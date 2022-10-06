module UVA
#(
parameter DELAY = 5000000
)
(
input logic 			clk,
input logic 			_clk,
//analiz
//out.1
//LVDS to out. 1
output logic 			di_1_out,
input  logic 			do_1_in,
output logic 			clk_1_out,
output logic 			izp_1_out,
output logic			ti_1_out,
input  logic			clk_out_in,
//TTL to out.1
output logic 	[8: 0] 	addr_1_out,


//Upr. UVA
//LVDS to upr. UVA
input logic				izp_uva_in,
input logic 			im_uva_in,
//input logic 			ozs_uva_in,
output logic 			izp_uva_out,
output logic 			im_uva_out,
//TTL to upr. UVA
output logic 			zspa_uva_out,
input logic 			rspa_uva_in,
input logic 			inz_uva_in,
output logic 			ispr_uva_out,

//Upr. cont
//LVDS to upr. cont
output logic 			izp_upr_cont_out,
output logic 			im_upr_cont_out,
//TTL to upr. cont
input logic 	[7: 0]	res_ttl1_in,
output logic 	[7: 0]	res_ttl1_out,
input logic 	[3: 0] 	ispr_upr_cont_in,
input logic  	[1: 0] 	sense_upr_cont_in,
output logic 			upr_mkk_upr_cont_out,
output logic 	[2: 0]	kod_upr_pum_upr_cont_out,

//end analiz

//start obmen data
output			MDC, // PIN_31
inout			MDIO, // no tauch PIN_30 it is control micro and analiz, poprobovat'
//output			TX_CLK, it trans clk PIN_1
output			TX_EN = 1, //high lvl PIN_2
input	[3: 0]	RXD, // PIN_43-46 DATA
//input			RX_clk, // rezerv clk PIN_38 // it's in
input			RX_DV, //high lvl utvejdenie data PIN_39 check RDX line
input			RX_ER, // if high,to error PIN_41
//output	[3: 0]	TRAN_DATA, //PIN_43_46
input			CRS, //wait or no wait PIN_40
input			COL, // if errror read and write on time PIN_42
input			RX_clk,
output			X1, // GEN PIN_34
//input			X2,// GEN_2 PIN_33
input			CLK_X1, //PIN_25 kontr point!!
//LED_PIN ON LED
 //JTAG interface on kontr point
 
 //RESET
output			reset_N = 1, // 1 us
output			PWR_DOWN_INT = 1, // high, low - low energy
output	[4: 0]	PHYAD = 1, // 0 - col, izolet MII PIN_43-46

//AN_0 and AN_1, AN_EN no think, only 100BASE-TX

//MAC
//input			RX_DV, // PIN_39 
output	[3: 0]	TXD, //PIN_3 - 6

output			LED_CONFIG,
input			TX_CLK

);

assign TXD [3: 0] = TRAN_DATA [3: 0]; // !!!! it's true !!!!
assign DATA [3: 0] = RXD [3: 0]; // !!!! it's true !!!!

assign X1 = clk_25Mz;

assign CLK_testing = lets_play ? clk_25Mz : 1'b0;
//assign RX_clk = clk_25Mz;
//assign CLK_X1 = clk_25Mz;

logic [3: 0] TRAN_DATA;
logic [3: 0] DATA;
//logic clk_25Mz;
logic CLK_testing;
logic lets_play = 0;

logic [63: 0] status_channel = 64'hFFFFFFFFFFFFFFFF;

//out status
logic	[7: 0]	active_channel_res_ttl; //потом сгрупировать
logic	[7: 0]	status_sum_addr_0_6_inz;
logic	[7: 0]	status_sum_addr_7_8_zspa_ispr_kod;
logic	[7: 0]	ready_channel;

logic check_volume_data;
logic check_receive;
logic check_CRC32;
logic clk_25Mz;
logic clk_100Mz; 
logic clk_1Mz;

logic [23: 0] cnt_clock_time;
/*
assign status_channel [63: 56] = active_channel_res_ttl [7: 0];
assign status_channel [55: 48] = status_sum_addr_0_6_inz [7: 0];
assign status_channel [47: 40] = status_sum_addr_7_8_zspa_ispr_kod [7: 0];
assign status_channel [39: 32] = ready_channel [7: 0];

assign status_channel [0] = check_volume_data;
assign status_channel [1] = check_receive;
assign status_channel [2] = check_CRC32;
*/
initial
status_channel [63: 0] = 64'hFFFFFFFFFFFFFFFF;

