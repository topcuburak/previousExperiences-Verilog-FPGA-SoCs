module factorial(output reg [31:0] product, 
					  input [15:0] N, //the input number that is calculated as factorial funtion
					  input clk
					  );
	reg [15:0] temp_N;				  //temporary register to hold input number
	reg signed [15:0] A;
	reg [15:0] Q,M;						//the booth algorithm is explained in the part a of the homework
	reg Q_1;
	reg [4:0] count;
	reg state;
	reg [1:0] state_2;			
initial 
	begin
		A<=0;
		M<=N;
		Q<=(N-1);
		Q_1<=0;      
		state<=0;
		count<=16;
		product<=0;
		temp_N<=(N-1);
		state_2<=0;
	end

always @(posedge clk)
	begin
		if(state==0)
		begin
			if (count!=0)
				begin
					if((Q[0]==0)&&(Q_1==1))
						A<=A+M;
					else if ((Q[0]==1)&&(Q_1==0)) 
						A<=A-M;
				end
				state<=1;
		end
		
		else if((state==1)&&(count!=0))		//three state is defined to shift
														//refresh multiplicand and multiplier and start the algorithm again
			begin
				{A,Q,Q_1}= {A[15],A,Q};
				count<=count-1;
				state<=0;
			end	
		
		else if ((count==0)&&(temp_N!=0)) //when count reaches 0, and temp_N!=1;
			begin									 
				if (state_2==0)				
				begin
					product <={A,Q};
					temp_N<=temp_N-1;			//decrement input N
					state_2<=1;	
				end
				else if (state_2==1)
				begin	
					A<=0;
					M<=product[15:0];		//hold the result in the product, put it to M register for the new multiplicand
					Q<=temp_N;				//put decremented input to the multiplicand register Q
					Q_1<=0;
					state_2<=2;
				end
				else if (state_2==2)
				begin
					count<=16;				//start booth algorithm again
					state_2<=0;
					state<=0;

				end
			end
	end
endmodule
	
