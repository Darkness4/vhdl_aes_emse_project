-- Marc NGUYEN
-- 27 nov 2019
-- AddRoundKey selon AES

library lib_aes;
use lib_aes.crypt_pack.type_state;

library ieee;
use ieee.std_logic_1164.all;

entity addroundkey is

  port (
    data_i: in type_state;
    key_i: in type_state;
    data_o: out type_state
  );

end entity addroundkey;

architecture addroundkey_arch of addroundkey is
begin

  rows: for i in 0 to 3 generate
    cases: for j in 0 to 3 generate
      data_o(i)(j) <= data_i(i)(j) xor key_i(i)(j);
    end generate cases;
  end generate rows;

end architecture;
