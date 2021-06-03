module memory(
  clk,    
  rst,    
  board_number,
  data_bus_request,
  data_bus_gain,
  address_bus,
  data_bus,
  data_bus_id,
  addr_data_arbitration,
  feedback_addr
  );
  // --------------Port Declaration----------------------- 
  //rst and board number
  input           clk;    
  input           rst;
  input           [2:0]board_number;    
  //processor to cache controller ports

  //cache to bus ports
  inout           [36:0] address_bus;//32 bit addr + 2 bit cmd + 3 bit board number 
  output logic    data_bus_request;//ask for data bus access
  input           addr_data_arbitration;
  input           data_bus_gain;//0 if no gain, 1 if granted
  inout           [511:0] data_bus;//32bytes need two cycles to transfer a block
  inout           [2:0]data_bus_id;

  input           [31:0]feedback_addr;


  logic [511:0]memory[4095:0]; //256 KB, 64 byte block 12 bits for address is enough 
                                //4096 entrys of blocks,
                                //each block have 4 reg size data.

  logic [31:0]received_data_bus_addr;
  logic [1:0]received_data_bus_cmd;
  logic [2:0]received_data_bus_source_ID;
  logic [7:0] received_data_bus_index;
  logic [21:0] received_data_bus_tag;
  logic [11:0] received_data_bus_block_offset;
  //CIQ input
  logic CIQ_fifo_write_en;//must write 
  logic [1:0] CIQ_fifo_cmd;
  logic [2:0] CIQ_fifo_source_ID;
  logic [11:0] CIQ_fifo_block_offset;
  logic CIQ_fifo_valid;//check if data is in current cache
  logic [17:0]CIQ_fifo_information;
  //CIQ output
  logic [17:0]CIQ_head_information;
  logic [1:0] CIQ_head_cmd;
  logic [2:0] CIQ_head_source_ID;
  logic [11:0] CIQ_head_block_offset;


  //DROQ input
  logic DROQ_fifo_write_en;//must write 
  logic DROQ_fifo_request;
  logic [2:0] DROQ_fifo_source_iD;
  //logic [511:0] DROQ_fifo_data;
  logic [11:0] DROQ_fifo_block_offset;
  logic [15:0]DROQ_information;
  //DROQ output

  logic   data_bus_gain_reg_2;
  logic   data_bus_gain_reg;
  logic [2:0] top_DROQ_source_iD_reg_2;
  logic [2:0] top_DROQ_source_iD_reg;
 // logic [511:0] top_DROQ_data_reg_3;
 // logic [511:0] top_DROQ_data_reg_2;
 // logic [511:0] top_DROQ_data_reg;
  logic [15:0] top_DROQ_information;//
  logic top_DROQ_request;
  logic [2:0]top_DROQ_source_iD;
  logic [11:0]top_DROQ_block_offset;

  logic [11:0] top_DROQ_addr_reg;
  logic [11:0] top_DROQ_addr_reg_2;
  logic [11:0] top_DROQ_addr_reg_3;

  //feedback signals from responder
  logic [31:0]feedback_addr;
  logic [1:0]feedback_data_bus_block_offset;

  logic [31:0]feedback_data_bus_addr;
  logic [31:0]feedback_data_bus_addr_reg;
  logic [31:0]feedback_data_bus_addr_reg_2;
  logic feedback_write_en;
  logic feedback_write_en_reg;
  logic feedback_write_en_reg_2;
  logic [511:0]feedback_data;
  logic [511:0]feedback_data_reg;
  //bus to cache controller

  assign received_data_bus_source_ID=address_bus[2:0];
  assign received_data_bus_cmd=address_bus[4:3];
  assign received_data_bus_addr=address_bus[36:5];
  assign received_data_bus_block_offset=received_data_bus_addr[13:2];// 12 bit 
 
  //put into CIQ
  always_comb 
  begin 
    if (received_data_bus_cmd==2'b01 ||received_data_bus_cmd==2'b10 ||received_data_bus_cmd==2'b11) //not idle
    begin
      if(received_data_bus_block_offset<=4095)//yes,contains the cache line //????
      begin
        CIQ_fifo_write_en=1'b1;
        CIQ_fifo_valid=1'b1;
        CIQ_fifo_cmd=received_data_bus_cmd;
        CIQ_fifo_source_ID=received_data_bus_source_ID;
        CIQ_fifo_block_offset=received_data_bus_block_offset;
      end
      else// no detected
      begin
        CIQ_fifo_write_en=1'b1;
        CIQ_fifo_valid=1'b0;
        CIQ_fifo_cmd=2'b00;
        CIQ_fifo_source_ID=3'b000;
        CIQ_fifo_block_offset=0;
      end
    end
    else
    begin
      CIQ_fifo_write_en=1'b0;
      CIQ_fifo_valid=1'b0;
      CIQ_fifo_cmd=0;
      CIQ_fifo_source_ID=0;
      CIQ_fifo_block_offset=0;

    end
  end

  //change state of the cache based on cmd
  //CIQ_fifo_valid,CIQ_fifo_cmd,CIQ_fifo_source_ID,
  assign CIQ_fifo_information={CIQ_fifo_valid,CIQ_fifo_cmd,CIQ_fifo_source_ID,CIQ_fifo_block_offset}; //1+2+3+12
  logic one_logic;
  logic CIQ_empty;
  assign one_logic=1'b1&&!CIQ_empty;

  sync_fifo #( 
  .depth(8), 
  .width(18)
  )
  CIQ(//one cycle to write,to read
  .clk(clk),
  .reset(rst),
  .wr_enable(CIQ_fifo_write_en),
  .rd_enable(one_logic),
  .empty(CIQ_empty),
  .full(full),
  .rd_data(CIQ_head_information),
  .wr_data(CIQ_fifo_information),
  .count(count));

  assign CIQ_head_valid=(CIQ_empty==0)?CIQ_head_information[17]:0;
  assign CIQ_head_cmd=(CIQ_empty==0)?CIQ_head_information[16:15]:0;
  assign CIQ_head_source_ID=(CIQ_empty==0)?CIQ_head_information[14:12]:0;
  assign CIQ_head_block_offset=(CIQ_empty==0)?CIQ_head_information[11:0]:0;


  always_comb 
  begin 
    if(CIQ_head_cmd==2'b01 || CIQ_head_cmd==2'b10 || CIQ_head_cmd==2'b11)//not idle and not writeback
    begin
      if(CIQ_head_valid==1'b1)
      begin
        if(CIQ_head_cmd==2'b11)//writeback
        begin
          DROQ_fifo_write_en=1'b1;
          DROQ_fifo_source_iD=3'b0;
          //DROQ_fifo_data=512'b0;
          DROQ_fifo_request=1'b0;
          DROQ_fifo_block_offset=CIQ_head_block_offset;

        end
        else if(CIQ_head_cmd==2'b01)//read to share
        begin
          DROQ_fifo_write_en=1'b1;
          DROQ_fifo_source_iD=CIQ_head_source_ID;
          //DROQ_fifo_data=memory[CIQ_head_block_offset];
          DROQ_fifo_request=1'b1;
          DROQ_fifo_block_offset=CIQ_head_block_offset;
        end
        else//read to own
        begin
          DROQ_fifo_write_en=1'b1;
          DROQ_fifo_source_iD=CIQ_head_source_ID;
         // DROQ_fifo_data=memory[CIQ_head_block_offset];
          DROQ_fifo_request=1'b1;
          DROQ_fifo_block_offset=CIQ_head_block_offset;
        end
      end
      else//not valid, does'nt have cache line
      begin
        DROQ_fifo_write_en=1'b1;
        DROQ_fifo_source_iD=0;
        //DROQ_fifo_data=0;
        DROQ_fifo_request=1'b0;
        DROQ_fifo_block_offset=12'b0;
      end
    end
    else//idle
    begin
        DROQ_fifo_write_en=1'b0;
        DROQ_fifo_source_iD=3'b000;
        //DROQ_fifo_data=512'b0000;
        DROQ_fifo_request=1'b0;
        DROQ_fifo_block_offset=12'b0;
    end
  end
  
  assign DROQ_information={DROQ_fifo_source_iD,DROQ_fifo_block_offset,DROQ_fifo_request};//3+12+1
  logic rd_enable;
  logic DROQ_empty;
  assign rd_enable=~addr_data_arbitration & ~DROQ_empty;
  sync_fifo #( 
  .depth(8), 
  .width(16)
  )
  DROQ(//one cycle to write, same cycle to read
  .clk(clk),
  .reset(rst),
  .wr_enable(DROQ_fifo_write_en),
  .rd_enable(~addr_data_arbitration),
  .empty(DROQ_empty),
  .full(DROQ_full),
  .rd_data(top_DROQ_information),
  .wr_data(DROQ_information),
  .count(count));


  //module for issuing data bus ins

  always_ff @(posedge clk or posedge rst) 
  begin 
    if(rst) begin  
      data_bus_gain_reg_2<=0;
      data_bus_gain_reg<=0;
      top_DROQ_source_iD_reg_2 <= 0;
      top_DROQ_source_iD_reg <= 0;
     // top_DROQ_data_reg_3 <= 0;
      //top_DROQ_data_reg_2 <= 0;
      //top_DROQ_data_reg <= 0;
      top_DROQ_addr_reg_2 <= 0;
      top_DROQ_addr_reg_3 <= 0;
      top_DROQ_addr_reg <= 0;
  end
    else 
    begin 
        begin
          data_bus_gain_reg_2<=data_bus_gain_reg;
          data_bus_gain_reg<=data_bus_gain;
          top_DROQ_source_iD_reg_2 <= top_DROQ_source_iD_reg;
          top_DROQ_source_iD_reg <= top_DROQ_source_iD;
          //top_DROQ_data_reg_3 <= top_DROQ_data_reg_2;
          //top_DROQ_data_reg_2 <= top_DROQ_data_reg;
          //top_DROQ_data_reg <= top_DROQ_data;
          top_DROQ_addr_reg_2 <= top_DROQ_addr_reg;
          top_DROQ_addr_reg_3 <= top_DROQ_addr_reg_2 ;
          top_DROQ_addr_reg <= top_DROQ_block_offset;
        end
    end
  end
  //ask for data bus
  assign data_bus_request=(DROQ_empty==0 && addr_data_arbitration==0)?top_DROQ_information[0]:1'b0;
  assign top_DROQ_source_iD=(DROQ_empty==0 && addr_data_arbitration==0)?top_DROQ_information[15:13]:1'b0;
  assign top_DROQ_block_offset=(DROQ_empty==0 && addr_data_arbitration==0)?top_DROQ_information[12:1]:1'b0;

  //issue data bus request
  assign data_bus_id=(data_bus_gain_reg==1)?top_DROQ_source_iD_reg_2:3'bz;
  assign data_bus=(data_bus_gain_reg_2==1)?memory[top_DROQ_addr_reg_3]:512'bz;


  //feedback signal (bus to cache (DIQ))
  assign feedback_data=data_bus;
  
  always_comb 
  begin
    //receive data bus
    if(data_bus_id==board_number)
    begin
      feedback_data_bus_addr<=feedback_addr;
      feedback_write_en<=1;
    end
    else
    begin
      feedback_data_bus_addr<=0;
      feedback_write_en<=0;
    end
  end

  always_ff @(posedge clk or posedge rst) 
  begin 
    if(rst) begin
       feedback_write_en_reg<= 0;
       feedback_write_en_reg_2<= 0;
       feedback_data_bus_addr_reg<= 0;
       feedback_data_bus_addr_reg_2<= 0;
       feedback_data_reg<= 0;
    end else begin
       feedback_write_en_reg<= feedback_write_en;
       feedback_write_en_reg_2<= feedback_write_en_reg;
       feedback_data_bus_addr_reg<= feedback_data_bus_addr;
       feedback_data_bus_addr_reg_2<= feedback_data_bus_addr_reg;
       feedback_data_reg<= feedback_data;
    end
  end

  always_ff @(posedge clk or posedge rst) begin
  //reset 
  if(rst) 
  begin
    memory[0]<={32'b01000001011100000000000000000000,
    		   32'b01000001011000000000000000000000,
    		   32'b01000001010100000000000000000000,
    		   32'b01000001010000000000000000000000,
    		   32'b01000001001100000000000000000000,
    		   32'b01000001001000000000000000000000,
    		   32'b01000001000100000000000000000000,
    		   32'b01000001000000000000000000000000,
    		   32'b01000000111000000000000000000000,
    		   32'b01000000110000000000000000000000,
    		   32'b01000000101000000000000000000000,
    		   32'b01000000100000000000000000000000,
    		   32'b01000000010000000000000000000000,
    		   32'b01000000000000000000000000000000,
    		   32'b00111111100000000000000000000000,
    		   32'b00000000000000000000000000000000};
    memory[1]<={
				32'b01000000010000000000000000000000,
				32'b01000000010000000000000000000000,
				32'b01000000010000000000000000000000,
				32'b01000000010000000000000000000000,
				32'b01000000000000000000000000000000,
				32'b01000000000000000000000000000000,
				32'b01000000000000000000000000000000,
				32'b01000000000000000000000000000000,
				32'b00111111100000000000000000000000,
				32'b00111111100000000000000000000000,
				32'b00111111100000000000000000000000,
				32'b00111111100000000000000000000000,
				32'b00000000000000000000000000000000,
				32'b00000000000000000000000000000000,
				32'b00000000000000000000000000000000,
				32'b00000000000000000000000000000000};
		//memory2	
	memory[2]<={	
				32'b01000000111000000000000000000000,
				32'b01000000111000000000000000000000,
				32'b01000000111000000000000000000000,
				32'b01000000111000000000000000000000,
				32'b01000000110000000000000000000000,
				32'b01000000110000000000000000000000,
				32'b01000000110000000000000000000000,
				32'b01000000110000000000000000000000,
				32'b01000000101000000000000000000000,
				32'b01000000101000000000000000000000,
				32'b01000000101000000000000000000000,
				32'b01000000101000000000000000000000,
				32'b01000000100000000000000000000000,
				32'b01000000100000000000000000000000,
				32'b01000000100000000000000000000000,
				32'b01000000100000000000000000000000};
		//memory3
	memory[3]<={
				32'b01000001001100000000000000000000,
				32'b01000001001100000000000000000000,
				32'b01000001001100000000000000000000,
				32'b01000001001100000000000000000000,
				32'b01000001001000000000000000000000,
				32'b01000001001000000000000000000000,
				32'b01000001001000000000000000000000,
				32'b01000001001000000000000000000000,
				32'b01000001000100000000000000000000,
				32'b01000001000100000000000000000000,
				32'b01000001000100000000000000000000,
				32'b01000001000100000000000000000000,
				32'b01000001000000000000000000000000,
				32'b01000001000000000000000000000000,
				32'b01000001000000000000000000000000,
				32'b01000001000000000000000000000000};
//memory4
	memory[4]<={
				32'b01000001011100000000000000000000,
				32'b01000001011100000000000000000000,
				32'b01000001011100000000000000000000,
				32'b01000001011100000000000000000000,
				32'b01000001011000000000000000000000,
				32'b01000001011000000000000000000000,
				32'b01000001011000000000000000000000,
				32'b01000001011000000000000000000000,
				32'b01000001010100000000000000000000,
				32'b01000001010100000000000000000000,
				32'b01000001010100000000000000000000,
				32'b01000001010100000000000000000000,
				32'b01000001010000000000000000000000,
				32'b01000001010000000000000000000000,
				32'b01000001010000000000000000000000,
				32'b01000001010000000000000000000000};	

    for(int i=5;i<4096;i=i+1)
    begin
      memory[i]<=512'b0;
    end
  end
  else 
  begin
    if(feedback_write_en_reg_2==1)
    begin
      memory[feedback_data_bus_addr_reg_2]<=feedback_data_reg;
    end 
  end
end
endmodule