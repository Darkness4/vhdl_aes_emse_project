-- Marc NGUYEN
-- 27 nov 2019
-- MixColumns Test Bench

library ieee;
use ieee.std_logic_1164.std_logic;

library lib_aes;
use lib_aes.crypt_pack.type_state;

library lib_rtl;

entity mixcolumns_tb is
end entity mixcolumns_tb;

architecture mixcolumns_tb_arch of mixcolumns_tb is

  -- Composant à tester
  component mixcolumns
    port(
      data_i: in type_state;
      data_o: out type_state
    );
  end component;

  -- Signaux pour la simulation
  signal data_i_s: type_state;
  signal data_o_s: type_state;

begin

  DUT: mixcolumns port map(
    data_i => data_i_s,
    data_o => data_o_s
  );

  -- Stimuli
  data_i_s <= ((x"af", x"16", x"ce", x"bc"),
               (x"e6", x"91", x"62", x"44"),
               (x"01", x"06", x"d3", x"20"),
               (x"d5", x"ab", x"b1", x"ae")) after 50 ns;

end architecture mixcolumns_tb_arch;
