-- Marc NGUYEN
-- 11/12/2019
-- Register D with AES-State as input and output

library IEEE;
use IEEE.std_logic_1164.all;

library lib_aes;
use lib_aes.crypt_pack.type_state;

entity register_d is

  port (
    resetb_i : in std_logic;
    clock_i : in std_logic;
    state_i : in type_state;
    state_o : out type_state
  );

end entity register_d;

architecture register_d_arch of register_d is

  signal state_s : type_state;

begin

  seq_0 : process (clock_i, resetb_i) is

  begin

    -- Reset clears state
    if resetb_i = '0' then
      for i in 0 to 3 loop
        for j in 0 to 3 loop
          state_s(i)(j) <= (others => '0');
        end loop;
      end loop;

    -- New data at RISING
    elsif clock_i'event and clock_i='1' then
      state_s <= state_i;
    end if;

  end process seq_0;

  -- Output
  state_o <= state_s;

end architecture register_d_arch;

