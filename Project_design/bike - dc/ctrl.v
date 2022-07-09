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
			N=N+1;          //��̼���
		  a=a+1;          //�͵�ƽ����
		  b=b+1;          //�ߵ�ƽ����
			if (rst==0)
				begin
					N=0;             //���rst���� ��̼�������
					a=0;             //���rst���� �͵�ƽ��������
					b=0;             //���rst���� �ߵ�ƽ��������
				end
		  else
		    begin 
					if(clk==1)
							 a=0;           //�ڸߵ�ƽʱ����
					else b=0;           //�ڵ͵�ƽʱ����    
        end
		end
	always@(negedge clk) 
      c=b;                      //��ֹ��һ���͵�ƽ��ʱ�����ߵ�ƽ�������� ��b�ļ�������c
     
	always@(posedge clk) 
		begin			
      if (rst==0)            //���rst���� ����ٶ�����
        begin
		      speed =0;
		      num = 0;
		    end
		  else 
		    begin 
					num=N*circle;        // ���=��ת��*�ܳ�
					speed=(a+c)*circle;  //�ٶ�=ת��*�ܳ�
					
					if (num>30000)    //������������3000�� led���� ��ʾ����
					   led=0;
					else led=1;
		    end
		end 

endmodule
