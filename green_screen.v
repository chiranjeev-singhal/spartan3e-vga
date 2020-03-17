`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:15:28 05/27/2016 
// Design Name: 
// Module Name:    green_screen 
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
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:33:16 11/03/2015 
// Design Name: 
// Module Name:    orange 
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
module green(clock,hs,vs,r,b,g
    );
output reg [2:0] r,g;
output reg [2:1] b;
output reg hs,vs;
input clock;
//input [7:0] data;

// for make clk of 25MHZ one for hsync and 2nd for vsync
reg clk=0,
	 cntv=0;

// two conter of 10 bit
reg [9:0] hc=0,//for hsync
          vc=0;//for vsync

// take wires for split the screen vertically			 
wire hdisp,vdisp;

//for make clk of 25 MHz
always@(posedge clock)
begin
clk=~clk;
end

//for hsyc and cntv for make the line (800 clock) for vsyc 
always@(posedge clk)
begin
	if(hc<95)
	    begin
	      hs<=0;
			hc<=hc+1;
			cntv<=0;
			end
		else if(hc>=95 && hc<799)
				begin
				hs<=1;
				hc<=hc+1;
				cntv<=0;
				end
			else if(hc==799)
				begin
				hs<=0;
				hc<=0;
				cntv<=cntv+1;
				end
		else
	     begin
	      hc<=hc+1;
	       hs<=hs;
	       cntv<=0;
	     end
end
	
	//for vsyc from cntv clock =16000 clk(clk_out)//
	always@(posedge cntv)
	begin
		if(vc<2)
			begin
			vs<=0;
			vc<=vc+1;
			end
		else if(vc>=2 && vc<520)
				begin
				vs<=1;
				vc<=vc+1;
				end
		else if(vc==520)
				begin
				vc<=0;
				vs<=0;
				end
		else
			begin
			vc<=vc+1;
			vs<=vs;
			end
	end

//use data flow to avoide multisoursin "in place and rout error" use wires
assign hdisp = (hc>=143 && hc<=783) ?1'b1:1'b0;
assign vdisp = (vc>=30 && vc<=510) ? 1'b1:1'b0;

always@(hdisp,vdisp)
begin
if( hdisp==1 && vdisp==1)
begin
r=3'b000;
g=3'b111;
b=2'b00;

//{b,g,r}=data;
end
else
begin
r=3'b111;
g=3'b111;
b=2'b11;
end

end
endmodule


module tb_orange;
wire [2:0] r;
wire [2:0] g;
wire [2:1] b;
reg clock;
wire hs;
wire vs;
reg [7:0] data;

green  inst (clock,hs,vs,r,b,g
                  );
						
initial
begin
clock <= 0;
end

always #1
clock <= ~clock;
endmodule
