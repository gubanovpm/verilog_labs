`ifndef m
	`define m 4
`endif
module VCBmCLED(input ce,          output reg [`m-1:0] Q = 0,
                input up,          output wire CEO,
                input [`m-1:0] di, output wire TC,
                input L,
                input clk,
                input clr);
	assign TC  = up ? (Q == (1<<`m)-1) : (Q == 0);
	assign CEO = ce & TC;
	always @(posedge clk) begin
		if (clr) Q <= 0;
		else     Q <= L ? di : (up & ce ? Q+1 : (!up &ce ? Q-1 : Q));
	end
endmodule
