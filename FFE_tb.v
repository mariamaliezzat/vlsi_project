`timescale 1ns/1ps
module FFE_tb ();
    parameter DATA_WIDTH_tb = 12 ;

    parameter   FFE_CLK_PERIOD  = 250 ,     // 4MHz clock
                FFE_HIGH_PERIOD = 0.5 * FFE_CLK_PERIOD ,
                FFE_LOW_PERIOD  = 0.5 * FFE_CLK_PERIOD ;

    parameter   DATA_CLK_PERIOD  = 1000 ,     // 1MHz clock
                DATA_HIGH_PERIOD = 0.5 * DATA_CLK_PERIOD ,
                DATA_LOW_PERIOD  = 0.5 * DATA_CLK_PERIOD ;

    parameter LENGTH = 32 ;

    reg                                     ffe_clk_tb;
    reg                                     rst_n_tb;
    reg                                     data_clk_tb;
    reg                                     load_in_tb;
    reg     signed [DATA_WIDTH_tb - 1 : 0]  data_in_tb ;
    wire    signed [DATA_WIDTH_tb - 1 : 0]  data_out_tb;
    wire                                    data_valid_tb;

    reg     signed [DATA_WIDTH_tb - 1 : 0] data_in_ref_tb  [LENGTH - 1 : 0];
    reg     signed [DATA_WIDTH_tb - 1 : 0] data_out_ref_tb [LENGTH - 1 : 0];


    integer i;

always  
    begin
        #FFE_HIGH_PERIOD ffe_clk_tb = 1'b0;
        #FFE_LOW_PERIOD ffe_clk_tb =  1'b1;
    end

always #(DATA_HIGH_PERIOD)
    begin
        #50 data_clk_tb = ~data_clk_tb;     
    end



initial begin
    $dumpfile("FFE.vcd");
    $dumpvars;
    
    intialize();
    
    for (i = 0; i < LENGTH ; i = i + 1 ) begin
        @(posedge data_clk_tb)
        data_in_tb = data_in_ref_tb[i];
        load_in_tb = 1'b1;
        #(FFE_CLK_PERIOD + 1)
        load_in_tb = 1'b0;
        @(posedge data_valid_tb)
        if (data_out_tb <= data_out_ref_tb[i] + 2 && data_out_tb >= data_out_ref_tb[i] - 2) begin
            $display("Test[%d]: Success!\n",i);
        end else begin
            $display("Test[%d]: FAIL!\n",i);
        end
    end
    #(10*DATA_CLK_PERIOD)
    $stop;
end



task intialize;
    begin
        $readmemb("data_in_ref.txt",data_in_ref_tb);
        $readmemb("data_out_ref.txt",data_out_ref_tb);
        load_in_tb = 1'b0;
        data_in_tb = 'd0;
        ffe_clk_tb = 1'b1;
        rst_n_tb = 1'b1;
        data_clk_tb = 1'b1;
        #(0.3*FFE_CLK_PERIOD)
        rst_n_tb = 1'b0;
        #FFE_HIGH_PERIOD
        rst_n_tb = 1'b1;
        
    end
endtask


FFE_top #(.DATA_WIDTH(DATA_WIDTH_tb)) DUT
(
.clk(ffe_clk_tb),
.rst_n(rst_n_tb),
.load_in(load_in_tb),
.data_in(data_in_tb),
.data_out(data_out_tb),
.data_valid(data_valid_tb)
);




endmodule