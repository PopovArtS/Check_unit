module RES_TTL1 //check begin all channel, 8 raz
(
	input clk_100Mz,
	input clk_1Mz,
	
	input	[7: 0]		res_ttl1_in,
	output 	[7: 0]		res_ttl1_out,
	output	[7: 0]		active_channel_res_ttl
);
localparam ETALON_ISPR_RES_TTL = 50;
localparam SBROS_1Mz = 2'b01;

logic [7: 0] kz = 0;
//logic buff_res_ttl;
//logic buff_refresh;
logic [2: 0] j = 0;
logic cnt_real_res [2: 0];
logic [2: 0] cnt_time_analiz;
wire [7: 0] cnt_form_res_ttl [7: 0]; //check
genvar i;
generate
	for (i = 0; i < 8; i = i + 1) 
	begin : gerator
		GEN_TEST_RES_TTL gen_test_res_ttl
		(
			.clk_100Mz(clk_100Mz),
			.clk_1Mz(clk_1Mz),
	
			.res_ttl1_in(res_ttl1_in [i]),
			.cnt_form_res_ttl(cnt_form_res_ttl [i])
		);
	end

		
	always @(posedge clk_100Mz)
	begin
		res_ttl1_out [j] <= res_ttl1_out [j] + 1; //gerator 100 Mz out
			
		if (j == 7) //or 0
			cnt_time_analiz <= cnt_time_analiz + 1;
			
		if (cnt_time_analiz == 7) //begin all channel, next 8 circle
			cnt_real_res [j] <= 0;
		
		if ((cnt_time_analiz == 7) & (cnt_real_res [j] > 4))
			active_channel_res_ttl[j] <= 1;
		else
			active_channel_res_ttl[j] <= 0;
		
			
		if (cnt_form_res_ttl [j] > 16)	// all 50, check comb 2'b10
			if (((cnt_form_res_ttl [0] == cnt_form_res_ttl [j]) + (cnt_form_res_ttl [1] == cnt_form_res_ttl [j]) + (cnt_form_res_ttl [2] == cnt_form_res_ttl [j]) + (cnt_form_res_ttl [3] == cnt_form_res_ttl [j]) + (cnt_form_res_ttl [4] == cnt_form_res_ttl [j]) + (cnt_form_res_ttl [5] == cnt_form_res_ttl [j]) + (cnt_form_res_ttl [6] == cnt_form_res_ttl [j]) + (cnt_form_res_ttl [7] == cnt_form_res_ttl [j])) == 1)
				kz [j] <= 0; // good
			else
				kz [j] <= 1; //bad
		else
			kz [j] <= 1;
			
	end	
		
		
		
	always @(posedge clk_1Mz)
	begin
		j <= j + 1;
		
		if (((cnt_form_res_ttl [j] < ETALON_ISPR_RES_TTL + 3) & (cnt_form_res_ttl [j] > ETALON_ISPR_RES_TTL - 3)) & (kz [j] == 0)) //
			cnt_real_res [j] <= cnt_real_res [j] + 1;
		else
			cnt_real_res [j] <= cnt_real_res [j] + 0;

	end	
		

endgenerate


endmodule