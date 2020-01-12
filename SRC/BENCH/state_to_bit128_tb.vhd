-- Marc NGUYEN
-- 11 dec 2019
-- state_to_bit128 Test Bench

library ieee;
use ieee.std_logic_1164.std_logic;
use ieee.numeric_std.all;

library lib_aes;
use lib_aes.crypt_pack.type_state;
use lib_aes.crypt_pack.bit128;

library lib_rtl;

entity state_to_bit128_tb is
end entity state_to_bit128_tb;

architecture state_to_bit128_tb_arch of state_to_bit128_tb is

  -- Composant à tester
  component state_to_bit128
    port(
      data_i: in type_state;
      data_o: out bit128
    );
  end component;

  signal data_i_s: type_state;
  signal data_o_s: bit128;

  -- Arrange
  constant data_c: unsigned(127 downto 0) := x"af44d3ab16e620b1ce9101aebc6206d5";

begin

  DUT: state_to_bit128 port map(
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
    assert unsigned(data_o_s) = data_c
      report "data_o_s /= data_c"
      severity error;

    -- End
    wait for 5 ns;
    assert false report "Simulation Finished" severity failure;
  end process test;

end architecture state_to_bit128_tb_arch;

