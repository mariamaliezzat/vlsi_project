module top #(
    parameter DATA_WIDTH =12,
    parameter NUM_STAGES =2

) (
    input   wire                                    clk,
    input   wire                                    rst_n,
    input   wire                                    load_in,
    input   wire    signed  [DATA_WIDTH - 1 : 0]    data_in,
    output  reg     signed  [DATA_WIDTH - 1 : 0]    data_out
);
    wire                                         sel              ;
    wire                                         enable           ;
    reg       signed    [DATA_WIDTH-1:0]         acc              ;
    wire      signed    [DATA_WIDTH-1:0]         mux_out          ;
    wire      signed    [2*DATA_WIDTH-1:0]       mul_out_long     ;
    wire      signed    [DATA_WIDTH-1:0]         mul_out          ;
    
    /*************internal signals**********************/
    wire                                            load_in_sync;
    wire                        [1:0]               count       ;
    wire        signed          [DATA_WIDTH-1:0]    fifo_r_data ;  
    wire        signed          [DATA_WIDTH-1:0]    rom_r_data  ;

    /*********************mux**********************/
    assign mux_out      = sel ? 'd0 : acc          ;
    assign mul_out_long = rom_r_data * fifo_r_data ;
    assign mul_out      = mul_out_long >> 11       ;
    always @(posedge clk , negedge rst_n) 
        begin
            if (!rst_n) 
                begin
                    acc <= 'd0;
                end 
            else 
                begin
                    acc <= mul_out + mux_out ;
                end
        end
    always @(posedge clk , negedge rst_n) 
        begin
            if (!rst_n) 
                begin
                    data_out <= 'd0;
                end 
            else 
                begin
                    if (enable) 
                        begin
                            data_out <= acc;
                        end
                    
                end
        end

    load_sync #(.NUM_STAGES(NUM_STAGES)) load_sync0
    (
        .clk(clk),
        .rst_n(rst_n),
        .load_in(load_in),
        .load_in_sync(load_in_sync)
    );
    ///////////////////////////////////////////////////////////

    counter counter0 
    (
        .clk(clk),
        .rst_n(rst_n),
        .load_in_sync(load_in_sync),
        .count(count)
    );

    /////////////////////////////////////////////////////////////
   
    shift_reg #(.DATA_WIDTH(DATA_WIDTH)) shift_reg0
    (
        .clk(clk),
        .rst_n(rst_n),
        .load_in_sync(load_in_sync),
        .data_in(data_in),
        .fifo_r_address(count),
        .fifo_r_data(fifo_r_data)
    );
    ///////////////////////////////////////////////////////////

    ROM #(.DATA_WIDTH(DATA_WIDTH)) ROM0
    (
        .rom_r_address(count),
        .rom_r_data(rom_r_data)
    );
endmodule