module permute(opcode,ra,rb,imm_7bits,result);
	input [10:0] opcode;
	input [127:0] ra,rb;
	input signed[6:0] imm_7bits;
	output logic [127:0]result;

	logic unsigned [4:0]byte_count;
	logic unsigned [4:0]byte_count_imm;
	logic unsigned [3:0]bit_count;
	logic unsigned [3:0]bit_count_imm;
	logic signed[31:0]rb_pefered_word;

	assign rb_pefered_word=rb[127:96];

	assign byte_count=(0-rb_pefered_word)%32;
	assign byte_count_imm=(0-imm_7bits)%32;
	assign bit_count=(0-rb_pefered_word)%8;
	assign bit_count_imm=(0-imm_7bits)%8;
	always @(opcode)
	case (opcode)
		11'b00111011011 :  //Shift left quadword by Bits
		begin
			assign result=ra<<rb[98:96];
		end
		11'b00111111011 :  //Shift Left Quadword by Bits Immediate
		begin
			assign result=ra<<imm_7bits[2:0];
		end
		11'b00111011011 :  //Shift left quadword by bytes
		begin
			assign result=ra<<rb[100:96]*8;
		end
		11'b00111111011 :  //Shift Left Quadword by bytes Immediate
		begin
			assign result=ra<<imm_7bits[4:0]*8;
		end
		11'b00111011000 :  //Rotate Quadword by Bits
		begin
			assign result=(ra<<rb[98:96])|(ra>>(128-rb[98:96]));
		end
		11'b00111111000 :  //Rotate Quadword by Bits imm
		begin
			assign result=(ra<<imm_7bits[2:0])|(ra>>(128-imm_7bits[2:0]));
		end
		11'b00111011000 :  //Rotate Quadword by bytes
		begin
			assign result=(ra<<rb[99:96]*8)|(ra>>(128-rb[99:96]*8));
		end
		11'b00111111000 :  //Rotate Quadword by bytes imm
		begin
			assign result=(ra<<imm_7bits[3:0]*8)|(ra>>(128-imm_7bits[3:0]*8));
		end
		11'b00111111101 :  //Rotate and Mask Quadword by Bytes
		begin
			assign result=(byte_count<16)?(ra>>byte_count*8):0;
		end
		11'b00111001101 :  //Rotate and Mask Quadword by Bytes Immediate
		begin
			assign result=(byte_count_imm<16)?(ra>>byte_count_imm*8):0;
		end
		11'b00111011001 :  //Rotate and Mask Quadword by Bits
		begin
			assign result=ra>>(bit_count);
		end
		11'b00111111001  :  //Rotate and Mask Quadword by Bits Immediate
		begin
			assign result=ra>>(bit_count_imm);
		end
		
		default: 
		begin
			assign result=0;
		end
		endcase
	endmodule