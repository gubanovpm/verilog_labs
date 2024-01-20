module Gen_ce10ms(input clk, output wire CO,
                  input ce,  output wire CEO,
                  input R,
                  input EN);

  parameter F50MHz=50000000;
  parameter F01kHz=100;
	
	reg  [31:0] cb_Nms = 0;
	wire [31:0] Nms = (F50MHz/F01Hz)-1;
  
	assign CO = (cb_Nms == 0);
	always @(posedge clk) begin
		cb_Nms <= R | !EN ? 0 : (CO ? Nms : cb_Nms-1);
	end

endmodule
