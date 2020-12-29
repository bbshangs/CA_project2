module MUX2(
	data0_i,
    data1_i,
    data2_i,
    forward_i,
    data_o
);

input	signed	[31:0]	data0_i;
input	signed	[31:0]	data1_i;
input	signed	[31:0]	data2_i;
input			[1:0]	forward_i;
output	signed	[31:0]	data_o;

reg		signed	[31:0]	data_o;

always @(*) begin
	case(forward_i)
		2'b00: data_o = data0_i;
		2'b01: data_o = data1_i;
		2'b10: data_o = data2_i;
	endcase
end

endmodule
