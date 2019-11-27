-- Marc NGUYEN
-- 27 oct 2019
-- Condiguration du testbench de ShiftRows

library lib_rtl;

configuration shiftrows_tb_conf of shiftrows_tb is
  for shiftrows_tb_arch
    for DUT: shiftrows
      use entity lib_rtl.shiftrows(shiftrows_arch);
    end for;
  end for;
end configuration shiftrows_tb_conf;

