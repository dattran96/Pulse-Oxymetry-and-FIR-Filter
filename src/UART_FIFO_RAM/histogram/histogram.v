
///////////////////////////////////////////
// Histogram calculation module
///////////////////////////////////////////
// Description:
// - Computes the histogram of the input data with the given number of samples.
// - A rising edge on clear_in starts a state machine that resets all bins to zero.
// - ready_out signal indicates if data can be written or read. If it is low, the content is currently being cleared.
// - dual_port_ram can be replaced by any dual port SRAM or Block-RAM that has no output registers.
///////////////////////////////////////////

`timescale 10 fs / 1 fs

module histogram (
	clk_w,		// write port clock
	rst_n,		// asynchronous reset
	wdata_in,	// write data (data to sample in the histogram)
	we_in,		// write enable (enables the sampling of wdata_in)
	clear_in,	// clear input (after a rising edge of clear_in the content will be overwritten with zeros)
	clk_r,		// read port clock (in fully sychronous designs: same as clk_w)
	raddr_in,	// read address (used to read out the content of the bins)
	histo_size,	// total number of samples to record (must be <= DEPTH)
	rdata_out,	// read data (content of the bin at address raddr_in when reading out)
	ready_out,	// ready indicator (when high writing and reading can be performed. Is low while content is being cleared)
	full_out	// full indicator (is high when the number of samples recorded has reached histo_size)
);

// ----------------------------------------
// PARAMETERS
// ----------------------------------------

parameter WIDTH = 8;	// Bit-width of wdata_in (2^WIDTH = number of bins)
parameter DEPTHBIT = 5;	// Bit-width of rdata_out

localparam DEPTH = 2**DEPTHBIT;	// Depth of each bin

// FSM States:
localparam STATE_IDLE = 0;
localparam STATE_CLEAR = 1;

// ----------------------------------------
// PORTS
// ----------------------------------------

// Inputs:
input clk_w;
input rst_n;
input [WIDTH-1:0] wdata_in;
input we_in;
input clear_in;
input clk_r;
input [WIDTH-1:0] raddr_in;
input [DEPTHBIT-1:0] histo_size;

// Outputs:
output wire [DEPTHBIT-1:0] rdata_out;
output reg ready_out;
output wire full_out;

// ----------------------------------------
// SIGNALS
// ----------------------------------------

// Clear state machine:
reg state;
reg clear_old;
reg [WIDTH-1:0] clear_addr;
reg we_clear;
reg [DEPTHBIT-1:0] histo_count;
wire histo_full;

// Write port:
wire [WIDTH-1:0] addr_a;
wire [DEPTHBIT-1:0] wdata_a;
wire we_a;
wire [DEPTHBIT-1:0] rdata_a;

// Read port:
wire [WIDTH-1:0] addr_b;
wire [DEPTHBIT-1:0] rdata_b;

// ----------------------------------------
// INSTANCES
// ----------------------------------------

// Dual port RAM (replace with SRAM or Block-RAM in Chip or FPGA implementations):
dual_port_ram #(.WIDTH(DEPTHBIT), .DEPTHBIT(WIDTH)) dp_ram_inst (
	// Port A: Write
	.clk_a	(clk_w),
	.addr_a	(addr_a),
	.wdata_a(wdata_a),
	.rdata_a(rdata_a),
	.we_a	(we_a),
	// Port B: Read
	.clk_b	(clk_r),
	.addr_b (addr_b),
	.wdata_b(0),
	.rdata_b(rdata_b),
	.we_b	(0)
);

// ----------------------------------------
// ASSIGNMENTS
// ----------------------------------------

// Clear state machine:
assign histo_full = histo_count >= histo_size;	// histogram full indicator
assign full_out = histo_full;

// Write port signals:
assign addr_a = we_clear ? clear_addr : wdata_in;
assign wdata_a = we_clear ? 0 : rdata_a + 1'b1;	// increment histogram bin
assign we_a = (we_in & !histo_full) | we_clear;

// Read port signals:
assign addr_b = raddr_in;
assign rdata_out = rdata_b;

// ----------------------------------------
// PROCESSES
// ----------------------------------------

// Histogram clearing FSM:
always @(posedge clk_w or negedge rst_n) begin
	if (!rst_n) begin
		ready_out <= 1;
		clear_addr <= 0;
		we_clear <= 0;
		histo_count <= 0;
		clear_old <= 0;
		state <= STATE_IDLE;
	end else begin
		clear_old <= clear_in;
		case (state)
		// Idle state: perform writing or reading
		STATE_IDLE: begin
			ready_out <= 1;
			clear_addr <= 0;	// reset clear counter
			if (we_in) begin
				// Count the number of samples:
				if (!histo_full) begin
					histo_count <= histo_count + 1'b1;
				end
			end
			// On rising edge of clear_in go to clear state:
			if (clear_in & !clear_old) begin
				state <= STATE_CLEAR;
				we_clear <= 1;
			end else begin
				state <= STATE_IDLE;
				we_clear <= 0;
			end
		end
		// Clear state: clear content of histogram (overwrite all bins with zero)
		STATE_CLEAR: begin
			ready_out <= 0;
			histo_count <= 0;	// reset sample counter
			// go through all addresses and clear the content, when done go back to idle state:
			if (clear_addr < {WIDTH{1'b1}}) begin
				clear_addr <= clear_addr + 1'b1;
				we_clear <= 1;
				state <= STATE_CLEAR;
			end else begin
				we_clear <= 0;
				state <= STATE_IDLE;
			end
		end
		endcase
	end
end

endmodule
