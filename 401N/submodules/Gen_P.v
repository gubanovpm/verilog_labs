module Gen_P (input [1:0] ptr, output wire seg_P,
              input [1:0] adr_An );
	assign seg_P = !(ptr==adr_An);
endmodule
