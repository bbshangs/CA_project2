module EXMEM (
	clk_i,
	RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,

    ALUResult_i,
    MUX_B_i,
    RDaddr_i,

    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,

    ALUResult_o,
    MUX_B_o,
    RDaddr_o
);

input 						clk_i;
input						RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i;
input signed	[31:0]		ALUResult_i, MUX_B_i;
input			[4:0]		RDaddr_i;

output						RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;
output signed	[31:0]		ALUResult_o, MUX_B_o;
output			[4:0]		RDaddr_o;

reg							RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;
reg signed		[31:0]		ALUResult_o, MUX_B_o;
reg 			[4:0]		RDaddr_o;

always @(posedge clk_i) begin
	//Stall ?
	RegWrite_o <= RegWrite_i;
	MemtoReg_o <= MemtoReg_i;
	MemRead_o <= MemRead_i;
	MemWrite_o <= MemWrite_i;
	ALUResult_o <= ALUResult_i;
	MUX_B_o <= MUX_B_i;
	RDaddr_o <= RDaddr_i;
end

endmodule