-- Marc NGUYEN
-- 27 nov 2019
-- MixColumns selon AES

library lib_aes;
use lib_aes.crypt_pack.type_state;

entity mixcolumns is

  port (
    data_i: in type_state;
    data_o: out type_state
  );

end entity mixcolumns;

architecture mixcolumns_arch of mixcolumns is
begin

  --todo
end architecture mixcolumns_arch;
