// +-------------------------------------------+
// |                                           |
// |     HUB75 DOT MATRIX DISPLAY DRIVER       |
// |                                           |
// |  Author: Chandler Klüser Chantre (2023)   |
// |  Device: Sipeed Tang Nano 9k              |
// |  Display: 64x32 1/16 dot matrix HUB75     |
// |  Lesson 01: Single Static Red Pixel       |
// |  https://github.com/Chandler-Kluser/Tang75/blob/master/01%20-%20Single%20Red%20Pixel/src/pxmat_tn9k.v
//
// parameters
localparam PIXEL_COLUMNS = 32; // screen width in pixels
localparam PIXEL_LINES   = 16; // screen height in pixels/2
localparam OE_INTENSITY  = 10; // screen display intensity (min=1; max=128; off=0)

module ledsbasic (
    input  clk,
    output led1,

    /* Matrix LED driver */
    output GLM_R1,
    output GLM_R2,
    output GLM_G1,
    output GLM_G2,
    output GLM_B1,
    output GLM_B2,

    output GLM_A,
    output GLM_B,
    output GLM_C,

    output GLM_OE,
    output GLM_LAT,
    output GLM_CLK,

    /* glm5va leds */
    output GLM_LED1,
    output GLM_LED2,
    output GLM_LED3,
    output GLM_LED4
);
    assign led1=1'b1;
    assign GLM_LED1=1'b1; 
    assign GLM_LED2=1'b0;
    assign GLM_LED3=1'b0;
    assign GLM_LED4=1'b1;

    wire clk_out;
    assign GLM_CLK = clk_out;

    reg rst = 1'b1;
    reg LATCH = 1'b0;
    reg LATCH_OLD = 1'b0;
    reg latch_pulse = 1'b0;
    assign GLM_LAT = LATCH;

    reg [2:0] ADDR = 0;
    assign GLM_A = ADDR[2];
    assign GLM_B = ADDR[1];
    assign GLM_C = ADDR[0];

    wire [2:0] RGB0;
    wire [2:0] RGB1;

    assign GLM_G1 = RGB0[0];
    assign GLM_R1 = RGB0[1];  
    assign GLM_B1 = RGB0[2];

    assign GLM_R2 = RGB1[0];
    assign GLM_G2 = RGB1[1];
    assign GLM_B2 = RGB1[2];

    reg[6:0] counter = 0;
    
    // clock divisor (outputs 60Hz)
    wire clk_master_rise;
    wire clk_master;

    clock_divisor clkdiv(.clk(clk),
                         .clk_out(clk_master),
                         .clk_master_rise(clk_master_rise));

    // output enable controller
    wire OE;
    assign GLM_OE = OE;
    oe_controller oe_ctrl(.clk(clk_master_rise),.rst(rst),.cnt(counter),.OE(OE));

    // prints only first line
    always @(posedge clk) begin
        LATCH_OLD <= LATCH;
        latch_pulse <= 1'b0;
        if(LATCH_OLD==0 && LATCH==1'b1) begin
            latch_pulse <= 1'b1;
            ADDR <= ADDR + 1'b1;
        end
    end

    // shift registers clock driver
    assign clk_out = (counter<PIXEL_COLUMNS) ? clk_master : 1;

    // design pattern
    assign RGB0 = (counter==5) ? 3'b111 : 3'b100; 
    assign RGB1 = 3'b001;
    
    always @(posedge clk) begin
        if(clk_master_rise === 1'b1) begin
            // increment clock counter
            counter <= counter + 7'd1;

            // LATCH signal handling
            // PIXEL_COLUMNS+1 clock cycle LATCHES
            if ((counter==PIXEL_COLUMNS)) begin
                LATCH <= 1;
            // PIXEL_COLUMNS+2 clock cycle UNLATCH
            end else if ((counter==PIXEL_COLUMNS+1)) begin
                LATCH        <= 0;
                counter      <= 7'd0;
//                LAT_EN       <=    0;
            end
        end
    end
endmodule

`define CLK_DIV 9
module clock_divisor (
    input       clk,
    output  clk_out,
    output clk_master_rise,
    output clk_master_fall
);

    reg[`CLK_DIV:0] counter=0;
    assign clk_out = counter[`CLK_DIV];
    assign clk_master_rise = (counter===(1<<`CLK_DIV));
    assign clk_master_fall = (counter === 0);
    always @(posedge clk) counter = counter + 1;


endmodule

module oe_controller(
    input      clk,
    input      rst,
    input[6:0] cnt,
    output reg  OE
);

    always @(posedge clk) begin
        if (!rst) begin
            OE      = 1;
        end else begin
            if (cnt<OE_INTENSITY) OE = 0; else OE = 1;
        end
    end
endmodule
