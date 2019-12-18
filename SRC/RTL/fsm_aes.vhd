-- Marc NGUYEN
-- 18 dec 2019
-- FSM pour gérer les états de l'AES

library lib_aes;
use lib_aes.crypt_pack.bit4;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm_aes is

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

end entity fsm_aes;

architecture fsm_aes_arch of fsm_aes is

  -- TODO: implements

begin

  -- TODO: implements

end architecture fsm_aes_arch;