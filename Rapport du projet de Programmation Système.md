# Rapport du projet de Programmation Système

[TOC]

## Plan

[Mettre Graphe]

## SubBytes

TODO: Decrire principe

### Component SBox

#### Entity

[TODO Image SBox]

La SBox possède comme **entrée** :

- un bus 8 bits que l'on nomme `data_i`, de type `bit8` [TODO: Lien vers Annexe].

La SBox possède comme **sortie** :

- un bus 8 bits que l'on nomme `data_o` de type `bit8` [TODO: Lien vers Annexe]

VHDL :

```vhdl
entity sbox is

  port (
    data_i: in bit8;
    data_o: out bit8
  );

end entity adder;
```

#### Architecture

**Dans la partie déclarative de l'architecture SBox**, on déclare un `array` de taille 256, constante, qui doit représenter la SBox suivante :

[TODO Image Sbox]

```vhdl
architecture sbox_arch of sbox is
  -- Déclaration d'un type "sbox"
  type sbox_t is array (0 to 255) of bit8;
  -- Déclaration des données de la sbox
  constant sbox_c: sbox_t := (X"52", X"09", X"6a", [...], X"7d");

begin
```

**Dans la partie descriptive de l'architecture de SBox**, on envoie l'image de `sbox_c` en fonction `data_i` à `data_o`. 

Cependant, il faut noter que `data_i` est en `bit128`, c'est-à-dire, `std_logic_vector(127 downto 0)`. Comme l'opérateur `()` n'accepte que des `integer`, on utilise la librarie `ieee.numeric_stc.all` afin de convertir des `std_logic_vector` en `integer`.

[TODO: Image de conversion]

VHDL :

```vhdl
-- Pour utiliser le type bit8
library lib_aes;
use lib_aes.crypt_pack.bit8;

-- Pour utiliser les types de std_logic_1164
library ieee;
use ieee.std_logic_1164.std_logic;

-- Pour convertir des std_logic_vector en integer
use ieee.numeric_std.unsigned;
use ieee.numeric_std.to_integer;

[...]

architecture sbox_arch of sbox is
    
    [...]

begin

  data_o <= sbox_c(to_integer(unsigned(data_i)));

end architecture sbox_arch;
```

#### Testbench

```vhdl
entity sbox_tb is
end entity sbox_tb;

architecture sbox_tb_arch of sbox_tb is

  -- Composant à tester
  component sbox
    port(
      data_i: in bit8;
      data_o: out bit8
    );
  end component;

  -- Signaux pour la simulation
  signal data_i_s: bit8;
  signal data_o_s: bit8;

begin

  DUT: sbox port map(
    data_i => data_i_s,
    data_o => data_o_s
  );

  -- Stimuli
  data_i_s <= x"00", x"1F" after 50 ns;

end architecture sbox_tb_arch;
```

TODO: Validation. 

### SubBytes Entity

[TODO Image SubBytes]

La SubBytes possède comme **entrée** :

- la matrice d'état en entrée que l'on nomme `data_i`, de type `type_state` [TODO: Lien vers Annexe].

La SubBytes possède comme **sortie** :

- la matrice d'état future que l'on nomme `data_o` de type `type_state` [TODO: Lien vers Annexe]

VHDL :

```vhdl
entity subbytes is

  port (
    data_i: in type_state;
    data_o: out type_state
  );

end entity subbytes;
```

### SubBytes Architecture

Ici, on va chercher à appliquer la SBox sur chaque octet de la état (16 octects) **de manière concurrente**. Par conséquent, on utilise 16 SBox par octet.

[Schéma 16 octets aligné vertical, flèche vers Sbox, sortie]

**Dans la partie déclarative de l'architecture de SubBytes**, on déclare un `component sbox`. 

```vhdl
architecture subbytes_arch of subbytes is

  component sbox
    port (
      data_i: in bit8;
      data_o: out bit8
    );
  end component;

begin
```

**Dans la partie descriptive de l'architecture  de SubBytes**, on génère 1 `sbox` par case, et on fait entrer la `data_i` et sortir la `data_o` correspondant.

VHDL :

```vhdl
begin

  S_row: for i in 0 to 3 generate
    S_case: for j in 0 to 3 generate
      sbox: sbox port map(
        data_i => data_i(i)(j),
        data_o => data_o(i)(j)
      );
    end generate S_case;
  end generate S_row;

end architecture subbytes_arch;
```

### SubBytes TestBench

