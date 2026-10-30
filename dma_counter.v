`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2026 18:16:07
// Design Name: 
// Module Name: dma_counter
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

module dma_counter (
    input CLK,
    input RST,

    input load,
    input decrement,

    input [15:0] Counter_in,

    output reg [15:0] Counter_out
);

    always @(posedge CLK) begin

        if (RST) begin
            Counter_out <= 16'h0000;
        end

        else begin

            if (load)
                Counter_out <= Counter_in;

            else if (decrement && Counter_out != 16'h0000)
                Counter_out <= Counter_out - 16'h0001;

        end

    end

endmodule
