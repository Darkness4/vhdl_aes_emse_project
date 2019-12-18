-- Marc NGUYEN
-- 11 dec 2019
-- Configuration du testbench de state to bit128

library lib_rtl;

configuration state_to_bit128_tb_conf of state_to_bit128_tb is
  for state_to_bit128_tb_arch
    for DUT: state_to_bit128
      use entity lib_rtl.state_to_bit128(state_to_bit128_arch);
    end for;
  end for;
end configuration state_to_bit128_tb_conf;
