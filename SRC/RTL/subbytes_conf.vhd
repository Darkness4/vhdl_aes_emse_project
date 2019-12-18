-- Marc NGUYEN
-- 11 dec 2019
-- Configuration de subbytes

library lib_rtl;

configuration subbytes_conf of subbytes is
  for subbytes_arch
    for S_row
      for S_case
        for all: sbox
          use entity lib_rtl.sbox(sbox_arch);
        end for;
      end for;
    end for;
  end for;
end configuration subbytes_conf;