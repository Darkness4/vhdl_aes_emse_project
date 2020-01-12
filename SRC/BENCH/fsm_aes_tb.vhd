-- Marc NGUYEN
-- 18 dec 2019
-- FSM AES Test Bench

library ieee;
use ieee.std_logic_1164.std_logic;
use ieee.std_logic_1164.std_logic_vector;
use ieee.numeric_std.to_unsigned;

library lib_aes;
use lib_aes.crypt_pack.bit4;

library lib_rtl;

entity fsm_aes_tb is
end entity fsm_aes_tb;

architecture fsm_aes_tb_arch of fsm_aes_tb is

  -- Composant à tester
  component fsm_aes
    port (
      round_i: in bit4;
      clock_i: in std_logic;
      resetb_i: in std_logic;
      start_i: in std_logic;
      init_counter_o: out std_logic;
      start_counter_o: out std_logic;
      enable_output_o: out std_logic;
      aes_on_o: out std_logic;
      enable_round_computing_o: out std_logic;
      enable_mix_columns_o: out std_logic
    );
  end component;

  -- Signaux pour la simulation
  subtype output_t is std_logic_vector(0 to 5);
  signal round_i_s: bit4;
  signal clock_i_s: std_logic;
  signal resetb_i_s: std_logic;
  signal start_i_s: std_logic;
  signal output_s: output_t;

  -- Arrange
  type order_t is array (0 to 5) of output_t;
  constant order_of_output: order_t := (
    -- init, start, enable_output, aes_on, enable_RC, enable_MC
    ('1', '0', '0', '0', '0', '0'), -- idle
    ('1', '1', '0', '0', '0', '0'), -- start
    ('0', '1', '0', '1', '0', '0'), -- R0
    ('0', '1', '0', '1', '1', '1'), -- R1to9
    ('0', '0', '0', '1', '1', '0'), -- R10
    ('0', '0', '1', '0', '0', '0')  -- end
  );

begin

  DUT: fsm_aes port map(
    round_i => round_i_s,
    clock_i => clock_i_s,
    resetb_i => resetb_i_s,
    start_i => start_i_s,
    init_counter_o => output_s(0),
    start_counter_o => output_s(1),
    enable_output_o => output_s(2),
    aes_on_o => output_s(3),
    enable_round_computing_o => output_s(4),
    enable_mix_columns_o => output_s(5)
  );

  clock: process
  begin
    clock_i_s <= '0';
    wait for 50 ns;
    clock_i_s <= '1';
    wait for 50 ns;
  end process clock;

  resetb_i_s <= '0', '1' after 40 ns;

  test: process
  begin
    -- Act
    round_i_s <= "0000";
    start_i_s <= '0';

    -- Assert : Should be initial state
    wait for 10 ns;  -- t = 10 ns
    assert output_s=order_of_output(0)
      report "Test has failed : output_s/=order_of_output(0)"
      severity error;

    -- Act
    wait for 140 ns;  -- t = 150 ns
    start_i_s <= '1';

    -- Assert : Should be initial state, (start is the next state)
    wait for 10 ns;  -- t = 160 ns
    assert output_s=order_of_output(0)
      report "Test has failed : output_s/=order_of_output(0)"
      severity error;

    -- Act
    wait for 90 ns;  -- t = 250 ns
    start_i_s <= '0';

    -- Assert : Should be start state after a start signal
    wait for 10 ns;  -- t = 260 ns
    assert output_s=order_of_output(1)
      report "Test has failed : output_s/=order_of_output(1)"
      severity error;

    wait for 90 ns;  -- t = 350 ns
    for mock_round in 0 to 10 loop
      -- Act
      round_i_s <= std_logic_vector(to_unsigned(mock_round, round_i_s'length));  -- Act
      wait for 10 ns; -- t = 360 + i * 100 ns

      -- Assert : State is R0 after the start State and Counter = 0
      if (mock_round = 0) then
        assert output_s=order_of_output(2)
          report "Test has failed : output_s/=order_of_output(2)"
          severity error;

      -- Assert : State is R1to9 and Counter between 1 and 9
      elsif (mock_round <= 9) then
        assert output_s=order_of_output(3)
          report "Test has failed : output_s/=order_of_output(3)"
          severity error;

      -- Assert : State is R10 after the State R1to9 and Counter == 10
      elsif (mock_round = 10) then
        assert output_s=order_of_output(4)
          report "Test has failed : output_s/=order_of_output(4)"
          severity error;
      end if;

      -- Align with time
      wait for 90 ns; -- t = 450 + i * 100 ns

    end loop;

    -- Counter = 10

    -- t = 1450 ns

    wait for 10 ns; -- t = 1460 ns

    -- Assert : State is End
    assert output_s=order_of_output(5)
      report "Test has failed : output_s/=order_of_output(5)"
      severity error;

    wait for 90 ns;  -- t = 1550 ns

    round_i_s <= "0000";  -- Counter should reset if state is idle.

    wait for 10 ns; -- t = 1460 ns

    -- Assert : FSM is reinitialized
    assert output_s=order_of_output(0)
      report "Test has failed : output_s/=order_of_output(0)"
      severity error;

    -- End
    wait for 5 ns;
    assert false report "Simulation Finished" severity failure;
  end process test;

end architecture fsm_aes_tb_arch;
