module sinhr_input_data
(
	input	clk_100Mz,
	input	clk_1Mz,
	input	clk_25Mz,
	
	input	[3: 0] data_in,
	input			CRS,
	input			RX_DV,
	input	[2: 0] state_in,
	
	output	[3: 0] data_sinhr_out

);

logic [7: 0] data_buff = 0;
logic [1: 0] param_sdvig_in_data;

always @(posedge clk_25Mz)
begin
	data_buff [3: 0] <= data_in [3: 0];
	data_buff [7: 4] <= data_buff [3: 0];

end



always @(posedge clk_25Mz)
begin
	if ((data_in [3: 0] != data_buff [3: 0]) && (CRS == 1) && (RX_DV == 1) && (state_in == 1))
		case (data_in)
			1: param_sdvig_in_data <= 0;
			2: param_sdvig_in_data <= 1;
			4: param_sdvig_in_data <= 2;
			8: param_sdvig_in_data <= 3;
			default : param_sdvig_in_data <= 0;
		endcase
		
	case (param_sdvig_in_data)	
	0: data_sinhr_out [3: 0] <= data_buff [3: 0];
	1: data_sinhr_out [3: 0] <= data_buff [4: 1];
	2: data_sinhr_out [3: 0] <= data_buff [5: 2];
	3: data_sinhr_out [3: 0] <= data_buff [6: 3];
	endcase
	//data_sinhr_out [3: 0] <= data_buff [(3 + param_sdvig_in_data): param_sdvig_in_data];
end

endmodule