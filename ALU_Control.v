`include "define.v"

module ALU_Control(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);

input   [9:0]   funct_i;
input   [1:0]   ALUOp_i;
output  [2:0]   ALUCtrl_o;

reg     [2:0]   ALUCtrl_o;

always @(*) begin
    if (ALUOp_i == 2'b10) begin // R inst
        case(funct_i)
            10'b0000000111: ALUCtrl_o = 3'b000; //and
            10'b0000000100: ALUCtrl_o = 3'b001; //xor
            10'b0000000001: ALUCtrl_o = 3'b010; //sll
            10'b0000000000: ALUCtrl_o = 3'b011; //add
            10'b0100000000: ALUCtrl_o = 3'b100; //sub
            10'b0000001000: ALUCtrl_o = 3'b101; //mul
        endcase
    end

    else if (ALUOp_i == 2'b00) begin // I or LWSW inst
        case(funct_i[2:0])
            3'b000: ALUCtrl_o = 3'b110; //addi
            3'b101: ALUCtrl_o = 3'b111; //srai
            3'b010: ALUCtrl_o = 3'b011; //lwsw
        endcase
    end

    else if (ALUOp_i == 2'b01) begin
        ALUCtrl_o = 3'b100; //beq
    end
end

endmodule
