

//BURAK TOPÇU 2617385
//EE445 HW-2, MANO'S BASIC COMPUTER


module hw_2(	
		input clk,
		input start,
		input [7:0] inp_1,
		output reg [7:0] out_1
		);
		
			reg Start; 				//Start flip flop
			reg [15:0] DR, AC, IR, TR; //data reg, accumulator, instruction reg, temp reg
			reg [11:0] PC, AR;		//program counter, address reg
			reg [7:0] OUTR, INPR;		//input and output regs
			reg [3:0] SC;		//timer
			reg [2:0] D;		//instruction decoder
			reg Indirect, E, FGI, FGO, IEN, IRQ; //indirect=I flip flop
			reg [15:0] mem_ram[4096:0];			//4K memory
	
	initial
		begin
			mem_ram [0]<=16'h1030;		//1030	at address=48, I put 4. PC==1
			mem_ram [1]<=16'h1031;		//100B	at address=49, I put 5. PC==2
			mem_ram [2]<=16'h7800;		//7800 	CLA again, PC==3
			mem_ram [3]<=16'h2037;     //LDA at 48. location
			mem_ram [4]<=16'h3030;		//store at 48. location
			//mem_ram [5]<=16'h4030;	//BUN
			//mem_ram [6]<=16'h5030;	//BSA
			//mem_ram [7]<=16'h6030;	//ISZ
			mem_ram [5]<=16'h7800;		//CLA
			mem_ram [6]<=16'h7400;		//CLE
			mem_ram [7]<=16'h7200;		//CMA
			mem_ram [8]<=16'h1030;		//again ADD AC to new value coming from store instruction to show circulations
			mem_ram [9]<=16'h7080;		//CIR
			mem_ram [10]<=16'h7040;		//CIL
			mem_ram [11]<=16'h7020;		//INC
			mem_ram [12]<=16'h7010;		//SPA
			mem_ram [13]<=16'h7008;		//SNA
			mem_ram [14]<=16'h7004;		//SZA	
			mem_ram [15]<=16'h7002;		//SZE
			mem_ram [16]<=16'h7001;		//HLT
			//mem_ram [21]<=16'h7008
			mem_ram [48]<=4;
			mem_ram [49]<=5;
			mem_ram [50]<=6;
			mem_ram [51]<=7;
			mem_ram [55]<=30;

			SC<=0;		//sequence counter that counts time T1, T2...
			DR<=0;		//data register
			AC<=0;		//accumulator 
			IR<=0;		//instruction  register
			TR<=0;		//temporary register
			OUTR<=0;		//output register
			INPR<=0;		//input register
			AR<=0;		//address register
			PC<=0;		//program  counter
			
			Start<=1;		//start signal
			//actually this start given as input, delete below to apply start signalx
			//Start<=start;
			Indirect<=0;		//indirect register 
			E<=0;					//E flag register
			FGI<=0;				//FGI flag (input flag)
			FGO<=0;				//FGO flag (output flag)
			IEN<=0;				//interrupt enable
			IRQ<=0;				//interrupt request 
		end	
		
	always @(posedge clk)  //fetching and decode block
								  //if start is not  enabled, no fetch occurs, hence no operation will be carried out.
	
	begin
		if(Start==1)
		begin
			if(SC==0)			//at  SC=0, T0 case, for that case AC<-PC
				begin
					AR<=PC;
					SC<=SC+1;
				end
			else if (SC==1)	//at T1, read information from  memory to IR
				begin
					IR[15:0]<=mem_ram[AR];
					PC<=PC+1;		
					SC<=SC+1;
				end
			else if (SC==2)	//at T2
				begin
					D[2:0]<=IR[14:12];  //D is the decoded instructions
					Indirect<=IR[15];		//For controlling type of instruction such as indirect or direct
					AR[11:0]<=IR[11:0];	//address of operand or address of address of operand.
					SC<=SC+1;
				end
		end
	end
	
	always@ (posedge clk)
	begin
		if((D==3'b111)&(Indirect==1)&(SC==3))
		begin
			INPR<=inp_1;
			OUTR<=out_1;
			if(IR[11]==1)
				begin
					AC[7:0]<=INPR;		//input is received by accumualator
					FGI<=0;
					SC<=0;
				end
			else if(IR[10]==1)
				begin
					OUTR<=AC[7:0];		//output is received from accumulator
					FGO<=0;
					SC<=0;
				end
			else if (IR[9]==1)
				begin
					if(FGI==1)
					PC<=PC+1;
					SC<=0;
				end
			else if (IR[8]==1)
				begin
					if(FGO==1)
					PC<=PC+1;
					SC<=0;
				end
			else if (IR[7]==1)
				begin
					IEN<=1;			//interrupt enable signal generated			
					SC<=0;
				end
			else if (IR[6]==1)
				begin
					SC<=0;
					IEN<=0;			//interrupt disable signal generated
				end
		end
	end
	

	always @(posedge clk) 		//to regulate interrupt signal 
	begin
		
		//if T0'T1'T2'IEN(FGI+FGO), interrupt request  will be  activated
		if(((SC!=0)&(SC!=1)&(SC!=2)&(IEN==1))&((FGI==1)|(FGO==1)))    
			begin
				IRQ<=1;	
				SC<=0;
			end
		else if((IRQ==1)&(SC==0))  //at T0 & IRQ=1
			begin
				AR<=0;		//address reg is assigned by 0 to reach first row of mem. 
				TR<=PC;		//PC will be stored in the TR
				SC<=SC+1;	//then time is incremented
			end
		else if((IRQ==1)&(SC==1))  //at T1 & IRQ=1
			begin
				mem_ram[AR]<=TR;		//at the 0th loc of mem, TR stored to back to that link after interrupt
				PC<=0;			//PC will 0
				SC<=SC+1;
			end
		else if((IRQ==1)&(SC==2))  //at T2 & IRQ=1
			begin
				PC<=PC+1;		//PC incremented
				IEN<=0;			//interrupt disabled
				IRQ<=0;			//IRQ 0 and time 0
				SC<=0;
			end
	end



	always @(posedge clk) //register reference type instructions 
	begin	 
		if(((D==3'b111)&(Indirect==0))&SC==3) // (((D==3'b111)&(I==0))&&SC==3) is assigned as r in lecture notes
		begin
				if(AR[11]==1'b1)   		//clear accumulator 
					begin
					AC<=0;
					SC<=0;
					end
				else if (AR[10]==1'b1)	//clear E register
					begin
					E<=0;
					SC<=0;
					end
				else if (AR[9]==1'b1)	//complement accumulator instruction
					begin
					AC<=~AC;
					SC<=0;
					end
				else if (AR[8]==1'b1)	//complement E instruction
					begin
					E<=E;
					SC<=0;
					end
				else if (AR[7]==1'b1)	//circulate to right
					begin	
						AC[14:0]<=AC[15:1];
						E<=AC[0];
						SC<=0;
					end
				else if (AR[6]==1'b1)	//circulate to left
					begin	
						AC[15:1]<=AC[14:0];
						E<=AC[15];
						SC<=0;
					end
				else if (AR[5]==1'b1)	//increment accumulator
					begin
						AC<=AC+1;
						SC<=0;
					end
				else if (AR[4]==1'b1)	//Skip Positive accumulator
					begin
						if(AC[15]==0)
							begin
							PC<=PC+1;
							SC<=0;
							end
					end
				else if (AR[3]==1'b1)	//Skip Negative Accumulator
					begin
						if(AC[15]==1)
							begin
								PC<=PC+1;
								SC<=0;
							end
					end
				else if (AR[2]==1'b1)	//Skip Zero if AC=0
					begin
						if(AC[15:0]==16'h00)
							begin
								PC<=PC+1;
								SC<=0;
							end
					end
				else if (AR[1]==1'b1)	//Skip if E=0
					begin
						if(E==0)
							begin
								PC<=PC+1;
								SC<=0;
							end
					end
				else 							//HLT
					begin
					SC<=0;
					end
		end
		
	else if ((D!=3'b111)&(Indirect==0))		//memory reg operations, without indirect
		begin
		 if((D==3'b000))  //AND operation
			begin
				if(SC==3)
					begin
						DR<=mem_ram[AR];
						SC<=SC+1;
					end
				else if(SC==4)
					begin
						AC<=AC&DR;
						SC<=0;
					end
			end
		else if((D==3'b001))	 //ADD
			begin
				if(SC==3)
					begin
					DR<=mem_ram[AR];
					SC<=SC+1;
					end
				else if (SC==4)
					begin
					{E,AC[15:0]}<= AC+DR;
					SC<=0;
					end				
			end
		
		else if((D==3'b010))	//LOAD,LDR
			begin
				if(SC==3)
					begin
						DR<=mem_ram[AR];
						SC<=SC+1;
					end
				else if (SC==4)
					begin
						AC<=DR;
						SC<=0;
					end
			end

		else if((D==3'b011))	//store, STR
			begin
				if(SC==3)
					begin
						mem_ram[AR]<=AC[15:0];
						SC<=0;
					end
			end
		
		else if((D==3'b100))	//Branch unconditionally
			begin
				if(SC==3)
					begin
					PC<=PC+1;
					SC<=0;
					end
			end
		else if((D==3'b101))	//Branch and save return address
			begin
				if(SC==3)
					begin
					mem_ram[AR]<=PC;
					AR<=AR+1;
					SC<=SC+1;
					end
				else if (SC==4)
					begin
					PC<=AR;
					SC<=0;
					end
			end
		else if((D==3'b110))		//ISZ
			begin
				if(SC==3)
					begin
					DR<=mem_ram[AR];
					SC<=SC+1;
					end
				else if(SC==4)
					begin
					DR<=DR+1;
					SC<=SC+1;
					end
				else if(SC==5)
					begin
					mem_ram[AR]<=DR;
						if(DR==0)
						begin
							PC<=PC+1;
							SC<=0;
						end
					end
			end
		end
		
		else if(((D!=3'b111)&(Indirect==1)))	//memory reg operations with indirect.
			begin
				AR<=mem_ram[AR];
				SC<=SC+1;
				 if((D==3'b000))  //AND operation
					begin
						if(SC==4)
							begin
								DR<=mem_ram[AR];
								SC<=SC+1;
							end
						else if(SC==5)
							begin
								AC<=AC&DR;
								SC<=0;
							end
					end
				else if((D==3'b001))	 //ADD
					begin
						if(SC==4)
							begin
							DR<=mem_ram[AR];
							SC<=SC+1;
							end
						else if (SC==5)
							begin
							{E,AC[15:0]}<= AC+DR;
							SC<=0;
							end				
					end
				
				else if((D==3'b010))	//LOAD,LDR
					begin
						if(SC==4)
							begin
								DR<=mem_ram[AR];
								SC<=SC+1;
							end
						else if (SC==5)
							begin
								AC<=DR;
								SC<=0;
							end
					end

				else if((D==3'b011))	//store, STR
					begin
						if(SC==4)
							begin
								mem_ram[AR]<=AC[15:0];
								SC<=0;
							end
					end
				
				else if((D==3'b100))	//Branch unconditionally
					begin
						if(SC==5)
							begin
							PC<=PC+1;
							end
					end
				else if((D==3'b101))	//Branch and save return address
					begin
						if(SC==4)
							begin
							mem_ram[AR]<=PC;
							AR<=AR+1;
							SC<=SC+1;
							end
						else if (SC==5)
							begin
							PC<=AR;
							SC<=0;
							end
					end
				else if((D==3'b110))		//ISZ
					begin
						if(SC==4)
							begin
								DR<=mem_ram[AR];
								SC<=SC+1;
							end
						else if(SC==5)
							begin
								DR<=DR+1;
								SC<=SC+1;
							end
						else if(SC==6)
							begin
							mem_ram[AR]<=DR;
								if(DR==0)
								begin
									PC<=PC+1;
									SC<=0;
								end
							end
					end
			end
		end
		
endmodule
