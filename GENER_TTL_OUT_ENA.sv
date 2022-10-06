module GENER_TTL_OUT_ENA
(
	input	clk_100Mz,
	input	clk_1Mz,
	
	input			branch_channel,
	input			enable_channel,
	output			data_out_0,
	output			data_out_1
);


always @(posedge clk_100Mz)
begin
	if (branch_channel == 1)
		if (enable_channel == 1)
			data_out_1 <= clk_100Mz;
		else
			data_out_1 <= 0;
	else
		if (enable_channel == 1)//0
			data_out_0 <= clk_100Mz;
		else
			data_out_0 <= 0;

end
endmodule