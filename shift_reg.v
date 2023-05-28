module shift_reg #(
    parameter      DATA_WIDTH = 12
) (
    input                                           clk,
    input                                           rst_n,
    input                                           load_in_sync,
    input         signed        [DATA_WIDTH-1:0]    data_in,
    input                       [1:0]               fifo_r_address,
    output  wire                [DATA_WIDTH-1:0]    fifo_r_data                
);
    reg [DATA_WIDTH-1:0] shift_reg [0:3];
    integer  i;
    assign  fifo_r_data = shift_reg[fifo_r_address];
always @(posedge clk ,negedge rst_n) 
    begin
        if (!rst_n) 
            begin
                shift_reg[0] <= 'd0;
                shift_reg[1] <= 'd0;
                shift_reg[2] <= 'd0;
                shift_reg[3] <= 'd0;
            end 
        else 
            begin
                if (load_in_sync) 
                    begin
                        shift_reg[0] <= data_in ;
                        shift_reg[1] <= shift_reg[0];
                        shift_reg[2] <= shift_reg[1];
                        shift_reg[3] <= shift_reg[2];
                    end 
            end
    end
endmodule
