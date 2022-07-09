module shake(clock,keyin,keyout);
	input clock,keyin;
	output keyout;
	reg[3:0]count;
	reg keyout;

	always@(posedge clock)
		begin 
			if (keyin==0)
			begin
				count<=count+1;
				if(count<8)
				  keyout<=1;
				else 
				  begin
						keyout<=keyin;
						count<=9;
					end
		 	end
		  else
		    begin
					count<=0;
					keyout<=1;
			  end
			end
endmodule
