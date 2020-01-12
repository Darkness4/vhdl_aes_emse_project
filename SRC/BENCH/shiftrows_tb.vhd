-- Marc NGUYEN
-- 27 oct 2019
-- ShiftRows Test Bench

library ieee;
use ieee.std_logic_1164.std_logic;

library lib_aes;
use lib_aes.crypt_pack.type_state;

library lib_rtl;

entity shiftrows_tb is
end entity shiftrows_tb;

architecture shiftrows_tb_arch of shiftrows_tb is

  -- Composant à tester
  component shiftrows
    port(
      data_i: in type_state;
      data_o: out type_state
    );
  end component;

  signal data_i_s: type_state;
  signal data_o_s: type_state;

  -- Arrange
  constant state_c: type_state := ((x"af", x"16", x"ce", x"bc"),
                                   (x"e6", x"91", x"62", x"44"),
                                   (x"01", x"06", x"d3", x"20"),
                                   (x"d5", x"ab", x"b1", x"ae"));

begin

  DUT: shiftrows port map(
    data_i => data_i_s,
    data_o => data_o_s
  );

  -- Act
  data_i_s <= ((x"af", x"16", x"ce", x"bc"),
               (x"44", x"e6", x"91", x"62"),
               (x"d3", x"20", x"01", x"06"),
               (x"ab", x"b1", x"ae", x"d5"));

  test: process
  begin
    -- Assert
    wait for 5 ns;
    assert data_o_s = state_c
      report "data_o_s /= state_c"
      severity error;

    -- End
    wait for 5 ns;
    assert false report "Simulation Finished" severity failure;
  end process test;

end architecture shiftrows_tb_arch;

