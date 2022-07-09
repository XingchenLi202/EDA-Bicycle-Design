module xianshi(clk,h,g,f,e,d,c,b,a,i,s);
	input clk;
	input [7:0]a,b,c,d,e,f,g,h;
	output [7:0]i;
	output [2:0]s;
	reg [7:0]s;
	reg [7:0]i;
	reg [2:0]state;
	

	always@(posedge clk)
		begin
			state=state+1;
			if (state==1)
			  begin 
         s=8'b01111111;
          i=a;             //将第一位输出
        end
      else if (state==2)
			  begin 
          s=8'b10111111;
          i=b;             //将第2位输出
        end
      else if (state==3)
			  begin 
          s=8'b11011111;
          i=c;             //将第三位输出
        end
      else if (state==4)
			  begin 
          s=8'b11101111;
          i=d;             //将第四位输出
        end
      else if (state==5)
			  begin 
          s=8'b11110111;
          i=e;             //将第五位输出
        end
      else if (state==6)
			  begin 
          s=8'b11111011;
          i=f;             //将第六位输出
        end
      else if (state==7)
			  begin 
          s=8'b11111101;
          i=g;             //将第七位输出
        end 
			else 
			  begin 
          s=8'b11111110;
          i=h;             //将第八位输出
        end                  
    end
 endmodule
			