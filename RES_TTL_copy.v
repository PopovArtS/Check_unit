module RES_TTL1
(
	input clk_100Mz,
	input clk_1Mz,
	
	input	[7: 0]		res_ttl1_in,
	output 	[7: 0]		res_ttl1_out,
	output	[7: 0]		active_channel_res_ttl
);
localparam ETALON_ISPR_RES_TTL = 50;
localparam SBROS_1Mz = 2'b01;
localparam CODE_G = 2'b10;

logic buff_res_ttl;
logic buff_refresh;
logic [2: 0] j = 0;
wire [7: 0] cnt_form_res_ttl[7: 0];
/*genvar i;
generate
	for (i = 0; i < 7; i = i + 1) 
		begin : gerator
			/*GEN_TEST_RES_TTL gen_test_res_ttl
			(
				//input clk_100Mz,
				//input clk_1Mz,
	
				//input	[7: 0]		res_ttl1_in,
				//output 	[7: 0]		res_ttl1_out,
				//output	[7: 0]		cnt_form_res_ttl
			)
			
		/*	always @(posedge clk_100Mz)
				begin
					if ((cnt_form_res_ttl < ETALON_ISPR_RES_TTL + 3) & (cnt_form_res_ttl > ETALON_ISPR_RES_TTL - 3))
						active_channel_res_ttl <= 1;
					else
						active_channel_res_ttl <= 0;
				end
		
		end

endgenerate*/

always @(posedge clk_100Mz)
begin

	res_ttl1_out [j] <= res_ttl1_out [j] + 1;
	buff_res_ttl <= res_ttl1_in;
	buff_refresh <= clk_1Mz;
	
	if (!({buff_refresh, clk_1Mz} == SBROS_1Mz))
		begin
			j <= j + 1;
			cnt_form_res_ttl [j] <= 0;
		end	
	
	
	if ({buff_res_ttl, res_ttl1_in} == CODE_G)
		cnt_form_res_ttl <= cnt_form_res_ttl + 1;
		
	if (!({buff_refresh, clk_1Mz} == SBROS_1Mz))
		cnt_form_res_ttl <= 0;
		
	
	
	

end