module DC_Motor(clock,enable,reset, MA);
	input reset;
	input clock;
	input enable;                  //控制开关
	output [1:0]MA;                //电机控制
	reg pulse;	       //脉冲
	reg [1:0]MA;	   //电机控制 

	always@(posedge clock or negedge reset)
		begin  
			if(!reset)          //复位
      	MA<= 0;   
			else //以MA_r[0]为准，当状态0的时间大于状态1的时间时，电机逆时针转动；反之，电机顺时针转动。
				begin
					if (enable == 1)       
						MA <= 0;     
					else//29-45:由2个引脚控制生成双极性PWM发生器
						begin        
							MA[0] <= pulse;
							MA[1] <= ~pulse; //MA_r[1]与MA_r[0]反向
						end    
				end
		end  
endmodule
                
