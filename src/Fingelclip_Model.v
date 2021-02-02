`timescale 1ms/1us

module Fingerclip_Model(Vppg, DC_Comp, PGA_Gain);
	
	output reg [7:0] Vppg;
	input [6:0] DC_Comp;
	input [3:0] PGA_Gain;
	
	reg clk;
	reg [10:0] Vppg_var, DC_var, PGA_var;

	initial begin
		clk = 0;
		Vppg = 0;
		Vppg_var = 0;
	end

	always@(posedge clk or negedge clk or DC_Comp or PGA_Gain ) begin
		
		DC_var = DC_Comp << 1;
		PGA_var = PGA_Gain << 4;
		if(clk == 1) begin
			Vppg_var  = (255-DC_var) + PGA_var;
			if(Vppg_var > 255) Vppg = 255;
			else Vppg = Vppg_var;
		end else 
			if((PGA_var + DC_var) > 255) Vppg  = 0;
			else Vppg = (255-DC_var) - PGA_var;

	end

	always #545 clk = !clk;

endmodule