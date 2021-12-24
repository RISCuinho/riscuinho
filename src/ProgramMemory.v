`include "config.vh"

module ProgramMemory #(
   parameter INSTR_ADDR_WIDTH   = 20,
   parameter STEP    = 4
) (
   input                                  clk,
   input       [INSTR_ADDR_WIDTH-1:0]     pc,
   output      [(STEP*8)-1:0]             instr,
   // a memória pode ser grava em circunstãncias especiais
   input                                  pgm,
   input       [INSTR_ADDR_WIDTH-1:0]     addr,
   input       [(STEP*8)-1:0]             data
);
   localparam SIZE = 2**INSTR_ADDR_WIDTH;
   /* 
    * A memória será acesada em grupos de bytes (step), 
    * assim o ponteiro poderá ser incrementado conforme 
    * este grupo e reduzir o tamanho do barramento.
    */
   reg [(STEP*8)-1:0] memory [0:SIZE-1]; 
   
   
   initial begin
      `ifndef __YOSYS__
      $display("Program Memory step %0d, memory word %0d bits, address width %0d bits, total words %0d",
      `else
      $display("Program Memory step %d, memory word %d bits, address width %d bits, total words %d",
      `endif
               STEP, (STEP*8), INSTR_ADDR_WIDTH, SIZE);
      `ifndef __YOSYS__
      $display("Load prog_%0d.hex",SIZE);
      `else
      $display("Load prog_%d.hex",SIZE);
      `endif
      if(INSTR_ADDR_WIDTH == 5 )
         $readmemh(`MEMORY_PROG_32, memory); // carrega um programa de referência   
      else if(INSTR_ADDR_WIDTH == 6 )
         $readmemh(`MEMORY_PROG_64, memory); // carrega um programa de referência   
      else if(INSTR_ADDR_WIDTH == 7 )
         $readmemh(`MEMORY_PROG_128, memory); // carrega um programa de referência   
      else if(INSTR_ADDR_WIDTH == 8 )
         $readmemh(`MEMORY_PROG_254, memory); // carrega um programa de referência   
   end

   assign instr = memory[pc];  
   always @(posedge clk) begin
      if(pgm) memory[addr] <= data;
   end

endmodule
