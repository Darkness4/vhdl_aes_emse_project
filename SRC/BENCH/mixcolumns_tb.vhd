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
      enable_i: in std_logic;
      data_o: out type_state
    );
  end component;

  -- Signaux pour la simulation
  signal data_i_s: type_state;
  signal data_o_s: type_state;
  signal enable_i_s: std_logic;

  -- Arrange
  constant state_when_enabled_c: type_state := ((x"a0", x"29", x"43", x"21"),
                                                (x"ae", x"8e", x"d5", x"fa"),
                                                (x"2f", x"6d", x"d9", x"51"),
                                                (x"bc", x"e0", x"81", x"fc"));
  constant state_when_disabled_c: type_state := ((x"af", x"16", x"ce", x"bc"),
                                                 (x"e6", x"91", x"62", x"44"),
                                                 (x"01", x"06", x"d3", x"20"),
                                                 (x"d5", x"ab", x"b1", x"ae"));
begin

  DUT: mixcolumns port map(
    data_i => data_i_s,
    enable_i => enable_i_s,
    data_o => data_o_s
  );

  -- Act
  data_i_s <= ((x"af", x"16", x"ce", x"bc"),
               (x"e6", x"91", x"62", x"44"),
               (x"01", x"06", x"d3", x"20"),
               (x"d5", x"ab", x"b1", x"ae"));
  
  enable_i_s <= '0',
                '1' after 50 ns;

  test: process
  begin
    -- Assert
    wait for 5 ns;
    assert data_o_s = state_when_disabled_c
      report "data_o_s /= state_when_disabled_c"
      severity error;

    wait for 50 ns;
    assert data_o_s = state_when_enabled_c
      report "data_o_s /= state_when_enabled_c"
      severity error;

    -- End
    wait for 5 ns;
    assert false report "Simulation Finished" severity failure;
  end process test;

end architecture mixcolumns_tb_arch;
