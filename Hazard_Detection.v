module Hazard_Detection
(
    data1_i,
    data2_i,
    data3_i,
    MemRead_i,
    PCWrite_o,
    Stall_o,
    NoOp_o
);

input   [4:0]  data1_i;
input   [4:0]  data2_i;
input   [4:0]  data3_i;
input           MemRead_i;
output          PCWrite_o;
output          Stall_o;
output          NoOp_o;

reg             PCWrite_o;
reg             Stall_o;
reg             NoOp_o;

always @(*) begin
    if (MemRead_i && (data1_i == data3_i || data2_i == data3_i)) begin
        PCWrite_o <= 1'b0; // don't update PC
        Stall_o <= 1'b1; // do stall
        NoOp_o <= 1'b1; // no operation
    end

    else begin
        PCWrite_o <= 1'b1;
        Stall_o <= 1'b0;
        NoOp_o <= 1'b0;
    end
end

endmodule
