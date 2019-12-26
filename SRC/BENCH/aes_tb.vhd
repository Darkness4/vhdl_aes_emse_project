-- Marc NGUYEN
-- 18 dec 2019
-- AES Main Test Bench

library ieee;
use ieee.std_logic_1164.std_logic;

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

begin

  DUT: aes port map(
    clock_i => clock_i_s,
    resetb_i => resetb_i_s,
    start_i => start_i_s,
    text_i => text_i_s,
    aes_on_o => aes_on_o_s,
    cipher_o => cipher_o_s
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
  text_i_s <= x"526573746f20656e2076696c6c65203f";

end architecture aes_tb_arch;

