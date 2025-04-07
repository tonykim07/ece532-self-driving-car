

module cropping #(
  parameter IMAGE_WIDTH = 1280, // Image width
  parameter IMAGE_HEIGHT = 720 // Image height
) (
  input wire clk, // Clock
  input wire rstn, // Reset


  // Slave AXI stream interface
  input wire [23:0] s_axis_tdata, // Data
  input wire s_axis_tvalid, // Valid
  output wire s_axis_tready, // Ready
  input wire s_axis_tlast, // Last
  input wire s_axis_tuser, // User

  output wire [23:0] m_axis_tdata, // Data
  output wire m_axis_tvalid, // Valid
  input wire m_axis_tready, // Ready
  output wire m_axis_tlast, // Last
  output wire m_axis_tuser, // User

  // to microblaze
  input wire [31:0]        USER_IMAGE_WIDTH,
  input wire [31:0]        USER_IMAGE_HEIGHT,
  input wire [31:0]        USER_WIDTH_START,
  input wire [31:0]        USER_HEIGHT_START,
  
  input [8:0]              USER_HUE,
  input [7:0]              USER_SATURATION,
  input [7:0]              USER_VALUE,

  output [23:0]            average,
  output                   line_detected
);

  wire          ready = m_axis_tready;
  wire          valid = s_axis_tvalid;
  wire [23:0]   data = s_axis_tdata;
  wire          last = s_axis_tlast;
  wire          user = s_axis_tuser;

  assign s_axis_tready = ready;
  assign m_axis_tvalid = valid;
//  assign m_axis_tdata = data;
  assign m_axis_tlast = last;
  assign m_axis_tuser = user;

  reg [$clog2(IMAGE_WIDTH)-1:0] pix_counter;
  reg [$clog2(IMAGE_HEIGHT)-1:0] line_number;

  wire pixel_valid;
  wire inside_cropped_box;

  always @(posedge clk) begin
    if (!rstn) begin // reset ip to idle state
      pix_counter <= 0;
      line_number <= 0;
    end else if (ready && valid && user) begin // reset frame and line counter to 1
      pix_counter <= 1;
      line_number <= 0;
    end else begin
      if (ready && valid) begin
        if (pix_counter == IMAGE_WIDTH-1 || last) begin
          pix_counter <= 0;
          line_number <= line_number + 1;
        end else begin
          pix_counter <= pix_counter + 1;
        end
      end
    end
  end

  assign pixel_valid = (pix_counter >= USER_WIDTH_START && 
      line_number >= USER_HEIGHT_START &&
      pix_counter < USER_WIDTH_START + USER_IMAGE_WIDTH &&
      line_number < USER_HEIGHT_START + USER_IMAGE_HEIGHT) ? valid && ready : 0;
      
  assign inside_cropped_box = (pix_counter >= USER_WIDTH_START + 5 && 
      line_number >= USER_HEIGHT_START + 5 &&
      pix_counter < USER_WIDTH_START + USER_IMAGE_WIDTH - 5 &&
      line_number < USER_HEIGHT_START + USER_IMAGE_HEIGHT - 5);

  assign m_axis_tdata = (pixel_valid && !inside_cropped_box)? 'hebe834 : data;

  lane_following #(
    .IMAGE_WIDTH(IMAGE_WIDTH),
    .IMAGE_HEIGHT(IMAGE_HEIGHT)
  ) lane_following_inst (
    .clk(clk),
    .rstn(rstn),
    .start_in(ready && valid && user),
    .pixel_valid_in(pixel_valid),
    .pixel_data(data),
    .average(average),
    .line_detected(line_detected),
    .USER_IMAGE_WIDTH(USER_IMAGE_WIDTH),
    .USER_IMAGE_HEIGHT(USER_IMAGE_HEIGHT),
    .USER_HUE(USER_HUE),
    .USER_SATURATION(USER_SATURATION),
    .USER_VALUE(USER_VALUE)
  );


endmodule