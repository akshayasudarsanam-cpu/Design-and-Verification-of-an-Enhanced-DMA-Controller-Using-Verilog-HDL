`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2026 18:16:49
// Design Name: 
// Module Name: dma_read
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
`timescale 1ns / 1ps

module dma_read (
    input [2:0] state,
    input [2:0] transfer_type,

    output reg MEMR,
    output reg IOR
);

    localparam READ = 3'd2;

    always @(*) begin

        MEMR = 1'b0;
        IOR  = 1'b0;

        if (state == READ) begin

            case (transfer_type)

                3'b100: begin
                    // Memory to Memory
                    MEMR = 1'b1;
                    IOR  = 1'b0;
                end

                3'b010: begin
                    // Memory to I/O
                    MEMR = 1'b1;
                    IOR  = 1'b0;
                end

                3'b001: begin
                    // I/O to Memory
                    MEMR = 1'b0;
                    IOR  = 1'b1;
                end

                default: begin
                    MEMR = 1'b0;
                    IOR  = 1'b0;
                end

            endcase

        end

    end

endmodule
