module Imm_Gen(
	data_i,
	data_o
);

input signed	 [31:0] 	data_i;
output signed	 [31:0] 	data_o;

wire			 [6:0] 		opcode;
wire 			 [11:0] 	imme;

assign opcode = data_i[6:0];
assign imme = (opcode == 7'b0010011)? data_i[31:20]:
			(opcode == 7'b0000011)? data_i[31:20]:
			(opcode == 7'b0100011)? {data_i[31:25], data_i[11:7]}:
			{data_i[31], data_i[7], data_i[30:25], data_i[11:8]};

assign data_o = {{20{imme[11]}}, imme[11:0]};

endmodule
