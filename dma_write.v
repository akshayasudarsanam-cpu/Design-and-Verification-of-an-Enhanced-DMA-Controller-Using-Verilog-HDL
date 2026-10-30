`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2026 18:17:23
// Design Name: 
// Module Name: dma_write
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

module dma_write (
    input [2:0] state,
    input [2:0] transfer_type,

    output reg MEMW,
    output reg IOW
);

    localparam WRITE = 3'd4;

    always @(*) begin

        MEMW = 1'b0;
        IOW  = 1'b0;

        if (state == WRITE) begin

            case (transfer_type)

                3'b100: begin
                    // Memory to Memory
                    MEMW = 1'b1;
                    IOW  = 1'b0;
                end

                3'b010: begin
                    // Memory to I/O
                    MEMW = 1'b0;
                    IOW  = 1'b1;
                end

                3'b001: begin
                    // I/O to Memory
                    MEMW = 1'b1;
                    IOW  = 1'b0;
                end

                default: begin
                    MEMW = 1'b0;
                    IOW  = 1'b0;
                end

            endcase

        end

    end

endmodule
