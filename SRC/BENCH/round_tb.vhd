-- Marc NGUYEN
-- 22 oct 2019
-- round Test Bench

library ieee;
use ieee.std_logic_1164.std_logic;

-- Type used: bit128, type_state
library lib_aes;
use lib_aes.crypt_pack.all;

library lib_rtl;

entity round_tb is
end entity round_tb;

architecture round_tb_arch of round_tb is

  -- Composant à tester
  component round
    port(
      text_i: in bit128;
      current_key_i: in bit128;
      clock_i: in std_logic;
      resetb_i: in std_logic;
      enable_round_computing_i: in std_logic;
      enable_mix_columns_i: in std_logic;
      cipher_o: out bit128
    );
  end component;

  -- Signaux pour la simulation
  signal text_i_s: bit128;
  signal current_key_i_s: bit128;
  signal cipher_o_s: bit128;
  signal clock_i_s: std_logic;
  signal resetb_i_s: std_logic;
  signal enable_round_computing_s: std_logic;
  signal enable_mix_columns_s: std_logic;

begin

  DUT: round port map(
    text_i => text_i_s,
    current_key_i => current_key_i_s,
    clock_i => clock_i_s,
    resetb_i => resetb_i_s,
    enable_round_computing_i => enable_round_computing_s,
    enable_mix_columns_i => enable_mix_columns_s,
    cipher_o =>  cipher_o_s
  );

  -- Stimuli
  -- Test 2 use case
  -- Usecase : Round 0 between 0 and 150 ns.
  -- Expect : output_ARK = 791b6662478eb7c88b817ce465aa6f03
  -- Usecase : Round 1 between 150 and 250 ns.
  -- Expect : cipher_state_s = 791b6662478eb7c88b817ce465aa6f03
  -- Expect : output_SB = af44d3ab16e620b1ce9101aebc6206d5
  -- Expect : output_SR = afe601d5169106abce62d3b1bc4420ae
  -- Expect : output_MC = a0ae2fbc298e6de043d5d98121fa51fc
  -- Expect : output_ARK = d54257ea74ccc710b56066f9de80a1b8
  resetb_i_s <= '0', '1' after 50 ns;

  clock_i_s <= '0', '1' after 50 ns,
               '0' after 100 ns, '1' after 150 ns,
               '0' after 200 ns, '1' after 250 ns,
               '0' after 300 ns, '1' after 350 ns,
               '0' after 400 ns, '1' after 450 ns,
               '0' after 500 ns, '1' after 550 ns;

  enable_round_computing_s <= '0', '1' after 150 ns;
  enable_mix_columns_s <= '0', '1' after 150 ns;

  text_i_s <= x"526573746f20656e2076696c6c65203f";

  current_key_i_s <= x"2b7e151628aed2a6abf7158809cf4f3c", 
                     x"75ec78565d42aaf0f6b5bf78ff7af044" after 150 ns;

  end architecture round_tb_arch;
