//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2025 12:20:22 PM
// Design Name: 
// Module Name: uart_top
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


module uart_top(
    input i_clk,
    input i_Rx_Pin,
    output o_Tx_Pin
    );
    
    
  parameter SYS_CLK_FREQ = 100_000_000;
  parameter BAUD_RATE = 115200;
  
  
  localparam CLKS_PER_BIT = SYS_CLK_FREQ / BAUD_RATE;
  
  
  
  wire[7:0] w_Rx_Byte;
  wire w_Rx_DV;
  
  
  
  wire w_Tx_Active;
  wire w_Tx_Done;
  
  
  
  uart_rx #(
  .CLKS_PER_BIT(CLKS_PER_BIT)
  )
  
  inst_uart_rx (
  .i_clk(i_clk),
  .i_Rx_Serial (i_Rx_Pin),
  .o_Rx_DV (w_Rx_DV),
  .o_Rx_Byte (w_Rx_Byte)
  );  
  
  
  uart_tx #(
  .CLKS_PER_BIT(CLKS_PER_BIT)
  )
  
  inst_uart_tx (
  .i_clk (i_clk),
  .i_Tx_DV (w_Rx_DV),
  .i_Tx_Byte (w_Rx_Byte),
  .o_Tx_Active (w_Tx_Active),
  .o_Tx_Serial (o_Tx_Pin),
  .o_Tx_Done (w_Tx_Done)
  );
     
endmodule
