module ECC(input[0:31] data_in, output reg[0:31] data_out, output reg err_2_bit);
  
  integer i, error_loc, nr_of_1, k;
  reg[4:0] Xor;
  reg[154:0] poz_one;
  
  always @(data_in) begin
    nr_of_1 = 0; k = 0;
    for(i = 1; i < 32; i = i + 1) begin
      if(data_in[i] == 1) begin
        nr_of_1 = nr_of_1 + 1;
        poz_one[5*k +: 5] = i[4:0];
        k = k + 1;
      end
    end
    
    Xor[4:0] = poz_one[4:0] ^ poz_one[9:5];
    for(i = 2; i < k; i = i + 1) begin
        Xor[4:0] = Xor[4:0] ^ poz_one[5*i +: 5];
    end
    error_loc = 16*Xor[4] + 8*Xor[3] + 4*Xor[2] + 2*Xor[1] + Xor[0];
    
    if((nr_of_1[0] & 1) == data_in[0]) begin
      data_out[0:31] = data_in[0:31];                   // parity == parity_bit (bit 0) => no error or 2 errors
      if(error_loc != 0) err_2_bit = 1;                // if xor between all 1 positions != 0 --> 2 errors
      else err_2_bit = 0;                             // else no error
    end
    else begin                                     // only 1 error
      data_out[0:31] = data_in[0:31];
      err_2_bit = 0;                              // xor between positions with value 1 (except bit nr. 0) => pozition of swithced bit
      data_out[error_loc] = ~data_out[error_loc];
    end
    
  end
endmodule