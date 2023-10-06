`ifndef m
	`define m 4
`endif

module ACC2mE( input [`m-1:0] X, output reg [`m-1:0] ACC = 0,
							 input ce, output wire CO,
							 input clk);

	assign CO = (X+ACC >= 1<<`m); //Сигнал переноса
	always @ (posedge clk) if (ce) begin
		ACC <= ACC + X; // Аккумулятор с емкостью 2 m
	end

endmodule
