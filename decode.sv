
module decode(
//input
instruction_in,
//output
immediate_7_bit,
immediate_8_bit,
immediate_10_bit,
immediate_16_bit,
immediate_18_bit,
opcode,
write_signal_load_store,
addr_reg_1,
addr_reg_2,
addr_reg_3,
write_reg_addr_reg,
reg_read_signal,
reg_write_signal,
instruction_parity,
instruction_latency
);
input [31:0] instruction_in;
output logic[6:0] immediate_7_bit;
output logic[7:0] immediate_8_bit;
output logic[9:0] immediate_10_bit;
output logic[15:0] immediate_16_bit;
output logic[17:0] immediate_18_bit;
output logic[10:0] opcode;
output logic write_signal_load_store;
output logic[6:0] addr_reg_1,addr_reg_2,addr_reg_3;
output logic[6:0] write_reg_addr_reg;
output logic unsigned [3:0]instruction_latency;
output logic reg_read_signal,reg_write_signal;
output logic instruction_parity;//odd is 1 even is zero


always@*
begin
   //even pipe
   if(instruction_in[31:21]==11'b00011001000|| //add halfword
      instruction_in[31:21]==11'b00011000000|| //add word
      instruction_in[31:21]==11'b00001001000|| //subtract halfword
      instruction_in[31:21]==11'b00001000000|| //subtract word
      instruction_in[31:21]==11'b01101000000|| //add extended 
      instruction_in[31:21]==11'b00011000010|| //carry generate
      instruction_in[31:21]==11'b01101000001|| //subtract from extended
      instruction_in[31:21]==11'b00001000010|| //borrow generate
      instruction_in[31:21]==11'b01010100101|| // count leading zeros
      instruction_in[31:21]==11'b00011000001|| //and
      instruction_in[31:21]==11'b01011000001|| //and with complement
      instruction_in[31:21]==11'b00001000001|| //or
      instruction_in[31:21]==11'b01011001001|| //or with complement
      instruction_in[31:21]==11'b01001000001|| //exclusive or
      instruction_in[31:21]==11'b00011001001|| //nand
      instruction_in[31:21]==11'b00001001001|| //nor
      instruction_in[31:21]==11'b01001001001|| //equivalent
      instruction_in[31:21]==11'b01111010000|| //compare equal byte
      instruction_in[31:21]==11'b01111001000|| //compare equal halfword
      instruction_in[31:21]==11'b01111000000|| //compare equal word
      instruction_in[31:21]==11'b01001010000|| //compare greater than byte
      instruction_in[31:21]==11'b01001001000|| //compare greater than halfword
      instruction_in[31:21]==11'b01001000000|| //compare greater than word
      instruction_in[31:21]==11'b01011010000|| //compare logical greater than byte
      instruction_in[31:21]==11'b01011001000|| //compare logical greater than halfword
      instruction_in[31:21]==11'b01011000000|| //compare logical greater than word
      //simply fixed 2
      instruction_in[31:21]==11'b00001011111|| //shift left halfword
      instruction_in[31:21]==11'b00001011011|| //shift left word
      instruction_in[31:21]==11'b00001011100|| //rotate halfword
      instruction_in[31:21]==11'b00001011000|| //rotate word
      instruction_in[31:21]==11'b00001011101|| //rotate and mask halfword
      instruction_in[31:21]==11'b00001011001|| //rotate and mask word
      instruction_in[31:21]==11'b00001011110|| //rotate and mask algebraic halfword
      instruction_in[31:21]==11'b00001011010|| //rotate and mask algebraic word
      //floating op
      instruction_in[31:21]==11'b01011000100|| //floating add
	  instruction_in[31:21]==11'b01011000101|| //floating subtract
	  instruction_in[31:21]==11'b01011000110|| //floating multiply
	  instruction_in[31:21]==11'b01111000010|| //floating compare equal
	  instruction_in[31:21]==11'b01111001010|| //floating compare magnitude equal
	  instruction_in[31:21]==11'b01011000010|| //floating compare greater than
	  instruction_in[31:21]==11'b01011001010|| //floating compare magnitude greater than
	  instruction_in[31:21]==11'b01111000100|| //multiply
	  instruction_in[31:21]==11'b01111001100|| //multiply unsigned
	  instruction_in[31:21]==11'b01111000101|| //Multiply High
	  instruction_in[31:21]==11'b01111000111|| //Multiply and shift right
	  //byte
	  instruction_in[31:21]==11'b01010110100|| //Count Ones in Bytes
	  instruction_in[31:21]==11'b01001010011|| //sum bytes into halfwords
	  instruction_in[31:21]==11'b00011010011|| //average bytes
	  instruction_in[31:21]==11'b00001010011 //absolute differences of bytes
      )
   begin
   	    reg_read_signal=1;
	    reg_write_signal=1;
	    instruction_parity=0;
	    opcode=instruction_in[31:21];
	    addr_reg_1=instruction_in[13:7];
	    addr_reg_2=instruction_in[20:14];
	    write_reg_addr_reg=instruction_in[6:0];
	    addr_reg_3=0;
	    write_signal_load_store=0;
	    immediate_7_bit=0;
	    immediate_8_bit=0;
	    immediate_10_bit=0;
	    immediate_16_bit=0;
	    immediate_18_bit=0;
   end 			//simply fixed 2
  	else if(instruction_in[31:21]==11'b00001111111 ||//shift left halfword immediate 7bits immediate
		    instruction_in[31:21]==11'b00001111011 ||//shift left word immediate
		    instruction_in[31:21]==11'b00001111100 || //rotate halfword immediate
		    instruction_in[31:21]==11'b00001111000 || //rotate word immediate
		    instruction_in[31:21]==11'b00001111101 || //rotate and mask halfword immediate
		    instruction_in[31:21]==11'b00001111001 || //rotate and mask word immediate
		    instruction_in[31:21]==11'b00001111110 || //Rotate and Mask Algebraic Halfword Immediate
		    instruction_in[31:21]==11'b00001111010  //Rotate and Mask Algebraic word Immediate
		     )//
   begin
   	    reg_read_signal=1;
	    reg_write_signal=1;
	    instruction_parity=0;
	    opcode=instruction_in[31:21];
	    addr_reg_1=instruction_in[13:7];
	    addr_reg_2=0;
	    write_reg_addr_reg=instruction_in[6:0];
	    addr_reg_3=0;
	    write_signal_load_store=0;
	    immediate_7_bit=instruction_in[20:14];
	    immediate_8_bit=0;
	    immediate_10_bit=0;
	    immediate_16_bit=0;
	    immediate_18_bit=0;
   end 			//simply fixed 1
   else if( instruction_in[31:24]==8'b00011101|| //add halfword immdiate 10bit immediate
            instruction_in[31:24]==8'b00011100|| //add word immdiate
            instruction_in[31:24]==8'b00001101|| //subtract from halfword immediate
            instruction_in[31:24]==8'b00001100|| //subtract from word immediate
            instruction_in[31:24]==8'b00010110|| //And Byte Immediate
            instruction_in[31:24]==8'b00010101|| //And halfword Immediate
            instruction_in[31:24]==8'b00010100|| //And word Immediate
            instruction_in[31:24]==8'b00000110|| //or Byte Immediate
            instruction_in[31:24]==8'b00000101|| //or halfword Immediate
            instruction_in[31:24]==8'b00000100|| //or word Immediate
            instruction_in[31:24]==8'b01000110|| //xor Byte Immediate
            instruction_in[31:24]==8'b01000101|| //xor halfword Immediate
            instruction_in[31:24]==8'b01000100|| //xor word Immediate
            instruction_in[31:24]==8'b01111110|| //compare equal byte immediate
            instruction_in[31:24]==8'b01111101|| //compare equal halfword immediate
            instruction_in[31:24]==8'b01111100|| //compare equal word immediate
            instruction_in[31:24]==8'b01001110|| //compare greater than byte immediate
            instruction_in[31:24]==8'b01001101|| //compare greater than halfword immediate
            instruction_in[31:24]==8'b01001100|| //compare greater than word immediate
            instruction_in[31:24]==8'b01011110|| //compare logical greater than byte immediate
            instruction_in[31:24]==8'b01011101|| //compare logical greater than halfword immediate
            instruction_in[31:24]==8'b01011100|| //compare logical greater than word immediate
            //floating 
            instruction_in[31:24]==8'b01110100|| //multiply immediate
            instruction_in[31:24]==8'b01110101 //multiply unsigned immediate
         )
   begin
   	    reg_read_signal=1;
	    reg_write_signal=1;
	    instruction_parity=0;
	    opcode={instruction_in[31:24],3'bxxx};
	    addr_reg_1=instruction_in[13:7];
	    addr_reg_2=0;
	    write_reg_addr_reg=instruction_in[6:0];
	    addr_reg_3=0;
	    write_signal_load_store=0;
	    immediate_7_bit=0;
	    immediate_8_bit=0;
	    immediate_10_bit=instruction_in[23:14];
	    immediate_16_bit=0;
	    immediate_18_bit=0;
   end
   else if(instruction_in[31:23]==9'b010000011 ||//immediate load halfword
         instruction_in[31:23]==9'b010000010 ||//immediate load halfword upper
         instruction_in[31:23]==9'b010000001 //immediate load word
         )//
   begin
   	    reg_read_signal=0;
	    reg_write_signal=1;
	    instruction_parity=0;
	    opcode={instruction_in[31:23],2'bxx};
	    addr_reg_1=0;
	    addr_reg_2=0;
	    write_reg_addr_reg=instruction_in[6:0];
	    addr_reg_3=0;
	    write_signal_load_store=0;
	    immediate_7_bit=0;
	    immediate_8_bit=0;
	    immediate_10_bit=0;
	    immediate_16_bit=instruction_in[22:7];
	    immediate_18_bit=0;
   end
   else if(instruction_in[31:25]==7'b0100001)//immediate load address)
   begin
   	    reg_read_signal=1;
	    reg_write_signal=1;
	    instruction_parity=0;
	    opcode={instruction_in[31:25],4'bxxxx};
	    addr_reg_1=0;
	    addr_reg_2=0;
	    write_reg_addr_reg=instruction_in[6:0];
	    addr_reg_3=0;
	    write_signal_load_store=0;
	    immediate_7_bit=0;
	    immediate_8_bit=0;
	    immediate_10_bit=0;
	    immediate_16_bit=0;
	    immediate_18_bit=instruction_in[31:7];
   end
   else if(instruction_in[31:28]==4'b1000 ||//select bit
   			instruction_in[31:28]==4'b1110 ||//floating multiply and add
   			instruction_in[31:28]==4'b1111 ||//floating multiply and subtract
   			instruction_in[31:28]==4'b1100 //Multiply and Add
         )//
   begin
   	    reg_read_signal=1;
	    reg_write_signal=1;
	    instruction_parity=0;
	    opcode={instruction_in[31:28],7'bxxxxxxx};
	    addr_reg_1=instruction_in[13:7];
	    addr_reg_2=instruction_in[20:14];
	    write_reg_addr_reg=instruction_in[27:21];
	    addr_reg_3=instruction_in[6:0];
	    write_signal_load_store=0;
	    immediate_7_bit=0;
	    immediate_8_bit=0;
	    immediate_10_bit=0;
	    immediate_16_bit=0;
	    immediate_18_bit=0;
   end
  else if(instruction_in[31:22]==10'b0111011010 ||//convert signed integer to floating
  		  instruction_in[31:22]==10'b0111011000 ||//convert floating to signed integer
  		  instruction_in[31:22]==10'b0111011011 ||//convert unsigned integer to floating
  		  instruction_in[31:22]==10'b0111011001 //convert floating to unsigned integer
     )//
   begin
   	    reg_read_signal=1; 
	    reg_write_signal=1;
	    instruction_parity=0;
	    opcode={instruction_in[31:22],1'bx};
	    addr_reg_1=instruction_in[13:7];
	    addr_reg_2=0;
	    write_reg_addr_reg=instruction_in[6:0];
	    addr_reg_3=0;
	    write_signal_load_store=0;
	    immediate_7_bit=0;
	    immediate_8_bit=instruction_in[21:14];
	    immediate_10_bit=0;
	    immediate_16_bit=0;
	    immediate_18_bit=0;
   end
   else if(instruction_in[31:21]==11'b01000000001) //nop execute)//
   begin 
   	    reg_read_signal=0; 
	    reg_write_signal=0;
	    instruction_parity=0;
	    opcode=instruction_in[31:21];
	    addr_reg_1=0;
	    addr_reg_2=0;
	    write_reg_addr_reg=0;
	    addr_reg_3=0;
	    write_signal_load_store=0;
	    immediate_7_bit=0;
	    immediate_8_bit=0;
	    immediate_10_bit=0;
	    immediate_16_bit=0;
	    immediate_18_bit=0;
   end
   //odd pipe
   else if(instruction_in[31:21]==11'b00111011011 ||//shift left quadword by bits
   			instruction_in[31:21]==11'b00111011111 ||//shift left quadword by bytes
   			instruction_in[31:21]==11'b00111011000 ||//rotate quadword by bits
   			instruction_in[31:21]==11'b00111011100 ||//rotate quadword by bytes
   			instruction_in[31:21]==11'b00111011001 ||//rotate and mask quadword by bits
   			instruction_in[31:21]==11'b00111011101 ||//rotate and mask quadword by bytes
   			instruction_in[31:21]==11'b00111000100 //load quadword(x-form)||

    )//
    begin
   		 reg_read_signal=1; 
	     reg_write_signal=1;
	     instruction_parity=1;
	     opcode=instruction_in[31:21];
	     addr_reg_1=instruction_in[13:7];
	     addr_reg_2=instruction_in[20:14];
	     write_reg_addr_reg=instruction_in[6:0];
	     addr_reg_3=0;
	     write_signal_load_store=0;
	     immediate_7_bit=0;
	     immediate_8_bit=0;
	     immediate_10_bit=0;
	     immediate_16_bit=0;
	     immediate_18_bit=0;
    end
    else if(instruction_in[31:21]==11'b00111111011 ||//shift left quadword by bits immediate 7 bits
   			instruction_in[31:21]==11'b00111111011 ||//shift left quadword by bytes immediate
   			instruction_in[31:21]==11'b00111111000 ||//rotate quadword by bits immediate
   			instruction_in[31:21]==11'b00111111100 ||//rotate quadword by bytes immediate
   			instruction_in[31:21]==11'b00111111001 ||//rotate and mask quadword by bits immediate
   			instruction_in[31:21]==11'b00111111101 //rotate and mask quadword by bytes immediate
    )
    begin
   	     reg_read_signal=1; 
	     reg_write_signal=1;
	     instruction_parity=1;
	     opcode=instruction_in[31:21];
	     addr_reg_1=instruction_in[13:7];
	     addr_reg_2=0;
	     write_reg_addr_reg=instruction_in[6:0];
	     addr_reg_3=0;
	     write_signal_load_store=0;
	     immediate_7_bit=instruction_in[20:14];
	     immediate_8_bit=0;
	     immediate_10_bit=0;
	     immediate_16_bit=0;
	     immediate_18_bit=0;
    end
    else if(instruction_in[31:21]==11'b00101000100)//store quadword(x-form)
    begin
    	 reg_read_signal=1; 
	     reg_write_signal=0;
	     instruction_parity=1;
	     opcode=instruction_in[31:21];
	     addr_reg_1=instruction_in[13:7];
	     addr_reg_2=instruction_in[20:14];
	     write_reg_addr_reg=0;
	     addr_reg_3=instruction_in[6:0];
	     write_signal_load_store=1;
	     immediate_7_bit=0;
	     immediate_8_bit=0;
	     immediate_10_bit=0;
	     immediate_16_bit=0;
	     immediate_18_bit=0;
    end	
    else if(instruction_in[31:26]==6'b101011)//load link
    begin
    	 reg_read_signal=1; 
	     reg_write_signal=1;
	     instruction_parity=1;
	     opcode={instruction_in[31:26],5'b0};
	     addr_reg_1=instruction_in[25:19];
	     addr_reg_2=0;
	     write_reg_addr_reg=instruction_in[18:11];
	     addr_reg_3=0;
	     write_signal_load_store=0;
	     immediate_7_bit=0;
	     immediate_8_bit=0;
	     immediate_10_bit=instruction_in[9:0];
	     immediate_16_bit=0;
	     immediate_18_bit=0;
    end
    else if(instruction_in[31:26]==6'b101010)//store conditional
    begin
    	 reg_read_signal=1; 
	     reg_write_signal=1;
	     instruction_parity=1;
	     opcode={instruction_in[31:26],5'b0};
	     addr_reg_1=instruction_in[25:21];
	     addr_reg_2=0;
	     write_reg_addr_reg=instruction_in[20:16];
	     addr_reg_3=instruction_in[20:16];
	     write_signal_load_store=1;
	     immediate_7_bit=0;
	     immediate_8_bit=0;
	     immediate_10_bit=0;
	     immediate_16_bit=instruction_in[15:0];
	     immediate_18_bit=0;
    end
    else if(instruction_in[31:21]==11'b00000000001)//no operation(load)
    begin
    	 reg_read_signal=0; 
	     reg_write_signal=0;
	     instruction_parity=1;
	     opcode=instruction_in[31:21];
	     addr_reg_1=0;
	     addr_reg_2=0;
	     write_reg_addr_reg=0;
	     addr_reg_3=0;
	     write_signal_load_store=0;
	     immediate_7_bit=0;
	     immediate_8_bit=0;
	     immediate_10_bit=0;
	     immediate_16_bit=0;
	     immediate_18_bit=0;
    end
    else if(instruction_in[31:24]==8'b00110100)//load quadword(d form) 10 bit immediate
	begin 
		 reg_read_signal=1; 
	     reg_write_signal=1;
	     instruction_parity=1;
	     opcode={instruction_in[31:24],3'bxxx};
	     addr_reg_1=instruction_in[13:7];
	     addr_reg_2=0;
	     write_reg_addr_reg=instruction_in[6:0];
	     addr_reg_3=0;
	     write_signal_load_store=0;
	     immediate_7_bit=0;
	     immediate_8_bit=0;
	     immediate_10_bit=instruction_in[23:14];
	     immediate_16_bit=0;
	     immediate_18_bit=0;
    end
    else if(instruction_in[31:24]==8'b00100100) //store quadword(d form) ) 10 bit immediate
    begin
    	 reg_read_signal=1; 
	     reg_write_signal=0;
	     instruction_parity=1;
	     opcode={instruction_in[31:24],3'bxxx};
	     addr_reg_1=instruction_in[13:7];
	     addr_reg_2=0;
	     write_reg_addr_reg=0;
	     addr_reg_3=instruction_in[6:0];
	     write_signal_load_store=1;
	     immediate_7_bit=0;
	     immediate_8_bit=0;
	     immediate_10_bit=instruction_in[23:14];
	     immediate_16_bit=0;
	     immediate_18_bit=0;
    end
    else if(instruction_in[31:23]==9'b001100100 ||//branch relative //16 bits immediate
   			instruction_in[31:23]==9'b001100000 //branch absolute //16 bits immediate
    )//
    begin
    	 reg_read_signal=0; 
	     reg_write_signal=0;
	     instruction_parity=1;
	     opcode={instruction_in[31:23],2'bxx};
	     addr_reg_1=0;
	     addr_reg_2=0;
	     write_reg_addr_reg=0;
	     addr_reg_3=0;
	     write_signal_load_store=0;
	     immediate_7_bit=0;
	     immediate_8_bit=0;
	     immediate_10_bit=0;
	     immediate_16_bit=instruction_in[22:7];
	     immediate_18_bit=0;
    end
    else if(instruction_in[31:23]==9'b001100110 ||//branch relative and set link//16 bits immediate
			instruction_in[31:23]==9'b001100010 //branch absolute and set link//16 bits immediate
    )//
    begin
    	 reg_read_signal=0; 
	     reg_write_signal=0;
	     instruction_parity=1;
	     opcode={instruction_in[31:23],2'bxx};
	     addr_reg_1=0;
	     addr_reg_2=0;
	     write_reg_addr_reg=instruction_in[6:0];
	     addr_reg_3=0;
	     write_signal_load_store=0;
	     immediate_7_bit=0;
	     immediate_8_bit=0;
	     immediate_10_bit=0;
	     immediate_16_bit=instruction_in[22:7];
	     immediate_18_bit=0;
    end
    else if(instruction_in[31:21]==11'b00110101000)//branch indirect
    begin
    	 reg_read_signal=1; 
	     reg_write_signal=0;
	     instruction_parity=1;
	     opcode=instruction_in[31:21];
	     addr_reg_1=instruction_in[13:7];
	     addr_reg_2=0;
	     write_reg_addr_reg=0;
	     addr_reg_3=0;
	     write_signal_load_store=0;
	     immediate_7_bit=0;
	     immediate_8_bit=0;
	     immediate_10_bit=0;
	     immediate_16_bit=0;
	     immediate_18_bit=0;
    end
    else if(instruction_in[31:23]==9'b001000010 ||//branch if not zero word
			instruction_in[31:23]==9'b001000000 ||//branch if zero word
			instruction_in[31:23]==9'b001000110 ||//branch if not zero halfword
			instruction_in[31:23]==9'b001000110 //branch if zero halfword
    )//
    begin
    	 reg_read_signal=1; 
	     reg_write_signal=0;
	     instruction_parity=1;
	     opcode={instruction_in[31:23],2'bxx};
	     addr_reg_1=0;
	     addr_reg_2=0;
	     write_reg_addr_reg=0;
	     addr_reg_3=instruction_in[6:0];
	     write_signal_load_store=0;
	     immediate_7_bit=0;
	     immediate_8_bit=0;
	     immediate_10_bit=0;
	     immediate_16_bit=instruction_in[22:7];
	     immediate_18_bit=0;
    end
    else if(instruction_in[31:21]==11'b00000000000) //stop and signal
    begin
    	 reg_read_signal=0; 
	     reg_write_signal=0;
	     instruction_parity=1;
	     opcode=instruction_in[31:21];
	     addr_reg_1=0;
	     addr_reg_2=0;
	     write_reg_addr_reg=0;
	     addr_reg_3=0;
	     write_signal_load_store=0;
	     immediate_7_bit=0;
	     immediate_8_bit=0;
	     immediate_10_bit=0;
	     immediate_16_bit=0;
	     immediate_18_bit=0;
    end
    else//nop
   	begin
   		 reg_read_signal=0; 
	     reg_write_signal=0;
	     instruction_parity=1'bx;
	     opcode=11'bxxxxxxxxxxx;
	     addr_reg_1=0;
	     addr_reg_2=0;
	     write_reg_addr_reg=0;
	     addr_reg_3=0;
	     write_signal_load_store=0;
	     immediate_7_bit=0;
	     immediate_8_bit=0;
	     immediate_10_bit=0;
	     immediate_16_bit=0;
	     immediate_18_bit=0;
   	end
end

always@*
begin
    //delay lantency ment
	if(//simply fixed 1
	instruction_in[31:21]==11'b00011001000|| //add halfword
	instruction_in[31:21]==11'b00011000000|| //add word
	instruction_in[31:21]==11'b00001001000|| //subtract halfword
	instruction_in[31:21]==11'b00001000000|| //subtract word
	instruction_in[31:21]==11'b01101000000|| //add extended 
	instruction_in[31:21]==11'b00011000010|| //carry generate
	instruction_in[31:21]==11'b01101000001|| //subtract from extended
	instruction_in[31:21]==11'b00001000010|| //borrow generate
	instruction_in[31:21]==11'b01010100101|| // count leading zeros
	instruction_in[31:21]==11'b00011000001|| //and
	instruction_in[31:21]==11'b01011000001|| //and with complement
	instruction_in[31:21]==11'b00001000001|| //or
	instruction_in[31:21]==11'b01011001001|| //or with complement
	instruction_in[31:21]==11'b01001000001|| //exclusive or
	instruction_in[31:21]==11'b00011001001|| //nand
	instruction_in[31:21]==11'b00001001001|| //nor
	instruction_in[31:21]==11'b01001001001|| //equivalent
	instruction_in[31:21]==11'b01111010000|| //compare equal byte
	instruction_in[31:21]==11'b01111001000|| //compare equal halfword
	instruction_in[31:21]==11'b01111000000|| //compare equal word
	instruction_in[31:21]==11'b01001010000|| //compare greater than byte
	instruction_in[31:21]==11'b01001001000|| //compare greater than halfword
	instruction_in[31:21]==11'b01001000000|| //compare greater than word
	instruction_in[31:21]==11'b01011010000|| //compare logical greater than byte
	instruction_in[31:21]==11'b01011001000|| //compare logical greater than halfword
	instruction_in[31:21]==11'b01011000000||
	instruction_in[31:24]==8'b00011101|| //add halfword immdiate 10bit immediate
	instruction_in[31:24]==8'b00011100|| //add word immdiate
	instruction_in[31:24]==8'b00001101|| //subtract from halfword immediate
	instruction_in[31:24]==8'b00001100|| //subtract from word immediate
	instruction_in[31:24]==8'b00010110|| //And Byte Immediate
	instruction_in[31:24]==8'b00010101|| //And halfword Immediate
	instruction_in[31:24]==8'b00010100|| //And word Immediate
	instruction_in[31:24]==8'b00000110|| //or Byte Immediate
	instruction_in[31:24]==8'b00000101|| //or halfword Immediate
	instruction_in[31:24]==8'b00000100|| //or word Immediate
	instruction_in[31:24]==8'b01000110|| //xor Byte Immediate
	instruction_in[31:24]==8'b01000101|| //xor halfword Immediate
	instruction_in[31:24]==8'b01000100|| //xor word Immediate
	instruction_in[31:24]==8'b01111110|| //compare equal byte immediate
	instruction_in[31:24]==8'b01111101|| //compare equal halfword immediate
	instruction_in[31:24]==8'b01111100|| //compare equal word immediate
	instruction_in[31:24]==8'b01001110|| //compare greater than byte immediate
	instruction_in[31:24]==8'b01001101|| //compare greater than halfword immediate
	instruction_in[31:24]==8'b01001100|| //compare greater than word immediate
	instruction_in[31:24]==8'b01011110|| //compare logical greater than byte immediate
	instruction_in[31:24]==8'b01011101|| //compare logical greater than halfword immediate
	instruction_in[31:24]==8'b01011100|| //compare logical greater than word immediate)//simply fixed
    instruction_in[31:23]==9'b010000011 ||//immediate load halfword
	instruction_in[31:23]==9'b010000010 ||//immediate load halfword upper
	instruction_in[31:23]==9'b010000001 ||//immediate load wordbegin
    instruction_in[31:25]==7'b0100001||//immediate load address
    instruction_in[31:28]==4'b1000||//select bit
    instruction_in[31:21]==11'b01000000001//nop execute
    )
	begin
    	 instruction_latency=2;
    end

    else if(//simply fixed 2
    instruction_in[31:21]==11'b00001011111|| //shift left halfword
	instruction_in[31:21]==11'b00001011011|| //shift left word
	instruction_in[31:21]==11'b00001011100|| //rotate halfword
	instruction_in[31:21]==11'b00001011000|| //rotate word
	instruction_in[31:21]==11'b00001011101|| //rotate and mask halfword
	instruction_in[31:21]==11'b00001011001|| //rotate and mask word
	instruction_in[31:21]==11'b00001011110|| //rotate and mask algebraic halfword
	instruction_in[31:21]==11'b00001011010|| //rotate and mask algebraic word
    instruction_in[31:21]==11'b00001111111 ||//shift left halfword immediate 7bits immediate
    instruction_in[31:21]==11'b00001111011 ||//shift left word immediate
    instruction_in[31:21]==11'b00001111100 || //rotate halfword immediate
    instruction_in[31:21]==11'b00001111000 || //rotate word immediate
    instruction_in[31:21]==11'b00001111101 || //rotate and mask halfword immediate
    instruction_in[31:21]==11'b00001111001 || //rotate and mask word immediate
    instruction_in[31:21]==11'b00001111110 || //Rotate and Mask Algebraic Halfword Immediate
    instruction_in[31:21]==11'b00001111010) //Rotate and Mask Algebraic word Immediatebegin
    begin
    	 instruction_latency=4;
    end

    else if//signle precision float 
    (
	instruction_in[31:21]==11'b01011000100|| //floating add
	instruction_in[31:21]==11'b01011000101|| //floating subtract
	instruction_in[31:21]==11'b01011000110|| //floating multiply
	instruction_in[31:28]==4'b1110 ||//floating multiply and add
   	instruction_in[31:28]==4'b1111 ||//floating multiply and subtract
	instruction_in[31:21]==11'b01111000010|| //floating compare equal
	instruction_in[31:21]==11'b01111001010|| //floating compare magnitude equal
	instruction_in[31:21]==11'b01011000010|| //floating compare greater than
	instruction_in[31:21]==11'b01011001010 //floating compare magnitude greater than
	)
    begin
    	 instruction_latency=5;
    end
    
    else if //signle precision int
    (
	instruction_in[31:22]==10'b0111011010 ||//convert signed integer to floating
	instruction_in[31:22]==10'b0111011000 ||//convert floating to signed integer
	instruction_in[31:22]==10'b0111011011 ||//convert unsigned integer to floating
	instruction_in[31:22]==10'b0111011001 || //convert floating to unsigned integer
    instruction_in[31:21]==11'b01111000100|| //multiply
	instruction_in[31:21]==11'b01111001100|| //multiply unsigned
	instruction_in[31:21]==11'b01111000101|| //Multiply High
	instruction_in[31:21]==11'b01111000111|| //Multiply and shift right
	instruction_in[31:28]==4'b1100|| //Multiply and Add
	instruction_in[31:24]==8'b01110100|| //multiply immediate
    instruction_in[31:24]==8'b01110101 //multiply unsigned immediate
    )
    begin
    	 instruction_latency=7;
    end
    
    else if//byte
    (
	instruction_in[31:21]==11'b01010110100|| //Count Ones in Bytes
	instruction_in[31:21]==11'b01001010011|| //sum bytes into halfwords
	instruction_in[31:21]==11'b00011010011|| //average bytes
	instruction_in[31:21]==11'b00001010011 //absolute differences of bytes
    )
    begin
    	 instruction_latency=4;
    end

    else if//permute
    (
	instruction_in[31:21]==11'b00111011011 ||//shift left quadword by bits
	instruction_in[31:21]==11'b00111011111 ||//shift left quadword by bytes
	instruction_in[31:21]==11'b00111011000 ||//rotate quadword by bits
	instruction_in[31:21]==11'b00111011100 ||//rotate quadword by bytes
	instruction_in[31:21]==11'b00111011001 ||//rotate and mask quadword by bits
	instruction_in[31:21]==11'b00111011101 ||//rotate and mask quadword by bytes
	instruction_in[31:21]==11'b00111111011 ||//shift left quadword by bits immediate 7 bits
	instruction_in[31:21]==11'b00111111011 ||//shift left quadword by bytes immediate
	instruction_in[31:21]==11'b00111111000 ||//rotate quadword by bits immediate
	instruction_in[31:21]==11'b00111111100 ||//rotate quadword by bytes immediate
	instruction_in[31:21]==11'b00111111001 ||//rotate and mask quadword by bits immediate
	instruction_in[31:21]==11'b00111111101 //rotate and mask quadword by bytes immediate
    )
    begin
    	 instruction_latency=4;
    end
    
    else if//local store
    (
    instruction_in[31:24]==8'b00110100||//load quadword(d form) 10 bit immediate
    instruction_in[31:21]==11'b00111000100|| //load quadword(x-form)
    instruction_in[31:24]==8'b00100100|| //store quadword(d form) ) 10 bit immediate
    instruction_in[31:21]==11'b00101000100//store quadword(x-form)
    )
    begin
    	 instruction_latency=6;
    end

    else if//branch
    (
	instruction_in[31:23]==9'b001100100 ||//branch relative //16 bits immediate
	instruction_in[31:23]==9'b001100000 ||//branch absolute //16 bits immediate
	instruction_in[31:21]==11'b00110101000||//branch indirect
	instruction_in[31:23]==9'b001100110 ||//branch relative and set link//16 bits immediate
	instruction_in[31:23]==9'b001100010 ||//branch absolute and set link//16 bits immediate
	instruction_in[31:23]==9'b001000010 ||//branch if not zero word
	instruction_in[31:23]==9'b001000000 ||//branch if zero word
	instruction_in[31:23]==9'b001000110 ||//branch if not zero halfword
	instruction_in[31:23]==9'b001000110 ||//branch if zero halfword
	instruction_in[31:21]==11'b00000000000) //stop and signal
    begin
    	 instruction_latency=1;
    end
    else
    begin
    	 instruction_latency=0;
    end
end
endmodule

