module BTN_WRP_test;
	reg ce;
	reg btn_in;
	wire btn_out;

	BTN_WRP uut(.BTN_IN(btn_in), .BTN_OUT(btn_out),
              .ce(ce));	

	// periodic ce sig generator
	parameter Tce = 40; // period ce sig = 160 ns
	always begin
		ce = 0;
		#(Tce/2);
		ce = 1;
		#(Tce/2);
	end

	initial begin
		$dumpfile("BTN_WRP.vcd");
    $dumpvars(0, BTN_WRP_test);
		btn_in = 0; #120;
		btn_in = 1; #15 ;
		btn_in = 0; #25 ;
		btn_in = 1; #5  ;
		btn_in = 0; #5  ;
		btn_in = 1; #300; 
		$finish();
	end
endmodule
