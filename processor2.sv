
module processor2(
	clk,
	reset,
	board_number,
	address_bus,
	arbitrator_addr_bus_request,
	data_bus_request,
	addr_bus_flow_control,
	addr_bus_flow_control_reg,
	data_bus,
	data_bus_id,
	data_bus_addr,

	//signals from bus
	addr_bus_gain,
	data_bus_gain,
	addr_data_arbitration,
	or_addr_bus_flow_control
);

	input clk,reset;
	input [2:0]board_number;
	inout           [36:0] address_bus;//32 bit addr + 2 bit cmd + 3 bit board number 
	output logic    addr_bus_flow_control;
	output logic    addr_bus_flow_control_reg;
	input           or_addr_bus_flow_control;
	output logic    arbitrator_addr_bus_request;//ask for addr bus access
	output logic    data_bus_request;//ask for data bus access
	input           addr_data_arbitration;
	input           addr_bus_gain;//0 if no gain, 1 if granted
	input           data_bus_gain;//0 if no gain, 1 if granted
	inout           [511:0] data_bus;//32bytes need two cycles to transfer a block
	inout           [2:0]data_bus_id;
	inout           [31:0]data_bus_addr;
	//instruction fetch stage
	//in
	logic [31:0]pc_in;
	//out
	logic [31:0]instruction_1;
	logic [31:0]instruction_2;
	logic [31:0]pc_1,pc_2;
	//pc
	logic flush_signal;

	//decode stage
	//in
	//after instruction reg
	logic [31:0]instruction_1_reg;
	logic [31:0]instruction_2_reg;
	logic [31:0]pc_1_reg;
	logic [31:0]pc_2_reg;
	
	//instruction 1 and 2
	//decode output

	//first instruction
	logic [10:0]opcode_1;//opcode
	logic [6:0] immediate_7_bit_1;//immediates
	logic [7:0] immediate_8_bit_1;
	logic [9:0] immediate_10_bit_1;
	logic [15:0] immediate_16_bit_1;
	logic [17:0] immediate_18_bit_1;
	logic write_signal_load_store_1;//write enable to local memory
	logic [6:0] addr_reg_1,addr_reg_2,addr_reg_3;//three read address
	logic [6:0] write_reg_addr_reg_1;//one write address
	logic reg_read_signal_1,reg_write_signal_1;//read and write enable for register file
	logic instruction_parity_1;//parity of the instruction
	logic [3:0] instruction_latency_1;
	//second instruction
	logic [10:0] opcode_2;
	logic [6:0] immediate_7_bit_2;
	logic [7:0] immediate_8_bit_2;
	logic [9:0] immediate_10_bit_2;
	logic [15:0] immediate_16_bit_2;
	logic [17:0] immediate_18_bit_2;
	logic write_signal_load_store_2;
	logic [6:0] addr_reg_4,addr_reg_5,addr_reg_6;
	logic [6:0] write_reg_addr_reg_2;
	logic reg_read_signal_2,reg_write_signal_2;
	logic instruction_parity_2;
	logic [3:0] instruction_latency_2;
	//dependent stage checks data hazard with stall
	//wire
	logic [3:0] delay_1,delay_2,delay_3,delay_4,delay_5,delay_6;
	//output
	logic both_stall,single_stall;
	logic cache_stall;
	logic single_stall_reg;
	//issue & route
	//out
	logic same_parity;
	logic [31:0] pc_odd;
	logic [10:0] opcode_odd;
	logic [6:0] immediate_7_bit_odd;
	logic [7:0] immediate_8_bit_odd;
	logic [9:0] immediate_10_bit_odd;
	logic [15:0] immediate_16_bit_odd;
	logic [17:0] immediate_18_bit_odd;
	logic write_signal_load_store_odd;
	logic [6:0] addr_reg_1_odd,addr_reg_2_odd,addr_reg_3_odd;
	logic [6:0] write_reg_addr_reg_odd;
	logic reg_read_signal_odd,reg_write_signal_odd;
	logic [3:0] instruction_latency_odd;

	logic [10:0] opcode_even;
	logic [31:0] pc_even;
	logic [6:0] immediate_7_bit_even;
	logic [7:0] immediate_8_bit_even;
	logic [9:0] immediate_10_bit_even;
	logic [15:0] immediate_16_bit_even;
	logic [17:0] immediate_18_bit_even;
	logic write_signal_load_store_even;
	logic [6:0] addr_reg_1_even,addr_reg_2_even,addr_reg_3_even;
	logic [6:0] write_reg_addr_reg_even;
	logic reg_read_signal_even,reg_write_signal_even;
	logic [3:0] instruction_latency_even;
	//register stage
	//in
	logic [31:0] pc_odd_reg;
	logic [6:0] immediate_7_bit_odd_reg;
	logic [7:0] immediate_8_bit_odd_reg;
	logic [9:0] immediate_10_bit_odd_reg;
	logic [15:0] immediate_16_bit_odd_reg;
	logic [17:0] immediate_18_bit_odd_reg;
	logic [10:0] opcode_odd_reg;
	logic write_signal_load_store_odd_reg;
	logic [6:0] addr_reg_1_odd_reg,addr_reg_2_odd_reg,addr_reg_3_odd_reg;
	logic [6:0] write_reg_addr_reg_odd_reg;
	logic reg_read_signal_odd_reg,reg_write_signal_odd_reg;

	logic [31:0]pc_even_reg;
	logic [6:0] immediate_7_bit_even_reg;
	logic [7:0] immediate_8_bit_even_reg;
	logic [9:0] immediate_10_bit_even_reg;
	logic [15:0] immediate_16_bit_even_reg;
	logic [17:0] immediate_18_bit_even_reg;
	logic [10:0] opcode_even_reg;
	logic write_signal_load_store_even_reg;
	logic [6:0] addr_reg_1_even_reg,addr_reg_2_even_reg,addr_reg_3_even_reg;
	logic [6:0] write_reg_addr_reg_even_reg;
	logic reg_read_signal_even_reg,reg_write_signal_even_reg;
	
	//out
	logic[127:0] data_1_op_after_reg,data_2_op_after_reg,data_3_op_after_reg;
	logic[127:0] data_1_ep_after_reg,data_2_ep_after_reg,data_3_ep_after_reg;

	//feedforward logic 
	//input
	logic[6:0] fw_addr_ep1,fw_addr_ep2,fw_addr_ep3,fw_addr_ep4,fw_addr_ep5,fw_addr_ep6,fw_addr_ep7,fw_addr_ep8;
	logic[6:0] fw_addr_op1,fw_addr_op2,fw_addr_op3,fw_addr_op4,fw_addr_op5,fw_addr_op6,fw_addr_op7,fw_addr_op8,fw_addr_op9;

	logic[127:0] fw_data_ep1,fw_data_ep2,fw_data_ep3,fw_data_ep4,fw_data_ep5,fw_data_ep6,fw_data_ep7,fw_data_ep8;
	logic[127:0] fw_data_op1,fw_data_op2,fw_data_op3,fw_data_op4,fw_data_op5,fw_data_op6,fw_data_op7,fw_data_op8,fw_data_op9;
	//output
	logic[127:0] data_1_op_after_fw,data_2_op_after_fw,data_3_op_after_fw;
	logic[127:0] data_1_ep_after_fw,data_2_ep_after_fw,data_3_ep_after_fw;

	//operation stage 1
	//in
	//odd
	logic [6:0] immediate_7_bit_reg_op;
	logic [7:0] immediate_8_bit_reg_op;
	logic [9:0] immediate_10_bit_reg_op;
	logic [15:0] immediate_16_bit_reg_op;
	logic [17:0] immediate_18_bit_reg_op;
	logic [10:0] opcode_reg_op;
	logic write_signal_load_store_reg_op;//write to data memory not register file
	logic [31:0] pc_in_reg_op;
	logic reg_write_signal_op;
	logic [6:0] write_reg_addr_reg_op;

	//even
	logic [6:0] immediate_7_bit_reg_ep;
	logic [7:0] immediate_8_bit_reg_ep;
	logic [9:0] immediate_10_bit_reg_ep;
	logic [15:0] immediate_16_bit_reg_ep;
	logic [17:0] immediate_18_bit_reg_ep;
	logic [10:0] opcode_reg_ep;
	logic write_signal_load_store_reg_ep;
	logic [31:0] pc_in_reg_ep;
	logic reg_write_signal_ep;
	logic [6:0] write_reg_addr_reg_ep;

	logic[127:0] data_1_op_after_fw_reg,data_2_op_after_fw_reg,data_3_op_after_fw_reg;
	logic[127:0] data_1_ep_after_fw_reg,data_2_ep_after_fw_reg,data_3_ep_after_fw_reg;
	
	assign even_is_first_signal=(pc_in_reg_ep<pc_in_reg_op)?1:0;
	//out

	logic [127:0] result_1;//simply fixed 1
	logic [127:0] result_2;//simply fixed 2
	logic [127:0] result_3;//float point
	logic [127:0] result_4;//byte
	logic [127:0] result_5;//branch
	logic [127:0] result_6;//permute
	logic [127:0] result_7;//local store
	//branch
	logic [31:0] correct_pc;
	logic stop;
	logic branch_signal;
	logic real_take_or_not_signal;


	logic [127:0] result_1_reg_1;
	logic [127:0] result_2_reg_1;
	logic [127:0] result_3_reg_1;
	logic [127:0] result_4_reg_1;
	logic [127:0] result_5_reg_1;
	logic [127:0] result_6_reg_1;
	logic [127:0] result_7_reg_1;
	logic[6:0]result_addr_ep1;
	logic[6:0]result_addr_op1;
	logic reg_write_signal_ep1;
	logic reg_write_signal_op1;

	//operation stage 2
	//out
	logic [127:0] result_1_reg_2;
	logic [127:0] result_2_reg_2;
	logic [127:0] result_3_reg_2;
	logic [127:0] result_4_reg_2;
	logic [127:0] result_6_reg_2;
	logic [127:0] result_7_reg_2;
	logic [6:0]result_addr_ep2;
	logic [6:0]result_addr_op2;
	logic reg_write_signal_ep2;
	logic reg_write_signal_op2;
	//operation stage 3
	//out
	logic [127:0] result_1_reg_3;
	logic [127:0] result_2_reg_3;
	logic [127:0] result_3_reg_3;
	logic [127:0] result_4_reg_3;
	logic [127:0] result_6_reg_3;
	logic [127:0] result_7_reg_3;
	logic[6:0]result_addr_ep3;
	logic[6:0]result_addr_op3;
	logic reg_write_signal_ep3;
	logic reg_write_signal_op3;

	//operation stage 4
	//out
	logic [127:0] result_1_reg_4;
	logic [127:0] result_2_reg_4;
	logic [127:0] result_3_reg_4;
	logic [127:0] result_4_reg_4;
	logic[6:0]result_addr_ep4;
	logic[6:0]result_addr_op4;
	logic reg_write_signal_ep4;
	logic reg_write_signal_op4;
	//operation stage 5
	//out
	logic [127:0] result_1_reg_5;
	logic [127:0] result_2_reg_5;
	logic [127:0] result_3_reg_5;
	logic [127:0] result_4_reg_5;
	logic[6:0]result_addr_ep5;
	logic[6:0]result_addr_op5;
	logic reg_write_signal_ep5;
	logic reg_write_signal_op5;
	//operation stage 6
	//out
	logic [127:0] result_1_reg_6;
	logic [127:0] result_2_reg_6;
	logic [127:0] result_3_reg_6;
	logic [127:0] result_4_reg_6;
	logic[6:0]result_addr_ep6;
	logic[6:0]result_addr_op6;
	logic reg_write_signal_ep6;
	logic reg_write_signal_op6;
	//operation stage 7
	//out
	logic [127:0] result_1_reg_7;
	logic [127:0] result_2_reg_7;
	logic [127:0] result_3_reg_7;
	logic[6:0]result_addr_ep7;
	logic[6:0]result_addr_op7;
	logic reg_write_signal_ep7;
	logic reg_write_signal_op7;
	//operation stage 8
	//out
	logic [127:0] result_1_reg_8;
	logic [127:0] result_2_reg_8;
	logic[6:0]result_addr_ep8;
	logic[6:0]result_addr_op8;
	logic reg_write_signal_ep8;
	logic reg_write_signal_op8;

	logic [127:0] data_after_fwe3;
	logic [127:0] data_after_fwe6;
	logic [127:0] data_after_fwe7;
	logic [127:0] data_after_fwo1;
	logic [127:0] data_after_fwo6;

	//instruction fetch
	instruction_cache_2 i1(
	.clk(clk),
	.reset(reset),
	.pc(pc_in),
	.instruction_out_1(instruction_1),
	.instruction_out_2(instruction_2),
	.pc_1(pc_1),
	.pc_2(pc_2));
	//branch prediction && pc control
	
	branch_prediction_correlated branch_and_predict1
	(
	.clk(clk),
	.reset(reset),
	.single_stall(single_stall),
	.both_stall(both_stall),
	.same_parity(same_parity),
	.old_pc_from_decode_stage(pc_1_reg),
	.feedback_pc_from_branch_stage(pc_in_reg_op),
	.correct_pc(correct_pc),
	.real_take_or_not_signal(real_take_or_not_signal),
	.branch_signal(branch_signal),
	.cache_stall(cache_stall),
	.flush_signal(flush_signal),
	.pc(pc_in)
	);







	//decode 
	decode d1(
	.instruction_in(instruction_1_reg),
	.immediate_7_bit(immediate_7_bit_1),
	.immediate_8_bit(immediate_8_bit_1),
	.immediate_10_bit(immediate_10_bit_1),
	.immediate_16_bit(immediate_16_bit_1),
	.immediate_18_bit(immediate_18_bit_1),
	.opcode(opcode_1),
	.addr_reg_1(addr_reg_1),
	.addr_reg_2(addr_reg_2),
	.addr_reg_3(addr_reg_3),
	.write_signal_load_store(write_signal_load_store_1),
	.write_reg_addr_reg(write_reg_addr_reg_1),
	.reg_read_signal(reg_read_signal_1),
	.reg_write_signal(reg_write_signal_1),
	.instruction_parity(instruction_parity_1),
	.instruction_latency(instruction_latency_1));
	
	//decode
	decode d2(
	.instruction_in(instruction_2_reg),
	.immediate_7_bit(immediate_7_bit_2),
	.immediate_8_bit(immediate_8_bit_2),
	.immediate_10_bit(immediate_10_bit_2),
	.immediate_16_bit(immediate_16_bit_2),
	.immediate_18_bit(immediate_18_bit_2),
	.opcode(opcode_2),
	.addr_reg_1(addr_reg_4),
	.addr_reg_2(addr_reg_5),
	.addr_reg_3(addr_reg_6),
	.write_signal_load_store(write_signal_load_store_2),
	.write_reg_addr_reg(write_reg_addr_reg_2),
	.reg_read_signal(reg_read_signal_2),
	.reg_write_signal(reg_write_signal_2),
	.instruction_parity(instruction_parity_2),
	.instruction_latency(instruction_latency_2));
	
	dependence dep1(
	.read_enable_signal_1(reg_read_signal_1),
	.read_enable_signal_2(reg_read_signal_2),
	.write_enable_signal_1(reg_write_signal_1),
	.write_enable_signal_2(reg_write_signal_2),
	.avaiable_counter_1(delay_1),
	.avaiable_counter_2(delay_2),
	.avaiable_counter_3(delay_3),
	.avaiable_counter_4(delay_4),
	.avaiable_counter_5(delay_5),
	.avaiable_counter_6(delay_6),
	.addr_reg_1(addr_reg_1),
	.addr_reg_2(addr_reg_2),
	.addr_reg_3(addr_reg_3),
	.addr_reg_4(addr_reg_4),
	.addr_reg_5(addr_reg_5),
	.addr_reg_6(addr_reg_6),
	.write_reg_addr_reg_1(write_reg_addr_reg_1),
	.write_reg_addr_reg_2(write_reg_addr_reg_2),
	.both_stall(both_stall),
	.single_stall(single_stall),
	.single_stall_reg(single_stall_reg)
	);
	
	issue issue1(
	.cache_stall(cache_stall),
	.clk(clk),
	.reset(reset),
	.flush_signal(flush_signal),
	.both_stall(both_stall),
	.single_stall(single_stall),
	.same_parity(same_parity),
	.pc_1(pc_1_reg),
	.immediate_7_bit_1(immediate_7_bit_1),
	.immediate_8_bit_1(immediate_8_bit_1),
	.immediate_10_bit_1(immediate_10_bit_1),
	.immediate_16_bit_1(immediate_16_bit_1),
	.immediate_18_bit_1(immediate_18_bit_1),
	.opcode_1(opcode_1),
	.addr_reg_1(addr_reg_1),
	.addr_reg_2(addr_reg_2),
	.addr_reg_3(addr_reg_3),
	.write_reg_addr_reg_1(write_reg_addr_reg_1),
	.reg_read_signal_1(reg_read_signal_1),
	.reg_write_signal_1(reg_write_signal_1),
	.instruction_parity_1(instruction_parity_1),
	.write_signal_load_store_1(write_signal_load_store_1),
	.instruction_latency_1(instruction_latency_1),
	.pc_2(pc_2_reg),
	.immediate_7_bit_2(immediate_7_bit_2),
	.immediate_8_bit_2(immediate_8_bit_2),
	.immediate_10_bit_2(immediate_10_bit_2),
	.immediate_16_bit_2(immediate_16_bit_2),
	.immediate_18_bit_2(immediate_18_bit_2),
	.opcode_2(opcode_2),
	.addr_reg_4(addr_reg_4),
	.addr_reg_5(addr_reg_5),
	.addr_reg_6(addr_reg_6),
	.write_reg_addr_reg_2(write_reg_addr_reg_2),
	.reg_read_signal_2(reg_read_signal_2),
	.reg_write_signal_2(reg_write_signal_2),
	.instruction_parity_2(instruction_parity_2),
	.write_signal_load_store_2(write_signal_load_store_2),
	.instruction_latency_2(instruction_latency_2),
	//output
	.pc_odd(pc_odd),
	.immediate_7_bit_odd(immediate_7_bit_odd),
	.immediate_8_bit_odd(immediate_8_bit_odd),
	.immediate_10_bit_odd(immediate_10_bit_odd),
	.immediate_16_bit_odd(immediate_16_bit_odd),
	.immediate_18_bit_odd(immediate_18_bit_odd),
	.opcode_odd(opcode_odd),
	.addr_reg_1_odd(addr_reg_1_odd),
	.addr_reg_2_odd(addr_reg_2_odd),
	.addr_reg_3_odd(addr_reg_3_odd),
	.write_signal_load_store_odd(write_signal_load_store_odd),
	.write_reg_addr_reg_odd(write_reg_addr_reg_odd),
	.reg_read_signal_odd(reg_read_signal_odd),
	.reg_write_signal_odd(reg_write_signal_odd),
	.instruction_latency_odd(instruction_latency_odd),
	.pc_even(pc_even),
	.immediate_7_bit_even(immediate_7_bit_even),
	.immediate_8_bit_even(immediate_8_bit_even),
	.immediate_10_bit_even(immediate_10_bit_even),
	.immediate_16_bit_even(immediate_16_bit_even),
	.immediate_18_bit_even(immediate_18_bit_even),
	.opcode_even(opcode_even),
	.addr_reg_1_even(addr_reg_1_even),
	.addr_reg_2_even(addr_reg_2_even),
	.addr_reg_3_even(addr_reg_3_even),
	.write_signal_load_store_even(write_signal_load_store_even),
	.write_reg_addr_reg_even(write_reg_addr_reg_even),
	.reg_read_signal_even(reg_read_signal_even),
	.reg_write_signal_even(reg_write_signal_even),
	.instruction_latency_even(instruction_latency_even));
	
	//scoreboard
	scoreboard scoreboard1
    (
	//signals for flush
	.cache_stall(cache_stall),
	.flush_signal(flush_signal),
	.write_signal_op_rf(reg_write_signal_odd_reg),
	.write_signal_ep_rf(reg_write_signal_even_reg),
	.write_signal_ep_first_stage(write_signal_ep),
	.write_addr_op_rf(write_reg_addr_reg_odd_reg),
	.write_addr_ep_rf(write_reg_addr_reg_even_reg),
	.write_addr_ep_first_stage(write_reg_addr_reg_ep),
	.even_is_first_signal(even_is_first_signal),
	//normal scoreboard write and read
	.clk(clk),
	.reset(reset),
	.read_addr_reg_1(addr_reg_1),
	.read_addr_reg_2(addr_reg_2),
	.read_addr_reg_3(addr_reg_3),
	.read_addr_reg_4(addr_reg_4),
	.read_addr_reg_5(addr_reg_5),
	.read_addr_reg_6(addr_reg_6),
	.read_reg_signal_1(reg_read_signal_1),
	.read_reg_signal_2(reg_read_signal_2),
	.instruction_latency_op(instruction_latency_odd),
	.instruction_latency_ep(instruction_latency_even),
	.write_addr_op(write_reg_addr_reg_odd),
	.write_signal_op(reg_write_signal_odd),
	.write_addr_ep(write_reg_addr_reg_even),
	.write_signal_ep(reg_write_signal_even),
	.counter_1(delay_1),
	.counter_2(delay_2),
	.counter_3(delay_3),
	.counter_4(delay_4),
	.counter_5(delay_5),
	.counter_6(delay_6));
	//register 
	
	register r1(
	.clk(clk),
	.reset(reset),
	.read_signal_1(reg_read_signal_odd_reg),
	.read_signal_2(reg_read_signal_even_reg),
	.write_signal_1(reg_write_signal_ep8),
	.write_signal_2(reg_write_signal_op8),
	.data_read_1(data_1_op_after_reg),
	.data_read_2(data_2_op_after_reg),
	.data_read_3(data_3_op_after_reg),
	.data_read_4(data_1_ep_after_reg),
    .data_read_5(data_2_ep_after_reg),
    .data_read_6(data_3_ep_after_reg),
    .data_write_1(result_1_reg_8),
    .data_write_2(result_2_reg_8),
    .read_addr_1(addr_reg_1_odd_reg),
    .read_addr_2(addr_reg_2_odd_reg),
    .read_addr_3(addr_reg_3_odd_reg),
    .read_addr_4(addr_reg_1_even_reg),
    .read_addr_5(addr_reg_2_even_reg),
    .read_addr_6(addr_reg_3_even_reg),
    .write_addr_1(result_addr_ep8),
    .write_addr_2(result_addr_op8));
    
	//forwarding unit
	forwarding_unit fw1(
	.addr_1_odd(addr_reg_1_odd_reg),
	.addr_2_odd(addr_reg_2_odd_reg),
	.addr_3_odd(addr_reg_3_odd_reg),
	.addr_1_even(addr_reg_1_even_reg),
	.addr_2_even(addr_reg_2_even_reg),
	.addr_3_even(addr_reg_3_even_reg),

	.data_in_1_odd(data_1_op_after_reg),
	.data_in_2_odd(data_2_op_after_reg),
	.data_in_3_odd(data_3_op_after_reg),
	.data_in_1_even(data_1_ep_after_reg),
	.data_in_2_even(data_2_ep_after_reg),
	.data_in_3_even(data_3_ep_after_reg),

	.forward_addr_ep1(fw_addr_ep1),
	.forward_addr_ep2(fw_addr_ep2),
	.forward_addr_ep3(fw_addr_ep3),
	.forward_addr_ep4(fw_addr_ep4),
	.forward_addr_ep5(fw_addr_ep5),
	.forward_addr_ep6(fw_addr_ep6),
	.forward_addr_ep7(fw_addr_ep7),
	.forward_addr_ep8(fw_addr_ep8),

	.forward_addr_op1(fw_addr_op1),
	.forward_addr_op2(fw_addr_op2),
	.forward_addr_op3(fw_addr_op3),
	.forward_addr_op4(fw_addr_op4),
	.forward_addr_op5(fw_addr_op5),
	.forward_addr_op6(fw_addr_op6),
	.forward_addr_op7(fw_addr_op4),
	.forward_addr_op8(fw_addr_op5),
	.forward_addr_op9(fw_addr_op6),

	.forward_data_ep1(fw_data_ep1),
	.forward_data_ep2(fw_data_ep2),
	.forward_data_ep3(fw_data_ep3),
	.forward_data_ep4(fw_data_ep4),
	.forward_data_ep5(fw_data_ep5),
	.forward_data_ep6(fw_data_ep6),
	.forward_data_ep7(fw_data_ep7),
	.forward_data_ep8(fw_data_ep8),
	
	.forward_data_op1(fw_data_op1),
	.forward_data_op2(fw_data_op2),
	.forward_data_op3(fw_data_op3),
	.forward_data_op4(fw_data_op4),
	.forward_data_op5(fw_data_op5),
	.forward_data_op6(fw_data_op6),
	.forward_data_op7(fw_data_op4),
	.forward_data_op8(fw_data_op5),
	.forward_data_op9(fw_data_op6),
	
	.data_out_1_odd(data_1_op_after_fw),
	.data_out_2_odd(data_2_op_after_fw),
	.data_out_3_odd(data_3_op_after_fw),
	.data_out_1_even(data_1_ep_after_fw),
	.data_out_2_even(data_2_ep_after_fw),
	.data_out_3_even(data_3_ep_after_fw));
	
	//odd pipeline
	branch branch1(
	.opcode(opcode_reg_op),
	.pc_in(pc_in_reg_op),
	.ra(data_1_op_after_fw_reg),
	.rc(data_3_op_after_fw_reg),
	.immediate(immediate_16_bit_reg_op),
	.pc(correct_pc),
	.branch_jump_signal(branch_signal),
	.take_or_not(real_take_or_not_signal),
	.stop(stop),
	.result(result_5));

	permute permute1(
	.opcode(opcode_reg_op),
	.ra(data_1_op_after_fw_reg),
	.rb(data_2_op_after_fw_reg),
	.imm_7bits(immediate_7_bit_reg_op),
	.result(result_6));

	/*
	load_store ls1(
	.clk(clk),
	.reset(reset),
	.opcode(opcode_reg_op),
	.ra(data_1_op_after_fw_reg),
	.rb(data_2_op_after_fw_reg),
	.rc(data_3_op_after_fw_reg),
	.immediate(immediate_10_bit_reg_op),
	.result(result_7),
	.write_signal(write_signal_load_store_reg_op)
	.cache_stall(cache_stall)
	);
	*/
	logic [10:0]opcode;
	logic [127:0] ra;
	logic [127:0] rb;
	logic [127:0] rc;
	logic [9:0]cache_immediate;
	logic write_signal;
	logic LL_bit;
	logic load_link;
	logic store_conditional;
	logic return_load_link_state;
	logic invalidate_signal;

	assign opcode=opcode_reg_op;
	assign ra=data_1_op_after_fw_reg;
	assign rb=data_2_op_after_fw_reg;
	assign rc=data_3_op_after_fw_reg;
	assign cache_immediate=immediate_10_bit_reg_op;
	assign write_signal=write_signal_load_store_reg_op;

	logic [31:0]p_to_cache_address;
	logic p_to_cache_read_en;
	logic [127:0]p_to_cache_data;
	logic [127:0]cache_to_p_data;

	always_ff @(posedge clk or posedge reset) begin
		if(reset) begin
			LL_bit <= 0;
		end 
		else 
		begin
			if(opcode_reg_op==00101000100)
				//wait until cache state is in shared or owned
			begin
				if(return_load_link_state==1'b1)
					LL_bit <= 1;
			end
			else
			begin
				if(invalidate_signal==1'b1)//invalidate
					LL_bit <= 0;
			end
		end
	end

	//writeback cache
	always_comb
	begin
		case (opcode_reg_op) 
			11'b00110100xxx:  //Load Quadword (d-form)
			begin
				assign p_to_cache_address=({{18{cache_immediate[9]}},cache_immediate,4'b0000}+ra[127:96])&32'hfffffff0;
				assign p_to_cache_read_en=1;
				assign p_to_cache_data=0;
				assign store_conditional=1'b0;
				assign load_link=1'b0;
			end
			11'b00111000100 : //Load Quadword (x-form)
			begin
				assign p_to_cache_address=(ra[127:96]+rb[127:96])&32'hfffffff0;
				assign p_to_cache_read_en=1;
				assign p_to_cache_data=0;
				assign store_conditional=1'b0;
				assign load_link=1'b0;
			end
			11'b00100100xxx : //Store Quadword (d-form)
			begin
				assign p_to_cache_address=({{18{cache_immediate[9]}},cache_immediate,4'b0000}+ra[127:96])&32'hfffffff0;
				assign p_to_cache_read_en=0;
				assign p_to_cache_data=rc;
				assign store_conditional=1'b0;
				assign load_link=1'b0;
			end
			11'b00101000100 :  //Store Quadword (x-form)
			begin

				assign p_to_cache_address=(ra[127:96]+rb[127:96])&32'hfffffff0;
				assign p_to_cache_read_en=0;
				assign p_to_cache_data=rc;
				assign store_conditional=1'b0;
				assign load_link=1'b0;
			end
			11'b00101000100 :  //store conditional
			begin
				assign p_to_cache_address=({{18{cache_immediate[9]}},cache_immediate,4'b0000}+ra[127:96])&32'hfffffff0;
				assign p_to_cache_read_en=0;
				assign p_to_cache_data=rc;
				assign store_conditional=1'b1;
				assign load_link=1'b0;

			end
			11'b00101000100 :  //load link
			begin
				assign p_to_cache_address=({{18{cache_immediate[9]}},cache_immediate,4'b0000}+ra[127:96])&32'hfffffff0;
				assign p_to_cache_read_en=1;
				assign p_to_cache_data=0;
				assign store_conditional=1'b0;
				assign load_link=1'b1;
			end
			11'b00000000001 : //No Operation (Load)
			begin 
				assign p_to_cache_address=0;
				assign p_to_cache_read_en=0;
				assign p_to_cache_data=0;
				assign store_conditional=1'b0;
				assign load_link=1'b0;
			end 
		default: 
		begin
			assign p_to_cache_address=0;
			assign p_to_cache_read_en=0;
			assign p_to_cache_data=0;
			assign store_conditional=1'b0;
			assign load_link=1'b0;
		end
		endcase
	end

	write_back_cache cache(
	.clk(clk),    
	.rst(reset),    
	.board_number(board_number),
	.p_read_en(p_to_cache_read_en),
	.p_write_en(write_signal_load_store_reg_op),
	.p_addr_byte(p_to_cache_address),
	.p_to_cache_data(p_to_cache_data),
	.cache_to_p_data(result_7),
	.cache_stall(cache_stall),
	.address_bus(address_bus),
	.arbitrator_addr_bus_request(arbitrator_addr_bus_request),
	.data_bus_request(data_bus_request),
	.addr_bus_flow_control(addr_bus_flow_control),
	.addr_bus_flow_control_reg(addr_bus_flow_control_reg),
	.data_bus(data_bus),
	.data_bus_addr(data_bus_addr),
	.data_bus_id(data_bus_id),
	.addr_bus_gain(addr_bus_gain),
	.data_bus_gain(data_bus_gain),
	.addr_data_arbitration(addr_data_arbitration),
	.or_addr_bus_flow_control(or_addr_bus_flow_control),
	.return_load_link_state(return_load_link_state),
	.store_conditional_fail(store_conditional_fail),
	.store_conditional(store_conditional),
	.load_link(load_link),
	.invalidate_signal(invalidate_signal)
	);

	//even pipeline
	simple_fixed_1 sf1(
	.opcode(opcode_reg_ep),
	.ra(data_1_ep_after_fw_reg),
	.rb(data_2_ep_after_fw_reg),
	.rc(data_3_ep_after_fw_reg),
	.immediate_10bit(immediate_10_bit_reg_ep),
	.immediate_16bit(immediate_16_bit_reg_ep),
	.immediate_18bit(immediate_18_bit_reg_ep),
	.result(result_1));

	simple_fixed_2 sf2(
	.opcode(opcode_reg_op),
	.ra(data_1_ep_after_fw_reg),
	.rb(data_2_ep_after_fw_reg),
	.immediate(immediate_7_bit_reg_ep),
	.result(result_2));

	floating_point fp1(
	.opcode(opcode_reg_ep),
	.ra(data_1_ep_after_fw_reg),
	.rb(data_2_ep_after_fw_reg),
	.rc(data_3_ep_after_fw_reg),
	.immediate(immediate_8_bit_reg_ep),
	.immediate_10_bits(immediate_10_bit_reg_ep),
	.result(result_3));

	byte_op b1(
	.opcode(opcode_reg_ep),
	.ra(data_1_ep_after_fw_reg),
	.rb(data_2_ep_after_fw_reg),
	.result(result_4));
	 
	//pipeline stages and delay signals 
	//address
	assign fw_addr_ep1=result_addr_ep1;
	assign fw_addr_ep2=result_addr_ep2;
	assign fw_addr_ep3=result_addr_ep3;
	assign fw_addr_ep4=result_addr_ep4;
	assign fw_addr_ep5=result_addr_ep5;
	assign fw_addr_ep6=result_addr_ep6;
	assign fw_addr_ep7=result_addr_ep7;
	assign fw_addr_ep8=result_addr_ep8;//write back stage even pipe

	assign fw_addr_op1=write_reg_addr_reg_op;
	assign fw_addr_op2=result_addr_op1;
	assign fw_addr_op3=result_addr_op2;
	assign fw_addr_op4=result_addr_op3;
	assign fw_addr_op5=result_addr_op4;
	assign fw_addr_op6=result_addr_op5;
	assign fw_addr_op7=result_addr_op6;
	assign fw_addr_op8=result_addr_op7;
	assign fw_addr_op9=result_addr_op8;//write back stage odd pipe
	
	//
	assign fw_data_ep1=result_1_reg_1;
	assign fw_data_ep2=result_1_reg_2;
	assign fw_data_ep3=data_after_fwe3;
	assign fw_data_ep4=result_1_reg_4;
	assign fw_data_ep5=data_after_fwe6;
	assign fw_data_ep6=data_after_fwe7;
	assign fw_data_ep7=result_1_reg_7;
	assign fw_data_ep8=result_1_reg_8;


	assign fw_data_op1=result_5;
	assign fw_data_op2=result_5_reg_1;
	assign fw_data_op3=data_after_fwo1;
	assign fw_data_op4=result_6_reg_3;
	assign fw_data_op5=result_3_reg_4;
	assign fw_data_op6=result_3_reg_5;
	assign fw_data_op7=data_after_fwo6;
	assign fw_data_op8=result_2_reg_7;
	assign fw_data_op9=result_2_reg_8;
	

	always_ff @(posedge clk or posedge reset) begin 
		if(reset) 
		begin
			//instruction_reg
			pc_2_reg<=0;
			pc_1_reg<=0;
			instruction_1_reg<=32'b00000000001000000000000000000000;//no op
			instruction_2_reg<=32'b01000000001000000000000000000000;//no op

			//decode dep issue and route
			pc_odd_reg<=0;
			immediate_7_bit_odd_reg<=0;
			immediate_8_bit_odd_reg<=0;
			immediate_10_bit_odd_reg<=0;
			immediate_16_bit_odd_reg<=0;
			immediate_18_bit_odd_reg<=0;
			opcode_odd_reg<=0;
			write_signal_load_store_odd_reg<=0;
			addr_reg_1_odd_reg<=0;
			addr_reg_2_odd_reg<=0;
			addr_reg_3_odd_reg<=0;
			write_reg_addr_reg_odd_reg<=0;
			reg_read_signal_odd_reg<=0;
			reg_write_signal_odd_reg<=0;
  
			pc_even_reg<=0;
			immediate_7_bit_even_reg<=0;
			immediate_8_bit_even_reg<=0;
			immediate_10_bit_even_reg<=0;
			immediate_16_bit_even_reg<=0;
			immediate_18_bit_even_reg<=0;
			opcode_even_reg<=0;
			write_signal_load_store_even_reg<=0;
			addr_reg_1_even_reg<=0;
			addr_reg_2_even_reg<=0;
			addr_reg_3_even_reg<=0;
			write_reg_addr_reg_even_reg<=0;
			reg_read_signal_even_reg<=0;
			reg_write_signal_even_reg<=0;

			//regiter file
			data_1_op_after_fw_reg<=0;
			data_2_op_after_fw_reg<=0;
			data_3_op_after_fw_reg<=0;
			immediate_7_bit_reg_op<=0;
			immediate_8_bit_reg_op<=0;
			immediate_10_bit_reg_op<=0;
			immediate_16_bit_reg_op<=0;
			immediate_18_bit_reg_op<=0;
			opcode_reg_op<=0;
			write_signal_load_store_reg_op<=0;
			write_reg_addr_reg_op<=0;
			reg_write_signal_op<=0;

			data_1_ep_after_fw_reg<=0;
			data_2_ep_after_fw_reg<=0;
			data_3_ep_after_fw_reg<=0;
			immediate_7_bit_reg_ep<=0;
			immediate_8_bit_reg_ep<=0;
			immediate_10_bit_reg_ep<=0;
			immediate_16_bit_reg_ep<=0;
			immediate_18_bit_reg_ep<=0;
			opcode_reg_ep<=0;
			write_signal_load_store_reg_ep<=0;
			reg_write_signal_ep<=0;
			write_reg_addr_reg_ep<=0;
			reg_write_signal_ep<=0;

			//after first stage
			pc_in_reg_op<=0;
			pc_in_reg_ep<=0;
			result_1_reg_1<=0;
			result_2_reg_1<=0;
			result_3_reg_1<=0;
			result_4_reg_1<=0;
			result_6_reg_1<=0;
			result_7_reg_1<=0;
			result_addr_ep1<=0;
			result_addr_op1<=0;
			reg_write_signal_ep1<=0;
			reg_write_signal_op1<=0;

			//after second stage
			result_1_reg_2<=0;
			result_2_reg_2<=0;
			result_3_reg_2<=0;
			result_4_reg_2<=0;
			result_6_reg_2<=0;
			result_7_reg_2<=0;
			result_addr_ep2<=0;
			result_addr_op2<=0;
			reg_write_signal_ep2<=0;
			reg_write_signal_op2<=0;

			//after third stage
			result_1_reg_3<=0;
			result_2_reg_3<=0;
			result_3_reg_3<=0;
			result_4_reg_3<=0;
			result_6_reg_3<=0;
			result_7_reg_3<=0;
			result_addr_ep3<=0;
			result_addr_op3<=0;
			reg_write_signal_ep3<=0;
			reg_write_signal_op3<=0;

			//after fourth stage
			result_1_reg_4<=0;
			result_2_reg_4<=0;
			result_3_reg_4<=0;
			result_4_reg_4<=0;
			result_addr_ep4<=0;
			result_addr_op4<=0;
			reg_write_signal_ep4<=0;
			reg_write_signal_op4<=0;

			//after fifth stage
			result_1_reg_5<=0;
			result_2_reg_5<=0;
			result_3_reg_5<=0;
			result_4_reg_5<=0;
			result_addr_ep5<=0;
			result_addr_op5<=0;
			reg_write_signal_ep5<=0;
			reg_write_signal_op5<=0;

			//after sixth stage
			result_1_reg_6<=0;
			result_2_reg_6<=0;
			result_3_reg_6<=0;
			result_4_reg_6<=0;
			result_addr_ep6<=0;
			result_addr_op6<=0;
			reg_write_signal_ep6<=0;
			reg_write_signal_op6<=0;

			//after seventh stage
			result_1_reg_7<=0;
			result_2_reg_7<=0;
			result_3_reg_7<=0;
			result_addr_ep7<=0;
			result_addr_op7<=0;
			reg_write_signal_ep7<=0;
			reg_write_signal_op7<=0;

			//after eighth stage
			result_1_reg_8<=0;
			result_2_reg_8<=0;
			result_addr_ep8<=0;
			result_addr_op8<=0;
			reg_write_signal_ep8<=0;
			reg_write_signal_op8<=0;

		end 
		else 
		begin
			if(cache_stall==1'b1)
			begin
			end
			else
			begin
			//instruction fetch
			pc_1_reg<=pc_1;
			pc_2_reg<=pc_2;
			instruction_1_reg<=instruction_1;
			instruction_2_reg<=instruction_2;
			//decode dep issue & route
			pc_odd_reg<=pc_odd;
			immediate_7_bit_odd_reg<=immediate_7_bit_odd;
			immediate_8_bit_odd_reg<=immediate_8_bit_odd;
			immediate_10_bit_odd_reg<=immediate_10_bit_odd;
			immediate_16_bit_odd_reg<=immediate_16_bit_odd;
			immediate_18_bit_odd_reg<=immediate_18_bit_odd;
			opcode_odd_reg<=opcode_odd;
			write_signal_load_store_odd_reg<=write_signal_load_store_odd;
			addr_reg_1_odd_reg<=addr_reg_1_odd;
			addr_reg_2_odd_reg<=addr_reg_2_odd;
			addr_reg_3_odd_reg<=addr_reg_3_odd;
			write_reg_addr_reg_odd_reg<=write_reg_addr_reg_odd;
			reg_read_signal_odd_reg<=reg_read_signal_odd;
			reg_write_signal_odd_reg<=reg_write_signal_odd;

			pc_even_reg<=pc_even;
			immediate_7_bit_even_reg<=immediate_7_bit_even;
			immediate_8_bit_even_reg<=immediate_8_bit_even;
			immediate_10_bit_even_reg<=immediate_10_bit_even;
			immediate_16_bit_even_reg<=immediate_16_bit_even;
			immediate_18_bit_even_reg<=immediate_18_bit_even;
			opcode_even_reg<=opcode_even;
			write_signal_load_store_even_reg<=write_signal_load_store_even;
			addr_reg_1_even_reg<=addr_reg_1_even;
			addr_reg_2_even_reg<=addr_reg_2_even;
			addr_reg_3_even_reg<=addr_reg_3_even;
			write_reg_addr_reg_even_reg<=write_reg_addr_reg_even;
			reg_read_signal_even_reg<=reg_read_signal_even;
			reg_write_signal_even_reg<=reg_write_signal_even;

			//register file
			data_1_op_after_fw_reg<=(flush_signal==1)?0:data_1_op_after_fw;
			data_2_op_after_fw_reg<=(flush_signal==1)?0:data_2_op_after_fw;
			data_3_op_after_fw_reg<=(flush_signal==1)?0:data_3_op_after_fw;
			immediate_7_bit_reg_op<=(flush_signal==1)?0:immediate_7_bit_odd_reg;
			immediate_8_bit_reg_op<=(flush_signal==1)?0:immediate_8_bit_odd_reg;
			immediate_10_bit_reg_op<=(flush_signal==1)?0:immediate_10_bit_odd_reg;
			immediate_16_bit_reg_op<=(flush_signal==1)?0:immediate_16_bit_odd_reg;
			immediate_18_bit_reg_op<=(flush_signal==1)?0:immediate_18_bit_odd_reg;
			opcode_reg_op<=(flush_signal==1)?0:opcode_odd_reg;
			write_signal_load_store_reg_op<=(flush_signal==1)?0:write_signal_load_store_odd_reg;
			reg_write_signal_op<=(flush_signal==1)?0:reg_write_signal_odd_reg;
			write_reg_addr_reg_op<=(flush_signal==1)?0:write_reg_addr_reg_odd_reg;
			pc_in_reg_op<=(flush_signal==1)?0:pc_odd_reg;

			data_1_ep_after_fw_reg<=(flush_signal==1)?0:data_1_ep_after_fw;
			data_2_ep_after_fw_reg<=(flush_signal==1)?0:data_2_ep_after_fw;
			data_3_ep_after_fw_reg<=(flush_signal==1)?0:data_3_ep_after_fw;
			immediate_7_bit_reg_ep<=(flush_signal==1)?0:immediate_7_bit_even_reg;
			immediate_8_bit_reg_ep<=(flush_signal==1)?0:immediate_8_bit_even_reg;
			immediate_10_bit_reg_ep<=(flush_signal==1)?0:immediate_10_bit_even_reg;
			immediate_16_bit_reg_ep<=(flush_signal==1)?0:immediate_16_bit_even_reg;
			immediate_18_bit_reg_ep<=(flush_signal==1)?0:immediate_18_bit_even_reg;
			opcode_reg_ep<=(flush_signal==1)?0:opcode_even_reg;
			write_signal_load_store_reg_ep<=(flush_signal==1)?0:write_reg_addr_reg_even_reg;
			reg_write_signal_ep<=(flush_signal==1)?0:reg_write_signal_even_reg;
			write_reg_addr_reg_ep<=(flush_signal==1)?0:write_reg_addr_reg_even_reg;
			pc_in_reg_ep<=(flush_signal==1)?0:pc_even_reg;
			//after stage 1 
			result_1_reg_1<=(flush_signal==1 && even_is_first_signal==0)?0:result_1;
			result_2_reg_1<=(flush_signal==1 && even_is_first_signal==0)?0:result_2;
			result_3_reg_1<=(flush_signal==1 && even_is_first_signal==0)?0:result_3;
			result_4_reg_1<=(flush_signal==1 && even_is_first_signal==0)?0:result_4;
			result_5_reg_1<=result_5;
			result_6_reg_1<=result_6;
			result_7_reg_1<=result_7;

			result_addr_ep1<=write_reg_addr_reg_ep;
			result_addr_op1<=write_reg_addr_reg_op;
			reg_write_signal_ep1<=(flush_signal==1 && even_is_first_signal==0)?0:reg_write_signal_ep;
			reg_write_signal_op1<=reg_write_signal_op;

			//after stage 2
			result_1_reg_2<=result_1_reg_1;
			result_2_reg_2<=result_2_reg_1;
			result_3_reg_2<=result_3_reg_1;
			result_4_reg_2<=result_4_reg_1;
			result_6_reg_2<=data_after_fwo1;
			result_7_reg_2<=result_7_reg_1;
			result_addr_ep2<=result_addr_ep1;
			result_addr_op2<=result_addr_op1;
			reg_write_signal_ep2<=reg_write_signal_ep1;
			reg_write_signal_op2<=reg_write_signal_op1;

			//after stage 3
			result_1_reg_3<=result_1_reg_2;
			result_2_reg_3<=result_2_reg_2;
			result_3_reg_3<=result_3_reg_2;
			result_4_reg_3<=result_4_reg_2;
			result_6_reg_3<=result_6_reg_2;
			result_7_reg_3<=result_7_reg_2;
			result_addr_ep3<=result_addr_ep2;
			result_addr_op3<=result_addr_op2;
			reg_write_signal_ep3<=reg_write_signal_ep2;
			reg_write_signal_op3<=reg_write_signal_op2;

			//after stage 4
			result_1_reg_4<=data_after_fwe3;
			result_2_reg_4<=result_3_reg_3;
			result_3_reg_4<=result_6_reg_3;
			result_4_reg_4<=result_7_reg_3;
			result_addr_ep4<=result_addr_ep3;
			result_addr_op4<=result_addr_op3;
			reg_write_signal_ep4<=reg_write_signal_ep3;
			reg_write_signal_op4<=reg_write_signal_op3;
			//after stage 5

			result_1_reg_5<=result_1_reg_4;
			result_2_reg_5<=result_2_reg_4;
			result_3_reg_5<=result_3_reg_4;
			result_4_reg_5<=result_4_reg_4;
			result_addr_ep5<=result_addr_ep4;
			result_addr_op5<=result_addr_op4;
			reg_write_signal_ep5<=reg_write_signal_ep4;
			reg_write_signal_op5<=reg_write_signal_op4;

			//after stage 6
			result_1_reg_6<=data_after_fwe6;
			result_2_reg_6<=result_2_reg_5;
			result_3_reg_6<=data_after_fwo6;
			result_addr_ep6<=result_addr_ep5;
			result_addr_op6<=result_addr_op5;
			reg_write_signal_ep6<=reg_write_signal_ep5;
			reg_write_signal_op6<=reg_write_signal_op5;

			//after stage 7
			result_1_reg_7<=data_after_fwe7;
			result_2_reg_7<=result_3_reg_6;
			result_addr_ep7<=result_addr_ep6;
			result_addr_op7<=result_addr_op6;
			reg_write_signal_ep7<=reg_write_signal_ep6;
			reg_write_signal_op7<=reg_write_signal_op6;

			//after stage 8
			result_1_reg_8<=result_1_reg_7;
		 	result_2_reg_8<=result_2_reg_7;
			result_addr_ep8<=result_addr_ep7;
			result_addr_op8<=result_addr_op7;
			reg_write_signal_ep8<=reg_write_signal_ep7;
			reg_write_signal_op8<=reg_write_signal_op7;
			end
		end
	end
	//use or gate to or results from different outputs
	assign data_after_fwe3=result_1_reg_3|result_2_reg_3|result_4_reg_3;
	assign data_after_fwe6=result_2_reg_5|result_1_reg_5;
	assign data_after_fwe7=result_1_reg_6|result_2_reg_6;
	assign data_after_fwo1=result_5_reg_1|result_6_reg_1;//good
	assign data_after_fwo6=result_3_reg_5|result_4_reg_5;
endmodule


