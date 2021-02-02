
///////////////////////////////////////////
// Dual port RAM
///////////////////////////////////////////
// Description:
// - Dual port RAM w/o output register
// - Output data is available within the same clock cycle as address
// - Will synthesize to a register based RAM (slow and big compared to SRAM)
// - Can be used as behavorial model for a real SRAM
// - INFO: no write is performed if both we_a and we_b are high! Modify code if this behaviour does not suit your application.
///////////////////////////////////////////

`timescale 10 fs / 1 fs

module dual_port_ram (
	clk_a,		// Port A clock
	addr_a,		// Port A address
	wdata_a,	// Port A write data
	rdata_a,	// Port A read data
	we_a,		// Port A write enable (active high)
	clk_b,		// Port B clock
	addr_b,		// Port B address
	wdata_b,	// Port B write data
	rdata_b,	// Port B read data
	we_b		// Port B write enable (active high)
);

// ----------------------------------------
// PARAMETERS
// ----------------------------------------

parameter WIDTH = 8;	// Bit-width of wdata and rdata
parameter DEPTHBIT = 4;	// Memory depth = 2^DEPTHBIT

localparam DEPTH = 2**DEPTHBIT;	// Depth of the memory

// ----------------------------------------
// PORTS
// ----------------------------------------

// Inputs:
// Port A:
input clk_a;
input [DEPTHBIT-1:0] addr_a;
input [WIDTH-1:0] wdata_a;
input we_a;
// Port B:
input clk_b;
input [DEPTHBIT-1:0] addr_b;
input [WIDTH-1:0] wdata_b;
input we_b;

// Outputs:
output wire [WIDTH-1:0] rdata_a;
output wire [WIDTH-1:0] rdata_b;

// ----------------------------------------
// SIGNALS
// ----------------------------------------

reg [WIDTH-1:0] ram [DEPTH-1:0];	// The memory

// ----------------------------------------
// PROCESSES
// ----------------------------------------

assign rdata_a = ram[addr_a];	// Read on port A
assign rdata_b = ram[addr_b];	// Read on port B

// Write on port A:
always @(posedge clk_a) begin
	if (we_a & !we_b) begin
		ram[addr_a] <= wdata_a;
	end
end

// Write on port B:
always @(posedge clk_b) begin
	if (we_b & !we_a) begin
		ram[addr_b] <= wdata_b;
	end
end

endmodule
