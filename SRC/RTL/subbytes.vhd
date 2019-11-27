-- Marc NGUYEN
-- 22 oct 2019
-- SubBytes selon Rijndael, en implémentation VHDL. Execution de 16 sbox en 
-- concurrence.

library lib_aes;
use lib_aes.crypt_pack.all;

library ieee;
use ieee.std_logic_1164.all;

library lib_rtl;

entity subbytes is

  port (
    data_i: in type_state;
    data_o: out type_state
  );

end entity subbytes;

architecture subbytes_arch of subbytes is

  component sbox
    port (
      data_i: in bit8;
      data_o: out bit8
    );
  end component;

begin

  S_row: for i in 0 to 3 generate
    S_case: for j in 0 to 3 generate
      sbox: sbox port map(
        data_i => data_i(i)(j),
        data_o => data_o(i)(j)
      );
    end generate S_case;
  end generate S_row;

end architecture subbytes_arch;
