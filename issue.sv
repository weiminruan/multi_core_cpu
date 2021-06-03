module issue(
cache_stall,
clk,
reset,
flush_signal,
both_stall,
single_stall,
pc_1,
immediate_7_bit_1,
immediate_8_bit_1,
immediate_10_bit_1,
immediate_16_bit_1,
immediate_18_bit_1,
opcode_1,
addr_reg_1,
addr_reg_2,
addr_reg_3,
write_reg_addr_reg_1,
reg_read_signal_1,
reg_write_signal_1,
instruction_parity_1,
write_signal_load_store_1,
instruction_latency_1,

pc_2,
immediate_7_bit_2,
immediate_8_bit_2,
immediate_10_bit_2,
immediate_16_bit_2,
immediate_18_bit_2,
opcode_2,
addr_reg_4,
addr_reg_5,
addr_reg_6,
write_reg_addr_reg_2,
reg_read_signal_2,
reg_write_signal_2,
instruction_parity_2,
write_signal_load_store_2,
instruction_latency_2,


pc_odd,
immediate_7_bit_odd,
immediate_8_bit_odd,
immediate_10_bit_odd,
immediate_16_bit_odd,
immediate_18_bit_odd,
opcode_odd,
addr_reg_1_odd,
addr_reg_2_odd,
addr_reg_3_odd,
write_reg_addr_reg_odd,
reg_read_signal_odd,
reg_write_signal_odd,
write_signal_load_store_odd,
instruction_latency_odd,
pc_even,
immediate_7_bit_even,
immediate_8_bit_even,
immediate_10_bit_even,
immediate_16_bit_even,
immediate_18_bit_even,
opcode_even,
addr_reg_1_even,
addr_reg_2_even,
addr_reg_3_even,
write_reg_addr_reg_even,
reg_read_signal_even,
reg_write_signal_even,
write_signal_load_store_even,
instruction_latency_even,
same_parity

);
input clk,reset;
input cache_stall;
input both_stall;
input single_stall;
input flush_signal;
input [31:0] pc_1;
input [10:0]opcode_1;
input [6:0] immediate_7_bit_1;
input [7:0] immediate_8_bit_1;
input [9:0] immediate_10_bit_1;
input [15:0] immediate_16_bit_1;
input [17:0] immediate_18_bit_1;
input write_signal_load_store_1;
input [6:0] addr_reg_1,addr_reg_2,addr_reg_3;
input [6:0] write_reg_addr_reg_1;
input reg_read_signal_1,reg_write_signal_1;
input instruction_parity_1;
input unsigned [3:0]instruction_latency_1;

input [31:0] pc_2;
input [10:0] opcode_2;
input [6:0] immediate_7_bit_2;
input [7:0] immediate_8_bit_2;
input [9:0] immediate_10_bit_2;
input [15:0] immediate_16_bit_2;
input [17:0] immediate_18_bit_2;
input write_signal_load_store_2;
input [6:0] addr_reg_4,addr_reg_5,addr_reg_6;
input [6:0] write_reg_addr_reg_2;
input reg_read_signal_2,reg_write_signal_2;
input instruction_parity_2;
input unsigned[3:0]instruction_latency_2;

output logic[31:0] pc_odd;
output logic[10:0] opcode_odd;
output logic[6:0] immediate_7_bit_odd;
output logic[7:0] immediate_8_bit_odd;
output logic[9:0] immediate_10_bit_odd;
output logic[15:0] immediate_16_bit_odd;
output logic[17:0] immediate_18_bit_odd;
output logic write_signal_load_store_odd;
output logic[6:0] addr_reg_1_odd,addr_reg_2_odd,addr_reg_3_odd;
output logic[6:0] write_reg_addr_reg_odd;
output logic reg_read_signal_odd,reg_write_signal_odd;
output logic [3:0]instruction_latency_odd;

output logic[31:0] pc_even;
output logic[10:0] opcode_even;
output logic[6:0] immediate_7_bit_even;
output logic[7:0] immediate_8_bit_even;
output logic[9:0] immediate_10_bit_even;
output logic[15:0] immediate_16_bit_even;
output logic[17:0] immediate_18_bit_even;
output logic write_signal_load_store_even;
output logic[6:0] addr_reg_1_even,addr_reg_2_even,addr_reg_3_even;
output logic[6:0] write_reg_addr_reg_even;
output logic reg_read_signal_even,reg_write_signal_even;
output logic [3:0]instruction_latency_even;

