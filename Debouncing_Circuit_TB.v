// Edge Detector
module  Debouncing_Circuit_TB # (parameter tic_tb =10) ();
    reg  CLK_tb;
    reg  RST_tb;
    reg  SW_tb;
    wire db_tb;

Debouncing_Circuit #(.tic(tic_tb)) dut(
.CLK(CLK_tb),
.RST(RST_tb),
.SW(SW_tb),
.db(db_tb) );

always #5 CLK_tb = ~CLK_tb ;

initial
begin

 // System Functions
 $dumpfile("debouncing circuit.vcd") ;       
 $dumpvars; 
CLK_tb = 1'b0;
RST_tb = 1'b0;
SW_tb  = 1'b0;
#10
RST_tb = 1'b1;

#10 SW_tb = 1'b1;
#250 SW_tb =1'b0;
#20 SW_tb = 1'b1;
#20 SW_tb = 1'b0;
#20 SW_tb = 1'b1;
#20 SW_tb = 1'b1;
#20 SW_tb = 1'b0;
#20 SW_tb = 1'b1;
#2000 SW_tb =1'b0;
#2000
$stop;
end


endmodule