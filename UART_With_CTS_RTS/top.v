/* Top level module for keypad + UART demo */
module top (
    // input hardware clock (12 MHz)
    hwclk,
    // all LEDs
    //led1,
    // UART lines
    //ftdi_tx,

    TODO:
    1. list the pmod pins here so that the TTL USB adapter will be able to receive
    Make sure the pins are connected to the pmod according to the .pcf file!

    // RTS
    rts
    // TxD
    TxD_ser

    2. TTL adapter löten


);

    /* Clock input */
    input hwclk;

    /* LED outputs */
    output led1;

    /* FTDI I/O */
    output ftdi_tx;


    parameter ASCII_0 = 8'd48;
    parameter ASCII_9 = 8'd57;
    reg [7:0] uart_txbyte = ASCII_0;

    wire uart_send;

    wire rts;

    reg clk_9600 = 0;
    reg [31:0] cntr_9600 = 32'b0;
    parameter period_9600 = 625; // 12.000.000 / 9600 = 1250. 1250 / 2 = 625

    // register that is used as output with the UART_TX and connected to
    // the o_txd_wire. o_txd_wire is mapped to the correct pin on the PMOD.
    reg TxD_ser;
    wire o_txd_wire;
    assign o_txd_wire = TxD_ser;

    UART_TX uart_tx (
        .RxD_par(uart_txbyte), // [in] byte to send
        .RxD_start(uart_send), // [in] UART_TX enable
        .RTS(rts), // [in] RTS signal (ready to send)
        .sys_clk(hwclk), // [in] hardware clock
        .BaudTick(clk_9600), // [in] baudrate generator clock signal
        .TxD_ser(TxD_ser) // [out] serialize signal for sending the byte
    );

    // generate the baudrate
    always @ (posedge hwclk) begin

        /* generate 9600 Hz clock (= baudrate) */
        cntr_9600 <= cntr_9600 + 1;
        if (cntr_9600 == period_9600) begin
            clk_9600 <= ~clk_9600;
            cntr_9600 <= 32'b0;
        end

        // /* generate 1 Hz clock */
        // cntr_1 <= cntr_1 + 1;
        // if (cntr_1 == period_1) begin
        //     clk_1 <= ~clk_1;
        //     cntr_1 <= 32'b0;
        // end

    end

endmodule