-- Marc NGUYEN
-- 11 dec 2019
-- Converter type_state to bit128

library lib_aes;
use lib_aes.crypt_pack.type_state;
use lib_aes.crypt_pack.bit128;

entity state_to_bit128 is

  port (
    data_i: in type_state;
    data_o: out bit128
  );

end entity state_to_bit128;

architecture state_to_bit128_arch of state_to_bit128 is
begin

  rows: for i in 0 to 3 generate
    cases: for j in 0 to 3 generate
      data_o((8 * (i+1) - 1) + (32 * j) downto (i * 8 + j * 32)) <= data_i(3 - i)(3 - j);
    end generate cases;
  end generate rows;

end architecture state_to_bit128_arch;

