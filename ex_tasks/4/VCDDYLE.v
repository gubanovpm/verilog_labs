module VCDDYLE(input clk, output wire [7:0] DM, //День месяца
               input ce, output wire [7:0] M, //Месяц года
               input [5:0]DI, output wire COM, //Конец месяца
               input L, output wire COY, //Конец года
               input M_D,
               input VY);

  wire Lnm=L & M_D ;
  wire Lnd=L & !M_D;
  //--Счетчик дней в месяце

  VCDDMLE DD1 (.ce(ce), .CO(COM),// Конец месяца
               .NM(M),  .D(DM), // День месяца
               .clk(clk),
               .DI(DI),
               .L(Lnd),
               .VY(VY));

  reg  [3:0]N10M = 0 ;//Регистр десятков дней в месяце
  wire [3:0]N1M ; //Младшая декада номера месяца
  wire CO10M ; //Конец десятка месяцев
  assign M = {N10M,N1M} ; //Месяц года M[5:0] = {N10M,N1M[3:0]}
  
  //wire [15:0]MD={M,DM}; //Последний день года (12.31)
  assign COY = COM & (N10M==1) & (N1M==2) ;
  //assign COY = (MD=={8'h12,8'h31}) & COM ;//Конец года
  //--Декадный счетчик единиц месяцев
  CD4RLE DD3 ( .ce(COM),  .DO(N1M),
               .clk(clk), .CO(CO10M),
               .L(Lnm), //Загрузка младшей декады номера месяца
               .DI(DI[3:0]), //Младшая декада номера месяца
               .R1(COY)); //Загрузка номера 1-го месяца года
  //--Счет десятков месяцев
  //wire CO10M = COM & (N10M==1) & (N1M==2) ;
  always @ (posedge clk) begin
    N10M <= COY? 0 : Lnm? DI[5:4] : CO10M? N10M+1 : N10M ;
  end
endmodule

module VCDDMLE(input ce,       output wire CO, // Конец месяца
               input [7:0] NM, output wire[7:0] D, // День месяца
               input clk,
               input [5:0]DI,
               input L,
               input VY);//Указатель високосного года

  wire [3:0]N1D ; //Счетчик единиц дней в месяце
  wire CO10D ; //Конец очередного десятка дней
  reg [3:0] N10D =0 ; //Счетчик десятков дней
  assign D = {N10D,N1D} ; //Номер дня месяца D[5:0]={N10D[1:0],N1D[3:0]
  wire [5:0]NDM ; //Количество дней в месяце
  assign CO=(D==NDM) & ce ; //Конец месяца
  //--Загружаемый декадный счетчик единиц дней
  CD4RLE DD1 ( .ce(ce),   .DO(N1D),
               .clk(clk), .CO(CO10D),
               .L(L),                  //Загрузка номера первого дня месяца
               .DI(DI[3:0]),           //Количество единиц дней в месяце
               .R1(CO));               //Загрузка 1 (первого дня месяца)
  //--Счет десятков дней
  always @ (posedge clk) begin
    N10D <= CO? 0 : L? DI[5:4] : CO10D? N10D+1 : N10D ;
  end
  //Таблица дней в месяце
  NDM DD2 ( .M(NM), .NDM(NDM),
            .VY(VY));
endmodule

module NDM(input [7:0] M, output wire[5:0] NDM,
           input VY);

  wire [5:0] Nfeb = VY? 6'h29 : 6'h28 ;
  assign NDM = (M==5'h01)? 6'h31 ://Январь
               (M==5'h02)? Nfeb ://Февраль
               (M==5'h03)? 6'h31 ://Март
               (M==5'h04)? 6'h30 ://Апрель
               (M==5'h06)? 6'h30 ://Июнь
               (M==5'h05)? 6'h31 ://Май
               (M==5'h07)? 6'h31 ://Июль
               (M==5'h08)? 6'h31 ://Август
               (M==5'h09)? 6'h30 ://Сентябрь
               (M==5'h10)? 6'h31 ://Октябрь
               (M==5'h11)? 6'h30 ://Ноябрь
               (M==5'h12)? 6'h31 ://Декабрь
                           6'h30 ;
endmodule

module CD4RLE  (input ce,       output reg [3:0] DO = 1,
                input clk,      output wire CO,
                input [3:0] DI,
                input L,
                input R1);
	assign CO = ce & (DO == 9);
	always @(posedge clk) begin
		if (R1) DO <= 1;
		else    DO <= L ? DI : (ce ? DO+1 : DO);
	end
endmodule
