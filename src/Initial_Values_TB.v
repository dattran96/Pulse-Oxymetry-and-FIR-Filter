` timescale 100ns/1ns
module Initial_Values_TB ();
	wire LED_IR, LED_RED;	
	wire [6:0] DC_Comp;
	wire [3:0] LED_Drive, PGA;
	reg clk;
	Initial_Values dut( .clk(clk), .LED_IR(LED_IR), .LED_RED(LED_RED), .DC_Comp(DC_Comp),
	.LED_Drive(LED_Drive), .PGA(PGA));
	initial clk = 0;
	always #1.5 clk = !clk;
endmodule


