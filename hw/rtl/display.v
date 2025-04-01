`timescale 1ns / 1ps

module display #(
    parameter IMAGE_WIDTH = 1280,
    parameter IMAGE_HEIGHT = 720,
    parameter START_WIDTH = 7,
    parameter START_HEIGHT = 0,
    parameter UNIT = "angle"
)
(
    input clk,
    input rstn,
    
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
    // angle, 0 - 360
    input wire [31:0] angle
    );
    
    localparam TOTAL_WIDTH = (UNIT == "current") ? 5 : (UNIT == "voltage") ? 3 : 4;
    
    wire [3:0] hundreds = angle[11:8];
    wire [3:0] tens = angle[7:4];
    wire [3:0] ones = angle[3:0];
    
//    wire [9:0] num1, num2;
    
//    assign num1 = angle - ((angle >> 7) * 100);
//    wire [3:0] hundreds = (angle * 205) >> 14;
    
//    assign num2 = num1 - ((num1 >>3) * 10);
//    wire [3:0] tens = (num1 * 205) >> 11;
    
//    wire ones = num2[3:0];
    

    
    // AXI logic
  wire          ready = m_axis_tready;
  wire          valid = s_axis_tvalid;
  wire [23:0]   data = s_axis_tdata;
  wire          last = s_axis_tlast;
  wire          user = s_axis_tuser;

  assign s_axis_tready = ready;
  assign m_axis_tvalid = valid;
  assign m_axis_tlast = last;
  assign m_axis_tuser = user;

  reg [$clog2(IMAGE_WIDTH)-1:0] pix_counter;
  reg [$clog2(IMAGE_HEIGHT)-1:0] line_number;

  wire pixel_valid;
  
  
  // pixel valid - write stuff to the screen
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
  
  
  
  // ROM for pixel data
  // Declare an 8x8 font ROM for digits 0-9.
// Each digit is stored as eight rows of 8 bits.
(* ram_type = "distributed" *) reg [7:0] font_rom [0:15][0:7];

initial begin
  // Digit 0
  font_rom[0][0] = 8'b00111100;
  font_rom[0][1] = 8'b01000010;
  font_rom[0][2] = 8'b01000010;
  font_rom[0][3] = 8'b01000010;
  font_rom[0][4] = 8'b01000010;
  font_rom[0][5] = 8'b01000010;
  font_rom[0][6] = 8'b01000010;
  font_rom[0][7] = 8'b00111100;
  
  // Digit 1
  font_rom[1][0] = 8'b00001000;
  font_rom[1][1] = 8'b00011000;
  font_rom[1][2] = 8'b00101000;
  font_rom[1][3] = 8'b00001000;
  font_rom[1][4] = 8'b00001000;
  font_rom[1][5] = 8'b00001000;
  font_rom[1][6] = 8'b00001000;
  font_rom[1][7] = 8'b00111100;
  
  // Digit 2
  font_rom[2][0] = 8'b00111100;
  font_rom[2][1] = 8'b01000010;
  font_rom[2][2] = 8'b00000010;
  font_rom[2][3] = 8'b00000100;
  font_rom[2][4] = 8'b00001000;
  font_rom[2][5] = 8'b00110000;
  font_rom[2][6] = 8'b01000000;
  font_rom[2][7] = 8'b01111110;
  
  // Digit 3
  font_rom[3][0] = 8'b00111100;
  font_rom[3][1] = 8'b01000010;
  font_rom[3][2] = 8'b00000010;
  font_rom[3][3] = 8'b00011100;
  font_rom[3][4] = 8'b00000010;
  font_rom[3][5] = 8'b00000010;
  font_rom[3][6] = 8'b01000010;
  font_rom[3][7] = 8'b00111100;
  
  // Digit 4
  font_rom[4][0] = 8'b00000100;
  font_rom[4][1] = 8'b00001100;
  font_rom[4][2] = 8'b00010100;
  font_rom[4][3] = 8'b00100100;
  font_rom[4][4] = 8'b01000100;
  font_rom[4][5] = 8'b01111110;
  font_rom[4][6] = 8'b00000100;
  font_rom[4][7] = 8'b00000100;
  
  // Digit 5
  font_rom[5][0] = 8'b01111110;
  font_rom[5][1] = 8'b01000000;
  font_rom[5][2] = 8'b01000000;
  font_rom[5][3] = 8'b01111100;
  font_rom[5][4] = 8'b00000010;
  font_rom[5][5] = 8'b00000010;
  font_rom[5][6] = 8'b01000010;
  font_rom[5][7] = 8'b00111100;
  
  // Digit 6
  font_rom[6][0] = 8'b00111100;
  font_rom[6][1] = 8'b01000010;
  font_rom[6][2] = 8'b01000000;
  font_rom[6][3] = 8'b01111100;
  font_rom[6][4] = 8'b01000010;
  font_rom[6][5] = 8'b01000010;
  font_rom[6][6] = 8'b01000010;
  font_rom[6][7] = 8'b00111100;
  
  // Digit 7
  font_rom[7][0] = 8'b01111110;
  font_rom[7][1] = 8'b00000010;
  font_rom[7][2] = 8'b00000100;
  font_rom[7][3] = 8'b00001000;
  font_rom[7][4] = 8'b00010000;
  font_rom[7][5] = 8'b00100000;
  font_rom[7][6] = 8'b00100000;
  font_rom[7][7] = 8'b00100000;
  
  // Digit 8
  font_rom[8][0] = 8'b00111100;
  font_rom[8][1] = 8'b01000010;
  font_rom[8][2] = 8'b01000010;
  font_rom[8][3] = 8'b00111100;
  font_rom[8][4] = 8'b01000010;
  font_rom[8][5] = 8'b01000010;
  font_rom[8][6] = 8'b01000010;
  font_rom[8][7] = 8'b00111100;
  
  // Digit 9
  font_rom[9][0] = 8'b00111100;
  font_rom[9][1] = 8'b01000010;
  font_rom[9][2] = 8'b01000010;
  font_rom[9][3] = 8'b01000010;
  font_rom[9][4] = 8'b00111110;
  font_rom[9][5] = 8'b00000010;
  font_rom[9][6] = 8'b01000010;
  font_rom[9][7] = 8'b00111100;
  
  // Degree symbol
  font_rom[10][0] = 8'b00110000;
  font_rom[10][1] = 8'b01001000;
  font_rom[10][2] = 8'b01001000;
  font_rom[10][3] = 8'b00110000;
  font_rom[10][4] = 8'b00000000;
  font_rom[10][5] = 8'b00000000;
  font_rom[10][6] = 8'b00000000;
  font_rom[10][7] = 8'b00000000;
    
  // Voltage symbol - V
  font_rom[11][0] = 8'b01000010;
  font_rom[11][1] = 8'b01000010;
  font_rom[11][2] = 8'b01000010;
  font_rom[11][3] = 8'b01000010;
  font_rom[11][4] = 8'b00100100;
  font_rom[11][5] = 8'b00100100;
  font_rom[11][6] = 8'b00100100;
  font_rom[11][7] = 8'b00011000;
  
  // Current symbol - m
  font_rom[12][0] = 8'b00000000;
  font_rom[12][1] = 8'b00000000;
  font_rom[12][2] = 8'b00000000;
  font_rom[12][3] = 8'b00000000;
  font_rom[12][4] = 8'b00110110;
  font_rom[12][5] = 8'b01001001;
  font_rom[12][6] = 8'b01001001;
  font_rom[12][7] = 8'b01001001;
  
  // Current symbol - A
  font_rom[13][0] = 8'b00011000;
  font_rom[13][1] = 8'b00100100;
  font_rom[13][2] = 8'b00100100;
  font_rom[13][3] = 8'b00100100;
  font_rom[13][4] = 8'b01111110;
  font_rom[13][5] = 8'b01000010;
  font_rom[13][6] = 8'b01000010;
  font_rom[13][7] = 8'b01000010;
  
  // Pause symbol - ||
  font_rom[14][0] = 8'b00000000;
  font_rom[14][1] = 8'b01100110;
  font_rom[14][2] = 8'b01100110;
  font_rom[14][3] = 8'b01100110;
  font_rom[14][4] = 8'b01100110;
  font_rom[14][5] = 8'b01100110;
  font_rom[14][6] = 8'b01100110;
  font_rom[14][7] = 8'b00000000;
  
  // Blank symbol
  font_rom[15][0] = 8'b00000000;
  font_rom[15][1] = 8'b00000000;
  font_rom[15][2] = 8'b00000000;
  font_rom[15][3] = 8'b00000000;
  font_rom[15][4] = 8'b00000000;
  font_rom[15][5] = 8'b00000000;
  font_rom[15][6] = 8'b00000000;
  font_rom[15][7] = 8'b00000000;
end
    
    wire [3:0] unit_1;
    wire [3:0] unit_2;
    
    generate
        if(UNIT == "angle") begin
            assign unit_1 = 4'd10;
            assign unit_2 = 4'd0;
        end else if(UNIT == "voltage") begin
            assign unit_1 = 4'd11;
            assign unit_2 = 4'd0;
        end else if (UNIT == "current") begin
            assign unit_1 = 4'd12;
            assign unit_2 = 4'd13;
        end else if (UNIT == "stopgo") begin
            assign unit_1 = angle == 0 ? 4'd14 : 4'd0;
            assign unit_2 = 4'd0;
        end
    endgenerate
    
    wire [3:0] digit;
    generate
        if (UNIT == "stopgo") begin
            assign digit = (pix_counter[10:7] == START_WIDTH && angle == 1) ? 4'd14 : 4'd15;
        end else if(UNIT == "voltage") begin
            assign digit = (pix_counter[10:7] == START_WIDTH) ? tens :
                             (pix_counter[10:7] == START_WIDTH+1) ? ones :
                             (pix_counter[10:7] == START_WIDTH+2) ? unit_1 : 
                             (pix_counter[10:7] == START_WIDTH+3) ? unit_2 : 4'd15;
        end else begin
            assign digit = (pix_counter[10:7] == START_WIDTH) ? hundreds :
                             (pix_counter[10:7] == START_WIDTH+1) ? tens :
                             (pix_counter[10:7] == START_WIDTH+2) ? ones : 
                             (pix_counter[10:7] == START_WIDTH+3) ? unit_1 : 
                             (pix_counter[10:7] == START_WIDTH+4) ? unit_2 : 4'd0;
        end
    endgenerate
                     
    wire start_write = (pix_counter[10:7] >= START_WIDTH && pix_counter[10:7] <= START_WIDTH+TOTAL_WIDTH-1) && (line_number >= START_HEIGHT && line_number < START_HEIGHT+128);
                     
    wire [2:0] rom_row = line_number[6:4];     // 3-bit row index (0-7)
    wire [2:0] rom_col = pix_counter[6:4];   // 3-bit col index (0-7)
    // Use [7 - rom_col] if you want the MSB of each row to be the leftmost pixel.
    wire pixel_on = start_write && font_rom[digit][rom_row][7 - rom_col];
    
    // Use pixel_on to determine whether to draw the pixel.
    // For example, drive the output pixel color as white if 'on', black otherwise:
    assign pixel_valid = valid && ready && pixel_on;
    
    assign m_axis_tdata = pixel_valid ? 'h00FF00 : data;
 
endmodule

