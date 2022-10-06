module clk_reciver
(
	input 	logic 			clk_fpga, //clk 100 MHz
	input	logic			clk_in, //clk 1 MHz
	input	logic			choose_channel,
	
	output	logic	[1: 0]	status //status
);

localparam MIN_cnt = 44;
localparam WATCHDOG_TIME = 150;

logic	[5: 0] 	cnt_positive;
logic 	[5: 0] 	cnt_negative;
logic 	[7: 0]	cnt_watchdog;
logic			status_positive;
logic			status_negative;
logic			status_watchdog;
logic 			flag_edge;
logic			prev_flag_edge;

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
		if (flag_edge != prev_flag_edge)
		begin
			status_negative <= (cnt_negative > MIN_cnt) ? 1 : 0;
		end
	end
	else
	begin
		cnt_positive <= 0;
		cnt_negative <= cnt_negative + 1;
		if (flag_edge != prev_flag_edge)
		begin
			status_positive <= (cnt_positive > MIN_cnt) ? 1 : 0;
		end
	end
end

always @(posedge clk_fpga)
begin
	if (prev_flag_edge == flag_edge)
	begin
		if (cnt_watchdog != WATCHDOG_TIME)
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
	end
end


always @(posedge clk_fpga)
begin
	if (choose_channel == 0)
		status [0] <= (status_negative & status_positive & status_watchdog) ? 1 : 0;//status
	else
		status [1] <= (status_negative & status_positive & status_watchdog) ? 1 : 0;//status
end 

endmodule
