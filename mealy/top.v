module top(
    input wire clk_100MHz,   // Pin E3
    input wire sw0,          // SW0 sebagai input w
    input wire btnc,         // BTN-C sebagai enter
    input wire btnd,         // BTN-D sebagai reset
    output wire led_y,       // LD0 sebagai output y
    output wire led_hb,      // LD15 sebagai heartbeat
    output wire [6:0] seg,   // Katoda seven-segment
    output wire [7:0] an     // Anoda seven-segment
);

    wire enter_p;
    wire rst_l;
    wire y;
    wire [1:0] st;

    // Debouncer untuk tombol enter BTN-C
    debouncer db_e (
        .clk(clk_100MHz),
        .btn_in(btnc),
        .btn_pulse(enter_p),
        .btn_level()
    );

    // Debouncer untuk tombol reset BTN-D
    debouncer db_r (
        .clk(clk_100MHz),
        .btn_in(btnd),
        .btn_pulse(),
        .btn_level(rst_l)
    );

    // Clock divider hanya untuk heartbeat LED
    clock_divider hb (
        .clk_100MHz(clk_100MHz),
        .reset(rst_l),
        .ce_2s(),
        .led_hb(led_hb)
    );

    // FSM Mealy
    fsm_mealy fsm (
        .clk(clk_100MHz),
        .reset(rst_l),
        .ce(enter_p),
        .w(sw0),
        .y(y),
        .state_display(st)
    );

    // Seven-segment display
    display disp (
        .clk(clk_100MHz),
        .w_in(sw0),
        .y_out(y),
        .state(st),
        .seg(seg),
        .an(an)
    );

    assign led_y = y;

endmodule