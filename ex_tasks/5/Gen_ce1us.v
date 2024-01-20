module Gen_ce1us(input clk,   output wire CO);

  parameter F50MHz=50000000;
  parameter F1MHz =1000000;
	
	reg  [15:0] cb_Nms = 0;
	wire [15:0] Nms = F50MHz/F1MHz-1;
  
	assign CO = (cb_Nms == 0);
	always @(posedge clk) begin
		cb_Nms <= ((cb_Nms==0) ? Nms : cb_Nms-1);
	end

endmodule