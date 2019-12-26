# Rapport du projet de Programmation Système

TODO: Not all test

TODO: Legend graph

TODO: Graph renvoi dans le texte

[TOC]

## Plan

[Mettre Graphe]

## SubBytes

TODO: Decrire principe

### Component SBox

#### Entity

[TODO Image SBox]

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

### Component MixColumn



#### Entity

[TODO Image MixColumns]

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

  signal data2_s: column_state;
  signal data3_s: column_state;

begin

  data2_s <= (
    std_logic_vector((unsigned(data_i(0)(6 downto 0)) & "0") xor
      ("000" & data_i(0)(7) & data_i(0)(7) & "0" & data_i(0)(7) & data_i(0)(7))),
    std_logic_vector((unsigned(data_i(1)(6 downto 0)) & "0") xor
      ("000" & data_i(1)(7) & data_i(1)(7) & "0" & data_i(1)(7) & data_i(1)(7))),
    std_logic_vector((unsigned(data_i(2)(6 downto 0)) & "0") xor
      ("000" & data_i(2)(7) & data_i(2)(7) & "0" & data_i(2)(7) & data_i(2)(7))),
    std_logic_vector((unsigned(data_i(3)(6 downto 0)) & "0") xor
      ("000" & data_i(3)(7) & data_i(3)(7) & "0" & data_i(3)(7) & data_i(3)(7)))
  );
  data3_s <= (
    data2_s(0) xor data_i(0),
    data2_s(1) xor data_i(1),
    data2_s(2) xor data_i(2),
    data2_s(3) xor data_i(3)
  );

  data_o(0) <= data2_s(0) xor data3_s(1) xor data_i(2) xor data_i(3);
  data_o(1) <= data_i(0) xor data2_s(1) xor data3_s(2) xor data_i(3);
  data_o(2) <= data_i(0) xor data_i(1) xor data2_s(2) xor data3_s(3);
  data_o(3) <= data3_s(0) xor data_i(1) xor data_i(2) xor data2_s(3);

end architecture mixcolumn_arch;
```

#### Testbench

### MixColumns Entity

[TODO Image MixColumns]

La MixColumns possède comme **entrée** :

- la matrice d'état en entrée que l'on nomme `data_i`, de type `type_state` [TODO: Lien vers Annexe].
- `enable_i`, de type `std_logic`, qui permet :
  - Si `enable = 1`, `data_out <= mixcolumns(data_i)`
  - Sinon, `data_out <= data_i`, afin que l'on désactive lors du round final.

La MixColumns possède comme **sortie** :

- la matrice d'état future que l'on nomme `data_o` de type `type_state` [TODO: Lien vers Annexe]

VHDL :

```vhdl
entity mixcolumns is

  port (
    data_i: in type_state;
    enable_i: in std_logic;
    data_o: out type_state
  );

end entity mixcolumns;
```

### MixColumns Architecture



TODO: VHDL

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

## Round

[TODO: Add Image 11 rounds]

TODO: Rerédiger

Il faudra mémoriser après un AddRoundKey.

Il faut entrer la subkey, text clair.

### Component Registre D

Le registre D permettra de cadencer notre round et de synchroniser avec un compteur de round et une machine d'état.

#### Entity

```vhdl
entity register_d is

  port (
    resetb_i : in std_logic;
    clock_i : in std_logic;
    state_i : in type_state;
    state_o : out type_state
  );

end entity register_d;
```

#### Architecture

On adapte notre registre D au type `state`.

```vhdl
architecture register_d_arch of register_d is

  signal state_s : type_state;

begin

  seq_0 : process (clock_i, resetb_i) is

  begin

    -- Reset clears state
    if resetb_i = '0' then
      for i in 0 to 3 loop
        for j in 0 to 3 loop
          state_s(i)(j) <= (others => '0');
        end loop;
      end loop;

    -- New data at RISING
    elsif clock_i'event and clock_i='1' then
      state_s <= state_i;
    end if;

  end process seq_0;

  -- Output
  state_o <= state_s;

end architecture register_d_arch;
```

#### TestBench



### Round Entity

[TODO Image Entity]

Le Round possède comme **entrée** :

- Le texte clair que l'on nomme `text_i`, de type `bit128` [TODO: Lien vers Annexe].
- La sous-clé en entrée que l'on nomme `current_key_i`, de type `bit128` [TODO: Lien vers Annexe].
- L'horloge `clock_i` en `std_logic` et le reset `resetb_i` (reset si le niveau est bas)
- `enable_round_computing_i` en `std_logic` qui servira de choisir l'entrée entre le texte clair pour le round 0, ou les résultats des précédant round.
- `enable_mix_columns_i` qui servira de d'activer/désactiver MixColumns pour le Round 0 et Round 10

Le round possède comme **sortie** :

- Le texte chiffré du round que l'on nomme `cipher_o` de type `bit128` [TODO: Lien vers Annexe]

```vhdl
entity round is

  port (
    text_i: in bit128;
    current_key_i: in bit128;
    clock_i: in std_logic;
    resetb_i: in std_logic;
    enable_round_computing_i: in std_logic;
    enable_mix_columns_i: in std_logic;
    cipher_o: out bit128
  );

