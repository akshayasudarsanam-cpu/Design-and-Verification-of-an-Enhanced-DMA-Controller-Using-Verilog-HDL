`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2026 18:15:22
// Design Name: 
// Module Name: dma_address
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


module dma_address (
    input [2:0] state,

    input [15:0] S_addr,
    input [15:0] D_addr,

    output reg [15:0] Addrbus
);

    localparam IDLE    = 3'd0;
    localparam BUS_REQ = 3'd1;
    localparam READ    = 3'd2;
    localparam STORE   = 3'd3;
    localparam WRITE   = 3'd4;
    localparam UPDATE  = 3'd5;
    localparam DONE    = 3'd6;

    always @(*) begin

        case (state)

            // Source address during READ and STORE
            READ,
            STORE:
                Addrbus = S_addr;

            // Destination address during WRITE
            WRITE:
                Addrbus = D_addr;

            default:
                Addrbus = 16'h0000;

        endcase

    end

endmodule
