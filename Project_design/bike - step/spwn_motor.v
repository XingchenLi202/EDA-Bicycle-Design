module spwn_motor(clk,reset,up,down,division,direction,A,B,C,D,out);
input clk;
input reset;
input up;   //����
input down; //����
input [1:0] division; //���������Ƶ����״̬
input direction; //������ƣ�1������0����
output out;       //���Ƶ��
output A,B,C,D;   //����״̬
reg out;          
reg [1:0] sta,state;//��λ����״̬,�ٶȿ���״̬
reg sclk,sclock;    //��clk��Ƶ��sclk
reg [7:0] H,data1,data2;
reg [6:0] frediv;   //��Ƶ״̬
reg [7:0] cnt1,cnt; //0-255
reg [6:0] count_sin,count,cnt2; //0-127
reg A,B,C,D;

parameter st0=2'h0, st1=2'h1, st2=2'h2,st3=2'h3;  //������λ����״̬4
parameter sta0=2'h0, sta1=2'h1, sta2=2'h2,sta3=2'h3; //������λ����״̬4
parameter state0=2'h0, state1=2'h1, state2=2'h2;    //�ٶȿ���״̬3

//���Ƽ��ٺͼ��ٲ���
always@(posedge clk or negedge reset) 
   if(!reset)                 //���reset����  H=215���� state0��ʼ״̬
         begin
	     H<=215;
	     state<=state0;
	     end                        
    else case(state)
					state0:
						begin
									if(!up && down)       //���up����  ����state1����״̬
										state<=state1;
									else if(up && !down)     //���down����  ����state2����״̬
										state<=state2;
									else
										state<=state0;            //���� ��state0��ʼ״̬
						end
					state1: 
									if(up)
										if(H>=8'd245)         //�ж�H=245  ������ٶ�
										state<=state0;        //  �ص���ʼ״̬
									else 
										begin
												H<=H+8'd5;         //���� H+5      �ص�����ٶ�
												state<=state0;
														end
					state2: if(down)
										if(H<=8'd215)      // �ж�H=215  ������ٶ�
										state<=state0;      //    �ص���ʼ״̬
									else
										begin
											H<=H-8'd5;           //���� H-5      �ص���ʼ״̬
											state<=state0;			
										end
					default: state<=state0;
						endcase	
								  
always@(posedge clk or negedge reset)   //ʱ�ӷ�Ƶ����.ϵ��ԽС��Ƶ��Խ�� 
    if(!reset)
		  frediv<=16;
    else 
	    begin
				case (division)                 //��Ӧ����������ĸ���ͬת�ٵ�
					3'b00:  frediv<=16;            
					3'b01:  frediv<=8;       							   
					3'b10:  frediv<=4;  
					3'b11:  frediv<=2;  
					default:  frediv<=16;
				endcase	
	    end

always@(posedge clk or negedge reset)
    if(!reset)
	     begin
				cnt1<=8'd0;
				sclk<=1'b0;
			end
		else if(cnt1==8'd255)
	    begin
				cnt1<=H;
				sclk<=~sclk;                           //sclk Ϊclk��512��Ƶ
			end
    else cnt1<=cnt1+8'd1;		 
    
//-
always@(posedge sclk or negedge reset)
     if(!reset)
	      begin
					count_sin<=7'd0;
					sclock<=1'b0;
				end
	 else if(count_sin==7'd127)
	      begin
					count_sin<=7'd0;
					sclock<=~sclock;                   //scolckΪsclk ��256��Ƶ
				end
	 else count_sin<=count_sin+7'd1;
	 
//��λ����
always@(posedge sclk or negedge reset)	
     if(!reset)	
	       begin
					 cnt<=8'd0;count<=7'd0;sta<=sta0;
					 A<=1'b0; B<=1'b0; C<=1'b0; D<=1'b0;
				 end
    else begin                  //���෴ʽ�������A->B->C->D->A�����ĴΣ�ת��ת��һ������
	       cnt<=cnt+8'd1;
			if(direction)         //����ת�� 
		 case(sta)  
		 sta0:                //��A��B 
		    begin
			    if(cnt>=8'd255)
						if(count>=frediv)
							begin
								sta<=sta1;                //���cnt�����ǵ�255ʱ ������һ״̬
								count<=7'd1;                
							end
						else count<=count+7'd1;
			   
			    if(cnt<=data1) 
             begin  A<=1'b1; C<=1'b0; D<=1'b0; end
			    else	 
             begin  A<=1'b0; C<=1'b0; D<=1'b0; end
                 
			    if(cnt<=data2) 
             begin  B<=1'b1; C<=1'b0; D<=1'b0; end
			    else	 
             begin  B<=1'b0; C<=1'b0; D<=1'b0; end			   
                 					   
            end				   
		sta1:    //��B��C 
			begin
			   if(cnt>=8'd255)
						if(count>=frediv)
							begin
								sta<=sta2;               //���cnt�����ǵ�255ʱ ������һ״̬
								count<=7'd1;
							end
						else count<=count+7'd1;
						
			   if(cnt<=data1) 
           begin  B<=1'b1; A<=1'b0; D<=1'b0; end
				 else	 
           begin  B<=1'b0; A<=1'b0; D<=1'b0; end 
              
				 if(cnt<=data2) 
           begin  C<=1'b1; A<=1'b0; D<=1'b0; end
				 else	 
           begin  C<=1'b0; A<=1'b0; D<=1'b0; end			   
      end     
      					   				 				   
		sta2:    //��C �� D
			begin
				if(cnt>=8'd255)
					if(count>=frediv)
						begin
							sta<=sta3;               //���cnt�����ǵ�255ʱ ������һ״̬
							count<=7'd1;
						end
				  else count<=count+7'd1;
				 
					if(cnt<=data1) 
						begin  C<=1'b1; A<=1'b0; B<=1'b0; end
					else	 
            begin  C<=1'b0; A<=1'b0; B<=1'b0; end
                 
					if(cnt<=data2) 
						begin  D<=1'b1; A<=1'b0; B<=1'b0; end
					else	 
						begin  D<=1'b0; A<=1'b0; B<=1'b0; end			   
      end		
		sta3:   //��D ��A					
			begin
			  if(cnt>=8'd255)
			    if(count>=frediv)
						begin
							sta<=sta0;             //���cnt�����ǵ�255ʱ ������һ״̬
							count<=7'd1;
						end
			    else count<=count+7'd1;
			     
				if(cnt<=data1) 
          begin  D<=1'b1; C<=1'b0; B<=1'b0; end
				else	 
          begin  D<=1'b0; C<=1'b0; B<=1'b0; end
                 
				if(cnt<=data2) 
          begin  A<=1'b1; C<=1'b0; B<=1'b0; end
				else	 
          begin  A<=1'b0; C<=1'b0; B<=1'b0; end			   
       end	
		default:  begin  A<=1'b0; B<=1'b0; C<=1'b0; D<=1'b0; end			
  endcase

else //����ת��
      case(sta) 
st0:	 //��A �� D
       begin
			   if(cnt>=8'd255)
			      if(count>=frediv)
							begin
								sta<=sta1;               //���cnt�����ǵ�255ʱ ������һ״̬
								count<=7'd1;
							end
						else count<=count+7'd1;
			   
			   if(cnt<=data1) 
           begin  A<=1'b1; C<=1'b0; B<=1'b0; end
			   else	 
           begin  A<=1'b0; C<=1'b0; B<=1'b0; end
                 
			   if(cnt<=data2) 
           begin  D<=1'b1; C<=1'b0; B<=1'b0; end
			   else	 
           begin  D<=1'b0; C<=1'b0; B<=1'b0; end			   
        end					   
        
st1:	////��D�� C 
       begin
			   if(cnt>=8'd255)
			      if(count>=frediv)
							begin
								sta<=sta2;              //���cnt�����ǵ�255ʱ ������һ״̬
								count<=7'd1;
							end
						else count<=count+7'd1;
			   
			   if(cnt<=data1) 
           begin  D<=1'b1; A<=1'b0; B<=1'b0; end
			   else	 
           begin  D<=1'b0; A<=1'b0; B<=1'b0; end
                 
			   if(cnt<=data2) 
           begin  C<=1'b1; A<=1'b0; B<=1'b0; end
			   else	 
           begin  C<=1'b0; A<=1'b0; B<=1'b0; end			   
       end				
       		   
st2:	//��C�� B 
       begin
			   if(cnt>=8'd255)
			      if(count>=frediv)
							begin
								sta<=sta3;            //���cnt�����ǵ�255ʱ ������һ״̬
								count<=7'd1;
							end
						else count<=count+7'd1;
			   
			   if(cnt<=data1) 
           begin  C<=1'b1; A<=1'b0; D<=1'b0; end
			   else	 
           begin  C<=1'b0; A<=1'b0; D<=1'b0; end
                 
			   if(cnt<=data2) 
           begin  B<=1'b1; A<=1'b0; D<=1'b0; end
			   else	 
           begin  B<=1'b0; A<=1'b0; D<=1'b0; end			   
       end			
         
st3:	//��B �� A 
       begin
				 if(cnt>=8'd255)
						if(count>=frediv)       
							begin
								sta<=sta0;             //���cnt�����ǵ�255ʱ ������һ״̬
								count<=7'd1;
							end
				 else count<=count+7'd1;
			   
			   if(cnt<=data1) 
           begin  B<=1'b1; C<=1'b0; D<=1'b0; end
			   else	 
           begin  B<=1'b0; C<=1'b0; D<=1'b0; end
                 
			   if(cnt<=data2) 
            begin  A<=1'b1; C<=1'b0; D<=1'b0; end
			   else	 
            begin  A<=1'b0; C<=1'b0; D<=1'b0; end			   
       end			
         
   default:  begin  A<=1'b0; B<=1'b0; C<=1'b0; D<=1'b0; end			
  endcase      		 
end	
//���Ҳ���
always@(posedge sclock or negedge reset)
    if(!reset)
        cnt2<=7'd0;
    else case(frediv)  //ռ�ձ�1��1��PWM��
				7'd16: begin   //��λ1
	            if(cnt2>=16) //16��״̬,sclk�ļ�����
								begin
									cnt2<=7'd1;
									out=~out;
								end    //16��sclk�ź�֮��ת
							else
								cnt2<=cnt2+7'd1;
								case(cnt2)  
								1:  begin data1<=254; data2<=2;   end			
								2:  begin data1<=251; data2<=5;   end
								3:  begin data1<=244; data2<=14;  end
								4:  begin data1<=232; data2<=26;  end
								5:  begin data1<=215; data2<=43;  end
								6:  begin data1<=196; data2<=63;  end
								7:  begin data1<=174; data2<=85;  end
								8:  begin data1<=150; data2<=109; end
								9:  begin data1<=125; data2<=128; end
								10: begin data1<=100; data2<=153; end
								11: begin data1<=77;  data2<=177; end
								12: begin data1<=55;  data2<=198; end
								13: begin data1<=36;  data2<=218; end
								14: begin data1<=21;  data2<=233; end
								15: begin data1<=10;  data2<=245; end
								16: begin data1<=4;   data2<=252; end
								default: begin data1<=0;data2<=0;   end
							endcase //��16��sclk����ʱ���ڣ���A�����ƶ���B������ͼ�����
	end	
			7'd8: begin      //��λ2
	            if(cnt2>=8) 
								begin
									cnt2<=7'd1;
									out=~out;
								end    //8��sclk�ź�֮��ת
							else
								cnt2<=cnt2+7'd1;
								case(cnt2)  
								1:  begin data1<=254; data2<=2;   end			
								2:  begin data1<=244; data2<=14;  end
								3:  begin data1<=215; data2<=43;  end
								4:  begin data1<=174; data2<=85;  end
								5:  begin data1<=125; data2<=128; end
								6:  begin data1<=77;  data2<=177; end
								7:  begin data1<=36;  data2<=218; end
								8:  begin data1<=10;  data2<=245; end
								default: begin data1<=0; data2<=0;   end
								endcase
	      end	
			7'd4: begin       //��λ3
	            if(cnt2>=4) 
								begin
									cnt2<=7'd1;
									out=~out;//4��sclk�ź�֮��ת
								end
							else
								cnt2<=cnt2+7'd1;
								case(cnt2)  
								1:  begin data1<=254; data2<=2;   end			
								2:  begin data1<=215; data2<=43;  end
								3:  begin data1<=125; data2<=128; end
								4:  begin data1<=36;  data2<=218; end
								default: begin data1<=0;   data2<=0;   end
								endcase
	      end		
			7'd2: begin       //��λ4
	            if(cnt2>=2) 
								begin
									cnt2<=7'd1;
									out=~out;
								end   //2��sclk�ź�֮��ת
							else
								cnt2<=cnt2+7'd1;
								case(cnt2)  
								1:  begin data1<=254; data2<=2;   end			
								2:  begin data1<=128; data2<=128; end
								default: begin data1<=0; data2<=0; end
								endcase
	      end		
endcase	
endmodule 