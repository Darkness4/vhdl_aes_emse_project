-- Marc NGUYEN
-- 22 oct 2019
-- Configuration du testbench de SBox

library lib_rtl;

configuration sbox_tb_conf of sbox_tb is
  for sbox_tb_arch
    for DUT: sbox
      use entity lib_rtl.sbox(sbox_arch);
    end for;
  end for;
end configuration sbox_tb_conf;