```vhdl
architecture subbytes_tb_arch of subbytes_tb is

  -- Composant à tester
  component subbytes
    port(
      data_i: in type_state;
      data_o: out type_state
    );
  end component;

  -- Signaux pour la simulation
  signal data_i_s: type_state;
  signal data_o_s: type_state;

begin

  DUT: subbytes port map(
    data_i => data_i_s,
    data_o => data_o_s
  );

  -- Stimuli
  data_i_s <= ((x"00", x"00", x"00", x"00"),
               (x"00", x"00", x"00", x"00"),
               (x"00", x"00", x"00", x"00"),
               (x"00", x"00", x"00", x"00")),
              ((x"79", x"47", x"8b", x"65"),
               (x"1b", x"8e", x"81", x"aa"),
               (x"66", x"b7", x"7c", x"6f"),
               (x"62", x"c8", x"e4", x"03")) after 50 ns;

end architecture subbytes_tb_arch;
```

TODO: Validation

## ShiftRows

ShiftRows doit permter les octets de chaque ligne de l'état.

Le décalagé dépend de l'incide (0...3) de la ligne.

[TODO Image]

### ShiftRows Entity

[TODO Image ShiftRows]

La ShiftRows possède comme **entrée** :

- la matrice d'état en entrée que l'on nomme `data_i`, de type `type_state` [TODO: Lien vers Annexe].

La ShiftRows possède comme **sortie** :

- la matrice d'état future que l'on nomme `data_o` de type `type_state` [TODO: Lien vers Annexe]

VHDL :

```vhdl
entity subbytes is

  port (
    data_i: in type_state;
    data_o: out type_state
  );

end entity subbytes;
```

### ShiftRows Architecture

**Dans la partie descriptive de l'architecture  de ShiftRows,** on utilisera des boucles `generate` afin d'appliquer la permutation.

[Image bloc vers bloc byte shift]

VHDL :

```vhdl
architecture shiftrows_arch of shiftrows is
begin

  rows: for i in 0 to 3 generate
    cases: for j in 0 to 3 generate
      data_o(i)(j) <= data_i(i)((i + j) mod 4);
    end generate cases;
  end generate rows;

end architecture shiftrows_arch;
```

### ShiftRows TestBench

```vhdl
architecture shiftrows_tb_arch of shiftrows_tb is

  -- Composant à tester
  component shiftrows
    port(
      data_i: in type_state;
      data_o: out type_state
    );
  end component;

  signal data_i_s: type_state;
  signal data_o_s: type_state;

begin

  DUT: shiftrows port map(
    data_i => data_i_s,
    data_o => data_o_s
  );

  -- Stimuli
  data_i_s <= ((x"00", x"00", x"00", x"00"),
               (x"00", x"00", x"00", x"00"),
               (x"00", x"00", x"00", x"00"),
               (x"00", x"00", x"00", x"00")),
              ((x"af", x"16", x"ce", x"bc"),
               (x"44", x"e6", x"91", x"62"),
               (x"d3", x"20", x"01", x"06"),
               (x"ab", x"b1", x"ae", x"d5")) after 50 ns;

end architecture shiftrows_tb_arch;
```

TODO: Validation

## MixColumns

### Component MixColumn

#### Entity

[TODO Image MixColumns]

La MixColumns possède comme **entrée** :

- une colonne de la matrice d'état que l'on nomme `data_i`, de type `column_state` [TODO: Lien vers Annexe].

La MixColumns possède comme **sortie** :

- la matrice d'état future que l'on nomme `data_o` de type `column_state` [TODO: Lien vers Annexe]

VHDL :

```vhdl
entity mixcolumn is

  port (
    data_i: in column_state;
    data_o: out column_state
  );

end entity mixcolumn;
```

#### Architecture

```vhdl
architecture mixcolumn_arch of mixcolumn is
  
begin

  data_o(0) <= std_logic_vector(
    (unsigned(data_i(0))*2) xor 
    (unsigned(data_i(1))*3) xor
    (unsigned(data_i(2))*1) xor
    (unsigned(data_i(3))*1) xor
    unsigned(("000" & data_i(7) & 
     data_i(7) & "0" & data_i(7) & data_i(7)))
  );
  data_o(1) <= std_logic_vector(
    (unsigned(data_i(0))*1) xor 
    (unsigned(data_i(1))*2) xor
    (unsigned(data_i(2))*3) xor
    (unsigned(data_i(3))*1) xor
    unsigned(("000" & data_i(7) & 
     data_i(7) & "0" & data_i(7) & data_i(7)))
  );
  data_o(2) <= std_logic_vector(
    (unsigned(data_i(0))*1) xor 
    (unsigned(data_i(1))*1) xor
    (unsigned(data_i(2))*2) xor
    (unsigned(data_i(3))*3) xor
    unsigned(("000" & data_i(7) & 
     data_i(7) & "0" & data_i(7) & data_i(7)))
  );
  data_o(3) <= std_logic_vector(
    (unsigned(data_i(0))*3) xor 
    (unsigned(data_i(1))*1) xor
    (unsigned(data_i(2))*1) xor
    (unsigned(data_i(3))*2) xor
    unsigned(("000" & data_i(7) & 
     data_i(7) & "0" & data_i(7) & data_i(7))) 
  );

end architecture mixcolumn_arch;
```

