`timescale 1ns/1ns
module downling_data_100Base_tb();

logic	clk_100Mz;
logic	clk_1Mz;
logic	clk_25Mz;
	
logic			TX_EN;
logic			start_work;
logic			check_good_work;
logic	[63: 0]	status_channel;
	
logic	[31: 0]	buff_data_crc;
	
logic	[3: 0]	data_pack;
	
logic			check_volume_data;
logic			check_receive;
	
logic			CRS;
		
logic	[15: 0]	reg_MDIO_RD;

logic 	[3: 0] cnt_clk_100;
logic 	[5: 0] cnt_clk_25;


Ethernet_100Base DUT(clk_100Mz, clk_1Mz, clk_25Mz,  MDC, MDIO, TX_EN, DATA, RX_clk, RX_DV, RX_ER, TRAN_DATA, CRS, COL, CLK_OUT, RESET_N, PWR_DOWN_INT, PHYAD, LED_CONFIG, MDIX_EN, buff_data_0, buff_data_1, buff_data_2, buff_data_3, buff_data_4, buff_data_5, buff_data_6, buff_data_7, status_channel, check_volume_data, check_receive, check_CRC32);


initial
begin
status_channel [63: 0] = 64'hFFFFFFFF00000000;
buff_data_crc [31: 0] = 32'ha7e31749;
CRS = 1;
//TX_EN = 1;
start_work = 1;
check_good_work = 1;
reg_MDIO_RD = 0;


end

always
begin
if (cnt_clk_100 == 39)
	cnt_clk_100 <= 0;
else	
	cnt_clk_100 <= cnt_clk_100 + 1;
	
if (cnt_clk_25 == 9)
	cnt_clk_25 <= 0;
else	
	cnt_clk_25 <= cnt_clk_25 + 1;	
	
if (cnt_clk_100 < 19)
	clk_25Mz <= 1;
else
	clk_25Mz <= 0;
	
	
if (cnt_clk_25 < 4)
	clk_100Mz <= 1;
else
	clk_100Mz <= 0;	
	
	
	
	
	
	
end






/*
always
#20 clk_25Mz = ~clk_25Mz;


always 
#5 clk_100Mz = ~clk_100Mz;

*/

initial
begin
$dumpfile("out.vcd");
$dumpvars(0, DUT);

end

initial
$monitor($stime,, clk_100Mz,,, clk_25Mz,,, data_pack,, TX_EN,, start_work,, check_good_work,, status_channel,, buff_data_crc,, check_volume_data,, check_receive,, CRS,, reg_MDIO_RD);



endmodule