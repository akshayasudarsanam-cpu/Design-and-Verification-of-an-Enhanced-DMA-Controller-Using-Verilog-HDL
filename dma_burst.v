`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.09.2026 18:30:17
// Design Name: 
// Module Name: dma_burst
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
module dma_burst #(
    parameter BURST_LENGTH = 3
)(
    input CLK,
    input RST,

    input burst_start,
    input transfer_done,

    output reg burst_active = 1'b0,
    output reg burst_done   = 1'b0
);

    reg [2:0] burst_count;

    always @(posedge CLK or posedge RST) begin

        if (RST) begin
            burst_count  <= 3'd0;
            burst_active <= 1'b0;
            burst_done   <= 1'b0;
        end

        else begin

            burst_done <= 1'b0;

            // Start burst
            if (burst_start && !burst_active) begin
                burst_active <= 1'b1;
                burst_count  <= 3'd0;
            end

            // Count completed transfers
            else if (burst_active && transfer_done) begin

                if (burst_count == BURST_LENGTH - 1) begin
                    burst_active <= 1'b0;
                    burst_done   <= 1'b1;
                    burst_count  <= 3'd0;
                end

                else begin
                    burst_count <= burst_count + 1'b1;
                end

            end

        end
    end

endmodule