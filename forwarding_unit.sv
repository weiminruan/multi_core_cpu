
module forwarding_unit(
	addr_1_odd,
	addr_2_odd,
	addr_3_odd,
	addr_1_even,
	addr_2_even,
	addr_3_even,
	data_in_1_odd,
	data_in_2_odd,
	data_in_3_odd,
	data_in_1_even,
	data_in_2_even,
	data_in_3_even,
	forward_addr_ep1,
	forward_addr_ep2,
	forward_addr_ep3,
	forward_addr_ep4,
	forward_addr_ep5,
	forward_addr_ep6,
	forward_addr_ep7,
	forward_addr_ep8,
	forward_addr_op1,
	forward_addr_op2,
	forward_addr_op3,
	forward_addr_op4,
	forward_addr_op5,
	forward_addr_op6,
	forward_addr_op7,
	forward_addr_op8,
	forward_addr_op9,
	forward_data_ep1,
	forward_data_ep2,
	forward_data_ep3,
	forward_data_ep4,
	forward_data_ep5,
	forward_data_ep6,
	forward_data_ep7,
	forward_data_ep8,
	forward_data_op1,
	forward_data_op2,
	forward_data_op3,
	forward_data_op4,
	forward_data_op5,
	forward_data_op6,
	forward_data_op7,
	forward_data_op8,
	forward_data_op9,
	data_out_1_odd,
	data_out_2_odd,
	data_out_3_odd,
	data_out_1_even,
	data_out_2_even,
	data_out_3_even);


   input [6:0] addr_1_odd,addr_2_odd,addr_3_odd;
   input [6:0] addr_1_even,addr_2_even,addr_3_even;
   input [127:0] data_in_1_odd,data_in_2_odd,data_in_3_odd;
   input [127:0] data_in_1_even,data_in_2_even,data_in_3_even;

   input [6:0] forward_addr_ep1,forward_addr_ep2,forward_addr_ep3,forward_addr_ep4,forward_addr_ep5,forward_addr_ep6,forward_addr_ep7,forward_addr_ep8;
   input [6:0] forward_addr_op1,forward_addr_op2,forward_addr_op3,forward_addr_op4,forward_addr_op5,forward_addr_op6,forward_addr_op7,forward_addr_op8,forward_addr_op9;
   
   input [127:0] forward_data_ep1,forward_data_ep2,forward_data_ep3,forward_data_ep4,forward_data_ep5,forward_data_ep6,forward_data_ep7,forward_data_ep8;
   input [127:0] forward_data_op1,forward_data_op2,forward_data_op3,forward_data_op4,forward_data_op5,forward_data_op6,forward_data_op7,forward_data_op8,forward_data_op9;
   output [127:0] data_out_1_odd,data_out_2_odd,data_out_3_odd;
   output [127:0] data_out_1_even,data_out_2_even,data_out_3_even;


   assign data_out_1_odd=(addr_1_odd==forward_addr_op1)?forward_data_op1:
   					(addr_1_odd==forward_addr_op2)?forward_data_op2:
   					(addr_1_odd==forward_addr_ep1)?forward_data_ep1:
   					(addr_1_odd==forward_addr_op3)?forward_data_op3:
   					(addr_1_odd==forward_addr_ep2)?forward_data_ep2:
   					(addr_1_odd==forward_addr_op4)?forward_data_op4:
   					(addr_1_odd==forward_addr_ep3)?forward_data_ep3:
   					(addr_1_odd==forward_addr_op5)?forward_data_op5:
   					(addr_1_odd==forward_addr_ep4)?forward_data_ep4:
   					(addr_1_odd==forward_addr_op6)?forward_data_op6:
					(addr_1_odd==forward_addr_ep5)?forward_data_ep5:
					(addr_1_odd==forward_addr_op7)?forward_data_op7:
					(addr_1_odd==forward_addr_ep6)?forward_data_ep6:
					(addr_1_odd==forward_addr_op8)?forward_data_op8:
					(addr_1_odd==forward_addr_ep7)?forward_data_ep7:
					(addr_1_odd==forward_addr_op9)?forward_data_op9:
					(addr_1_odd==forward_addr_ep8)?forward_data_ep8:
					data_in_1_odd;

   assign data_out_2_odd=(addr_2_odd==forward_addr_op1)?forward_data_op1:
   					(addr_2_odd==forward_addr_op2)?forward_data_op2:
   					(addr_2_odd==forward_addr_ep1)?forward_data_ep1:
   					(addr_2_odd==forward_addr_op3)?forward_data_op3:
   					(addr_2_odd==forward_addr_ep2)?forward_data_ep2:
   					(addr_2_odd==forward_addr_op4)?forward_data_op4:
   					(addr_2_odd==forward_addr_ep3)?forward_data_ep3:
   					(addr_2_odd==forward_addr_op5)?forward_data_op5:
   					(addr_2_odd==forward_addr_ep4)?forward_data_ep4:
   					(addr_2_odd==forward_addr_op6)?forward_data_op6:
					(addr_2_odd==forward_addr_ep5)?forward_data_ep5:
					(addr_2_odd==forward_addr_op7)?forward_data_op7:
					(addr_2_odd==forward_addr_ep6)?forward_data_ep6:
					(addr_2_odd==forward_addr_op8)?forward_data_op8:
					(addr_2_odd==forward_addr_ep7)?forward_data_ep7:
					(addr_2_odd==forward_addr_op9)?forward_data_op9:
					(addr_2_odd==forward_addr_ep8)?forward_data_ep8:
					data_in_2_odd;		

   assign data_out_3_odd=(addr_3_odd==forward_addr_op1)?forward_data_op1:
   					(addr_3_odd==forward_addr_op2)?forward_data_op2:
   					(addr_3_odd==forward_addr_ep1)?forward_data_ep1:
   					(addr_3_odd==forward_addr_op3)?forward_data_op3:
   					(addr_3_odd==forward_addr_ep2)?forward_data_ep2:
   					(addr_3_odd==forward_addr_op4)?forward_data_op4:
   					(addr_3_odd==forward_addr_ep3)?forward_data_ep3:
   					(addr_3_odd==forward_addr_op5)?forward_data_op5:
   					(addr_3_odd==forward_addr_ep4)?forward_data_ep4:
   					(addr_3_odd==forward_addr_op6)?forward_data_op6:
					(addr_3_odd==forward_addr_ep5)?forward_data_ep5:
					(addr_3_odd==forward_addr_op7)?forward_data_op7:
					(addr_3_odd==forward_addr_ep6)?forward_data_ep6:
					(addr_3_odd==forward_addr_op8)?forward_data_op8:
					(addr_3_odd==forward_addr_ep7)?forward_data_ep7:
					(addr_3_odd==forward_addr_op9)?forward_data_op9:
					(addr_3_odd==forward_addr_ep8)?forward_data_ep8:
					data_in_3_odd;	

   assign data_out_1_even=(addr_1_even==forward_addr_op1)?forward_data_op1:
   					(addr_1_even==forward_addr_op2)?forward_data_op2:
   					(addr_1_even==forward_addr_ep1)?forward_data_ep1:
   					(addr_1_even==forward_addr_op3)?forward_data_op3:
   					(addr_1_even==forward_addr_ep2)?forward_data_ep2:
   					(addr_1_even==forward_addr_op4)?forward_data_op4:
   					(addr_1_even==forward_addr_ep3)?forward_data_ep3:
   					(addr_1_even==forward_addr_op5)?forward_data_op5:
   					(addr_1_even==forward_addr_ep4)?forward_data_ep4:
   					(addr_1_even==forward_addr_op6)?forward_data_op6:
					(addr_1_even==forward_addr_ep5)?forward_data_ep5:
					(addr_1_even==forward_addr_op7)?forward_data_op7:
					(addr_1_even==forward_addr_ep6)?forward_data_ep6:
					(addr_1_even==forward_addr_op8)?forward_data_op8:
					(addr_1_even==forward_addr_ep7)?forward_data_ep7:
					(addr_1_even==forward_addr_op9)?forward_data_op9:
					(addr_1_even==forward_addr_ep8)?forward_data_ep8:
					data_in_1_even;

   assign data_out_2_even=(addr_2_even==forward_addr_op1)?forward_data_op1:
   					(addr_2_even==forward_addr_op2)?forward_data_op2:
   					(addr_2_even==forward_addr_ep1)?forward_data_ep1:
   					(addr_2_even==forward_addr_op3)?forward_data_op3:
   					(addr_2_even==forward_addr_ep2)?forward_data_ep2:
   					(addr_2_even==forward_addr_op4)?forward_data_op4:
   					(addr_2_even==forward_addr_ep3)?forward_data_ep3:
   					(addr_2_even==forward_addr_op5)?forward_data_op5:
   					(addr_2_even==forward_addr_ep4)?forward_data_ep4:
   					(addr_2_even==forward_addr_op6)?forward_data_op6:
					(addr_2_even==forward_addr_ep5)?forward_data_ep5:
					(addr_2_even==forward_addr_op7)?forward_data_op7:
					(addr_2_even==forward_addr_ep6)?forward_data_ep6:
					(addr_2_even==forward_addr_op8)?forward_data_op8:
					(addr_2_even==forward_addr_ep7)?forward_data_ep7:
					(addr_2_even==forward_addr_op9)?forward_data_op9:
					(addr_2_even==forward_addr_ep8)?forward_data_ep8:
					data_in_2_even;
					
   assign data_out_3_even=(addr_3_even==forward_addr_op1)?forward_data_op1:
   					(addr_3_even==forward_addr_op2)?forward_data_op2:
   					(addr_3_even==forward_addr_ep1)?forward_data_ep1:
   					(addr_3_even==forward_addr_op3)?forward_data_op3:
   					(addr_3_even==forward_addr_ep2)?forward_data_ep2:
   					(addr_3_even==forward_addr_op4)?forward_data_op4:
   					(addr_3_even==forward_addr_ep3)?forward_data_ep3:
   					(addr_3_even==forward_addr_op5)?forward_data_op5:
   					(addr_3_even==forward_addr_ep4)?forward_data_ep4:
   					(addr_3_even==forward_addr_op6)?forward_data_op6:
					(addr_3_even==forward_addr_ep5)?forward_data_ep5:
					(addr_3_even==forward_addr_op7)?forward_data_op7:
					(addr_3_even==forward_addr_ep6)?forward_data_ep6:
					(addr_3_even==forward_addr_op8)?forward_data_op8:
					(addr_3_even==forward_addr_ep7)?forward_data_ep7:
					(addr_3_even==forward_addr_op9)?forward_data_op9:
					(addr_3_even==forward_addr_ep8)?forward_data_ep8:
					data_in_3_even;	
endmodule


