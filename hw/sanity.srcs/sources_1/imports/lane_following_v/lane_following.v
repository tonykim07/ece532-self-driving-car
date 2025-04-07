

module lane_following #(
  parameter IMAGE_WIDTH = 1280, // Image width
  parameter IMAGE_HEIGHT = 720 // Image height
) (
  input wire clk, // Clock
  input wire rstn, // Reset

  input wire start_in,
  input pixel_valid_in,
  input [23:0] pixel_data,
  output [31:0] average,
  output reg line_detected,

  input [$clog2(IMAGE_WIDTH)-1:0]     USER_IMAGE_WIDTH,
  input [$clog2(IMAGE_HEIGHT)-1:0]    USER_IMAGE_HEIGHT,
  input [8:0]                         USER_HUE,
  input [7:0]                         USER_SATURATION,
  input [7:0]                         USER_VALUE
);

  reg [23:0]                        avg_start;
  reg [31:0]                        pix_x_count_in;
  reg [$clog2(IMAGE_HEIGHT)-1:0]    pix_y_count;
  
  
  wire [31:0]                        pix_x_count;
  wire start, pixel_valid;

  wire [8:0]                         hue;
  wire [7:0]                         saturation, value;

  assign average = avg_start >> 8;

  always @(posedge clk) begin
    if (!rstn || start_in) begin
      pix_x_count_in <= 0;
    end else begin
      if (pixel_valid_in) begin
        if (pix_x_count_in == USER_IMAGE_WIDTH-1) begin
          pix_x_count_in <= 0;
        end else begin
          pix_x_count_in <= pix_x_count_in + 1;
        end
      end
    end
  end

  localparam WAIT_LINE_START = 0, WAIT_LINE_END = 1;
  reg [1:0] state;
  
  hue_transform hue_transform_inst(
    .clk(clk),
    .rst_n(rstn),
    
    .pixel_data(pixel_data),
    .pixel_valid(pixel_valid_in),
    .start(start_in),
    .pixel_x_count(pix_x_count_in),
    
    .hue_red_val(hue),
    .saturation_red_val(saturation),
    .value_red_val(value),
    .is_red_valid(pixel_valid),
    .start_o(start),
    .pixel_x_count_o(pix_x_count)
  );
  
//  rgb_2_hsv rgb_convert_hsv_inst (
//    .pixel_data(pixel_data),
//    .hue(hue)
//  );

  always @(posedge clk) begin
    if (!rstn) begin
      pix_y_count <= 0;
      state <= 0;
      avg_start <= 0;
      line_detected <= 0;
    end else begin
      if (start) begin
        pix_y_count <= 0;
        state <= 0;
      end
      case (state)
        WAIT_LINE_START: begin
          if (pixel_valid) begin
            if (((hue >= 0 && hue <= USER_HUE) || (hue >= 360-USER_HUE)) && saturation >= USER_SATURATION && value >= USER_VALUE) begin
                avg_start <= (((avg_start * 15) + (pix_x_count << 8)) >>> 4);
                state <= WAIT_LINE_END;
                line_detected <= 1;
            end else if (pix_x_count == USER_IMAGE_WIDTH-1) begin
                pix_y_count <= (pix_y_count == USER_IMAGE_HEIGHT-1) ? 0 : pix_y_count + 1;
                line_detected <= 0;
            end
          end
//          if (pixel_valid && () begin
//            if (pix_y_count == 0) begin
//              avg_start <= pix_x_count;
//            end else begin
//              avg_start <= avg_start * 0.95 + pix_x_count * 0.05;
//            end
            // avg_start is in q_something.8
//            avg_start <= ((((avg_start * (15<<4))>>4) + pix_x_count<<4) << 4) / (16<<4);
//            avg_start <= (((avg_start * 15) + (pix_x_count << 8)) >>> 4);
//            state <= WAIT_LINE_END;
//            line_detected <= 1;
//          end else if (pix_x_count == USER_IMAGE_WIDTH-1) begin
            // ignore
//            avg_start <= (((avg_start * 15) + (USER_IMAGE_WIDTH+10 << 8)) >>> 4);
//            if (pixel_valid) begin
//                line_detected <= 0;
//            end
            
//          end
        end
        WAIT_LINE_END: begin
          line_detected <= 1;
          if (pix_x_count == USER_IMAGE_WIDTH-1) begin
            state <= WAIT_LINE_START;
            pix_y_count <= (pix_y_count == USER_IMAGE_HEIGHT-1) ? 0 : pix_y_count + 1;
          end
        end
        default: begin
          state <= WAIT_LINE_START;
        end
      endcase
    end
  end

endmodule
