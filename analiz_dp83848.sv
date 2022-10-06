module analiz_dp83848
#(
	parameter START_BIT = 2'b01,
	parameter PHY_ADDR = 5'h0C,
	parameter OPCODE_RD = 2'b10,
	parameter OPCODE_WR = 2'b01
)
(
	input	clk_100Mz,
	input	clk_1Mz,
	input	clk_25Mz,
	
	
	//input			first_start,
	
	//output			MDC,
	//output			MDIO_out,
	
	input	[2: 0]	state,	
	// kuda wr - ?
	//input			MDIO_in,
	//output	logic	flag_end_comad_diag,
	input [63: 39]	buff_data_0, //45 - (end) and 46 - (begin) read or write, 44 - oprosit' dp, 43 - 39 reg_addr
	
	inout			MDIO,
	
	output	logic [15: 0]	reg_MDIO_RD	
	

);

logic MDIO_in;
logic MDIO_out;
logic flag_end_comad_diag;

assign MDIO = (flag_end_comad_diag == 1) ? MDIO_out : 1'bz;
assign MDIO_in = MDIO;
//assign MDC = clk_25Mz; 


logic i = 1;
logic [2: 0] state_dp = 0;
logic flag_check_dp = 0;

logic [2: 0] j = 0;
logic [3: 0] cnt_reg_data = 0;

//logic flag_end_comad_diag = 0;

//logic [15: 0] buff_
/*initial
reg_MDIO_RD = 16'hFFFF;*/


always @(negedge clk_25Mz) // this relaese lose 1 clk
begin
	if (buff_data_0 [44] == 1)
		flag_end_comad_diag <= 1;
	else
		flag_end_comad_diag <= 0;
	//begin
	case (state_dp) //1 clk zadr, i don`t know
		0:	begin
				//MDIO_out <= 1'bz
				if (buff_data_0 [44] == 1)
					state_dp <= state_dp + 1;
		
			end				
		
		1: 	begin
				MDIO_out <= START_BIT [i];
				i <= i + 1;
				
				if (i == 0)
					state_dp <= state_dp + 1;
				
			end

		2:	begin
				MDIO_out <= buff_data_0 [(45 + i)]; //initial buff_data_0 [46] = 0 (end), buff_data_0 [47] = 1 (begin) 
				i <= i + 1;
				
				if (i == 0)
					state_dp <= state_dp + 1;

			end
			
		3:	begin
				MDIO_out <= PHY_ADDR [j];
				j <= j + 1;
				
				if (j == 4)
					begin
						j <= 0;
						state_dp <= state_dp + 1;
					
					end
				
			end
			
		4:	begin
				MDIO_out <= buff_data_0 [(39 + j)]; //40 - begin, 44 - end
				j <= j + 1;
				
				if (j == 4)
					begin
						j <= 0;
						state_dp <= state_dp + 1;
					
					end 
				
			end
			
		5:	begin
				if (buff_data_0 [46: 45] == OPCODE_WR)
					begin
						MDIO_out <= buff_data_0 [(45 + i)];
						i <= i + 1;
						
						if (i == 0)
							state_dp <= state_dp + 1;
						
					end else
					begin
						flag_end_comad_diag <= 0;
						i <= i + 1;
						
						if (i == 0)
							state_dp <= state_dp + 1;
					
					end
					

			end
			
		6:	begin
				if (buff_data_0 [46: 45] == OPCODE_WR)
					begin
						MDIO_out <= buff_data_0 [(47 + cnt_reg_data)];
						
						if (cnt_reg_data == 15)
							state_dp <= state_dp + 1;
						else
							cnt_reg_data <= cnt_reg_data + 1;
					
					end else
					begin
						reg_MDIO_RD [cnt_reg_data] <= MDIO_in; //check <-/->
						
						if (cnt_reg_data == 15)
							state_dp <= state_dp + 1;
						else
							cnt_reg_data <= cnt_reg_data + 1;
					
					end
			
			end					
					
		7:	begin // m b + flag on 1 RD or WR
				if (flag_end_comad_diag == 1)
					state_dp <= state_dp + 1;
				//flag_end_comad_diag <= 0;

			end
	
	endcase
	
	//end





end






endmodule