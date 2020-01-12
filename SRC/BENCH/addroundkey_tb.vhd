-- Marc NGUYEN
-- 22 oct 2019
-- addroundkey Test Bench

library ieee;
use ieee.std_logic_1164.std_logic;

library lib_aes;
use lib_aes.crypt_pack.type_state;

library lib_rtl;

entity addroundkey_tb is
end entity addroundkey_tb;

architecture addroundkey_tb_arch of addroundkey_tb is

  -- Composant à tester
  component addroundkey
    port(
      data_i: in type_state;
      key_i: in type_state;
      data_o: out type_state
    );
  end component;

  -- Signaux pour la simulation
  signal data_i_s: type_state;
  signal key_i_s: type_state;
  signal data_o_s: type_state;

  -- Arrange
  constant state_c: type_state := ((x"79", x"47", x"8b", x"65"),
                                   (x"1b", x"8e", x"81", x"aa"),
                                   (x"66", x"b7", x"7c", x"6f"),
                                   (x"62", x"c8", x"e4", x"03"));

begin

  DUT: addroundkey port map(
    data_i => data_i_s,
    key_i => key_i_s,
    data_o => data_o_s
  );

  -- Act
  data_i_s <= ((x"52", x"6f", x"20", x"6c"),
               (x"65", x"20", x"76", x"65"),
               (x"73", x"65", x"69", x"20"),
               (x"74", x"6e", x"6c", x"3f"));

  key_i_s <= ((x"2b", x"28", x"ab", x"09"),
              (x"7e", x"ae", x"f7", x"cf"),
              (x"15", x"d2", x"15", x"4f"),
              (x"16", x"a6", x"88", x"3c"));

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

end architecture addroundkey_tb_arch;
