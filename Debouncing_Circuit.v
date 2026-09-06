// Edge Detector
module  Debouncing_Circuit #(parameter tic = 10)(
    input  wire  CLK,
    input  wire  RST,
    input  wire  SW,
    output reg  db
);

  localparam   Zero = 3'b000,
               One = 3'b001,
               Wait_1_1 = 3'b010,
               Wait_1_2 = 3'b011,
               Wait_1_3 = 3'b100,
               Wait_0_1 = 3'b101,
               Wait_0_2 = 3'b110,
               Wait_0_3 = 3'b111;

reg [2:0] current_state, next_state;
reg [5:0]counter;
reg m_tic;


always @(posedge CLK or negedge RST)
  begin
    if(!RST)
    begin
      current_state <= Zero;
      counter <= 0;
    end
    else 
    begin
      current_state <= next_state;
      if (counter == tic)
        begin
        m_tic <= 1'b1;
        counter <= 0;
        end
        else
        begin
        counter <= counter + 1;
        m_tic <= 1'b0;
        end
    end
  end

always @(*)
  begin
  db=1'b0;
  next_state = Zero; 
case(current_state)
Zero:
    begin
     if(SW)
        next_state = Wait_1_1;
     else
        next_state = Zero; 
    end

Wait_1_1:
   begin
     if(~SW)
     next_state = Zero;
     else if(SW && m_tic)
     next_state = Wait_1_2;
     else if(SW && ~m_tic)
     next_state = Wait_1_1;
   end

Wait_1_2:
   begin
     if(~SW)
     next_state = Zero;
     if(SW && m_tic)
     next_state = Wait_1_3;
     else if(SW && ~m_tic)
     next_state = Wait_1_2;
   end
Wait_1_3:
   begin
     if(~SW)
     next_state = Zero;
     else if(SW && m_tic)
     next_state = One;
     else if(SW && ~m_tic)
     next_state = Wait_1_3;
   end
One:
   begin
    db=1'b1;
     if(SW)
     next_state = One;
     else
     next_state = Wait_0_1;
   end
Wait_0_1:
   begin
    db=1'b1;
     if(SW)
     next_state = One;
     else if(~SW && m_tic)
     next_state = Wait_0_2;
     else if(~SW && ~m_tic)
     next_state = Wait_0_1;

   end
Wait_0_2:
   begin
    db=1'b1;
     if(SW)
     next_state = One;
     else if(~SW && m_tic)
     next_state = Wait_0_3;
     else if(~SW && ~m_tic)
     next_state = Wait_0_2;
   end
Wait_0_3:
   begin
    db=1'b1;
     if(SW)
     next_state = One;
     if(~SW && m_tic)
     next_state = Zero;
     else if(~SW && ~m_tic)
     next_state = Wait_0_3;
   end

default:begin
       next_state = Zero;
        end
 endcase   
end

endmodule