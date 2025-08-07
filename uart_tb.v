`timescale 1ns/10ps

module top_tb;

//inputs
 reg i_clk = 0;
 reg i_uart_rxd = 1'b1;
 reg r_tx_dv = 0;
 reg [7:0] r_tx_byte = 0;
 
 //outputs
 wire o_uart_txd;
 wire o_rx_dv_led;
 wire o_tx_active_led;
 wire o_tx_done;
 wire[7:0] w_rx_byte;
 
 
 parameter CLKS_PER_BIT = 87;
 parameter CLOCK_PERIOD_NS = 100;
 parameter BIT_PERIOD = CLKS_PER_BIT * CLOCK_PERIOD_NS;
 
 
 
 task UART_WRITE_BYTE;
 input[7:0] i_Data;
 integer ii;
 begin
 
    i_uart_rxd <= 1'b0;
    #(BIT_PERIOD);
    
    
    for (ii = 0; ii < 8; ii = ii + 1)
        begin
            i_uart_rxd <= i_Data[ii];
            #(BIT_PERIOD);
           end
           
           i_uart_rxd <= 1'b1;
        #(BIT_PERIOD);
 end
 endtask
 
 
 //DUT
 uart_top_2 dut (
 .i_clk (i_clk),
 .i_uart_rxd(i_uart_rxd),
 .i_tx_dv(r_tx_dv),
 .i_tx_byte(r_tx_byte),
  .o_tx_done(o_tx_done),
  .o_rx_byte(w_rx_byte),
 .o_uart_txd(o_uart_txd),
 .o_rx_dv_led(o_rx_dv_led),
 .o_tx_active_led(o_tx_active_led)
 );
 
 
 
 always 
    #(CLOCK_PERIOD_NS/2) i_clk <= ~i_clk;
    
    
    
   initial begin
   $dumpfile("uart_tb.vcd");
   $dumpvars(0, top_tb);
   
   
    @(posedge i_clk);
    @(posedge i_clk);
    r_tx_dv <= 1'b1;
    r_tx_byte <= 8'hAB;
    @(posedge i_clk);
    r_tx_dv <= 1'b0;
    
    $display("Time %t: Testbench is now waiting for o_tx_done...", $time);
    
    @(posedge o_tx_done);
    
    
    $display("Time %t: Testbench received o_tx_done! Continuing...", $time);
    
    @(posedge i_clk);
    UART_WRITE_BYTE(8'h3F);
  //  wait (o_rx_dv_led == 1'b1);
    @(posedge i_clk);
    
    
    if (w_rx_byte == 8'h3F)
        $display("Test Passed");
    else
        $display("Test Failed: Expected 0x3F, but received 0x%h", w_rx_byte);
        
      $finish;
     end 
 
 endmodule

