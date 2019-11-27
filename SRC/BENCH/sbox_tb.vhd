-- Marc NGUYEN
-- 22 oct 2019
-- SBox Test Bench

library ieee;
use ieee.std_logic_1164.all;

-- Utilisation du type bit8
library lib_aes;
use lib_aes.crypt_pack.all;

library lib_rtl;

entity sbox_tb is
end entity sbox_tb;

architecture sbox_tb_arch of sbox_tb is

  -- Composant à tester
  component sbox
    port(
      data_i: in bit8;
      data_o: out bit8
    );
  end component;

  -- Signaux pour la simulation
  signal data_i_s: bit8;
  signal data_o_s: bit8;

begin

  DUT: sbox port map(
    data_i => data_i_s,
    data_o => data_o_s
  );

  -- Stimuli
  data_i_s <= x"00", x"1F" after 50 ns;

end architecture sbox_tb_arch;

