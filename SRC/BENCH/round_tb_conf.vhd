-- Marc NGUYEN
-- 27 oct 2019
-- Configuration du testbench de Round

library lib_rtl;

configuration round_tb_conf of round_tb is
  for round_tb_arch
    for DUT: round
      use entity lib_rtl.round(round_arch);
    end for;
  end for;
end configuration round_tb_conf;

