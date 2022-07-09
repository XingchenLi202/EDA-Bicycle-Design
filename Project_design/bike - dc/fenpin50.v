module fenpin50(clockin,clockout);
input clockin;
output clockout;
reg [5:0]count;
reg clockout;
parameter N=50;

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