#### Testbench

### MixColumns Entity

[TODO Image MixColumns]

La MixColumns possède comme **entrée** :

- la matrice d'état en entrée que l'on nomme `data_i`, de type `type_state` [TODO: Lien vers Annexe].

La MixColumns possède comme **sortie** :

- la matrice d'état future que l'on nomme `data_o` de type `type_state` [TODO: Lien vers Annexe]

VHDL :

```vhdl
entity mixcolumns is

  port (
    data_i: in type_state;
    data_o: out type_state
  );

end entity mixcolumns;
```

### MixColumns Architecture

TODO: Meilleure rédaction

**Cas 1 : Bit de poids fort = 0**

0x02 dot 0b0111 1111 = 0b1111 1110

**Cas 2 : Bit de poids fort = 1**

0x2 dot 0b1111 0000 = (0b1 1110 0000 mod  0b1 0001 1011)	(1 0001 10101 ~ x⁸+x⁴+x³+x+1)

= 0b1 1110 0000 + 0b1 0001 1011

= 0b1111 1011

En gros : 

```vhdl
data_i << 2
XOR
"000" & data_i(7) & data_i(7) & "0" & data_i(7) & data_i(7)
```

Multiplier par 3

```vhdl
data_i << 2
XOR
data_i
XOR
"000" & data_i(7) & data_i(7) & "0" & data_i(7) & data_i(7)
```

data_i (column_state)=>[MixColumn]=>data_o(column_state)

### MixColumns TestBench

```vhdl
architecture mixcolumns_tb_arch of mixcolumns_tb is

  -- Composant à tester
  component mixcolumns
    port(
      data_i: in type_state;
      data_o: out type_state
    );
  end component;

  -- Signaux pour la simulation
  signal data_i_s: type_state;
  signal data_o_s: type_state;

begin

  DUT: mixcolumns port map(
    data_i => data_i_s,
    data_o => data_o_s
  );

  -- Stimuli
  data_i_s <= ((x"00", x"00", x"00", x"00"),
               (x"00", x"00", x"00", x"00"),
               (x"00", x"00", x"00", x"00"),
               (x"00", x"00", x"00", x"00")),
              ((x"af", x"16", x"ce", x"bc"),
               (x"e6", x"91", x"62", x"44"),
               (x"01", x"06", x"d3", x"20"),
               (x"d5", x"ab", x"b1", x"ae")) after 50 ns;

end architecture mixcolumns_tb_arch;
```

TODO: Validation. 

## AddRoundKey

### AddRoundKey Entity

[TODO Image AddRoundKey]

La AddRoundKey possède comme **entrée** :

- la matrice d'état en entrée que l'on nomme `data_i`, de type `type_state` [TODO: Lien vers Annexe].
- la sous-clé en entrée que l'on nomme `key_i`, de type `type_state` [TODO: Lien vers Annexe].

La AddRoundKey possède comme **sortie** :

- la matrice d'état future que l'on nomme `data_o` de type `type_state` [TODO: Lien vers Annexe]

VHDL :

```vhdl
entity addroundkey is

  port (
    data_i: in type_state;
    key_i: in type_state;
    data_o: out type_state
  );

end entity addroundkey;
```

### AddRoundKey Architecture

**Dans la partie descriptive de l'architecture  de ShiftRows,** on applique `xor` entre la `key_i(i)(j)` et le `data_i(i)(j)`. On sort le résultat du `xor` sur `data_o(i)(j)`

```vhdl
architecture addroundkey_arch of addroundkey is
begin

  rows: for i in 0 to 3 generate
    cases: for j in 0 to 3 generate
      data_o(i)(j) <= data_i(i)(j) xor key_i(i)(j);
    end generate rows;
  end generate cases;

end architecture;
```

### AddRoundKey TestBench

```vhdl
architecture addroundkey_tb_arch of addroundkey_tb is

  -- Composant à tester
  component addroundkey
    port(
      data_i: in type_state;
      key_i: in type_state;
      data_o: out type_state
    );
  end component;

  -- Signaux pour la simulation
  signal data_i_s: type_state;
  signal key_i_s: type_state;
  signal data_o_s: type_state;

begin

  DUT: addroundkey port map(
    data_i => data_i_s,
    key_i => key_i_s,
    data_o => data_o_s
  );

  -- Stimuli
  data_i_s <= ((x"52", x"6f", x"20", x"6c"),
               (x"65", x"20", x"76", x"65"),
               (x"73", x"65", x"69", x"20"),
               (x"74", x"6e", x"6c", x"3f"));

  key_i_s <= ((x"2b", x"28", x"ab", x"09"),
              (x"7e", x"ae", x"f7", x"cf"),
              (x"15", x"d2", x"15", x"4f"),
              (x"16", x"a6", x"88", x"3c"));

end architecture addroundkey_tb_arch;
```

TODO: Validation. 

# Bibliographie

