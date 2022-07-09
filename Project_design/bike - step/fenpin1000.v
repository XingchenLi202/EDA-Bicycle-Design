module fenpin1000(clockin,clockout);
input clockin;
output clockout;
reg [9:0]count;
reg clockout;
parameter N=1000;

always@(posedge clockin)
begin
	if(count==N/2-1)
	begin
		count<=0;
		clockout<=~clockout;
	end
	else count<=count+1;
end
endmodule
