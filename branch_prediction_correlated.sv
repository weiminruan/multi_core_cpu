module branch_prediction_correlated(
  clk,
  reset,
  single_stall,//from dependence
  both_stall,//from dependence
  same_parity,//from dependence
  old_pc_from_decode_stage,//from dependence
  feedback_pc_from_branch_stage,//from branch
  real_take_or_not_signal,//from branch
  branch_signal,//from branch
  correct_pc,//from branch
  flush_signal,//output
  pc,//output
  cache_stall
  );

  input clk,reset,single_stall,both_stall,same_parity;
  input [31:0]old_pc_from_decode_stage;
  input [31:0]feedback_pc_from_branch_stage;
  input [31:0]correct_pc;
  input real_take_or_not_signal;
  input branch_signal;
  input cache_stall;
  output logic [31:0]pc;
  output logic flush_signal;

  logic [31:0]next_pc;
  logic unsigned[11:0] pc_least_sig_figures;
  logic unsigned[31:0] feedback_pc;
  logic [1:0] Branch_history_table[4095:0][3:0];
  logic [1:0]global_branch_history[4095:0];
  logic [1:0]take_or_not_temp[4095:0];
  // BTB 
  logic BTB_valid[4095:0];
  logic unsigned [31:0]BTB_ins_pc[4095:0];
  logic BTB_is_branch_signal[4095:0];
  logic [31:0]BTB_predicted_pc[4095:0];
  logic unsigned BTB_prediction[4095:0];
  //prediction
  
  always_comb
  begin
    for(int i=0;i<4095;i=i+1)
    begin
      BTB_prediction[i]=(Branch_history_table[i][global_branch_history[i]]==2'b10||Branch_history_table[i][global_branch_history[i]]==2'b11)?1'b1:1'b0;
    end
    
  end
  //branch prediction

  assign pc_least_sig_figures=next_pc[11:0];
  assign feedback_pc=feedback_pc_from_branch_stage[11:0];
  assign flush_signal=(branch_signal==1 && correct_pc!=BTB_predicted_pc[feedback_pc])?1:0;


  assign pc=(flush_signal==1)?correct_pc:
            (single_stall==1 || both_stall==1 || same_parity==1 || cache_stall==1)?old_pc_from_decode_stage:
            (pc_least_sig_figures!=0 && pc_least_sig_figures-8>=0 && BTB_ins_pc[pc_least_sig_figures-8]==(next_pc-8) && BTB_is_branch_signal[pc_least_sig_figures-8]==1'b1 && BTB_prediction[pc_least_sig_figures-8]==1)?BTB_predicted_pc[pc_least_sig_figures-8]:next_pc; // && BTB_ins_pc[pc_least_sig_figures-8]==(next_pc-8) && BTB_is_branch_signal[pc_least_sig_figures-8]==1'b1 && BTB_prediction[pc_least_sig_figures-8]==1)?BTB_predicted_pc[pc_least_sig_figures-8]:next_pc;


  //determine pc 
  //update branch history table and btb when mispredict or facing new branch instruction
  

  always_ff @(posedge clk or posedge reset )
  begin
    if(reset)
    begin
      next_pc<=0;
    end
    else
      next_pc<=pc+8;
  end
  
  //update BTB
  
  always_ff @(posedge clk or posedge reset)
  begin
    if(reset)
    begin
        for(int x=0;x<4096;x=x+1)
        begin
          BTB_is_branch_signal[x]<=1'b0;
          BTB_predicted_pc[x]<=32'd0;
          BTB_ins_pc[x]<=32'd0; 
          BTB_valid[x]<=1'b0;
        end
    end
    else
    begin
      if(branch_signal==1)
      begin
        if(real_take_or_not_signal==1)
        begin
          BTB_ins_pc[feedback_pc]<=feedback_pc_from_branch_stage;
          BTB_is_branch_signal[feedback_pc]<=1;
          BTB_predicted_pc[feedback_pc]<=correct_pc;
          BTB_valid[feedback_pc]<=1'b1;
        end
        else 
        begin
          BTB_ins_pc[feedback_pc]<=feedback_pc_from_branch_stage;
          BTB_is_branch_signal[feedback_pc]<=1;
          BTB_predicted_pc[feedback_pc]<=feedback_pc_from_branch_stage+8;
          BTB_valid[feedback_pc]<=1'b1;
        end
      end
        //keep the old values
        //is_branch_signal[feedback_pc]<=0;
    end
  end
  
  //
  integer i;
  integer j;
  always_ff @(posedge clk or posedge reset) 
  begin
    if(reset) 
    begin
      for (i=0; i < 4096; i=i+1)
      begin
        global_branch_history[i]<=0;
       for (j=0; j < 4; j=j+1) 
       begin
          Branch_history_table[i][j] <= 2'b01;
       end
    end
    end 
    //start filling global branch history and  branch history table
    //00 strong not taken
    //01 weak not taken
    //10 strong taken
    //11 weak taken
    else 
    begin//prediction state
      if(branch_signal==1)
      begin  
         if(real_take_or_not_signal==0)//not taken
         begin

          if(Branch_history_table[feedback_pc][{real_take_or_not_signal,global_branch_history[feedback_pc][1]}]==2'b00)
            Branch_history_table[feedback_pc][{real_take_or_not_signal,global_branch_history[feedback_pc][1]}]<=2'b00;

          else if(Branch_history_table[feedback_pc][{real_take_or_not_signal,global_branch_history[feedback_pc][1]}]==2'b01)
            Branch_history_table[feedback_pc][{real_take_or_not_signal,global_branch_history[feedback_pc][1]}]<=2'b00;

          else if(Branch_history_table[feedback_pc][{real_take_or_not_signal,global_branch_history[feedback_pc][1]}]==2'b10)
            Branch_history_table[feedback_pc][{real_take_or_not_signal,global_branch_history[feedback_pc][1]}]<=2'b11;

          else if(Branch_history_table[feedback_pc][{real_take_or_not_signal,global_branch_history[feedback_pc][1]}]==2'b11)
            Branch_history_table[feedback_pc][{real_take_or_not_signal,global_branch_history[feedback_pc][1]}]<=2'b00;

          global_branch_history[feedback_pc]<={real_take_or_not_signal,global_branch_history[feedback_pc][1]};

         end
         else if(real_take_or_not_signal==1)//taken
         begin
          if(Branch_history_table[feedback_pc][{real_take_or_not_signal,global_branch_history[feedback_pc][1]}]==2'b00)
            Branch_history_table[feedback_pc][{real_take_or_not_signal,global_branch_history[feedback_pc][1]}]<=2'b01;

          else if(Branch_history_table[feedback_pc][{real_take_or_not_signal,global_branch_history[feedback_pc][1]}]==2'b01)
            Branch_history_table[feedback_pc][{real_take_or_not_signal,global_branch_history[feedback_pc][1]}]<=2'b10;

          else if(Branch_history_table[feedback_pc][{real_take_or_not_signal,global_branch_history[feedback_pc][1]}]==2'b10)
            Branch_history_table[feedback_pc][{real_take_or_not_signal,global_branch_history[feedback_pc][1]}]<=2'b10;

          else if(Branch_history_table[feedback_pc][{real_take_or_not_signal,global_branch_history[feedback_pc][1]}]==2'b11)
            Branch_history_table[feedback_pc][{real_take_or_not_signal,global_branch_history[feedback_pc][1]}]<=2'b10;

          global_branch_history[feedback_pc]<={real_take_or_not_signal,global_branch_history[feedback_pc][1]};
         end
      end
    end
  end
  
endmodule