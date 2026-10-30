`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.09.2026 18:31:04
// Design Name: 
// Module Name: dma_interrupt
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
module dma_interrupt (
    input CLK,
    input RST,

    input transfer_active,
    input transfer_done,
    input error_flag,

    output reg busy = 1'b0,
    output reg interrupt =1'b0
);

    always @(posedge CLK) begin

        if (RST) begin
            busy      <= 1'b0;
            interrupt <= 1'b0;
        end

        else begin

            // Show that DMA is currently active
            busy <= transfer_active;

            // Generate interrupt when transfer completes
            // or when an error occurs
            if (transfer_done || error_flag)
                interrupt <= 1'b1;
            else
                interrupt <= 1'b0;

        end

    end

endmodule
