-- Marc NGUYEN
-- 11 dec 2019
-- bit128_to_state Test Bench

library ieee;
use ieee.std_logic_1164.std_logic;

library lib_aes;
use lib_aes.crypt_pack.type_state;
use lib_aes.crypt_pack.bit128;

library lib_rtl;

entity bit128_to_state_tb is
end entity bit128_to_state_tb;

architecture bit128_to_state_tb_arch of bit128_to_state_tb is

  -- Composant à tester
  component bit128_to_state
    port(
      data_i: in bit128;
      data_o: out type_state
    );
  end component;

  signal data_i_s: bit128;
  signal data_o_s: type_state;

  -- Arrange
  constant state_c: type_state := ((x"af", x"16", x"ce", x"bc"),
                                   (x"44", x"e6", x"91", x"62"),
                                   (x"d3", x"20", x"01", x"06"),
                                   (x"ab", x"b1", x"ae", x"d5"));

begin

  DUT: bit128_to_state port map(
    data_i => data_i_s,
    data_o => data_o_s
  );

  -- Act
  data_i_s <= x"af44d3ab16e620b1ce9101aebc6206d5";

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

end architecture bit128_to_state_tb_arch;

