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

module Filter_tst;

// Inputs
reg CLK_Filter;
reg rst_n;
reg [7:0] RED_ADC_Value;
  
  
// Outputs
wire [19:0] Out_RED_Filtered;

// Instantiate the Unit Under Test (UUT)
FIR_Filter_RED dut_red (
.CLK_Filter(CLK_Filter),
.rst_n(rst_n),
.ADC_Value(RED_ADC_Value),
.Out_RED_Filtered(Out_RED_Filtered)
);

FIR_Filter_IR dut_ir (
.CLK_Filter(CLK_Filter),
.rst_n(rst_n),
.ADC_Value(IR_ADC_Value),
.Out_IR_Filtered(Out_IR_Filtered)
);


initial begin
// Initialize Inputs


CLK_Filter = 0;
rst_n = 0;
RED_ADC_Value = 0;
#1000;

rst_n = 1;
#800;

rst_n = 0;
RED_ADC_Value = 8'd5;
#1000;
RED_ADC_Value = 8'd10;
#1000;
RED_ADC_Value  = 8'd12;
#1000;
RED_ADC_Value  = 8'd15;
#1000;
RED_ADC_Value = 8'd16;
#1000;

#100000 $stop; 


end
always begin #500 CLK_Filter=~CLK_Filter; end
endmodule