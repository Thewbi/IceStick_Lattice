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
    //reg uart_send = 1'b0;
    //wire uart_send = 1'b1;
    wire uart_send;

    // transmission done signal. The UART outputs a high value, when the transmission is done
    wire uart_txed;
    //reg uart_txed_reg;

    //assign uart_txed_reg = uart_txed;

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


/*
    //reg [31:0] chars_transmitted = 1'b0;

    reg disable_uart = 1'b0;
    assign uart_send = !disable_uart;

    // https://digilent.com/blog/how-to-code-a-state-machine-in-verilog/
    localparam state_wait = 3'b000;
    localparam state_send = 3'b001;

    reg [2:0] present_state = state_send;
    reg [2:0] next_state = state_wait;

    always @ (present_state) begin
        
        case (present_state)

            state_wait:
            begin
                next_state = state_send;
                disable_uart <= 1'b1;
            end

            state_send:
            begin
                next_state = state_wait;
                disable_uart <= 1'b0;
            end

            //default:
           // begin
            //    next_state = state_send;
            //    disable_uart <= 1'b1;
            //end

        endcase

    end

    always @ (posedge clk_1) begin
    //always @ (clk_1 or chars_transmitted) begin
    //always @ (present_state) begin

        if (present_state == state_wait) begin
            //disable_uart <= 1'b1;
            //chars_transmitted = 0;
        end

        if (present_state == state_send) begin
            //disable_uart <= 1'b0;

            //if (chars_transmitted > 1) begin
            //    disable_uart <= 1'b1;
            //end else begin
            //    disable_uart <= 1'b0;
            //end 
        end

    end

    reg uart_txed_reg;

    //always @ (clk_1 or uart_txed_reg) begin
    //always @ (posedge clk_1) begin
    //always @ (uart_txed) begin
    //always @ (posedge clk_1) begin    
    //    present_state = next_state;
        //disable_uart = ~disable_uart;
    //end

    //always @(posedge uart_txed) begin
        //disable_uart <= 1'b1;
        //chars_transmitted = chars_transmitted + 1;
    //    uart_txed_reg <= ~uart_txed_reg;
    //  end

    always @(uart_txed or clk_1) begin
        //present_state = state_wait;

        case (present_state)

            state_wait:
            begin
                present_state = state_send;
            end

            state_send:
            begin
                present_state = state_wait;
            end

        endcase
    end
*/

    //wire transmit_en;
    //reg transmit_en_reg = 1'b0;
    //reg transmit_en_reg = 1'b1;
    //assign transmit_en = transmit_en_reg;

    //reg disable_uart = 1'b0;
    //always @(uart_txed or transmit_en) begin

        //disable_uart <= 1'b1;
        //disable_uart <= 1'b0;

        //transmit_en_reg = 1'b0;

        // if (disable_uart == 1) begin
        //     // deactivate sending data
        //     //uart_send <= 1'b0;
        //     disable_uart <= 1'b0;
        // end else begin
        //     // activate sending data
        //     //uart_send <= 1'b1;
        //     // when a character has been transmitted, turn the UART off so no more data is sent
        //     disable_uart <= 1'b1;
        // end

        //disable_uart <= 1'b0;
        //if (uart_txed == 1'b1) begin
        //    disable_uart <= 1'b1;
        //end else begin
        //    disable_uart <= 1'b0;
        //end
        
        // if (transmit_en == 1'b1) begin
        //     disable_uart <= 1'b0;
        //     //transmit_en_reg <= 1'b0;
        // end
        //uart_send <= 1'b0;
        //disable_uart <= ~disable_uart;
       
    //end

    //assign uart_txed = !disable_uart;
    //assign uart_send = !disable_uart;

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

        //disable_uart <= 1'b1;
        //uart_send <= 1'b1;

        //disable_uart <= 1'b0;

        //transmit_en_reg = 1'b1;
        //transmit_en_reg = ~transmit_en_reg;
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

    //always @(posedge uart_txed) begin
        //disable_uart <= 1'b1;
        //chars_transmitted = chars_transmitted + 1;
    //    uart_txed_reg <= ~uart_txed_reg;
    //  end

endmodule