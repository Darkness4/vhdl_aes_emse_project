-- Marc NGUYEN
-- 27 oct 2019
-- Configuration du testbench de MixColumns

library lib_rtl;

configuration mixcolumns_tb_conf of mixcolumns_tb is
  for mixcolumns_tb_arch
    for DUT: mixcolumns
      use configuration lib_rtl.mixcolumns_conf;
    end for;
  end for;
end configuration mixcolumns_tb_conf;
