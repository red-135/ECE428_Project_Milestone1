`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:08:44 05/09/2013 
// Design Name: 
// Module Name:    addrgen_2_b 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module addrgen_2_b( clk , addr_2b , en_ram2 ,Reset_Main, VtcVde );

input clk ;
input Reset_Main ;
input VtcVde ;
output en_ram2 ;
output [17:0] addr_2b ;

reg [17:0] cnt ;
reg en_ram2 ;

assign addr_2b = cnt ;

always @ (posedge clk)
begin
    if (Reset_Main == 1'b1)
	 begin
        cnt = 18'b0;
		  en_ram2 = 1'b0 ;
     end
	 else
	 begin
    if (VtcVde == 1'b1)
    begin	 
     if (cnt == 18'b100101011111111111)
      begin
		  cnt = 18'b0;
		  en_ram2 = 1'b1 ;
		 end
    else
	 begin
        cnt = cnt + 1;
		  en_ram2 = 1'b1 ;
	 end 
	end
end
end 
endmodule
