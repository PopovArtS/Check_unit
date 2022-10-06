module CRS_32_IN
#(
parameter CRC_DATA = 32'h4C11DB7
)
(
	input	clk_100Mz,
	input	clk_1Mz,
	input	clk_25Mz,
	
	input	[3: 0]	data_in,
	input	[3: 0]	DATA,
	input	[2: 0]	state_in,
	
	output	logic [32: 0]	buff_data_crc_in

	

);


logic [3: 0] buff_data_in = 0;

//logic [32: 0] reg_div_crc;



logic check_start_crs = 0;

logic [1: 0] i = 3;


//logic [1: 0] cnt_shift_pack = 3;
//assign [32: 0] reg_div_crc = [32: 0] buff_data_crc;

always @(posedge clk_25Mz)
begin
	if (state_in == 5)
		begin
			check_start_crs <= 1;
			
		end else
			check_start_crs <= 0;
		
	
	if (check_start_crs == 1)
		begin
			buff_data_in [3: 0] <= data_in [3: 0];
		
		end

	

end

always @(posedge clk_100Mz)
begin
	if (state_in == 5)
		begin
			if (buff_data_in [3: 0] != data_in [3: 0])
				begin
					buff_data_crc_in [32: 0] <= {buff_data_crc_in [32: 0] << 1, data_in [i]};
					
					if (buff_data_crc_in [32] == 1)
						buff_data_crc_in [31: 0] <= buff_data_crc_in [31: 0] ^ CRC_DATA [31: 0];
				
					i <= i - 1;
				
				
				
				end
			

end



end









endmodule