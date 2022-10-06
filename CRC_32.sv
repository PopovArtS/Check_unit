module CRC_32
#(
parameter CRC_DATA = 32'h4C11DB7
)
(
	input	clk_100Mz,
	input	clk_1Mz,
	input	clk_25Mz,
	
	input	logic		_data_pack,
	input	[3: 0]	DATA,
	input	[2: 0]	step,
	
	output	logic [32: 0]	buff_data_crc

	

);

//logic [7: 0] buff_pred_data_crc = 0;
//logic [32: 0] buff_data_crc = 0;

//logic [32: 0] reg_div_crc;

//logic [31: 0] buff_data_crc_rez;

//assign buff_data_crc_rez [31: 0] = buff_data_crc [31: 0];

logic [5: 0] cnt_down_start_pack;
//logic [1: 0] cnt_shift_pack = 3;
//assign [32: 0] reg_div_crc = [32: 0] buff_data_crc;

always @(posedge clk_25Mz)
begin
	/*if (step == 4)
		begin
			buff_data_crc [3: 0] <= data_pack [3: 0];
		
		end*/

end

always @(posedge clk_100Mz)
begin
	if (step == 5)
		begin
			//cnt_shift_pack <= cnt_shift_pack - 1;
			
			buff_data_crc [32: 0] <= {buff_data_crc [31: 0], _data_pack};
					
			if (buff_data_crc [32] == 1)
				buff_data_crc [31: 0] <= buff_data_crc [31: 0] ^ CRC_DATA [31: 0];
				
			
			if (cnt_down_start_pack != 31)
				cnt_down_start_pack <= cnt_down_start_pack + 1;
			else
				cnt_down_start_pack <= 0;

			
		end else
		begin
			cnt_down_start_pack <= 0;
			//cnt_shift_pack <= 3;	
			if (step == 1)
				buff_data_crc [32: 0] <= 0;			
		
		end

		
		
end













endmodule