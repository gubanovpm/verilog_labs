`ifndef a
	`define a 11 //Число разрядов
`endif

module ACCM ( input [7:0] X, output reg [`a-1:0] ACC = 0,
							input ce, output wire CO, //Сигнал переноса
							input clk, output reg Mx=0); //Меандр

	parameter M=500 ;
	assign CO = (X+ACC >= M); //Сигнал переноса CO=1 при X+ACC >= M
	always @ (posedge clk) if (ce) begin
		ACC <= CO? ACC + X - M : ACC + X; // Аккумулятор с емкостью M
		Mx <= (CO & ce)? !Mx : Mx ; //Меандр
	end

endmodule
