module MIL_TXD(input clk, 			output wire TXP, // ”Положительные” импульсы
            	 input[15:0]dat, 	output wire TXN, // ”Отрицательные” импульсы
            	 input txen, 			output reg SY1 = 0, // Первый импульс синхронизации
            	 									output reg SY2 = 0, // Второй импульс синхронизации
            	 									output reg en_tx = 0, // Разрешение передачи
            	 									output reg T_dat = 0, // Интервал данных
            	 									output wire T_end, // Такт конца слова
            	 									output wire SDAT, // Последовательные данные
            	 									output reg FT_cp = 1, // Счетчик четности
            	 									output reg [4:0]cb_bit = 0, //Счетчик бит слова
            	 									output wire ce_tact,
            	 									output reg CW_DW = 1); /*CW_DW=1 – контр.слово, 
																											   CW_DW=0 - слово данных*/

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

assign TXP = (en_tx & (( CW_DW & SY1) | //"Положительные" импульсы
											 (!CW_DW & SY2) |
											 (T_dat & (sr_dat[15]^QM)) |
											 (T_end & (FT_cp^QM)))) ^ ((T_dat | T_end) & ce_tact);

assign TXN = (en_tx & ((!CW_DW & SY1) | //"Отрицательные" импульсы
											 (CW_DW & SY2) |
											 (T_dat & (sr_dat[15]^!QM)) |
											 (T_end & (FT_cp^!QM)))) ^ ((T_dat | T_end) & ce_tact) ;

assign SDAT = sr_dat[15] & T_dat ; // Последовательные данные


always @ (posedge clk) begin
	ttxen <= txen ; tttxen <= ttxen ; //Задержка на Tclk
	cb_tact <= (ce_tact | st) ? 1 : en_tx ? cb_tact+1 : cb_tact ; //Tcet=Tbit/2=0.5us
	QM <= (st | ce_tact) ? 0 : (cb_tact==24) ? 1 : QM ; /*Триггер меандра модулятора
																										  последовательных данных*/
	SY1 <= st? 1 : ((cb_bit==1) & (cb_tact==24))? 0 : SY1 ;
	SY2 <= (st | st_Tdat)? 0 : ((cb_bit==1) & (cb_tact==24))? 1 : SY2 ;
	en_tx <= st? 1 : (!txen & ce_end)? 0 : en_tx ;
	cb_bit <= st? 0 : (en_tx & ce_tact)? cb_bit+1 : cb_bit ;
	T_dat <= st_Tdat? 1 : st18 & ce_tact? 0 : T_dat ;
	sr_dat <= st_Tdat? dat : (T_dat & ce_tact)? sr_dat<<1 : sr_dat ;
	FT_cp <= st_Tdat? 1 : (T_dat & sr_dat[15] & ce_tact)? !FT_cp : FT_cp ;
	CW_DW <= (ttxen & !tttxen)? 1 : ce_end? 0 : CW_DW ;
end

endmodule