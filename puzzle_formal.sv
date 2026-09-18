module puzzle_formal(
  input clk, input rst_n, input enable, input I,
  output success,
  output [7:0] O
);
  supply1 VPWR;
  supply0 VGND;

  puzzle dut (
    .VPWR(VPWR), .VGND(VGND), .clk(clk), .rst_n(rst_n),
    .enable(enable), .I(I),
    .\O[7] (O[7]), .\O[6] (O[6]), .\O[5] (O[5]), .\O[4] (O[4]),
    .\O[3] (O[3]), .\O[2] (O[2]), .\O[1] (O[1]), .\O[0] (O[0]),
    .success(success)
  );

  reg first_cycle = 1;
  always @(posedge clk) begin
    if (first_cycle) begin
      assume (rst_n == 1'b0);   // force real reset at the start of the trace
      first_cycle <= 0;
    end
  end

 always @(posedge clk)
    assert (!success);

endmodule
