

module pipeline_ff #(
   parameter COUNT_X_WIDTH = 32
  ,parameter N_STAGES = 1
) (
  input clk,
  input rst_n,

  input valid_in,
  input [COUNT_X_WIDTH-1:0] count_x_in,
  input start_in,

  output wire valid_out,
  output wire start_out,
  output wire [COUNT_X_WIDTH-1:0] count_x_out
);

  reg [COUNT_X_WIDTH-1:0] count_x_ff [0:N_STAGES-1];
  
  reg valid_ff [0:N_STAGES-1];
  reg start_ff [0:N_STAGES-1];
  integer i;

  always @(posedge clk) begin
    if (!rst_n) begin
      for (i = 0; i < N_STAGES; i = i + 1) begin
        count_x_ff[i] <= 0;
//        count_y_ff[i] <= 0;
        valid_ff[i] <= 0;
        start_ff[i] <= 0;
      end
    end else begin
      count_x_ff[0] <= count_x_in;
//      count_y_ff[0] <= count_y_in;
      valid_ff[0] <= valid_in;
      start_ff[0] <= start_in;
      for (i = 1; i < N_STAGES; i = i + 1) begin
        count_x_ff[i] <= count_x_ff[i-1];
//        count_y_ff[i] <= count_y_ff[i-1];
        valid_ff[i] <= valid_ff[i-1];
        start_ff[i] <= start_ff[i-1];
      end
    end
  end

  assign count_x_out = count_x_ff[N_STAGES-1];
//  assign count_y_out = count_y_ff[N_STAGES-1];
  assign valid_out = valid_ff[N_STAGES-1];
  assign start_out = start_ff[N_STAGES-1];

endmodule

module hue_transform #(
  parameter COUNT_X_WIDTH = 32
) (
   input                             clk
  ,input                             rst_n

  ,input [23:0]                      pixel_data
  ,input                             pixel_valid
  ,input                             start
  ,input [COUNT_X_WIDTH-1:0]         pixel_x_count

  ,output [8:0]                      hue_red_val // 0 to 360 degrees
  ,output [7:0]                      saturation_red_val
  ,output [7:0]                      value_red_val
  ,output                            is_red_valid
  ,output                            start_o
  ,output [COUNT_X_WIDTH-1:0]        pixel_x_count_o
);

  // RGB pixel data
  wire [7:0] red, green, blue;
  assign {red, green, blue} = pixel_data;
  wire [23:0] pixel_data_ff; // delayed pixel data for hue calculation
  
  // precalculated 1/chroma values are in the table 
  wire   [32:0]          chroma_inverse; // UQ1.32 format
  wire   [32:0]          cmax_inverse; // UQ1.32 format

  
  chroma_calc chroma_calc_inst (
    .clk                  (clk),
    .rst_n                (rst_n),
    .pixel_data_i         (pixel_data),
    .pixel_data_o         (pixel_data_ff),
    .chroma_inverse_o     (chroma_inverse),
    .cmax_inverse_o       (cmax_inverse)
  );

  // 2 cycles latency
  hsv_calc hsv_calc_inst (
    .clk                  (clk),
    .rst_n                (rst_n),
    .pixel_data_i         (pixel_data_ff),
    .chroma_inverse_i     (chroma_inverse),
    .cmax_inverse_i       (cmax_inverse),
    .hue_deg_o            (hue_red_val),
    .saturation_o         (saturation_red_val),
    .value_o              (value_red_val)
  );

  pipeline_ff #(
    .COUNT_X_WIDTH(COUNT_X_WIDTH), 
    .N_STAGES(4)
  ) pipeline_ff_inst (
    .clk                  (clk),
    .rst_n                (rst_n),
    .valid_in             (pixel_valid),
    .start_in             (start),
    .count_x_in           (pixel_x_count),
    .valid_out            (is_red_valid),
    .start_out            (start_o),
    .count_x_out          (pixel_x_count_o)
  );

endmodule


module chroma_calc (
  input wire clk,
  input wire rst_n,

  input wire [23:0] pixel_data_i,
  output reg [23:0] pixel_data_o,
  output wire [32:0] chroma_inverse_o,
  output wire [32:0] cmax_inverse_o
);
  wire [7:0] chroma;
  wire [7:0] red, green, blue;
  assign {red, green, blue} = pixel_data_i;

  wire within_red_hue = red > green && red > blue;
  assign chroma = within_red_hue ? red - ((green < blue) ? green : blue) : 0;
  reg [23:0] pixel_data_ff;

  always @(posedge clk) begin
    if (!rst_n) begin
      pixel_data_o <= 0;
      pixel_data_ff <= 0;
    end else begin
      pixel_data_ff <= pixel_data_i;
      pixel_data_o <= pixel_data_ff;
    end
  end

  inverse_table chroma_inverse_inst (
    .clk(clk),
    .rst_n(rst_n),
    .denominator(chroma),
    .inverse(chroma_inverse_o)
  );

  inverse_table cmax_inverse_inst (
    .clk(clk),
    .rst_n(rst_n),
    .denominator(within_red_hue ? red : 0),
    .inverse(cmax_inverse_o)
  );
endmodule

module hsv_calc (
  input      clk,
  input      rst_n,
  input      [23:0] pixel_data_i,
  input      [32:0] chroma_inverse_i,
  input      [32:0] cmax_inverse_i,
  output     [8:0]  hue_deg_o,
  output     [7:0]  saturation_o,
  output reg [7:0]  value_o
);

  wire [7:0] red, green, blue;
  wire [7:0] red_ff, green_ff, blue_ff;
  reg [23:0] pixel_data_ff;
  assign {red, green, blue} = pixel_data_i;
  assign {red_ff, green_ff, blue_ff} = pixel_data_ff;
  wire within_red_hue = red > green && red > blue;

  reg signed [42:0] hue; // Q9.32 format
  reg  [39:0] saturation, saturation_ff; // UQ8.32 format
  reg  [39:0] value; // UQ8.32 format
  reg  [47:0] hue_deg; // Q16.32 format

  always @(posedge clk) begin
    if (!rst_n) begin
      hue_deg <= 0;
      hue <= 0;
    end else begin
      hue <= (green - blue) * chroma_inverse_i; // Q10.32 format
      hue_deg <= (hue == 0) ? 0 : (hue + (green_ff < blue_ff ? (6<<32) : 0)) * 60; // Q16.32 format

      // we only care about red so if not in the red range we set saturation and value to 0
      saturation <= (red - ((green < blue) ? green : blue)) * cmax_inverse_i; // UQ8.32 format
      saturation_ff <= saturation * 100; // UQ8.32 format
      value <= within_red_hue ? red * 'h64646464 : 0; // UQ8.32 format of red * 100/255
      value_o <= value[39:32] + value[31]; // Q8.32 format
    end
    pixel_data_ff <= pixel_data_i;
  end
  // truncate with rounding up
  assign saturation_o = saturation_ff[38:32] + saturation_ff[31]; // UQ7.0 format
  assign hue_deg_o = hue_deg[40:32] + hue_deg[31]; // Q16.32 format to Q9.0 format

endmodule