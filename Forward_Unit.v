module Forward_Unit(
	MemRegWrite_i,
    MemRd_i,
    WBRegWrite_i,
    WBRd_i,
    EXRs1_i,
    EXRs2_i,
    ForwardA_o,
    ForwardB_o
);

input			MemRegWrite_i;
input	[4:0]	MemRd_i;
input			WBRegWrite_i;
input	[4:0]	WBRd_i;
input	[4:0]	EXRs1_i;
input 	[4:0]	EXRs2_i;
output	[1:0]	ForwardA_o;
output	[1:0]	ForwardB_o;

reg 	[1:0]	ForwardA_o;
reg 	[1:0]	ForwardB_o;

always @(*) begin
	//no hazards
	ForwardA_o = 2'b00;
	ForwardB_o = 2'b00;

	//EX-hazard
	if (MemRegWrite_i && (MemRd_i != 5'b0) && (MemRd_i == EXRs1_i)) begin
		ForwardA_o = 2'b10;
	end
	if (MemRegWrite_i && (MemRd_i != 5'b0) && (MemRd_i == EXRs2_i)) begin
		ForwardB_o = 2'b10;
	end

	//MEM-Hazard
	if (WBRegWrite_i && (WBRegWrite_i != 5'b0) &&  !(MemRegWrite_i && (MemRd_i != 5'b0) && (MemRd_i == EXRs1_i)) && (WBRd_i == EXRs1_i)) begin
		ForwardA_o = 2'b01;
	end
	if (WBRegWrite_i && (WBRegWrite_i != 5'b0) &&  !(MemRegWrite_i && (MemRd_i != 5'b0) && (MemRd_i == EXRs2_i)) && (WBRd_i == EXRs2_i)) begin
		ForwardB_o = 2'b01;
	end
end

endmodule

