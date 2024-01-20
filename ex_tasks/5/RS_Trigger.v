module RS_Trigger(input r, output wire q,
                  input s);

  assign q_n = ~(s | q);
  assign q   = ~(r | q_n);

endmodule