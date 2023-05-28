module ROM #(
    parameter DATA_WIDTH    = 12
) (
    input     [1:0]                     rom_r_address,
    output    [DATA_WIDTH-1:0]          rom_r_data
      
);
    reg     [DATA_WIDTH-1:0] ROM [0:3];
 
    initial 
        begin
            ROM[0] = 'b0_10000000000;
            ROM[1] = 'b1_11000000000;
            ROM[2] = 'b0_00101000000;
            ROM[3] = 'b1_11110000000;
        end
    assign  rom_r_data = ROM[rom_r_address];
endmodule
