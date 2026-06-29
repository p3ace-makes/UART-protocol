module uartT_tb;
  reg clk, rst, wr, enb;
  reg [7:0] data_in;
  wire tx, busy;

  uartT dut (.clk(clk),.rst(rst),.wr(wr),.enb(enb),.data_in (data_in),.tx(tx),.busy(busy));
  
  always #5 clk = ~clk;
  initial begin
    clk = 0;
    rst = 1;
    wr = 0;
    enb = 0;
    
    #20;
    rst = 0;
    #10;
    data_in = 8'hA5;  
    wr = 1;
    
    #10;
    wr = 0;
    
    repeat (10) begin
      #20 enb = 1;   
      #10 enb = 0;
    end

    #20;
    $finish;
  end
  initial begin
    $monitor("Time=%0t rst=%b wr=%b enb=%b state=%b busy=%b tx=%b index=%0d",$time, rst, wr, enb, dut.state, busy, tx, dut.index);
  end
endmodule