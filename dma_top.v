`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2026 18:11:51
// Design Name: 
// Module Name: dma_top
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

module dma_top (
    input CLK,
    input RST,

    // DMA request and bus handshake
    input DREQ,
    input HLDA,

    // CPU programming interface
    input REGW,
    input [1:0] REGSEL,
    input [15:0] Setup,

    // Data from source memory / I/O
    input [7:0] Data_in,

    // DMA control outputs
    output HLD,
    output DACK,

    output MEMR,
    output MEMW,

    output IOR,
    output IOW,

    output EOP,

    // Address and data
    output [15:0] Addrbus,
    output [7:0] Data_out,

    // Add-on module outputs
    output DMA_BUSY,
    output DMA_INTERRUPT,
    output BURST_DONE,
    output ERROR_FLAG
);

    //====================================================
    // Original DMA internal signals
    //====================================================

    wire [7:0] ctrl_reg;

    wire [15:0] Counter;
    wire [15:0] S_addr;
    wire [15:0] D_addr;

    wire [15:0] runtime_counter;

    wire [2:0] state;

    wire load_counter;
    wire update_counter;

    wire update_source;
    wire update_destination;

    wire [7:0] buffer_data;

    wire [2:0] transfer_type;


    //====================================================
    // Add-on internal signals
    //====================================================

    wire [7:0] fifo_data_out;
    wire fifo_full;
    wire fifo_empty;

    wire burst_active;

    wire recovery;

    wire transfer_done;


    //====================================================
    // Transfer type
    //====================================================

    assign transfer_type = ctrl_reg[5:3];


    //====================================================
    // DMA REGISTER MODULE
    //====================================================

    dma_registers REGISTERS (
        .CLK(CLK),
        .RST(RST),
        .REGW(REGW),
        .REGSEL(REGSEL),
        .Setup(Setup),

        .update_source(update_source),
        .update_destination(update_destination),

        .buffer_write(1'b0),
        .Data_in(Data_in),

        .ctrl_reg(ctrl_reg),
        .Counter(Counter),
        .S_addr(S_addr),
        .D_addr(D_addr),

        .data_buff()
    );


    //====================================================
    // DMA FSM
    //====================================================

    dma_fsm FSM (
        .CLK(CLK),
        .RST(RST),
        .DREQ(DREQ),
        .HLDA(HLDA),

        .Counter(runtime_counter),

        .state(state),

        .load_counter(load_counter),
        .update_counter(update_counter),

        .update_source(update_source),
        .update_destination(update_destination)
    );


    //====================================================
    // DMA COUNTER
    //====================================================

    dma_counter COUNTER (
        .CLK(CLK),
        .RST(RST),

        .load(load_counter),
        .decrement(update_counter),

        .Counter_in(Counter),
        .Counter_out(runtime_counter)
    );


    //====================================================
    // DMA CONTROL
    //====================================================

    dma_control CONTROL (
        .state(state),
        .DREQ(DREQ),
        .HLDA(HLDA),

        .HLD(HLD),
        .DACK(DACK),
        .EOP(EOP)
    );


    //====================================================
    // DMA ADDRESS
    //====================================================

    dma_address ADDRESS (
        .state(state),
        .S_addr(S_addr),
        .D_addr(D_addr),

        .Addrbus(Addrbus)
    );


    //====================================================
    // DMA BUFFER
    //
    // This remains the main DMA data path.
    // Data_out comes from this buffer.
    //====================================================

    dma_buffer BUFFER (
        .CLK(CLK),
        .RST(RST),

        .write_enable(state == 3'd3),

        .Data_in(Data_in),
        .Data_out(buffer_data)
    );


    //====================================================
    // DMA READ CONTROL
    //====================================================

    dma_read READ_CONTROL (
        .state(state),
        .transfer_type(transfer_type),

        .MEMR(MEMR),
        .IOR(IOR)
    );


    //====================================================
    // DMA WRITE CONTROL
    //====================================================

    dma_write WRITE_CONTROL (
        .state(state),
        .transfer_type(transfer_type),

        .MEMW(MEMW),
        .IOW(IOW)
    );


    //====================================================
    // FIFO ADD-ON
    //
    // FIFO receives the actual Data_in.
    // It does NOT replace the original DMA buffer.
    //====================================================

    dma_fifo #(
        .DATA_WIDTH(8),
        .FIFO_DEPTH(4)
    ) FIFO (
        .CLK(CLK),
        .RST(RST),

        .write_enable(state == 3'd3),
        .read_enable(state == 3'd4),

        .Data_in(Data_in),
        .Data_out(fifo_data_out),

        .full(fifo_full),
        .empty(fifo_empty)
    );


    //====================================================
    // BURST ADD-ON
    //
    // Three successful write operations make one burst.
    //====================================================

    assign transfer_done = (state == 3'd4);

    dma_burst #(
        .BURST_LENGTH(3)
    ) BURST (
        .CLK(CLK),
        .RST(RST),

        .burst_start(state == 3'd2),
        .transfer_done(transfer_done),

        .burst_active(burst_active),
        .burst_done(BURST_DONE)
    );


    //====================================================
    // ERROR DETECTION ADD-ON
    //
    // Disabled during the normal successful transfer.
    //====================================================

    dma_error #(
        .TIMEOUT_LIMIT(4)
    ) ERROR (
        .CLK(CLK),
        .RST(RST),

        .error_enable(1'b0),
        .transfer_active(burst_active),

        .error_flag(ERROR_FLAG),
        .recovery(recovery)
    );


    //====================================================
    // INTERRUPT ADD-ON
    //====================================================

    dma_interrupt INTERRUPT (
        .CLK(CLK),
        .RST(RST),

        .transfer_active(burst_active),
        .transfer_done(transfer_done),
        .error_flag(ERROR_FLAG),

        .busy(DMA_BUSY),
        .interrupt(DMA_INTERRUPT)
    );


    //====================================================
    // MAIN DMA DATA OUTPUT
    //
    // IMPORTANT:
    // Keep the original working data path.
    //====================================================

    assign Data_out = buffer_data;

endmodule