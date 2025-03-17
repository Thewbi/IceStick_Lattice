module top (
    // input hardware clock (12 MHz)
    input hwclk,
    // all LEDs
    output led1,
    // UART lines
    input ftdi_rx,
    output ftdi_tx
);

    // 1 Hz clock generation (from 12 MHz)
    reg clk_1 = 0;
    reg [31:0] cntr_1 = 32'b0;
    parameter period_1 = 6000000; // 120000000 / 2 = 600000. Means the clock signal goes low and high for 600000 ticks each per second

    // LED
    reg ledval = 0;
    assign led1 = ledval;

    // UART TX
    reg toggle_second = 1'b0;
    reg toggle_store = 1'b0;

    reg [7:0] tx_byte = 8'h00;
    reg tx_DataValid = 1'b0;
    wire tx_Active;
    wire tx_Done;

    // input       i_Clock,     // clock
    // input       i_Tx_DV,     // data valid, pull high to start sending whatever is in i_Tx_Byte
    // input [7:0] i_Tx_Byte,   // payload bits (byte) to send
    // output      o_Tx_Active, // high during transmission
    // output reg  o_Tx_Serial, // this is the port connected to the UART TX line
    // output      o_Tx_Done    // high for a single clock cycle when transmission is done
    uart_tx #(.CLKS_PER_BIT(104)) utx(
        .i_Clock(hwclk),
        .i_Tx_DV(tx_DataValid),
        .i_Tx_Byte(tx_byte),
        .o_Tx_Active(tx_Active),
        .o_Tx_Serial(ftdi_tx),
        .o_Tx_Done(tx_Done)
    );

    // UART RX
    wire rx_DV;
    wire [7:0] rx_byte;

    // input        i_Clock,        // clock
    // input        i_Rx_Serial,    // this is the port connected to the UART TX line
    // output       o_Rx_DV,        // data valid, goes high for a single clock tick after reception
    // output [7:0] o_Rx_Byte       // data received
    uart_rx #(.CLKS_PER_BIT(104)) urx(
        .i_Clock(hwclk),
        .i_Rx_Serial(ftdi_rx),
        .o_Rx_DV(rx_DV),
        .o_Rx_Byte(rx_byte)
    );

    always @(posedge tx_Done or posedge rx_DV)
    begin
        if (tx_Done == 1)
        begin
            tx_DataValid = 1'b0;
        end
        else if (rx_DV == 1'b1)
        begin
            tx_byte = rx_byte;
            tx_DataValid = 1'b1;
        end
    end

endmodule