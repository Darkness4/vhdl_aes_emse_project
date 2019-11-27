-- Marc NGUYEN
-- 27 nov 2019
-- MixColumn Test Bench

library ieee;
use ieee.std_logic_1164.std_logic;

library lib_aes;
use lib_aes.crypt_pack.column_state;

library lib_rtl;

entity mixcolumn_tb is
end entity mixcolumn_tb;

architecture mixcolumn_tb_arch of mixcolumn_tb is

  -- Composant à tester
  component mixcolumn
    port(
      data_i: in column_state;
      data_o: out column_state
    );
  end component;

  -- Signaux pour la simulation
  signal data_i_s: column_state;
  signal data_o_s: column_state;

begin

  DUT: mixcolumn port map(
    data_i => data_i_s,
    data_o => data_o_s
  );

  -- Stimuli
  -- TODO
  data_i_s <= (x"af", x"16", x"ce", x"bc");

end architecture mixcolumn_tb_arch;
