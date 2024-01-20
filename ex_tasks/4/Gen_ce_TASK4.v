module Gen_ce_TASK4(input clk, output wire CO,
                    input ce,
                    input R,
                    input Tmod);

  parameter F50MHz = 50000000;
  parameter F10Hz  = 10;
	parameter F1Hz   = 1;

	reg  [15:0] cb_Nms = 0;
	wire [15:0] Nms = (Tmod ? F50MHz/F10Hz-1 : ((F50MHz/F1Hz)-1));

	assign CO = (cb_Nms == 0);
	always @(posedge clk) begin
		cb_Nms <= (R ? 0 : ((cb_Nms==0) ? Nms : cb_Nms-1));
	end

endmodule