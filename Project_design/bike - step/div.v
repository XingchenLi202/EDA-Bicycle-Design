module div(sclk,reset,clk);
input sclk;
input reset;
output clk;
reg [4:0] count;
reg clk;

always@(posedge sclk)
  begin
    if(count==50/2-1)
			begin
			 clk<=~clk;	   
				count<=0;
			end  
	  else 
	   count<=count+5'd1;
  end
endmodule	   