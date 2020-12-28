module IFID(
	clk_i,
    Stall_i,
    Flush_i,
    PC_i,
    instr_i,
    PC_o,
    instr_o
);

input 			clk_i;
input			Stall_i;
input			Flush_i;
input	[31:0]	PC_i;
input	[31:0]	instr_i;
output	[31:0]	PC_o;
output	[31:0]	instr_o;

reg		[31:0]	PC_o;
reg 	[31:0]	instr_o;

always @(posedge clk_i) begin
	if (Stall_i) begin
		PC_o <= 32'b0;
		instr_o <= instr_o;
	end
	else begin
		PC_o <= PC_i;
		if (Flush_i) begin
			instr_o <= 32'b0;
		end
		else begin
			instr_o <= instr_i;
		end
	end
end

endmodule
