module DC_Motor(clock,enable,reset, MA);
	input reset;
	input clock;
	input enable;                  //���ƿ���
	output [1:0]MA;                //�������
	reg pulse;	       //����
	reg [1:0]MA;	   //������� 

	always@(posedge clock or negedge reset)
		begin  
			if(!reset)          //��λ
      	MA<= 0;   
			else //��MA_r[0]Ϊ׼����״̬0��ʱ�����״̬1��ʱ��ʱ�������ʱ��ת������֮�����˳ʱ��ת����
				begin
					if (enable == 1)       
						MA <= 0;     
					else//29-45:��2�����ſ�������˫����PWM������
						begin        
							MA[0] <= pulse;
							MA[1] <= ~pulse; //MA_r[1]��MA_r[0]����
						end    
				end
		end  
endmodule
                
