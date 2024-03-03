`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ed Nutting 
// 
// Create Date: 30.05.2019 15:12:07
// Design Name: PMOD demo
// Module Name: top
// Project Name: PMOD
// Target Devices: Zedboard (Zynq 7020)
// Tool Versions: Vivado 2016.1
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Licensed under MIT license - refer to LICENSE file.
// 
//////////////////////////////////////////////////////////////////////////////////

module top(

    input SYS_CLK, // System clock 25Mhz on the IceStick

    // FTDI I/O, UART lines for the USB FTDI UART connection on the IceStick
    output ftdi_tx,

    input  PMOD1, // RTS
    output PMOD2, // RXD
    input  PMOD3, // TXD
    output PMOD4, // CTS

    input  PMOD7, // STS
    output PMOD8, // RST

    inout LED1, // top LED RED
    inout LED2, // right LED RED
    inout LED3, // bottom LED RED
    inout LED4, // left LED RED

    inout LED5 // center LED which is green

);

    assign LED2 = 0;
    reg LED3_reg = 0;
    reg LED4_reg = 0;

    wire BT2_RTS;
    wire BT2_TXD;

    wire BT2_CTS;
    wire BT2_RXD;

    wire BT2_STS;

    wire BT2_send;
    wire BT2_sent;
    wire BT2_receive;
    wire BT2_received;

    wire BT2_RST_N;

    // this ASCII character is currently sent at a rate of 9600 baud over the UART
    // Note: could also use "0" or "9" below, but I wanted to
    // be clear about what the actual binary value is.
    parameter ASCII_0 = 8'd48;
    parameter ASCII_9 = 8'd57;
    reg [7:0] uart_txbyte = ASCII_0;

    wire [7:0] BT2_char_out;
    wire [7:0] BT2_char_in;

    // 9600 Hz clock generation (from 12 MHz)
    reg clk_9600 = 0;
    reg [31:0] cntr_9600 = 32'b0;
    parameter period_9600 = 625; // 12.000.000 / 9600 = 1250. 1250 / 2 = 625

    reg clk_1 = 0;
    reg [31:0] cntr_1 = 32'b0;
    parameter period_1 = 6000000;

    // this flag determines, weather the UART does send data or not
    wire uart_send;
    assign uart_send = 1;

    // transmission done signal. The UART outputs a high value, when the transmission is done
    wire uart_txed;

    // UART transmitter module designed for
    // 8 bits, no parity, 1 stop bit. 
    //
    uart_tx_8n1 transmitter (
        // 9600 baud rate clock
        .clk(clk_9600),
        // byte to be transmitted
        .txbyte(BT2_char_out),
        // trigger a UART transmit on baud clock
        .senddata(BT2_receive),
        // input: tx is finished
        .txdone(uart_txed),
        // output UART tx pin
        .tx(ftdi_tx)
    );

    // Low speed clock generation
    always @ (posedge SYS_CLK) begin

        // generate 9600 Hz clock (= baudrate)
        cntr_9600 <= cntr_9600 + 1;
        if (cntr_9600 == period_9600) begin
            clk_9600 <= ~clk_9600;
            cntr_9600 <= 32'b0;
        end

        // generate 1 Hz clock
        cntr_1 <= cntr_1 + 1;
        if (cntr_1 == period_1) begin
            clk_1 <= ~clk_1;
            cntr_1 <= 32'b0;
        end

    end

    // the PMOD_BT2 module has to be reset!
    // It has to be reset so that the state machine starts 
    // with the START state!
    wire RST_N;
    reg RST_N_PERFORMED_REG = 0;
    reg RST_N_REG;

    // LED 3 is the bottom LED (seen from the orientation: USB to the left and IRDA to the right)
    assign LED3 = RST_N;

    always @ (posedge clk_1) begin

        // toggle the LED
        LED4_reg = ~LED4_reg;

        // if the module has not been reset yet, reset it
        // the reset is an active low cycle
        if (!RST_N_PERFORMED_REG) begin
            RST_N_PERFORMED_REG <= 1;
            RST_N_REG <= 0;
        end else begin
            RST_N_REG <= 1;
        end

    end
    assign LED4 = LED4_reg;
    assign RST_N = RST_N_REG;

    // See constraints file - global clock should be from Y9 package pin @ 100MHz
    wire CLK;
    assign CLK = SYS_CLK;

    wire lock;
    wire clkout;

    // A PLL is used to create a 100Mhz clock from the IceStick's onboard 12Mhz clock
    //
    // clock settings according to icepll (https://raw.githubusercontent.com/YosysHQ/icestorm/master/icepll/icepll.cc)
    //
    // F_PLLIN:    12.000 MHz (given)
    // F_PLLOUT:  100.000 MHz (requested)
    // F_PLLOUT:  100.500 MHz (achieved)
    // 
    // FEEDBACK: SIMPLE
    // F_PFD:   12.000 MHz
    // F_VCO:  804.000 MHz
    // 
    // DIVR:  0 (4'b0000)
    // DIVF: 66 (7'b1000010)
    // DIVQ:  3 (3'b011)
    // 
    // FILTER_RANGE: 1 (3'b001)

    SB_PLL40_CORE #(
		.FEEDBACK_PATH("SIMPLE"),
		.PLLOUT_SELECT("GENCLK"),
		.DIVR(4'b0000),
		.DIVF(7'b1000010),
		.DIVQ(3'b011),
		.FILTER_RANGE(3'b001)
	) uut (
		.LOCK(lock),
		.RESETB(1'b1),
		.BYPASS(1'b0),
		.REFERENCECLK(SYS_CLK),
		.PLLOUTCORE(clkout)
	);

    // PMOD BT2 - Bluetooth connection - https://github.com/EdNutting/PMOD/blob/master/PMOD.srcs/sources_1/new/Top.v
    
    // BT2 input signals
    assign BT2_RTS = PMOD1;
    assign BT2_TXD = PMOD3;
    assign BT2_STS = PMOD7;
    
    // BT2 indicator LEDs
    assign LED5 = BT2_STS;

    // BT2 outputs
    assign PMOD2 = BT2_RXD;
    assign PMOD4 = BT2_CTS;
    assign PMOD8 = 1'b1; // Reset signal

    // BT2 module - https://github.com/EdNutting/PMOD/blob/master/PMOD.srcs/sources_1/new/Top.v
    PMOD_BT2 bt2 (
        .CLK        (clkout),
        .RST_N      (RST_N),

        .RTS        (BT2_RTS),
        .RXD        (BT2_RXD),
        .TXD        (BT2_TXD),
        .CTS        (BT2_CTS),
        .STS        (BT2_STS),
        .RST_N_Out  (BT2_RST_N),
        
        .char_in    (BT2_char_in), // character to send
        .char_out   (BT2_char_out), // [output] character (/byte) received
        .send       (BT2_send), // [input] active-high. Set to send. Keep high until 'sent' set.
        .sent       (BT2_sent), // [output] active-high. Pulses for 1 clock cycle when 'char_in' finished sending.
        .receive    (BT2_receive), // [output reg receive] Active-high. Set while char_out valid when a byte is received.
        .received   (BT2_received) // [input] Active-high. Set for 1 clock cycle to clear 'receive' and being accepting next character.
    );
        
    // configure the BT2 module as an echo device
    assign BT2_char_in = BT2_char_out;
    assign BT2_send = BT2_receive && !BT2_sent;
    assign BT2_received = BT2_sent;
    assign LED1 = BT2_receive;

endmodule