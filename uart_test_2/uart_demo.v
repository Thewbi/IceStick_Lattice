/*
 * Copyright 2015 Forest Crossman
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

//`include "cores/osdvu/uart.v"

module top(
	input iCE_CLK,
	input RS232_Rx_TTL,
	output RS232_Tx_TTL,
	output LED0,
	output LED1,
	output LED2,
	output LED3,
	output LED4
	);

	wire reset = 0;
	reg transmit = 0;
	reg [7:0] tx_byte;
	wire received;
	wire [7:0] rx_byte;
	wire is_receiving;
	wire is_transmitting;
	wire recv_error;

    reg [7:0] counter = 8'b0;
    reg [7:0] buffer [3:0];
    reg start = 0;
    reg waiter = 1;

	assign LED4 = recv_error;
	assign {LED3, LED2, LED1, LED0} = rx_byte[7:4];

	uart #(
		.baud_rate(9600),                 // The baud rate in kilobits/s
		.sys_clk_freq(12000000)           // The master clock frequency
	)
	uart0(
		.clk(iCE_CLK),                    // The master clock for this module
		.rst(reset),                      // Synchronous reset
		.rx(RS232_Rx_TTL),                // Incoming serial line
		.tx(RS232_Tx_TTL),                // Outgoing serial line
		.transmit(transmit),              // Signal to transmit
		.tx_byte(tx_byte),                // Byte to transmit
		.received(received),              // Indicated that a byte has been received
		.rx_byte(rx_byte),                // Byte received
		.is_receiving(is_receiving),      // Low when receive line is idle
		.is_transmitting(is_transmitting),// Low when transmit line is idle
		.recv_error(recv_error)           // Indicates error in receiving packet.
	);

	always @(posedge iCE_CLK) begin

        waiter = ~waiter;

        if (transmit == 1) begin
            transmit = 0;
        end

		if (received && waiter)
        begin



            $display("received");

            buffer[counter] = rx_byte;

            counter = counter + 1;

            $display("received counter: %d", counter);

            if (counter == 4)
            begin
                 counter = counter - 1;

                 tx_byte = buffer[counter];
                 transmit = 1;

                start = 1;
            end
		end
        //  else begin
		// 	transmit <= 0;
		// end

        // if (counter <= 2 && start) begin
        //     $display("is_transmitting: %d, counter: %d, start: %d", is_transmitting, counter, start);
        // end

        if (is_transmitting == 0 && counter >= 0 && start == 1)
        begin
            //$display("transmit");

            if (counter > 0) begin



             $display("transmit counter: %d", counter);



             tx_byte = buffer[counter];
             transmit = 1;

             counter = counter - 1;
            end
            else
            begin
                transmit = 0;
            end
        end

        // if (counter == 0)
        // begin
        //     //$display("stop");

        //     start = 0;
        //     transmit = 0;
        // end
	end

    // always @(negedge is_transmitting)
    // begin
    //     //counter = counter - 1;
    // end
endmodule