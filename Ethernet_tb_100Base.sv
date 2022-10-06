`timescale 1ns/1ns
module Ethernet_tb_100Base();

logic	clk_100Mz,
logic	clk_1Mz,
logic	clk_25Mz,
		
logic		MDC;
logic		MDIO; // no tauch PIN_30 it is control micro and analiz, poprobovat'
logic		TX_EN; //high lvl PIN_2
logic [3: 0]	DATA; // PIN_43-46 // !!!! it's true !!!!
logic			RX_clk; // rezerv clk PIN_38
logic			RX_DV; //high lvl utvejdenie data PIN_39
logic				RX_ER; // if high,to error PIN_41
logic [3: 0]	TRAN_DATA; //PIN_3_6 !!!! it's true !!!!
logic			CRS; //wait or no wait PIN_40
logic			COL; // if errror read and write on time PIN_42

logic			RESET_N; // 1 us
logic			PWR_DOWN_INT;
logic [4: 0]	PHYAD; // 0 - col, izolet MII

		
logic			LED_CONFIG;
		
logic			MDIX_EN; // initial active 
		

		
logic [63: 0] buff_data_0;
logic [63: 0] buff_data_1;
logic [63: 0] buff_data_2;
logic [63: 0] buff_data_3;
logic [63: 0] buff_data_4;
logic [63: 0] buff_data_5;
logic [63: 0] buff_data_6;
logic [63: 0] buff_data_7;
		
logic [63: 0] status_channel;
		
logic	check_volume_data;
logic	check_receive;
logic	check_CRC32;

counter DUT(clk_100Mz, clk_25Mz, TX_EN, DATA, RX_clk, RX_DV, TRAN_DATA, CRS, COL, PWR_DOWN_INT, PHYAD, MDIX_EN);

initial 
begin
	RESET_N = 0;
	RX_DV = 1;
//	status_channel = 64'hFFFFFFFF00000000;

end

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



initial begin
#10000 $stop;
end









endmodule