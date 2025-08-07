
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2025 09:13:42 AM
// Design Name: 
// Module Name: uart_top_2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_top_2(
    input i_clk,
    input i_uart_rxd,
    input i_tx_dv,
    input[7:0] i_tx_byte,
    output[7:0] o_rx_byte,
    output o_uart_txd,
    output o_rx_dv_led,
    output o_tx_done,
    output o_tx_active_led
    );
    
    parameter CLKS_PER_BIT = 868;
    
    
        wire[7:0] rx_byte;
        wire rx_dv;
        wire tx_active;
        wire tx_done;
    
    
    
    uart_rx#(
    .CLKS_PER_BIT(CLKS_PER_BIT))
    i_uart_rx (
    .i_clk (i_clk),
    .i_Rx_Serial(i_uart_rxd),
    .o_Rx_Byte(rx_byte),
    .o_Rx_DV(rx_dv)
    );
    
    
    uart_tx#(
    .CLKS_PER_BIT(CLKS_PER_BIT))
    i_uart_tx (
    .i_clk(i_clk),
    .i_Tx_DV(i_tx_dv),
    .i_Tx_Byte(i_tx_byte),
    .o_Tx_Serial(o_uart_txd),
    .o_Tx_Active(tx_active),
    .o_Tx_Done(tx_done)
    );
    
    
    assign o_rx_dv_led = rx_dv;
    assign o_tx_active_led = tx_active;
    assign o_tx_done = tx_done;
    assign o_rx_byte = rx_byte;
    
    
    
endmodule