end entity round;
```

### Round Architecture

D'après la documentation de l'AES, un round est composé de :

[TODO IMAGE]

On utilisera un registre D pour synchroniser notre composant `round ` avec le compteur de round et une machine d'état.

Egalement, comme nos entrées sont des `bit128` et que notre architecture se base sur des `state`, on convertira les `bits128` en entrée en `state`, et les `state` en sortie en `bit128`

On prévoit donc notre architecture VHDL :

![image-20191226150734997](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20191226150734997.png)

On connecte donc nos différents composants en VHDL :

```vhdl
architecture round_arch of round is

  ...  -- Composants et signals affichés dans le schéma

begin

  text_bit128_to_state: bit128_to_state
    port map(
      data_i => text_i,
      data_o => text_state_s
    );


  -- demux
  input_ARK_s <= output_MC_s when enable_round_computing_i = '1' else text_state_s;

  current_key_bit128_to_state: bit128_to_state
    port map(
      data_i => current_key_i,
      data_o => current_key_s
    );

  addroundkey_instance: addroundkey
    port map(
      data_i => input_ARK_s,
      key_i => current_key_s,
      data_o => output_ARK_s
    );

  register_d_instance: register_d
    port map(
      resetb_i => resetb_i,
      clock_i => clock_i,
      state_i => output_ARK_s,
      state_o => cipher_state_s
    );

  cipher_to_bit128: state_to_bit128
    port map(
      data_i => cipher_state_s,
      data_o => cipher_o
    );

  subbytes_instance: subbytes
    port map(
      data_i => cipher_state_s,
      data_o => output_SB_s
    );

  shiftrows_instance: shiftrows
    port map(
      data_i => output_SB_s,
      data_o => output_SR_s
    );

  mixcolumns_instance: mixcolumns
    port map(
      data_i => output_SR_s,
      data_o => output_MC_s,
      enable_i => enable_mix_columns_i
    );

end architecture round_arch;
```

### Round TestBench

## Machine d'Etat

La machine d'état contrôle le comportement du round en fonction du compteur de round.

![image-20191226155750386](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20191226155750386.png)

Voici donc la configuration des données en fonction des états :

|                 | idle  | start_counter | round_0 | round_1to9 | round10 | end_fsm |
| :-------------: | :---: | :-----------: | :-----: | :--------: | :-----: | :-----: |
| init_counter_o  | **1** |     **1**     |    0    |     0      |    0    |    0    |
| start_counter_o |   0   |     **1**     |  **1**  |   **1**    |    0    |    0    |
| enable_output_o |   0   |       0       |    0    |     0      |    0    |  **1**  |
|    aes_on_o     |   0   |       0       |  **1**  |   **1**    |  **1**  |    0    |
|   enable_RC_o   |   0   |       0       |    0    |   **1**    |  **1**  |    0    |
|   enable_MC_o   |   0   |       0       |    0    |   **1**    |    0    |    0    |

### Machine d'Etat Entity

D'après le diagramme d'état, on définit rapidement les entrées et les sorties :

```vhdl
entity fsm_aes is

  port (
    round_i: in bit4;  -- Utilise: 10, Max: 16
    clock_i: in std_logic;
    resetb_i: in std_logic;
    start_i: in std_logic;
    init_counter_o: out std_logic;
    start_counter_o: out std_logic;
    enable_output_o: out std_logic;
    aes_on_o: out std_logic;
    enable_round_computing_o: out std_logic;
    enable_mix_columns_o: out std_logic
  );

end entity fsm_aes;
```

### Machine d'Etat Architecture

Pour changer d'état en fonction de l'horloge et du reset, nous utiliserons un process dédié, sensible à l'horloge et au reset :

```vhdl
  event_dispatcher: process (clock_i, resetb_i)
  begin
    if resetb_i = '0' then
      etat_present <= idle;
    elsif clock_i'event and clock_i = '1' then
      etat_present <= etat_futur;
    end if;
  end process event_dispatcher;
```

Pour changer d'état en fonction des entrées, nous utiliserons un autre process dédié, sensible à l'état présent, le start et le round :

```vhdl
  event_map_to_state: process (etat_present, start_i, round_i)
  begin
    case etat_present is
      when idle =>
        if start_i = '0' then
          etat_futur <= idle;  -- loop until start
        else
          etat_futur <= start_counter;
        end if;
      when start_counter =>
        etat_futur <= round_0;
      when round_0 =>
        etat_futur <= round_1to9;
      when round_1to9 =>
        if to_integer(unsigned(round_i)) < 9 then
          etat_futur <= round_1to9;  -- loop while round_i < 9
        else
          etat_futur <= round10;
        end if;
      when round10 =>
        etat_futur <= end_fsm;
      when end_fsm =>
        etat_futur <= idle;
    end case;
  end process event_map_to_state;
```

Pour changer les données en fonction de l'état :

```vhdl
state_model: process (etat_present)
  begin
    case etat_present is
      when idle =>
        init_counter_o <= '1';
        start_counter_o <= '0';
        enable_output_o <= '0';
        aes_on_o <= '0';
        enable_round_computing_o <= '0';
        enable_mix_columns_o <= '0';
      ... -- Le comportement est défini dans le tableau ci-dessus.
      when end_fsm =>
        init_counter_o <= '0';
        start_counter_o <= '0';
        enable_output_o <= '1';
        aes_on_o <= '0';
        enable_round_computing_o <= '0';
        enable_mix_columns_o <= '0';
    end case;
  end process state_model;
```

### Machine d'Etat TestBench 

## Compteur de Round

## AES



# Bibliographie

# Annexe



