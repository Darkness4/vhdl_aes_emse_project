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

  type state_fsm is (idle, start_counter, round_0, round_1to9, round10, end_fsm);
  signal etat_present, etat_futur: state_fsm;

begin

  event_dispatcher: process (clock_i, resetb_i)
  begin
    if resetb_i = '0' then
      etat_present <= idle;
    elsif clock_i'event and clock_i = '1' then
      etat_present <= etat_futur;
    end if;
  end process event_dispatcher;

  event_map_to_state: process (etat_present, start_i, round_i)
  begin
    case etat_present is
      when idle =>
        if start_i = '0' then
          etat_futur <= idle;
        else
          etat_futur <= start_counter;
        end if;
      when start_counter =>
        etat_futur <= round_0;
      when round_0 =>
        etat_futur <= round_1to9;
      when round_1to9 =>
        if to_integer(unsigned(round_i)) < 9 then
          etat_futur <= round_1to9;
        else
          etat_futur <= round10;
        end if;
      when round10 =>
        etat_futur <= end_fsm;
      when end_fsm =>
        etat_futur <= idle;
    end case;
  end process event_map_to_state;

  state_model: process (etat_present)
  begin
    case etat_present is
      when idle =>
        init_counter_o <= '1';
        start_counter_o <= '0';
        enable_output_o <= '0';
        aes_on_o <= '0';
        enable_round_computing_o <= '0';
        enable_mix_columns_o <= '0';
      when start_counter =>
        init_counter_o <= '1';
        start_counter_o <= '1';
        enable_output_o <= '0';
        aes_on_o <= '0';
        enable_round_computing_o <= '0';
        enable_mix_columns_o <= '0';
      when round_0 =>
        init_counter_o <= '0';
        start_counter_o <= '1';
        enable_output_o <= '0';
        aes_on_o <= '1';
        enable_round_computing_o <= '0';
        enable_mix_columns_o <= '0';
      when round_1to9 =>
        init_counter_o <= '0';
        start_counter_o <= '1';
        enable_output_o <= '0';
        aes_on_o <= '1';
        enable_round_computing_o <= '1';
        enable_mix_columns_o <= '1';
      when round10 =>
        init_counter_o <= '0';
        start_counter_o <= '0';
        enable_output_o <= '0';
        aes_on_o <= '1';
        enable_round_computing_o <= '1';
        enable_mix_columns_o <= '0';
      when end_fsm =>
        init_counter_o <= '0';
        start_counter_o <= '0';
        enable_output_o <= '1';
        aes_on_o <= '0';
        enable_round_computing_o <= '0';
        enable_mix_columns_o <= '0';
    end case;
  end process state_model;

end architecture fsm_aes_arch;