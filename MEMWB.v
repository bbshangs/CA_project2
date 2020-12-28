module MEMWB (
	clk_i,
	RegWrite_i,
    MemtoReg_i,
    ALUResult_i,
    ReadData_i,
    RDaddr_i,
    RegWrite_o,
    MemtoReg_o,
    ALUResult_o,
    ReadData_o,
    RDaddr_o
);

input						clk_i;
input						RegWrite_i, MemtoReg_i;
input	signed	[31:0]		ALUResult_i, ReadData_i;
input			[4:0]		RDaddr_i;

output						RegWrite_o, MemtoReg_o;
output	signed	[31:0]		ALUResult_o, ReadData_o;
output			[4:0]		RDaddr_o;

reg 						RegWrite_o, MemtoReg_o;
reg 	signed	[31:0]		ALUResult_o, ReadData_o;
reg 			[4:0]		RDaddr_o;

always @(posedge clk_i) begin
	RegWrite_o <= RegWrite_i;
	MemtoReg_o <= MemtoReg_i;
	ALUResult_o <= ALUResult_i;
	ReadData_o <= ReadData_i;
	RDaddr_o <= RDaddr_i;
end
endmodule