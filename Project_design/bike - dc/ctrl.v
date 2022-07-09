module ctrl(clk,rst,in,circle,num,speed,led);
	input clk,in,rst;
	input [3:0]circle;
	output num,speed,led;

	reg [18:0] num;
	reg [13:0] speed=0;
	reg [11:0] N=0 ;
	reg [8:0] a,b,c;
	reg led;

	always@(posedge in )
		begin 
			N=N+1;          //里程计数
		  a=a+1;          //低电平计数
		  b=b+1;          //高电平计数
			if (rst==0)
				begin
					N=0;             //如果rst按下 里程计数清零
					a=0;             //如果rst按下 低电平计数清零
					b=0;             //如果rst按下 高电平计数清零
				end
		  else
		    begin 
					if(clk==1)
							 a=0;           //在高电平时清零
					else b=0;           //在低电平时清零    
        end
		end
	always@(negedge clk) 
      c=b;                      //防止下一个低电平来时，将高电平计数清零 将b的计数赋给c
     
	always@(posedge clk) 
		begin			
      if (rst==0)            //如果rst按下 里程速度清零
        begin
		      speed =0;
		      num = 0;
		    end
		  else 
		    begin 
					num=N*circle;        // 里程=总转数*周长
					speed=(a+c)*circle;  //速度=转数*周长
					
					if (num>30000)    //如果里程数超过3000米 led灯亮 提示清零
					   led=0;
					else led=1;
		    end
		end 

endmodule
