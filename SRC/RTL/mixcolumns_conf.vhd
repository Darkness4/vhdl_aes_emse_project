-- Marc NGUYEN
-- 11 dec 2019
-- Configuration de mixcolumns

library lib_rtl;

configuration mixcolumns_conf of mixcolumns is
  for mixcolumns_arch
    for columns_order
      for all: mixcolumn
        use entity lib_rtl.mixcolumn(mixcolumn_arch);
      end for;
    end for;
  end for;
end configuration mixcolumns_conf;