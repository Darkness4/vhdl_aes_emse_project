-- Marc NGUYEN
-- 11/12/2019
-- Round selon AES

-- Type used : bit128, type_state
library lib_aes;
use lib_aes.crypt_pack.all;

library ieee;
use ieee.std_logic_1164.all;

entity round is

  port (
    text_i: in bit128;
    current_key_i: in bit128;
    clock_i: in std_logic;
    resetb_i: in std_logic;
    enable_round_computing_i: in std_logic;
    enable_mix_columns_i: in std_logic;
    cipher_o: out bit128
  );

end entity round;

architecture round_arch of round is

  component addroundkey is
    port (
      data_i: in type_state;
      key_i: in type_state;
      data_o: out type_state
    );
  end component addroundkey;

  component mixcolumns is
    port (
      data_i: in type_state;
      enable_i: in std_logic;
      data_o: out type_state
    );
  end component mixcolumns;

  component shiftrows is
    port (
      data_i: in type_state;
      data_o: out type_state
    );
  end component shiftrows;

  component subbytes is
    port (
      data_i: in type_state;
      data_o: out type_state
    );
  end component subbytes;

  component register_d is
    port (
      resetb_i : in std_logic;
      clock_i : in std_logic;
      state_i : in type_state;
      state_o : out type_state
    );
  end component register_d;

  component state_to_bit128 is
    port (
      data_i: in type_state;
      data_o: out bit128
    );
  end component state_to_bit128;

  component bit128_to_state is
    port (
      data_i: in bit128;
      data_o: out type_state
    );
  end component bit128_to_state;

  signal text_state_s : type_state;
  signal cipher_state_s : type_state;

  signal output_MC_s : type_state;
  signal input_ARK_s : type_state;
  signal output_ARK_s : type_state;
  signal output_SB_s : type_state;
  signal output_SR_s : type_state;

  signal current_key_s : type_state;

begin

  text_bit128_to_state: bit128_to_state
    port map(
      data_i => text_i,
      data_o => text_state_s
    );


  -- demux
  input_ARK_s <= output_MC_s when enable_round_computing_i = '1' else text_state_s;

  current_key_bit128_to_state: bit128_to_state
    port map(
      data_i => current_key_i,
      data_o => current_key_s
    );

  addroundkey_instance: addroundkey
    port map(
      data_i => input_ARK_s,
      key_i => current_key_s,
      data_o => output_ARK_s
    );

  register_d_instance: register_d
    port map(
      resetb_i => resetb_i,
      clock_i => clock_i,
      state_i => output_ARK_s,
      state_o => cipher_state_s
    );

  cipher_to_bit128: state_to_bit128
    port map(
      data_i => cipher_state_s,
      data_o => cipher_o
    );

  subbytes_instance: subbytes
    port map(
      data_i => cipher_state_s,
      data_o => output_SB_s
    );

  shiftrows_instance: shiftrows
    port map(
      data_i => output_SB_s,
      data_o => output_SR_s
    );

  mixcolumns_instance: mixcolumns
    port map(
      data_i => output_SR_s,
      data_o => output_MC_s,
      enable_i => enable_mix_columns_i
    );

end architecture round_arch;
