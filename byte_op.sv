module byte_op(opcode,ra,rb,result);

	input [10:0] opcode;
	input [127:0] ra,rb;
	output logic [127:0]result;

	logic [7:0] ra1_byte,ra2_byte,ra3_byte,ra4_byte,ra5_byte,ra6_byte,ra7_byte,ra8_byte,ra9_byte,ra10_byte,ra11_byte,ra12_byte,ra13_byte,ra14_byte,ra15_byte,ra16_byte;
	logic [7:0] rb1_byte,rb2_byte,rb3_byte,rb4_byte,rb5_byte,rb6_byte,rb7_byte,rb8_byte,rb9_byte,rb10_byte,rb11_byte,rb12_byte,rb13_byte,rb14_byte,rb15_byte,rb16_byte;
	
	logic [15:0] sum_b1,sum_b2,sum_b3,sum_b4;
	logic [15:0] sum_a1,sum_a2,sum_a3,sum_a4;

	logic [8:0] sum1_byte,sum2_byte,sum3_byte,sum4_byte,sum5_byte,sum6_byte,sum7_byte,sum8_byte,sum9_byte,sum10_byte,sum11_byte,sum12_byte,sum13_byte,sum14_byte,sum15_byte,sum16_byte;
	logic [7:0] sum1_byte_shift,sum2_byte_shift,sum3_byte_shift,sum4_byte_shift,sum5_byte_shift,sum6_byte_shift,sum7_byte_shift,sum8_byte_shift,sum9_byte_shift,sum10_byte_shift,sum11_byte_shift,sum12_byte_shift,sum13_byte_shift,sum14_byte_shift,sum15_byte_shift,sum16_byte_shift;
	
	logic unsigned [7:0] ra1_byte_unsigned,ra2_byte_unsigned,ra3_byte_unsigned,ra4_byte_unsigned,ra5_byte_unsigned,ra6_byte_unsigned,ra7_byte_unsigned,ra8_byte_unsigned,ra9_byte_unsigned,ra10_byte_unsigned,ra11_byte_unsigned,ra12_byte_unsigned,ra13_byte_unsigned,ra14_byte_unsigned,ra15_byte_unsigned,ra16_byte_unsigned;
	logic unsigned [7:0] rb1_byte_unsigned,rb2_byte_unsigned,rb3_byte_unsigned,rb4_byte_unsigned,rb5_byte_unsigned,rb6_byte_unsigned,rb7_byte_unsigned,rb8_byte_unsigned,rb9_byte_unsigned,rb10_byte_unsigned,rb11_byte_unsigned,rb12_byte_unsigned,rb13_byte_unsigned,rb14_byte_unsigned,rb15_byte_unsigned,rb16_byte_unsigned;
	logic unsigned [7:0] sum1_byte_unsigned,sum2_byte_unsigned,sum3_byte_unsigned,sum4_byte_unsigned,sum5_byte_unsigned,sum6_byte_unsigned,sum7_byte_unsigned,sum8_byte_unsigned,sum9_byte_unsigned,sum10_byte_unsigned,sum11_byte_unsigned,sum12_byte_unsigned,sum13_byte_unsigned,sum14_byte_unsigned,sum15_byte_unsigned,sum16_byte_unsigned;

	assign ra16_byte=ra[7:0];
	assign ra15_byte=ra[15:8];
	assign ra14_byte=ra[23:16];
	assign ra13_byte=ra[31:24];
	assign ra12_byte=ra[39:32];
	assign ra11_byte=ra[47:40];
	assign ra10_byte=ra[55:48];
	assign ra9_byte=ra[63:56];
	assign ra8_byte=ra[71:64];
	assign ra7_byte=ra[79:72];
	assign ra6_byte=ra[87:80];
	assign ra5_byte=ra[95:88];
	assign ra4_byte=ra[103:96];
	assign ra3_byte=ra[111:104];
	assign ra2_byte=ra[119:112];
	assign ra1_byte=ra[127:120];

	assign rb16_byte=rb[7:0];
	assign rb15_byte=rb[15:8];
	assign rb14_byte=rb[23:16];
	assign rb13_byte=rb[31:24];
	assign rb12_byte=rb[39:32];
	assign rb11_byte=rb[47:40];
	assign rb10_byte=rb[55:48];
	assign rb9_byte=rb[63:56];
	assign rb8_byte=rb[71:64];
	assign rb7_byte=rb[79:72];
	assign rb6_byte=rb[87:80];
	assign rb5_byte=rb[95:88];
	assign rb4_byte=rb[103:96];
	assign rb3_byte=rb[111:104];
	assign rb2_byte=rb[119:112];
	assign rb1_byte=rb[127:120];

	assign ra16_byte_unsigned=ra[7:0];
	assign ra15_byte_unsigned=ra[15:8];
	assign ra14_byte_unsigned=ra[23:16];
	assign ra13_byte_unsigned=ra[31:24];
	assign ra12_byte_unsigned=ra[39:32];
	assign ra11_byte_unsigned=ra[47:40];
	assign ra10_byte_unsigned=ra[55:48];
	assign ra9_byte_unsigned=ra[63:56];
	assign ra8_byte_unsigned=ra[71:64];
	assign ra7_byte_unsigned=ra[79:72];
	assign ra6_byte_unsigned=ra[87:80];
	assign ra5_byte_unsigned=ra[95:88];
	assign ra4_byte_unsigned=ra[103:96];
	assign ra3_byte_unsigned=ra[111:104];
	assign ra2_byte_unsigned=ra[119:112];
	assign ra1_byte_unsigned=ra[127:120];

	assign rb16_byte_unsigned=rb[7:0];
	assign rb15_byte_unsigned=rb[15:8];
	assign rb14_byte_unsigned=rb[23:16];
	assign rb13_byte_unsigned=rb[31:24];
	assign rb12_byte_unsigned=rb[39:32];
	assign rb11_byte_unsigned=rb[47:40];
	assign rb10_byte_unsigned=rb[55:48];
	assign rb9_byte_unsigned=rb[63:56];
	assign rb8_byte_unsigned=rb[71:64];
	assign rb7_byte_unsigned=rb[79:72];
	assign rb6_byte_unsigned=rb[87:80];
	assign rb5_byte_unsigned=rb[95:88];
	assign rb4_byte_unsigned=rb[103:96];
	assign rb3_byte_unsigned=rb[111:104];
	assign rb2_byte_unsigned=rb[119:112];
	assign rb1_byte_unsigned=rb[127:120];
	always@(opcode)
		case (opcode) 
			11'b01010110100 :  //count ones in bytes
			begin
				
				assign sum1_byte_unsigned=ra1_byte[0]+ra1_byte[1]+ra1_byte[2]+ra1_byte[3]+ra1_byte[4]+ra1_byte[5]+ra1_byte[6]+ra1_byte[7];
				assign sum2_byte_unsigned=ra2_byte[0]+ra2_byte[1]+ra2_byte[2]+ra2_byte[3]+ra2_byte[4]+ra2_byte[5]+ra2_byte[6]+ra2_byte[7];
				assign sum3_byte_unsigned=ra3_byte[0]+ra3_byte[1]+ra3_byte[2]+ra3_byte[3]+ra3_byte[4]+ra3_byte[5]+ra3_byte[6]+ra3_byte[7];
				assign sum4_byte_unsigned=ra4_byte[0]+ra4_byte[1]+ra4_byte[2]+ra4_byte[3]+ra4_byte[4]+ra4_byte[5]+ra4_byte[6]+ra4_byte[7];
				assign sum5_byte_unsigned=ra5_byte[0]+ra5_byte[1]+ra5_byte[2]+ra5_byte[3]+ra5_byte[4]+ra5_byte[5]+ra5_byte[6]+ra5_byte[7];
				assign sum6_byte_unsigned=ra6_byte[0]+ra6_byte[1]+ra6_byte[2]+ra6_byte[3]+ra6_byte[4]+ra6_byte[5]+ra6_byte[6]+ra6_byte[7];
				assign sum7_byte_unsigned=ra7_byte[0]+ra7_byte[1]+ra7_byte[2]+ra7_byte[3]+ra7_byte[4]+ra7_byte[5]+ra7_byte[6]+ra7_byte[7];
				assign sum8_byte_unsigned=ra8_byte[0]+ra8_byte[1]+ra8_byte[2]+ra8_byte[3]+ra8_byte[4]+ra8_byte[5]+ra8_byte[6]+ra8_byte[7];
				assign sum9_byte_unsigned=ra9_byte[0]+ra9_byte[1]+ra9_byte[2]+ra9_byte[3]+ra9_byte[4]+ra9_byte[5]+ra9_byte[6]+ra9_byte[7];
				assign sum10_byte_unsigned=ra10_byte[0]+ra10_byte[1]+ra10_byte[2]+ra10_byte[3]+ra10_byte[4]+ra10_byte[5]+ra10_byte[6]+ra10_byte[7];
				assign sum11_byte_unsigned=ra11_byte[0]+ra11_byte[1]+ra11_byte[2]+ra11_byte[3]+ra11_byte[4]+ra11_byte[5]+ra11_byte[6]+ra11_byte[7];
				assign sum12_byte_unsigned=ra12_byte[0]+ra12_byte[1]+ra12_byte[2]+ra12_byte[3]+ra12_byte[4]+ra12_byte[5]+ra12_byte[6]+ra12_byte[7];
				assign sum13_byte_unsigned=ra13_byte[0]+ra13_byte[1]+ra13_byte[2]+ra13_byte[3]+ra13_byte[4]+ra13_byte[5]+ra13_byte[6]+ra13_byte[7];
				assign sum14_byte_unsigned=ra14_byte[0]+ra14_byte[1]+ra14_byte[2]+ra14_byte[3]+ra14_byte[4]+ra14_byte[5]+ra14_byte[6]+ra14_byte[7];
				assign sum15_byte_unsigned=ra15_byte[0]+ra15_byte[1]+ra15_byte[2]+ra15_byte[3]+ra15_byte[4]+ra15_byte[5]+ra15_byte[6]+ra15_byte[7];
				assign sum16_byte_unsigned=ra16_byte[0]+ra16_byte[1]+ra16_byte[2]+ra16_byte[3]+ra16_byte[4]+ra16_byte[5]+ra16_byte[6]+ra16_byte[7];
				assign result={sum1_byte_unsigned,sum2_byte_unsigned,sum3_byte_unsigned,sum4_byte_unsigned,sum5_byte_unsigned,sum6_byte_unsigned,sum7_byte_unsigned,sum8_byte_unsigned,sum9_byte_unsigned,sum10_byte_unsigned,sum11_byte_unsigned,sum12_byte_unsigned,sum13_byte_unsigned,sum14_byte_unsigned,sum15_byte_unsigned,sum16_byte_unsigned};
			end
			
			11'b01001010011 :  //Sum Bytes into Halfwords
			begin
				assign sum_b1=rb1_byte_unsigned+rb2_byte_unsigned+rb3_byte_unsigned+rb4_byte_unsigned;
				assign sum_b2=rb5_byte_unsigned+rb6_byte_unsigned+rb7_byte_unsigned+rb8_byte_unsigned;
				assign sum_b3=rb9_byte_unsigned+rb10_byte_unsigned+rb11_byte_unsigned+rb12_byte_unsigned;
				assign sum_b4=rb13_byte_unsigned+rb14_byte_unsigned+rb15_byte_unsigned+rb16_byte_unsigned;
				assign sum_a1=ra1_byte_unsigned+ra2_byte_unsigned+ra3_byte_unsigned+ra4_byte_unsigned;
				assign sum_a2=ra5_byte_unsigned+ra6_byte_unsigned+ra7_byte_unsigned+ra8_byte_unsigned;
				assign sum_a3=ra9_byte_unsigned+ra10_byte_unsigned+ra11_byte_unsigned+ra12_byte_unsigned;
				assign sum_a4=ra13_byte_unsigned+ra14_byte_unsigned+ra15_byte_unsigned+ra16_byte_unsigned;
				assign result={sum_b1,sum_a1,sum_b2,sum_a2,sum_b3,sum_a3,sum_b4,sum_a4};
			end
			
			11'b00011010011 :  //Average Bytes
			begin
				assign sum1_byte=rb1_byte+ra1_byte+1;
				assign sum2_byte=rb2_byte+ra2_byte+1;
				assign sum3_byte=rb3_byte+ra3_byte+1;
				assign sum4_byte=rb4_byte+ra4_byte+1;
				assign sum5_byte=rb5_byte+ra5_byte+1;
				assign sum6_byte=rb6_byte+ra6_byte+1;
				assign sum7_byte=rb7_byte+ra7_byte+1;
				assign sum8_byte=rb8_byte+ra8_byte+1;
				assign sum9_byte=rb9_byte+ra9_byte+1;
				assign sum10_byte=rb10_byte+ra10_byte+1;
				assign sum11_byte=rb11_byte+ra11_byte+1;
				assign sum12_byte=rb12_byte+ra12_byte+1;
				assign sum13_byte=rb13_byte+ra13_byte+1;
				assign sum14_byte=rb14_byte+ra14_byte+1;
				assign sum15_byte=rb15_byte+ra15_byte+1;
				assign sum16_byte=rb16_byte+ra16_byte+1;
				
				assign sum1_byte_shift=sum1_byte>>1;
				assign sum2_byte_shift=sum2_byte>>1;
				assign sum3_byte_shift=sum3_byte>>1;
				assign sum4_byte_shift=sum4_byte>>1;
				assign sum5_byte_shift=sum5_byte>>1;
				assign sum6_byte_shift=sum6_byte>>1;
				assign sum7_byte_shift=sum7_byte>>1;
				assign sum8_byte_shift=sum8_byte>>1;
				assign sum9_byte_shift=sum9_byte>>1;
				assign sum10_byte_shift=sum10_byte>>1;
				assign sum11_byte_shift=sum11_byte>>1;
				assign sum12_byte_shift=sum12_byte>>1;
				assign sum13_byte_shift=sum13_byte>>1;
				assign sum14_byte_shift=sum14_byte>>1;
				assign sum15_byte_shift=sum15_byte>>1;
				assign sum16_byte_shift=sum16_byte>>1;
				assign result={sum1_byte_shift,sum2_byte_shift,sum3_byte_shift,sum4_byte_shift,sum5_byte_shift,sum6_byte_shift,sum7_byte_shift,sum8_byte_shift,sum9_byte_shift,sum10_byte_shift,sum11_byte_shift,sum12_byte_shift,sum13_byte_shift,sum14_byte_shift,sum15_byte_shift,sum16_byte_shift};
			end
			
			11'b00001010011 : //Absolute Differences of Bytes
			begin
				assign sum1_byte_unsigned=(rb1_byte_unsigned>ra1_byte_unsigned)?rb1_byte_unsigned-ra1_byte_unsigned:(ra1_byte_unsigned-rb1_byte_unsigned);
				assign sum2_byte_unsigned=(rb2_byte_unsigned>ra2_byte_unsigned)?rb2_byte_unsigned-ra2_byte_unsigned:(ra2_byte_unsigned-rb2_byte_unsigned);
				assign sum3_byte_unsigned=(rb3_byte_unsigned>ra3_byte_unsigned)?rb3_byte_unsigned-ra3_byte_unsigned:(ra3_byte_unsigned-rb3_byte_unsigned);
				assign sum4_byte_unsigned=(rb4_byte_unsigned>ra4_byte_unsigned)?rb4_byte_unsigned-ra4_byte_unsigned:(ra4_byte_unsigned-rb4_byte_unsigned);
				assign sum5_byte_unsigned=(rb5_byte_unsigned>ra5_byte_unsigned)?rb5_byte_unsigned-ra5_byte_unsigned:(ra4_byte_unsigned-rb5_byte_unsigned);
				assign sum6_byte_unsigned=(rb6_byte_unsigned>ra6_byte_unsigned)?rb6_byte_unsigned-ra6_byte_unsigned:(ra4_byte_unsigned-rb6_byte_unsigned);
				assign sum7_byte_unsigned=(rb7_byte_unsigned>ra7_byte_unsigned)?rb7_byte_unsigned-ra7_byte_unsigned:(ra4_byte_unsigned-rb7_byte_unsigned);
				assign sum8_byte_unsigned=(rb8_byte_unsigned>ra8_byte_unsigned)?rb8_byte_unsigned-ra8_byte_unsigned:(ra4_byte_unsigned-rb8_byte_unsigned);
				assign sum9_byte_unsigned=(rb9_byte_unsigned>ra9_byte_unsigned)?rb9_byte_unsigned-ra9_byte_unsigned:(ra4_byte_unsigned-rb9_byte_unsigned);
				assign sum10_byte_unsigned=(rb10_byte_unsigned>ra10_byte_unsigned)?rb10_byte_unsigned-ra10_byte_unsigned:(ra4_byte_unsigned-rb10_byte_unsigned);
				assign sum11_byte_unsigned=(rb11_byte_unsigned>ra11_byte_unsigned)?rb11_byte_unsigned-ra11_byte_unsigned:(ra4_byte_unsigned-rb11_byte_unsigned);
				assign sum12_byte_unsigned=(rb12_byte_unsigned>ra12_byte_unsigned)?rb12_byte_unsigned-ra12_byte_unsigned:(ra4_byte_unsigned-rb12_byte_unsigned);
				assign sum13_byte_unsigned=(rb13_byte_unsigned>ra13_byte_unsigned)?rb13_byte_unsigned-ra13_byte_unsigned:(ra4_byte_unsigned-rb13_byte_unsigned);
				assign sum14_byte_unsigned=(rb14_byte_unsigned>ra14_byte_unsigned)?rb14_byte_unsigned-ra14_byte_unsigned:(ra4_byte_unsigned-rb14_byte_unsigned);
				assign sum15_byte_unsigned=(rb15_byte_unsigned>ra15_byte_unsigned)?rb15_byte_unsigned-ra15_byte_unsigned:(ra4_byte_unsigned-rb15_byte_unsigned);
				assign sum16_byte_unsigned=(rb16_byte_unsigned>ra16_byte_unsigned)?rb16_byte_unsigned-ra16_byte_unsigned:(ra4_byte_unsigned-rb16_byte_unsigned);
				
				assign result={sum1_byte_unsigned,sum2_byte_unsigned,sum3_byte_unsigned,sum4_byte_unsigned,sum5_byte_unsigned,sum6_byte_unsigned,sum7_byte_unsigned,sum8_byte_unsigned,sum9_byte_unsigned,sum10_byte_unsigned,sum11_byte_unsigned,sum12_byte_unsigned,sum13_byte_unsigned,sum14_byte_unsigned,sum15_byte_unsigned,sum16_byte_unsigned};
				
			end
			
		default: assign result=0;
endcase
endmodule