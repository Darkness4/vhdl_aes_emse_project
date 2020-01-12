-- Marc NGUYEN
-- 18 dec 2019
-- AES Main

library lib_aes;
use lib_aes.crypt_pack.all;

library ieee;
use ieee.std_logic_1164.all;

entity aes is

  port (
    clock_i: in std_logic;
    resetb_i: in std_logic;
    start_i: in std_logic;
    text_i: in bit128;
    aes_on_o: out std_logic;
    cipher_o: out bit128
  );

end entity aes;

architecture aes_arch of aes is

  component KeyExpansion_I_O_table is
    port (
      round_i : in bit4;
      expansion_key_o : out bit128
    );
  end component KeyExpansion_I_O_table;

  component counter is
    port (
      clock_i: in std_logic;
      resetb_i: in std_logic;
      init_counter_i: in std_logic;
      start_counter_i: in std_logic;
      round_o: out bit4
    );
  end component counter;

  component fsm_aes is
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
  end component fsm_aes;

  component round is
    port (
      text_i: in bit128;
      current_key_i: in bit128;
      clock_i: in std_logic;
      resetb_i: in std_logic;
      enable_round_computing_i: in std_logic;
      enable_mix_columns_i: in std_logic;
      cipher_o: out bit128
    );
  end component round;

  signal round_s: bit4;
  signal init_counter_s: std_logic;
  signal start_counter_s: std_logic;
  signal enable_round_computing_s: std_logic;
  signal enable_mix_columns_s: std_logic;
  signal enable_output_s: std_logic;
  signal current_key_s: bit128;
  signal cipher_s: bit128;

begin

  KeyExpansion_I_O_instance: KeyExpansion_I_O_table
    port map(
      round_i => round_s,
      expansion_key_o => current_key_s
    );

  counter_instance: counter
    port map(
      clock_i => clock_i,
      resetb_i => resetb_i,
      init_counter_i => init_counter_s,
      start_counter_i => start_counter_s,
      round_o => round_s
    );

  fsm_aes_instance: fsm_aes
    port map(
      round_i => round_s,
      clock_i => clock_i,
      resetb_i => resetb_i,
      start_i => start_i,
      init_counter_o => init_counter_s,
      start_counter_o => start_counter_s,
      enable_output_o => enable_output_s,
      aes_on_o => aes_on_o,
      enable_round_computing_o => enable_round_computing_s,
      enable_mix_columns_o => enable_mix_columns_s
    );

  round_instance: round
    port map(
      text_i => text_i,
      current_key_i => current_key_s,
      clock_i => clock_i,
      resetb_i => resetb_i,
      enable_round_computing_i => enable_round_computing_s,
      enable_mix_columns_i => enable_mix_columns_s,
      cipher_o => cipher_s
    );

  -- Mux
  cipher_o <= cipher_s when enable_output_s='1' else X"00000000000000000000000000000000";

end architecture aes_arch;

