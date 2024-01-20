module ALD(input SA,           output wire SQ,
           input SB,           output wire SAB,
           input [15:0] mod_A, output S,
           input [15:0] mod_B, output reg [31:0] mod_Q = 0,
           input [1:0]  F ,
					 input ce);

  wire CMP1 = ~(mod_A > mod_B);
  wire CMP2 = ~(mod_B > mod_A);

  wire [3:0] SW = {SA, SB, F};
  wire [2:0] OP = (SW == 4'b0000) ? {2'b00, 1'b0} :
                  (SW == 4'b0001) ? {2'b00, CMP1} :
                  (SW == 4'b0010) ? {2'b10, CMP2}:
                  (SW == 4'b0011) ? {2'b11, 1'b0}:

                  (SW == 4'b0100) ?  {2'b01, CMP1}:
                  (SW == 4'b0101) ?  {2'b00, 1'b0}:
                  (SW == 4'b0110) ?  {2'b00, 1'b1}:
                  (SW == 4'b0111) ?  {2'b11, 1'b1}:

                  (SW == 4'b1000) ?  {2'b10, CMP2}:
                  (SW == 4'b1001) ?  {2'b00, 1'b1}:
                  (SW == 4'b1010) ?  {2'b00, 1'b0}:
                  (SW == 4'b1011) ?  {2'b11, 1'b1}:

                  (SW == 4'b1100) ?  {2'b00, 1'b1}:
                  (SW == 4'b1101) ?  {2'b10, CMP2}:
                  (SW == 4'b1110) ?  {2'b01, CMP1}:
                                     {2'b11, 1'b0} ;

	always @(posedge ce) begin 
		mod_Q <= ({OP[2], OP[1]} == 2'b00) ? mod_A + mod_B :
						 ({OP[2], OP[1]} == 2'b01) ? (~(SQ) ? mod_A - mod_B : mod_B - mod_A) :
						 ({OP[2], OP[1]} == 2'b10) ? (~(SQ) ? mod_B - mod_A : mod_A - mod_B) :
																				 mod_A * mod_B ;
	end
  assign S   = OP[0] ;
  assign SQ  = (F == 2'b11) ? 0 : S;
  assign SAB = (F == 2'b11) ? S : 0;

endmodule