`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2025 10:45:08 PM
// Design Name: 
// Module Name: grayscale
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module grayscale(
    input clk,
    input resetn,
    
    // input axi-st video
    input [23:0] s_axis_video_tdata,
    input s_axis_video_tvalid,
    output s_axis_video_tready,
    input s_axis_video_tuser,
    input s_axis_video_tlast,
    
    // output axi-st video
    output [23:0] m_axis_video_tdata,
    output [7:0] m_axis_grayscale_canny,
    output m_axis_video_tvalid,
    input m_axis_video_tready,
    output m_axis_video_tuser,
    output m_axis_video_tlast
    );
    
    wire [15:0] red, green, blue, gray_tmp;
    reg [7:0] gray_out;
//    wire [7:0] gray_out;
    
    reg valid_ff, tuser_ff, tlast_ff;
    
    assign red = 'b01001100 * s_axis_video_tdata[23:16]; // 0.3 * R
    assign green = 'b10010111 * s_axis_video_tdata[7:0]; // 0.59 * G
    assign blue = 'b00011100 * s_axis_video_tdata[15:8]; // 0.11 * B
    assign gray_tmp = red + green + blue;

    assign s_axis_video_tready =  m_axis_video_tready;
    
    assign m_axis_video_tvalid = valid_ff;
    assign m_axis_video_tuser = tuser_ff;
    assign m_axis_video_tlast = tlast_ff;
//    assign m_axis_video_tvalid = s_axis_video_tvalid;
//    assign m_axis_video_tuser = s_axis_video_tuser;
//    assign m_axis_video_tlast = s_axis_video_tlast;
    
//    assign gray_out = gray_tmp[15:8] + (0 & gray_tmp[7]);
    
    always @(posedge clk) begin
        if (!resetn) begin
            valid_ff <= 0;
            tuser_ff <= 0;
            tlast_ff <= 0;
            gray_out <= 0;
        end else begin
            if (m_axis_video_tready) begin
                valid_ff <= s_axis_video_tvalid;
                tuser_ff <= s_axis_video_tuser;
                tlast_ff <= s_axis_video_tlast;
                
                // round off result
                gray_out <= gray_tmp[15:8] + (0 & gray_tmp[7]);
            end else begin
                valid_ff <= valid_ff;
                tuser_ff <= tuser_ff;
                tlast_ff <= tlast_ff;
                gray_out <= gray_out;
            end
        end
    end
    
    assign m_axis_video_tdata = {gray_out, gray_out, gray_out};
    assign m_axis_grayscale_canny = gray_out;
    
endmodule
