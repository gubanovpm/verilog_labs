module DISPLAY(input clk,        output wire [3:0] AN,
               input [15:0] dat, output wire [7:0] SEG,
               input [1:0] PTR,  output wire ce1ms);
	wire [3:0] Dig ;
	wire [1:0] Adr_dig;

	Gen4an  DD1(.clk(clk), .q(Adr_dig), 
              .ce(ce1ms), .an(AN));

	MUX16_4 DD2(.dat(dat), .do(Dig), 
              .adr(Adr_dig));

	D7seg   DD3(.dig(Dig), .seg(SEG[6:0]));

	Gen_P   DD4(.adr_An(Adr_dig), .seg_P(SEG[7]), 
              .ptr(PTR));

	Gen1ms  DD5(.clk(clk), .ce1ms(ce1ms));
endmodule
