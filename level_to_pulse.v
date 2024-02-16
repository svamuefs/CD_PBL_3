module level_to_pulse #(
    parameter   IDLE      = 2'b00 ,
                PULSE       = 2'b01 ,
                PULSE_END   = 2'b10
) (
    input   clk ,
            level ,
            reset ,

    output  reg pulse ,

    output  reg [1:0]   state ,
                         next 
);
    always @(posedge clk or negedge reset) begin
        if (!reset) state <= IDLE;
        else state <= next;
    end

    always @* begin
        next = IDLE;
        case (state)
            IDLE:       if (level)  next = PULSE;
            PULSE:      if (level)  next = PULSE_END;
            PULSE_END:  if (level) next = PULSE_END; 
        endcase
    end

    always @(posedge clk or negedge reset) begin
        if (!reset) pulse <= 1'b0;
        else if (next == PULSE) pulse <= 1'b1;
        else pulse <= 1'b0;
    end

endmodule