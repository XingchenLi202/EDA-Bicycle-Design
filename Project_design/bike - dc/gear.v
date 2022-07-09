module gear (in,out);
	input in;
	output [3:0]out;
	reg [3:0]out;
	reg [1:0]a;

	always@(negedge in) 
		begin
		     if (a==2)
		        a=0;
		     else a=a+1;
		end
	always@(posedge in) 
	  begin 
		  case(a)
		     2'b00:out=15;
		     2'b01:out=12;
		     2'b10:out=8;
		     default out=15;
		   endcase
		 end
endmodule
		     
		     
		     
		  
		     
		     