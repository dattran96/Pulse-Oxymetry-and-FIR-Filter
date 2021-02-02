//Verilog HDL for "HDL_Lab_10", "FIR_Filter" "functional"
module FIR_Filter_version_2(
  input CLK_Filter,
  input rst_n,
  input wire[7:0] ADC_Value,
  output reg[19:0] Out_Filtered);

// parameter N = 4;
wire signed[8:0] coeffs[21:0];

// Accumulator
reg[19:0] accu;

// Pointer for reading the right coefficients
reg[4:0] coeff_Pointer;

// Temporary Pointer
reg[4:0] temp_Pointer;

// Next Pointer to read coefficient
reg[4:0] nxt_Pointer;




// define multiplier


// FIFO
reg [19:0] product[21:0];

assign coeffs[0]=2;
assign coeffs[1]=10;
assign coeffs[2]=16;
assign coeffs[3]=28;
assign coeffs[4]=43;
assign coeffs[5]=60;
assign coeffs[6]=78;
assign coeffs[7]=95;
assign coeffs[8]=111;
assign coeffs[9]=122;
assign coeffs[10]= 128;
assign coeffs[11]=128;
assign coeffs[12]=122;
assign coeffs[13]=111;
assign coeffs[14]=95;
assign coeffs[15]=78;
assign coeffs[16]=60;
assign coeffs[17]=43;
assign coeffs[18]=28;
assign coeffs[19]=16;
assign coeffs[20]=10;
assign coeffs[21]= 2;
assign full = (temp_Pointer == nxt_Pointer);




always @(posedge CLK_Filter or posedge rst_n)
begin
    if(rst_n)
        begin
            
	coeff_Pointer <= 0;
	temp_Pointer  <= 0;
	nxt_Pointer <= 1;
	accu = 0;
        Out_Filtered    <= 0;
        end
    else
        begin     

	// Add new value to accu
		product[coeff_Pointer]    = ADC_Value * coeffs[coeff_Pointer];
		accu = accu + product[coeff_Pointer];
        	Out_Filtered <= accu ;
	
		// Set coefficient pointer
		coeff_Pointer <= nxt_Pointer;
	
		// Set next Pointer
		if(nxt_Pointer == 21) // check if Pointer has reached the last element          
        		nxt_Pointer <= 0;
		else
			nxt_Pointer <= nxt_Pointer + 1;
            	
		if(full)
		begin	

			// prepare next calculation
			accu = accu - product[nxt_Pointer];
        		
			if(temp_Pointer == 21)
			temp_Pointer <= 0;
			else
			temp_Pointer <= temp_Pointer + 1;
		end
   
		
	end
	
	
end


endmodule

