-- Marc NGUYEN
-- 18 dec 2019
-- Configuration du testbench de FSM AES

library lib_rtl;

configuration fsm_aes_tb_conf of fsm_aes_tb is
  for fsm_aes_tb_arch
    for DUT: fsm_aes
      use entity lib_rtl.fsm_aes(fsm_aes_arch);
    end for;
  end for;
end configuration fsm_aes_tb_conf;
