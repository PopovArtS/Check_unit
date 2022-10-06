module LVDS_SOLO_LINE
(
	input clk_100Mz,
	input clk_1Mz,
	
	input [2: 0] j,
	//input				branch_channel,
	
	output	logic		lvds_0,
	output	logic		lvds_1,
	output	logic		lvds_2,
	output	logic		lvds_3,
	output	logic		lvds_4,
	output	logic		lvds_5,
	output	logic		lvds_6,
	output	logic		lvds_7
	
	
	
);
/*
logic [2: 0] flag_next_lvds;
logic [2: 0] cnt_next_channel;
*/


always @(posedge clk_100Mz)
begin	
	case (j)
	
	0:	begin
			lvds_0 <= clk_100Mz;
			lvds_1 <= 0;
			lvds_2 <= 0;
			lvds_3 <= 0;
			lvds_4 <= 0;
			lvds_5 <= 0;
			lvds_6 <= 0;
			lvds_7 <= 0;
		end
	1:	begin
			lvds_0 <= 0;
			lvds_1 <= clk_100Mz;
			lvds_2 <= 0;
			lvds_3 <= 0;
			lvds_4 <= 0;
			lvds_5 <= 0;
			lvds_6 <= 0;
			lvds_7 <= 0;
		end
	2:	begin
			lvds_0 <= 0;
			lvds_1 <= 0;
			lvds_2 <= clk_100Mz;
			lvds_3 <= 0;
			lvds_4 <= 0;
			lvds_5 <= 0;
			lvds_6 <= 0;
			lvds_7 <= 0;
		end
	3:	begin
			lvds_0 <= 0;
			lvds_1 <= 0;
			lvds_2 <= 0;
			lvds_3 <= clk_100Mz;
			lvds_4 <= 0;
			lvds_5 <= 0;
			lvds_6 <= 0;
			lvds_7 <= 0;
		end
	4:	begin
			lvds_0 <= 0;
			lvds_1 <= 0;
			lvds_2 <= 0;
			lvds_3 <= 0;
			lvds_4 <= clk_100Mz;
			lvds_5 <= 0;
			lvds_6 <= 0;
			lvds_7 <= 0;
		end
	5:	begin
			lvds_0 <= 0;
			lvds_1 <= 0;
			lvds_2 <= 0;
			lvds_3 <= 0;
			lvds_4 <= 0;
			lvds_5 <= clk_100Mz;
			lvds_6 <= 0;
			lvds_7 <= 0;
		end
	6:	begin
			lvds_0 <= 0;
			lvds_1 <= 0;
			lvds_2 <= 0;
			lvds_3 <= 0;
			lvds_4 <= 0;
			lvds_5 <= 0;
			lvds_6 <= clk_100Mz;
			lvds_7 <= 0;
		end
	7:	begin
			lvds_0 <= 0;
			lvds_1 <= 0;
			lvds_2 <= 0;
			lvds_3 <= 0;
			lvds_4 <= 0;
			lvds_5 <= 0;
			lvds_6 <= 0;
			lvds_7 <= clk_100Mz;
		end

	endcase
	
end
/*
always @(posedge clk_1Mz)
begin
	if (j == 7)
		cnt_next_channel <= 0;
	else
		cnt_next_channel <= cnt_next_channel + 1;
	
	if (cnt_next_channel == 7)
		flag_next_lvds <= flag_next_lvds + 1;	
end

*/

endmodule