class first_test;
  // int seed = 555;
   int error_cnt;
  //parameter NR_OF_TRANZ;
  covergroup my_funct_coverage;
   coverpoint lab2_if.cb.operand_a{
    
     bins operand_a_zero ={0};
     bins operand_a_Values_neg []={[-15:-1]};
     bins operand_a_Values_pos[] ={[1:15]};
   }
  

  
   coverpoint lab2_if.cb.operand_b{
    
     bins operand_b_zero ={0};
     bins operand_b_Values_pos []={[1:15]};
   }
  

    
   
   coverpoint lab2_if.cb.opcode{
    
     bins opcode_zero ={0};
     bins opcode_Values_pos []={[1:7]};
   }
   endgroup

  // Interface declaration
  virtual tb_ifc.TEST lab2_if;
  int NR_OF_TRANZ;
     // Global error counter
   function new(virtual tb_ifc.TEST lab_if);
   lab2_if =lab_if;
   this.error_cnt = 0;
   my_funct_coverage = new();
   endfunction


  function void randomize_transaction;
    // A later lab will replace this function with SystemVerilog
    // constrained random values
    //
    // The stactic temp variable is required in order to write to fixed
    // addresses of 0, 1 and 2.  This will be replaceed with randomizeed
    // write_pointer values in a later lab
    //
    static int temp = 0;
    lab2_if.cb.operand_a     <= $urandom()%16;                 // between -15 and 15
    lab2_if.cb.operand_b     <= $unsigned($urandom)%16;            // between 0 and 15
    lab2_if.cb.opcode        <= opcode_t'($unsigned($urandom)%8);  // between 0 and 7, cast to opcode_t type
    lab2_if.cb.write_pointer <= temp++;
  endfunction: randomize_transaction

  function void print_transaction;
    $display("Writing to register location %0d: ", lab2_if.cb.write_pointer);
    $display("  lab2_if.cb.opcode = %0d (%s)", lab2_if.cb.opcode, lab2_if.cb.opcode.name);
    $display("  lab2_if.cb.operand_a = %0d",   lab2_if.cb.operand_a);
    $display("  lab2_if.cb.operand_b = %0d\n", lab2_if.cb.operand_b);
  endfunction: print_transaction

  function void print_results;
    $display("Read from register location %0d: ", lab2_if.cb.read_pointer);
    $display("  lab2_if.cb.opcode = %0d (%s)", lab2_if.cb.instruction_word.opc, lab2_if.cb.instruction_word.opc.name);
    $display("  lab2_if.cb.operand_a = %0d",   lab2_if.cb.instruction_word.op_a);
    $display("  lab2_if.cb.operand_b = %0d\n", lab2_if.cb.instruction_word.op_b);
    $display("  result    = %0d\n", lab2_if.cb.instruction_word.result);
     case (lab2_if.cb.instruction_word.opc.name)
      "PASSA" : begin
        if (lab2_if.cb.instruction_word.result != lab2_if.cb.instruction_word.op_a) begin
          $error("PASSA operation error: Expected result = %0d Actual result = %0d\n", lab2_if.cb.instruction_word.op_a, lab2_if.cb.instruction_word.result);
          error_cnt += 1;
        end
      end
      "PASSB" : begin
        if (lab2_if.cb.instruction_word.result != lab2_if.cb.instruction_word.op_b) begin
          $error("PASSB operation error: Expected result = %0d Actual result = %0d\n",lab2_if.cb.instruction_word.op_b, lab2_if.cb.instruction_word.result);
          error_cnt += 1;
        end
      end
      "ADD" : begin
        if (lab2_if.cb.instruction_word.result != $signed(lab2_if.cb.instruction_word.op_a + lab2_if.cb.instruction_word.op_b)) begin
          $error("ADD operation error: Expected result = %0d Actual result = %0d\n", $signed(lab2_if.cb.instruction_word.op_a + lab2_if.cb.instruction_word.op_b), lab2_if.cb.instruction_word.result);
          error_cnt += 1;
        end
      end
      "SUB" : begin
        if (lab2_if.cb.instruction_word.result != $signed(lab2_if.cb.instruction_word.op_a - lab2_if.cb.instruction_word.op_b)) begin
          $error("SUB operation error: Expected result = %0d Actual result = %0d\n", $signed(lab2_if.cb.instruction_word.op_a - lab2_if.cb.instruction_word.op_b), lab2_if.cb.instruction_word.result);
          error_cnt += 1;
        end
      end
      "MULT" : begin
        if (lab2_if.cb.instruction_word.result != $signed(lab2_if.cb.instruction_word.op_a * lab2_if.cb.instruction_word.op_b)) begin
          $error("MULT operation error: Expected result = %0d Actual result = %0d\n", $signed(lab2_if.cb.instruction_word.op_a * lab2_if.cb.instruction_word.op_b), lab2_if.cb.instruction_word.result);
          error_cnt += 1;
        end
      end
      "DIV" : begin
        if (lab2_if.cb.instruction_word.result != $signed(lab2_if.cb.instruction_word.op_a / lab2_if.cb.instruction_word.op_b)) begin
          $error("DIV operation error: Expected result = %0d Actual result = %0d\n", $signed(lab2_if.cb.instruction_word.op_a / lab2_if.cb.instruction_word.op_b), lab2_if.cb.instruction_word.result);
          error_cnt += 1;
        end
      end
      "MOD" : begin
        if (lab2_if.cb.instruction_word.result != $signed(lab2_if.cb.instruction_word.op_a % lab2_if.cb.instruction_word.op_b)) begin
          $error("MOD operation error: Expected result = %0d Actual result = %0d\n", $signed(lab2_if.cb.instruction_word.op_a % lab2_if.cb.instruction_word.op_b), lab2_if.cb.instruction_word.result);
          error_cnt += 1;
        end
      end
    endcase
   
  endfunction: print_results
  
     task run ();
         if (!$value$plusargs("NR_OF_TRANS=%0d", NR_OF_TRANZ)) begin
      NR_OF_TRANZ = 100;
    end
    $display("\n\n***********************************************************");
    $display(    "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(    "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(    "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(    "***********************************************************");
    $display(" First display");
    $display("\nReseting the instruction register...");
    
    
    lab2_if.cb.write_pointer <= 5'h00;         // initialize write pointer
    lab2_if.cb.read_pointer  <= 5'h1F;         // initialize read pointer
    lab2_if.cb.load_en       <= 1'b0;          // initialize load control line
    lab2_if.cb.reset_n       <= 1'b0;          // assert reset_n (active low)
    repeat (2) @(lab2_if.cb) ;     // hold in reset for 2 clock cycles
    lab2_if.cb.reset_n        <= 1'b1;          // deassert reset_n (active low)

    $display("\nWriting values to register stack...");
    @(lab2_if.cb) lab2_if.cb.load_en <= 1'b1;  // enable writing to register
    repeat (NR_OF_TRANZ) begin
      @(lab2_if.cb) randomize_transaction;
      @(lab2_if.cb) print_transaction;
      my_funct_coverage.sample();
    end
    @(lab2_if.cb) lab2_if.cb.load_en <= 1'b0;  // turn-off writing to register

    // read back and display same three register locations
    $display("\nReading back the same register locations written...");
     for (int i=0; i<=NR_OF_TRANZ-1; i++) begin
       // later labs will replace this loop with iterating through a
      // scoreboard to determine which addresses were written and
      // the expected values to be read back
       @(lab2_if.cb) lab2_if.cb.read_pointer <= i;
       @(negedge lab2_if.cb) print_results;
     end

//TEMA DE CASA in struct instr_t adaugam semnal de result(cat de de mare), 
//ii facem display in print_results, ne ducem in dut si declaram un case in fct de operatie(din enum),
// o sa fie afisat rezultatul fiecarei operatii sub formele de unde

    @(lab2_if.cb) ;
    $display("\n***********************************************************");
    $display(  "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(  "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(  "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(  "***********************************************************\n");
   // Error evaluation
    if (this.error_cnt == 0) begin
      $display("TEST PASSED");
    end else if (this.error_cnt > 0) begin
      $display("TEST FAILED (%0d errors)", this.error_cnt);
    end
    $finish;
  //end
endtask



 
endclass