module tpsba(input [15:0] inp_exp_x,	//taylor_poly_series_with_booth_algorithm module
				 input clk,
				 output reg [31:0] out_exp_x);


	reg [31:0] product;
	reg signed [15:0] A;
	reg [15:0] Q,M;
	reg Q_1;
	reg [4:0] count;		
	reg state;
	reg [1:0] state_2;
   reg [20:0] factorial_table [9:0];
	reg [1:0] taylor_state;
	reg [4:0] count_exp_sin_cos;		//new counter that is used for each step for the summation or subtraction of taylor polynomial series
	
	
	
	initial 
	begin
		A<=0;
		M<=inp_exp_x;
		Q<=inp_exp_x;
		Q_1<=0;      
		state<=0;
		count<=16;
		product<=0;
		state_2<=0;		
		factorial_table[1]<=16'b1000000000000000;			//look up table for the factorial values for the n=1....9;
		factorial_table[2]<=16'b0010101010101011;
		factorial_table[3]<=16'b0000101010101011;
		factorial_table[4]<=16'b0000001000100010;
		factorial_table[5]<=16'b0000000001011011;
		factorial_table[6]<=16'b0000000000001101;
		factorial_table[7]<=16'b0000000000000010;
		factorial_table[8]<=16'b0000000000000000;
		taylor_state<=0; 
		count_exp_sin_cos<=1;
		out_exp_x<=1; 		//initialized as 1 due to the first term of exponential definition of taylor definition.
		
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
			
			else if((state==1)&&(count!=0))		//shift process.
				begin
					{A,Q,Q_1}= {A[15],A,Q};
					count<=count-1;
					state<=0;
				end	
		
			else if ((count==0)&&(count_exp_sin_cos<=10))	//till count_exp_sin_cos reaches to 10, square calculation of the input will be
				begin														//calculated to reach 10 term. 
					if ((state_2==0)&&(count_exp_sin_cos!=11))
						begin
							product <={A,Q};				
							state_2<=1;	
						end
					else if ((state_2==1)&&(count_exp_sin_cos!=10))
						begin	
							A<=0;
							M<=product[15:0];			//product, stored in the multiplier
							Q<=inp_exp_x;				//input again assigned to multiplicand to get third, forth... power of the input used in 
							Q_1<=0;						//taylor expansion. 
							state_2<=2;
						end
					else if ((state_2==2)&&(count_exp_sin_cos!=10))		
						begin
							count<=16;
							state_2<=0;	
							state<=0;
							if (count_exp_sin_cos==1)					//after each process, count_exp_sin_cos is incremented. 
								begin
								count_exp_sin_cos<=count_exp_sin_cos+1;		
								M<=inp_exp_x;				
								Q<=inp_exp_x;
								Q_1<=0;
								end
							else
								count_exp_sin_cos<=count_exp_sin_cos+1;
						end
				end
	end
	
	always @(posedge clk)
	begin
			if((taylor_state==0)&&(state_2==1))			//these cases represent one by one addition of taylor series up to 10 term. 
			begin													//each addition is specified due to the counter called as count_exp_sin_cos. 
				case (count_exp_sin_cos)					
				5'b00001 :out_exp_x<=(out_exp_x<<16)+(inp_exp_x<<16);		//in order to reach same precision, both input and output shifted	
				5'b00010 :out_exp_x<=out_exp_x+(product*factorial_table[1]);	//left by 16.
				5'b00011 :out_exp_x<=out_exp_x+(product*factorial_table[2]);
				5'b00100 :out_exp_x<=out_exp_x+(product*factorial_table[3]);
				5'b00101 :out_exp_x<=out_exp_x+(product*factorial_table[4]);
				5'b00110 :out_exp_x<=out_exp_x+(product*factorial_table[5]);
				5'b00111 :out_exp_x<=out_exp_x+(product*factorial_table[6]); 
				5'b01000 :out_exp_x<=out_exp_x+(product*factorial_table[7]);	
				5'b01001 : begin 
							  out_exp_x<=(out_exp_x+(product*factorial_table[7]))>>16; //until this point the [15:0] bits are the fractional part
							  taylor_state<=1;														//to get real result, output is shifted right by 16.
							  end
				endcase
			end
	end
endmodule
