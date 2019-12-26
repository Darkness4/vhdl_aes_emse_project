-- Marc NGUYEN
-- 18 dec 2019
-- FSM AES Test Bench

library ieee;
use ieee.std_logic_1164.std_logic;

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
  signal round_i_s: bit4;
  signal clock_i_s: std_logic;
  signal resetb_i_s: std_logic;
  signal start_i_s: std_logic;
  signal init_counter_o_s: std_logic;
  signal start_counter_o_s: std_logic;
  signal enable_output_o_s: std_logic;
  signal aes_on_o_s: std_logic;
  signal enable_round_computing_o_s: std_logic;
  signal enable_mix_columns_o_s: std_logic;

begin

  DUT: fsm_aes port map(
    round_i => round_i_s,
    clock_i => clock_i_s,
    resetb_i => resetb_i_s,
    start_i => start_i_s,
    init_counter_o => init_counter_o_s,
    start_counter_o => start_counter_o_s,
    enable_output_o => enable_output_o_s,
    aes_on_o => aes_on_o_s,
    enable_round_computing_o => enable_round_computing_o_s,
    enable_mix_columns_o => enable_mix_columns_o_s
  );

  -- Stimuli
  clock_i_s <= '0', '1' after 50 ns,  -- idle
               '0' after 100 ns, '1' after 150 ns,  -- Dispatch start 
               '0' after 200 ns, '1' after 250 ns,  -- R0
               '0' after 300 ns, '1' after 350 ns,  -- R1
               '0' after 400 ns, '1' after 450 ns,  -- R2
               '0' after 500 ns, '1' after 550 ns,  -- R3
               '0' after 600 ns, '1' after 650 ns,  -- R4
               '0' after 700 ns, '1' after 750 ns,  -- R5
               '0' after 800 ns, '1' after 850 ns,  -- R6
               '0' after 900 ns, '1' after 950 ns,  -- R7
               '0' after 1000 ns, '1' after 1050 ns,  -- R8
               '0' after 1100 ns, '1' after 1150 ns,  -- R9
               '0' after 1200 ns, '1' after 1250 ns,  -- R10
               '0' after 1300 ns, '1' after 1350 ns,
               '0' after 1400 ns, '1' after 1450 ns,
               '0' after 1500 ns, '1' after 1550 ns,
               '0' after 1600 ns, '1' after 1650 ns,
               '0' after 1700 ns, '1' after 1750 ns,
               '0' after 1800 ns, '1' after 1850 ns;

  resetb_i_s <= '0', '1' after 40 ns;
  start_i_s <= '0', '1' after 150 ns, '0' after 350 ns;
  round_i_s <= "0000",
             "0001" after 250 ns,  -- R0
             "0010" after 350 ns,  -- R1
             "0011" after 450 ns,  -- R2
             "0100" after 550 ns,  -- R3
             "0101" after 650 ns,  -- R4
             "0110" after 750 ns,  -- R5
             "0111" after 850 ns,  -- R6
             "1000" after 950 ns,  -- R7
             "1001" after 1050 ns,  -- R8
             "1010" after 1150 ns,  -- R9
             "1011" after 1250 ns,  -- R10
             "1100" after 1350 ns;  -- R10

end architecture fsm_aes_tb_arch;
