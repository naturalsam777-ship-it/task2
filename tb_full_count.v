`timescale 1ns / 1ns
module tb_full_count;
    reg sys_clk = 1'b0;
    reg sys_rst_n = 1'b1;
    wire blink;
    wire [3:0] run;
    reg [31:0] cycle = 32'd0;
    reg [31:0] phase;
    reg [3:0] expected_run;
    integer fd;
    counter a(sys_clk,sys_rst_n,blink);
    running_light b(sys_clk,sys_rst_n,run);
    always #10 sys_clk=~sys_clk;
    initial begin
        fd=$fopen("evidence/full_count_results.csv","w");
        $fdisplay(fd,"time_ns,active_cycles,counter_cnt,running_cnt,blink,run");
        if (a.COUNT_MAX !== 25'd24999999 || b.COUNT_MAX !== 25'd24999999)
            $fatal(1,"Default count incorrect");
        #1 sys_rst_n=1'b0;
        #24 sys_rst_n=1'b1;
        repeat(100000000) begin
            @(posedge sys_clk);
            cycle=cycle+32'd1;
            if ((cycle % 32'd25000000)==0 || (cycle % 32'd25000000)==24999999) begin
                #1;
                phase=cycle/32'd25000000;
                expected_run=~(4'b0001 << (phase % 32'd4));
                if (a.cnt !== 25'(cycle%32'd25000000) || b.cnt !== a.cnt || blink !== phase[0] || run !== expected_run)
                    $fatal(1,"Default-count boundary failed at cycle %0d",cycle);
                $fdisplay(fd,"%0t,%0d,%0d,%0d,%b,%b",$time,cycle,a.cnt,b.cnt,blink,run);
            end
        end
        $display("PASS full_count: 100000000 active cycles, four 0.5 s intervals and running-light wrap");
        $fclose(fd); $finish;
    end
endmodule
