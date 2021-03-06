module fenwei1(clk,in,out1,out2,out3,out4);
	input clk;
	input [18:0]in;
	output [3:0]out1,out2,out3,out4; 
	reg  [3:0]out1,out2,out3,out4; 
	
	always@(posedge clk)
		begin
			out1=in/10000;
			out2=(in-out1*10000)/1000;
			out3=(in-out1*10000-out2*1000)/100;
			out4=(in-out1*10000-out2*1000-out3*100)/10;
		end
 endmodule