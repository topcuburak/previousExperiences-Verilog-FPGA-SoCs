module hw_3( output reg [31:0] product,  //product register is the output (result of the multiplication
				 input [15:0] Multiplicand, Multiplier,  //multiplier and multiplicand inputs 
				 input clk,
				 input [3:0] bit_range);

	reg  signed [15:0] A; //internal registers shown in the lecture notes ASM chart
	reg  [15:0] Q,M;   //internal registers shown in the lecture notes ASM chart
	reg Q_1; 			//internal registers shown in the lecture notes ASM chart 
	reg [4:0] count;  //internal registers that holds the count 
	reg state;			
	reg counter;
initial 
	begin
		A<=0;
		M<=Multiplicand;
		Q<=Multiplier;
		Q_1<=0;      
		state<=0;
		count<=16;
	end

always @(posedge clk)
	begin
		if(state==0)
		begin
			if (count!=0)
					begin
						if((Q[0]==0)&&(Q_1==1))		//for the case Q[0]=0 and Q_1=1 
							A<=A+M;						//add A to M 
						else if ((Q[0]==1)&&(Q_1==0)) 
							A<=A-M;						//for the case Q[0]=1 and Q_1=0, subtract A to M
					end								
				state<=1;
		end
		else if((state==1)&&(count!=0))			//shift right for all Q[0] and Q_1 
			begin
				{A,Q,Q_1}= {A[15],A,Q};
				count<=count-1;
				state<=0;
			end	
		else if (count==0)
			begin
				product <={A,Q};			//put the result in the product register that is output
			end
	end
endmodule
