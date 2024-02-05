module ADR_DAT_BL(input BTN, output wire [1:0] VEL,
                             output wire [7:0] ADR,
                             output wire [22:0] DAT);

  assign ADR = 8'h84;

  parameter my_dat = 23'h112200;
  parameter my_VEL = 2'b11; // for testing for me it us 2'b10;

  wire my_bit_dat=(my_dat[13]^BTN) ;

  assign DAT={my_dat[22:14],my_bit_dat,my_dat[12:0]} ;
  assign VEL = my_VEL ;
endmodule