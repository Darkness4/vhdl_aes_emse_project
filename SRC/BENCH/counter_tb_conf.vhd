-- Marc NGUYEN
-- 18 dec 2019
-- Configuration du testbench de counter

library lib_rtl;

configuration counter_tb_conf of counter_tb is
  for counter_tb_arch
    for DUT: counter
      use entity lib_rtl.counter(counter_arch);
    end for;
  end for;
end configuration counter_tb_conf;