pll_UVA pll 
(
	.areset(),
	.inclk0(clk),
	.c0(clk_25Mz),
	.c1(clk_100Mz), 
	.c2(clk_1Mz),
	.locked()
);

RES_TTL1 res_ttl1 
(
	.clk_100Mz(clk_100Mz),
	.clk_1Mz(clk_1Mz),
	.res_ttl1_in(res_ttl1_in),
	.res_ttl1_out(res_ttl1_out),
	.active_channel_res_ttl(active_channel_res_ttl)

);

LVDS_IN_STATUS lvds_in_status 
(
	.clk_100Mz(clk_100Mz),
	.clk_1Mz(clk_1Mz),
	
	.j(j),
	.cnt_check_channel(cnt_check_channel),
	.cnt_1Mz(cnt_1Mz),
	//.branch_channel(upr_mkk_upr_cont_out),
	
	.clk_out_in(clk_out_in),
	.izp_uva_in(izp_uva_in),
	.im_uva_in(im_uva_in),
	.do_1_in(do_1_in),

	.ready_channel(ready_channel)

);

LVDS_SOLO_LINE lvds_solo_line 
(
	.clk_100Mz(clk_100Mz),
	.clk_1Mz(clk_1Mz),
	
	.j(j),
	//.branch_channel(upr_mkk_upr_cont_out),
	
	.lvds_0(izp_1_out),
	.lvds_1(izp_uva_out),
	.lvds_2(im_uva_out),
	.lvds_3(ti_1_out),
	.lvds_4(clk_1_out),
	.lvds_5(izp_upr_cont_out),
	.lvds_6(im_upr_cont_out),
	.lvds_7(di_1_out)
		
);

TTL_LINE ttl_line  // check
(
	.clk_100Mz(clk_100Mz),
	.clk_1Mz(clk_1Mz),
	
	.ispr_upr_cont_in(ispr_upr_cont_in),
	.rspa_uva_in(rspa_uva_in),
	.sense_upr_cont_in(sense_upr_cont_in),
	
	.addr_1_out(addr_1_out),
	.zspa_uva_out(zspa_uva_out),
	.ispr_uva_out(ispr_uva_out),
	.kod_upr_pum_upr_cont_out(kod_upr_pum_upr_cont_out),
    
	.j(j),
	.cnt_check_channel(cnt_check_channel),
	.cnt_1Mz(cnt_1Mz),
	
	.branch_channel(upr_mkk_upr_cont_out),
	.inz_uva_in(inz_uva_in),
    
   	.status_sum_addr_7_8_zspa_ispr_kod(status_sum_addr_7_8_zspa_ispr_kod),
	.status_sum_addr_0_6_inz(status_sum_addr_0_6_inz)

); 

Ethernet_100Base Ethernet_100Base
(
	.clk_100Mz(clk_100Mz),
	.clk_1Mz(clk_1Mz),
	.clk_25Mz(CLK_testing),
	
	.MDC(MDC),
	.MDIO(MDIO),
	.TX_EN(TX_EN),
	.TRAN_DATA(TRAN_DATA),
	.TX_CLK(TX_CLK),
	.status_channel(status_channel),	
	
	
	//.TX_EN(TX_EN),
	.DATA(DATA),
	//.RX_clk(RX_clk),
	.RX_DV(RX_DV),
	.RX_ER(RX_ER),
	//.TRAN_DATA(TRAN_DATA),	
	.CRS(CRS),	
	.COL(COL),
	
	.clk_in_data(RX_clk),
	
	.PWR_DOWN_INT(PWR_DOWN_INT),
	
	.PHYAD(PHYAD),
	

	.LED_CONFIG(LED_CONFIG),
	
	/*.buff_data_0(buff_data_0),
	.buff_data_1(buff_data_1),
	.buff_data_2(buff_data_2),
	.buff_data_3(buff_data_3),
	.buff_data_4(buff_data_4),
	.buff_data_5(buff_data_5),
	.buff_data_6(buff_data_6),
	.buff_data_7(buff_data_7),*/
	
	.check_volume_data(check_volume_data),
	.check_receive(check_receive),
	.check_CRC32(check_CRC32),
	.reset_N(reset_N)
	
	
);

always @(posedge clk_1Mz)
if (cnt_clock_time == (DELAY - 1))
	lets_play <= 1;
else
	cnt_clock_time <= cnt_clock_time + 1;	





endmodule