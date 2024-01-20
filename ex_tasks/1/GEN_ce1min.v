module GEN_ce1min(input clk,   output wire CO,
                  input ce1ms, output wire Q,
                  input Tmod);

  parameter F50MHz=50000000;
  parameter F1kHz=1000;
	parameter F1Hz=1;
	
	reg  [31:0] cb_Nms = 0;
	wire [31:0] Nms = (Tmod ? (60*F50MHz-1) : ((F50MHz/F1Hz)-1));
  
	assign CO = (cb_Nms == 0);
	always @(posedge clk) begin
		cb_Nms <= (CO ? Nms : cb_Nms-1);
	end

  reg  [31:0] cQ_Nms = 0;
  wire [31:0] Q_Nms  = 2*F50MHz - 1;
  
  assign Q  = (cQ_Nms == 0);
  always @(posedge clk) if (ce1ms) begin
    cQ_Nms <= (Q ? Nms : cb_Nms - 1);
  end

endmodule