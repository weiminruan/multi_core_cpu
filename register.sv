
module register(clk,reset,read_signal_1,read_signal_2,write_signal_1,write_signal_2,data_read_1,data_read_2,data_read_3,data_read_4,
   data_read_5,data_read_6,data_write_1,data_write_2,read_addr_1,read_addr_2,read_addr_3,read_addr_4,read_addr_5,read_addr_6,write_addr_1,write_addr_2);

   input clk,reset;
   input [6:0] read_addr_1,read_addr_2,read_addr_3,read_addr_4,read_addr_5,read_addr_6;
   input [6:0]write_addr_1,write_addr_2;
   input write_signal_1,write_signal_2;
   input read_signal_1,read_signal_2;
   input [127:0] data_write_1,data_write_2;
   output [127:0] data_read_1,data_read_2,data_read_3,data_read_4,data_read_5,data_read_6;

   integer j;
   reg signed[127:0] register[127:0];

   always_ff @(posedge clk or posedge reset) 
   begin
      register[0]<=0;
      //register[20]<={32'd1044,96'b0};
      register[20]<={17'b0,15'b100000101000000,96'b0};
      if(reset) 
      begin
         for (j=1; j < 128; j=j+1) 
         begin
            register[j] <= 0; //reset array
         end
      end 
      else 
      begin
         if(write_signal_1==1)
            register[write_addr_1]<=data_write_1;
         if(write_signal_2==1)
            register[write_addr_2]<=data_write_2;
      end
   end
   assign data_read_1=(read_signal_1==1)?register[read_addr_1]:0;
   assign data_read_2=(read_signal_1==1)?register[read_addr_2]:0;
   assign data_read_3=(read_signal_1==1)?register[read_addr_3]:0;
   assign data_read_4=(read_signal_2==1)?register[read_addr_4]:0;
   assign data_read_5=(read_signal_2==1)?register[read_addr_5]:0;
   assign data_read_6=(read_signal_2==1)?register[read_addr_6]:0;
endmodule

