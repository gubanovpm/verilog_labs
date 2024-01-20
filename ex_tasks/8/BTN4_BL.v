module BTN4_BL(input BTN0, output wire st0,
               input BTN1, output wire st1,
               input BTN2, output wire st2,
               input BTN3, output wire st3,
               input clk,
               input ce);

  BTN_WRP btn_0(.BTN(BTN0), .OUT(st0),
                .clk(clk),
                .ce(ce));

  BTN_WRP btn_1(.BTN(BTN1), .OUT(st1),
                .clk(clk),
                .ce(ce));

  BTN_WRP btn_2(.BTN(BTN2), .OUT(st2),
                .clk(clk),
                .ce(ce));

  BTN_WRP btn_3(.BTN(BTN3), .OUT(st3),
                .clk(clk),
                .ce(ce));

endmodule

module BTN_WRP(input BTN, output wire OUT,
               input clk,
               input ce);

  assign OUT = st;
  reg q1 = 0, q2 = 0;
  assign st = q1 & !q2 & ce;
  always @(posedge clk) begin
    q1 <= ce ? BTN : q1; q2 <= ce ? q1 : q2;
  end

endmodule
