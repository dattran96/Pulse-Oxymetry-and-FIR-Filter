module Top_Module_Controller_and_FIR(ADC,clk,Find_Setting, rst_n, LED_Drive,DC_Comp,LED_IR,LED_RED,PGA_Gain,Out_IR_Filtered,Out_RED_Filtered);
	
	//IN-OUT of CONTROLLER
	output wire [3:0] LED_Drive;
	output wire [6:0] DC_Comp;
	output wire LED_IR;
	output wire LED_RED;
	output wire [3:0] PGA_Gain;
	wire [7:0] RED_ADC_Value;
	wire [7:0] IR_ADC_Value;
	wire CLK_Filter;
	
	//input wire fast_clk;
	input wire [7:0] ADC;
	input wire clk;
	input wire rst_n;
	input wire Find_Setting;
	
	
	//IN-OUT OF FIR
	output wire[19:0] Out_IR_Filtered;
	output wire[19:0] Out_RED_Filtered;	
	
	
	
	Controller_StateMachine Controller(
	.LED_Drive(LED_Drive), 
	.DC_Comp(DC_Comp), 
	.LED_IR(LED_IR), 
	.LED_RED(LED_RED), 
	.PGA_Gain(PGA_Gain),
	.RED_ADC_Value(RED_ADC_Value),
	.IR_ADC_Value(IR_ADC_Value),
	.CLK_Filter(CLK_Filter),
	.ADC(ADC), 
	.clk(clk),
	.rst_n(rst_n),
	.Find_Setting(Find_Setting));


	FIR_Filter_Optimized FIR_Filter_RED(
	.CLK_Filter(CLK_Filter),
	.rst_n(rst_n),
	.ADC_Value(RED_ADC_Value),
	.Out_Filtered(Out_RED_Filtered)
	);
	

	FIR_Filter_Optimized FIR_Filter_IR(
	.CLK_Filter(CLK_Filter),
	.rst_n(rst_n),
	.ADC_Value(IR_ADC_Value),
	.Out_Filtered(Out_IR_Filtered)
	);

endmodule
	
	

	
	
	