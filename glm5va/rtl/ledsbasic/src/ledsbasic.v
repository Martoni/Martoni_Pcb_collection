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
    output reg GLM_LED4
);

//    reg pix_clk;
//    always@(posedge clk) begin
//        pix_clk <= !pix_clk;
//    end;
//    assign GLM_CLK  = pix_clk;
    assign GLM_CLK  = clk;

    reg [2:0] ruc_addr;
    reg [7:0] ruc_cnt;
//    always@(posedge clk) begin
//        ruc_cnt <= ruc_cnt + 1;
//        if(ruc_cnt == 0) begin
//            ruc_addr <= ruc_addr + 1;
//        end;
//    end;
    assign GLM_A    = ruc_addr[2];
    assign GLM_B    = ruc_addr[1];
    assign GLM_C    = ruc_addr[0];

    always@(posedge clk) begin
        led1  <= !led1;
    end;

    reg       pix_latch;
    reg [4:0] pix_cnt;
    always@(posedge clk) begin
        pix_cnt <= pix_cnt + 1;
        pix_latch <= 0;
        if (pix_cnt == 0) begin
            pix_latch <= 1;
            ruc_addr <= ruc_addr + 1;
        end;
    end;
    assign GLM_LAT  = pix_latch;

    assign GLM_R1   = 1'b1;
    assign GLM_G1   = 1'b0;
    assign GLM_B1   = 1'b0;

    assign GLM_R2   = 1'b0;
    assign GLM_G2   = 1'b0;
    assign GLM_B2   = 1'b1;

    assign GLM_OE   = 1'b0;

    assign GLM_LED1 = 1'b1;
    assign GLM_LED2 = 1'b0;
    assign GLM_LED3 = 1'b1;
    assign GLM_LED4 = 1'b0;

endmodule
