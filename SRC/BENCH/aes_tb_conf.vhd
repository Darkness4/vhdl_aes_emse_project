-- Marc NGUYEN
-- 18 dec 2019
-- Configuration du testbench de AES Main

library lib_rtl;

configuration aes_tb_conf of aes_tb is
  for aes_tb_arch
    for DUT: aes
      use configuration lib_rtl.aes_conf;
    end for;
  end for;
end configuration aes_tb_conf;
