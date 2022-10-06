`timescale 1ns/1ns
module DOWNLING_DATA_100BASE_tb ();

logic	clk_100Mz;
logic	clk_1Mz;
logic	clk_25Mz;
logic		TX_EN;
logic		start_work;
logic	check_good_work;
logic [63: 0]	status_channel;

logic [31: 0]	buff_data_crc;

logic	data_pack;

logic	check_volume_data;
logic	check_receive;

logic		CRS;
logic		_data_pack; 
//assign reg_MDIO_RD = _reg_MDIO_RD;
reg [15: 0]	reg_MDIO_RD;
//reg [15: 0] _reg_MDIO_RD;

logic 	[3: 0] cnt_clk_100;
logic 	[5: 0] cnt_clk_25;
logic	[63: 0] buff_data_0;

DOWNLING_DATA_100BASE DUDE (clk_100Mz, clk_1Mz, clk_25Mz, TX_EN, start_work, check_good_work, status_channel, buff_data_crc, data_pack, check_volume_data, check_receive, CRS, reg_MDIO_RD, _data_pack, buff_data_0);
reg [15: 0] _reg_MDIO_RD;


initial
begin
status_channel [63: 0] = 64'hFFFFFFFF00000000;
buff_data_crc [31: 0] = 32'ha7e31749;
CRS = 1;
TX_EN = 1;
start_work = 0;
//check_good_work = 1;
//buff_data_0 = 64'h4000000000;
clk_100Mz = 1;
clk_25Mz = 1;
_reg_MDIO_RD = 16'hFFFF;
#40
start_work = 1;

end

always 
begin
#5
clk_100Mz <= 0;
#5 
clk_100Mz <= 1;
 
end

always
begin
#20
clk_25Mz <= 0;
#20
clk_25Mz <= 1;


end
/*
always
start_work <= 1;
#1	*/

initial
begin
$dumpfile("out.vcd");
$dumpvars(0, DUDE);

end


initial
$monitor($stime,, clk_100Mz,,, data_pack);

initial begin
#10000 $stop;
end






endmodule