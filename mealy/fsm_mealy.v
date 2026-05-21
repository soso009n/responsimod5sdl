module fsm_mealy(
    input wire clk,
    input wire reset,
    input wire ce,                  // Enter dari BTN-C
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

    // Logika next state dan output Mealy
    always @(*) begin
        next = curr;
        y = 1'b0;

        case (curr)
            S0: begin
                if (w == 1'b0) begin
                    next = S0;
                    y = 1'b0;
                end else begin
                    next = S1;
                    y = 1'b0;
                end
            end

            S1: begin
                if (w == 1'b0) begin
                    next = S2;
                    y = 1'b0;
                end else begin
                    next = S1;
                    y = 1'b0;
                end
            end

            S2: begin
                if (w == 1'b0) begin
                    next = S3;
                    y = 1'b0;
                end else begin
                    next = S0;
                    y = 1'b0;
                end
            end

            S3: begin
                if (w == 1'b0) begin
                    next = S0;
                    y = 1'b0;
                end else begin
                    next = S2;
                    y = 1'b1; // Mealy: y aktif saat current state S3 dan w=1
                end
            end

            default: begin
                next = S0;
                y = 1'b0;
            end
        endcase
    end

endmodule