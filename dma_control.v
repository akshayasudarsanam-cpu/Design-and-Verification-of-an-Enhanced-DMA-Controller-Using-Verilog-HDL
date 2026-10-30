`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2026 18:14:05
// Design Name: 
// Module Name: dma_control
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

module dma_control (
    input [2:0] state,
    input DREQ,
    input HLDA,

    output reg HLD,
    output reg DACK,
    output reg EOP
);

    localparam IDLE     = 3'd0;
    localparam BUS_REQ  = 3'd1;
    localparam READ     = 3'd2;
    localparam STORE    = 3'd3;
    localparam WRITE    = 3'd4;
    localparam UPDATE   = 3'd5;
    localparam DONE     = 3'd6;

    always @(*) begin

        HLD  = 1'b0;
        DACK = 1'b0;
        EOP  = 1'b0;

        case (state)

            BUS_REQ: begin
                HLD = 1'b1;
            end

            READ,
            STORE,
            WRITE,
            UPDATE: begin
                HLD  = 1'b1;
                DACK = 1'b1;
            end

            DONE: begin
                EOP = 1'b1;
            end

            default: begin
                HLD  = 1'b0;
                DACK = 1'b0;
                EOP  = 1'b0;
            end

        endcase
    end

endmodule
