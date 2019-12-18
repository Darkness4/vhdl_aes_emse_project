-- Marc NGUYEN
-- 11 dec 2019
-- Configuration du testbench de bit128 to state

library lib_rtl;

configuration bit128_to_state_tb_conf of bit128_to_state_tb is
  for bit128_to_state_tb_arch
    for DUT: bit128_to_state
      use entity lib_rtl.bit128_to_state(bit128_to_state_arch);
    end for;
  end for;
end configuration bit128_to_state_tb_conf;
