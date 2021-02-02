
///////////////////////////////////////////
// FIFO testbench
///////////////////////////////////////////
// Description:
// - 
///////////////////////////////////////////

// Simulator setting: timescale / precision
`timescale 1 ns / 1 ps

// Module port list:
module fifo_tb (
);

// ----------------------------------------
// PARAMETERS
// ----------------------------------------

// ----------------------------------------
// PORTS
// ----------------------------------------

// ----------------------------------------
// SIGNALS
// ----------------------------------------

// Inputs:
reg clk;
reg rst_n;
reg wr_en;
reg [7:0] wr_data;
reg rd_en;

// Outputs:
wire [7:0] rd_data;
wire empty;
wire full;

// ----------------------------------------
// INSTANCES
// ----------------------------------------

// FIFO:
fifo #(.WIDTH(8), .DEPTHBIT(2)) fifo_inst (
	.clk	(clk),	// write clock
	.rst_n	(rst_n),	// asynchronous reset (active low)
	.wr_en	(wr_en),	// write enable
	.wr_data(wr_data),// write data
	.rd_en	(rd_en),	// read enable
	.rd_data(rd_data),// read data
	.empty	(empty),	// empty indicator
	.full	(full)	// full indicator
);

// ----------------------------------------
// ASSIGNMENTS
// ----------------------------------------

// ----------------------------------------
// PROCESSES
// ----------------------------------------

always #0.5 clk = !clk;

initial begin
clk = 1;
rst_n = 1;
#1;
rst_n = 0;
#1;
rst_n = 1;
wr_en = 0;
rd_en = 0;
wr_data = 0;
#1;
wr_en = 1;
wr_data = 5;
#1;
wr_data = 3;
#1;
rd_en = 1;
#1;
rd_en = 0;
wr_data = 16;
#4;
wr_en = 0;
#1;
rd_en = 1;
#5;
rd_en = 0;

end

endmodule