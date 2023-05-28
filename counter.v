module counter #(
) (
    input                           clk,
    input                           rst_n,
    input                           load_in_sync,
    output      reg     [1:0]       count    

);  
    reg     flag ;   
    always @(posedge clk , negedge rst_n) 
        begin
            if (!rst_n) 
                begin
                    flag    <=  'd0 ;
                end 
            else 
                begin
                    if (load_in_sync) 
                        begin
                            flag    <=  'd1;
                        end
                    else if (count == 'd3) 
                        begin
                            flag    <=  'd0;
                        end
                    
                end
        end 
    always @(posedge clk , negedge rst_n) 
        begin
            if (!rst_n) 
                begin
                    count   <=  'd0 ;
                end 
            else 
                begin
                    if (flag) 
                        begin
                            count <= count +'d1;
                        end 
                    else 
                        begin
                            count <=    'd0;
                        end
                end
        end
endmodule