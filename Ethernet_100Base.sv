module Ethernet_100Base
(
		input	clk_100Mz,
		input	clk_1Mz,
		input	clk_25Mz,
		
		output			MDC,
		inout			MDIO, // no tauch PIN_30 it is control micro and analiz, poprobovat'
		//output			TX_CLK, it trans clk PIN_1
		output			TX_EN = 1, //high lvl PIN_2
		input	[3: 0]	DATA, // PIN_43-46 // !!!! it's true !!!!
		//input			RX_clk, // rezerv clk PIN_38
		input			RX_DV, //high lvl utvejdenie data PIN_39 for analiz, it for check data input
		input			RX_ER, // if high,to error PIN_41, lost realiz trans in PC
		output	[3: 0]	TRAN_DATA, //PIN_3_6 !!!! it's true !!!!
		input			CRS, //wait or no wait PIN_40
		input			COL, // if errror read and write on time PIN_42
		input			TX_CLK,
		//output			X1 GEN PIN_34
		//output			X2 GEN_2 PIN_33
		input			clk_in_data, //PIN_38 read data, sinhr RX_clk
		//LED_PIN ON LED
		 //JTAG interface on kontr point
		 
		 //RESET
		output			reset_N, // 1 us
		output			PWR_DOWN_INT,
		output	[4: 0]	PHYAD, // 0 - col, izolet MII
		
		//AN_0 and AN_1, AN_EN no think, only 100BASE-TX
		
		//MAC
		//output			RX_DV = 0, // PIN_39 
	//	output			TXD_3 = 1'z, //PIN_6
		
		output			LED_CONFIG,
		
		
		
		//data input PC
		
		/*output	[63: 0] buff_data_0,
		output  [63: 0] buff_data_1,
		output  [63: 0] buff_data_2,
		output  [63: 0] buff_data_3,
		output  [63: 0] buff_data_4,
		output  [63: 0] buff_data_5,
		output  [63: 0] buff_data_6,
		output  [63: 0] buff_data_7,*/
		
		input	[63: 0] status_channel,
		
		output			check_volume_data,
		output			check_receive,
		output 			check_CRC32
		
		
		
		
);
wire data_pack;
wire _data_pack;
//assign [3: 0] TRAN_DATA = [3: 0] data_pack; // on PC
logic [3: 0] data_in;
assign data_in [3: 0] = DATA [3: 0]; // on FPGA
//assign status_channel [2: 0] = {check_CRC32, check_receive, check_volume_data};
//assign status_channel [1] = check_receive;
//assign status_channel [2] = check_CRC32;
logic 	[63: 0] buff_data_0;
logic   [63: 0] buff_data_1;
logic   [63: 0] buff_data_2;
logic   [63: 0] buff_data_3;
logic   [63: 0] buff_data_4;
logic   [63: 0] buff_data_5;
logic   [63: 0] buff_data_6;
logic   [63: 0] buff_data_7 =  64'hFFFFFFFFFFFFFFFF;

logic [2: 0] step;

wire [31: 0] buff_data_crc;

wire [2: 0] state_in;


//logic [2: 0] status_channel;
initial
begin
buff_data_0 [38] = 1'b1;
buff_data_0 [44] = 1'b1;
buff_data_7 [63: 0]  =  64'hFFFFFFFFFFFFFFFF;

end


UVA_TRANSMIT uva_transmit //
(
	.clk_100Mz(clk_100Mz),
	.clk_1Mz(clk_1Mz),
	.clk_25Mz(TX_CLK),
	
	.data_pack(data_pack),
	.sinhr(sinhr),
	
	.TRAN_DATA(TRAN_DATA)

);

//wire data_pack;

UVA_RECEIVE uva_receive
(
	.clk_100Mz(clk_100Mz),
	.clk_1Mz(clk_1Mz),
	.clk_25Mz(clk_in_data), //clk_25Mz
	
	.data_in(data_in),
	.RX_ER(RX_ER),
	.CRS(CRS),
	//.start_work(start_work),
	.RX_DV(RX_DV),
	.state_in(state_in),

	.buff_data_crc_in(buff_data_crc_in),
	
	.check_CRC32(check_CRC32),
	
	.buff_data_0(buff_data_0),
	.buff_data_1(buff_data_1),
	.buff_data_2(buff_data_2),
	.buff_data_3(buff_data_3),
	.buff_data_4(buff_data_4),
	.buff_data_5(buff_data_5),
	.buff_data_6(buff_data_6),
	.buff_data_7(buff_data_7)

);

DOWNLING_DATA_100BASE downling_data_100base //otpravka
(
	.clk_100Mz(clk_100Mz),
	.clk_1Mz(clk_1Mz),
	.clk_25Mz(clk_25Mz),
	
	.start_work(good_work && sign_reset),
	.check_good_work(check_good_work),
	.status_channel(status_channel),
	.TX_EN(TX_EN),
	.data_pack(data_pack),
		
	.sinhr(sinhr),
	.step(step),
	._data_pack(_data_pack),
	.buff_data_crc(buff_data_crc),
	.check_receive(check_receive),
	.check_volume_data(check_volume_data),
	.reg_MDIO_RD(reg_MDIO_RD),
	.CRS(CRS),
	.buff_data_0(buff_data_0)

);

PHYSI_WORK_ETHERNET physi_work_ethernet
(
	.clk_100Mz(clk_100Mz),
	.clk_1Mz(clk_1Mz),
	.clk_25Mz(clk_25Mz),
	
	.buff_data_0(buff_data_0),
	.state(state),
	.good_work(good_work),
	.sign_reset(sign_reset),
	//.first_good_work(first_good_work),
	.MDC(MDC),

	.reset_N(reset_N),
	.first_start(first_start)

);

CRC_32 crc_32
(
	.clk_100Mz(clk_100Mz),
	.clk_1Mz(clk_1Mz),
	.clk_25Mz(clk_in_data), //clk_25Mz
	
	._data_pack(_data_pack),
	.DATA(TRAN_DATA),
	.step(step),
	.buff_data_crc(buff_data_crc)

);

CRS_32_IN crs_32_in //opechatka CRC
(
	.clk_100Mz(clk_100Mz),
	.clk_1Mz(clk_1Mz),
	.clk_25Mz(clk_in_data), //clk_25Mz
	
	.state_in(state_in),
	
	.data_in(data_in),
	.DATA(DATA),
	//.step(step),
	.buff_data_crc_in(buff_data_crc_in)
	
);

analiz_dp83848 analiz_dp83848
(
	.clk_100Mz(clk_100Mz),
	.clk_1Mz(clk_1Mz),
	.clk_25Mz(clk_25Mz),

	.MDIO(MDIO),
	.state(state),	
    .buff_data_0(buff_data_0),
        
    .reg_MDIO_RD(reg_MDIO_RD)

);


always @(posedge clk_25Mz)
PWR_DOWN_INT <= 1;













endmodule