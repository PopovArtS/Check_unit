module LVDS_IN_STATUS
(
	input clk_100Mz,
	input clk_1Mz,
	
	input	[2: 0]	j,
	input	[2: 0]	cnt_check_channel,
	input	[7: 0]	cnt_1Mz,
	//input			branch_channel,
	
	input 			clk_out_in,
	input 			izp_uva_in,
	input			im_uva_in,
	input			do_1_in,

	output	[7: 0]	ready_channel
);

localparam MIN_cnt = 40;
localparam MAX_cnt = 60;

//logic [1: 0] l;

logic [7: 0] status; //check, but read 
logic [2: 0] cnt_status [2: 0];

logic [8: 0] cnt_check_kz [2: 0];
logic [2: 0] cnt_flag_kz [2: 0];
logic [7: 0] flag_kz = 0;

logic [6: 0] cnt_clk_100Mz = 0;

logic [3: 0] data_in; // 7

assign data_in [0] = clk_out_in;
assign data_in [1] = izp_uva_in;
assign data_in [2] = im_uva_in;
assign data_in [3] = do_1_in;
/*assign data_in [4] = clk_out_in;
assign data_in [5] = izp_uva_in;
assign data_in [6] = im_uva_in;
assign data_in [7] = do_1_in;*/

//assign [1: 0] l = [1: 0] j; or on l switch data_in


genvar i;
generate // i < 4
	for (i = 0; i < 4; i = i + 1) // 8
	begin : gerator
		LVDS_STATUS lvds_status
		(
			.clk_fpga(clk_100Mz),
			.clk_check(clk_1Mz),
			.clk_in(data_in[i]),

			.status(status[i])//cnt
		);
	end
	
	always @(posedge clk_100Mz)
	begin
		if ((cnt_check_kz [j] > MIN_cnt) & (cnt_check_kz [j] < MAX_cnt))
			flag_kz [j] <= 1;
		else 
			flag_kz [j] <= 0;
		
		if (cnt_clk_100Mz == 99)
		begin
			cnt_check_kz [j] <= 0;
			cnt_clk_100Mz <= 0;
			
		end	else
		begin
			if (((data_in [j] == data_in [0]) + (data_in [j] == data_in [1]) + (data_in [j] == data_in [2]) + (data_in [j] == data_in [3])) == 1)
				cnt_check_kz [j] <= cnt_check_kz [j] + 1;	
				cnt_clk_100Mz <= cnt_clk_100Mz + 1;	
				
		end		
	
	end
		
	always @(posedge clk_1Mz)
	begin
		if (flag_kz [j] == 1)
			cnt_flag_kz [j] <= cnt_flag_kz [j] + 1;
			
		if (status [j] == 1)
			cnt_status [j] <= cnt_status [j] + 1;

		if (cnt_check_channel == 7)
		begin
			cnt_status [j] <= 0;
			cnt_flag_kz [j] <= 0;
			
			if ((cnt_flag_kz [j] > 2) & (cnt_status [j] > 2))
				ready_channel [j] <= 1;
			else
				ready_channel [j] <= 0;	
			
		end

	end
			
			
endgenerate
endmodule		