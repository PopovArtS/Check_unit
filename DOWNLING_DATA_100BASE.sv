module DOWNLING_DATA_100BASE
#(
	parameter MAC_ADR_POL = 48'hFFFFFFFFFFFF, //6 byte or 96'h030000000001
	parameter MAC_ADR_OTP = 0, //6 byte
	parameter MAC_TIP_FRAME = 16'h800 //2 byte proverit' cnt
)
(
	input	clk_100Mz,
	input	clk_1Mz,
	input	clk_25Mz,
	
	output			TX_EN = 1,
	input			start_work,
	output	logic	check_good_work,
	input	[63: 0]	status_channel,
	
	input	[31: 0]	buff_data_crc,
	
	output			buf_reset_dp,
	
	output			data_pack, //gde sdvig reg [3: 0]
	
	output	logic	check_volume_data,
	output	logic	check_receive,
	
	input			CRS,
	output	logic	_data_pack,
	output			sinhr,
	
	input	[63: 0] buff_data_0,
	output	[2: 0] 	step,
	
	input	reg [15: 0]	reg_MDIO_RD	
	

);
logic buf_data_pack;

assign buf_data_pack = data_pack;
reg [15: 0] _reg_MDIO_RD;
assign _reg_MDIO_RD = reg_MDIO_RD;

localparam SINHR_CLK = 2'b00;
localparam PREAMBULA = 4'b0101;
localparam PREAMBULA_END = 4'b0111;
localparam CHECK_STATUS = 8'b00000001;
localparam MIN_PACT_DATA = 95;
localparam MAX_PACT_DATA = 2999;

localparam MIN_CHECK_RECEIVE = 5;
localparam MAX_CHECK_RECEIVE = 6;


//logic sinhr = 0;

//logic [2: 0] step;

logic flag_tran_reg_MDIO_RD = 0;
logic start_data;

logic [1: 0] cnt_clk_25 = 0;


logic [3: 0] buff_clk_25Mz = 0; 

logic [1: 0] cnt_pream = 3;
logic [2: 0] i = 7;
logic [5: 0] j = 47;
logic [5: 0] k = 47;
logic [3: 0] h = 15;
logic [4: 0] l = 31;
logic [5: 0] u = 63;

logic check_out_port;

logic [3: 0] cnt_check_good_sinh = 0;
logic [4: 0] cnt_check_good_adr_master = 0;
logic [4: 0] cnt_check_good_adr_slave = 0;
logic [1: 0] cnt_check_good_tip_frame = 0;
logic [11: 0] cnt_check_good_data = 0;
logic [2: 0] cnt_check_good_crc = 0;
logic [2: 0] cnt_wait_receive_data = 0;
logic [2: 0] cnt_check_status = 0;


always @(posedge clk_25Mz)//posedge
begin
	TX_EN <= 1;

	case (step)
		0:	begin
				if ((start_work == 1) && (sinhr == 1) /*& (buff_data_0 [38] == 1) /*& (buff_data_0 [37] == 1)*/)
					begin
						//check_out_port <= check_out_port + 1; //kostil'
						
						//if (check_out_port == 1)
						step <= 1;
						
					end	else
						step <= 0;
		
			end	
	
		1:	begin
				check_out_port <= 0;
		
				if (check_good_work == 1) // start_data == 1 - sinhr for clk_25Mz
				begin
					cnt_check_good_sinh <= cnt_check_good_sinh + 1;					
				
				end
				
				if (cnt_check_good_sinh == 15)
					step <= 2;
				
				if (cnt_check_good_sinh == 0)
					if (start_work == 0)
						step <= 0;	
				
				cnt_check_good_data <= 0;
				
			end
			
		2:	begin
				if (check_good_work == 1)
				begin
					cnt_check_good_adr_master <= cnt_check_good_adr_master + 1;
				
				end

				if (cnt_check_good_adr_master == 11)
					step <= 3;
					
				/*else
					if (start_work == 0)
						step <= 0;*/
						
			end
			
		3:	begin
				cnt_check_good_adr_master <= 0;
				
				if (check_good_work == 1)
				begin
					cnt_check_good_adr_slave <= cnt_check_good_adr_slave + 1;
				
				end

				if (cnt_check_good_adr_slave == 11)
					step <= 4;
				/*else
					if (start_work == 0)
						step <= 0;	*/

			end
			
		4:	begin
				cnt_check_good_adr_slave <= 0;
				
				if (check_good_work == 1)
				begin
					cnt_check_good_tip_frame <= cnt_check_good_tip_frame + 1;
				
				end
				
				if 	(cnt_check_good_tip_frame == 3)	
					step <= 5;
				/*else
					if (start_work == 0)
						step <= 0;	*/

			end
			
		5:	begin
				cnt_check_good_tip_frame <= 0;
				
				if (check_good_work == 1)
				begin
					cnt_check_good_data <= cnt_check_good_data + 1;
				
				end	
					
				if 	(cnt_check_good_data == 131) //127
					step <= 6;
				/*else
					if (start_work == 0)
						step <= 0;	*/

			end
			
		6:	begin
				if (check_good_work == 1)
				begin
					cnt_check_good_crc <= cnt_check_good_crc + 1;
				end	
				
				if (cnt_check_good_crc == 7)
					step <= 1;
					
				if (((cnt_check_good_data > MIN_PACT_DATA) & (check_volume_data < MAX_PACT_DATA)) == 1)
					check_volume_data <= 1;
				else
					check_volume_data <= 0;

			end
			
		7: 	begin //wait receive
				/*if (CRS == 1)
					check_receive <= 1; //check work
				else
					check_receive <= 0;

				cnt_wait_receive_data <= cnt_wait_receive_data + 1;
			
				if ((cnt_wait_receive_data > 4) & (check_receive == 1))
					step <= 0;	*/

				//step <= 1;

			end
			
			
	
		
	endcase
	
	
	if (start_work == 0)
		begin
			//step <= 0;
			check_good_work <= 0;
			//TX_EN <= 0;
		end else
		begin
			check_good_work <= 1;
			
			//if (step != 0)
				//TX_EN <= 1;

		end	
	
		
		
	
