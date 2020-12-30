module CPU
(
    clk_i,
    rst_i,
    start_i,
    mem_data_i,
    mem_ack_i,
    mem_data_o,
    mem_addr_o,
    mem_enable_o,
    mem_write_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

Control Control(
    .Op_i       (IFID.instr_o[6:0]),
    .NoOp_i     (Hazard_Detection.NoOp_o),
    .ALUOp_o    (),
    .ALUSrc_o   (),
    .RegWrite_o (),
    .MemtoReg_o (),
    .MemRead_o  (),
    .MemWrite_o (),
    .Branch_o   ()
);

Adder Add_PC(
    .data1_i   (PC.pc_o),
    .data2_i   (32'd4),
    .data_o     ()
);

Adder Add_PC_Branch(
    .data1_i   (Imm_Gen.data_o<<1),
    .data2_i   (IFID.PC_o),
    .data_o    ()
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i  (Hazard_Detection.PCWrite_o),
    .pc_i       (MUX_PCSource.data_o),
    .pc_o       ()
);

Instruction_Memory Instruction_Memory(
    .addr_i     (PC.pc_o),
    .instr_o    ()
);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (IFID.instr_o[19:15]),
    .RS2addr_i   (IFID.instr_o[24:20]),
    .RDaddr_i   (MEMWB.RDaddr_o),
    .RDdata_i   (MUX_Mem2Reg.data_o),
    .RegWrite_i (MEMWB.RegWrite_o),
    .RS1data_o   (),
    .RS2data_o   ()
);

MUX32 MUX_ALUSrc(
    .data1_i    (MUX_B.data_o),
    .data2_i    (IDEX.imm_o),
    .select_i   (IDEX.ALUSrc_o),
    .data_o     ()
);

MUX32 MUX_Mem2Reg(
    .data1_i   (MEMWB.ALUResult_o),
    .data2_i   (MEMWB.ReadData_o),
    .select_i   (MEMWB.MemtoReg_o),
    .data_o     ()
);

MUX32 MUX_PCSource(
    .data1_i   (Add_PC.data_o),
    .data2_i   (Add_PC_Branch.data_o),
    .select_i   (If_Branch.data_o),
    .data_o     ()
);

MUX2 MUX_A(
    .data0_i  (IDEX.data1_o),
    .data1_i  (MUX_Mem2Reg.data_o),
    .data2_i  (EXMEM.ALUResult_o),
    .forward_i (Forward_Unit.ForwardA_o),
    .data_o    ()
);

MUX2 MUX_B(
    .data0_i  (IDEX.data2_o),
    .data1_i  (MUX_Mem2Reg.data_o),
    .data2_i  (EXMEM.ALUResult_o),
    .forward_i (Forward_Unit.ForwardB_o),
    .data_o    ()
);

Imm_Gen Imm_Gen(
    .data_i     (IFID.instr_o),
    .data_o     ()
);

ALU ALU(
    .data1_i    (MUX_A.data_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     ()
);

ALU_Control ALU_Control(
    .funct_i    (IDEX.funct_o),
    .ALUOp_i    (IDEX.ALUOp_o),
    .ALUCtrl_o  ()
);

/*
Data_Memory Data_Memory(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .addr_i     (dcache_controller.mem_addr_o),
    .enable_i   (dcache_controller.mem_enable_o),
    .write_i    (dcache_controller.mem_write_o),
    .data_i     (dcache_controller.mem_data_o),
    .ack_o      (),
    .data_o     ()
);
*/

dcache_controller dcache_controller(
    // System clock, reset and stall
    .clk_i          (clk_i),
    .rst_i          (rst_i),

    // to Data Memory interface
    .mem_data_i     (Data_Memory.data_o),
    .mem_ack_i      (Data_Memory.ack_o),
    .mem_data_o     (),
    .mem_addr_o     (),
    .mem_enable_o   (),
    .mem_write_o    (),

    // to CPU interface
    .cpu_data_i     (EXMEM.MUX_B_o),
    .cpu_addr_i     (EXMEM.ALUResult_o),
    .cpu_MemRead_i  (EXMEM.MemRead_o),
    .cpu_MemWrite_i (EXMEM.MemWrite_o),

    .cpu_data_o     (),
    .cpu_stall_o    ()

);

Hazard_Detection Hazard_Detection(
    .data1_i    (IFID.instr_o[19:15]),
    .data2_i    (IFID.instr_o[24:20]),
    .data3_i    (IDEX.RDaddr_o),
    .MemRead_i  (IDEX.MemRead_o),
    .PCWrite_o  (),
    .Stall_o    (),
    .NoOp_o     ()
);

Forward_Unit Forward_Unit(
    .MemRegWrite_i  (EXMEM.RegWrite_o),
    .MemRd_i        (EXMEM.RDaddr_o),
    .WBRegWrite_i   (MEMWB.RegWrite_o),
    .WBRd_i         (MEMWB.RDaddr_o),
    .EXRs1_i        (IDEX.RS1addr_o),
    .EXRs2_i        (IDEX.RS2addr_o),
    .ForwardA_o     (),
    .ForwardB_o     ()
);

IFID IFID(
    .clk_i      (clk_i),
    .Stall_i    (Hazard_Detection.Stall_o),
    .Flush_i    (If_Branch.data_o),
    .PC_i       (PC.pc_o),
    .instr_i    (Instruction_Memory.instr_o),
    .MemStall_i (dcache_controller.cpu_stall_o),
    .PC_o       (),
    .instr_o    ()
);

IDEX IDEX(
    .clk_i      (clk_i),
    // Control Input
    .ALUOp_i    (Control.ALUOp_o),
    .ALUSrc_i   (Control.ALUSrc_o),
    .RegWrite_i (Control.RegWrite_o),
    .MemtoReg_i (Control.MemtoReg_o),
    .MemRead_i  (Control.MemRead_o),
    .MemWrite_i (Control.MemWrite_o),
    // Register Data Input
    .data1_i    (Registers.RS1data_o),
    .data2_i    (Registers.RS2data_o),
    .imm_i      (Imm_Gen.data_o),
    .funct_i    ( {IFID.instr_o[31:25], IFID.instr_o[14:12]} ),
    .RS1addr_i  (IFID.instr_o[19:15]),
    .RS2addr_i  (IFID.instr_o[24:20]),
    .RDaddr_i   (IFID.instr_o[11:7]),
    .MemStall_i (dcache_controller.cpu_stall_o),
    // Control Output
    .ALUOp_o    (),
    .ALUSrc_o   (),
    .RegWrite_o (),
    .MemtoReg_o (),
    .MemRead_o  (),
    .MemWrite_o (),
    // Register Data Output
    .data1_o    (),
    .data2_o    (),
    .imm_o      (),
    .funct_o    (),
    .RS1addr_o  (),
    .RS2addr_o  (),
    .RDaddr_o   ()
);

EXMEM EXMEM(
    .clk_i          (clk_i),
    .RegWrite_i     (IDEX.RegWrite_o),
    .MemtoReg_i     (IDEX.MemtoReg_o),
    .MemRead_i      (IDEX.MemRead_o),
    .MemWrite_i     (IDEX.MemWrite_o),
    .ALUResult_i    (ALU.data_o),
    .MUX_B_i        (MUX_B.data_o),
    .RDaddr_i       (IDEX.RDaddr_o),
    .MemStall_i     (dcache_controller.cpu_stall_o),
    .RegWrite_o     (),
    .MemtoReg_o     (),
    .MemRead_o      (),
    .MemWrite_o     (),
    .ALUResult_o    (),
    .MUX_B_o        (),
    .RDaddr_o       ()
);

MEMWB MEMWB(
    .clk_i          (clk_i),
    .RegWrite_i     (EXMEM.RegWrite_o),
    .MemtoReg_i     (EXMEM.MemtoReg_o),
    .ALUResult_i    (EXMEM.ALUResult_o),
    .ReadData_i     (Data_Memory.data_o),
    .RDaddr_i       (EXMEM.RDaddr_o),
    .MemStall_i     (dcache_controller.cpu_stall_o),
    .RegWrite_o     (),
    .MemtoReg_o     (),
    .ALUResult_o    (),
    .ReadData_o     (),
    .RDaddr_o       ()
);

If_Branch If_Branch(
    .data1_i    (Registers.RS1data_o),
    .data2_i    (Registers.RS2data_o),
    .Branch_i   (Control.Branch_o),
    .data_o     ()
);

endmodule
