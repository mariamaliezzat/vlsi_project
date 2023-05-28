module load_sync #(
    parameter NUM_STAGES = 2
) (
    input                                      clk,
    input                                      rst_n,
    input                                      load_in,
    output                                     load_in_sync
);
integer i;
reg [NUM_STAGES-1:0] Q;
    always @(posedge clk, negedge rst_n ) 
        begin
            if (!rst_n) 
                begin
                    Q <=0;
                end 
            else 
                begin
                    Q[0] <= load_in;
                    for (i = 1;i<NUM_STAGES ;i=i+1 ) 
                        begin
                            Q[i]<=Q[i-1];
                        end 
                end
            
        end
    assign load_in_sync = Q[NUM_STAGES-1];
endmodule