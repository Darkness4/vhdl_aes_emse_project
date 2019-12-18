-- Marc NGUYEN
-- 11/12/2019
-- Configuration de l'AES Main

library lib_rtl;
library lib_aes;

configuration aes_conf of aes is
  for aes_arch
    for all: KeyExpansion_I_O_table
      use entity lib_aes.KeyExpansion_I_O_table(KeyExpansion_I_O_table_arch);
    end for;
    for all: counter
      use entity lib_rtl.counter(counter_arch);
    end for;
    for all: fsm_aes
      use entity lib_rtl.fsm_aes(fsm_aes_arch);
    end for;
    for all: round
      use configuration lib_rtl.round_conf;
    end for;
  end for;
end configuration aes_conf;