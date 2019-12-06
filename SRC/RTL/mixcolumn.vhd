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

  data_o(0) <= std_logic_vector(
    ((unsigned(data_i(0)) sll 1) xor ("000" & data_i(0)(7) & data_i(0)(7) & "0" & data_i(0)(7) & data_i(0)(7))) xor
    (((unsigned(data_i(1)) sll 1) + unsigned(data_i(1))) xor ("000" & data_i(1)(7) & data_i(1)(7) & "0" & data_i(1)(7) & data_i(1)(7))) xor
    (unsigned(data_i(2)) xor ("000" & data_i(2)(7) & data_i(2)(7) & "0" & data_i(2)(7) & data_i(2)(7))) xor
    (unsigned(data_i(3)) xor ("000" & data_i(3)(7) & data_i(3)(7) & "0" & data_i(3)(7) & data_i(3)(7)))
  );
  data_o(1) <= std_logic_vector(
    (unsigned(data_i(0)) xor ("000" & data_i(0)(7) & data_i(0)(7) & "0" & data_i(0)(7) & data_i(0)(7))) xor
    ((unsigned(data_i(1)) sll 1) xor ("000" & data_i(1)(7) & data_i(1)(7) & "0" & data_i(1)(7) & data_i(1)(7))) xor
    (((unsigned(data_i(2)) sll 1) + unsigned(data_i(2))) xor ("000" & data_i(2)(7) & data_i(2)(7) & "0" & data_i(2)(7) & data_i(2)(7))) xor
    (unsigned(data_i(3)) xor ("000" & data_i(3)(7) & data_i(3)(7) & "0" & data_i(3)(7) & data_i(3)(7)))
  );
  data_o(2) <= std_logic_vector(
    (unsigned(data_i(0)) xor ("000" & data_i(0)(7) & data_i(0)(7) & "0" & data_i(0)(7) & data_i(0)(7))) xor
    (unsigned(data_i(1)) xor ("000" & data_i(1)(7) & data_i(1)(7) & "0" & data_i(1)(7) & data_i(1)(7))) xor
    ((unsigned(data_i(2)) sll 1) xor ("000" & data_i(2)(7) & data_i(2)(7) & "0" & data_i(2)(7) & data_i(2)(7))) xor
    (((unsigned(data_i(3)) sll 1)  + unsigned(data_i(2))) xor ("000" & data_i(3)(7) & data_i(3)(7) & "0" & data_i(3)(7) & data_i(3)(7)))
  );
  data_o(3) <= std_logic_vector(
    (((unsigned(data_i(0)) sll 1) + unsigned(data_i(0))) xor ("000" & data_i(0)(7) & data_i(0)(7) & "0" & data_i(0)(7) & data_i(0)(7))) xor
    (unsigned(data_i(1)) xor ("000" & data_i(1)(7) & data_i(1)(7) & "0" & data_i(1)(7) & data_i(1)(7))) xor
    (unsigned(data_i(2)) xor ("000" & data_i(2)(7) & data_i(2)(7) & "0" & data_i(2)(7) & data_i(2)(7))) xor
    ((unsigned(data_i(3)) sll 1) xor ("000" & data_i(3)(7) & data_i(3)(7) & "0" & data_i(3)(7) & data_i(3)(7)))
  );

end architecture mixcolumn_arch;