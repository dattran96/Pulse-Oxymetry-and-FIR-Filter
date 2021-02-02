`timescale 1ms/1us
module Fingerclip_Model_TB ();

	
	
	reg [0:6] DC_Comp;
	reg [0:3] PGA_Gain;
	wire [0:7] Vppg;
	reg clk;
	
	Fingerclip_Model dut(.Vppg(Vppg), .DC_Comp(DC_Comp), .PGA_Gain(PGA_Gain));

	initial begin
		DC_Comp = 0;
		PGA_Gain = 0;
		clk = 0;
		#1000000 $stop;
	end

	

	always@(posedge clk) begin
		if (DC_Comp < 40) DC_Comp = DC_Comp +1;
		else PGA_Gain = PGA_Gain + 1;

	end


endmodule
