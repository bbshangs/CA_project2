module If_Branch
(
    data1_i,
    data2_i,
    Branch_i,
    data_o
);

input   signed  [31:0]  data1_i;
input   signed  [31:0]  data2_i;
input                   Branch_i;
output                  data_o;

reg                     data_o;
reg                     compare;

always @(*) begin
    if (data1_i == data2_i)
        compare <= 1'b1;
    else
        compare <= 1'b0;

    data_o <= compare & Branch_i;
end

endmodule
