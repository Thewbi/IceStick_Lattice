// 10 MHz == 10000000 ticks per second
// Every tick is one 100 ns
`timescale 1ns/1ns

module top_testbench();

    reg clk;
    reg ftdi_rx;
    wire ftdi_tx;

    wire rx_DV;
    wire [7:0] rx_byte;

    // reg rx_DV_reg;
    // reg [7:0] rx_byte_reg;

    // assign rx_DV_reg = rx_DV;
    // assign rx_byte_reg = rx_byte;

    // input        i_Clock,        // clock
    // input        i_Rx_Serial,    // this is the port connected to the UART TX line
    // output       o_Rx_DV,        // data valid, goes high for a single clock tick after reception
    // output [7:0] o_Rx_Byte       // data received
    //
    // (10000000)/(115200) = 87 for 10 MHz clock
    // every 87 clock ticks, a single bit is transmitted
    // (12000000)/(115200) = 104 for 12 MHz clock
    top top_dut(
        .hwclk(clk),
        .ftdi_rx(ftdi_rx),
        .ftdi_tx(ftdi_tx)
    );

    initial
    begin
        $dumpfile("build/aout.vcd");

        $dumpvars(0, clk);
        $dumpvars(0, top_dut);
        $dumpvars(0, ftdi_rx);
        $dumpvars(0, ftdi_tx);

        #0
        ftdi_rx = 1; // line is high during idle
        // rx_DV = 0;
        // rx_byte = 8'd0;

        //#104
        #208
        ftdi_rx = 0; // start bit pulls line low

        // send bits: 01010101 + stop bit == 0x55 == 85dec == a plus one stop bit

        //#104
        #208 // use twice the ticks since the clock goes low for one tick and high for another tick. This is then one clock cycle
        ftdi_rx = 0; // index 0
        //#104
        #208
        ftdi_rx = 0; // index 1
        //#104
        #208
        ftdi_rx = 0; // index 2
        //#104
        #208
        ftdi_rx = 0; // index 3
        //#104
        #208
        ftdi_rx = 0; // index 4
        //#104
        #208
        ftdi_rx = 0; // index 5
        //#104
        #208
        ftdi_rx = 0; // index 6
        //#104
        #208
        ftdi_rx = 0; // index 7

        //#104
        #208
        ftdi_rx = 1; // stop bit is high, idle is high


        #5000


        //#104
        #208
        ftdi_rx = 0; // start bit pulls line low

        // send bits: 01010101 + stop bit == 0x55 == 85dec == a plus one stop bit

        //#104
        #208 // use twice the ticks since the clock goes low for one tick and high for another tick. This is then one clock cycle
        ftdi_rx = 1; // index 0
        //#104
        #208
        ftdi_rx = 0; // index 1
        //#104
        #208
        ftdi_rx = 0; // index 2
        //#104
        #208
        ftdi_rx = 0; // index 3
        //#104
        #208
        ftdi_rx = 0; // index 4
        //#104
        #208
        ftdi_rx = 0; // index 5
        //#104
        #208
        ftdi_rx = 0; // index 6
        //#104
        #208
        ftdi_rx = 0; // index 7

        //#104
        #208
        ftdi_rx = 1; // stop bit is high, idle is high


        #5000



        //#104
        #208
        ftdi_rx = 0; // start bit pulls line low

        // send bits: 01010101 + stop bit == 0x55 == 85dec == a plus one stop bit

        //#104
        #208 // use twice the ticks since the clock goes low for one tick and high for another tick. This is then one clock cycle
        ftdi_rx = 0; // index 0
        //#104
        #208
        ftdi_rx = 1; // index 1
        //#104
        #208
        ftdi_rx = 0; // index 2
        //#104
        #208
        ftdi_rx = 0; // index 3
        //#104
        #208
        ftdi_rx = 0; // index 4
        //#104
        #208
        ftdi_rx = 0; // index 5
        //#104
        #208
        ftdi_rx = 0; // index 6
        //#104
        #208
        ftdi_rx = 0; // index 7

        //#104
        #208
        ftdi_rx = 1; // stop bit is high, idle is high


        #5000


        //#104
        #208
        ftdi_rx = 0; // start bit pulls line low

        // send bits: 01010101 + stop bit == 0x55 == 85dec == a plus one stop bit

        //#104
        #208 // use twice the ticks since the clock goes low for one tick and high for another tick. This is then one clock cycle
        ftdi_rx = 1; // index 0
        //#104
        #208
        ftdi_rx = 1; // index 1
        //#104
        #208
        ftdi_rx = 0; // index 2
        //#104
        #208
        ftdi_rx = 0; // index 3
        //#104
        #208
        ftdi_rx = 0; // index 4
        //#104
        #208
        ftdi_rx = 0; // index 5
        //#104
        #208
        ftdi_rx = 0; // index 6
        //#104
        #208
        ftdi_rx = 0; // index 7

        //#104
        #208
        ftdi_rx = 1; // stop bit is high, idle is high

        #5000


        //
        // second iteration
        //


        //#104
        #208
        ftdi_rx = 0; // start bit pulls line low

        // send bits: 01010101 + stop bit == 0x55 == 85dec == a plus one stop bit

        //#104
        #208 // use twice the ticks since the clock goes low for one tick and high for another tick. This is then one clock cycle
        ftdi_rx = 0; // index 0
        //#104
        #208
        ftdi_rx = 0; // index 1
        //#104
        #208
        ftdi_rx = 1; // index 2
        //#104
        #208
        ftdi_rx = 0; // index 3
        //#104
        #208
        ftdi_rx = 0; // index 4
        //#104
        #208
        ftdi_rx = 0; // index 5
        //#104
        #208
        ftdi_rx = 0; // index 6
        //#104
        #208
        ftdi_rx = 0; // index 7

        //#104
        #208
        ftdi_rx = 1; // stop bit is high, idle is high


        #5000


        //#104
        #208
        ftdi_rx = 0; // start bit pulls line low

        // send bits: 01010101 + stop bit == 0x55 == 85dec == a plus one stop bit

        //#104
        #208 // use twice the ticks since the clock goes low for one tick and high for another tick. This is then one clock cycle
        ftdi_rx = 1; // index 0
        //#104
        #208
        ftdi_rx = 0; // index 1
        //#104
        #208
        ftdi_rx = 1; // index 2
        //#104
        #208
        ftdi_rx = 0; // index 3
        //#104
        #208
        ftdi_rx = 0; // index 4
        //#104
        #208
        ftdi_rx = 0; // index 5
        //#104
        #208
        ftdi_rx = 0; // index 6
        //#104
        #208
        ftdi_rx = 0; // index 7

        //#104
        #208
        ftdi_rx = 1; // stop bit is high, idle is high


        #5000



        //#104
        #208
        ftdi_rx = 0; // start bit pulls line low

        // send bits: 01010101 + stop bit == 0x55 == 85dec == a plus one stop bit

        //#104
        #208 // use twice the ticks since the clock goes low for one tick and high for another tick. This is then one clock cycle
        ftdi_rx = 0; // index 0
        //#104
        #208
        ftdi_rx = 1; // index 1
        //#104
        #208
        ftdi_rx = 1; // index 2
        //#104
        #208
        ftdi_rx = 0; // index 3
        //#104
        #208
        ftdi_rx = 0; // index 4
        //#104
        #208
        ftdi_rx = 0; // index 5
        //#104
        #208
        ftdi_rx = 0; // index 6
        //#104
        #208
        ftdi_rx = 0; // index 7

        //#104
        #208
        ftdi_rx = 1; // stop bit is high, idle is high


        #5000


        //#104
        #208
        ftdi_rx = 0; // start bit pulls line low

        // send bits: 01010101 + stop bit == 0x55 == 85dec == a plus one stop bit

        //#104
        #208 // use twice the ticks since the clock goes low for one tick and high for another tick. This is then one clock cycle
        ftdi_rx = 1; // index 0
        //#104
        #208
        ftdi_rx = 1; // index 1
        //#104
        #208
        ftdi_rx = 1; // index 2
        //#104
        #208
        ftdi_rx = 0; // index 3
        //#104
        #208
        ftdi_rx = 0; // index 4
        //#104
        #208
        ftdi_rx = 0; // index 5
        //#104
        #208
        ftdi_rx = 0; // index 6
        //#104
        #208
        ftdi_rx = 0; // index 7

        //#104
        #208
        ftdi_rx = 1; // stop bit is high, idle is high

        #5000

        #40000 $finish();
    end

    // // when data goes high for a single tick print the data
    // always @(posedge rx_DV)
    // begin
    //     $display("rx_DV: %d, data: %d", rx_DV, rx_byte);
    // end

    // generate clock to sequence tests
    always
    begin
        //$display("tick %d", $time);
        clk <= 1;
        #1;
        clk <= 0;
        #1;
    end

endmodule