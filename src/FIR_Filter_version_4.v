//Verilog HDL for "HDL_Lab_10", "FIR_Filter" "functional"
module FIR_Filter_version_4(
  input CLK_Filter,
  input rst_n,
  input wire[7:0] ADC_Value,
  output reg[19:0] Out_Filtered);

// parameter N = 4;
wire signed[8:0] coeffs[21:0];

//
reg [15:0] previous_Value[21:0];

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


always @(posedge CLK_Filter or posedge rst_n)
begin
    if(rst_n)
        begin

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
   
	previous_Value[21]     <= 0;
        previous_Value[20]     <= 0;
	previous_Value[19]     <= 0;
        previous_Value[18]     <= 0;
	previous_Value[17]     <= 0;
        previous_Value[16]     <= 0;
	previous_Value[15]     <= 0;
        previous_Value[14]     <= 0;
       	previous_Value[13]     <= 0;
        previous_Value[12]     <= 0;
	previous_Value[11]     <= 0;
        previous_Value[10]     <= 0;
       	previous_Value[9]     <= 0;
        previous_Value[8]     <= 0;
	previous_Value[7]     <= 0;
        previous_Value[6]     <= 0;
       	previous_Value[5]     <= 0;
        previous_Value[4]     <= 0;
	previous_Value[3]     <= 0;
        previous_Value[2]     <= 0;
       	previous_Value[1]     <= 0;
        previous_Value[0]     <= 0;
	
        Out_Filtered    <= 0;
        end

    else
        begin     


	previous_Value[21]     <= previous_Value[20];
       	previous_Value[20]     <= previous_Value[19];
	previous_Value[19]     <= previous_Value[18];
        previous_Value[18]     <= previous_Value[17];
        previous_Value[17]     <= previous_Value[16];
        previous_Value[16]     <= previous_Value[15];
	previous_Value[15]     <= previous_Value[14];
        previous_Value[14]     <= previous_Value[13];
        previous_Value[13]     <= previous_Value[12];
        previous_Value[12]     <= previous_Value[11];
	previous_Value[11]     <= previous_Value[10];
        previous_Value[10]     <= previous_Value[9];
        previous_Value[9]     <= previous_Value[8];
        previous_Value[8]     <= previous_Value[7];
	previous_Value[7]     <= previous_Value[6];
        previous_Value[6]     <= previous_Value[5];
        previous_Value[5]     <= previous_Value[4];
        previous_Value[4]     <= previous_Value[3];
        previous_Value[3]     <= previous_Value[2];
        previous_Value[2]     <= previous_Value[1];
        previous_Value[1]     <= previous_Value[0];
        previous_Value[0]     <= ADC_Value;

	product[0] <= coeffs[0] * previous_Value[0];
		product[1] <= coeffs[1] * previous_Value[1];
		product[2] <= coeffs[2] * previous_Value[2];
		product[3] <= coeffs[3] * previous_Value[3];
		product[4] <= coeffs[4] * previous_Value[4];
		product[5] <= coeffs[5] * previous_Value[5];
		product[6] <= coeffs[6] * previous_Value[6];
		product[7] <= coeffs[7] * previous_Value[7];
		product[8] <= coeffs[8] * previous_Value[8];
		product[9] <= coeffs[9] * previous_Value[9];
		product[10] <= coeffs[10] * previous_Value[10];
		product[11] <= coeffs[10] * previous_Value[11];
		product[12] <= coeffs[9] * previous_Value[12];
		product[13] <= coeffs[8] * previous_Value[13];
		product[14] <= coeffs[7] * previous_Value[14];
		product[15] <= coeffs[6] * previous_Value[15];
		product[16] <= coeffs[5] * previous_Value[16];
		product[17] <= coeffs[4] * previous_Value[17];
		product[18] <= coeffs[3] * previous_Value[18];
		product[19] <= coeffs[2] * previous_Value[19];
		product[20] <= coeffs[1] * previous_Value[20];
		product[21] <= coeffs[0] * previous_Value[21];	

	 Out_Filtered <= (product[0] + product[1] + 
                              product[2] + product[3] + product[4] + product[5] + 
                              product[6] + product[7] + product[8] + product[9] + 
                              product[10] + product[11] + product[12] + product[13] + 
                              product[14] + product[15] + product[16] + product[17] + 
                              product[18] + product[19] + product[20] + product[21]);
	
		
	end

end
endmodule


