
module testbench_gcd ();
  logic        clk;
  logic        reset;
  logic        in;
  logic [1:0]  out;

  state_machine state_machine_i(
    .clk_i      (clk),
    .reset_i      (reset),
    .in_i       (in),
    .out_o      (out)
  );

  always begin
    #50 clk = ~clk;
  end

  initial begin
    $dumpfile("_sim/state_machine.vcd");
    $dumpvars(0, testbench_gcd);
  end

  initial begin

    clk   = 1;
    reset = 1;
    in = 0;
    #50 // 0-1 > 0 / änderung immer auf fallender flanke setzen
    #100 // 1-2
    #100 // 2
    reset = 0;
    #100 // 3
    #100 // 4
    in = 1;
    #100 // 5
    reset = 1;
    in = 0;
    #100 // 6

    $finish();
  end

endmodule
