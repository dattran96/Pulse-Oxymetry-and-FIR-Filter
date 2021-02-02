
`timescale 1 ns / 100 ps

module histogram_tb (
);

reg clk;
reg rst_n;
reg [3:0] data;
reg we;
reg clear;
reg [3:0] addr;
wire [7:0] data_out;
wire ready;
wire full;

histogram #(.WIDTH(4), .DEPTHBIT(8)) histogram_inst (
	.clk_w		(clk),
	.rst_n		(rst_n),
	.wdata_in	(data),
	.we_in		(we),
	.clear_in	(clear),
	.clk_r		(clk),
	.raddr_in	(addr),
	.histo_size	(8'd5),
	.rdata_out	(data_out),
	.ready_out	(ready),
	.full_out	(full)
);

always #0.5 clk = !clk;

initial begin
clk = 1;
addr = 0;
rst_n = 0;
clear = 0;
#2;
rst_n = 1;
data = 0;
we = 0;
clear = 1;
#1;
clear = 0;
#17;
we = 1;
data = 5;
#1;
data = 7;
#2;
data = 2;
#1;
data = 0;
#9;
we = 0;
data = 3;
#1;
addr = 0;
#1;
addr = 1;
#1;
addr = 2;
#1;
addr = 3;
#1;
addr = 4;
#1;
addr = 5;
#1;
addr = 6;
#1;
addr = 7;



end


endmodule