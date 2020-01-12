-- Marc NGUYEN
-- 18 dec 2019
-- AES Main Test Bench

library ieee;
use ieee.std_logic_1164.std_logic;
use ieee.std_logic_1164.std_logic_vector;
use ieee.numeric_std.all;

library lib_aes;
use lib_aes.crypt_pack.bit128;

library lib_rtl;

entity aes_tb is
end entity aes_tb;

architecture aes_tb_arch of aes_tb is

  -- Composant à tester
  component aes
    port (
      clock_i: in std_logic;
      resetb_i: in std_logic;
      start_i: in std_logic;
      text_i: in bit128;
      aes_on_o: out std_logic;
      cipher_o: out bit128
    );
  end component;

  signal clock_i_s: std_logic;
  signal resetb_i_s: std_logic;
  signal start_i_s: std_logic;
  signal aes_on_o_s: std_logic;
  signal text_i_s: bit128;
  signal cipher_o_s: bit128;

  constant cipher_c: unsigned(127 downto 0) := x"d4f125f097f7cee747669b783056caa7";

begin

  DUT: aes port map(
    clock_i => clock_i_s,
    resetb_i => resetb_i_s,
    start_i => start_i_s,
    text_i => text_i_s,
    aes_on_o => aes_on_o_s,
    cipher_o => cipher_o_s
  );

  clock: process
  begin
    clock_i_s <= '0';
    wait for 50 ns;
    clock_i_s <= '1';
    wait for 50 ns;
  end process clock;

  resetb_i_s <= '0', '1' after 40 ns;

  -- Act
  start_i_s <= '0', '1' after 150 ns, '0' after 250 ns, '1' after 1850 ns, '0' after 1950 ns;
  text_i_s <= x"526573746f20656e2076696c6c65203f";

  -- Assert
  test: process
  begin
    -- First shot
    wait for 260 ns;
    assert aes_on_o_s='1'
      report "Test has failed : aes_on_o_s/=1 when state is round0"
      severity error;

    wait for 1100 ns;  -- t = 1360 ns
    assert aes_on_o_s='0'
      report "Test has failed : aes_on_o_s/=0 when state is end"
      severity error;
    assert unsigned(cipher_o_s)=cipher_c
      report "Test has failed : cipher_o_s/=cipher_c"
      severity error;

    assert false report "First Shot Finished" severity failure;

    -- Second shot
    wait for 600 ns;  -- t = 1960 ns
    assert aes_on_o_s='1'
      report "Test has failed : aes_on_o_s/=1 when state is round0"
      severity error;

    wait for 1100 ns;  -- t = 2960 ns
    assert aes_on_o_s='0'
      report "Test has failed : aes_on_o_s/=0 when state is end"
      severity error;
    assert unsigned(cipher_o_s)=cipher_c
      report "Test has failed : cipher_o_s/=cipher_c"
      severity error;

    -- End
    wait for 5 ns;
    assert false report "Second Shot Finished" severity failure;
  end process;

end architecture aes_tb_arch;

