`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.09.2026 18:36:05
// Design Name: 
// Module Name: dma_fifo
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
module dma_fifo #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 4
)(
    input CLK,
    input RST,

    input write_enable,
    input read_enable,

    input [DATA_WIDTH-1:0] Data_in,
    output reg [DATA_WIDTH-1:0] Data_out,

    output full,
    output empty
);

    reg [DATA_WIDTH-1:0] fifo_memory [0:FIFO_DEPTH-1];

    reg [2:0] write_pointer;
    reg [2:0] read_pointer;
    reg [2:0] count;

    integer i;

    assign full  = (count == FIFO_DEPTH);
    assign empty = (count == 0);

    always @(posedge CLK or posedge RST) begin

        if (RST) begin

            write_pointer <= 3'd0;
            read_pointer  <= 3'd0;
            count         <= 3'd0;
            Data_out      <= 8'h00;

            // Clear FIFO memory during reset
            for (i = 0; i < FIFO_DEPTH; i = i + 1)
                fifo_memory[i] <= 8'h00;

        end

        else begin

            // Write data into FIFO
            if (write_enable && !full) begin
                fifo_memory[write_pointer] <= Data_in;
                write_pointer <= write_pointer + 1'b1;
            end

            // Read data from FIFO
            if (read_enable && !empty) begin
                Data_out <= fifo_memory[read_pointer];
                read_pointer <= read_pointer + 1'b1;
            end

            // Update FIFO count
            case ({write_enable && !full, read_enable && !empty})

                2'b10:
                    count <= count + 1'b1;

                2'b01:
                    count <= count - 1'b1;

                default:
                    count <= count;

            endcase

        end

    end

endmodule