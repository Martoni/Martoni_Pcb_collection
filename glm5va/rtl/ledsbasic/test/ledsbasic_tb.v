`timescale 1ns/100ps

module ledsbasic_tb ();

    reg clk=0;
    reg led1;
    reg GLM_R1;
    reg GLM_R2;
    reg GLM_G1;
    reg GLM_G2;
    reg GLM_B1;
    reg GLM_B2;
    reg GLM_A;
    reg GLM_B;
    reg GLM_C;
    reg GLM_OE;
    reg GLM_LAT;
    reg GLM_CLK;
    reg GLM_LED1;
    reg GLM_LED2;
    reg GLM_LED3;
    reg GLM_LED4;

    /* DUT */
    ledsbasic lb0(
        .clk(clk),
    .led1(led1),
    .GLM_R1    (GLM_R1  ), 
    .GLM_R2    (GLM_R2  ), 
    .GLM_G1    (GLM_G1  ), 
    .GLM_G2    (GLM_G2  ), 
    .GLM_B1    (GLM_B1  ), 
    .GLM_B2    (GLM_B2  ), 
    .GLM_A     (GLM_A   ),
    .GLM_B     (GLM_B   ),
    .GLM_C     (GLM_C   ),
    .GLM_OE    (GLM_OE  ), 
    .GLM_LAT   (GLM_LAT ),  
    .GLM_CLK   (GLM_CLK ),  
    .GLM_LED1  (GLM_LED1),   
    .GLM_LED2  (GLM_LED2),   
    .GLM_LED3  (GLM_LED3),   
    .GLM_LED4  (GLM_LED4));


    always
        #1 clk = !clk;

    initial begin
        $dumpfile("ledsbasic_tb.vcd");
        $dumpvars(0, lb0); 
    end

    initial begin
        $display("Testbench begin");
        #10000
        $display("end testbench");
        $finish();
    end

endmodule
