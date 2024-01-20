module Gen_ce(input clk, output wire ce1us,
                         output wire ce10us);

  parameter F50MHz= 50000000;
  parameter F1MHz = 10000000;

	reg  [15:0] cb_Nus = 0;
	wire [15:0] Nus = F50MHz/F1MHz-1;
  
	assign ce1us = (cb_Nus == 0);
	always @(posedge clk) begin
		cb_Nus <= ((cb_Nus==0) ? Nus : cb_Nus-1);
	end

  reg  [15:0] cb = 0;
  wire [15:0] N  = 10 * F50MHz/F1MHz - 1;

  assign ce10us = (cb == 0);
  always @(posedge clk) begin
    cb <= ((cb == 0) ? N : cb - 1);
  end

endmodule