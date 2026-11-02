`timescale 1ns/1ps
// Verification-only wrapper; DUT modules retain the complete 25,000,000-cycle setting.
module full_count_top(
    input wire sys_clk, sys_rst_n,
    output wire counter_led,
    output wire [3:0] running_led,
    output wire [24:0] counter_cnt, running_cnt
);
    counter counter_dut(.sys_clk(sys_clk), .sys_rst_n(sys_rst_n), .led_out(counter_led));
    running_light running_dut(.sys_clk(sys_clk), .sys_rst_n(sys_rst_n), .led_out(running_led));
    assign counter_cnt = counter_dut.cnt;
    assign running_cnt = running_dut.cnt;
endmodule
