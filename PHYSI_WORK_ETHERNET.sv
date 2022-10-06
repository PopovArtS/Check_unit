module PHYSI_WORK_ETHERNET
#(
	parameter PARAM_RESET = 39,
	//parameter ZADER_SEC = 160000000,
	parameter CLK_32_MDC = 33,
	parameter CNT_RESET = 25,
	parameter CNT_PAUSE_RESET_N = 75,
	parameter CNT_POWER_UP = 4175000,
	parameter DELAY = 3000000
)
(
	input	clk_100Mz,
	input	clk_1Mz,
	input	clk_25Mz,
	
	//output check_reg_dp,
	input [63: 0] buff_data_0,
	
	
	output	logic	buff_start = 0,

	output	logic	buff_reset = 0,
	
	//input			first_good_work,
	//input			flag_end_comad_diag,
	output	logic	first_start = 0,
	input	[2: 0]	state,
	output	logic	good_work,
	output	logic	sign_reset,
	output			reset_N = 1,
	output	logic	MDC
	
);

assign MDC = check_reg_dp ? clk_25Mz : 1'b0;
assign MDC_testing = check_time_delay ? clk_25Mz : 1'b0;

logic check_reg_dp;
logic start_work;

logic [6: 0] cnt_RESET_N = 0;
logic [23: 0] cnt_start_power = 0;

logic start_reset;


logic [4: 0] cnt_MDC = 0;
logic [23: 0] cnt_power_start = 0;
logic [11: 0] cnt_MDC_start = 0;
logic [7: 0] cnt_pause_reset = 0;



logic [23: 0] cnt_time_delay = 0;
logic check_time_delay;
logic MDC_testing;

initial
begin
start_work = 0;
sign_reset = 1;

end

always @(posedge clk_25Mz)//clk_25Mz
if (((first_start == 1) || ((cnt_MDC_start > 0) && (cnt_MDC_start < CLK_32_MDC)) || (buff_data_0 [38] == 1)))
begin		
	if (cnt_MDC_start == (CLK_32_MDC - 1))
	begin
		check_reg_dp <= 0;
		cnt_MDC_start <= 0;
		//first_good_work <= 1;
		
	end else
	begin
		check_reg_dp <= 1;
		cnt_MDC_start <= cnt_MDC_start + 1;
		//first_good_work <= 1;
		
	end
	
	if (buff_data_0 [36] == 0)
		good_work <= 1;
	else
		good_work <= 0;
		
end


always @(posedge clk_25Mz) //first start
if (cnt_power_start == CNT_POWER_UP)
	start_work <= 0;
else begin
	cnt_power_start <= cnt_power_start + 1;
	
	if (cnt_power_start == (CNT_POWER_UP - 1))
		start_work <= 1;
		
end


always @(posedge clk_25Mz) //block MDC
begin
	buff_reset <= start_reset;
	buff_start <= start_work;
	
	if ((buff_start != start_work) || (buff_reset != start_reset))
		first_start <= 1;
	else
		first_start <= 0;

end


always @(posedge clk_25Mz) //block reset
begin
if ((buff_data_0 [37] == 1) && (state == 1) || ((cnt_RESET_N > 0) && (cnt_RESET_N < CNT_RESET)))
begin
	cnt_RESET_N <= cnt_RESET_N + 1;
	sign_reset <= 0;
	
end else
begin
	cnt_RESET_N <= 0;

end	

if ((cnt_RESET_N == (CNT_RESET - 1)) || ((cnt_pause_reset > 0)) && (cnt_pause_reset < CNT_PAUSE_RESET_N))
	cnt_pause_reset <= cnt_pause_reset + 1;
else
	cnt_pause_reset <= 0;
	
if (cnt_pause_reset == (CNT_PAUSE_RESET_N - 1))	
begin
	start_reset <= 1;
	sign_reset <= 1;
end else
	start_reset <= 0;

if ((cnt_RESET_N > 0) && (cnt_RESET_N < CNT_RESET))
	reset_N <= 0;
else
	reset_N <= 1;
	

end
/*
always @(posedge clk_1Mz)
if (cnt_time_delay == (DELAY - 1))
	check_time_delay <= 1;
else
	cnt_time_delay <= cnt_time_delay + 1;

*/





/*
always @(posedge clk_100Mz)
if (/*(state != 0) & (first_start == 1)) //if start or reset
begin
	if (finish_MDC == 1)
		if (i > 1)
			MDC <= 1;
		else
			MDC <= 0;
	else
		MDC <= 0;
	
	
	
	if (i == 3)
		check_cnt_MDC <= check_cnt_MDC + 1;
		
	if (check_cnt_MDC == 31)
		finish_MDC <= 1;
		
	i <= i + 1;		
end else
	begin
		finish_MDC <= 0;
		//if (flag_end_comad_diag == 1)
			MDC <= clk_25Mz;
			
	end	



always @(posedge clk_25Mz)
if (cnt_zad_sec == (ZADER_SEC - 1))
begin
	if ((cnt_start_power == (START_POWER - 1)) && (finish_MDC == 1))
		start_work <= 1;
	else
		cnt_start_power <= cnt_start_power + 1;	
	
	if ((buf_reset_dp == 1) && (cnt_RESET_N != 39))
		reset_N <= 0;
	
	if (reset_N == 0)
		begin
			cnt_RESET_N <= cnt_RESET_N + 1;
			start_work <= 0;
		end
	
	if (cnt_RESET_N == (PARAM_RESET - 1))
		begin
			start_work <= 1;
			reset_N <= 1; //optim
			cnt_RESET_N <= 0;
						
		end	
		
	buff_start <= start_work;
	buff_reset <= reset_N;
	
	if ((buff_start != start_work) && (buff_reset != reset_N) && (state == 0))
		first_start <= 1;
	
	if ((state != 0) || (finish_MDC == 1))
		first_start <= 0;
end else
	cnt_zad_sec <= cnt_zad_sec + 1;

*/

endmodule