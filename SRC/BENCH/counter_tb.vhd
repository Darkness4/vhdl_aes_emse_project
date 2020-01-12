-- Marc NGUYEN
-- 18 dec 2019
-- Counter Test Bench

library ieee;
use ieee.std_logic_1164.std_logic;
use ieee.std_logic_1164.std_logic_vector;
use ieee.numeric_std.all;

library lib_aes;
use lib_aes.crypt_pack.bit4;

library lib_rtl;

entity counter_tb is
end entity counter_tb;

architecture counter_tb_arch of counter_tb is

  -- Composant à tester
  component counter
    port (
      clock_i: in std_logic;
      resetb_i: in std_logic;
      init_counter_i: in std_logic;
      start_counter_i: in std_logic;
      round_o: out bit4
    );
  end component;

  -- Signaux pour la simulation
  signal clock_i_s: std_logic;
  signal resetb_i_s: std_logic;
  signal init_counter_i_s: std_logic;
  signal start_counter_i_s: std_logic;
  signal round_o_s: bit4;

begin

  DUT: counter port map(
    clock_i => clock_i_s,
    resetb_i => resetb_i_s,
    init_counter_i => init_counter_i_s,
    start_counter_i => start_counter_i_s,
    round_o => round_o_s
  );

  clock: process
  begin
    clock_i_s <= '0';
    wait for 50 ns;
    clock_i_s <= '1';
    wait for 50 ns;
  end process clock;

  resetb_i_s <= '0', '1' after 140 ns;

  -- Act (expected from FSM behavior)
  init_counter_i_s <= '0', '1' after 150 ns, '0' after 450 ns, '1' after 1550 ns;
  start_counter_i_s <= '0', '1' after 251 ns, '0' after 1450 ns;

  test: process
  begin
    wait for 350 ns; -- t = 350 ns
    for test_round in 0 to 10 loop
      -- Assert
      wait for 10 ns; -- t = 360 + i * 100 ns
      assert unsigned(round_o_s)=test_round
        report "Test has failed : round_o_s/=test_round"
        severity error;
      wait for 90 ns; -- t = 450 + i * 100 ns
    end loop;

    -- t = 1450 ns

    wait for 10 ns; -- t = 1460 ns

    -- Test: Counter shouldn't increase when start = 0
    assert unsigned(round_o_s)=10
      report "Test has failed : round_o_s/=0"
      severity error;

    wait for 100 ns; -- t = 1560 ns

    -- Test : Counter should reset when init = 1
    assert unsigned(round_o_s)=0
      report "Test has failed : round_o_s/=0"
      severity error;

    -- End
    wait for 5 ns;
    assert false report "Simulation Finished" severity failure;
  end process test;

end architecture counter_tb_arch;
