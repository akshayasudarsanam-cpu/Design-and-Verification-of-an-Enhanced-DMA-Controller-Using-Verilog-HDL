`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2026 18:18:11
// Design Name: 
// Module Name: dma_top_tb
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

module dma_top_tb;

    //====================================================
    // Inputs
    //====================================================

    reg CLK;
    reg RST;

    reg DREQ;
    reg HLDA;

    reg REGW;
    reg [1:0] REGSEL;
    reg [15:0] Setup;

    reg [7:0] Data_in;


    //====================================================
    // Outputs
    //====================================================

    wire HLD;
    wire DACK;

    wire MEMR;
    wire MEMW;

    wire IOR;
    wire IOW;

    wire EOP;

    wire [15:0] Addrbus;
    wire [7:0] Data_out;

    // Add-on outputs
    wire DMA_BUSY;
    wire DMA_INTERRUPT;
    wire BURST_DONE;
    wire ERROR_FLAG;


    //====================================================
    // DUT
    //====================================================

    dma_top DUT (
        .CLK(CLK),
        .RST(RST),

        .DREQ(DREQ),
        .HLDA(HLDA),

        .REGW(REGW),
        .REGSEL(REGSEL),
        .Setup(Setup),

        .Data_in(Data_in),

        .HLD(HLD),
        .DACK(DACK),

        .MEMR(MEMR),
        .MEMW(MEMW),

        .IOR(IOR),
        .IOW(IOW),

        .EOP(EOP),

        .Addrbus(Addrbus),
        .Data_out(Data_out),

        .DMA_BUSY(DMA_BUSY),
        .DMA_INTERRUPT(DMA_INTERRUPT),
        .BURST_DONE(BURST_DONE),
        .ERROR_FLAG(ERROR_FLAG)
    );


    //====================================================
    // CLOCK
    //====================================================

    initial begin
        CLK = 1'b0;
        forever #5 CLK = ~CLK;
    end


    //====================================================
    // SOURCE DATA
    //
    // Transfer 1 = 11
    // Transfer 2 = 22
    // Transfer 3 = 33
    //
    // The data is kept stable instead of returning to zero.
    //====================================================

    always @(negedge CLK) begin

        if (RST) begin
            Data_in <= 8'd0;
        end
        else begin

            case (DUT.runtime_counter)

                16'd3:
                    Data_in <= 8'd11;

                16'd2:
                    Data_in <= 8'd22;

                16'd1:
                    Data_in <= 8'd33;

                default:
                    Data_in <= Data_in;

            endcase

        end
    end


    //====================================================
    // MAIN TEST
    //====================================================

    initial begin

        // Initial conditions
        RST    = 1'b1;
        DREQ   = 1'b0;
        HLDA   = 1'b0;

        REGW   = 1'b0;
        REGSEL = 2'b00;
        Setup  = 16'h0000;

        Data_in = 8'd0;


        //================================================
        // RESET
        //================================================

        #20;
        RST = 1'b0;


        //================================================
        // CONTROL REGISTER
        //
        // A0:
        // Bit 7 = 1 -> increment address
        // Bits 5:3 = 100 -> memory-to-memory
        //================================================

        @(negedge CLK);

        REGW   = 1'b1;
        REGSEL = 2'b00;
        Setup  = 16'h00A0;

        @(negedge CLK);

        REGW = 1'b0;


        //================================================
        // COUNTER = 3
        //================================================

        @(negedge CLK);

        REGW   = 1'b1;
        REGSEL = 2'b01;
        Setup  = 16'd3;

        @(negedge CLK);

        REGW = 1'b0;


        //================================================
        // SOURCE ADDRESS = 50
        //================================================

        @(negedge CLK);

        REGW   = 1'b1;
        REGSEL = 2'b10;
        Setup  = 16'd50;

        @(negedge CLK);

        REGW = 1'b0;


        //================================================
        // DESTINATION ADDRESS = 50
        //================================================

        @(negedge CLK);

        REGW   = 1'b1;
        REGSEL = 2'b11;
        Setup  = 16'd50;

        @(negedge CLK);

        REGW = 1'b0;


        //================================================
        // Clear setup bus after programming
        //================================================

        @(negedge CLK);

        Setup = 16'h0000;


        //================================================
        // START DMA
        //================================================

        @(negedge CLK);

        DREQ = 1'b1;

        @(negedge CLK);

        HLDA = 1'b1;


        //================================================
        // WAIT FOR DMA TO FINISH
        //================================================
        //
        // EOP becomes 1 when the DMA reaches DONE.
        // This prevents a second unwanted transfer.
        //================================================

        wait (EOP == 1'b1);


        //================================================
        // STOP DMA REQUEST
        //================================================

        @(negedge CLK);

        DREQ = 1'b0;
        HLDA = 1'b0;


        //================================================
        // Allow final waveform to be visible
        //================================================

        #50;

        $finish;

    end


    //====================================================
    // MONITOR
    //====================================================

    initial begin

        $monitor(
            "Time=%0t | State=%0d | Addr=%0d | Data_in=%0d | Data_out=%0d | Counter=%0d | HLD=%b | DACK=%b | EOP=%b | BUSY=%b | INT=%b | BURST_DONE=%b | ERROR=%b",
            $time,
            DUT.state,
            Addrbus,
            Data_in,
            Data_out,
            DUT.runtime_counter,
            HLD,
            DACK,
            EOP,
            DMA_BUSY,
            DMA_INTERRUPT,
            BURST_DONE,
            ERROR_FLAG
        );

    end

endmodule

