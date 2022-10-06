module LVDS_IN_STATUS
(
	input clk_100Mz,
	input clk_1Mz,
	
	input 			clk_out_in,
	input 			izp_uva_in,
	input			im_uva_in,
	input			do_1_in,
	/*
	output			izp_upr_cont_out,
	output			im_upr_cont_out,
	output			di_1_out,
	output			izp_1_out,
	*/
	output	[3: 0]	ready_channel
	

);


logic [1: 0] status [1: 0]; //check, but read 
logic [1: 0] j;
logic [3: 0] cnt_check_clk_1Mz = 0;
logic choose_channel = 0;
logic [3: 0] cnt_sum_status_0 = 0;
logic [3: 0] cnt_sum_status_1 = 0;
//logic [1: 0] group_izp_clk = 0;
//logic [1: 0] group_im_do = 0;
logic [1: 0] big_group_izpclk_imdo = 0;

//assign group_izp_clk = ({izp_uva_in, clk_out_in});
//assign group_im_do = ({im_uva_in, do_1_in});

genvar i;
generate
	for (i = 0; i < 5; i = i + 1) 
	begin : gerator
		LVDS_STATUS lvds_status
		(
			.clk_fpga(clk_100Mz),
			.clk_in(big_group_izpclk_imdo[i]),
			
			.choose_channel(choose_channel),
			.status(status[i])
		);
	end
	
	always @(posedge clk_100Mz)
		begin
			/*
			if (choose_channel == 0)
				begin
					im_upr_cont_out <= clk_1Mz;
					izp_upr_cont_out <= clk_1Mz;
					//j <= 0;
				end else
				begin
					//j <= 1;
					im_upr_cont_out <= 0;
					izp_upr_cont_out <= 0;					
				end
		
			if (choose_channel == 1)
				begin
					di_1_out <= clk_1Mz;
					izp_1_out <= clk_1Mz;
				end else
				begin
					di_1_out <= 0;
					izp_1_out <= 0;					
				end*/
				
			if (cnt_check_clk_1Mz > 12)
				if (choose_channel == 0)
					begin
						if (cnt_sum_status_0 > 12)
							ready_channel [0] <= 1;
						else
							ready_channel [0] <= 0;
							
						if (cnt_sum_status_1 > 12)
							ready_channel [1] <= 1; 
						else
							ready_channel [1] <= 0; 
					end else
					begin
						if (cnt_sum_status_0 > 12)
							ready_channel [2] <= 1;
						else
							ready_channel [2] <= 0;
							
						if (cnt_sum_status_1 > 12)
							ready_channel [3] <= 1; 
						else
							ready_channel [3] <= 0;
					end
			/*
			if (choose_channel == 0)
				big_group_izpclk_imdo <= {izp_uva_in, clk_out_in};
			else
				big_group_izpclk_imdo <= {im_uva_in, do_1_in};
		*/

		
		
		end
		
	always @(posedge clk_1Mz)
		begin
			cnt_check_clk_1Mz <= cnt_check_clk_1Mz + 1;
			
			if (cnt_check_clk_1Mz == 7) // 0
				begin
					choose_channel <= choose_channel + 1;
					cnt_sum_status_0 <= 0;
					cnt_sum_status_1 <= 0;
					
				end
			

		
			if (status [j])
				cnt_sum_status_0 <= cnt_sum_status_0 + 1;
				
			if (status [j] [choose_channel] == 1)
				cnt_sum_status_1 <= cnt_sum_status_1 + 1;
			
			
		


			if (status [j] [choose_channel] == 1)
				cnt_sum_status_0 <= cnt_sum_status_0 + 1;
					
			if (status [j] [choose_channel] == 1)
				cnt_sum_status_1 <= cnt_sum_status_1 + 1;

			
		
		end
			
			
endgenerate
endmodule		