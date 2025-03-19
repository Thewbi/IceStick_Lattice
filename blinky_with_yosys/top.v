// Blink an LED provided an input clock
/* module */
module top(SYS_CLK, LED5);

    /* I/O */
    input SYS_CLK;
    output LED5;

    /* Counter register */
    reg [31:0] counter = 32'b0;

    /* LED drivers */
    //assign LED5 = counter[16]; // way to fast to see
    //assign LED5 = counter[20]; // quick
    assign LED5 = counter[25]; // slow

    /* always */
    always @ (posedge SYS_CLK) begin
        counter <= counter + 1;
    end

endmodule