-- Marc NGUYEN
-- 27 nov 2019
-- ShiftRows selon AES

library lib_aes;
use lib_aes.crypt_pack.type_state;

entity shiftrows is

  port (
    data_i: in type_state;
    data_o: out type_state
  );

end entity shiftrows;

architecture shiftrows_arch of shiftrows is
begin

  rows: for i in 0 to 3 generate
    cases: for j in 0 to 3 generate
      data_o(i)(j) <= data_i(i)((i + j) mod 4);
    end generate cases;
  end generate rows;

end architecture shiftrows_arch;

