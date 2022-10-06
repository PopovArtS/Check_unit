module UVA_TRANSMIT
(
	input	clk_100Mz,
	input	clk_1Mz,
	input	clk_25Mz,
	
	input	data_pack, //initial = 0;
	//output [3: 0] buff_transmit = 0,
	input	sinhr,
	output 	[15: 0] cnt_check_data = 0,
	
	output	 [3: 0]	TRAN_DATA
	
);

logic write_data;
logic [3: 0] buff_transmit = 0;
//logic [15: 0] cnt_check_data = 0;
//assign TRAN_DATA [3: 0] = {buff_transmit [2: 0], data_pack};

//module for tranzit
always @(posedge clk_100Mz)
begin
if (sinhr == 1)
	write_data <= 1;

/*if (write_data == 1)
begin*/
	buff_transmit [3] <= buff_transmit [2];
	buff_transmit [2] <= buff_transmit [1];
	buff_transmit [1] <= buff_transmit [0];
	buff_transmit [0] <= data_pack;

//end
end

always @(posedge clk_25Mz) //posedge
//if (write_data == 1)
begin
	TRAN_DATA [3: 0] <= {buff_transmit [2: 0], data_pack};
	if (write_data == 1)
		cnt_check_data <= cnt_check_data + 1;

end


endmodule