`timescale 1us / 1us

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 22:07:00 01/29/2014
// Design Name: filterfir
// Module Name: D:/fft/floating_mul/tst.v
// Project Name: floating_mul
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: filterfir
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

module FIR_Filter_tb_Dat;

// Inputs
reg clk;
reg rst_n;
reg [7:0] input_sample;
  
  
// Outputs
wire [19:0] output_sample;

// Instantiate the Unit Under Test (UUT)
FIR_Filter_Dat dut (
.clk(clk),
.rst_n(rst_n),
.input_sample(input_sample),
.output_sample(output_sample)
);

initial begin
// Initialize Inputs


clk = 0;
rst_n = 0;
input_sample = 0;
#1000;

rst_n = 1;
#1000;

rst_n = 0;
input_sample = 8'd5;
#1000;
input_sample = 8'd10;
#1000;
input_sample = 8'd12;
#1000;
input_sample = 8'd15;

#10000000 $stop; 


end
always begin #1000 clk=~clk; end
endmodule