module arbitrator (
  clk,    
  rst, 
  req4,   
  req3,   
  req2,   
  req1,   
  req0, 
  gnt4,  
  gnt3,   
  gnt2,   
  gnt1,   
  gnt0   
);
// --------------Port Declaration----------------------- 
input           clk;    
input           rst; 
input           req4; 
input           req3;   
input           req2;   
input           req1;   
input           req0;   
output          gnt4;
output          gnt3;   
output          gnt2;   
output          gnt1;   
output          gnt0; 

logic [3:0]output_state;
logic [3:0]priority_output[3:0];
ring_counter r0(clk,rst,output_state);

priority_logic p0
(
  output_state[0],
  req0,
  req1,
  req2,
  req3,
  priority_output[0][0],
  priority_output[0][1],
  priority_output[0][2],
  priority_output[0][3]
);
priority_logic p1
(
  output_state[1],
  req1,
  req2,
  req3,
  req0,
  priority_output[1][0],
  priority_output[1][1],
  priority_output[1][2],
  priority_output[1][3]
);
priority_logic p2
(
  output_state[2],
  req2,
  req3,
  req0,
  req1,
  priority_output[2][0],
  priority_output[2][1],
  priority_output[2][2],
  priority_output[2][3]
);
priority_logic p3
(
  output_state[3],
  req3,
  req0,
  req1,
  req2,
  priority_output[3][0],
  priority_output[3][1],
  priority_output[3][2],
  priority_output[3][3]
);

assign gnt0=priority_output[0][0]|priority_output[1][3]|priority_output[2][2]|priority_output[3][1];
assign gnt1=priority_output[0][1]|priority_output[1][0]|priority_output[2][3]|priority_output[3][2];
assign gnt2=priority_output[0][2]|priority_output[1][1]|priority_output[2][0]|priority_output[3][3];
assign gnt3=priority_output[0][3]|priority_output[1][2]|priority_output[2][1]|priority_output[3][0];
assign gnt4=req4&((!req0) & (!req1) & (!req2) & (!req3)); //mem are only allowed to acces bus when no other cache wants to responds.
endmodule



module priority_logic(   
  enable, 
  req0,   
  req1,   
  req2,   
  req3,   
  output_0,
  output_1,
  output_2,
  output_3
);
// --------------Port Declaration-----------------------    
input           req0;   
input           req1;   
input           req2;   
input           req3;   
input           enable;
output          output_0;   
output          output_1;   
output          output_2;   
output          output_3;

logic           [3:0]priority_output;
  assign priority_output=(enable==1'b0)?4'b0000:
  				(req0==1'b1)?4'b0001:
          (req1==1'b1)?4'b0010:
          (req2==1'b1)?4'b0100:
          (req3==1'b1)?4'b1000:
          4'b0000;

  assign output_3=priority_output[3];
  assign output_2=priority_output[2];
  assign output_1=priority_output[1];
  assign output_0=priority_output[0];

endmodule
module ring_counter (
  clk,    
  rst,    
  output_state 
);
// --------------Port Declaration----------------------- 
input           clk;    
input           rst;    
  
output  logic [3:0]output_state;   
  
  always_ff @(posedge clk or posedge rst) begin : proc_output
    if(rst) 
    begin
      output_state <= 4'b0001;
    end 
    else 
    begin
      if(output_state==4'b0001)
      begin
        output_state <=4'b0010;
      end
      else if(output_state==4'b0010)
      begin
        output_state <=4'b0100;
      end
      else if(output_state==4'b0100)
      begin
        output_state <=4'b1000;
      end
      else if(output_state==4'b1000)
      begin
        output_state <=4'b0001;
      end
      else
      begin
      end
    end
  end
endmodule