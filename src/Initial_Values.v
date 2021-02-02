module Initial_Values(clk, LED_IR , LED_RED , DC_Comp , LED_Drive, PGA);
	input clk;
	output reg LED_IR, LED_RED;
	output reg [6:0] DC_Comp;
	output reg [3:0] LED_Drive, PGA;

	always@(posedge clk) begin 
		LED_IR <= 1;
		LED_RED <= 0;
		DC_Comp <= 57;
		LED_Drive <= 10;
		PGA <= 7;
	end	
endmodule
