module UVA_RECEIVE
#(
	parameter MAC_ADR_POL = 96'hFFFFFFFFFFFF, //6 byte or 96'h030000000001 check in PC ??? 96
	parameter MAC_ADR_OTP = 0, //6 byte
	parameter MAC_TIP_FRAME = 16'h800 //2 byte 
)
(
	input	clk_100Mz,
	input	clk_1Mz,
	input	clk_25Mz,
	
	input	[3: 0] 	data_in,
	input			CRS,
	//input			start_work,
	input			RX_DV,
	input	[31: 0] buff_data_crc_in,
	input			RX_ER,
	output	reg [2: 0] 	state_in,
	
	output	reg [63: 0] buff_data_0 = 64'hFFFFFFFFFFFFFFFF,
	output  reg [63: 0] buff_data_1,
	output  reg [63: 0] buff_data_2,
	output  reg [63: 0] buff_data_3,
	output  reg [63: 0] buff_data_4,
	output  reg [63: 0] buff_data_5,
	output  reg [63: 0] buff_data_6,
	output  reg [63: 0] buff_data_7 = 64'hFFFFFFFFFFFFFFFF,
	
	output	logic	check_CRC32
	
	
);
/*
initial
begin
buff_data_0 [38] = 1'b1;
buff_data_0 [44] = 1'b1;

end*/

localparam PREAMBULA = 4'b0101;
localparam PREAMBULA_END = 4'b0111;
//assign j [3: 0] = i [3: 0];

wire [3: 0] _data_in;

sinhr_input_data sinhr_input_data (
	.clk_100Mz(clk_100Mz),
	.clk_1Mz(clk_1Mz),
	.clk_25Mz(clk_25Mz),
	
	.data_in(data_in),
	.CRS(CRS),
	.RX_DV(RX_DV),
	.state_in(state_in),
	
	.data_sinhr_out(_data_in)

);






//assign _data_in [3: 0] = data_in [3: 0];

logic flag_er_MAC = 0;

logic [7: 0] buff_receive = 0;
//logic [2: 0] state;

logic [3: 0] 	buff_MAC_Addr_0 = 0;
logic [3: 0] 	buff_MAC_Addr_1 = 0;
logic [3: 0] 	buff_MAC_Addr_2 = 0;
logic [3: 0] 	buff_MAC_Addr_3 = 0;
logic [3: 0] 	buff_MAC_Addr_4 = 0;
logic [3: 0] 	buff_MAC_Addr_5 = 0;
logic [3: 0]	buff_MAC_Addr_6 = 0;
logic [3: 0]	buff_MAC_Addr_7 = 0;
logic [3: 0]	buff_MAC_Addr_8 = 0;
logic [3: 0]	buff_MAC_Addr_9 = 0;
logic [3: 0]	buff_MAC_Addr_10 = 0;
logic [3: 0]	buff_MAC_Addr_11 = 0;
logic [3: 0]	buff_MAC_Addr_12 = 0;
logic [3: 0]	buff_MAC_Addr_13 = 0;
logic [3: 0]	buff_MAC_Addr_14 = 0;
logic [3: 0]	buff_MAC_Addr_15 = 0;

logic flag_preambul = 0;

logic		 i = 0;
logic 		 i_2 = 0;
logic [1: 0] i_4 = 0; 
logic [2: 0] i_8 = 0; 
logic [3: 0] i_16 = 0;
logic [4: 0] i_32 = 0;
//logic [5: 0] i_64 = 0;
logic [2: 0] step = 0;

logic [3: 0] cnt_preambul = 0;
logic [3: 0] cnt_check_preambul = 0;
//logic [4: 0] cnt_check_adr_pol = 0;
logic [4: 0] cnt_check_adr_otp = 0;
//logic [2: 0] cnt_check_adr_pol = 0;


logic [31: 0] buff_data_crc32 = 0;
logic flag_full_read = 0;
//logic check_CRC32 <= 0;

logic buff_CRC = 0;

logic [7: 0] cnt_error_data;
logic [1: 0] param_sdvig_in_data;

initial
buff_data_7 [63: 0]  =  64'hFFFFFFFFFFFFFFFF;

