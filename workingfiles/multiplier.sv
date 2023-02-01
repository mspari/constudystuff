module multiplier(
  input logic        clk_i,
  input logic        rst_i,
  input logic        start_i,
  input logic [3:0]  a_i,
  input logic [3:0]  b_i,
  output logic       busy_o,
  output logic       valid_o,
  output logic [7:0] result_o
);


// control unit / internal registers
enum logic [1:0] {INIT, CALC, DONE} state_p, state_n;
logic [7:0] result_p, result_n;
logic [3:0] counter_p, counter_n;


// DATA PATH
// combinational logic of the data path
// > operations that can performed on defined registers (based on control signals)
logic[1:0] r_mux;
always_comb begin
  case(r_mux)
    2'b00: result_n = 0;
    2'b01: result_n = result_p;
    2'b10: result_n = result_p + (b_i << counter_p);
    default: result_n = 0;
  endcase
end

logic c_mux;
always_comb begin
  case(c_mux)
    1'b0: counter_n = 0;
    1'b1: counter_n = counter_p + 1;
  endcase;
end


// STATE MACHINE
// combinational logic (of the control logic)
// > in what state, which controls need to be set / defines control signals for the data path
always_comb begin
  state_n = state_p;
  r_mux = 2'b00;
  c_mux = 1'b0;

  case (state_p)
    INIT: begin
      r_mux = 2'b00;
      c_mux = 1'b0;

      if (start_i) begin
        state_n = CALC;
      end
      else begin
        state_n = INIT;
      end
    end

    CALC: begin
      c_mux = 1'b1;
      if (a_i[counter_p]) begin
        r_mux = 2'b10;
      end 
      else begin
        r_mux = 2'b01;
      end

      if (counter_p == 3) begin
        state_n = DONE;
      end
      else begin
        state_n = CALC;
      end
    end

    DONE: begin
      r_mux = 2'b01;
      c_mux = 1'b0;

      if (start_i) begin
        r_mux = 2'b00;
        state_n = CALC;
      end
      else begin
        state_n = DONE;
      end
    end
  endcase
end


// REGISTERS
// FSM state update (flip-flop of the control logic)
// > registers describing control logic 
always_ff @(posedge clk_i, posedge rst_i) begin
  if (rst_i) begin
    state_p <= INIT;
    result_p <= 4'b0;
    counter_p <= 4'b0;
  end
  else begin
    state_p <= state_n;
    result_p <= result_n;
    counter_p <= counter_n;
  end
end


// OUTPUT LOGIC
assign result_o = result_p;
assign busy_o = (state_p == CALC);
assign valid_o = (state_p == DONE);


endmodule