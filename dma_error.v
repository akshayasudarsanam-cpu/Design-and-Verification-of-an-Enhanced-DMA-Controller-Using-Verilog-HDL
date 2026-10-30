`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.09.2026 18:30:36
// Design Name: 
// Module Name: dma_error
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
module dma_error #(
    parameter TIMEOUT_LIMIT = 4
)(
    input CLK,
    input RST,

    input error_enable,
    input transfer_active,

    output reg error_flag = 1'b0,
    output reg recovery = 1'b0
);

    reg [2:0] timeout_count = 3'd0;

    always @(posedge CLK) begin

        if (RST) begin
            timeout_count <= 3'd0;
            error_flag    <= 1'b0;
            recovery      <= 1'b0;
        end

        else begin

            recovery <= 1'b0;

            // Count while transfer is active
            if (error_enable && transfer_active) begin

                if (timeout_count < TIMEOUT_LIMIT)
                    timeout_count <= timeout_count + 1'b1;

                // Timeout reached
                if (timeout_count == TIMEOUT_LIMIT - 1) begin
                    error_flag <= 1'b1;
                    recovery   <= 1'b1;
                end

            end

            else begin
                timeout_count <= 3'd0;
                error_flag    <= 1'b0;
            end

        end

    end

endmodule
