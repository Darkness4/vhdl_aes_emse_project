-- Marc NGUYEN
-- 11/12/2019
-- Register D Test Bench

library ieee;
use ieee.std_logic_1164.all;

library lib_aes;
use lib_aes.crypt_pack.type_state;

entity register_d_tb is
end register_d_tb;

architecture register_d_tb_arch of register_d_tb is

  component register_d
    port (
      resetb_i : in std_logic;
      clock_i : in std_logic;
      state_i : in type_state;
      state_o : out type_state
    );
  end component register_d;

  signal resetb_i_s : std_logic;
  signal clock_i_s : std_logic;
  signal state_i_s : type_state;
  signal state_o_s : type_state;

  -- Arrange
  constant unintialized_state: type_state := ((x"00", x"00", x"00", x"00"),
                                              (x"00", x"00", x"00", x"00"),
                                              (x"00", x"00", x"00", x"00"),
                                              (x"00", x"00", x"00", x"00"));
  constant first_state: type_state := ((x"00", x"04", x"08", x"0C"),
                                       (x"01", x"05", x"09", x"0D"),
                                       (x"02", x"06", x"0A", x"0E"),
                                       (x"03", x"07", x"0B", x"0F"));
  constant second_state: type_state := ((x"DE", x"AD", x"BE", x"EF"),
                                        (x"BA", x"DD", x"CA", x"FE"),
                                        (x"DE", x"AD", x"C0", x"DE"),
                                        (x"CA", x"DE", x"D0", x"0D"));

begin

  DUT: register_d 
    port map(
      resetb_i => resetb_i_s,
      clock_i => clock_i_s,
      state_i => state_i_s,
      state_o => state_o_s
    );

  -- CLK T = 100 ns
  clock_i_s <= '0', '1' after 50 ns,
               '0' after 100 ns, '1' after 150 ns,
               '0' after 200 ns, '1' after 250 ns,
               '0' after 300 ns, '1' after 350 ns,
               '0' after 400 ns, '1' after 450 ns,
               '0' after 500 ns, '1' after 550 ns;

  -- Act
  resetb_i_s <= '0', '1' after 5 ns, '0' after 290 ns;
  state_i_s <= ((x"00", x"04", x"08", x"0C"),
                (x"01", x"05", x"09", x"0D"),
                (x"02", x"06", x"0A", x"0E"),
                (x"03", x"07", x"0B", x"0F")),
               ((x"DE", x"AD", x"BE", x"EF"),
                (x"BA", x"DD", x"CA", x"FE"),
                (x"DE", x"AD", x"C0", x"DE"),
                (x"CA", x"DE", x"D0", x"0D")) after 100 ns;

  test: process
  begin
    -- Assert : 
    -- Test : Register D is not initialized before RISING
    wait for 5 ns;  -- t = 5 ns
    assert state_o_s = unintialized_state
      report "state_o_s /= unintialized_state"
      severity error;

    -- Test : Register D is now initialized  after RISING
    wait for 50 ns;  -- t = 55 ns
    assert state_o_s = first_state
      report "state_o_s /= first_state"
      severity error;

    -- Test : Register D change state after RISING
    wait for 100 ns;  -- t = 155 ns
    assert state_o_s = second_state
      report "state_o_s /= second_state"
      severity error;
    
    -- Test : Register D reset suddenly without caring about clock_i
    wait for 140 ns;  -- t = 295 ns
    assert state_o_s = unintialized_state
      report "state_o_s /= unintialized_state"
      severity error;

    -- End
    wait for 5 ns;
    assert false report "Simulation Finished" severity failure;
  end process test;
end architecture register_d_tb_arch;
