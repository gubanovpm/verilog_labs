module MIL_RXD(input clk,	  output wire ok_rx,					// -
							 input In_P,  output wire [15:0] sr_dat,  // -
							 input In_N,  output wire CW_DW,					// -
												    output wire T_end,					// -
												    output wire FT_cp,					// -
												    output wire en_rx,					// -
												    output wire [5:0] cb_tact,	// -
												    output wire [4:0] cb_bit,		// -
												    output wire en_wr,					// -
												    output wire ce_tact,				// -
												    output wire QM,							// -
												    output wire [7:0] cb_XOR,		// -
												    output wire ok_SY);					// +

parameter ref_SY = 62;
parameter TXvel = 1000000 ; // 1MHz
parameter Fclk = 50000000 ; // 50 MHz

reg [5:0] cb_tact = 0; //Счетчик такта
reg ttxen = 0, tttxen = 0 ; //Задержаные на Tce_tact сигнал запуска
reg QM = 0; //Модулятор

assign ce_tact = (cb_tact==Fclk/TXvel) ; // Tce_tact=Tbit=1us

wire ce_end = T_end & ce_tact ; // Конец кадр
wire st = (ttxen & !tttxen) | (ce_end & txen); // Импульс старта передачи
reg [15:0] sr_dat = 0 ; // Регистр сдвига данных
wire st_Tdat = (cb_bit==2) & en_tx & ce_tact ; // Импульс старта интервала данных
wire st18 = (cb_bit==18) & en_tx; //Конец интервала данных

assign T_end = (cb_bit==19) & en_tx; //Конец кадра, бит контроля четности

wire RXP, RXN, D_RXP, D_RXN; 
wire [6:0] cb_SY;

FD FD_P(.D(In_P), .Q(RXP),
				.clk(clk));

FD FD_N(.D(In_N), .Q(RXN),
				.clk(clk));	

SHIFT SHIFT_P(.SLI(RXP), .SRO(D_RXP),
						  .clk(clk));

SHIFT SHIFT_N(.SLI(RXN), .SRO(D_RXN),
						  .clk(clk));																			

assign tmp = D_RXN & RXP;
assign O = !((D_RXP & RXN) | (D_RXN & RXP));

VCB7CE VCB7CE(.clk(clk), .Q(cb_SY),
							.R(O));

assign ok_SY = (cb_SY >= ref_SY);

always @(posedge clk) begin
	ttxen <= txen ; tttxen <= ttxen ; //Задержка на Tclk
	cb_tact <= (ce_tact | st) ? 1 : en_tx ? cb_tact+1 : cb_tact ; //Tcet=Tbit/2=0.5us
	QM <= (st | ce_tact) ? 0 : (cb_tact==24) ? 1 : QM ; /*Триггер меандра модулятора
																										  последовательных данных*/

	en_tx <= st? 1 : (!txen & ce_end)? 0 : en_tx ;
	cb_bit <= st? 0 : (en_tx & ce_tact)? cb_bit+1 : cb_bit ;
	T_dat <= st_Tdat? 1 : st18 & ce_tact? 0 : T_dat ;
	sr_dat <= st_Tdat? dat : (T_dat & ce_tact)? sr_dat<<1 : sr_dat ;
	FT_cp <= st_Tdat? 1 : (T_dat & sr_dat[15] & ce_tact)? !FT_cp : FT_cp ;
	CW_DW <= (ttxen & !tttxen)? 1 : ce_end? 0 : CW_DW ;																											
end

endmodule
              
module FD(input D, output reg Q,
					input clk);

always @(posedge clk) begin
	Q <= D;  
end

endmodule			

module SHIFT(input SLI, output wire SRO,
						 input clk);


reg [75:0] sr = 76'b0;
assign SRO = sr[75];

always @(posedge clk) begin
	sr[0] = SLI;
	sr <= (sr << 1);
end

endmodule

module VCB7CE(input clk, 	output reg [6:0] Q = 0,
							input R);

always @ (posedge clk or posedge R ) begin
	Q <= R ? 0 : Q + 1 ;
end

endmodule