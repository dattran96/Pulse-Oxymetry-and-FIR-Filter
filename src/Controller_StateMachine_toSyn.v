module Controller_StateMachine(ADC,clk,Find_Setting, rst_n, LED_Drive,DC_Comp,LED_IR,LED_RED,PGA_Gain,RED_ADC_Value,IR_ADC_Value);
	
	output reg [3:0] LED_Drive;
	output reg [6:0] DC_Comp;
	output reg LED_IR;
	output reg LED_RED;
	output reg [3:0] PGA_Gain;
	//output reg CLK_Filter;
	//output reg [7:0] IR_ADC_Value;
	output reg [7:0] RED_ADC_Value;
	output reg [7:0] IR_ADC_Value;	

	//Input ADC of vppg
	input [7:0] ADC;
	//input clk;
	input clk;
	//input rst_n;
	input rst_n;
	//input Find_Setting;
	input Find_Setting;
	

	//RED OP searching
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

		
	//wait time_counter
	reg [15:0] Gain_wait_time;
	reg [15:0] Alternating_Wait_Time;
	
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

		 
	initial begin
		LED_Drive = 10;
		DC_Comp = 0; // DC_Comp = 0
		LED_IR = 0;	//Turn OFF IN_RED
		LED_RED = 1 ; //Turn ON RED_LED
		PGA_Gain = 0; // GAIN = 0
		V_offset = 0;
		acceptable_offset = 10;
		Gain_wait_time = 1090;
		Alternating_Wait_Time = 20;
		IR_ADC_Value = 0;
		RED_ADC_Value = 0;
	
	
		currentState = Reset_State;
		//CLK_Filter = 0;
		//IR_ADC_Value = 0;
	end


	always@(rst_n) begin
		if(rst_n == 0)
			currentState = Reset_State;
	end

	always@(Find_Setting) begin
		if(Find_Setting == 1)
			currentState = Find_New_Settings_State;
	end	
	 
	always@(posedge clk or negedge clk) begin
		case(currentState)
			Reset_State:
				begin
					DC_Comp = 0;
					PGA_Gain = 0;
					currentState = nextState; // go to where it was predefine, this Reset is just a middle state (Übergang)
				end
			
			Find_New_Settings_State:
				begin
					currentState = 	RED_LED_OP_Search_State;		
				end

			RED_LED_OP_Search_State:
				begin
					//Seaching for DC_Comp
					if( ADC > 127)
						begin
						DC_Comp = DC_Comp +1;
						V_offset = ADC- 127;
						end
					else if (ADC < 127)
						begin
						DC_Comp = DC_Comp- 1;
						V_offset = 127-ADC;	
						end
					//Stop searching, save for RED-LED DC point 
					if(V_offset<= acceptable_offset)
						begin
						RED_OP = DC_Comp;
						currentState = RED_LED_Gain_Search_State;
					 	end		
				end

			RED_LED_Gain_Search_State:
				begin
					if(ADC < 220 & ADC > 30 & Gain_wait_time >= 1090) // increase gain every 0.545(s)  
					begin
					PGA_Gain = PGA_Gain + 1;
					Gain_wait_time = 0;
					end
				//stop searching, store RED-Gain
				if (ADC > 220 | ADC < 30)
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
					//Seaching for DC_Comp
					if( ADC > 127)
						begin
						DC_Comp = DC_Comp +1;
						V_offset = ADC- 127;
						end
					else if (ADC < 127)
						begin
						DC_Comp = DC_Comp- 1;
						V_offset = 127-ADC;		
						end
					//Stop searching, save for IR-LED DC point 
					if(V_offset<= acceptable_offset)
						begin
						IR_OP = DC_Comp;
						currentState = INRED_Gain_Search_State;
					 	end		
				end

			INRED_Gain_Search_State:
				begin
					if(ADC < 220 & ADC > 30 & Gain_wait_time >= 1000) //
					begin
					PGA_Gain = PGA_Gain + 1;
					Gain_wait_time = 0;
					end
				//stop searching, store RED-Gain
				if (ADC > 220 | ADC < 30)
					begin
					IR_Gain = PGA_Gain;
					Gain_wait_time = 0;
					currentState = Alternating_LED_State;
					end	
				Gain_wait_time = Gain_wait_time + 1;
				end

			Alternating_LED_State:
				begin
				if(Alternating_Wait_Time >= 20) // 20 x 0.5 = 10ms, means we alternate every 10ms, means 100Hz
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
