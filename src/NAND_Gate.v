module NAND_Gate(output reg Y, input A, B, rst_n, clk);
always @ (A or B) begin
    if (A == 1'b1 & B == 1'b1) begin
        Y = 1'b0;
    end
    else 
        Y = 1'b1; 
end
endmodule