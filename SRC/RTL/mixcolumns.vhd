-- Marc NGUYEN
-- 27 nov 2019
-- MixColumns selon AES

library lib_aes;
use lib_aes.crypt_pack.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mixcolumns is

  port (
    data_i: in type_state;
    enable_i: in std_logic;
    data_o: out type_state
  );

end entity mixcolumns;

architecture mixcolumns_arch of mixcolumns is

  component mixcolumn
    port (
      data_i: in column_state;
      data_o: out column_state
    );
  end component;

  type state_col_major is array(0 to 3) of column_state;
  signal columns_i_s: state_col_major;
  signal columns_o_s: state_col_major;

begin

  rows_order_i: for i in 0 to 3 generate
    columns_order_i: for j in 0 to 3 generate
      columns_i_s(j)(i) <= data_i(i)(j);
    end generate columns_order_i;
  end generate rows_order_i;

  columns_order: for j in 0 to 3 generate
    MC: mixcolumn port map(
      data_i => columns_i_s(j),
      data_o => columns_o_s(j)
    );
  end generate columns_order;

  rows_order_o: for i in 0 to 3 generate
    columns_order_o: for j in 0 to 3 generate
      data_o(i)(j) <= columns_o_s(j)(i) when enable_i = '1' else data_i(i)(j);
    end generate columns_order_o;
  end generate rows_order_o;

end architecture mixcolumns_arch;
