module uartT(input clk,rst,wr,enb,input [7:0]data_in,output reg tx,output reg busy);
  
    parameter idle   = 2'b00;
    parameter start  = 2'b01;
    parameter data_s = 2'b10;
    parameter stop   = 2'b11;
  
    reg [1:0] state;
    reg [7:0] data;
    reg [2:0] index;

    always @(posedge clk) begin
      if(rst) begin
        state <= idle;
        tx <= 1'b1;   
        busy <= 1'b0;
        index<= 3'b000;
        data <= 8'b0;
      end
      else begin
        case (state)
          idle: begin
            tx<= 1'b1;
            busy <= 1'b0;
            if(wr) begin
              data<= data_in;
              busy <= 1'b1;
              state <= start;
            end
          end    
          start: begin
            tx <= 1'b0;   
            busy <= 1'b1;
            if(enb) begin
              index<= 3'b000;
              state<= data_s;
            end
          end
          data_s: begin
            busy <= 1'b1;
            tx <= data[index];
            if(enb) begin
              if(index == 3'b111)
                state <= stop;
              else
                index <= index + 1;
            end
          end
          stop: begin
            tx<= 1'b1;  
            busy <= 1'b1;
            if(enb) begin
              busy <= 1'b0;
              state <= idle;
            end
          end
          default: begin
            state <= idle;
          end
        endcase
      end
    end
endmodule

