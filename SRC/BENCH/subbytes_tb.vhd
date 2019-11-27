-- Marc NGUYEN
-- 22 oct 2019
-- SubBytes Test Bench

library ieee;
use ieee.std_logic_1164.all;

-- utilisation du type type_state
library lib_aes;
use lib_aes.crypt_pack.all;

library lib_rtl;

entity subbytes_tb is
end entity subbytes_tb;

architecture subbytes_tb_arch of subbytes_tb is

  -- Composant à tester
  component subbytes
    port(
      data_i: in type_state;
      data_o: out type_state
    );
  end component;

  -- Signaux pour la simulation
  signal data_i_s: type_state;
  signal data_o_s: type_state;

begin

  DUT: subbytes port map(
    data_i => data_i_s,
    data_o => data_o_s
  );

  -- Stimuli
  data_i_s <= ((0x00, 0x00, 0x00, 0x00),
               (0x00, 0x00, 0x00, 0x00),
               (0x00, 0x00, 0x00, 0x00),
               (0x00, 0x00, 0x00, 0x00),
               (0x00, 0x00, 0x00, 0x00)),
              ((0x00, 0x01, 0x02, 0x04),
               (0x08, 0x10, 0x20, 0x40),
               (0x80, 0xff, 0x03, 0x05),
               (0x07, 0x09, 0x0b, 0x0d),
               (0x0f, 0xf1, 0xf3, 0xf5)), after 50 ns;

end architecture subbytes_tb_arch;
