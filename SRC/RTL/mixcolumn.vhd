-- Marc NGUYEN
-- 27 nov 2019
-- MixColumns selon AES

library lib_aes;
use lib_aes.crypt_pack.column_state;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mixcolumn is

  port (
    data_i: in column_state;
    data_o: out column_state
  );

end entity mixcolumn;

architecture mixcolumn_arch of mixcolumn is
  
begin

  -- data_o(0) <= std_logic_vector(
    -- (unsigned(data_i(0))*2) xor 
    -- (unsigned(data_i(1))*3) xor
    -- (unsigned(data_i(2))*1) xor
    -- (unsigned(data_i(3))*1) xor
    -- unsigned(("000" & data_i(7) & 
     -- data_i(7) & "0" & data_i(7) & data_i(7)))
  -- );
  -- data_o(1) <= std_logic_vector(
    -- (unsigned(data_i(0))*1) xor 
    -- (unsigned(data_i(1))*2) xor
    -- (unsigned(data_i(2))*3) xor
    -- (unsigned(data_i(3))*1) xor
    -- unsigned(("000" & data_i(7) & 
     -- data_i(7) & "0" & data_i(7) & data_i(7)))
  -- );
  -- data_o(2) <= std_logic_vector(
    -- (unsigned(data_i(0))*1) xor 
    -- (unsigned(data_i(1))*1) xor
    -- (unsigned(data_i(2))*2) xor
    -- (unsigned(data_i(3))*3) xor
    -- unsigned(("000" & data_i(7) & 
     -- data_i(7) & "0" & data_i(7) & data_i(7)))
  -- );
  -- data_o(3) <= std_logic_vector(
    -- (unsigned(data_i(0))*3) xor 
    -- (unsigned(data_i(1))*1) xor
    -- (unsigned(data_i(2))*1) xor
    -- (unsigned(data_i(3))*2) xor
    -- unsigned(("000" & data_i(7) & 
     -- data_i(7) & "0" & data_i(7) & data_i(7))) 
  -- );

end architecture mixcolumn_arch;