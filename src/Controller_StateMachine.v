module Controller_StateMachine(ADC,clk,Find_Setting, rst_n, LED_Drive,DC_Comp,LED_IR,LED_RED,PGA_Gain, RED_ADC_Value, IR_ADC_Value, CLK_Filter);
	
	output reg [3:0] LED_Drive;
	output reg [6:0] DC_Comp;
	output reg LED_IR;
	output reg LED_RED;
	output reg [3:0] PGA_Gain;
	output reg [7:0] RED_ADC_Value;
	output reg [7:0] IR_ADC_Value;
	output reg CLK_Filter;
		
	
	//Input ADC of vppg
	input wire [7:0] ADC;
	//input clk;
	input wire clk;
	//input rst_n;
	input wire rst_n;
	//input Find_Setting;
	input wire Find_Setting;
	

	//RED OP searchingfi
	reg [6:0] RED_OP;

	//RED Gain searching
	reg [3:0] RED_Gain;

	//IR OP searching
	reg [6:0] IR_OP;
	//IR Gain searching
	reg [3:0] IR_Gain;


	//Offset voltage compare to 0.9
	reg [7:0] V_offset;
	reg [3:0] acceptable_offset;
	reg [7:0] V_min_1s;
	reg [7:0] V_max_1s;
	
		
	//wait time_counter
	reg [15:0] Gain_wait_time;
	reg [15:0] Alternating_Wait_Time;
	reg [15:0] Counter_CLK_Filter;
	reg [15:0] Min_Max_Wait_Counter;
	reg Min_Max_Found;
	reg [7:0] Min_Max_Difference;
	reg [7:0] DC_Middle;
	
	//All States
	reg idle_state;
	reg [3:0] currentState;
	reg [3:0] previousState;
	reg [3:0] nextState;
	
	parameter Reset_State = 0;
	parameter Find_New_Settings_State=1;
	parameter RED_LED_OP_Search_State =2;
	parameter RED_LED_Gain_Search_State =3 ;
	parameter INRED_OP_Search_State =4;
	parameter INRED_Gain_Search_State =5 ;
	
	parameter Alternating_RED_LED_State = 6;
	parameter Alternating_IR_LED_State = 7;
	parameter Alternating_LED_State = 8;

	parameter FIR_Filter_State = 9;
	parameter Idle_State = 10;

	//Instantiate FIR_Filter Module
	/*FIR_Filter FIR_Filter_RED(
	.CLK_Filter(CLK_Filter),
	.rst_n(rst_n),
	.ADC_Value(RED_ADC_Value),
	.Out_RED_Filtered(Out_RED_Filtered)
	);
	
	FIR_Filter FIR_Filter_IR(
	.CLK_Filter(CLK_Filter),
	.rst_n(rst_n),
	.ADC_Value(IR_ADC_Value),
	.Out_RED_Filtered(Out_IR_Filtered)
	);*/
	
	always@(posedge clk) begin
		if(rst_n ==1)
			begin
			Counter_CLK_Filter=0;
			CLK_Filter = 0;
			end
		if(Counter_CLK_Filter==1)
			begin
			Counter_CLK_Filter = 0;
			if (CLK_Filter == 1)
				CLK_Filter=0;
			else
				CLK_Filter =1;
			end
		Counter_CLK_Filter = Counter_CLK_Filter+1;
	end

	
	always@(posedge clk) begin    		//MARKER: HAS BEEN MODIFIED only for SYNTHESIS, MUST ADJUST BACK
		if (Find_Setting==1)
			begin
			currentState = Find_New_Settings_State;
			end
		if (rst_n == 1)
			begin
			currentState  = Reset_State;
			end
	case(currentState)
			Reset_State:
				begin					
					LED_Drive = 10;
					DC_Comp = 0; // DC_Comp = 0
					LED_IR = 0;	//Turn OFF IN_RED
					LED_RED = 1 ; //Turn ON RED_LED
					PGA_Gain = 0; // GAIN = 0
					V_offset = 0;
					acceptable_offset = 10;
					Gain_wait_time = 545;
					Min_Max_Wait_Counter=0;
					V_min_1s = 255;
					V_max_1s = 0;
					DC_Middle = 0;
					Min_Max_Found=0;
					Min_Max_Difference=0;
					Alternating_Wait_Time = 10;
					IR_ADC_Value = 0;
					RED_ADC_Value = 0;
					currentState = nextState; // go to where it was predefine, this Reset is just a middle state (bergang)

				end
			
			Find_New_Settings_State:
				begin
					currentState = 	RED_LED_OP_Search_State;		
				end

			RED_LED_OP_Search_State:
				begin
					if (Min_Max_Wait_Counter<20)
						begin
						if(ADC < V_min_1s)
							V_min_1s = ADC;
						if(ADC > V_max_1s)
							V_max_1s = ADC;
						end
					else
						begin
						Min_Max_Difference = V_max_1s-V_min_1s;
						DC_Middle =  (Min_Max_Difference >>2) + V_min_1s;
						if(DC_Middle < 127)
							V_offset = 127-DC_Middle;
						else
							V_offset = DC_Middle-127;
						V_max_1s = 0;
						V_min_1s = 255;
						Min_Max_Wait_Counter = 0;
						Min_Max_Found = 1;
						end
					//Stop searching, save for RED-LED DC point 
					if(V_offset<= acceptable_offset & Min_Max_Found == 1)
						begin
						RED_OP = DC_Comp;
						Min_Max_Found=0;
						currentState = RED_LED_Gain_Search_State;
					 	end
					//Seaching for DC_Comp
					if(Min_Max_Found == 1 & V_min_1s > 127)
						begin
						DC_Comp = DC_Comp +10;
						Min_Max_Found = 0;
						end
					else if (Min_Max_Found == 1 & V_max_1s < 127)
						begin
						DC_Comp = DC_Comp-10;
						Min_Max_Found = 0;
						end
					else if ( Min_Max_Found == 1 & DC_Middle < 127)
						begin
						DC_Comp = DC_Comp-5;
						Min_Max_Found = 0;
						end
					else if (Min_Max_Found == 1 & DC_Middle > 127)
						begin
						DC_Comp = DC_Comp+5;
						Min_Max_Found = 0;
						end
					
					Min_Max_Wait_Counter = Min_Max_Wait_Counter+1;
				end

			RED_LED_Gain_Search_State:
				begin
					if(ADC < 240 & ADC > 5 & Gain_wait_time >= 545) // increase gain every 0.545(s)  
					begin
					PGA_Gain = PGA_Gain + 1;
					Gain_wait_time = 0;
					end
				//stop searching, store RED-Gain
				if (ADC > 240 | ADC < 5)
					begin
					RED_Gain = PGA_Gain;
					Gain_wait_time = 0;
					currentState = Reset_State; //Reset Register before going to INRED
					nextState = INRED_OP_Search_State;
					end	
				Gain_wait_time = Gain_wait_time + 1;
				end
			
			INRED_OP_Search_State:
				begin
					LED_IR = 1;	//Turn ON IN_RED
					LED_RED = 0;

					if (Min_Max_Wait_Counter<20)
						begin
						if(ADC < V_min_1s)
							V_min_1s = ADC;
						if(ADC > V_max_1s)
							V_max_1s = ADC;
						end
					else
						begin
						Min_Max_Difference = V_max_1s-V_min_1s;
						DC_Middle =  (Min_Max_Difference >>2) + V_min_1s;
						if(DC_Middle < 127)
							V_offset = 127-DC_Middle;
						else
							V_offset = DC_Middle-127;
						V_max_1s = 0;
						V_min_1s = 255;
						Min_Max_Wait_Counter = 0;
						Min_Max_Found = 1;
						end


					//Stop searching, save for IR-LED DC point 
					if(V_offset<= acceptable_offset & Min_Max_Found == 1)
						begin
						IR_OP = DC_Comp;
						Min_Max_Found=0;
						currentState = INRED_Gain_Search_State;
					 	end


					//Seaching for DC_Comp
					if(Min_Max_Found == 1 & V_min_1s > 127)
						begin
						DC_Comp = DC_Comp +10;
						Min_Max_Found = 0;
						end
					else if (Min_Max_Found == 1 & V_max_1s < 127)
						begin
						DC_Comp = DC_Comp- 10;
						Min_Max_Found = 0;
						end
					else if ( Min_Max_Found == 1 & DC_Middle < 127)
						begin
						DC_Comp = DC_Comp-5;
						Min_Max_Found = 0;
						end
					else if (Min_Max_Found == 1 & DC_Middle > 127)
						begin
						DC_Comp = DC_Comp+5;
						Min_Max_Found = 0;
						end
					
					Min_Max_Wait_Counter = Min_Max_Wait_Counter+1;
						
				end

			INRED_Gain_Search_State:
				begin
					if(ADC < 240 & ADC > 5 & Gain_wait_time >= 545) //
					begin
					PGA_Gain = PGA_Gain +1;
					Gain_wait_time = 0;
					end
				//stop searching, store RED-Gain
				if (ADC > 240 | ADC < 5)
					begin
					IR_Gain = PGA_Gain;
					Gain_wait_time = 0;
					currentState = Alternating_LED_State;
					end	
				Gain_wait_time = Gain_wait_time + 1;
				end

			Alternating_LED_State:
				begin
				if(Alternating_Wait_Time >= 10) // 20 x 0.5 = 10ms, means we alternate every 10ms, means 100Hz
					begin
					Alternating_Wait_Time = 0;
					if(previousState == Alternating_IR_LED_State)
						currentState= Alternating_RED_LED_State;
					else if(previousState == Alternating_RED_LED_State)
						currentState= Alternating_IR_LED_State;
					else 	
						currentState= Alternating_RED_LED_State;
					end
				//Continuously out put the ADC based on which LED is currently on
				if(previousState == Alternating_IR_LED_State)
					begin
					IR_ADC_Value = ADC;	//output ADC of IR_LED
					end
				if(previousState == Alternating_RED_LED_State)
					begin
					RED_ADC_Value = ADC;	//output RED-ADCoutput ADC of RED_LED
					end
				//Increase timing-counter by 1
				Alternating_Wait_Time = Alternating_Wait_Time+1;
				end
			Alternating_RED_LED_State:
				begin
				LED_IR = 0;	//Turn ON RED_LED
				LED_RED = 1;
				DC_Comp = RED_OP;
				PGA_Gain = RED_Gain;
				currentState = Alternating_LED_State;
				previousState = Alternating_RED_LED_State;
				end
			
			Alternating_IR_LED_State:
				begin
				LED_IR = 1;	//Turn ON IR_LED
				LED_RED = 0;
				DC_Comp = IR_OP;
				PGA_Gain = IR_Gain;
				currentState = Alternating_LED_State;
				previousState = Alternating_IR_LED_State;
				end

			FIR_Filter_State:
				begin
				idle_state =1 ;
				end 
		
		endcase
end	
endmodule