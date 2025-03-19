module top (
    output reg led_green,
    output reg D1,
    output reg D2,
    output reg D3,
    output reg D4,

    // input wire resetn,

    // input hardware clock (12 MHz)
    input hwclk,
    // UART lines
    input ftdi_rx,
    output ftdi_tx
);

    //
    // https://stackoverflow.com/questions/38030768/icestick-yosys-using-the-global-set-reset-gsr
    //

    wire resetn;
    reg [3:0] rststate = 0;
    assign resetn = &rststate;
    always @(posedge hwclk) begin
        rststate <= rststate + !resetn;
        //rx_DataValid = 0;
    end

    //
    // state machine
    //

    parameter
        programming             = 4'b0000,
        programming_done        = 4'b0001
    ;

    // current state and next state
    reg [3:0] current_state = programming;
    reg [3:0] next_state = programming;

    //always @(posedge hwclk, negedge resetn)
    always @(posedge hwclk)
    begin
        if (resetn == 0)
        begin

            //$display("[XYZ] reset");

            // when reset=1, reset the state of the FSM to "FetchState_1" State
            current_state = programming;
            //next_state = programming;

            // further reset logic here
            // led_green = 0;
            // D1 = 0;
            // D2 = 0;
            // D3 = 0;
            // D4 = 0;

        end
        else
        begin
            // if (next_state != current_state) begin
            //     $display("[XYZ] current_state: %d, next_state: %d", current_state, next_state);
            // end

            //$display("[XYZ] next state");

            //led_green = 1;

            // otherwise, next state
            current_state = next_state;
        end
    end

    always @(current_state) begin
        case (current_state)

            programming:
            begin
                // $display("");
                // $display("");
                //$display("[programming]");

                // logic for this state goes here

                led_green = 0;
            end

            programming_done:
            begin
                // $display("");
                // $display("");
                //$display("[programming_done]");

                // logic for this state goes here

                led_green = 1;
            end
        endcase
    end

    //always @(current_state, buffer_index)
    //always @(hwclk, buffer_index)
    always @(hwclk) begin

        case (current_state)

            programming:
            begin
                if (buffer_index == 8'h04) begin
                    //$display("[controller] goto programming -> programming_done");
                    next_state = programming_done;
                end
                // else
                // begin
                //     next_state = programming;
                // end
            end

            // programming_done:
            // begin
            //     $display("[controller] goto FetchState_1 -> DecodeState");
            //     next_state = DecodeState;
            // end

        endcase

    end

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

        // when a byte is received, store it into the buffer, increment index
        if (rx_DataValid == 1'b1) begin
            //$display("[rx]");
            //D1 = 1;
            buffer[buffer_index] = rx_byte;
            tx_byte = rx_byte;
            if (buffer_index < 4) begin
                buffer_index = buffer_index + 8'h01;
            end

            D1 = buffer_index[0];
            D2 = buffer_index[1];
            D3 = buffer_index[2];
            D4 = buffer_index[3];
        end

        // when a byte has been transmitted, decrement index, pre load next byte
        if (tx_Done == 1'b1) begin
            if (buffer_index == 4) begin
                buffer_index = buffer_index - 8'h01;
                D1 = buffer_index[0];
                D2 = buffer_index[1];
                D3 = buffer_index[2];
                D4 = buffer_index[3];
            end
            if (buffer_index != 0) begin
                buffer_index = buffer_index - 8'h01;
                D1 = buffer_index[0];
                D2 = buffer_index[1];
                D3 = buffer_index[2];
                D4 = buffer_index[3];
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