module Gen_ce05us(input clk,   output wire CO);

  parameter F50MHz= 50000000;
  parameter F1MHz = 2000000;
	
	reg  [15:0] cb_Nus = 0;
	wire [15:0] Nus = F50MHz/F1MHz-1;
  
	assign CO = (cb_Nus == 0);
	always @(posedge clk) begin
		cb_Nus <= ((cb_Nus==0) ? Nus : cb_Nus-1);
	end

endmodule