module divider_2(clk, rst, clk_out);
	input clk, rst;
	output reg clk_out;
	always @(posedge clk)
	begin
	if (rst)
		clk_out <= 1'b0;
	else
		clk_out <= ~clk_out;
	end
endmodule