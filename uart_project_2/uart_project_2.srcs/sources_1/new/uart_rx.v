//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2025 12:15:41 PM
// Design Name: 
// Module Name: uart_rx
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

module uart_rx
#(parameter CLKS_PER_BIT = 87)
    (
    input i_clk,
    input i_Rx_Serial,
    output [7:0] o_Rx_Byte,
    output o_Rx_DV
    );
    
    
    localparam s_IDLE = 3'b000;
    localparam s_RX_START_BIT = 3'b001;
    localparam s_RX_DATA_BITS = 3'b010;
    localparam s_RX_STOP_BIT = 3'b011;
    localparam s_CLEANUP = 3'b100;
    
    
    reg r_Rx_Data_R = 1'b1;
    reg r_Rx_Data = 1'b1;
    
    
    reg[7:0] r_Clock_Count = 0;
    reg[7:0] r_Rx_Byte = 0;
    reg[2:0] r_Bit_Index = 0;
    reg[2:0] r_SM_Main = 0;
    reg r_Rx_DV = 0;
    
    always @(posedge i_clk)
        begin
            r_Rx_Data_R <= i_Rx_Serial;
            r_Rx_Data <= r_Rx_Data_R;
        end
        
     always @(posedge i_clk)
        begin
            case (r_SM_Main)
                s_IDLE:
                    begin
                        r_Clock_Count <= 0;
                        r_Bit_Index <= 0;
                        r_Rx_DV <= 1'b0;
                    
                    if (r_Rx_Data == 1'b0)
                            r_SM_Main <= s_RX_START_BIT;
                    else  
                            r_SM_Main <= s_IDLE;
                    end
                    
                s_RX_START_BIT:
                     begin
                        if (r_Clock_Count == (CLKS_PER_BIT-1)/2)
                            begin   
                                if (r_Rx_Data == 1'b0)
                                    begin   
                                        r_Clock_Count <= 0;
                                        r_SM_Main <= s_RX_DATA_BITS;
                                    end
                                else
                                     r_SM_Main <= s_IDLE;
                             end
                        else
                            begin
                                r_Clock_Count <= r_Clock_Count +1;
                                r_SM_Main <= s_RX_START_BIT;
                            end
                      end
                      
                s_RX_DATA_BITS:
                    begin
                        if (r_Clock_Count < CLKS_PER_BIT-1)
                            begin
                                r_Clock_Count <= r_Clock_Count + 1;
                                r_SM_Main <= s_RX_DATA_BITS;
                            end
                        else
                            begin
                                r_Clock_Count <= 0;
                                r_Rx_Byte[r_Bit_Index] <= r_Rx_Data;
                                
                                    if (r_Bit_Index < 7)
                                        begin
                                            r_Bit_Index <= r_Bit_Index + 1;
                                            r_SM_Main <= s_RX_DATA_BITS;
                                        end
                                    else
                                        begin 
                                            r_Bit_Index <= 0;
                                            r_SM_Main <= s_RX_STOP_BIT;
                                        end
                            end
                     end
                     
                s_RX_STOP_BIT:
                    begin
                        if (r_Clock_Count < CLKS_PER_BIT-1)
                            begin
                                r_Clock_Count <= r_Clock_Count + 1;
                                r_SM_Main <= s_RX_STOP_BIT;
                            end
                        else
                            begin
                                r_Clock_Count <= 0;
                                r_Rx_DV <= 1'b1;
                                r_SM_Main <= s_CLEANUP;
                            end
                     end
                     
                s_CLEANUP:
                    begin
                        r_Rx_DV <= 1'b0;
                        r_SM_Main <= s_IDLE;
                    end
                
                default:
                  r_SM_Main <= s_IDLE;
        
         endcase
     end
     
   assign o_Rx_DV = r_Rx_DV;
   assign o_Rx_Byte = r_Rx_Byte;
                               
                            
endmodule
