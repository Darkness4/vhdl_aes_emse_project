-- Marc NGUYEN
-- 11 dec 2019
-- Converter type_state to bit128

library lib_aes;
use lib_aes.crypt_pack.type_state;
use lib_aes.crypt_pack.bit128;

entity bit128_to_state is

  port (
    data_i: in bit128;
    data_o: out type_state
  );

end entity bit128_to_state;

architecture bit128_to_state_arch of bit128_to_state is
begin

  rows: for i in 0 to 3 generate
    cases: for j in 0 to 3 generate
      data_o(3 - i)(3 - j) <= data_i((8 * (i+1) - 1) + (32 * j) downto (i * 8 + j * 32));
    end generate cases;
  end generate rows;

end architecture bit128_to_state_arch;

