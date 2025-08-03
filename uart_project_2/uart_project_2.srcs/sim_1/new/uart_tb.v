`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2025 12:21:08 PM
// Design Name: 
// Module Name: uart_tb
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

module uart_tb;

  localparam CLK_FREQ = 100_000_000;
  localparam BAUD_RATE = 115200;
  
  
  localparam CLK_PERIOD_NS = 1_000_000_000 / CLK_FREQ;
  localparam BIT_PERIOD_NS = 1_000_000_000 / BAUD_RATE;
  
  
  
  reg tb_clock;
  reg tb_rx;
  wire tb_tx;
  
  
  
  uart_top #(
  .SYS_CLK_FREQ(CLK_FREQ),
  .BAUD_RATE(BAUD_RATE)
  )
  dut (
  .i_clk(tb_clock),
  .i_Rx_Pin(tb_rx),
  .o_Tx_Pin(tb_tx)
  );
  
  
  
  always #(CLK_PERIOD_NS/2) tb_clock = ~tb_clock;
  
  
  
  initial begin
  
    $display("Starting UART Testbench...");
    tb_clock = 0;
    tb_rx = 1;
    
    
    #(20_000);
    
    send_byte("A");
    #(150_000);
    
    
    send_byte("U");
    #(150_000);
    
    
    $display("Test Complete.");
    $finish;
  end
  
  
  
  
task send_byte(input [7:0] data);
    begin
        $display("Sending byte: %c (0x%h)", data, data);
        
        
        tb_rx = 1'b0;
        #(BIT_PERIOD_NS);
        
        
        for (integer i = 0; i <8; i = i+1) 
            begin
                tb_rx = data[i];
                #(BIT_PERIOD_NS);
            end
            
            
          tb_rx = 1'b1;
          #(BIT_PERIOD_NS);
          
          
          $display("Finished sending byte.");
        end
      endtask
    
endmodule
