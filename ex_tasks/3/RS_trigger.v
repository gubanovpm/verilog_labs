module RS_trigger(input s, output wire q,
                  input r, output wire q_n);

  assign q   = ~(r | q_n);
  assign q_n = ~(s | q);

endmodule