module speed(clk,rst,in,num,speed,led);
	input clk,in,rst;
	output num,speed,led;

	reg [9:0] num=0;
	reg [9:0] speed=0;
	reg [8:0] N=0 ;
	reg [8:0] a,b,c;
	reg led=1;

	always@(posedge in)
		begin 
			N=N+1;
			a=a+1;
			b=b+1; 
			if (rst==0)
				N=0;
			else if (N>2500)
							led=0;
			else if (clk==1)
             a=0;
			else if (clk==0)
             b=0;   
		end
	always@(negedge clk) 
      c=b;
     
	always@(posedge clk) 
		begin
      num=N*10;
      speed=(a+c)*10;
		end 

endmodule
