module fsm_moore(
    input wire clk,
    input wire reset,
    input wire ce,                  // Clock enable dari clock_divider
    input wire w,                   // Input dari SW0
    output reg y,                   // Output deteksi
    output wire [1:0] state_display // State untuk seven-segment
);

    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;
    parameter S3 = 2'b11;

    reg [1:0] curr;
    reg [1:0] next;

    assign state_display = curr;

    // Register state
    always @(posedge clk or posedge reset) begin
        if (reset)
            curr <= S0;
        else if (ce)
            curr <= next;
    end

    // Logika next state dan output Moore
    always @(*) begin
        y = (curr == S3);   // Moore: output hanya bergantung pada current state

        case (curr)
            S0: begin
                if (w == 1'b0)
                    next = S0;
                else
                    next = S1;
            end

            S1: begin
                if (w == 1'b0)
                    next = S2;
                else
                    next = S1;
            end

            S2: begin
                if (w == 1'b0)
                    next = S0;
                else
                    next = S3;
            end

            S3: begin
                if (w == 1'b0)
                    next = S2;
                else
                    next = S1;
            end

            default: begin
                next = S0;
            end
        endcase
    end

endmodule