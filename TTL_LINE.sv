module TTL_LINE
(
	input	clk_100Mz,
	input	clk_1Mz,
	
	input	[3: 0] 	ispr_upr_cont_in,
	input			rspa_uva_in,
	input	[1: 0]	sense_upr_cont_in,

	output	[8: 0]	addr_1_out,
	output			zspa_uva_out,
	output			ispr_uva_out,
	output	[2: 0]	kod_upr_pum_upr_cont_out,
	
	input			inz_uva_in,
	output			branch_channel = 1,
	
	output	[2: 0]	j,
	output	[2: 0]	cnt_check_channel = 0,
	output	[7: 0]	cnt_1Mz = 0,
	
	output	[7: 0]	status_sum_addr_0_6_inz,
	output	[7: 0]	status_sum_addr_7_8_zspa_ispr_kod
);

localparam MIN_IN8 = 4;
localparam MIN_CHECK_INZ = 100;
localparam MIN_cnt = 40;
localparam MAX_cnt = 60;

logic [11: 0] cnt_kz [2: 0];
logic [7: 0] kz;
logic [7: 0] cnt_status_kz [2: 0];

logic [7: 0] status_ttl_0 = 0;
logic [7: 0] status_ttl_1 = 0;

//logic [3: 0] j = 0;

logic [7: 0] data_out_0 = 0;
logic [7: 0] data_out_1 = 0;
logic [7: 0] cnt_read_data [3: 0];
logic [7: 0] enable_channel = 1;
logic [7: 0] in_addr;

logic [11: 0] cnt_inz_line;
logic [11: 0] cnt_read_inz;

//out 16
assign addr_1_out [6: 0] = data_out_1 [6: 0];
assign addr_1_out [8: 7] = data_out_0 [1: 0];
assign zspa_uva_out = data_out_0 [2];
assign ispr_uva_out = data_out_0 [3];
assign kod_upr_pum_upr_cont_out [2: 0] = data_out_0 [6: 4];

//in 8
assign in_addr [3: 0] = ispr_upr_cont_in [3: 0];
assign in_addr [4] = rspa_uva_in;
assign in_addr [6: 5] = sense_upr_cont_in [1: 0];
//assign in_addr [7] = inz_uva_in;


genvar i;
generate
	for (i = 0; i < 8; i = i + 1) 
	begin : gerator
		GENER_TTL_OUT_ENA gener_ttl_out_ena
		(
			.clk_100Mz(clk_100Mz),
			.clk_1Mz(clk_1Mz),
	
			.branch_channel(branch_channel),
			.data_out_0(data_out_0[i]),
			.data_out_1(data_out_1[i]),
			.enable_channel(enable_channel[j])

		);
	end
	
	


endgenerate


always @(posedge clk_100Mz)
begin
	if (branch_channel == 1)
		if (((in_addr [j] == in_addr [0]) + (in_addr [j] == in_addr [1]) + (in_addr [j] == in_addr [2]) + (in_addr [j] == in_addr [3]) + (in_addr [j] == in_addr [4]) + (in_addr [j] == in_addr [5]) + (in_addr [j] == in_addr [6])) == 1)
			cnt_kz [j] <= cnt_kz [j] + 1;
		
	if ((cnt_check_channel) & (branch_channel == 1))
		begin
			cnt_kz [j] <= 0;
			if ((cnt_kz [j] > MIN_cnt) & (cnt_kz [j] < MAX_cnt))
				cnt_status_kz [j] <= cnt_status_kz [j] + 1;
			
		end
		
	if ((j) & (branch_channel == 0))
		begin
			cnt_status_kz [j] <= 0;
			
			if (cnt_status_kz [j] > 4)
				kz [j] <= 1;
			else
				kz [j] <= 0;
			
		end
	if (cnt_1Mz == 99)
		cnt_1Mz <= 0;
	else
		cnt_1Mz <= cnt_1Mz + 1;
	
end



always @(posedge clk_1Mz)
begin

	cnt_check_channel <= cnt_check_channel + 1;
	
	if (cnt_check_channel == 7)
	begin
		j <= j + 1;
		enable_channel <= {enable_channel[6: 0], enable_channel[7]};
	end
		 

/*	if (j == 7)	
		enable_channel <= 1;*/

end

//read in data

genvar k;
generate
	for (k = 0; k < 8; k = k + 1) 
	begin : gerator_1
		TTL_IN_LINE ttl_in_line
		(
			.clk_fpga(clk_100Mz),
			//.j(j),
			.branch_channel(branch_channel),
			.clk_in(in_addr[k]), 
			.data_1(status_ttl_1[k]),
			.data_0(status_ttl_0[k])
	
		);
	end

endgenerate



always @(posedge clk_1Mz)
begin
	if (branch_channel == 1)
	begin
		if  (status_ttl_1 [j] == 1) 
		begin
			cnt_read_data [j] <= cnt_read_data [j] + 1;		
		end
	end
	else
	begin
		if (status_ttl_0 == 1)
		begin
			cnt_read_data [j] <= cnt_read_data [j] + 1;		
		end	
	end
	
			
	if (cnt_check_channel == 7)
		cnt_read_data [j] <= 0;
	
	
	if (j == 7) 
	begin		
		branch_channel <= branch_channel + 1;			
	end
	
	if (branch_channel == 1)
		if ((cnt_read_data [j] > MIN_IN8) & (j < 7) & (kz [j] == 1))
			status_sum_addr_0_6_inz [j] <= 1;
		else
			status_sum_addr_0_6_inz [j] <= 0;
	else
		if (cnt_read_data [j] > MIN_IN8)
			status_sum_addr_7_8_zspa_ispr_kod [j] <= 1;
		else
			status_sum_addr_7_8_zspa_ispr_kod [j] <= 0;	
/*

end

//check hold line inz


always @(posedge clk_1Mz)
begin
*/
	if (branch_channel == inz_uva_in)
		cnt_inz_line <= cnt_inz_line + 1;
	
	if ((branch_channel == 0) & (j == 7))
		begin
			cnt_inz_line <= 0;
			cnt_read_inz <= cnt_inz_line;
			
			if (cnt_read_inz > MIN_CHECK_INZ)
				status_sum_addr_0_6_inz [7] <= 1;
			else
				status_sum_addr_0_6_inz [7] <= 0;
		end
end








endmodule