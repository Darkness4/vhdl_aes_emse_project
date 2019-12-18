-- Marc NGUYEN
-- 11 dec 2019
-- Configuration de round

library lib_rtl;

configuration round_conf of round is
  for round_arch
    for all: addroundkey
      use entity lib_rtl.addroundkey(addroundkey_arch);
    end for;
    for all: mixcolumns
      use configuration lib_rtl.mixcolumns_conf;
    end for;
    for all: shiftrows
      use entity lib_rtl.shiftrows(shiftrows_arch);
    end for;
    for all: subbytes
      use configuration lib_rtl.subbytes_conf;
    end for;
    for all: state_to_bit128
      use entity lib_rtl.state_to_bit128(state_to_bit128_arch);
    end for;
    for all: bit128_to_state
      use entity lib_rtl.bit128_to_state(bit128_to_state_arch);
    end for;
  end for;
end configuration round_conf;