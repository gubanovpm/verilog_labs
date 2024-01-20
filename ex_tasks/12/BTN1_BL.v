module BTN1_BL(input BTN, output wire st,
               input clk,
               input ce);

  assign st = q1 & !q2 & ce;
  reg q1 = 0, q2 = 0;
  always @(posedge clk) begin
    q1 <= ce ? BTN : q1; q2 <= ce ? q1 : q2;
  end

endmodule