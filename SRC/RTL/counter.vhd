-- Marc NGUYEN
-- 18 dec 2019
-- Compteur

library lib_aes;
use lib_aes.crypt_pack.bit4;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is

  port (
    clock_i: in std_logic;
    resetb_i: in std_logic;
    init_counter_i: in std_logic;
    start_counter_i: in std_logic;
    round_o: out bit4
  );

end entity counter;

architecture counter_arch of counter is

  signal round_s : bit4;

begin

  seq_0 : process (clock_i, resetb_i) is
  begin
    -- Reset clears state
    if resetb_i = '0' then
      round_s <= "0000";
    
    -- New data at RISING
    elsif clock_i'event and clock_i = '1' then
      -- Arm
      if init_counter_i = '1' then
        round_s <= "0000";
        
      -- Start counting
      elsif start_counter_i = '1' then
        round_s <= std_logic_vector(unsigned(round_s) + 1);
        if round_s = "1011" then  -- if round > 10
          round_s <= "0000";
        end if;
      end if;
    end if;
  end process seq_0;

  round_o <= round_s;

end architecture counter_arch;