output logic same_parity;
logic [31:0] pc_1_after_issue;
logic [10:0]opcode_1_after_issue;
logic [6:0] immediate_7_bit_1_after_issue;
logic [7:0] immediate_8_bit_1_after_issue;
logic [9:0] immediate_10_bit_1_after_issue;
logic [15:0] immediate_16_bit_1_after_issue;
logic [17:0] immediate_18_bit_1_after_issue;
logic write_signal_load_store_1_after_issue;
logic [6:0] addr_reg_1_1_after_issue,addr_reg_2_1_after_issue,addr_reg_3_1_after_issue;
logic [6:0] write_reg_addr_reg_1_after_issue;
logic reg_read_signal_1_after_issue,reg_write_signal_1_after_issue;
logic instruction_parity_1_after_issue;
logic [3:0]instruction_latency_1_after_issue;

logic [31:0] pc_2_after_issue;
logic [10:0] opcode_2_after_issue;
logic [6:0] immediate_7_bit_2_after_issue;
logic [7:0] immediate_8_bit_2_after_issue;
logic [9:0] immediate_10_bit_2_after_issue;
logic [15:0] immediate_16_bit_2_after_issue;
logic [17:0] immediate_18_bit_2_after_issue;
logic write_signal_load_store_2_after_issue;
logic [6:0] addr_reg_1_2_after_issue,addr_reg_2_2_after_issue,addr_reg_3_2_after_issue;
logic [6:0] write_reg_addr_reg_2_after_issue;
logic reg_read_signal_2_after_issue,reg_write_signal_2_after_issue;
logic instruction_parity_2_after_issue; 
logic [3:0]instruction_latency_2_after_issue;

