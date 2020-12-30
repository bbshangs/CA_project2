module IDEX (
	clk_i,
	ALUOp_i,
    ALUSrc_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    data1_i,
    data2_i,
    imm_i,
    funct_i,
    RS1addr_i,
    RS2addr_i,
    RDaddr_i,
    MemStall_i,

    ALUOp_o,
    ALUSrc_o,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    data1_o,
    data2_o,
    imm_o,
    funct_o,
    RS1addr_o,
    RS2addr_o,
    RDaddr_o
);

input						clk_i;
input			[1:0]		ALUOp_i;
input 						ALUSrc_i, RegWrite_i, MemtoReg_i,MemRead_i, MemWrite_i;
input signed	[31:0]		data1_i, data2_i, imm_i;
input			[9:0]		funct_i;
input			[4:0]		RS1addr_i, RS2addr_i, RDaddr_i;
input 						MemStall_i;

output          [1:0]       ALUOp_o;
output                      ALUSrc_o, RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;
output signed   [31:0]      data1_o, data2_o, imm_o;
output          [9:0]       funct_o;
output          [4:0]       RS1addr_o, RS2addr_o, RDaddr_o;

reg		       	[1:0]		ALUOp_o = 2'b0;
reg 						ALUSrc_o = 1'b0, RegWrite_o = 1'b0, MemtoReg_o = 1'b0, MemRead_o = 1'b0, MemWrite_o = 1'b0;
reg  signed	    [31:0]		data1_o = 32'b0, data2_o = 32'b0, imm_o = 32'b0;
reg			    [9:0]		funct_o = 10'b0;
reg			    [4:0]		RS1addr_o = 5'b0, RS2addr_o = 5'b0, RDaddr_o = 5'b0;


always @(posedge clk_i) begin
    if (~MemStall_i) begin
        // Control Signal
        ALUOp_o <= ALUOp_i;
        ALUSrc_o <= ALUSrc_i;
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;

        //Register Data
        data1_o <= data1_i;
        data2_o <= data2_i;
        imm_o <= imm_i;
        funct_o <= funct_i;
        RS1addr_o <= RS1addr_i;
        RS2addr_o <= RS2addr_i;
        RDaddr_o <= RDaddr_i;
    end
end

endmodule
