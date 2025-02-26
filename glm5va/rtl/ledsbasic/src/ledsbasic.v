module ledsbasic (
    input  clk,
    output reg led1,

    /* Matrix LED driver */
    output reg GLM_R1,
    output reg GLM_R2,
    output reg GLM_G1,
    output reg GLM_G2,
    output reg GLM_B1,
    output reg GLM_B2,

    output reg GLM_A,
    output reg GLM_B,
    output reg GLM_C,

    output reg GLM_OE,
    output reg GLM_LAT,
    output reg GLM_CLK,

    /* glm5va leds */
    output reg GLM_LED1,
    output reg GLM_LED2,
    output reg GLM_LED3,
    output reg GLM_LED4);

    always@(posedge clk) begin
        led1  <= !led1;
    end;

    assign GLM_R1   = 1'b1;
    assign GLM_R2   = 1'b1;
    assign GLM_G1   = 1'b0;
    assign GLM_G2   = 1'b0;
    assign GLM_B1   = 1'b0;
    assign GLM_B2   = 1'b0;
    assign GLM_A    = 1'b0;
    assign GLM_B    = 1'b1;
    assign GLM_C    = 1'b0;
    assign GLM_OE   = 1'b1;
    assign GLM_LAT  = 1'b1;
    assign GLM_CLK  = 1'b1;
    assign GLM_LED1 = 1'b1;
    assign GLM_LED2 = 1'b0;
    assign GLM_LED3 = 1'b1;
    assign GLM_LED4 = 1'b0;

endmodule
