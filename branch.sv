module branch(
opcode,
pc_in,
ra,
rc,
immediate,
pc,
result,
branch_jump_signal,
take_or_not,
stop);
	input [10:0] opcode;
	input unsigned [31:0] pc_in;
	input [127:0] ra;
	input [127:0] rc;
	input [15:0] immediate;

	output logic[31:0] pc;
	output logic[127:0] result;
	output logic branch_jump_signal;
	output logic take_or_not;
	output logic stop;

	always_comb
	begin
	case (opcode)
		11'b001100100xx :  //Branch Relative
		begin
			 pc=pc_in+{{14{immediate[15]}},immediate,2'b00};
			 result= 0;
			 branch_jump_signal=1;
			 take_or_not=1;
			 stop=0;
		end
		 
		11'b001100000xx :  //Branch Absolute
		begin
			 pc={{14{immediate[15]}},immediate,2'b00};
			 result= 0;
			 branch_jump_signal=1;
			 take_or_not=1;
			 stop=0;
		end
		11'b00110101000 :  //Branch indirect
		begin
			 pc={ra[127:96]&32'hfffffffc};
			 result= 0;
			 branch_jump_signal=1;
			 take_or_not=1;
			 stop=0;
		end
		11'b001100110xx :  //Branch Relative and Set Link
		begin
			 pc=pc_in+{{14{immediate[15]}},immediate,2'b00};
			 result[127:96]=pc_in+8;
			 branch_jump_signal=1;
			 take_or_not=1;
			 stop=0;
		end
		11'b001100010xx :  //Branch Absolute and Set Link
		begin
			 pc={{14{immediate[15]}},immediate,2'b00};
			 result[127:96]=pc_in+8;
			 branch_jump_signal=1;
			 take_or_not=1;
			 stop=0;
		end
		11'b001000010xx :  //Branch If Not Zero Word
		begin
			 pc=(rc[127:96]!=0)?pc_in+{{14{immediate[15]}},immediate,2'b00}:pc_in+8;
			 result=0;
			 branch_jump_signal=1;
			 take_or_not=(rc[127:96]!=0)?1:0;
			 stop=0;
		end
		11'b001000000xx :  //Branch If Zero Word
		begin
			 pc=(rc[127:96]==0)?pc_in+{{14{immediate[15]}},immediate,2'b00}:pc_in+8;
			 result=0;
			 branch_jump_signal=1;
			 take_or_not=(rc[127:96]==0)?1:0;
			 stop=0;
		end
		11'b001000110xx :  //Branch If Not Zero Halfword
		begin
			 pc=(rc[111:96]!=0)?pc_in+{{14{immediate[15]}},immediate,2'b00}:pc_in+8;
			 result=0;
			 branch_jump_signal=1;
			 take_or_not=(rc[111:96]!=0)?1:0;
			 stop=0;
		end
		11'b001000100xx  :  //Branch If Zero Halfword
		begin
			 pc=(rc[111:96]==0)?pc_in+{{14{immediate[15]}},immediate,2'b00}:pc_in+8;
			 result=0;
			 branch_jump_signal=1;
			 take_or_not=(rc[111:96]!=0)?1:0;
			 stop=0;
		end
		11'b00000000000  : //stop
		begin
			 pc=pc_in;
			 result=0;
			 branch_jump_signal=0;
			 take_or_not=0;
			 stop=1;
		end
		default: 
		begin 
			 pc=pc_in;
			 result=0;
			 branch_jump_signal=0;
			 take_or_not=0;
			 stop=0;

		end
	endcase
    end
	endmodule