module BUTTON_BL( input BUTTON, output wire st,
								  input clk);

	reg [15:0]cb_ce=0 ;
	wire ce= (cb_ce==50000);
	reg q1=0, q2=0 ;
	
	assign st= q1 & !q2 & ce ;
	always @ (posedge clk) begin
		q1 <= ce? BUTTON : q1 ; q2 <= ce? q1 : q2 ;
		cb_ce <= ce? 1 : cb_ce+1 ;
	end
endmodule
