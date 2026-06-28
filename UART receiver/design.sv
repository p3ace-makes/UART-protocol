module uartR(input clk,rst,enb,rx,output reg [7:0]data_out,output reg rdy);
  parameter start=2'b00;
  parameter data_s=2'b01;
  parameter stop=2'b10;
  reg [1:0]state;
  reg [3:0]sample;
  reg [2:0]index;
  reg [7:0]data;
  always@(posedge clk)begin
    if(rst) begin
      state<=start;
      rdy<=0;
      sample<=0;
      index<=0;
      data<=0;
      data_out<=0;
    end
    else begin
      case(state)
        start:begin
          if(enb) begin
            if(rx==0 && sample!=4'hF) begin
              sample<=sample + 1'b1;
            end
            else if(sample==4'hF)begin
              state<=data_s;
              rdy<=0;
              sample<=0;
              index<=0;
            end
          end
        end
        data_s: begin
    	  if(sample == 4'd8)
          data[index] <= rx;    
    	  if(sample == 4'd15) begin
          sample <= 0;
            if(index == 3'd7) begin
              index <= 0;
              state <= stop;    
            end
            else
              index <= index + 1'b1;
          end
          else
            sample <= sample + 1'b1;
		end
        stop:begin
          if(sample==4'hF) begin
            state<=start;
            sample<=0;
            data_out<=data;
            rdy<=1;
          end
          else
    		sample <= sample + 1'b1;
        end
        default:begin
          state<=start;
        end
      endcase
    end
  end
endmodule    