end

always @(posedge clk_100Mz)//posedge
begin
	case (step)
		0:	begin
				data_pack <= 1'bz;
		
			end		
		
		1:	begin
			l <= 31;
					
			if ((check_good_work == 1) /*& (start_data == 1)*/)
				begin
					cnt_pream <= cnt_pream - 1;	
					
					if (cnt_check_good_sinh != 15)
						begin
							data_pack <= PREAMBULA [cnt_pream]; // i
							//cnt_pream <= cnt_pream - 1;	//i <= i - 1;
							
						end else
						begin
							data_pack <= PREAMBULA_END [cnt_pream]; // i
							//i <= i - 1;
						
						end
				end else
				data_pack <= 1'bz;

			end
				
		2:	begin
				cnt_pream <= 3;
				i <= 7;
				
				if ((check_good_work == 1) /*& (start_data == 1)*/)
					data_pack <= MAC_ADR_POL [j];
				else
					data_pack <= 1'bz;
				j <= j - 1;						
			
			end

		3:	begin
				j <= 47;
				
				if (check_good_work == 1)
					data_pack <= MAC_ADR_OTP [k];
				else
					data_pack <= 1'bz;
					
				k <= k - 1;
				
			end
			
		4:	begin
				k <= 47;
				
				if (check_good_work == 1)
					data_pack <= MAC_TIP_FRAME [h];
				else
					data_pack <= 1'bz;
					
				if ((cnt_check_good_tip_frame == 3)	& (h == 0))
					h <= 0;
				else	
					h <= h - 1;

			end
			
		5:	begin				
				if (check_good_work == 1)
				begin
					i <= i - 1;
					h <= h + 1;
					cnt_check_status <= cnt_check_status + 1;
				
					if (flag_tran_reg_MDIO_RD == 0)
						begin
							data_pack <= _reg_MDIO_RD [h];
							
							if (h == 15)
								flag_tran_reg_MDIO_RD <= 1;
							
						end else
						begin
							if (cnt_check_status == 7)
								u <= u - 1;
						
							if (status_channel [u] == 1)
								data_pack <= CHECK_STATUS [i];
							else
								data_pack <= 0;
						end	
				end	else
					data_pack <= 1'bz;
					
			end
			
		6:	begin
				l <= l - 1;
				i <= 7;
				flag_tran_reg_MDIO_RD <= 0;
				h <= 15;
				
				if (check_good_work == 1)
					data_pack <= buff_data_crc[l];
				else
					data_pack <= 1'bz;

			end
		
		7:	begin				
				data_pack <= 1'bz;

			end			
			
	endcase	
		
	if ((sinhr == 1) && (start_work == 1) && (step == 0))
		start_data <= 1;
	else 
		start_data <= 0;
	
end

always @(negedge clk_100Mz)
begin
_data_pack <= buf_data_pack;

buff_clk_25Mz [3] <= buff_clk_25Mz [2];
buff_clk_25Mz [2] <= buff_clk_25Mz [1];
buff_clk_25Mz [1] <= buff_clk_25Mz [0];
buff_clk_25Mz [0] <= clk_25Mz;

if ({buff_clk_25Mz [0], clk_25Mz} == SINHR_CLK)
	sinhr <= 1;
else
	sinhr <= 0;


end

endmodule