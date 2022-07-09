module fenwei(clk,in,out1,out2,out3,out4);
	input clk;
	input [13:0]in;
	output [3:0]out1,out2,out3,out4; 
	reg  [3:0]out1,out2,out3,out4,a; 
	
	always@(posedge clk)
		begin
		  a=in/10000;
			out1=(in-a*10000)/1000;
			out2=(in-a*10000-out1*1000)/100;
			out3=(in-a*10000-out1*1000-out2*100)/10;
			out4=in-a*10000-out1*1000-out2*100-out3*10;    
		end
 endmodule
 