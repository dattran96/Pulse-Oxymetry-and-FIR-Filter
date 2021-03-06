//Verilog HDL for "HDL_Lab_10", "FIR_Filter" "functional"
module FIR_Filter_version_1(
  input CLK_Filter,
  input rst_n,
  input wire[7:0] IR_ADC_Value,
  output reg[19:0] Out_IR_Filtered);

// parameter N = 4;
wire signed[8:0] coeffs[10:0];
reg [15:0] holderBefore[21:0];


// define multiplier

reg signed[31:0] product[21:0];

// assign coefficients: because we have a symmetric filter, we only need to reserve the half of coefficients

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
            
	holderBefore[21]     <= 0;
        holderBefore[20]     <= 0;
	holderBefore[19]     <= 0;
        holderBefore[18]     <= 0;
        holderBefore[17]     <= 0;
        holderBefore[16]     <= 0;
	holderBefore[15]     <= 0;
        holderBefore[14]     <= 0;
        holderBefore[13]     <= 0;
        holderBefore[12]     <= 0;
	holderBefore[11]     <= 0;
        holderBefore[10]     <= 0;
        holderBefore[9]     <= 0;
        holderBefore[8]     <= 0;
	holderBefore[7]     <=0;
        holderBefore[6]     <= 0;
        holderBefore[5]     <= 0;
        holderBefore[4]     <= 0;
        holderBefore[3]     <= 0;
        holderBefore[2]     <= 0;
        holderBefore[1]     <= 0;
        holderBefore[0]     <= 0;
        Out_IR_Filtered    <= 0;
        end
    else
        begin               
            
        holderBefore[21]     <= holderBefore[20];
       	holderBefore[20]     <= holderBefore[19];
	holderBefore[19]     <= holderBefore[18];
        holderBefore[18]     <= holderBefore[17];
        holderBefore[17]     <= holderBefore[16];
        holderBefore[16]     <= holderBefore[15];
	holderBefore[15]     <= holderBefore[14];
        holderBefore[14]     <= holderBefore[13];
        holderBefore[13]     <= holderBefore[12];
        holderBefore[12]     <= holderBefore[11];
	holderBefore[11]     <= holderBefore[10];
        holderBefore[10]     <= holderBefore[9];
       	holderBefore[9]     <= holderBefore[8];
        holderBefore[8]     <= holderBefore[7];
	holderBefore[7]     <= holderBefore[6];
        holderBefore[6]     <= holderBefore[5];
        holderBefore[5]     <= holderBefore[4];
        holderBefore[4]     <= holderBefore[3];
        holderBefore[3]     <= holderBefore[2];
        holderBefore[2]     <= holderBefore[1];
        holderBefore[1]     <= holderBefore[0];
        holderBefore[0]     <= IR_ADC_Value;
        Out_IR_Filtered <= (product[0] + product[1] + 
                              product[2] + product[3] + product[4] + product[5] + 
                              product[6] + product[7] + product[8] + product[9] + 
                              product[10] + product[11] + product[12] + product[13] + 
                              product[14] + product[15] + product[16] + product[17] + 
                              product[18] + product[19] + product[20] + product[21]);
        end
end

// implement product with coef 
always @(posedge CLK_Filter or posedge rst_n) begin
	if (rst_n) begin
		product[0] <= 0;
		product[1] <= 0;
		product[2] <= 0;
		product[3] <= 0;
		product[4] <= 0;
		product[5] <= 0;
		product[6] <= 0;
		product[7] <= 0;
		product[8] <= 0;
		product[9] <= 0;
		product[10] <= 0;
		product[11] <= 0;
		product[12] <= 0;
		product[13] <= 0;
		product[14] <= 0;
		product[15] <= 0;
		product[16] <= 0;
		product[17] <= 0;
		product[18] <= 0;
		product[19] <= 0;
		product[20] <= 0;
		product[21] <= 0;

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