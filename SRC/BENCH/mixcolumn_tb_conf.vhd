-- Marc NGUYEN
-- 27 oct 2019
-- Configuration du testbench de MixColumn

library lib_rtl;

configuration mixcolumn_tb_conf of mixcolumn_tb is
  for mixcolumn_tb_arch
    for DUT: mixcolumn
      use entity lib_rtl.mixcolumn(mixcolumn_arch);
    end for;
  end for;
end configuration mixcolumn_tb_conf;
