module top (
    // input hardware clock (12 MHz)
    input hwclk,
    // all LEDs
    output led1,
    // UART lines
    output ftdi_rx,
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

    reg [7:0] tx_byte = 8'h41;
    reg tx_DataValid = 1'b0;
    wire tx_Active;
    wire tx_Done;

    // input       i_Clock,     // clock
    // input       i_Tx_DV,     // data valid
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

    // Low speed clock generation
    always @ (posedge hwclk)
    begin

        // /* generate 9600 Hz clock (= baudrate) */
        // cntr_9600 <= cntr_9600 + 1;
        // if (cntr_9600 == period_9600) begin
        //     clk_9600 <= ~clk_9600;
        //     cntr_9600 <= 32'b0;
        // end

        // generate 1 Hz clock
        cntr_1 <= cntr_1 + 1;
        if (cntr_1 == period_1) begin
            clk_1 <= ~clk_1;
            cntr_1 <= 32'b0;
        end

    end

    // when the slow clock has a posedge
    always @(posedge clk_1)
    begin
        // toggle a LED
        ledval <= ~ledval;

        // send a character
        //tx_DataValid <= 1'b1;

        // trigger an action in the UART_TX block
        toggle_second <= ~toggle_second;
    end

    // UART_TX block
    always @(posedge hwclk or posedge tx_Done)
    begin
        if (tx_Done == 1)
        begin
            tx_DataValid <= 1'b0;
        end
        else
        begin
            if (toggle_store != toggle_second)
            begin
                tx_DataValid <= 1'b1;

                toggle_store <= toggle_second;
            end
        end
    end

    // always @(posedge tx_Done)
    // begin
    //     tx_DataValid <= 1'b0;
    // end

endmodule