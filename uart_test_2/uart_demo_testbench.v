// 10 MHz == 10000000 ticks per second // Every tick is 100 ns
// 12 Mhz == 12000000 ticks per second // Every tick is 83.333333333333328596 ns

// 9600 baud means, 9600 bits per second, 1,0416666666666666666666666666667e-4 seconds per bit
// 12000000 / 9600 = 1250 tick @ 12 Mhz per bit

`timescale 1ns/1ns

module top_testbench();

    reg iCE_CLK;

    reg RS232_Rx_TTL;
    wire RS232_Tx_TTL;

    wire LED0;
    wire LED1;
    wire LED2;
    wire LED3;
    wire LED4;

    top dut(
	 iCE_CLK,
	 RS232_Rx_TTL,
	 RS232_Tx_TTL,
	 LED0,
	 LED1,
	 LED2,
	 LED3,
	 LED4
	);

    initial
    begin
        $dumpfile("build/aout.vcd");

        $dumpvars(0, iCE_CLK);
        $dumpvars(0, RS232_Rx_TTL);
        $dumpvars(0, RS232_Tx_TTL);

        #0
        RS232_Rx_TTL = 0; // start bit pulls line low
        #2500
        RS232_Rx_TTL = 1; // index 0
        #2500
        RS232_Rx_TTL = 0;
        #2500
        RS232_Rx_TTL = 1;
        #2500
        RS232_Rx_TTL = 0;
        #2500
        RS232_Rx_TTL = 1;
        #2500
        RS232_Rx_TTL = 0;
        #2500
        RS232_Rx_TTL = 1;
        #2500
        RS232_Rx_TTL = 0; // index 7
        #2500
        RS232_Rx_TTL = 1; // stop bit is high




        #2500
        RS232_Rx_TTL = 0; // start bit pulls line low
        #2500
        RS232_Rx_TTL = 1; // index 0
        #2500
        RS232_Rx_TTL = 0;
        #2500
        RS232_Rx_TTL = 1;
        #2500
        RS232_Rx_TTL = 0;
        #2500
        RS232_Rx_TTL = 1;
        #2500
        RS232_Rx_TTL = 0;
        #2500
        RS232_Rx_TTL = 1;
        #2500
        RS232_Rx_TTL = 0; // index 7
        #2500
        RS232_Rx_TTL = 1; // stop bit is high



        #2500
        RS232_Rx_TTL = 0; // start bit pulls line low
        #2500
        RS232_Rx_TTL = 1; // index 0
        #2500
        RS232_Rx_TTL = 0;
        #2500
        RS232_Rx_TTL = 1;
        #2500
        RS232_Rx_TTL = 0;
        #2500
        RS232_Rx_TTL = 1;
        #2500
        RS232_Rx_TTL = 0;
        #2500
        RS232_Rx_TTL = 1;
        #2500
        RS232_Rx_TTL = 0; // index 7
        #2500
        RS232_Rx_TTL = 1; // stop bit is high






        #2500
        RS232_Rx_TTL = 0; // start bit pulls line low
        #2500
        RS232_Rx_TTL = 1; // index 0
        #2500
        RS232_Rx_TTL = 0;
        #2500
        RS232_Rx_TTL = 1;
        #2500
        RS232_Rx_TTL = 0;
        #2500
        RS232_Rx_TTL = 1;
        #2500
        RS232_Rx_TTL = 0;
        #2500
        RS232_Rx_TTL = 1;
        #2500
        RS232_Rx_TTL = 0; // index 7
        #2500
        RS232_Rx_TTL = 1; // stop bit is high

        #100000
        $finish();
        //#4000 $finish();
    end

    // generate clock to sequence tests
    always
    begin
        //$display("tick %d", $time);
        iCE_CLK <= 1;
        #1;
        iCE_CLK <= 0;
        #1;
    end

endmodule