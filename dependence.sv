
module dependence(
   read_enable_signal_1,
   read_enable_signal_2,
   write_enable_signal_1,
   write_enable_signal_2,
	avaiable_counter_1,
	avaiable_counter_2,
	avaiable_counter_3,
	avaiable_counter_4,
	avaiable_counter_5,
	avaiable_counter_6,
   addr_reg_1,
   addr_reg_2,
   addr_reg_3,
   addr_reg_4,
   addr_reg_5,
   addr_reg_6,
	write_reg_addr_reg_1,
	write_reg_addr_reg_2,
   both_stall,
   single_stall,
   single_stall_reg
	);
   
   input read_enable_signal_1,read_enable_signal_2;
   input single_stall_reg;
   input write_enable_signal_1,write_enable_signal_2;
   input [3:0]avaiable_counter_1,avaiable_counter_2,avaiable_counter_3,avaiable_counter_4,avaiable_counter_5,avaiable_counter_6;
   input [6:0] addr_reg_1,addr_reg_2,addr_reg_3,addr_reg_4,addr_reg_5,addr_reg_6;
   input [6:0] write_reg_addr_reg_1,write_reg_addr_reg_2;
   output logic both_stall,single_stall;
   logic write_to_same_destination_signal;
   logic data_harzard_ins_1;
   logic data_harzard_ins_2;

   assign write_to_same_destination_signal=(write_reg_addr_reg_1==write_reg_addr_reg_2 
   && write_enable_signal_2==1 && write_enable_signal_1)?1:0;
   always_comb
   begin
      if((avaiable_counter_1>0 ||avaiable_counter_2>0 ||avaiable_counter_3>0)&&read_enable_signal_1==1)
         data_harzard_ins_1=1;
      else
         data_harzard_ins_1=0;
   end
   always_comb
   begin
      if(((avaiable_counter_4>0 ||avaiable_counter_5>0 ||avaiable_counter_6>0) && read_enable_signal_2==1)
      ||((write_reg_addr_reg_1==addr_reg_4|| write_reg_addr_reg_1==addr_reg_5 || write_reg_addr_reg_1==addr_reg_6)
      && (write_enable_signal_1==1 && read_enable_signal_2==1)) && single_stall_reg==0)//data not yet ready or the second instruction is depending on the first and first instruction is not issue yet
      begin
         data_harzard_ins_2=1;
      end
      else
      begin
         data_harzard_ins_2=0;
      end
   end
   always_comb
   //two types of stall
   //first one issue the first instruction and nop to the other instruction
   //second one stalls everything and wait for the result from forwarding unit
   begin
	   if(write_to_same_destination_signal==1)
	      begin
	         if(data_harzard_ins_1==1 && data_harzard_ins_2==1)
	         begin
	            both_stall=1'b1;
	            single_stall=1'b0;
	         end
	         else if(data_harzard_ins_1==1 && data_harzard_ins_2==0)
	         begin
	            both_stall=1;
	            single_stall=0;
	         end
	         else if(data_harzard_ins_1==0 && data_harzard_ins_2==1)
	         begin
	            both_stall=0;
	            single_stall=1;
	         end
	         else
	         begin
	            both_stall=0;
	            single_stall=1;
	         end
	      end
		else
		begin
			if(data_harzard_ins_1==1 && data_harzard_ins_2==1)
			begin
				both_stall=1;
				single_stall=0;
			end
			else if(data_harzard_ins_1==1 && data_harzard_ins_2==0)
			begin
				both_stall=1;
				single_stall=0;
			end
			else if(data_harzard_ins_1==0 && data_harzard_ins_2==1)
			begin
				both_stall=0;
				single_stall=1;
			end
			else
			begin
				both_stall=0;
				single_stall=0;
			end
		end
   end  
endmodule

