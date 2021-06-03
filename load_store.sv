module load_store(
	clk,
	reset,
	opcode,
	ra,
	rb,
	rc,
	immediate,
	result,
	write_signal,

	);
	input clk,reset;
	input [10:0] opcode;
	input [127:0] ra,rb,rc;
	input [9:0] immediate;
	input write_signal;
	output


	logic 	read_en;
	

	output  logic [127:0]result;

	always_comb
	begin
		case (opcode) 
			11'b00110100xxx:  //Load Quadword (d-form)
			begin
				assign result=result_1_temp;
				assign address=({{18{immediate[9]}},immediate,4'b0000}+ra[127:96])&32'hfffffff0;
				assign read_en=1;
			end
			11'b00111000100 : //Load Quadword (x-form)
			begin
				assign result=result_2_temp;
				assign address=(ra[127:96]+rb[127:96])&8'hfffffff0;
				assign read_en=1;
			end
			11'b00100100xxx : //Store Quadword (d-form)
			begin
				assign result =0;
				assign address=({{18{immediate[9]}},immediate,4'b0000}+ra[127:96])&32'hfffffff0;
				assign read_en=0;
			end
			11'b00101000100 :  //Store Quadword (x-form)
			begin
				assign result=0;
				assign address=(ra[127:96]+rb[127:96])&8'hfffffff0;
				assign read_en=0;
			end
			11'b00000000001 : //No Operation (Load)
			begin 
				assign result=0 ;
				assign address=0;
				assign read_en=0;
			end 
			11'b10101100000 : //load link
			begin 
				assign result=0 ;
				assign address=0;
				assign read_en=0;
			end 
			11'b10101000000 : //store conditional
			begin 
				assign result=0 ;
				assign address=0;
				assign read_en=0;
			end 
		default: 
		begin
			assign result=0;
			assign address=0;
			assign read_en=0;
		end
		endcase
	end


	
endmodule