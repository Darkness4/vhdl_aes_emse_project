-- Marc NGUYEN
-- 27 oct 2019
-- Configuration du testbench de SubBytes

library lib_rtl;

configuration subbytes_tb_conf of subbytes_tb is
  for subbytes_tb_arch
    for DUT: subbytes
      use configuration lib_rtl.subbytes_conf;
    end for;
  end for;
end configuration subbytes_tb_conf;
