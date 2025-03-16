`timescale 1ns/1ps

module top_testbench();

    reg clk;

    wire led1;
    wire ftdi_rx;
    wire ftdi_tx;

    top dut(
        // input hardware clock (12 MHz)
        .hwclk(clk),
        // all LEDs
        .led1(led1),
        // UART lines
        .ftdi_rx(ftdi_rx),
        .ftdi_tx(ftdi_tx)
    );

    initial
    begin
        $dumpfile("build/aout.vcd");

        $dumpvars(0, clk);
        $dumpvars(0, led1);
        $dumpvars(0, ftdi_rx);
        $dumpvars(0, ftdi_tx);

        #500 $finish();
        //#4000 $finish();
    end

    // generate clock to sequence tests
    always
    begin
        $display("tick %d", $time);
        clk <= 1;
        #1;
        clk <= 0;
        #1;
    end

endmodule