logic single_stall_reg;
logic same_parity_reg;
always_ff @(posedge clk or posedge reset or posedge flush_signal) 
begin
	if(reset ==1|| flush_signal==1)
	begin
		single_stall_reg<=0;
		same_parity_reg<=0;
	end
	else
	begin
		if(cache_stall==1'b1)
		begin
		end
		else
		begin
			single_stall_reg<=single_stall;
			same_parity_reg<=same_parity;
		end
		
	end
end
always_comb
begin
	if(both_stall==1)
	begin
	//stall both pipelines
		 pc_1_after_issue=0;
		 opcode_1_after_issue=11'b00000000001;
		 immediate_7_bit_1_after_issue=0;
		 immediate_8_bit_1_after_issue=0;
		 immediate_10_bit_1_after_issue=0;
		 immediate_16_bit_1_after_issue=0;
		 immediate_18_bit_1_after_issue=0;
		 write_signal_load_store_1_after_issue=0;
		 addr_reg_1_1_after_issue=0;
		 addr_reg_2_1_after_issue=0;
		 addr_reg_3_1_after_issue=0;
		 write_reg_addr_reg_1_after_issue=0;
		 reg_read_signal_1_after_issue=0;
		 reg_write_signal_1_after_issue=0;
		 instruction_parity_1_after_issue=1;
		 instruction_latency_1_after_issue=0;

		 pc_2_after_issue=0;
		 opcode_2_after_issue=11'b01000000001;
		 immediate_7_bit_2_after_issue=0;
		 immediate_8_bit_2_after_issue=0;
		 immediate_10_bit_2_after_issue=0;
		 immediate_16_bit_2_after_issue=0;
		 immediate_18_bit_2_after_issue=0;
		 write_signal_load_store_2_after_issue=0;
		 addr_reg_1_2_after_issue=0;
		 addr_reg_2_2_after_issue=0;
		 addr_reg_3_2_after_issue=0;
		 write_reg_addr_reg_2_after_issue=0;
		 reg_read_signal_2_after_issue=0;
		 reg_write_signal_2_after_issue=0;
		 instruction_latency_2_after_issue=0;
	end
	else
	begin
		if(single_stall==1 && single_stall_reg==0)
		begin
			
			//issue one instruction issue the first one with a nop along with it
			if(instruction_parity_1==1) //odd
			begin

				 pc_1_after_issue=pc_1;
				 opcode_1_after_issue=opcode_1;
				 immediate_7_bit_1_after_issue=immediate_7_bit_1;
				 immediate_8_bit_1_after_issue=immediate_8_bit_1;
				 immediate_10_bit_1_after_issue=immediate_10_bit_1;
				 immediate_16_bit_1_after_issue=immediate_16_bit_1;
				 immediate_18_bit_1_after_issue=immediate_18_bit_1;
				 write_signal_load_store_1_after_issue=write_signal_load_store_1;
				 addr_reg_1_1_after_issue=addr_reg_1;
				 addr_reg_2_1_after_issue=addr_reg_2;
				 addr_reg_3_1_after_issue=addr_reg_3;
				 write_reg_addr_reg_1_after_issue=write_reg_addr_reg_1;
				 reg_read_signal_1_after_issue=reg_read_signal_1;
				 reg_write_signal_1_after_issue=reg_write_signal_1; 
				 instruction_parity_1_after_issue=instruction_parity_1;
				 instruction_latency_1_after_issue=instruction_latency_1;
				//nop even
				 pc_2_after_issue=0;
				 opcode_2_after_issue=11'b01000000001;
				 immediate_7_bit_2_after_issue=0;
				 immediate_8_bit_2_after_issue=0;
				 immediate_10_bit_2_after_issue=0;
				 immediate_16_bit_2_after_issue=0;
				 immediate_18_bit_2_after_issue=0;
				 write_signal_load_store_2_after_issue=0;
				 addr_reg_1_2_after_issue=0;
				 addr_reg_2_2_after_issue=0;
				 addr_reg_3_2_after_issue=0;
				 write_reg_addr_reg_2_after_issue=0;
				 reg_read_signal_2_after_issue=0;
				 reg_write_signal_2_after_issue=0;
				 instruction_parity_2_after_issue=0;
				 instruction_latency_1_after_issue=0;
			end
			else
			begin
				//nop
				 pc_1_after_issue=pc_1;
				 opcode_1_after_issue=opcode_1;
				 immediate_7_bit_1_after_issue=immediate_7_bit_1;
				 immediate_8_bit_1_after_issue=immediate_8_bit_1;
				 immediate_10_bit_1_after_issue=immediate_10_bit_1;
				 immediate_16_bit_1_after_issue=immediate_16_bit_1;
				 immediate_18_bit_1_after_issue=immediate_18_bit_1;
				 write_signal_load_store_1_after_issue=write_signal_load_store_1;
				 addr_reg_1_1_after_issue=addr_reg_1;
				 addr_reg_2_1_after_issue=addr_reg_2;
				 addr_reg_3_1_after_issue=addr_reg_3;
				 write_reg_addr_reg_1_after_issue=write_reg_addr_reg_1;
				 reg_read_signal_1_after_issue=reg_read_signal_1;
				 reg_write_signal_1_after_issue=reg_write_signal_1; 
				 instruction_parity_1_after_issue=instruction_parity_1;
				 instruction_latency_1_after_issue=instruction_latency_1;
				//nop odd
				 pc_2_after_issue=0;
				 opcode_2_after_issue=11'b00000000001;
				 immediate_7_bit_2_after_issue=0;
				 immediate_8_bit_2_after_issue=0;
				 immediate_10_bit_2_after_issue=0;
				 immediate_16_bit_2_after_issue=0;
				 immediate_18_bit_2_after_issue=0;
				 write_signal_load_store_2_after_issue=0;
				 addr_reg_1_2_after_issue=0;
				 addr_reg_2_2_after_issue=0;
				 addr_reg_3_2_after_issue=0;
				 write_reg_addr_reg_2_after_issue=0;
				 reg_read_signal_2_after_issue=0;
				 reg_write_signal_2_after_issue=0;
				 instruction_parity_2_after_issue=0;
				 instruction_latency_2_after_issue=0;
			end
		end
		else if(single_stall==1 && single_stall_reg==1)
		begin
			//stall both instructions
			 pc_1_after_issue=0;
			 opcode_1_after_issue=11'b01000000001;
			 immediate_7_bit_1_after_issue=0;
			 immediate_8_bit_1_after_issue=0;
			 immediate_10_bit_1_after_issue=0;
			 immediate_16_bit_1_after_issue=0;
			 immediate_18_bit_1_after_issue=0;
			 write_signal_load_store_1_after_issue=0;
			 addr_reg_1_1_after_issue=0;
			 addr_reg_2_1_after_issue=0;
			 addr_reg_3_1_after_issue=0;
			 write_reg_addr_reg_1_after_issue=0;
			 reg_read_signal_1_after_issue=0;
			 reg_write_signal_1_after_issue=0;
			 instruction_parity_1_after_issue=1;
			 instruction_latency_1_after_issue=0;

			 pc_2_after_issue=0;
			 opcode_2_after_issue=11'b01000000001;
			 immediate_7_bit_2_after_issue=0;
			 immediate_8_bit_2_after_issue=0;
			 immediate_10_bit_2_after_issue=0;
			 immediate_16_bit_2_after_issue=0;
			 immediate_18_bit_2_after_issue=0;
			 write_signal_load_store_2_after_issue=0;
			 addr_reg_1_2_after_issue=0;
			 addr_reg_2_2_after_issue=0;
			 addr_reg_3_2_after_issue=0;
			 write_reg_addr_reg_2_after_issue=0;
			 reg_read_signal_2_after_issue=0;
			 reg_write_signal_2_after_issue=0;
			 instruction_parity_2_after_issue=0;
			 instruction_latency_2_after_issue=0;
		end
		else if(single_stall==0 && single_stall_reg==1)
		begin
			if(instruction_parity_2==1) //odd
			begin
				 pc_1_after_issue=0;
				 opcode_1_after_issue=11'b01000000001;
				 immediate_7_bit_1_after_issue=0;
				 immediate_8_bit_1_after_issue=0;
				 immediate_10_bit_1_after_issue=0;
				 immediate_16_bit_1_after_issue=0;
				 immediate_18_bit_1_after_issue=0;
				 write_signal_load_store_1_after_issue=0;
				 addr_reg_1_1_after_issue=0;
				 addr_reg_2_1_after_issue=0;
				 addr_reg_3_1_after_issue=0;
				 write_reg_addr_reg_1_after_issue=0;
				 reg_read_signal_1_after_issue=0;
				 reg_write_signal_1_after_issue=0; 
				 instruction_parity_1_after_issue=0;
				 instruction_latency_1_after_issue=0;
				//nop
				 pc_2_after_issue=pc_2;
				 opcode_2_after_issue=opcode_2;
				 immediate_7_bit_2_after_issue=immediate_7_bit_2;
				 immediate_8_bit_2_after_issue=immediate_8_bit_2;
				 immediate_10_bit_2_after_issue=immediate_10_bit_2;
				 immediate_16_bit_2_after_issue=immediate_16_bit_2;
				 immediate_18_bit_2_after_issue=immediate_18_bit_2;
				 write_signal_load_store_2_after_issue=write_signal_load_store_2;
				 addr_reg_1_2_after_issue=addr_reg_4;
				 addr_reg_2_2_after_issue=addr_reg_5;
				 addr_reg_3_2_after_issue=addr_reg_6;
				 write_reg_addr_reg_2_after_issue=write_reg_addr_reg_2;
				 reg_read_signal_2_after_issue=reg_read_signal_2;
				 reg_write_signal_2_after_issue=reg_write_signal_2;
				 instruction_parity_2_after_issue=instruction_parity_2;
				 instruction_latency_2_after_issue=instruction_latency_2;
			end
			else
			begin
				 pc_1_after_issue=0;
				 opcode_1_after_issue=11'b00000000001;
				 immediate_7_bit_1_after_issue=0;
				 immediate_8_bit_1_after_issue=0;
				 immediate_10_bit_1_after_issue=0;
				 immediate_16_bit_1_after_issue=0;
				 immediate_18_bit_1_after_issue=0;
				 write_signal_load_store_1_after_issue=0;
				 addr_reg_1_1_after_issue=0;
				 addr_reg_2_1_after_issue=0;
				 addr_reg_3_1_after_issue=0;
				 write_reg_addr_reg_1_after_issue=0;
				 reg_read_signal_1_after_issue=0;
				 reg_write_signal_1_after_issue=0; 
				 instruction_parity_1_after_issue=1;
				 instruction_latency_1_after_issue=0;
				//nop
				 pc_2_after_issue=pc_2;
				 opcode_2_after_issue=opcode_2;
				 immediate_7_bit_2_after_issue=immediate_7_bit_2;
				 immediate_8_bit_2_after_issue=immediate_8_bit_2;
				 immediate_10_bit_2_after_issue=immediate_10_bit_2;
				 immediate_16_bit_2_after_issue=immediate_16_bit_2;
				 immediate_18_bit_2_after_issue=immediate_18_bit_even;
				 write_signal_load_store_2_after_issue=write_signal_load_store_2;
				 addr_reg_1_2_after_issue=addr_reg_4;
				 addr_reg_2_2_after_issue=addr_reg_5;
				 addr_reg_3_2_after_issue=addr_reg_6;
				 write_reg_addr_reg_2_after_issue=write_reg_addr_reg_2;
				 reg_read_signal_2_after_issue=reg_read_signal_2;
				 reg_write_signal_2_after_issue=reg_write_signal_2;
				 instruction_parity_2_after_issue=instruction_parity_2;
				 instruction_latency_2_after_issue=instruction_latency_2;
				
			end
		end
		else if(single_stall==0 && single_stall_reg==0)
		begin
			//regular issue
			 pc_1_after_issue=pc_1;
			 opcode_1_after_issue=opcode_1;
			 immediate_7_bit_1_after_issue=immediate_7_bit_1;
			 immediate_8_bit_1_after_issue=immediate_8_bit_1;
			 immediate_10_bit_1_after_issue=immediate_10_bit_1;
			 immediate_16_bit_1_after_issue=immediate_16_bit_1;
			 immediate_18_bit_1_after_issue=immediate_18_bit_1;
			 write_signal_load_store_1_after_issue=write_signal_load_store_1;
			 addr_reg_1_1_after_issue=addr_reg_1;
			 addr_reg_2_1_after_issue=addr_reg_2;
			 addr_reg_3_1_after_issue=addr_reg_3;
			 write_reg_addr_reg_1_after_issue=write_reg_addr_reg_1;
			 reg_read_signal_1_after_issue=reg_read_signal_1;
			 reg_write_signal_1_after_issue=reg_write_signal_1; 
			 instruction_parity_1_after_issue=instruction_parity_1;
			 instruction_latency_1_after_issue=instruction_latency_1;

			 pc_2_after_issue=pc_2;
			 opcode_2_after_issue=opcode_2;
			 immediate_7_bit_2_after_issue=immediate_7_bit_2;
			 immediate_8_bit_2_after_issue=immediate_8_bit_2;
			 immediate_10_bit_2_after_issue=immediate_10_bit_2;
			 immediate_16_bit_2_after_issue=immediate_16_bit_2;
			 immediate_18_bit_2_after_issue=immediate_18_bit_even;
			 write_signal_load_store_2_after_issue=write_signal_load_store_2;
			 addr_reg_1_2_after_issue=addr_reg_4;
			 addr_reg_2_2_after_issue=addr_reg_5;
			 addr_reg_3_2_after_issue=addr_reg_6;
			 write_reg_addr_reg_2_after_issue=write_reg_addr_reg_2;
			 reg_read_signal_2_after_issue=reg_read_signal_2;
			 reg_write_signal_2_after_issue=reg_write_signal_2;
			 instruction_parity_2_after_issue=instruction_parity_2;
			 instruction_latency_2_after_issue=instruction_latency_2;
		end

	end
	

	

	/*
	if(flush_signal==1)
	begin
		 pc_odd=0;
		 opcode_odd=11'b00000000001;
		 immediate_7_bit_odd=0;
		 immediate_8_bit_odd=0;
		 immediate_10_bit_odd=0;
		 immediate_16_bit_odd=0;
		 immediate_18_bit_odd=0;
		 write_signal_load_store_odd=0;
		 addr_reg_1_odd=0;
		 addr_reg_2_odd=0;
		 addr_reg_3_odd=0;
		 write_reg_addr_reg_odd=0;
		 reg_read_signal_odd=0;
		 reg_write_signal_odd=0; 
		 instruction_latency_odd=0;

		 pc_even=0;
		 opcode_even=11'b10000000001;
		 immediate_7_bit_even=0;
		 immediate_8_bit_even=0;
		 immediate_10_bit_even=0;
		 immediate_16_bit_even=0;
		 immediate_18_bit_even=0;
		 write_signal_load_store_even=0;
		 addr_reg_1_even=0;
		 addr_reg_2_even=0;
		 addr_reg_3_even=0;
		 write_reg_addr_reg_even=0;
		 reg_read_signal_even=0;
		 reg_write_signal_even=0;
		 instruction_latency_even=0;
	end
	else
	begin
		 pc_odd=pc_odd;
		 opcode_odd=opcode_odd;
		 immediate_7_bit_odd=immediate_7_bit_odd;
		 immediate_8_bit_odd=immediate_8_bit_odd;
		 immediate_10_bit_odd=immediate_10_bit_odd;
		 immediate_16_bit_odd=immediate_16_bit_odd;
		 immediate_18_bit_odd=immediate_18_bit_odd;
		 write_signal_load_store_odd=write_signal_load_store_odd;
		 addr_reg_1_odd=addr_reg_1_odd;
		 addr_reg_2_odd=addr_reg_2_odd;
		 addr_reg_3_odd=addr_reg_3_odd;
		 write_reg_addr_reg_odd=immediate_7_bit_odd;
		 reg_read_signal_odd=immediate_7_bit_odd;
		 reg_write_signal_odd=immediate_7_bit_odd; 
		 instruction_latency_odd= instruction_latency_odd;

		 pc_even=pc_even;
		 opcode_even=opcode_even;
		 immediate_7_bit_even=immediate_7_bit_even;
		 immediate_8_bit_even=immediate_8_bit_even;
		 immediate_10_bit_even=immediate_10_bit_even;
		 immediate_16_bit_even=immediate_16_bit_even;
		 immediate_18_bit_even=immediate_18_bit_even;
		 write_signal_load_store_even=write_signal_load_store_even;
		 addr_reg_1_even=addr_reg_1_even;
		 addr_reg_2_even=addr_reg_2_even;
		 addr_reg_3_even=addr_reg_3_even;
		 write_reg_addr_reg_even= write_reg_addr_reg_even;
		 reg_read_signal_even=reg_read_signal_even;
		 reg_write_signal_even=reg_write_signal_even;
		  instruction_latency_even= instruction_latency_even;
	end
	*/
end
always_comb
begin
	//route part of the processor
	//check parity of the instruction
	if(same_parity_reg==1)
	begin
		same_parity=0;
		if(instruction_parity_2==1)
		begin
			 pc_odd=pc_2_after_issue;
			 opcode_odd=opcode_2_after_issue;
			 immediate_7_bit_odd=immediate_7_bit_2_after_issue;
			 immediate_8_bit_odd=immediate_8_bit_2_after_issue;
			 immediate_10_bit_odd=immediate_10_bit_2_after_issue;
			 immediate_16_bit_odd=immediate_16_bit_2_after_issue;
			 immediate_18_bit_odd=immediate_18_bit_2_after_issue;
			 write_signal_load_store_odd=write_signal_load_store_2_after_issue;
			 addr_reg_1_odd=addr_reg_1_2_after_issue;
			 addr_reg_2_odd=addr_reg_2_2_after_issue;
			 addr_reg_3_odd=addr_reg_3_2_after_issue;
			 write_reg_addr_reg_odd=write_reg_addr_reg_2_after_issue;
			 reg_read_signal_odd=reg_read_signal_2_after_issue;
			 reg_write_signal_odd=reg_write_signal_2_after_issue; 
			 instruction_latency_odd=instruction_latency_2_after_issue;

			 pc_even=0;
			 opcode_even=11'b01000000001;
			 immediate_7_bit_even=0;
			 immediate_8_bit_even=0;
			 immediate_10_bit_even=0;
			 immediate_16_bit_even=0;
			 immediate_18_bit_even=0;
			 write_signal_load_store_even=0;
			 addr_reg_1_even=0;
			 addr_reg_2_even=0;
			 addr_reg_3_even=0;
			 write_reg_addr_reg_even=0;
			 reg_read_signal_even=0;
			 reg_write_signal_even=0;
			 instruction_latency_even=0;

		end
		else
		begin
			 pc_odd=0;
			 opcode_odd=11'b00000000001;
			 immediate_7_bit_odd=0;
			 immediate_8_bit_odd=0;
			 immediate_10_bit_odd=0;
			 immediate_16_bit_odd=0;
			 immediate_18_bit_odd=0;
			 write_signal_load_store_odd=0;
			 addr_reg_1_odd=0;
			 addr_reg_2_odd=0;
			 addr_reg_3_odd=0;
			 write_reg_addr_reg_odd=0;
			 reg_read_signal_odd=0;
			 reg_write_signal_odd=0;
			 instruction_latency_odd=0;

			 pc_even=pc_2_after_issue;
			 opcode_even=opcode_2_after_issue;
			 immediate_7_bit_even=immediate_7_bit_2_after_issue;
			 immediate_8_bit_even=immediate_8_bit_2_after_issue;
			 immediate_10_bit_even=immediate_10_bit_2_after_issue;
			 immediate_16_bit_even=immediate_16_bit_2_after_issue;
			 immediate_18_bit_even=immediate_18_bit_2_after_issue;
			 write_signal_load_store_even=write_signal_load_store_2_after_issue;
			 addr_reg_1_even=addr_reg_1_2_after_issue;
			 addr_reg_2_even=addr_reg_2_2_after_issue;
			 addr_reg_3_even=addr_reg_3_2_after_issue;
			 write_reg_addr_reg_even=write_reg_addr_reg_2_after_issue;
			 reg_read_signal_even=reg_read_signal_2_after_issue;
			 reg_write_signal_even=reg_write_signal_2_after_issue; 
			 instruction_latency_even=instruction_latency_2_after_issue;
		end
	end
	else
	begin
		if(instruction_parity_2_after_issue==instruction_parity_1_after_issue &&instruction_parity_1_after_issue==1)
		begin
			 same_parity=1;
			 pc_odd=pc_1_after_issue;
			 opcode_odd=opcode_1_after_issue;
			 immediate_7_bit_odd=immediate_7_bit_1_after_issue;
			 immediate_8_bit_odd=immediate_8_bit_1_after_issue;
			 immediate_10_bit_odd=immediate_10_bit_1_after_issue;
			 immediate_16_bit_odd=immediate_16_bit_1_after_issue;
			 immediate_18_bit_odd=immediate_18_bit_1_after_issue;
			 write_signal_load_store_odd=write_signal_load_store_1_after_issue;
			 addr_reg_1_odd=addr_reg_1_1_after_issue;
			 addr_reg_2_odd=addr_reg_2_1_after_issue;
			 addr_reg_3_odd=addr_reg_3_1_after_issue;
			 write_reg_addr_reg_odd=write_reg_addr_reg_1_after_issue;
			 reg_read_signal_odd=reg_read_signal_1_after_issue;
			 reg_write_signal_odd=reg_write_signal_1_after_issue; 
			 instruction_latency_odd=instruction_latency_1_after_issue;

			 pc_even=0;
			 opcode_even=11'b01000000001;
			 immediate_7_bit_even=0;
			 immediate_8_bit_even=0;
			 immediate_10_bit_even=0;
			 immediate_16_bit_even=0;
			 immediate_18_bit_even=0;
			 write_signal_load_store_even=0;
			 addr_reg_1_even=0;
			 addr_reg_2_even=0;
			 addr_reg_3_even=0;
			 write_reg_addr_reg_even=0;
			 reg_read_signal_even=0;
			 reg_write_signal_even=0;
			 instruction_latency_even=0;

			//issue ins 1 and nop()
		end
		else if(instruction_parity_2_after_issue==instruction_parity_1_after_issue &&instruction_parity_1_after_issue==0)
		begin
			//issue ins 1 and nop()
			 same_parity=1;
			 pc_odd=0;
			 opcode_odd=11'b01000000001;
			 immediate_7_bit_odd=0;
			 immediate_8_bit_odd=0;
			 immediate_10_bit_odd=0;
			 immediate_16_bit_odd=0;
			 immediate_18_bit_odd=0;
			 write_signal_load_store_odd=0;
			 addr_reg_1_odd=0;
			 addr_reg_2_odd=0;
			 addr_reg_3_odd=0;
			 write_reg_addr_reg_odd=0;
			 reg_read_signal_odd=0;
			 reg_write_signal_odd=0;
			 instruction_latency_odd=0;

			 pc_even=pc_1_after_issue;
			 opcode_even=opcode_1_after_issue;
			 immediate_7_bit_even=immediate_7_bit_1_after_issue;
			 immediate_8_bit_even=immediate_8_bit_1_after_issue;
			 immediate_10_bit_even=immediate_10_bit_1_after_issue;
			 immediate_16_bit_even=immediate_16_bit_1_after_issue;
			 immediate_18_bit_even=immediate_18_bit_1_after_issue;
			 write_signal_load_store_even=write_signal_load_store_1_after_issue;
			 addr_reg_1_even=addr_reg_1_1_after_issue;
			 addr_reg_2_even=addr_reg_2_1_after_issue;
			 addr_reg_3_even=addr_reg_3_1_after_issue;
			 write_reg_addr_reg_even=write_reg_addr_reg_1_after_issue;
			 reg_read_signal_even=reg_read_signal_1_after_issue;
			 reg_write_signal_even=reg_write_signal_1_after_issue;
			 instruction_latency_even=instruction_latency_1_after_issue;

		end
		else
		begin
			 same_parity=0;
			if(instruction_parity_1_after_issue==0)
			begin
				 pc_odd=pc_2_after_issue;
				 opcode_odd=opcode_2_after_issue;
				 immediate_7_bit_odd=immediate_7_bit_2_after_issue;
				 immediate_8_bit_odd=immediate_8_bit_2_after_issue;
				 immediate_10_bit_odd=immediate_10_bit_2_after_issue;
				 immediate_16_bit_odd=immediate_16_bit_2_after_issue;
				 immediate_18_bit_odd=immediate_18_bit_2_after_issue;
				 write_signal_load_store_odd=write_signal_load_store_2_after_issue;
				 addr_reg_1_odd=addr_reg_1_2_after_issue;
				 addr_reg_2_odd=addr_reg_2_2_after_issue;
				 addr_reg_3_odd=addr_reg_3_2_after_issue;
				 write_reg_addr_reg_odd=write_reg_addr_reg_2_after_issue;
				 reg_read_signal_odd=reg_read_signal_2_after_issue;
				 reg_write_signal_odd=reg_write_signal_2_after_issue; 
				 instruction_latency_odd=instruction_latency_2_after_issue;

				 pc_even=pc_1_after_issue;
				 opcode_even=opcode_1_after_issue;
				 immediate_7_bit_even=immediate_7_bit_1_after_issue;
				 immediate_8_bit_even=immediate_8_bit_1_after_issue;
				 immediate_10_bit_even=immediate_10_bit_1_after_issue;
				 immediate_16_bit_even=immediate_16_bit_1_after_issue;
				 immediate_18_bit_even=immediate_18_bit_1_after_issue;
				 write_signal_load_store_even=write_signal_load_store_1_after_issue;
				 addr_reg_1_even=addr_reg_1_1_after_issue;
				 addr_reg_2_even=addr_reg_2_1_after_issue;
				 addr_reg_3_even=addr_reg_3_1_after_issue;
				 write_reg_addr_reg_even=write_reg_addr_reg_1_after_issue;
				 reg_read_signal_even=reg_read_signal_1_after_issue;
				 reg_write_signal_even=reg_write_signal_1_after_issue;
				 instruction_latency_even=instruction_latency_1_after_issue;
			end
			else
			begin
				 pc_odd=pc_1_after_issue;
				 opcode_odd=opcode_1_after_issue;
				 immediate_7_bit_odd=immediate_7_bit_1_after_issue;
				 immediate_8_bit_odd=immediate_8_bit_1_after_issue;
				 immediate_10_bit_odd=immediate_10_bit_1_after_issue;
				 immediate_16_bit_odd=immediate_16_bit_1_after_issue;
				 immediate_18_bit_odd=immediate_18_bit_1_after_issue;
				 write_signal_load_store_odd=write_signal_load_store_1_after_issue;
				 addr_reg_1_odd=addr_reg_1_1_after_issue;
				 addr_reg_2_odd=addr_reg_2_1_after_issue;
				 addr_reg_3_odd=addr_reg_3_1_after_issue;
				 write_reg_addr_reg_odd=write_reg_addr_reg_1_after_issue;
				 reg_read_signal_odd=reg_read_signal_1_after_issue;
				 reg_write_signal_odd=reg_write_signal_1_after_issue; 
				 instruction_latency_odd=instruction_latency_1_after_issue;

				 pc_even=pc_2_after_issue;
				 opcode_even=opcode_2_after_issue;
				 immediate_7_bit_even=immediate_7_bit_2_after_issue;
				 immediate_8_bit_even=immediate_8_bit_2_after_issue;
				 immediate_10_bit_even=immediate_10_bit_2_after_issue;
				 immediate_16_bit_even=immediate_16_bit_2_after_issue;
				 immediate_18_bit_even=immediate_18_bit_2_after_issue;
				 write_signal_load_store_even=write_signal_load_store_2_after_issue;
				 addr_reg_1_even=addr_reg_1_2_after_issue;
				 addr_reg_2_even=addr_reg_2_2_after_issue;
				 addr_reg_3_even=addr_reg_3_2_after_issue;
				 write_reg_addr_reg_even=write_reg_addr_reg_2_after_issue;
				 reg_read_signal_even=reg_read_signal_2_after_issue;
				 reg_write_signal_even=reg_write_signal_2_after_issue;
				 instruction_latency_even=instruction_latency_2_after_issue;
			end
		end
	end	
end
	

	
endmodule