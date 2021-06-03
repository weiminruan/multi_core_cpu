
module instruction_cache_2(
clk,
reset,
pc,
instruction_out_1,
instruction_out_2,
pc_1,
pc_2);

   input clk,reset;
   input unsigned [31:0] pc;
   output logic [31:0] instruction_out_1,instruction_out_2;
   output logic unsigned [31:0] pc_1,pc_2;

   logic unsigned [31:0] pc_after_division;
   assign pc_after_division=pc/4;

   reg signed[31:0] instruction_cache[2047:0];
	initial begin
        $readmemb("binary_code_2.txt", instruction_cache);
    end
    assign pc_1=pc;
    assign pc_2=pc+4;
    assign instruction_out_1=instruction_cache[pc_after_division];
    assign instruction_out_2=instruction_cache[pc_after_division+1];


endmodule

