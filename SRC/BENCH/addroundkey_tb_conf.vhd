-- Marc NGUYEN
-- 27 oct 2019
-- Configuration du testbench de AddRoundKey

library lib_rtl;

configuration addroundkey_tb_conf of addroundkey_tb is
  for addroundkey_tb_arch
    for DUT: addroundkey
      use entity lib_rtl.addroundkey(addroundkey_arch);
    end for;
  end for;
end configuration addroundkey_tb_conf;

