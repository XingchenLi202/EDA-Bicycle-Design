module spwn_motor(clk,reset,up,down,division,direction,A,B,C,D,out);
input clk;
input reset;
input up;   //加速
input down; //减速
input [1:0] division; //步进电机分频控制状态
input direction; //方向控制，1：正。0：反
output out;       //输出频率
output A,B,C,D;   //方向状态
reg out;          
reg [1:0] sta,state;//相位控制状态,速度控制状态
reg sclk,sclock;    //对clk分频成sclk
reg [7:0] H,data1,data2;
reg [6:0] frediv;   //分频状态
reg [7:0] cnt1,cnt; //0-255
reg [6:0] count_sin,count,cnt2; //0-127
reg A,B,C,D;

parameter st0=2'h0, st1=2'h1, st2=2'h2,st3=2'h3;  //反向相位控制状态4
parameter sta0=2'h0, sta1=2'h1, sta2=2'h2,sta3=2'h3; //正向相位控制状态4
parameter state0=2'h0, state1=2'h1, state2=2'h2;    //速度控制状态3

//控制加速和减速部分
always@(posedge clk or negedge reset) 
   if(!reset)                 //如果reset按下  H=215进入 state0初始状态
         begin
	     H<=215;
	     state<=state0;
	     end                        
    else case(state)
					state0:
						begin
									if(!up && down)       //如果up按下  计入state1加速状态
										state<=state1;
									else if(up && !down)     //如果down按下  计入state2减速状态
										state<=state2;
									else
										state<=state0;            //否则 在state0初始状态
						end
					state1: 
									if(up)
										if(H>=8'd245)         //判断H=245  即最高速度
										state<=state0;        //  回到初始状态
									else 
										begin
												H<=H+8'd5;         //否则 H+5      回到最低速度
												state<=state0;
														end
					state2: if(down)
										if(H<=8'd215)      // 判断H=215  即最低速度
										state<=state0;      //    回到初始状态
									else
										begin
											H<=H-8'd5;           //否则 H-5      回到初始状态
											state<=state0;			
										end
					default: state<=state0;
						endcase	
								  
always@(posedge clk or negedge reset)   //时钟分频控制.系数越小，频率越大 
    if(!reset)
		  frediv<=16;
    else 
	    begin
				case (division)                 //对应步进电机的四个不同转速档
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
				sclk<=~sclk;                           //sclk 为clk的512分频
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
					sclock<=~sclock;                   //scolck为sclk 的256分频
				end
	 else count_sin<=count_sin+7'd1;
	 
//相位控制
always@(posedge sclk or negedge reset)	
     if(!reset)	
	       begin
					 cnt<=8'd0;count<=7'd0;sta<=sta0;
					 A<=1'b0; B<=1'b0; C<=1'b0; D<=1'b0;
				 end
    else begin                  //四相反式步进电机A->B->C->D->A换相四次，转子转动一个齿轮
	       cnt<=cnt+8'd1;
			if(direction)         //正向转动 
		 case(sta)  
		 sta0:                //从A到B 
		    begin
			    if(cnt>=8'd255)
						if(count>=frediv)
							begin
								sta<=sta1;                //如果cnt计数记到255时 进入下一状态
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
		sta1:    //从B到C 
			begin
			   if(cnt>=8'd255)
						if(count>=frediv)
							begin
								sta<=sta2;               //如果cnt计数记到255时 进入下一状态
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
      					   				 				   
		sta2:    //从C 到 D
			begin
				if(cnt>=8'd255)
					if(count>=frediv)
						begin
							sta<=sta3;               //如果cnt计数记到255时 进入下一状态
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
		sta3:   //从D 到A					
			begin
			  if(cnt>=8'd255)
			    if(count>=frediv)
						begin
							sta<=sta0;             //如果cnt计数记到255时 进入下一状态
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

else //反向转动
      case(sta) 
st0:	 //从A 到 D
       begin
			   if(cnt>=8'd255)
			      if(count>=frediv)
							begin
								sta<=sta1;               //如果cnt计数记到255时 进入下一状态
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
        
st1:	////从D到 C 
       begin
			   if(cnt>=8'd255)
			      if(count>=frediv)
							begin
								sta<=sta2;              //如果cnt计数记到255时 进入下一状态
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
       		   
st2:	//从C到 B 
       begin
			   if(cnt>=8'd255)
			      if(count>=frediv)
							begin
								sta<=sta3;            //如果cnt计数记到255时 进入下一状态
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
         
st3:	//从B 到 A 
       begin
				 if(cnt>=8'd255)
						if(count>=frediv)       
							begin
								sta<=sta0;             //如果cnt计数记到255时 进入下一状态
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
//正弦采样
always@(posedge sclock or negedge reset)
    if(!reset)
        cnt2<=7'd0;
    else case(frediv)  //占空比1：1的PWM波
				7'd16: begin   //档位1
	            if(cnt2>=16) //16个状态,sclk的计数器
								begin
									cnt2<=7'd1;
									out=~out;
								end    //16个sclk信号之后反转
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
							endcase //在16个sclk脉冲时间内，由A缓缓移动向B，根据图像分析
	end	
			7'd8: begin      //档位2
	            if(cnt2>=8) 
								begin
									cnt2<=7'd1;
									out=~out;
								end    //8个sclk信号之后反转
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
			7'd4: begin       //档位3
	            if(cnt2>=4) 
								begin
									cnt2<=7'd1;
									out=~out;//4个sclk信号之后反转
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
			7'd2: begin       //档位4
	            if(cnt2>=2) 
								begin
									cnt2<=7'd1;
									out=~out;
								end   //2个sclk信号之后反转
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