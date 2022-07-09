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
          i=a;             //����һλ���
        end
      else if (state==2)
			  begin 
          s=8'b10111111;
          i=b;             //����2λ���
        end
      else if (state==3)
			  begin 
          s=8'b11011111;
          i=c;             //������λ���
        end
      else if (state==4)
			  begin 
          s=8'b11101111;
          i=d;             //������λ���
        end
      else if (state==5)
			  begin 
          s=8'b11110111;
          i=e;             //������λ���
        end
      else if (state==6)
			  begin 
          s=8'b11111011;
          i=f;             //������λ���
        end
      else if (state==7)
			  begin 
          s=8'b11111101;
          i=g;             //������λ���
        end 
			else 
			  begin 
          s=8'b11111110;
          i=h;             //���ڰ�λ���
        end                  
    end
 endmodule
			