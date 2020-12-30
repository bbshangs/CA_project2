module ALU(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o
);

input   signed  [31:0]  data1_i;
input   signed  [31:0]  data2_i;
input           [2:0]   ALUCtrl_i;
output  signed  [31:0]  data_o;

reg     signed  [31:0]  data_o;

always @(*) begin
	case (ALUCtrl_i)
		3'b000: data_o = data1_i & data2_i; //and
		3'b001: data_o = data1_i ^ data2_i; //xor
		3'b010: data_o = data1_i << data2_i; //sll
		3'b011: data_o = data1_i + data2_i; //add
		3'b100: data_o = data1_i - data2_i; //sub
		3'b101: data_o = data1_i * data2_i; //mul
		3'b110: data_o = data1_i + data2_i; //addi
		3'b111: data_o = data1_i >>> data2_i[4:0]; //srai
	endcase
end

endmodule
