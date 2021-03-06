`timescale 1us/1us
module Controller_TB();

	//Input controller
	reg  clk;
	wire [7:0] Vppg;

	//output Controller
	wire [3:0] LED_Drive;
	wire [6:0] DC_Comp;
	wire LED_IR;
	wire LED_RED;
	wire [3:0] PGA_Gain;
	wire [7:0] RED_ADC_Value;
	//output Fingerclip
	
	
	
	Controller_Dat dut1( .RED_ADC_Value(RED_ADC_Value), .LED_Drive(LED_Drive), .DC_Comp(DC_Comp), .LED_IR(LED_IR), .LED_RED(LED_RED), .PGA_Gain(PGA_Gain), .ADC(Vppg), .clk(clk));
	Fingerclip_Model dut2(.Vppg(Vppg), .DC_Comp(DC_Comp), .PGA_Gain(PGA_Gain));	


	initial begin
		clk = 0;
		#100000000 $stop;
	end

	always #500 clk = !clk;

	
endmodule