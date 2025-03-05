module fourleds (
    input clk,
    output led1,
    output GLM_LED1,
    output GLM_LED2,
    output GLM_LED3,
    output GLM_LED4);

    reg [3:0] ledscount;

    always@(posedge clk) begin
        ledscount <= ledscount + 1;    
    end;

    assign led1=1'b0;
    assign GLM_LED1=ledscount[0];
    assign GLM_LED2=ledscount[1];
    assign GLM_LED3=ledscount[2];
    assign GLM_LED4=ledscount[3];

endmodule

