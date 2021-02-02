///////////////////////////////////////////
// UART Transceiver 8 bit
///////////////////////////////////////////
// Description:
// - Implements a simple RS232 compatible UART Transceiver with 8 bit data word length
// - Based on Xilinx UART core
// - tx_data is written to a FIFO when tx_en is high. UART transmits the data bit by bit.
// - tx_full indicates when TX FIFO is full
// - Received data is available at rx_data and rx_data_rdy indicates that rx_data is valid
// - Baud rate and TX FIFO depth can be set via parameters
// - fifo can be replaced with any SRAM based synchronous or asynchronous FIFO
//
// !!! IMPORTANT: Set the correct Clock rate with parameter CLOCK_RATE to ensure proper Baud clock generation !!!
///////////////////////////////////////////

// Simulator setting: timescale / precision
`timescale 10ns/1ns

module uart (
	clk,		// clock
	rst,		// asynchronous reset (active high)
	uart_rx,	// UART RX pin
	tx_en,		// TX enable
	tx_data,	// TX data
	tx_full,	// TX FIFO full indicator
	uart_tx,	// UART TX pin
	rx_data,	// RX data
	rx_data_rdy	// RX data ready indicator
);

// ----------------------------------------
// PARAMETERS
// ----------------------------------------

parameter BAUD_RATE = 57_600;		// UART Baud rate
parameter CLOCK_RATE = 100_000_000;	// Clock rate of clk in Hz for Baud clock generator
parameter TX_FIFO_DEPTH_BIT = 10;	// TX FIFO depth = 2^TX_FIFO_DEPTH_BIT

// ----------------------------------------
// PORTS
// ----------------------------------------

// Inputs:
input clk;
input rst;
input uart_rx;
input tx_en;
input [7:0] tx_data;

// Outputs:
output wire tx_full;
output wire uart_tx;
output wire [7:0] rx_data;
output wire rx_data_rdy;

// ----------------------------------------
// SIGNALS
// ----------------------------------------

wire fifo_rd_en;
wire fifo_empty;

// ----------------------------------------
// INSTANCES
// ----------------------------------------

uart_rx #(
    .BAUD_RATE   (BAUD_RATE),
    .CLOCK_RATE  (CLOCK_RATE)
  ) uart_rx_inst (
    .clk_rx	(clk), 
    .rst_clk_rx	(rst), 
    .rxd_i	(uart_rx), 
    .rx_data	(rx_data), 
    .rx_data_rdy(rx_data_rdy), 
    .frm_err	()
);

uart_tx #(
    .BAUD_RATE    (BAUD_RATE),
    .CLOCK_RATE   (CLOCK_RATE)
  ) uart_tx_inst (
    .clk_tx		(clk), 
    .rst_clk_tx		(rst), 
    .char_fifo_empty	(fifo_empty), 
    .char_fifo_dout	(fifo_rd_data), 
    .char_fifo_rd_en	(fifo_rd_en), 
    .txd_tx		(uart_tx)
    );

fifo #(.WIDTH(8), .DEPTHBIT(TX_FIFO_DEPTH_BIT)) fifo_inst (
	.clk	(clk),			// write clock
	.rst_n	(!rst),			// asynchronous reset (active low)
	.wr_en	(tx_en),		// write enable
	.wr_data(tx_data),		// write data
	.rd_en	(fifo_rd_en),	// read enable
	.rd_data(fifo_rd_data),	// read data
	.empty	(fifo_empty),	// empty indicator
	.full	(tx_full)		// full indicator
);

// ----------------------------------------
// PROCESSES
// ----------------------------------------

endmodule
