//Verilog HDL for "HDL_Lab_10", "FIR_Filter" "functional"

module FIR_Filter_Version_2(
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
assign empty = (coeff_Pointer == temp_Pointer);
assign full = (temp_Pointer == nxt_Pointer);



/*genvar i;

generate
for (i=0; i<N; i=i+1)
    begin: mult
        multiplier mult1(
          .dataa(coeffs[i]),		// h[k]
          .datab(holderBefore[i]),	// x[n-k]
          .result(toAdd[i]));		// temp_y[k]
    end
endgenerate
*/


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
/*
// implement product with coef 
always @(posedge CLK_Filter or posedge rst_n) begin
	if (rst_n) begin
		

	end
	else begin
		product[0] <= coeffs[0] * holderBefore[0];
		product[1] <= coeffs[1] * holderBefore[1];
		product[2] <= coeffs[2] * holderBefore[2];
		product[3] <= coeffs[3] * holderBefore[3];
		product[4] <= coeffs[4] * holderBefore[4];
		product[5] <= coeffs[5] * holderBefore[5];
		product[6] <= coeffs[6] * holderBefore[6];
		product[7] <= coeffs[7] * holderBefore[7];
		product[8] <= coeffs[8] * holderBefore[8];
		product[9] <= coeffs[9] * holderBefore[9];
		product[10] <= coeffs[10] * holderBefore[10];
		product[11] <= coeffs[10] * holderBefore[11];
		product[12] <= coeffs[9] * holderBefore[12];
		product[13] <= coeffs[8] * holderBefore[13];
		product[14] <= coeffs[7] * holderBefore[14];
		product[15] <= coeffs[6] * holderBefore[15];
		product[16] <= coeffs[5] * holderBefore[16];
		product[17] <= coeffs[4] * holderBefore[17];
		product[18] <= coeffs[3] * holderBefore[18];
		product[19] <= coeffs[2] * holderBefore[19];
		product[20] <= coeffs[1] * holderBefore[20];
		product[21] <= coeffs[0] * holderBefore[21];
			
	end
end
*/



endmodule

/*module multiplier(
          dataa,		// h[k]
          datab,	// x[n-k]
          result );	

output [15:0] result;
	input  [15:0] dataa;
	input  [15:0] datab;



	assign result = dataa*datab;

endmodule
*/

