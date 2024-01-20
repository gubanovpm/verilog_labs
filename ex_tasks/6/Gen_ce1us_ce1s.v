module Gen_ce1us_ce1s(input clk,   output wire CO1us,
                      input ce1ms, output wire CO1s);

  parameter F50MHz= 50000000;
  parameter F1MHz = 1000000;
	
	reg  [15:0] cb_Nus = 0;
	wire [15:0] Nus = F50MHz/F1MHz-1;
  
	assign CO1us = (cb_Nus == 0);
	always @(posedge clk) begin
		cb_Nus <= ((cb_Nus==0) ? Nus : cb_Nus-1);
	end

  reg  [15:0] cb_Ns = 0;
  wire [15:0] Ns    = 1000 - 1;

  assign CO1s = (cb_Ns == 0);
	always @(posedge ce1ms) begin
		cb_Ns <= ((cb_Ns==0) ? Ns : cb_Ns-1);
	end

endmodule