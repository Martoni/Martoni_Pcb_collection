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
localparam PIXEL_COLUMNS = 64; // screen width in pixels
localparam PIXEL_LINES   = 16; // screen height in pixels/2
localparam OE_INTENSITY  =  64; // screen display intensity (min=1; max=128; off=0)

module ledsbasic (
    input  clk,
    output reg led1,

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
    output reg GLM_LED1,
    output reg GLM_LED2,
    output reg GLM_LED3,
    output reg GLM_LED4
);

    wire clk_out;
    assign GLM_CLK = clk_out;
    reg rst = 0;
    reg LATCH;
    assign GLM_LAT = LATCH;

    wire [3:0] ADDR;
    assign GLM_A = ADDR[3];
    assign GLM_B = ADDR[2];
    assign GLM_C = ADDR[1];

    wire [2:0] RGB0;
    wire [2:0] RGB1;

    assign GLM_G1 = RGB0[0];
    assign GLM_R1 = RGB0[1];  
    assign GLM_B1 = RGB0[2];

    assign GLM_R2 = RGB1[0];
    assign GLM_G2 = RGB1[1];
    assign GLM_B2 = RGB1[2];


    localparam PIXEL_COLUMNS = 64; // screen width in pixels
    localparam PIXEL_LINES   = 16; // screen height in pixels/2

    reg[6:0] counter = 0;
    
    assign RGB0 = (counter==63) ? 3'b001 : 3'b000;
    assign RGB1 = 3'b000;

    // clock divisor (outputs 60Hz)
    wire clk_master;
    clock_divisor clkdiv(.clk(clk),.clk_out(clk_master));

    // register to control LATCH output
    reg        LAT_EN;

    // output enable controller
    wire OE;
    assign GLM_OE = !OE;
    oe_controller oe_ctrl(.clk(clk_master),.rst(0),.cnt(counter),.OE(OE));

    // prints only first line
    assign ADDR = 4'b0000;

    // shift registers clock driver
    assign clk_out = (counter<PIXEL_COLUMNS) ? clk_master : 1;

    // design pattern
    assign RGB0 = (counter==63) ? 3'b001 : 3'b000;
    assign RGB1 = 3'b000;
    
    always @(negedge clk_master) begin
        // async reset logic
        if (!rst) begin
            LATCH         <= 0;
            LAT_EN        <= 1;
            counter       <= 7'd0;
        end else begin
            // increment clock counter
            counter <= counter + 7'd1;

            // LATCH signal handling
            // PIXEL_COLUMNS+1 clock cycle LATCHES
            if (counter==PIXEL_COLUMNS & LAT_EN) begin
                LATCH <= 1;
            // PIXEL_COLUMNS+2 clock cycle UNLATCH
            end else if (counter==PIXEL_COLUMNS+1 & LAT_EN) begin
                LATCH        <= 0;
                counter      <= 7'd0;
                LAT_EN       <=    0;
            end
        end
    end
endmodule

module clock_divisor (
    input       clk,
    output  clk_out
);

    reg[11:0] counter;
    assign clk_out = counter[11];
    always @(negedge clk) counter = counter + 1;
endmodule

module oe_controller(
    input      clk,
    input      rst,
    input[6:0] cnt,
    output reg  OE
);

    always @(negedge clk) begin
        if (!rst) begin
            OE      = 1;
        end else begin
            if (cnt<OE_INTENSITY) OE = 0; else OE = 1;
        end
    end
endmodule
