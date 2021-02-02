///////////////////////////////////////////
// Synchronous FIFO
///////////////////////////////////////////
// Description:
// - First-in-first-out buffer with synchronous write and read clock
// - empty signal indicates that the buffer is empty (no more reads possible)
// - full signal indicates thate the buffer is full (no more writes possible)
// - dual_port_ram can be replaced by any dual port SRAM or Block-RAM that has no output registers.
///////////////////////////////////////////

// Simulator setting: timescale / precision
`timescale 1 ns / 1 ps

// Module port list:
module fifo (
	clk,	// write clock
	rst_n,	// asynchronous reset (active low)
	wr_en,	// write enable
	wr_data,// write data
	rd_en,	// read enable
	rd_data,// read data
	empty,	// empty indicator
	full	// full indicator
);

// ----------------------------------------
// PARAMETERS
// ----------------------------------------

parameter WIDTH = 8;	// Width of wr_data and rd_data
parameter DEPTHBIT = 9;	// Number of entries = 2^DEPTHBIT

localparam MAXCOUNT = 2**DEPTHBIT;	// Maximum number of entries

// ----------------------------------------
// PORTS
// ----------------------------------------

// Inputs:
input clk;
input rst_n;
input wr_en;
input [WIDTH-1:0] wr_data;
input rd_en;

// Outputs:
output reg [WIDTH-1:0] rd_data;
output wire empty;
output wire full;

// ----------------------------------------
// SIGNALS
// ----------------------------------------

reg [DEPTHBIT:0] fifo_count;
reg [DEPTHBIT-1:0] wr_pointer;
reg [DEPTHBIT-1:0] rd_pointer;

wire [WIDTH-1:0] rdata_b;

// ----------------------------------------
// INSTANCES
// ----------------------------------------

// Dual port RAM:
dual_port_ram #(.WIDTH(WIDTH), .DEPTHBIT(DEPTHBIT)) dp_ram_inst (
	.clk_a	(clk),	// Port A clock
	.addr_a	(wr_pointer),	// Port A address
	.wdata_a(wr_data),	// Port A write data
	.rdata_a(),	// Port A read data
	.we_a	(wr_en & !full),	// Port A write enable (active high)
	.clk_b	(clk),	// Port B clock
	.addr_b	(rd_pointer),	// Port B address
	.wdata_b({WIDTH{1'b0}}),	// Port B write data
	.rdata_b(rdata_b),	// Port B read data
	.we_b	(1'b0)	// Port B write enable (active high)
);

// ----------------------------------------
// ASSIGNMENTS
// ----------------------------------------

assign empty = (fifo_count == 0);
assign full = (fifo_count == MAXCOUNT);

// ----------------------------------------
// PROCESSES
// ----------------------------------------

// Write pointer:
always @(posedge clk or negedge rst_n)
begin: WRITE_POINTER
	if (!rst_n) begin	// reset
		wr_pointer <= 0;
	end else begin		// operation
		if (wr_en & !full) begin
			wr_pointer <= wr_pointer + 1;
		end
	end
end

// Read pointer and data:
always @(posedge clk or negedge rst_n)
begin: READ_POINTER
	if (!rst_n) begin	// reset
		rd_data <= 0;
		rd_pointer <= 0;
	end else begin		// operation
		if (rd_en & !empty) begin
			rd_pointer <= rd_pointer + 1;
			rd_data <= rdata_b;
		end
	end
end

// Fifo counter:
always @(posedge clk or negedge rst_n)
begin: FIFO_COUNT
	if (!rst_n) begin	// reset
		fifo_count <= 0;
	end else begin		// operation
		// write but no read:
		if (wr_en & !full & !rd_en) begin
			fifo_count <= fifo_count + 1;
		// read but no write:
		end else if (rd_en & !empty & !wr_en) begin
			fifo_count <= fifo_count - 1;
		end
	end
end

endmodule