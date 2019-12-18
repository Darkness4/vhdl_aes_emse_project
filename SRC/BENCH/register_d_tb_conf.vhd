-- Marc NGUYEN
-- 11/12/2019
-- Configuration of the Register D Test Bench

library lib_rtl;

configuration register_d_tb_conf of register_d_tb is
  for register_d_tb_arch
    for DUT: register_d
      use entity lib_rtl.register_d(register_d_arch);
    end for;
  end for;
end register_d_tb_conf;
