module DC_state(clk,in,out);
	input clk,in;
	output out;
	reg out;
  
  always @(posedge clk)
    begin 
			if(in==0)
			  out=~out;
			else 
			  out=out;
		end
endmodule
