module top(
    input wire clk_100MHz,   // Pin E3
    input wire sw0,          // SW0 sebagai input w
    input wire btnd,         // BTN-D sebagai reset
    output wire led_y,       // LD0 sebagai output y
    output wire led_hb,      // LD15 sebagai heartbeat
    output wire [6:0] seg,   // Katoda seven-segment
    output wire [7:0] an     // Anoda seven-segment
);

    wire rst;
    wire ce_2s;
    wire y;
    wire [1:0] st;

    // Debouncer untuk tombol reset BTN-D
    debouncer db_r (
        .clk(clk_100MHz),
        .btn_in(btnd),
        .btn_pulse(),
        .btn_level(rst)
    );

    // Clock divider untuk trigger FSM setiap 2 detik
    clock_divider div (
        .clk_100MHz(clk_100MHz),
        .reset(rst),
        .ce_2s(ce_2s),
        .led_hb(led_hb)
    );

    // FSM Moore
    fsm_moore fsm (
        .clk(clk_100MHz),
        .reset(rst),
        .ce(ce_2s),
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