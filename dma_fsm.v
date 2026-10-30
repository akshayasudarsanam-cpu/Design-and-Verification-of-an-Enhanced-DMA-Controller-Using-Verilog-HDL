`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2026 18:13:41
// Design Name: 
// Module Name: dma_fsm
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


module dma_fsm (
    input CLK,
    input RST,

    input DREQ,
    input HLDA,
    input [15:0] Counter,

    output reg [2:0] state = 3'd0,

    output reg load_counter,
    output reg update_counter,
    output reg update_source,
    output reg update_destination
);

    localparam IDLE     = 3'd0;
    localparam BUS_REQ  = 3'd1;
    localparam READ     = 3'd2;
    localparam STORE    = 3'd3;
    localparam WRITE    = 3'd4;
    localparam UPDATE   = 3'd5;
    localparam DONE     = 3'd6;

    reg [2:0] next_state;

    always @(posedge CLK) begin
        if (RST)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin

        next_state = state;

        case (state)

            IDLE: begin
                if (DREQ)
                    next_state = BUS_REQ;
            end

            BUS_REQ: begin
                if (HLDA)
                    next_state = READ;
            end

            READ:
                next_state = STORE;

            STORE:
                next_state = WRITE;

            WRITE:
                next_state = UPDATE;

            UPDATE: begin
                if (Counter == 16'h0001)
                    next_state = DONE;
                else
                    next_state = READ;
            end

            DONE:
                next_state = IDLE;

            default:
                next_state = IDLE;

        endcase
    end

    always @(*) begin

        load_counter      = 1'b0;
        update_counter    = 1'b0;
        update_source     = 1'b0;
        update_destination = 1'b0;

        // Load runtime counter when bus is granted
        if ((state == BUS_REQ) && HLDA)
            load_counter = 1'b1;

        // Update after every completed transfer
        if (state == UPDATE) begin
            update_counter     = 1'b1;
            update_source      = 1'b1;
            update_destination = 1'b1;
        end

    end

endmodule
