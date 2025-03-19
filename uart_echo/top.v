module top (
    // input hardware clock (12 MHz)
    input hwclk,
    // UART lines
    input ftdi_rx,
    output ftdi_tx
);

    reg [7:0] tx_byte = 8'h00;
    reg tx_DataValid = 1'b0;
    wire tx_Active;
    wire tx_Done;

    reg [7:0] buffer [0:3];
    reg [7:0] buffer_index = 8'h00;

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
    wire rx_DataValid;
    wire [7:0] rx_byte;

    // input        i_Clock,        // clock
    // input        i_Rx_Serial,    // this is the port connected to the UART TX line
    // output       o_Rx_DV,        // data valid, goes high for a single clock tick after reception
    // output [7:0] o_Rx_Byte       // data received
    uart_rx #(.CLKS_PER_BIT(104)) urx(
        .i_Clock(hwclk),
        .i_Rx_Serial(ftdi_rx),
        .o_Rx_DV(rx_DataValid),
        .o_Rx_Byte(rx_byte)
    );

    always @(posedge hwclk)
    begin
        if (rx_DataValid == 1'b1) begin
            buffer[buffer_index] = rx_byte;
            tx_byte = rx_byte;
            if (buffer_index < 4) begin
                buffer_index = buffer_index + 8'h01;
            end
        end

        if (tx_Done == 1'b1) begin
            if (buffer_index == 4) begin
                buffer_index = buffer_index - 8'h01;
            end
            if (buffer_index != 0) begin
                buffer_index = buffer_index - 8'h01;
            end
            tx_byte = buffer[buffer_index];
        end
    end

    always @(posedge hwclk)
    begin
        if (buffer_index == 8'h04) begin
            tx_DataValid = 1'b1;
        end
        if (buffer_index == 8'h00) begin
            tx_DataValid = 1'b0;
        end
    end

endmodule