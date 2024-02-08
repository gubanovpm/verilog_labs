module LED_BL(input [7:0] DI, output wire [7:0] DO,
              input E );

  assign DO= DI | {8{E}} ;

endmodule