/* Top level module for keypad + UART demo */
module top (
    // input hardware clock (12 MHz)
    hwclk, 
    // all LEDs
    led1,
    // UART lines
    ftdi_tx, 
    );

    /* Clock input */
    input hwclk;

    /* LED outputs */
    output led1;

    /* FTDI I/O */
    output ftdi_tx;

    /* 9600 Hz clock generation (from 12 MHz) */
    reg clk_9600 = 0;
    reg [31:0] cntr_9600 = 32'b0;
    parameter period_9600 = 625; // 12.000.000 / 9600 = 1250. 1250 / 2 = 625

    /* 1 Hz clock generation (from 12 MHz) */
    reg clk_1 = 0;
    reg [31:0] cntr_1 = 32'b0;
    parameter period_1 = 6000000;
    reg toggle_second = 1'b0;
    reg toggle_store = 1'b0;

    // Note: could also use "0" or "9" below, but I wanted to
    // be clear about what the actual binary value is.
    parameter ASCII_0 = 8'd48;
    parameter ASCII_9 = 8'd57;

    /* UART registers */

    // this ASCII character is currently sent at a rate of 9600 baud over the UART
    reg [7:0] uart_txbyte = ASCII_0;

    // this flag determines, weather the UART does send data or not
    wire uart_send;

    // transmission done signal. The UART outputs a high value, when the transmission is done
    wire uart_txed;

    /* LED register */
    reg ledval = 0;

    /* UART transmitter module designed for
       8 bits, no parity, 1 stop bit. 
    */
    uart_tx_8n1 transmitter (
        // 9600 baud rate clock
        .clk(clk_9600),
        // byte to be transmitted
        .txbyte(uart_txbyte),
        // trigger a UART transmit on baud clock
        .senddata(uart_send),
        // input: tx is finished
        .txdone(uart_txed),
        // output UART tx pin
        .tx(ftdi_tx)
    );

    /* Wiring */
    assign led1 = ledval;
    
    /* Low speed clock generation */
    always @ (posedge hwclk) begin

        /* generate 9600 Hz clock (= baudrate) */
        cntr_9600 <= cntr_9600 + 1;
        if (cntr_9600 == period_9600) begin
            clk_9600 <= ~clk_9600;
            cntr_9600 <= 32'b0;
        end

        /* generate 1 Hz clock */
        cntr_1 <= cntr_1 + 1;
        if (cntr_1 == period_1) begin
            clk_1 <= ~clk_1;
            cntr_1 <= 32'b0;
        end

    end

    /* Increment ASCII digit and blink LED */
    always @(posedge clk_1) begin

        // toggle a LED
        ledval <= ~ledval;

        // change the ASCII character that is send
        if (uart_txbyte == ASCII_9) begin
            uart_txbyte <= ASCII_0;
        end else begin
            uart_txbyte <= uart_txbyte + 1;
        end

        toggle_second <= ~toggle_second;

    end

    reg uart_send_reg = 1'b0;
    assign uart_send = uart_send_reg;

    // this always block is the sole driver of the uart_send_reg register
    // which is connected to the uart_send wire which in turn enables and disables
    // the sender UART
    always @(posedge hwclk) begin

        // When the UART has transmitted a single character, it sets uart_txed to 1.
        // Here uart_txed is compared to 1 and if this is the case, the sender UART
        // is disabled so that only with the next 1Hz clock tick, the next character
        // is sent
        if (uart_txed == 1'b1) begin
            uart_send_reg <= 1'b0;
        end

        // when the 1Hz clock ticks, it toggles the toggle_store register.
        // Here, toggle_store is read and on every toggle, the UART is enabled for sending a single character
        if (toggle_store != toggle_second) begin
            uart_send_reg <= 1'b1;
            toggle_store <= toggle_second;
        end

    end

endmodule