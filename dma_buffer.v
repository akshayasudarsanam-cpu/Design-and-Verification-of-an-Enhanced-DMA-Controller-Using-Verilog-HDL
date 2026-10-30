`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2026 18:16:28
// Design Name: 
// Module Name: dma_buffer
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

module dma_buffer (
    input CLK,
    input RST,

    input write_enable,
    input [7:0] Data_in,

    output reg [7:0] Data_out = 8'h00
);

    always @(posedge CLK) begin

        if (RST)
            Data_out <= 8'h00;

        else if (write_enable)
            Data_out <= Data_in;

    end

endmodule
