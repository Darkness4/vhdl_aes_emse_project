-- Marc NGUYEN
-- 18 dec 2019
-- Counter Test Bench

library ieee;
use ieee.std_logic_1164.std_logic;

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
  signal round_o_s: bit4

begin

  DUT: counter port map(
    clock_i => clock_i_s,
    resetb_i => resetb_i_s,
    init_counter_i => init_counter_i_s,
    start_counter_i => start_counter_i_s,
    round_o => round_o_s
  );

  -- Stimuli
  clock_i_s <= '0', '1' after 50 ns,
               '0' after 100 ns, '1' after 150 ns,
               '0' after 200 ns, '1' after 250 ns,
               '0' after 300 ns, '1' after 350 ns,
               '0' after 400 ns, '1' after 450 ns,
               '0' after 500 ns, '1' after 550 ns,
               '0' after 600 ns, '1' after 650 ns,
               '0' after 700 ns, '1' after 750 ns,
               '0' after 800 ns, '1' after 850 ns,
               '0' after 900 ns, '1' after 950 ns,
               '0' after 1000 ns, '1' after 1050 ns,
               '0' after 1100 ns, '1' after 1150 ns,
               '0' after 1200 ns, '1' after 1250 ns,
               '0' after 1300 ns, '1' after 1350 ns,
               '0' after 1400 ns, '1' after 1450 ns,
               '0' after 1500 ns, '1' after 1550 ns,
               '0' after 1600 ns, '1' after 1650 ns,
               '0' after 1700 ns, '1' after 1750 ns,
               '0' after 1800 ns, '1' after 1850 ns;

  resetb_i_s <= '0', '1' after 140 ns;
  init_counter_i_s <= '0', '1' after 140 ns, '0' after 340 ns;
  start_counter_i_s <= '0', '1' after 140 ns;

end architecture counter_tb_arch;
