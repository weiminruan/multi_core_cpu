
    module floating_point(opcode,ra,rb,rc,immediate,immediate_10_bits,result);
   
    input [10:0] opcode;
    input [127:0] ra,rb,rc;
    input unsigned[7:0] immediate;
    input [9:0] immediate_10_bits;
    output logic [127:0] result;

    logic signed[15:0] imm_signed;
    logic unsigned[15:0] imm_unsigned;
    logic unsigned[7:0] factor_scale,factor_scale_2;
    logic unsigned[31:0] factor_scale_amount;
    logic unsigned[50:0]factor_scale_2_amount;
    shortreal  ra1_word,ra2_word,ra3_word,ra4_word;
    shortreal  rb1_word,rb2_word,rb3_word,rb4_word;
    shortreal  rc1_word,rc2_word,rc3_word,rc4_word;
    shortreal  rt1_word,rt2_word,rt3_word,rt4_word;

    shortreal  ra1_word_abs,ra2_word_abs,ra3_word_abs,ra4_word_abs;
    shortreal  rb1_word_abs,rb2_word_abs,rb3_word_abs,rb4_word_abs;

    logic [31:0] rt1_word_result,rt2_word_result,rt3_word_result,rt4_word_result;

    integer rt1_word_float_int,rt2_word_float_int,rt3_word_float_int,rt4_word_float_int;
    integer unsigned rt1_word_float_int_unsigned,rt2_word_float_int_unsigned,rt3_word_float_int_unsigned,rt4_word_float_int_unsigned;

    integer ra1_word_int,ra2_word_int,ra3_word_int,ra4_word_int;
    
    integer unsigned ra1_word_int_unsigned,ra2_word_int_unsigned,ra3_word_int_unsigned,ra4_word_int_unsigned;


    logic signed[15:0] ra1_word_int_16bit,ra2_word_int_16bit,ra3_word_int_16bit,ra4_word_int_16bit;
    logic signed[15:0] rb1_word_int_16bit,rb2_word_int_16bit,rb3_word_int_16bit,rb4_word_int_16bit;
    logic signed[15:0] rc1_word_int,rc2_word_int,rc3_word_int,rc4_word_int;

    //logic [31:0] rb1_word_int,rb2_word_int,rb3_word_int,rb4_word_int;
    logic signed [15:0] ra1_word_int_16bit_high,ra2_word_int_16bit_high,ra3_word_int_16bit_high,ra4_word_int_16bit_high;



    logic unsigned [15:0] ra1_word_int_16bit_unsigned,ra2_word_int_16bit_unsigned,ra3_word_int_16bit_unsigned,ra4_word_int_16bit_unsigned;
    logic unsigned [15:0] rb1_word_int_16bit_unsigned,rb2_word_int_16bit_unsigned,rb3_word_int_16bit_unsigned,rb4_word_int_16bit_unsigned;


    logic signed [31:0] rt1_word_int,rt2_word_int,rt3_word_int,rt4_word_int;
    logic unsigned [31:0] rt1_word_int_unsigned,rt2_word_int_unsigned,rt3_word_int_unsigned,rt4_word_int_unsigned;

    assign imm_signed=(immediate_10_bits[9]==1)?{6'b111111,immediate_10_bits}:{6'b000000,immediate_10_bits};
    assign imm_unsigned=(immediate_10_bits[9]==1)?{6'b111111,immediate_10_bits}:{6'b000000,immediate_10_bits};

    assign ra4_word_int_16bit=ra[15:0];
    assign ra3_word_int_16bit=ra[47:32];
    assign ra2_word_int_16bit=ra[79:64];
    assign ra1_word_int_16bit=ra[111:96];

    assign rb4_word_int_16bit=rb[15:0];
    assign rb3_word_int_16bit=rb[47:32];
    assign rb2_word_int_16bit=rb[79:64];
    assign rb1_word_int_16bit=rb[111:96];

    assign ra4_word_int_16bit_high=ra[31:16];
    assign ra3_word_int_16bit_high=ra[64:48];
    assign ra2_word_int_16bit_high=ra[95:80];
    assign ra1_word_int_16bit_high=ra[127:112];



    assign ra4_word_int_16bit_unsigned=ra[15:0];
    assign ra3_word_int_16bit_unsigned=ra[47:32];
    assign ra2_word_int_16bit_unsigned=ra[79:64];
    assign ra1_word_int_16bit_unsigned=ra[111:96];


    assign rb4_word_int_16bit_unsigned=rb[15:0];
    assign rb3_word_int_16bit_unsigned=rb[47:32];
    assign rb2_word_int_16bit_unsigned=rb[79:64];
    assign rb1_word_int_16bit_unsigned=rb[111:96];

    assign rc4_word_int=rc[31:0];
    assign rc3_word_int=rc[63:32];
    assign rc2_word_int=rc[95:64];
    assign rc1_word_int=rc[127:96];

    assign ra4_word_int=ra[31:0];
    assign ra3_word_int=ra[63:32];
    assign ra2_word_int=ra[95:64];
    assign ra1_word_int=ra[127:96];

    assign ra4_word_int_unsigned=ra[31:0];
    assign ra3_word_int_unsigned=ra[63:32];
    assign ra2_word_int_unsigned=ra[95:64];
    assign ra1_word_int_unsigned=ra[127:96];

    assign ra4_word=$bitstoshortreal(ra[31:0]);
    assign ra3_word=$bitstoshortreal(ra[63:32]);
    assign ra2_word=$bitstoshortreal(ra[95:64]);
    assign ra1_word=$bitstoshortreal(ra[127:96]);

    assign rb4_word=$bitstoshortreal(rb[31:0]);
    assign rb3_word=$bitstoshortreal(rb[63:32]);
    assign rb2_word=$bitstoshortreal(rb[95:64]);
    assign rb1_word=$bitstoshortreal(rb[127:96]);

    assign rc4_word=$bitstoshortreal(rc[31:0]);
    assign rc3_word=$bitstoshortreal(rc[63:32]);
    assign rc2_word=$bitstoshortreal(rc[95:64]);
    assign rc1_word=$bitstoshortreal(rc[127:96]);

    assign factor_scale=155-immediate;
    assign factor_scale_2=173-immediate;
    assign factor_scale_amount=2**factor_scale;
    assign factor_scale_2_amount=2**factor_scale_2;

    always @ (opcode)
    case (opcode) 
    11'b01011000100:  //add
    begin
        assign rt1_word=ra1_word+rb1_word;
        assign rt2_word=ra2_word+rb2_word;
        assign rt3_word=ra3_word+rb3_word;
        assign rt4_word=ra4_word+rb4_word;
        assign rt1_word_result=$shortrealtobits(rt1_word);
        assign rt2_word_result=$shortrealtobits(rt2_word);
        assign rt3_word_result=$shortrealtobits(rt3_word);
        assign rt4_word_result=$shortrealtobits(rt4_word);
        assign result={rt1_word_result,rt2_word_result,rt3_word_result,rt4_word_result};
    end
    
    11'b01011000101 : //sub
    begin
        assign rt1_word=ra1_word-rb1_word;
        assign rt2_word=ra2_word-rb2_word;
        assign rt3_word=ra3_word-rb3_word;
        assign rt4_word=ra4_word-rb4_word;
        assign rt1_word_result=$shortrealtobits(rt1_word);
        assign rt2_word_result=$shortrealtobits(rt2_word);
        assign rt3_word_result=$shortrealtobits(rt3_word);
        assign rt4_word_result=$shortrealtobits(rt4_word);
        assign result={rt1_word_result,rt2_word_result,rt3_word_result,rt4_word_result};
    end
    
    11'b01011000110 :  //mul
    begin
        assign rt1_word=ra1_word*rb1_word;
        assign rt2_word=ra2_word*rb2_word;
        assign rt3_word=ra3_word*rb3_word;
        assign rt4_word=ra4_word*rb4_word;
        assign rt1_word_result=$shortrealtobits(rt1_word);
        assign rt2_word_result=$shortrealtobits(rt2_word);
        assign rt3_word_result=$shortrealtobits(rt3_word);
        assign rt4_word_result=$shortrealtobits(rt4_word);
        assign result={rt1_word_result,rt2_word_result,rt3_word_result,rt4_word_result};
    end
    
    11'b1110xxxxxxx:  // mul and add
    begin
        assign rt1_word=ra1_word*rb1_word+rc1_word;
        assign rt2_word=ra2_word*rb2_word+rc2_word;
        assign rt3_word=ra3_word*rb3_word+rc3_word;
        assign rt4_word=ra4_word*rb4_word+rc4_word;

        assign rt1_word_result=$shortrealtobits(rt1_word);
        assign rt2_word_result=$shortrealtobits(rt2_word);
        assign rt3_word_result=$shortrealtobits(rt3_word);
        assign rt4_word_result=$shortrealtobits(rt4_word);
        assign result={rt1_word_result,rt2_word_result,rt3_word_result,rt4_word_result};
    end
    
    11'b1111xxxxxxx: //mul and sub
    begin
        assign rt1_word=ra1_word*rb1_word-rc1_word;
        assign rt2_word=ra2_word*rb2_word-rc1_word;
        assign rt3_word=ra3_word*rb3_word-rc1_word;
        assign rt4_word=ra4_word*rb4_word-rc1_word;
        assign rt1_word_result=$shortrealtobits(rt1_word);
        assign rt2_word_result=$shortrealtobits(rt2_word);
        assign rt3_word_result=$shortrealtobits(rt3_word);
        assign rt4_word_result=$shortrealtobits(rt4_word);
        assign result={rt1_word_result,rt2_word_result,rt3_word_result,rt4_word_result};
    end
    
    11'b0111011010x: // signed int to float
    begin
        assign rt1_word=$itor(ra1_word_int) ;
        assign rt2_word=$itor(ra2_word_int) ;
        assign rt3_word=$itor(ra3_word_int) ;
        assign rt4_word=$itor(ra4_word_int) ;
        assign rt1_word_result=$shortrealtobits(rt1_word/(2**factor_scale));
        assign rt2_word_result=$shortrealtobits(rt2_word/(2**factor_scale));
        assign rt3_word_result=$shortrealtobits(rt3_word/(2**factor_scale));
        assign rt4_word_result=$shortrealtobits(rt4_word/(2**factor_scale));

        assign result={rt1_word_result,rt2_word_result,rt3_word_result,rt4_word_result};
    end
    
    11'b0111011000x:  //float to signed int
    begin
        assign rt1_word=ra1_word*factor_scale_2_amount;
        assign rt2_word=ra2_word*factor_scale_2_amount;
        assign rt3_word=ra3_word*factor_scale_2_amount;
        assign rt4_word=ra4_word*factor_scale_2_amount;
        assign rt1_word_float_int=$rtoi(rt1_word);
        assign rt2_word_float_int=$rtoi(rt2_word);
        assign rt3_word_float_int=$rtoi(rt3_word);
        assign rt4_word_float_int=$rtoi(rt4_word);
        assign rt1_word_result=rt1_word_float_int;
        assign rt2_word_result=rt2_word_float_int;
        assign rt3_word_result=rt3_word_float_int;
        assign rt4_word_result=rt4_word_float_int;
        assign result={rt1_word_result,rt2_word_result,rt3_word_result,rt4_word_result};
    end
  
    
    11'b0111011011x : //unsigned int to float
    begin
        assign rt1_word=$itor(ra1_word_int_unsigned);
        assign rt2_word=$itor(ra2_word_int_unsigned);
        assign rt3_word=$itor(ra3_word_int_unsigned);
        assign rt4_word=$itor(ra4_word_int_unsigned);
        assign rt1_word_result=$shortrealtobits(rt1_word/factor_scale_amount);
        assign rt2_word_result=$shortrealtobits(rt2_word/factor_scale_amount);
        assign rt3_word_result=$shortrealtobits(rt3_word/factor_scale_amount);
        assign rt4_word_result=$shortrealtobits(rt4_word/factor_scale_amount);
        assign result={rt1_word_result,rt2_word_result,rt3_word_result,rt4_word_result};
    end
    
    11'b0111011001x:  //float to unsigned int
    begin
        assign rt1_word=ra1_word*factor_scale_2_amount;
        assign rt2_word=ra2_word*factor_scale_2_amount;
        assign rt3_word=ra3_word*factor_scale_2_amount;
        assign rt4_word=ra4_word*factor_scale_2_amount;
        assign rt1_word_float_int_unsigned=$rtoi(rt1_word);
        assign rt2_word_float_int_unsigned=$rtoi(rt2_word);
        assign rt3_word_float_int_unsigned=$rtoi(rt3_word);
        assign rt4_word_float_int_unsigned=$rtoi(rt4_word);
        assign rt1_word_result=rt1_word_float_int_unsigned;
        assign rt2_word_result=rt2_word_float_int_unsigned;
        assign rt3_word_result=rt3_word_float_int_unsigned;
        assign rt4_word_result=rt4_word_float_int_unsigned;
        assign result={rt1_word_result,rt2_word_result,rt3_word_result,rt4_word_result};
    end
    
    11'b01111000010:  //float comp eual
    begin         
        assign rt1_word_result=(ra1_word==rb1_word)?32'b11111111111111111111111111111111:0;
        assign rt2_word_result=(ra2_word==rb2_word)?32'b11111111111111111111111111111111:0;
        assign rt3_word_result=(ra3_word==rb3_word)?32'b11111111111111111111111111111111:0; 
        assign rt4_word_result=(ra4_word==rb4_word)?32'b11111111111111111111111111111111:0;
        assign result={rt1_word_result,rt2_word_result,rt3_word_result,rt4_word_result};
    end
    
    11'b01111001010:  //float comp magnitude equal
    begin            
        assign ra1_word_abs=(ra1_word<0)?-1*ra1_word:ra1_word;
        assign ra2_word_abs=(ra2_word<0)?-1*ra1_word:ra2_word;
        assign ra3_word_abs=(ra3_word<0)?-1*ra1_word:ra3_word;
        assign ra4_word_abs=(ra4_word<0)?-1*ra1_word:ra4_word;

        assign rb1_word_abs=(rb1_word<0)?-1*rb1_word:rb1_word;
        assign rb2_word_abs=(rb2_word<0)?-1*rb1_word:rb2_word;
        assign rb3_word_abs=(rb3_word<0)?-1*rb1_word:rb3_word;
        assign rb4_word_abs=(rb4_word<0)?-1*rb1_word:rb4_word;

        assign rt1_word_result=(ra1_word_abs==rb1_word_abs)?32'b11111111111111111111111111111111:0;
        assign rt2_word_result=(ra2_word_abs==rb2_word_abs)?32'b11111111111111111111111111111111:0;
        assign rt3_word_result=(ra3_word_abs==rb3_word_abs)?32'b11111111111111111111111111111111:0; 
        assign rt4_word_result=(ra4_word_abs==rb4_word_abs)?32'b11111111111111111111111111111111:0;
        assign result={rt1_word_result,rt2_word_result,rt3_word_result,rt4_word_result};
  
    end
    
    11'b01011000010: // comp greater than
    begin         
        assign rt1_word_result=(ra1_word>rb1_word)?32'b11111111111111111111111111111111:0;
        assign rt2_word_result=(ra2_word>rb2_word)?32'b11111111111111111111111111111111:0;
        assign rt3_word_result=(ra3_word>rb3_word)?32'b11111111111111111111111111111111:0; 
        assign rt4_word_result=(ra4_word>rb4_word)?32'b11111111111111111111111111111111:0;
        assign result={rt1_word_result,rt2_word_result,rt3_word_result,rt4_word_result};
    end
    
    11'b01011001010: //comp mag greater than
    begin            
        assign ra1_word_abs=(ra1_word<0)?-1*ra1_word:ra1_word;
        assign ra2_word_abs=(ra2_word<0)?-1*ra1_word:ra2_word;
        assign ra3_word_abs=(ra3_word<0)?-1*ra1_word:ra3_word;
        assign ra4_word_abs=(ra4_word<0)?-1*ra1_word:ra4_word;

        assign rb1_word_abs=(rb1_word<0)?-1*rb1_word:rb1_word;
        assign rb2_word_abs=(rb2_word<0)?-1*rb1_word:rb2_word;
        assign rb3_word_abs=(rb3_word<0)?-1*rb1_word:rb3_word;
        assign rb4_word_abs=(rb4_word<0)?-1*rb1_word:rb4_word;

        assign rt1_word_result=(ra1_word_abs>rb1_word_abs)?32'b11111111111111111111111111111111:0;
        assign rt2_word_result=(ra2_word_abs>rb2_word_abs)?32'b11111111111111111111111111111111:0;
        assign rt3_word_result=(ra3_word_abs>rb3_word_abs)?32'b11111111111111111111111111111111:0; 
        assign rt4_word_result=(ra4_word_abs>rb4_word_abs)?32'b11111111111111111111111111111111:0;
        assign result={rt1_word_result,rt2_word_result,rt3_word_result,rt4_word_result};
  
    end
    
    11'b01111000100: //int mul
    begin         
        assign rt1_word_int=ra1_word_int_16bit*rb1_word_int_16bit;
        assign rt2_word_int=ra2_word_int_16bit*rb2_word_int_16bit;
        assign rt3_word_int=ra3_word_int_16bit*rb3_word_int_16bit; 
        assign rt4_word_int=ra4_word_int_16bit*rb4_word_int_16bit;
        assign result={rt1_word_int,rt2_word_int,rt3_word_int,rt4_word_int};
    end
    
    11'b01111001100: //int mul unsigned
    begin         
        assign rt1_word_int_unsigned=ra1_word_int_16bit_unsigned*rb1_word_int_16bit_unsigned;
        assign rt2_word_int_unsigned=ra2_word_int_16bit_unsigned*rb2_word_int_16bit_unsigned;
        assign rt3_word_int_unsigned=ra3_word_int_16bit_unsigned*rb3_word_int_16bit_unsigned; 
        assign rt4_word_int_unsigned=ra4_word_int_16bit_unsigned*rb4_word_int_16bit_unsigned;
        assign result={rt1_word_int_unsigned,rt2_word_int_unsigned,rt3_word_int_unsigned,rt4_word_int_unsigned};
    end
    
    11'b01110100xxx: //mul imm
    begin         
        assign rt1_word_int=ra1_word_int_16bit*imm_signed;
        assign rt2_word_int=ra2_word_int_16bit*imm_signed;
        assign rt3_word_int=ra3_word_int_16bit*imm_signed; 
        assign rt4_word_int=ra4_word_int_16bit*imm_signed;
        assign result={rt1_word_int,rt2_word_int,rt3_word_int,rt4_word_int};
    end   

    
    11'b01110101xxx: //mul unsigned imm
    begin         
        assign rt1_word_int_unsigned=ra1_word_int_16bit_unsigned*imm_unsigned;
        assign rt2_word_int_unsigned=ra2_word_int_16bit_unsigned*imm_unsigned;
        assign rt3_word_int_unsigned=ra3_word_int_16bit_unsigned*imm_unsigned; 
        assign rt4_word_int_unsigned=ra4_word_int_16bit_unsigned*imm_unsigned;
        assign result={rt1_word_int_unsigned,rt2_word_int_unsigned,rt3_word_int_unsigned,rt4_word_int_unsigned};
    end 
    
    11'b1100xxxxxxx: //mul and add
    begin         
        assign rt1_word_int=ra1_word_int_16bit*rb1_word_int_16bit+rc1_word_int;
        assign rt2_word_int=ra2_word_int_16bit*rb1_word_int_16bit+rc2_word_int;
        assign rt3_word_int=ra3_word_int_16bit*rb1_word_int_16bit+rc3_word_int; 
        assign rt4_word_int=ra4_word_int_16bit*rb1_word_int_16bit+rc4_word_int;
        assign result={rt1_word_int,rt2_word_int,rt3_word_int,rt4_word_int};
    end 
    
    11'b01111000101: //mul high
    begin         
        assign rt1_word_int=ra1_word_int_16bit_high*rb1_word_int_16bit;
        assign rt2_word_int=ra2_word_int_16bit_high*rb2_word_int_16bit;
        assign rt3_word_int=ra3_word_int_16bit_high*rb3_word_int_16bit;
        assign rt4_word_int=ra4_word_int_16bit_high*rb4_word_int_16bit;
        assign result={rt1_word_int[15:0],16'b0000000000000000,rt2_word_int[15:0],16'b0000000000000000,rt3_word_int[15:0],16'b0000000000000000,rt4_word_int[15:0],16'b0000000000000000};
    end 
    
    11'b01111000111: // mul and shift right
    begin         
        assign rt1_word_int=ra1_word_int_16bit*rb1_word_int_16bit;
        assign rt2_word_int=ra2_word_int_16bit*rb2_word_int_16bit;
        assign rt3_word_int=ra3_word_int_16bit*rb3_word_int_16bit; 
        assign rt4_word_int=ra4_word_int_16bit*rb4_word_int_16bit;
        assign result={{16{rt1_word_int[31]}},rt1_word_int[31:16],{16{rt2_word_int[31]}},rt2_word_int[31:16],{16{rt3_word_int[31]}},rt3_word_int[31:16],{16{rt4_word_int[31]}},rt4_word_int[31:16]};
    end
    
    default:
    begin
        assign result=0;
    end
    endcase
endmodule