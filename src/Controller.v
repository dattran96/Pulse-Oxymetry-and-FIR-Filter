`timescale 1ms/1us
module Controller(Vppg,clk,LED_Drive,DC_Comp,LED_IR,LED_RED,PGA_Gain,RED_ADC_Value);		
		// for Cadence, change Vppg to ADC
	
	output reg [3:0] LED_Drive;
	output reg [6:0] DC_Comp;
	output reg LED_IR;
	output reg LED_RED;
	output reg [3:0] PGA_Gain;
	//output reg CLK_Filter;
	//output reg [7:0] IR_ADC_Value;
	output reg [7:0] RED_ADC_Value;

	input [7:0] Vppg;
	//input Find_Setting;
	input clk;
	//input rst_n;
	
	//RED OP searching
	reg found_RED_OP;
	reg [6:0] RED_OP;

	//RED Gain searching
	reg RED_Gain;
	// reg RED_search_Gain;
	// reg [7:0] previous_ADC;
	// reg wait_for_react;

	//Offset voltage compare to 0.9
	reg [7:0] V_offset;
	reg [3:0] acceptable_offset;

	initial 
	begin
		
		LED_Drive = 10;
		DC_Comp = 0; // DC_Comp = 0
		LED_IR = 0;	//Turn OFF IN_RED
		LED_RED = 1 ; //Turn ON RED_LED
		PGA_Gain = 0; // GAIN = 0
		found_RED_OP = 0;
		V_offset = 255;
		acceptable_offset = 10;
		// wait_for_react=0;
		//CLK_Filter = 0;
		//IR_ADC_Value = 0;
	end

	always@(posedge clk or negedge clk) begin

		// Find operating point for RED LED
		if(found_RED_OP == 0)	begin
			if(V_offset<= acceptable_offset)	begin		// terminating condition for finding operating poitn of 0.9V
				RED_OP = DC_Comp;			// save DC Compensation
				found_RED_OP = 1;
					// RED_search_Gain = 1;
		 	end
			else if( Vppg > 127 )		// if the module has exceeded the operating point of 0.9V
			begin
				DC_Comp = DC_Comp +1;
				V_offset = Vppg- 127;
			end
			else			// if the module has not reached the operating point of 0.9V yet
			begin
				DC_Comp = DC_Comp- 1;
				V_offset = 127-Vppg;
				//RED_ADC_Value = ADC;				save RED_ADC_Value after PGA_Gain has been adjusted	
			end
		end
		
		//Stop searching, save for RED-LED DC point 
		
		//Search for RED-gain

		else 	// if operating point was found
			begin
				if(Vppg > 245 | Vppg < 16)	begin		// terminating condition
			
					
					RED_Gain = PGA_Gain;		// save PGA_Gain;
					RED_ADC_Value = Vppg;
				end
		
				else
					PGA_Gain = PGA_Gain + 1;
			end


		// TODO: Avoid Clipping
		
		// Switching between RED and IR OP/ Gain Search
		/*case 1: red_op
		case 2: red_gain
		case 3: ir_op
		case 4: ir_gain

		*/
		//stop searching, store RED-Gain
		
		end	
		

	
	
endmodule