module GEN_TEST_RES_TTL
(
	input clk_100Mz,
	input clk_1Mz,
	
	input				res_ttl1_in,
//output 				res_ttl1_out,
	output	[7: 0]		cnt_form_res_ttl
);

localparam CODE_G = 2'b10;
localparam SBROS_1Mz = 2'b01;

logic buff_res_ttl;
logic buff_refresh;

always @(posedge clk_100Mz)
begin
	//res_ttl1_out <= res_ttl1_out + 1;

	buff_res_ttl <= res_ttl1_in;
	buff_refresh <= clk_1Mz;
	
	if (({buff_res_ttl, res_ttl1_in} == CODE_G) & !({buff_refresh, clk_1Mz} == SBROS_1Mz))
		cnt_form_res_ttl <= cnt_form_res_ttl + 1;
	else
		cnt_form_res_ttl <= 0;
		
end