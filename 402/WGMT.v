`ifndef z
	`define z 11
`endif

`ifndef n
	`define n 16
`endif

module WGMT (input st,						 output reg [`z-1:0] q=0,
						 input clk,						 output wire end_PW,
						 input [`n-1:0] NTclk, output reg ceo=0,
						 input [`z-1:0] MT,		 output reg PW=0);
	reg [`n-1:0]cb_ce=0 ;
	assign end_PW = (q==1); // Выход компаратора
	wire ce = (cb_ce==NTclk);
	always @ (posedge clk) begin
		cb_ce <= ((st & !PW) | ce)? 1 : cb_ce + 1 ;
		q <= (st & !PW)? MT : (ce & PW) ? q-1 : q ;
		PW <= st? 1 : (ce & end_PW)? 0 : PW ;
		ceo <= ce ;
	end
endmodule
