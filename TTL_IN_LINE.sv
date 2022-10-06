module TTL_IN_LINE 
(
	input 	logic 			clk_fpga, //clk 100 MHz
	//input	logic			j,
	input	logic			branch_channel,
	input	logic			clk_in, //clk 1 MHz
	output	logic			data_1,
	output	logic			data_0
);

localparam MIN_cnt = 40;
localparam WATCHDOG_TIME = 144;

logic	[6: 0] 	cnt_positive;
logic 	[6: 0] 	cnt_negative;
logic 	[7: 0]	cnt_watchdog;

logic	[6: 0]	status_positive;
logic	[6: 0]	status_negative;
logic	[6: 0]	status_watchdog;
logic 			flag_edge;
logic			prev_flag_edge;
/*
logic [7: 0] data;
logic [7: 0] status_kz;*/

always @(posedge clk_fpga)
begin
	flag_edge <= clk_in;
	prev_flag_edge <= flag_edge;
end

always @(posedge clk_fpga)
begin
	if (flag_edge)
	begin
		cnt_negative <= 0;
		cnt_positive <= cnt_positive + 1;
		if(flag_edge != prev_flag_edge)
		begin
			status_negative <= (cnt_negative > MIN_cnt) ? 1 : 0;
		end
	end
	else
	begin
		cnt_positive <= 0;
		cnt_negative <= cnt_negative + 1;
		if(flag_edge != prev_flag_edge)
		begin
			status_positive <= (cnt_positive > MIN_cnt) ? 1 : 0;
		end
	end
end

always @(posedge clk_fpga)
begin
	if (prev_flag_edge == flag_edge)
	begin
		if(cnt_watchdog != WATCHDOG_TIME)
		begin
			cnt_watchdog <= cnt_watchdog + 1;
			status_watchdog <= 1;
		end
		else
		begin
			status_watchdog <= 0;
		end
	end
	else
	begin
		cnt_watchdog <= 0;
		status_watchdog <= 1;
	end
end




always @(posedge clk_fpga)
begin
	if (branch_channel == 1)
		data_1 <= (status_positive & status_watchdog) ? 1 : 0;
	else
		data_0 <= (status_negative & status_watchdog) ? 1 : 0;
end 

endmodule