module mux4x1 #(                                            //isto é de fato, na realidade, um mux4x1
    parameter   DATAWIDTH   = 4
) (
    input [DATAWIDTH-1:0]   IN_A , IN_B , IN_C , IN_D ,
    input [1:0] slc ,

    output reg [DATAWIDTH-1:0]  out
);

always @* begin
    case (slc)
        2'b00: out = IN_A;
        2'b01: out = IN_B;
        2'b10: out = IN_C;
        2'b11: out = IN_D;
    endcase
end
    
endmodule