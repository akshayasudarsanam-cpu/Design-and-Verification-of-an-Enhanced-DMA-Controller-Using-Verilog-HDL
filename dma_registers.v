`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2026 18:12:27
// Design Name: 
// Module Name: dma_registers
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

module dma_registers (
    input CLK,
    input RST,

    input REGW,
    input [1:0] REGSEL,
    input [15:0] Setup,

    input update_source,
    input update_destination,

    input buffer_write,
    input [7:0] Data_in,

    output reg [7:0] ctrl_reg,
    output reg [15:0] Counter,
    output reg [15:0] S_addr,
    output reg [15:0] D_addr,
    output reg [7:0] data_buff
);

    always @(posedge CLK) begin

        if (RST) begin
            ctrl_reg  <= 8'h00;
            Counter   <= 16'h0000;
            S_addr    <= 16'h0000;
            D_addr    <= 16'h0000;
            data_buff <= 8'h00;
        end

        else begin

            // CPU programs DMA registers
            if (REGW) begin
                case (REGSEL)

                    2'b00:
                        ctrl_reg <= Setup[7:0];

                    2'b01:
                        Counter <= Setup;

                    2'b10:
                        S_addr <= Setup;

                    2'b11:
                        D_addr <= Setup;

                    default: begin
                    end

                endcase
            end

            // Update source address
            if (update_source) begin
                if (ctrl_reg[7])
                    S_addr <= S_addr + 16'h0001;
                else
                    S_addr <= S_addr - 16'h0001;
            end

            // Update destination address
            if (update_destination) begin
                if (ctrl_reg[7])
                    D_addr <= D_addr + 16'h0001;
                else
                    D_addr <= D_addr - 16'h0001;
            end

            // Store data temporarily
            if (buffer_write)
                data_buff <= Data_in;

        end
    end

endmodule