//module for receive
always @(posedge clk_25Mz) //posedge
begin
	case (state_in)
		0:	begin
				if ((CRS == 1) && (RX_DV == 1)) //mb 1 i don't know, if CRS != RX_DV, it's not fact
				begin
					state_in <= state_in + 1;
					step <= 0;
				end	
					
				if (buff_data_crc_in [31: 0] == buff_data_crc32 [31: 0])
					check_CRC32 <= 1;
				else
					check_CRC32 <= 0;
					
			end
		
		1:	begin
				if ((_data_in == PREAMBULA) && ((cnt_check_preambul != cnt_preambul) || (cnt_preambul == 0)))
				begin
					cnt_preambul <= cnt_preambul + 1;
					cnt_check_preambul <= cnt_preambul;
				end else begin
					//cnt_check_preambul <= 0;
					cnt_preambul <= 0;
					
				end
				
				if ((_data_in == PREAMBULA_END) & (cnt_preambul == 15))
					begin
						flag_preambul <= 1;
						//cnt_preambul <= cnt_preambul + 1;
						state_in <= state_in + 1;
						
					end	
					
			end
			
		2:	begin
				cnt_preambul <= 0; //reg [23: 0] bla_bla <= data_in [3: 0]
				//if  (bla_bla [23: 0] == MAC_ADR_POL [23: 0]
				//	state_in <= state_in + 1; 
				
				
				case (i_8)
					0: 	begin
							buff_MAC_Addr_5 [3: 0] <= _data_in [3: 0];					
					
						end
						
					1:	begin
                        	buff_MAC_Addr_4 [3: 0] <= _data_in [3: 0];
                        
                        end
					
					2:	begin
                        	buff_MAC_Addr_3 [3: 0] <= _data_in [3: 0];
                        
                        end
						
					3:	begin	
							buff_MAC_Addr_2 [3: 0] <= _data_in [3: 0];
						
						end
						
					4:	begin	
							buff_MAC_Addr_1 [3: 0] <= _data_in [3: 0];
						
						end
						
					5:	begin	
							buff_MAC_Addr_0 [3: 0] <= _data_in [3: 0];
						
						end
				
				endcase				
					
				if ({buff_MAC_Addr_5 [3: 0], buff_MAC_Addr_4 [3: 0], buff_MAC_Addr_3 [3: 0], buff_MAC_Addr_2 [3: 0], buff_MAC_Addr_1 [3: 0], data_in [3: 0]} == MAC_ADR_POL [23: 0]) //buff_MAC_Addr_0 [3: 0]
					begin
						state_in <= state_in + 1;
						buff_MAC_Addr_5 [3: 0] <= 0;
						buff_MAC_Addr_4 [3: 0] <= 0;
						buff_MAC_Addr_3 [3: 0] <= 0;
						buff_MAC_Addr_2 [3: 0] <= 0;
						buff_MAC_Addr_1 [3: 0] <= 0;
						buff_MAC_Addr_0 [3: 0] <= 0;
						i_8 <= 0;
						
					end else
						i_8 <= i_8 + 1;	
						
				if (i_8 > 6)
					flag_er_MAC <= 1;
				else
					flag_er_MAC <= 0;	
					
		/*
				if (data_in [3: 0] == MAC_ADR_POL [(23 - (4 * (i_2 + i + i_4))): (23 - ((4 * (i_2 + i_4 + 1 + i)) - 1))]) //if (data_in [3: 0] == MAC_ADR_POL [(23 - (4 * j)): (23 - ((4 * (j + 1)) - 1))])
					begin
						if (i_4 == 3)
							i_4 <= i_4 + 1;
						else
							if (i_2 == 1)
								i_2 <= i_2 + 1;
							else
								i <= i + 1;
							
						
					end	
					
				if ((i_2 == 1) & (i_4 == 3) & (i == 1))
					begin
						state_in <= state_in + 1;
						i_2 <= 0;
						i_4 <= 0;
						i <= 0;
						
					end	*/

			end
			
		3:	begin
				case (i_8)
					0: 	begin
							buff_MAC_Addr_5 [3: 0] <= _data_in [3: 0];					
					
						end
						
					1:	begin
                        	buff_MAC_Addr_4 [3: 0] <= _data_in [3: 0];
                        
                        end
					
					2:	begin
                        	buff_MAC_Addr_3 [3: 0] <= _data_in [3: 0];
                        
                        end
						
					3:	begin	
							buff_MAC_Addr_2 [3: 0] <= _data_in [3: 0];
						
						end
						
					4:	begin	
							buff_MAC_Addr_1 [3: 0] <= _data_in [3: 0];
						
						end
						
					5:	begin	
							buff_MAC_Addr_0 [3: 0] <= _data_in [3: 0];
						
						end
				
				endcase				
					
				if ({buff_MAC_Addr_5 [3: 0], buff_MAC_Addr_4 [3: 0], buff_MAC_Addr_3 [3: 0], buff_MAC_Addr_2 [3: 0], buff_MAC_Addr_1 [3: 0], data_in [3: 0]} == MAC_ADR_OTP [23: 0]) //buff_MAC_Addr_0 [3: 0]
					begin
						state_in <= state_in + 1;
						buff_MAC_Addr_5 [3: 0] <= 0;
						buff_MAC_Addr_4 [3: 0] <= 0;
						buff_MAC_Addr_3 [3: 0] <= 0;
						buff_MAC_Addr_2 [3: 0] <= 0;
						buff_MAC_Addr_1 [3: 0] <= 0;
						buff_MAC_Addr_0 [3: 0] <= 0;
						i_8 <= 0;
						
					end else
						i_8 <= i_8 + 1;	
		
				if (i_8 > 6)
					flag_er_MAC <= 1;
				else
					flag_er_MAC <= 0;
			
		/*
				if (data_in [3: 0] == MAC_ADR_OTP [(23 - (4 * (i_8 + i_4))): (23 - ((4 * (i_8 + i_4 + 1)) - 1))])
					begin
						if (i_8 == 7)
							i_4 <= i_4 + 1;
						else
							i_8 <= i_8 + 1;
						
					end	
					
				if ((i_8 == 7) & (i_4 == 3))
					begin
						state_in <= state_in + 1;
						i_8 <= 0;
						i_4 <= 0;
						
					end	*/
		
			end

		4:	begin
				case (i_4)
					0: 	begin
							buff_MAC_Addr_5 [3: 0] <= _data_in [3: 0];					
					
						end
						
					1:	begin
                        	buff_MAC_Addr_4 [3: 0] <= _data_in [3: 0];
                        
                        end
					
					2:	begin
                        	buff_MAC_Addr_3 [3: 0] <= _data_in [3: 0];
                        
                        end
						
					3:	begin	
							buff_MAC_Addr_2 [3: 0] <= _data_in [3: 0];
						
						end
						
				endcase		

				if ({buff_MAC_Addr_5 [3: 0], buff_MAC_Addr_4 [3: 0], buff_MAC_Addr_3 [3: 0], _data_in [3: 0]} == MAC_TIP_FRAME [15: 0]) //buff_MAC_Addr_2 [3: 0]
					begin
						state_in <= state_in + 1;
						buff_MAC_Addr_5 [3: 0] <= 0;
						buff_MAC_Addr_4 [3: 0] <= 0;
						buff_MAC_Addr_3 [3: 0] <= 0;
						buff_MAC_Addr_2 [3: 0] <= 0;
						i_4 <= 0;
						
					end else
						i_4 <= i_4 + 1;	
		/*
				if (i_4 > 6)
					flag_er_MAC <= 1;
				else
					flag_er_MAC <= 0;	*/
					
				/*	
						
				if (data_in [3: 0] == MAC_TIP_FRAME [(15 - (4 * (i_4))): (15 - ((4 * (i_4 + 1)) - 1))])
					begin
						if (i_4 == 3)
							i_4 <= i_4 + 1;
						
					end	
					
				if (i_4 == 3)
					begin
						state_in <= state_in + 1;
						//i_8 <= 0;
						i_4 <= 0;
						
					end	*/
		
			end

		5:	begin
				case (step)
					0:	begin
							case (i_16)
								0: 	begin
										buff_MAC_Addr_15 [3: 0] <= _data_in [3: 0];					
								
									end
									
								1:	begin
										buff_MAC_Addr_14 [3: 0] <= _data_in [3: 0];
									
									end
								
								2:	begin
										buff_MAC_Addr_13 [3: 0] <= _data_in [3: 0];
									
									end
									
								3:	begin	
										buff_MAC_Addr_12 [3: 0] <= _data_in [3: 0];
									
									end
								
								4: 	begin
										buff_MAC_Addr_11 [3: 0] <= _data_in [3: 0];					
								
									end
									
								5:	begin
										buff_MAC_Addr_10 [3: 0] <= _data_in [3: 0];
									
									end
								
								6:	begin
										buff_MAC_Addr_9 [3: 0] <= _data_in [3: 0];
									
									end
									
								7:	begin	
										buff_MAC_Addr_8 [3: 0] <= _data_in [3: 0];
									
									end
									
								8: 	begin
										buff_MAC_Addr_7 [3: 0] <= _data_in [3: 0];					
								
									end
									
								9:	begin
										buff_MAC_Addr_6 [3: 0] <= _data_in [3: 0];
									
									end
								
								10:	begin
										buff_MAC_Addr_5 [3: 0] <= _data_in [3: 0];
									
									end
									
								11:	begin	
										buff_MAC_Addr_4 [3: 0] <= _data_in [3: 0];
									
									end

								12:	begin
										buff_MAC_Addr_3 [3: 0] <= _data_in [3: 0];					
								
									end
									
								13:	begin
										buff_MAC_Addr_2 [3: 0] <= _data_in [3: 0];
									
									end
								
								14:	begin
										buff_MAC_Addr_1 [3: 0] <= _data_in [3: 0];
									
									end
									
								15:	begin	
										buff_MAC_Addr_0 [3: 0] <= _data_in [3: 0];
									
									end		
						
				endcase	
					
				if (i_16 == 15)
					begin
						step <= step + 1;
						i_16 = 0;
						buff_data_0 [63: 0] <= {buff_MAC_Addr_15 [3: 0], buff_MAC_Addr_14 [3: 0], buff_MAC_Addr_13 [3: 0], buff_MAC_Addr_12 [3: 0], buff_MAC_Addr_11 [3: 0], buff_MAC_Addr_10 [3: 0], buff_MAC_Addr_9 [3: 0], buff_MAC_Addr_8 [3: 0], buff_MAC_Addr_7 [3: 0], buff_MAC_Addr_6 [3: 0], buff_MAC_Addr_5 [3: 0], buff_MAC_Addr_4 [3: 0], buff_MAC_Addr_3 [3: 0], buff_MAC_Addr_2 [3: 0], buff_MAC_Addr_1 [3: 0], data_in [3: 0]}; //buff_MAC_Addr_0 [3: 0]
					
					end else
						i_16 <= i_16 + 1;	

					/*
							buff_data_0 [63 - (4 * i_16): 63 - ((4 * (i_16 + 1)) - 1)] <= data_in [3: 0]; //buff_data_0 [63 - (4 * j): 63 - ((4 * (j + 1)) - 1)] <= data_in [3: 0];
							i_16 <= i_16 + 1;
							
							if (i_16 == 15)
								begin
									step <= step + 1;
									i_16 = 0;
								
								end
					*/
						end
						
					1:	begin
							case (i_16)
								0: 	begin
										buff_MAC_Addr_15 [3: 0] <= _data_in [3: 0];					
								
									end
									
								1:	begin
										buff_MAC_Addr_14 [3: 0] <= _data_in [3: 0];
									
									end
								
								2:	begin
										buff_MAC_Addr_13 [3: 0] <= _data_in [3: 0];
									
									end
									
								3:	begin	
										buff_MAC_Addr_12 [3: 0] <= _data_in [3: 0];
									
									end
								
								4: 	begin
										buff_MAC_Addr_11 [3: 0] <= _data_in [3: 0];					
								
									end
									
								5:	begin
										buff_MAC_Addr_10 [3: 0] <= _data_in [3: 0];
									
									end
								
								6:	begin
										buff_MAC_Addr_9 [3: 0] <= _data_in [3: 0];
									
									end
									
								7:	begin	
										buff_MAC_Addr_8 [3: 0] <= _data_in [3: 0];
									
									end
									
								8: 	begin
										buff_MAC_Addr_7 [3: 0] <= _data_in [3: 0];					
								
									end
									
								9:	begin
										buff_MAC_Addr_6 [3: 0] <= _data_in [3: 0];
									
									end
								
								10:	begin
										buff_MAC_Addr_5 [3: 0] <= _data_in [3: 0];
									
									end
									
								11:	begin	
										buff_MAC_Addr_4 [3: 0] <= _data_in [3: 0];
									
									end

								12:	begin
										buff_MAC_Addr_3 [3: 0] <= _data_in [3: 0];					
								
									end
									
								13:	begin
										buff_MAC_Addr_2 [3: 0] <= _data_in [3: 0];
									
									end
								
								14:	begin
										buff_MAC_Addr_1 [3: 0] <= _data_in [3: 0];
									
									end
									
								15:	begin	
										buff_MAC_Addr_0 [3: 0] <= _data_in [3: 0];
									
									end		
						
				endcase	
					
				if (i_16 == 15)
					begin
						step <= step + 1;
						i_16 = 0;
						buff_data_1 [63: 0] <= {buff_MAC_Addr_15 [3: 0], buff_MAC_Addr_14 [3: 0], buff_MAC_Addr_13 [3: 0], buff_MAC_Addr_12 [3: 0], buff_MAC_Addr_11 [3: 0], buff_MAC_Addr_10 [3: 0], buff_MAC_Addr_9 [3: 0], buff_MAC_Addr_8 [3: 0], buff_MAC_Addr_7 [3: 0], buff_MAC_Addr_6 [3: 0], buff_MAC_Addr_5 [3: 0], buff_MAC_Addr_4 [3: 0], buff_MAC_Addr_3 [3: 0], buff_MAC_Addr_2 [3: 0], buff_MAC_Addr_1 [3: 0], _data_in [3: 0]}; //buff_MAC_Addr_0 [3: 0]
					
					end else
						i_16 <= i_16 + 1;	

					/*
							buff_data_1 [63 - (4 * i_16): 63 - ((4 * (i_16 + 1)) - 1)] <= data_in [3: 0];
							i_16 <= i_16 + 1;
							
							if (i_16 == 15)
								begin
									step <= step + 1;
									i_16 = 0;
								
								end*/
					
						end
					
					2:	begin
							case (i_16)
								0: 	begin
										buff_MAC_Addr_15 [3: 0] <= _data_in [3: 0];					
								
									end
									
								1:	begin
										buff_MAC_Addr_14 [3: 0] <= _data_in [3: 0];
									
									end
								
								2:	begin
										buff_MAC_Addr_13 [3: 0] <= _data_in [3: 0];
									
									end
									
								3:	begin	
										buff_MAC_Addr_12 [3: 0] <= _data_in [3: 0];
									
									end
								
								4: 	begin
										buff_MAC_Addr_11 [3: 0] <= _data_in [3: 0];					
								
									end
									
								5:	begin
										buff_MAC_Addr_10 [3: 0] <= _data_in [3: 0];
									
									end
								
								6:	begin
										buff_MAC_Addr_9 [3: 0] <= _data_in [3: 0];
									
									end
									
								7:	begin	
										buff_MAC_Addr_8 [3: 0] <= _data_in [3: 0];
									
									end
									
								8: 	begin
										buff_MAC_Addr_7 [3: 0] <= _data_in [3: 0];					
								
									end
									
								9:	begin
										buff_MAC_Addr_6 [3: 0] <= _data_in [3: 0];
									
									end
								
								10:	begin
										buff_MAC_Addr_5 [3: 0] <= _data_in [3: 0];
									
									end
									
								11:	begin	
										buff_MAC_Addr_4 [3: 0] <= _data_in [3: 0];
									
									end

								12:	begin
										buff_MAC_Addr_3 [3: 0] <= _data_in [3: 0];					
								
									end
									
								13:	begin
										buff_MAC_Addr_2 [3: 0] <= _data_in [3: 0];
									
									end
								
								14:	begin
										buff_MAC_Addr_1 [3: 0] <= _data_in [3: 0];
									
									end
									
								15:	begin	
										buff_MAC_Addr_0 [3: 0] <= _data_in [3: 0];
									
									end		
						
				endcase	
					
				if (i_16 == 15)
					begin
						step <= step + 1;
						i_16 = 0;
						buff_data_2 [63: 0] <= {buff_MAC_Addr_15 [3: 0], buff_MAC_Addr_14 [3: 0], buff_MAC_Addr_13 [3: 0], buff_MAC_Addr_12 [3: 0], buff_MAC_Addr_11 [3: 0], buff_MAC_Addr_10 [3: 0], buff_MAC_Addr_9 [3: 0], buff_MAC_Addr_8 [3: 0], buff_MAC_Addr_7 [3: 0], buff_MAC_Addr_6 [3: 0], buff_MAC_Addr_5 [3: 0], buff_MAC_Addr_4 [3: 0], buff_MAC_Addr_3 [3: 0], buff_MAC_Addr_2 [3: 0], buff_MAC_Addr_1 [3: 0], _data_in [3: 0]}; //buff_MAC_Addr_0 [3: 0]
					
					end else
						i_16 <= i_16 + 1;	
					
						/*	buff_data_2 [63 - (4 * i_16): 63 - ((4 * (i_16 + 1)) - 1)] <= data_in [3: 0];
							i_16 <= i_16 + 1;
							
							if (i_16 == 15)
								begin
									step <= step + 1;
									i_16 = 0;
								
								end*/
					
						end
				
					3:	begin
							case (i_16)
								0: 	begin
										buff_MAC_Addr_15 [3: 0] <= _data_in [3: 0];					
								
									end
									
								1:	begin
										buff_MAC_Addr_14 [3: 0] <= _data_in [3: 0];
									
									end
								
								2:	begin
										buff_MAC_Addr_13 [3: 0] <= _data_in [3: 0];
									
									end
									
								3:	begin	
										buff_MAC_Addr_12 [3: 0] <= _data_in [3: 0];
									
									end
								
								4: 	begin
										buff_MAC_Addr_11 [3: 0] <= _data_in [3: 0];					
								
									end
									
								5:	begin
										buff_MAC_Addr_10 [3: 0] <= _data_in [3: 0];
									
									end
								
								6:	begin
										buff_MAC_Addr_9 [3: 0] <= _data_in [3: 0];
									
									end
									
								7:	begin	
										buff_MAC_Addr_8 [3: 0] <= _data_in [3: 0];
									
									end
									
								8: 	begin
										buff_MAC_Addr_7 [3: 0] <= _data_in [3: 0];					
								
									end
									
								9:	begin
										buff_MAC_Addr_6 [3: 0] <= _data_in [3: 0];
									
									end
								
								10:	begin
										buff_MAC_Addr_5 [3: 0] <= _data_in [3: 0];
									
									end
									
								11:	begin	
										buff_MAC_Addr_4 [3: 0] <= _data_in [3: 0];
									
									end

								12:	begin
										buff_MAC_Addr_3 [3: 0] <= _data_in [3: 0];					
								
									end
									
								13:	begin
										buff_MAC_Addr_2 [3: 0] <= _data_in [3: 0];
									
									end
								
								14:	begin
										buff_MAC_Addr_1 [3: 0] <= _data_in [3: 0];
									
									end
									
								15:	begin	
										buff_MAC_Addr_0 [3: 0] <= _data_in [3: 0];
									
									end		
						
				endcase	
					
				if (i_16 == 15)
					begin
						step <= step + 1;
						i_16 = 0;
						buff_data_3 [63: 0] <= {buff_MAC_Addr_15 [3: 0], buff_MAC_Addr_14 [3: 0], buff_MAC_Addr_13 [3: 0], buff_MAC_Addr_12 [3: 0], buff_MAC_Addr_11 [3: 0], buff_MAC_Addr_10 [3: 0], buff_MAC_Addr_9 [3: 0], buff_MAC_Addr_8 [3: 0], buff_MAC_Addr_7 [3: 0], buff_MAC_Addr_6 [3: 0], buff_MAC_Addr_5 [3: 0], buff_MAC_Addr_4 [3: 0], buff_MAC_Addr_3 [3: 0], buff_MAC_Addr_2 [3: 0], buff_MAC_Addr_1 [3: 0], _data_in [3: 0]}; //buff_MAC_Addr_0 [3: 0]
					
					end else
						i_16 <= i_16 + 1;	

					/*
							buff_data_3 [63 - (4 * i_16): 63 - ((4 * (i_16 + 1)) - 1)] <= data_in [3: 0];
							i_16 <= i_16 + 1;
							
							if (i_16 == 15)
								begin
									step <= step + 1;
									i_16 = 0;
								
								end*/
					
						end
				
					4:	begin
							case (i_16)
								0: 	begin
										buff_MAC_Addr_15 [3: 0] <= _data_in [3: 0];					
								
									end
									
								1:	begin
										buff_MAC_Addr_14 [3: 0] <= _data_in [3: 0];
									
									end
								
								2:	begin
										buff_MAC_Addr_13 [3: 0] <= _data_in [3: 0];
									
									end
									
								3:	begin	
										buff_MAC_Addr_12 [3: 0] <= _data_in [3: 0];
									
									end
								
								4: 	begin
										buff_MAC_Addr_11 [3: 0] <= _data_in [3: 0];					
								
									end
									
								5:	begin
										buff_MAC_Addr_10 [3: 0] <= _data_in [3: 0];
									
									end
								
								6:	begin
										buff_MAC_Addr_9 [3: 0] <= _data_in [3: 0];
									
									end
									
								7:	begin	
										buff_MAC_Addr_8 [3: 0] <= _data_in [3: 0];
									
									end
									
								8: 	begin
										buff_MAC_Addr_7 [3: 0] <= _data_in [3: 0];					
								
									end
									
								9:	begin
										buff_MAC_Addr_6 [3: 0] <= _data_in [3: 0];
									
									end
								
								10:	begin
										buff_MAC_Addr_5 [3: 0] <= _data_in [3: 0];
									
									end
									
								11:	begin	
										buff_MAC_Addr_4 [3: 0] <= _data_in [3: 0];
									
									end

								12:	begin
										buff_MAC_Addr_3 [3: 0] <= _data_in [3: 0];					
								
									end
									
								13:	begin
										buff_MAC_Addr_2 [3: 0] <= _data_in [3: 0];
									
									end
								
								14:	begin
										buff_MAC_Addr_1 [3: 0] <= _data_in [3: 0];
									
									end
									
								15:	begin	
										buff_MAC_Addr_0 [3: 0] <= _data_in [3: 0];
									
									end		
						
				endcase	
					
				if (i_16 == 15)
					begin
						step <= step + 1;
						i_16 = 0;
						buff_data_4 [63: 0] <= {buff_MAC_Addr_15 [3: 0], buff_MAC_Addr_14 [3: 0], buff_MAC_Addr_13 [3: 0], buff_MAC_Addr_12 [3: 0], buff_MAC_Addr_11 [3: 0], buff_MAC_Addr_10 [3: 0], buff_MAC_Addr_9 [3: 0], buff_MAC_Addr_8 [3: 0], buff_MAC_Addr_7 [3: 0], buff_MAC_Addr_6 [3: 0], buff_MAC_Addr_5 [3: 0], buff_MAC_Addr_4 [3: 0], buff_MAC_Addr_3 [3: 0], buff_MAC_Addr_2 [3: 0], buff_MAC_Addr_1 [3: 0], _data_in [3: 0]}; //buff_MAC_Addr_0 [3: 0]
					
					end else
						i_16 <= i_16 + 1;	
					
					/*
							buff_data_4 [63 - (4 * i_16): 63 - ((4 * (i_16 + 1)) - 1)] <= data_in [3: 0];
							i_16 <= i_16 + 1;
							
							if (i_16 == 15)
								begin
									step <= step + 1;
									i_16 = 0;
								
								end*/
					
						end
						
					5:	begin
							case (i_16)
								0: 	begin
										buff_MAC_Addr_15 [3: 0] <= _data_in [3: 0];					
								
									end
									
								1:	begin
										buff_MAC_Addr_14 [3: 0] <= _data_in [3: 0];
									
									end
								
								2:	begin
										buff_MAC_Addr_13 [3: 0] <= _data_in [3: 0];
									
									end
									
								3:	begin	
										buff_MAC_Addr_12 [3: 0] <= _data_in [3: 0];
									
									end
								
								4: 	begin
										buff_MAC_Addr_11 [3: 0] <= _data_in [3: 0];					
								
									end
									
								5:	begin
										buff_MAC_Addr_10 [3: 0] <= _data_in [3: 0];
									
									end
								
								6:	begin
										buff_MAC_Addr_9 [3: 0] <= _data_in [3: 0];
									
									end
									
								7:	begin	
										buff_MAC_Addr_8 [3: 0] <= _data_in [3: 0];
									
									end
									
								8: 	begin
										buff_MAC_Addr_7 [3: 0] <= _data_in [3: 0];					
								
									end
									
								9:	begin
										buff_MAC_Addr_6 [3: 0] <= _data_in [3: 0];
									
									end
								
								10:	begin
										buff_MAC_Addr_5 [3: 0] <= _data_in [3: 0];
									
									end
									
								11:	begin	
										buff_MAC_Addr_4 [3: 0] <= _data_in [3: 0];
									
									end

								12:	begin
										buff_MAC_Addr_3 [3: 0] <= _data_in [3: 0];					
								
									end
									
								13:	begin
										buff_MAC_Addr_2 [3: 0] <= _data_in [3: 0];
									
									end
								
								14:	begin
										buff_MAC_Addr_1 [3: 0] <= _data_in [3: 0];
									
									end
									
								15:	begin	
										buff_MAC_Addr_0 [3: 0] <= _data_in [3: 0];
									
									end		
						
				endcase	
					
				if (i_16 == 15)
					begin
						step <= step + 1;
						i_16 = 0;
						buff_data_5 [63: 0] <= {buff_MAC_Addr_15 [3: 0], buff_MAC_Addr_14 [3: 0], buff_MAC_Addr_13 [3: 0], buff_MAC_Addr_12 [3: 0], buff_MAC_Addr_11 [3: 0], buff_MAC_Addr_10 [3: 0], buff_MAC_Addr_9 [3: 0], buff_MAC_Addr_8 [3: 0], buff_MAC_Addr_7 [3: 0], buff_MAC_Addr_6 [3: 0], buff_MAC_Addr_5 [3: 0], buff_MAC_Addr_4 [3: 0], buff_MAC_Addr_3 [3: 0], buff_MAC_Addr_2 [3: 0], buff_MAC_Addr_1 [3: 0], _data_in [3: 0]}; //buff_MAC_Addr_0 [3: 0]
					
					end else
						i_16 <= i_16 + 1;	

					/*
							buff_data_5 [63 - (4 * i_16): 63 - ((4 * (i_16 + 1)) - 1)] <= data_in [3: 0];
							i_16 <= i_16 + 1;
							
							if (i_16 == 15)
								begin
									step <= step + 1;
									i_16 = 0;
								
								end*/
					
						end
					
					6:	begin
							case (i_16)
								0: 	begin
										buff_MAC_Addr_15 [3: 0] <= _data_in [3: 0];					
								
									end
									
								1:	begin
										buff_MAC_Addr_14 [3: 0] <= _data_in [3: 0];
									
									end
								
								2:	begin
										buff_MAC_Addr_13 [3: 0] <= _data_in [3: 0];
									
									end
									
								3:	begin	
										buff_MAC_Addr_12 [3: 0] <= _data_in [3: 0];
									
									end
								
								4: 	begin
										buff_MAC_Addr_11 [3: 0] <= _data_in [3: 0];					
								
									end
									
								5:	begin
										buff_MAC_Addr_10 [3: 0] <= _data_in [3: 0];
									
									end
								
								6:	begin
										buff_MAC_Addr_9 [3: 0] <= _data_in [3: 0];
									
									end
									
								7:	begin	
										buff_MAC_Addr_8 [3: 0] <= _data_in [3: 0];
									
									end
									
								8: 	begin
										buff_MAC_Addr_7 [3: 0] <= _data_in [3: 0];					
								
									end
									
								9:	begin
										buff_MAC_Addr_6 [3: 0] <= _data_in [3: 0];
									
									end
								
								10:	begin
										buff_MAC_Addr_5 [3: 0] <= _data_in [3: 0];
									
									end
									
								11:	begin	
										buff_MAC_Addr_4 [3: 0] <= _data_in [3: 0];
									
									end

								12:	begin
										buff_MAC_Addr_3 [3: 0] <= _data_in [3: 0];					
								
									end
									
								13:	begin
										buff_MAC_Addr_2 [3: 0] <= _data_in [3: 0];
									
									end
								
								14:	begin
										buff_MAC_Addr_1 [3: 0] <= _data_in [3: 0];
									
									end
									
								15:	begin	
										buff_MAC_Addr_0 [3: 0] <= _data_in [3: 0];
									
									end		
						
				endcase	
					
				if (i_16 == 15)
					begin
						step <= step + 1;
						i_16 = 0;
						buff_data_6 [63: 0] <= {buff_MAC_Addr_15 [3: 0], buff_MAC_Addr_14 [3: 0], buff_MAC_Addr_13 [3: 0], buff_MAC_Addr_12 [3: 0], buff_MAC_Addr_11 [3: 0], buff_MAC_Addr_10 [3: 0], buff_MAC_Addr_9 [3: 0], buff_MAC_Addr_8 [3: 0], buff_MAC_Addr_7 [3: 0], buff_MAC_Addr_6 [3: 0], buff_MAC_Addr_5 [3: 0], buff_MAC_Addr_4 [3: 0], buff_MAC_Addr_3 [3: 0], buff_MAC_Addr_2 [3: 0], buff_MAC_Addr_1 [3: 0], _data_in [3: 0]}; //buff_MAC_Addr_0 [3: 0]
					
					end else
						i_16 <= i_16 + 1;	
					
					/*
							buff_data_6 [63 - (4 * i_16): 63 - ((4 * (i_16 + 1)) - 1)] <= data_in [3: 0];
							i_16 <= i_16 + 1;
							
							if (i_16 == 15)
								begin
									step <= step + 1;
									i_16 = 0;
								
								end*/
					
						end
					
					7:	begin
							case (i_16)
								0: 	begin
										buff_MAC_Addr_15 [3: 0] <= _data_in [3: 0];					
								
									end
									
								1:	begin
										buff_MAC_Addr_14 [3: 0] <= _data_in [3: 0];
									
									end
								
								2:	begin
										buff_MAC_Addr_13 [3: 0] <= _data_in [3: 0];
									
									end
									
								3:	begin	
										buff_MAC_Addr_12 [3: 0] <= _data_in [3: 0];
									
									end
								
								4: 	begin
										buff_MAC_Addr_11 [3: 0] <= _data_in [3: 0];					
								
									end
									
								5:	begin
										buff_MAC_Addr_10 [3: 0] <= _data_in [3: 0];
									
									end
								
								6:	begin
										buff_MAC_Addr_9 [3: 0] <= _data_in [3: 0];
									
									end
									
								7:	begin	
										buff_MAC_Addr_8 [3: 0] <= _data_in [3: 0];
									
									end
									
								8: 	begin
										buff_MAC_Addr_7 [3: 0] <= _data_in [3: 0];					
								
									end
									
								9:	begin
										buff_MAC_Addr_6 [3: 0] <= _data_in [3: 0];
									
									end
								
								10:	begin
										buff_MAC_Addr_5 [3: 0] <= _data_in [3: 0];
									
									end
									
								11:	begin	
										buff_MAC_Addr_4 [3: 0] <= _data_in [3: 0];
									
									end

								12:	begin
										buff_MAC_Addr_3 [3: 0] <= _data_in [3: 0];					
								
									end
									
								13:	begin
										buff_MAC_Addr_2 [3: 0] <= _data_in [3: 0];
									
									end
								
								14:	begin
										buff_MAC_Addr_1 [3: 0] <= _data_in [3: 0];
									
									end
									
								15:	begin	
										buff_MAC_Addr_0 [3: 0] <= _data_in [3: 0];
									
									end		
						
				endcase	
					
				if (i_16 == 15)
					begin
						step <= step + 1;
						i_16 = 0;
						buff_data_7 [63: 0] <= {buff_MAC_Addr_15 [3: 0], buff_MAC_Addr_14 [3: 0], buff_MAC_Addr_13 [3: 0], buff_MAC_Addr_12 [3: 0], buff_MAC_Addr_11 [3: 0], buff_MAC_Addr_10 [3: 0], buff_MAC_Addr_9 [3: 0], buff_MAC_Addr_8 [3: 0], buff_MAC_Addr_7 [3: 0], buff_MAC_Addr_6 [3: 0], buff_MAC_Addr_5 [3: 0], buff_MAC_Addr_4 [3: 0], buff_MAC_Addr_3 [3: 0], buff_MAC_Addr_2 [3: 0], buff_MAC_Addr_1 [3: 0], _data_in [3: 0]}; //buff_MAC_Addr_0 [3: 0]
					
					end else
						i_16 <= i_16 + 1;	
					
					/*
							buff_data_7 [63 - (4 * i_16): 63 - ((4 * (i_16 + 1)) - 1)] <= data_in [3: 0];
							i_16 <= i_16 + 1;
							
							if (i_16 == 15)
								begin
									step <= step + 1;
									i_16 = 0;
								
								end*/
					
						end
				
				endcase

			end

		6:	begin
				case (i_16)
								0: 	begin
										buff_MAC_Addr_7 [3: 0] <= _data_in [3: 0];					
								
									end
									
								1:	begin
										buff_MAC_Addr_6 [3: 0] <= _data_in [3: 0];
									
									end
								
								2:	begin
										buff_MAC_Addr_5 [3: 0] <= _data_in [3: 0];
									
									end
									
								3:	begin	
										buff_MAC_Addr_4 [3: 0] <= _data_in [3: 0];
									
									end
								
								4: 	begin
										buff_MAC_Addr_3 [3: 0] <= _data_in [3: 0];					
								
									end
									
								5:	begin
										buff_MAC_Addr_2 [3: 0] <= _data_in [3: 0];
									
									end
								
								6:	begin
										buff_MAC_Addr_1 [3: 0] <= _data_in [3: 0];
									
									end
									
								7:	begin	
										buff_MAC_Addr_0 [3: 0] <= _data_in [3: 0];
									
									end	
						
				endcase	
					
				if (i_8 == 7)
					begin
						step <= step + 1;
						i_8 = 0;
						buff_data_crc32 [31: 0] <= {buff_MAC_Addr_7 [3: 0], buff_MAC_Addr_6 [3: 0], buff_MAC_Addr_5 [3: 0], buff_MAC_Addr_4 [3: 0], buff_MAC_Addr_3 [3: 0], buff_MAC_Addr_2 [3: 0], buff_MAC_Addr_1 [3: 0], _data_in [3: 0]}; //buff_MAC_Addr_0 [3: 0]
					
					end else
						i_8 <= i_8 + 1;
		
		/*
				buff_data_crc32 [31 - (4 * i_8): 31 - ((4 * (i_8 + 1)) - 1)] <= data_in [3: 0]; //buff_data_crc32 [31 - (4 * j): 31 - ((4 * (j + 1)) - 1)] <= data_in [3: 0];
				i_8 <= i_8 + 1;
				
				if (i_8 == 7) 
					begin
						i_8 <= 0;
						state_in <= 0;
					
					end*/
		
			end
	
	endcase
	
	buff_CRC <= CRS;
			
	if (CRS == 0)
		begin
			state_in <= 0;
			step <= 0;
			
			if ((state_in < 6) & (buff_CRC == 1))
				flag_full_read <= 0;
			else
				flag_full_read <= 1;
			
		end	
		//data_in [3: 0] <= buff_transmit [3: 0];

end


always @(posedge clk_25Mz)
begin
if (RX_ER == 1)
	cnt_error_data <= cnt_error_data + 1;


end





endmodule