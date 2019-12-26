-- Marc NGUYEN
-- 27 nov 2019
-- MixColumn (pour 1 colonne) selon AES

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

  signal data2_s: column_state;
  signal data3_s: column_state;

begin

  data2_s <= (
    std_logic_vector((unsigned(data_i(0)(6 downto 0)) & "0") xor
      ("000" & data_i(0)(7) & data_i(0)(7) & "0" & data_i(0)(7) & data_i(0)(7))),
    std_logic_vector((unsigned(data_i(1)(6 downto 0)) & "0") xor
      ("000" & data_i(1)(7) & data_i(1)(7) & "0" & data_i(1)(7) & data_i(1)(7))),
    std_logic_vector((unsigned(data_i(2)(6 downto 0)) & "0") xor
      ("000" & data_i(2)(7) & data_i(2)(7) & "0" & data_i(2)(7) & data_i(2)(7))),
    std_logic_vector((unsigned(data_i(3)(6 downto 0)) & "0") xor
      ("000" & data_i(3)(7) & data_i(3)(7) & "0" & data_i(3)(7) & data_i(3)(7)))
  );
  data3_s <= (
    data2_s(0) xor data_i(0),
    data2_s(1) xor data_i(1),
    data2_s(2) xor data_i(2),
    data2_s(3) xor data_i(3)
  );

  data_o(0) <= data2_s(0) xor data3_s(1) xor data_i(2) xor data_i(3);
  data_o(1) <= data_i(0) xor data2_s(1) xor data3_s(2) xor data_i(3);
  data_o(2) <= data_i(0) xor data_i(1) xor data2_s(2) xor data3_s(3);
  data_o(3) <= data3_s(0) xor data_i(1) xor data_i(2) xor data2_s(3);

end architecture mixcolumn_arch;