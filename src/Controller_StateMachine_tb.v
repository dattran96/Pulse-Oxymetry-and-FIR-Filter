`timescale 1us/1us
module Controller_StateMachine_tb();

	//Input controller
	reg  clk;
	reg fast_clk;
	wire [7:0] Vppg;
	reg rst_n;
	reg Find_Setting;
	


	//output Controller
	wire [3:0] LED_Drive;
	wire [6:0] DC_Comp;
	wire LED_IR;
	wire LED_RED;
	wire [3:0] PGA_Gain;
	wire [19:0] Out_RED_Filtered;
	wire [19:0] Out_IR_Filtered;
	wire CLK_Filter;
	//output Fingerclip


	
	
	
	//Controller_Dat dut1( .RED_ADC_Value(RED_ADC_Value), .LED_Drive(LED_Drive), .DC_Comp(DC_Comp), .LED_IR(LED_IR), .LED_RED(LED_RED), .PGA_Gain(PGA_Gain), .ADC(Vppg), .clk(clk));
	Fingerclip_Model dut2(.Vppg(Vppg), .DC_Comp(DC_Comp), .PGA_Gain(PGA_Gain));	
	Top_Module_Controller_and_FIR dut1(.LED_Drive(LED_Drive), .DC_Comp(DC_Comp), .LED_IR(LED_IR), .LED_RED(LED_RED), 
.PGA_Gain(PGA_Gain), .Out_IR_Filtered(Out_IR_Filtered), .Out_RED_Filtered(Out_RED_Filtered), .ADC(Vppg), .clk(clk),.rst_n(rst_n),.Find_Setting(Find_Setting));
// Instantiate the Unit Under Test (UUT)



	
	initial begin
		Find_Setting = 0;
		rst_n = 1;
		clk = 0;
		
		
		#550 rst_n = 0;
		#600 Find_Setting = 1;
		#1150 Find_Setting = 0;
		
		
		#100000000 $stop;
	end

	



	always #500 clk = !clk;  //Clock 1khz controller
	always #40 fast_clk = !fast_clk; //Clock of Filter, 22 times faster than Sampling Frequency(500Hz)
	
endmodule