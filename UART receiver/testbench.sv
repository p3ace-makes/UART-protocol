module uartR_tb;
  reg clk,rst,enb,rx;
  wire [7:0]data_out;
  wire rdy;
  uartR test (.clk(clk),.rst(rst),.enb(enb),.rx(rx),.data_out(data_out),.rdy(rdy));
  initial clk=0;
  always #5clk=~clk;
  initial begin
    rst=1;
    enb=0;
    rx=1;
    #20;
    rst = 0;
    enb = 1;
    rx = 0;
    repeat(16) @(posedge clk);

    rx = 1; repeat(16) @(posedge clk); 
    rx = 0; repeat(16) @(posedge clk); 
    rx = 1; repeat(16) @(posedge clk); 
    rx = 1; repeat(16) @(posedge clk); 
    rx = 0; repeat(16) @(posedge clk); 
    rx = 1; repeat(16) @(posedge clk); 
    rx = 0; repeat(16) @(posedge clk); 
    rx = 1; repeat(16) @(posedge clk); 

    rx = 1;
    repeat(16) @(posedge clk);

    #50;
    $finish;
   end
   initial begin
     $monitor("t=%0t state=%b sample=%d index=%d rx=%b data=%b data_out=%b rdy=%b",$time,test.state,test.sample,test.index,rx,test.data,data_out,rdy);
            
end
endmodule              