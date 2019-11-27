-- Marc NGUYEN
-- 22 nov 2019
-- SubBytes Test Bench

library ieee;
use ieee.std_logic_1164.std_logic;

library lib_aes;
use lib_aes.crypt_pack.type_state;

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
  data_i_s <= ((x"79", x"47", x"8b", x"65"),
               (x"1b", x"8e", x"81", x"aa"),
               (x"66", x"b7", x"7c", x"6f"),
               (x"62", x"c8", x"e4", x"03")) after 50 ns;

end architecture subbytes_tb_arch;
