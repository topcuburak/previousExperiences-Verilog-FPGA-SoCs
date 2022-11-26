module cosine_module(input [15:0] inp_cos_x, 	//cosine module
				 input clk,
				 output reg [31:0]  out_cos_x);


	reg [40:0] product;
	reg signed [15:0] A;
	reg [15:0] Q,M;
	reg Q_1;
	reg [4:0] count;
	reg state;
	reg [1:0] state_2;
   reg [20:0] factorial_table [9:0];
	reg [1:0] taylor_state;
	reg [4:0] count_exp_sin_cos;
	
	
	
	initial 
	begin
		A<=0;
		M<=inp_cos_x;
		Q<=inp_cos_x;
		Q_1<=0;      
		state<=0;
		count<=16;
		product<=0;
		state_2<=0;		
		factorial_table[1]<=16'b1000000000000000;	//factorial_table
		factorial_table[2]<=16'b0010101010101011;
		factorial_table[3]<=16'b0000101010101011;
		factorial_table[4]<=16'b0000001000100010;
		factorial_table[5]<=16'b0000000001011011;
		factorial_table[6]<=16'b0000000000001101;
		factorial_table[7]<=16'b0000000000000010;
		factorial_table[8]<=16'b0000000000000001;
		taylor_state<=0; 
		count_exp_sin_cos<=1;
		out_cos_x<=17'b10000000000000000; //first term is the 1 but shifted to 16 bit to right to get same precision with the calculated other terms.
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
			
			else if((state==1)&&(count!=0))
				begin
					{A,Q,Q_1}= {A[15],A,Q};
					count<=count-1;
					state<=0;
				end	
		
			else if ((count==0)&&(count_exp_sin_cos<=10))
				begin
					if ((state_2==0)&&(count_exp_sin_cos!=11))
						begin
							product <={A,Q};
							state_2<=1;	
						end
					else if ((state_2==1)&&(count_exp_sin_cos!=10))
						begin	
							A<=0;
							M<=product[15:0];
							Q<=inp_cos_x;
							Q_1<=0;
							state_2<=2;
						end
					else if ((state_2==2)&&(count_exp_sin_cos!=10))
						begin
							count<=16;
							state_2<=0;
							state<=0;
							count_exp_sin_cos<=count_exp_sin_cos+1;
						end
				end
	end
	
always @(posedge clk)
	begin
			if((taylor_state==0)&&(state_2==1))
			begin
				case (count_exp_sin_cos)					//in the  cosine expansion, each respective term added to the output result.
				5'b00001 :out_cos_x<=out_cos_x-(product*factorial_table[1]);	//x^2/2!
				5'b00011 :out_cos_x<=out_cos_x+(product*factorial_table[3]);	//x^4/4!, and so on.
				5'b00101 :out_cos_x<=out_cos_x-(product*factorial_table[5]);	
				5'b00111 :out_cos_x<=out_cos_x+(product*factorial_table[7]);	//after all terms are calculated and added to the output
																								//respective cosine value is calculated manually and the result shared in the  simulation results file. 
				endcase
			end
	end
endmodule