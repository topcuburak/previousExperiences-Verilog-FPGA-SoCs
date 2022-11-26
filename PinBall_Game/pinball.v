module screen(
	 input clk,
    output vga_h_sync,
    output vga_v_sync,
    output reg inDisplayArea,
    output reg [9:0] CounterX,
	 output reg [9:0] CounterY,
	 output reg [7:0] Red,
	 output reg [7:0] Blue,
	 output reg [7:0] Green,
	 output reg clk_en,
	 output reg [9:0] X_top_merkez,
	 output reg [9:0] Y_top_merkez,
	 output reg [30:0] counterball,
	 output reg [30:0] counterssd,
	 //output reg [5:0] X_v,
	 //output wire Y_v,
	 input startbutton, start_sagkol, start_solkol,
	 output reg [5:0] doga_sag,
	 output reg [5:0] doga_sol
	 
  );
    
	 //horizontal and vertical synch generator
																									
	 reg vga_HorizontalSynch, vga_VerticalSynch,border,border2,
		  engel_1,engel_1_1,engel_1_2,engel_1_3,engel_1_4,
		  engel_2,engel_2_1,engel_2_2,engel_2_3,engel_2_4,
		  engel_3,engel_4,engel_5,engel_6,
		  sag_kol_alt,ssd11,ssd12,ssd13,ssd14,ssd15,ssd16,ssd17,
		  sag_kol_ust,ssd21,ssd22,ssd23,ssd24,ssd25,ssd26,ssd27,
		  sol_kol_alt,ssd31,ssd32,ssd33,ssd34,ssd35,ssd36,ssd37,
		  sol_kol_ust,
		  bosluk_1,
		  bosluk_2,
		  top,
		  plunger,
		  clock_sayaci
		  
		  ;
	 
	 integer X_v,Y_v;
    wire CounterXmaxed = (CounterX == 799); // 16 + 48 + 96 + 640
    wire CounterYmaxed = (CounterY == 524); // 10 + 2 + 33 + 480
	 
	 
	 initial 
	 begin 
	  X_top_merkez<=180;
	  Y_top_merkez<=242;
	  counterball <= 0;
	  X_v = 5; 
	  Y_v = -1;
	  doga_sag <= 1;
	  doga_sol <=1; 
	  end
 
	 //Clock divider
	 always @(posedge clk) begin
		clk_en <= !clk_en;
	 end
	 
	 //For horizonatal and vertical synchs, counter incrementer
	 always @(posedge clk_en)
		 begin
		if (CounterXmaxed)
			CounterX <= 0;
		 else
			CounterX <= CounterX + 1;
	 end
	 
    always @(posedge clk_en)
    begin
			if ((CounterY==1)&&(CounterX==799)) 
				begin
					vga_VerticalSynch <= (CounterY < (524))&&( CounterY ==(1));
					CounterY <= CounterY + 1;
				end  
	 
		   else if (CounterXmaxed)		  
				begin
					if (CounterYmaxed)
					CounterY <=0;
					else 
					CounterY <= CounterY + 1;
					
			end
			else 
				begin
					vga_VerticalSynch <= ((CounterY < (524))&&( CounterY >(1)));  
				end
				vga_HorizontalSynch <= ((CounterX > (94))&& CounterX < (799));   // active for 96 clocks
    end
    always @(posedge clk)											
    begin
		  counterball <= counterball + 1'b1; 
		  counterssd <= counterssd + 1'b1;
        inDisplayArea <= (CounterX < (784) && CounterX > (143) ) && (CounterY < (515)&& CounterY > (34));
		  
		  //ilk altýgen
		  engel_1<= ((CounterX>200)&&(CounterX<=(200+26))&&((CounterY>100)&&(CounterY<=(100+26))));
		  engel_1_1<= ((CounterX>200)&&(CounterX<=(200+13))&&((CounterY>(87))&&(CounterY<=(100)))&&(CounterY>-CounterX+300));
		  engel_1_2<= (((CounterX<=226)&&(CounterX>(200+13))&&(CounterY>(87))&&(CounterY<=(100))&&(CounterY>CounterX-126)));
		  engel_1_3<= ((CounterX>200)&&(CounterX<=(200+13))&&((CounterY>(126))&&(CounterY<=(100+26+13)))&&(CounterY<CounterX-74));
		  engel_1_4<= ((CounterX<=226)&&(CounterX>(200+13))&&((CounterY>(126))&&(CounterY<=(100+26+13)))&&(CounterY<-CounterX+352));
		
		// ikinci altýgen
		  engel_2<= ((CounterX-300>200)&&(CounterX-300<=(200+26))&&((CounterY>100)&&(CounterY<=(100+26))));
		  engel_2_1<= ((CounterX-300>200)&&(CounterX-300<=(200+13))&&((CounterY>(87))&&(CounterY<=(100)))&&(CounterY>-CounterX+300+300));
		  engel_2_2<= (((CounterX-300<=226)&&(CounterX-300>(200+13))&&(CounterY>(87))&&(CounterY<=(100))&&(CounterY>CounterX-126-300)));
		  engel_2_3<= ((CounterX-300>200)&&(CounterX-300<=(200+13))&&((CounterY>(126))&&(CounterY<=(100+26+13)))&&(CounterY<CounterX-74-300));
		  engel_2_4<= ((CounterX-300<=226)&&(CounterX-300>(200+13))&&((CounterY>(126))&&(CounterY<=(100+26+13)))&&(CounterY<-CounterX+352+300));
		  
		 //Yuvarlaklar
		  engel_3<= ((((CounterX-283)*(CounterX-283))+((CounterY-183)*(CounterY-183)))<=20*20); 
		  engel_4<= ((((CounterX-450)*(CounterX-450))+((CounterY-250)*(CounterY-250)))<=20*20);
		  engel_5<= ((((CounterX-550)*(CounterX-550))+((CounterY-328)*(CounterY-328)))<=20*20);
		  engel_6<= ((((CounterX-380)*(CounterX-380))+((CounterY-350)*(CounterY-350)))<=20*20);	  
	     border <=((CounterX>=143)&&(CounterX<=(16+143))&&(CounterY<=450))
					  ||((CounterX>(783-16))&&(CounterX<783))||((CounterY>=35)&&(CounterY<(35+9)));
		  border2 <=(((CounterX>=674-30)&&(CounterX<=670-14))&&((CounterY<=450)&&(CounterY>=35)));
		 
		  bosluk_1<= ((CounterX>=670&&CounterX<=676)&&(CounterY>=130&&CounterY<=210))||
						 ((CounterX>=744&&CounterX<=750)&&(CounterY>=130&&CounterY<=210))||
						 ((CounterX>=670&&CounterX<=750)&&(CounterY>=130&&CounterY<=136))||
		             ((CounterX>=670&&CounterX<=750)&&(CounterY>=210-6&&CounterY<=210));
		  
		  ssd11<= ((CounterX>=721&&CounterX<725)&&(CounterY>=137&&CounterY<=137+30));
		  ssd12<= ((CounterX>=725&&CounterX<=737)&&(CounterY>=137&&CounterY<=137+13));
		  ssd13<= ((CounterX>738&&CounterX<=742)&&(CounterY>=137&&CounterY<=137+30));
		  ssd14<= ((CounterX>=725&&CounterX<=737)&&(CounterY>=208&&CounterY<=221));
		  ssd15<= ((CounterX>=721&&CounterX<725)&&(CounterY>=208&&CounterY<=208+30));
		  ssd16<= ((CounterX>738&&CounterX<=742)&&(CounterY>=208+30&&CounterY<=221+30));
		  ssd17<= ((CounterX>=725&&CounterX<=690)&&(CounterY>=239&&CounterY<=239+13));
		  
		 /* sdd11<=ssd2||ssd3||ssd4||ssd5||ssd7
		  sdd12<=
		  sdd13<=
		  sdd14<=
		  sdd15<=
		  sdd16<=
		  sdd17<=*/
		  
		  
		  
		  bosluk_2<= ((CounterX>=670&&CounterX<=676)&&(CounterY>=130+150&&CounterY<=210+150))||
						 ((CounterX>=744&&CounterX<=750)&&(CounterY>=130+150&&CounterY<=210+150))||
						 ((CounterX>=670&&CounterX<=750)&&(CounterY>=130+150&&CounterY<=136+150))||
		             ((CounterX>=670&&CounterX<=750)&&(CounterY>=210-6+150&&CounterY<=210+150));			 
		  
		  sol_kol_ust<= ((((CounterY-400)*220)>=((CounterX-(144+16))*(90)))
							 &&(((CounterY-405)*220)<=((CounterX-(144+16))*(90)))
							 &&(CounterX<=160+220-60));
		  sag_kol_ust<= ((((CounterY-400)*220)>=((CounterX-644)*(-90)))
							 &&(((CounterY-405)*220)<=((CounterX-644)*(-90)))
							 &&(CounterX<644)&&(CounterX>=644-220+60));
		  sol_kol_alt<= ((((CounterY-466)*220)>=((CounterX-(342))*(90-doga_sol)))
							 &&(((CounterY-471)*220)<=((CounterX-(342))*(90-doga_sol)))
							 &&(CounterX>=160+220-60)&&(CounterX<=160+220));
		  sag_kol_alt<= ((((CounterY-466)*220)>=((CounterX-462)*(-90+doga_sag)))
							 &&(((CounterY-471)*220)<=((CounterX-462)*(-90+doga_sag)))
							 &&(CounterX<644-220+60)&&(CounterX>=644-220));
		  
		   
		  plunger<= (((CounterX<=(143+30))&&(CounterX>143+16))&&(CounterY>=237-2&&CounterY<247+2));
		  top<= ((((CounterX-X_top_merkez)*(CounterX-X_top_merkez))+((CounterY-Y_top_merkez)*(CounterY-Y_top_merkez)))<=7*7); 

		   // tam orta noktada x=402, y=499
			// sol ve saðdaki fark x 60 olsun, y farký  25 
			// sað alt için baþlangýç noktasý, x=462, y=474
			// sol alt için baþlangýç noktasý, x=342, y=474
		  	
			// Topun Hareketi Burada
						if (counterball==500000) begin  //500000
									counterball <= 0;
										if (startbutton == 1)
											begin 
												  X_top_merkez <= X_top_merkez + X_v;
												  Y_top_merkez <= Y_top_merkez + Y_v;
														if (start_sagkol==0)
														doga_sag<=doga_sag + 1'b1;
													else if (start_solkol==0)
														doga_sol<=doga_sol + 1'b1;
											end								
										end
			//else if (counterssd==49000000) begin
						//counterssd<=0;
				/*		if (counterball==50000000) begin
						else if(ssd3) //1
						begin
						Green <=8'b11111111;
						Red <=8'b11111111;
						Blue <=8'b00000000;
						end
						else if(ssd2||ssd3||ssd4||ssd5||ssd7) //2 
						begin
						Green <=8'b11111111;
						Red <=8'b11111111;
						Blue <=8'b00000000;
						end
						else if(ssd2||ssd3||ssd4||ssd6||ssd7) //3
						begin
						Green <=8'b11111111;
						Red <=8'b11111111;
						Blue <=8'b00000000;
						end
						else if(ssd1||ssd5||ssd7||ssd6) //4
						begin
						Green <=8'b11111111;
						Red <=8'b11111111;
						Blue <=8'b00000000;
						end
						if(ssd2||ssd1||ssd4||ssd6||ssd7) //5
						begin
						Green <=8'b11111111;
						Red <=8'b11111111;
						Blue <=8'b00000000;
						end
						if(ssd1||ssd2||ssd4||ssd5||ssd7||ssd6) //6
						begin
						Green <=8'b11111111;
						Red <=8'b11111111;
						Blue <=8'b00000000;
						end
						if(ssd2&&ssd3&&ssd4&&ssd6) //7
						begin
						Green <=8'b11111111;
						Red <=8'b11111111;
						Blue <=8'b00000000;
						end
						if(ssd1&&ssd2&&ssd3&&ssd4&&ssd5&&ssd6&&ssd7) //8
						begin
						Green <=8'b11111111;
						Red <=8'b11111111;
						Blue <=8'b00000000;
						end
						if(ssd2ssd3&&ssd4&&ssd6&&ssd1)
						begin
						Green <=8'b11111111;
						Red <=8'b11111111;
						Blue <=8'b00000000;
						end
					end*/
		   else  if (inDisplayArea) 
				begin
					if (border)
						begin 
							Green <=8'b11111111;
							Red <=8'b11111111;
							Blue <=8'b00000000;
							
						end
					    // ilk üçgen
					else if (border2)
						begin 
							Green <=8'b11111111;
							Red <=8'b11111111;
							Blue <=8'b00000000;
							
						end	 
					
					else if(top) // Topun yeri		
					
							begin
											Green <=8'b11111111;
											Red <=8'b00000000;
											Blue <=8'b11111111;
									if((startbutton==1)&&(X_top_merkez<=160+8))
											begin
											X_v = 5;
									      end
									else if((X_top_merkez>=644-8)&&(startbutton==1))
											begin
											X_v = -5;
											end
									else if ((Y_top_merkez<=52)&&(startbutton==1))
											 begin
											 Y_v = 1;
											end
									else if((((X_top_merkez-283)*(X_top_merkez-283))+((Y_top_merkez-183)*(Y_top_merkez-183)))<=27*27)
										begin
											if(X_top_merkez-110<=Y_top_merkez)
											Y_v = -5;
											else if (X_top_merkez-110>Y_top_merkez)
											X_v = -8;
										end
									else if ((((X_top_merkez-550)*(X_top_merkez-550))+((Y_top_merkez-328)*(Y_top_merkez-328)))<=27*27)
										begin
											Y_v = -4;
											X_v = -5;
										end
							
									else if ((((X_top_merkez-380)*(X_top_merkez-380))+((Y_top_merkez-350)*(Y_top_merkez-350)))<=27*27)
										begin
											Y_v <= -6;
											X_v<= -3;
										end 
									else if ((((X_top_merkez-450)*(X_top_merkez-450))+((Y_top_merkez-250)*(Y_top_merkez-250)))<=27*27)
										begin
											Y_v <= -5;
											X_v <= -5;
										end
									
									/*else if((((Y_top_merkez-400)*220)>=((X_top_merkez-(144+16))*(90)))&&(startbutton==1))  // sol engel
											begin
											X_v <= 5;
											Y_v <= -3;
											end
									else if((((Y_top_merkez-400)*220)>=((X_top_merkez-644)*(-90)))&&(startbutton==1)) // sað engel
											begin
											X_v <= -X_v;
											Y_v <= -Y_v;
											end*/
							end	
							
					
					else if (engel_1)	
							begin
									Red <=8'b00000000;
									Blue<= 8'b11111111;
									Green<= 8'b00000000;
							end
							
					 else if(engel_1_1) //üst üçgen	
							begin
								
									Red <=8'b00000000;
									Blue<= 8'b11111111;
									Green<= 8'b00000000;
								end	
					
					else if(engel_1_2) //üst üçgen	
						   begin
						 	
									Red <=8'b00000000;
									Blue<= 8'b11111111;
									Green<= 8'b00000000;
							 end
				   
					else if(engel_1_3) //üst üçgen
						   begin
						 	
									Red <=8'b00000000;
									Blue<= 8'b11111111;
									Green<= 8'b00000000;
							 end
					
					else if(engel_1_4) //üst üçgen
						   begin
						 	
									Red <=8'b00000000;
									Blue<= 8'b11111111;
									Green<= 8'b00000000;
							 end
					
					//ikinci üçgen
					else if (engel_2)	
							begin
									Red <=8'b00000000;
									Blue<= 8'b11111111;
									Green<= 8'b00000000;
							end
							
					 else if(engel_2_1) 
							begin
								
									Red <=8'b00000000;
									Blue<= 8'b11111111;
									Green<= 8'b00000000;
								end
								
					else if(engel_2_2)
						   begin
									Red <=8'b00000000;
									Blue<= 8'b11111111;
									Green<= 8'b00000000;
							 end
				  
				  else if(engel_2_3) //üst üçgen
						   begin
									Red <=8'b00000000;
									Blue<= 8'b11111111;
									Green<= 8'b00000000;
							 end
					
					else if(engel_2_4) 
						   begin
									Red <=8'b00000000;
									Blue<= 8'b11111111;
									Green<= 8'b00000000;
							 end
					
					else if(engel_3) // daire 1 M=> y=183-x=283
						   begin
									Red <=8'b00000000;
									Blue<= 8'b00000000;
									Green<= 8'b11111111;
							 end		 
			
					else if(engel_4) // daire 1 M=> y=80-x=310		
							begin
									Red <=8'b00000000;
									Blue<= 8'b00000000;
									Green<= 8'b11111111;
						    end			
					
					else if(engel_5) // daire 1 M=> y=80-x=310		
							begin
									Red <=8'b11111111;
									Blue<= 8'b00000000;
									Green<= 8'b00000000;
							 end			
					
					else if(engel_6) // daire 1 M=> y=190-x=450	
							begin
									Red <=8'b11111111;
									Blue<= 8'b00000000;
									Green<= 8'b00000000;
							 end		
									 
					else if(sag_kol_alt) // sað altta vuracak olan kol			
									begin
											Green <=8'b11111111;
											Red <=8'b11111111;
											Blue <=8'b00000000;
									 end	
					else if(sag_kol_ust) // sað altta vuracak olan kol			
									begin
											Green <=8'b11111111;
											Red <=8'b11111111;
											Blue <=8'b00000000;
									 end							 	
					else if(sol_kol_alt) // sol altta vuracak olan kol			
									begin
											Green <=8'b11111111;
											Red <=8'b11111111;
											Blue <=8'b00000000;
									 end
					else if(sol_kol_ust) // sol altta vuracak olan kol			
									begin
											Green <=8'b11111111;
											Red <=8'b11111111;
											Blue <=8'b00000000;
									 end
					else if(bosluk_1) // sað üst, skor tutacaðýmýz boþluk			
									begin
											Green <=8'b00000000;
											Red <=8'b00000000;
											Blue <=8'b11111111;
									 end
				   else if(bosluk_2) // sað orta, zaman tutacaðýmýz boþluk		
									begin
											Green <=8'b00000000;
											Red <=8'b00000000;
											Blue <=8'b11111111;
									 end
					else if(plunger) // Plunger'ýn yeri		
									begin
											Green <=8'b11111111;
											Red <=8'b00000000;
											Blue <=8'b11111111;
									 end
					
					//else if(CounterYmaxed)
						//	if(top birþeye çarpyorsa)
							//else if (counter)
					else 
							begin
								Red<= 8'b00000000;
								Blue<= 8'b00000000;
								Green<= 8'b00000000;
							end
					end
					
		  end


    assign vga_h_sync = ~vga_HorizontalSynch; //(CounterX>95) ? 1'b1:1'b0; 
    assign vga_v_sync = ~vga_VerticalSynch;   //(CounterY>1) ? 1'b1:1'b0;

			
endmodule

				// sag_kol<= ((((CounterY-451)*220)>=((CounterX-650)*(-60+doga)))&&(((CounterY-455)*220)<=((CounterX-650)*(-60+doga)))&&(CounterX<=649)&&(CounterX>=549));
				// sol_kol<= ((((CounterY-451)*220)>=((CounterX-144)*(60)))&&(((CounterY-455)*220)<=((CounterX-144)*(60)))&&(CounterX>144+17));
		
		
		 /*(((CounterY-443)(220))>=((CounterX-624)*(-60))) // L 1 line
						&&(((CounterY-453)(220))<=((CounterX-630)(-60))) // L 4 line
						&&((CounterY-463)60)<=((220)(CounterX-614))  // L 2 line
						&&((CounterY-453)60)>=((220)(CounterX-630))); // L 3 
		  //top<=((((CounterX-380)(CounterX-380))+((CounterY-350)(CounterY-350)))<=14*14);*/
