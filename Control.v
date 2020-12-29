`include "define.v"

module Control(
	Op_i,
	NoOp_i,
	ALUOp_o,
	ALUSrc_o,
	RegWrite_o,
	MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    Branch_o
);

input 	[6:0] 		Op_i;
input 				NoOp_i;

output 	[1:0] 		ALUOp_o;
output 				ALUSrc_o;
output 				RegWrite_o;
output 				MemtoReg_o;
output 				MemRead_o;
output 				MemWrite_o;
output 				Branch_o;

reg 	[1:0] 		ALUOp_o;
reg 				ALUSrc_o;
reg 				RegWrite_o;
reg 				MemtoReg_o;
reg 				MemRead_o;
reg 				MemWrite_o;
reg 				Branch_o;

initial begin
	ALUOp_o = 2'b0;
	ALUSrc_o = 1'b0;
	RegWrite_o = 1'b0;
	MemtoReg_o = 1'b0;
	MemRead_o = 1'b0;
	MemWrite_o = 1'b0;
	Branch_o = 1'b0;
end

always @(*) begin
	if (NoOp_i) begin
		ALUOp_o = 2'b0;
		ALUSrc_o = 1'b0;
		RegWrite_o = 1'b0;
		MemtoReg_o = 1'b0;
		MemRead_o = 1'b0;
		MemWrite_o = 1'b0;
		Branch_o = 1'b0;
	end
	else begin
		case(Op_i)
			7'b0110011: // R inst
				begin
					ALUOp_o = 2'b10;
					ALUSrc_o = 1'b0;
					RegWrite_o = 1'b1;
					MemtoReg_o = 1'b0;
					MemRead_o = 1'b0;
					MemWrite_o = 1'b0;
					Branch_o = 1'b0;
				end
			7'b0010011: // I inst
				begin
					ALUOp_o = 2'b00;
					ALUSrc_o = 1'b1;
					RegWrite_o = 1'b1;
					MemtoReg_o = 1'b0;
					MemRead_o = 1'b0;
					MemWrite_o = 1'b0;
					Branch_o = 1'b0;
				end
			7'b0000011: // LW inst
				begin
					ALUOp_o = 2'b00;
					ALUSrc_o = 1'b1;
					RegWrite_o = 1'b1;
					MemtoReg_o = 1'b1;
					MemRead_o = 1'b1;
					MemWrite_o = 1'b0;
					Branch_o = 1'b0;
				end
			7'b0100011: // SW inst
				begin
					ALUOp_o = 2'b00;
					ALUSrc_o = 1'b1;
					RegWrite_o = 1'b0;
					MemtoReg_o = 1'b0;
					MemRead_o = 1'b0;
					MemWrite_o = 1'b1;
					Branch_o = 1'b0;
				end
			7'b1100011: // BEQ inst
				begin
					ALUOp_o = 2'b01;
					ALUSrc_o = 1'b1;
					RegWrite_o = 1'b0;
					MemtoReg_o = 1'b0;
					MemRead_o = 1'b0;
					MemWrite_o = 1'b0;
					Branch_o = 1'b1;
				end
			default:
				begin
					ALUOp_o = 2'b0;
					ALUSrc_o = 1'b0;
					RegWrite_o = 1'b0;
					MemtoReg_o = 1'b0;
					MemRead_o = 1'b0;
					MemWrite_o = 1'b0;
					Branch_o = 1'b0;
				end
		endcase
	end
end

endmodule
