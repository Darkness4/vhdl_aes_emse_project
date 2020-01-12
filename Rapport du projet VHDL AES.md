

Marc NGUYEN - 12 Janvier 2020

# <div style="height: 350px;"><div style="margin: 0; position: absolute; top: 80%;">Rapport du Projet Conception d'un Système Numérique AES VHDL</div></div>



**Modélisation VHDL de l'algorithme de chiffrement AES**

<div style="page-break-after: always; break-after: page;"></div>
**<u>Table des Matières</u>**

[TOC]

<div style="page-break-after: always; break-after: page;"></div>

## SubBytes

SubBytes effetcue une transformation non linéaire appliqué à tous les octets de l'état en utilisant une SBox.

<img src="C:/Users/nguye/AppData/Roaming/Typora/typora-user-images/image-20200112151448082.png" alt="image-20200112151448082" style="zoom: 50%;" />

<div style="text-align: center; font-size: 12px;"><u>Figure 1 : Principe du SubBytes</u></div>
### SubBytes Entity

<img src="C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111145300121.png" alt="image-20200111145300121" style="zoom: 67%;" />

<div style="text-align: center; font-size: 12px;"><u>Figure 2 : SubBytes Entity</u></div>
```vhdl
entity subbytes is

  port (
    data_i: in type_state;
    data_o: out type_state
  );

end entity subbytes;
```

Note : Le type `type_state` est un `array(0 to 3) ` de `row_state`, qui lui-même est un `array(0 to 3)` de `bit8` (`std_logic_vector(7 downto 0)`). Il s'agit donc d'un tableau 4 x 4 avec 1 octet par case.

<img src="C:/Users/nguye/AppData/Roaming/Typora/typora-user-images/image-20200112151555616.png" alt="image-20200112151555616" style="zoom:50%;" />

<div style="text-align: center; font-size: 12px;"><u>Figure 3 : Représentation d'un State array</u></div>
<div style="page-break-after: always; break-after: page;"></div>
### SubBytes Architecture

Ici, on va chercher à appliquer la SBox sur chaque octet de l'état (16 octets) **de manière concurrente**. Par conséquent, on utilise 1 SBox **pour chaque** octet.

**Dans la partie déclarative de l'architecture de SubBytes**, on déclare un `component sbox`, que l'on implémentera plus tard.

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

Il nous reste plus qu'à implémenter la SBox et **tester**.

<div style="page-break-after: always; break-after: page;"></div>
### Component SBox

#### Entity

<img src="C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111143937674.png" alt="image-20200111143937674" style="zoom:67%;" />

<div style="text-align: center; font-size: 12px;"><u>Figure 4 : SBox Entity</u></div>
```vhdl
entity sbox is

  port (
    data_i: in bit8;
    data_o: out bit8
  );

end entity adder;
```

#### Architecture

**Dans la partie déclarative de l'architecture SBox**, on déclare un `array` de taille 256, **constante**, qui doit représenter la SBox suivante :

<img src="C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111144052027.png" alt="image-20200111144052027" style="zoom:67%;" />

<div style="text-align: center; font-size: 12px;"><u>Figure 5 : SBox fournie à implémenter</u></div>
```vhdl
architecture sbox_arch of sbox is
  -- Déclaration d'un type "sbox"
  type sbox_t is array (0 to 255) of bit8;
  -- Déclaration des données de la sbox
  constant sbox_c: sbox_t := (X"52", X"09", X"6a", [...], X"0c", X"7d");

begin
```

**Dans la partie descriptive de l'architecture de SBox**, on envoie l'image de `sbox_c` à `data_o`. 

Cependant, il faut noter que `data_i` est en **`bit128`** (`std_logic_vector(127 downto 0)`). Comme l'opérateur `array()` n'accepte que des `integer` en paramètre, on utilise la librairie `ieee.numeric_stc.all` afin de convertir des `std_logic_vector` en `integer`.

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

-- [...]

architecture sbox_arch of sbox is
    
    -- [...]

begin

  data_o <= sbox_c(to_integer(unsigned(data_i)));

end architecture sbox_arch;
```

<div style="page-break-after: always; break-after: page;"></div>
#### Testbench

Test : "Tout l'ensemble de 0 à 255 doit correspondre à la SBox"

- En entrée :  Un variable allant de 0 à 255.

- On s'attend à obtenir la transformation de la variable à partir de la SBox.

**Résultat :**

![image-20200111153131535](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111153131535.png)

<div style="text-align: center; font-size: 12px;"><u>Figure 6 : Résultat obtenu pour le test SBox</u></div>

En passant par les test par assertions VHDL, on obtient dans la console :

```txt
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ns  Iteration: 0  Instance: /sbox_tb/DUT
# ** Failure: Simulation Finished
#    Time: 2560 ns  Iteration: 0  Process: /sbox_tb/test File: SRC/BENCH/sbox_tb.vhd
# Break in Process test at SRC/BENCH/sbox_tb.vhd line 70
```

Donc, toutes les assertions sont passées, donc **sbox est validé**.

Manuellement : sbox(0x7D) = 0x13. 

### SubBytes TestBench

En entrée : 

```vhdl
((x"79", x"47", x"8b", x"65"),
 (x"1b", x"8e", x"81", x"aa"),
 (x"66", x"b7", x"7c", x"6f"),
 (x"62", x"c8", x"e4", x"03")
```

Ce que l'on attend :

```vhdl
((x"af", x"16", x"ce", x"bc"),
 (x"44", x"e6", x"91", x"62"),
 (x"d3", x"20", x"01", x"06"),
 (x"ab", x"b1", x"ab", x"d5"))
```

**Résultat :**

![image-20200111155500281](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111155500281.png)

<div style="text-align: center; font-size: 12px;"><u>Figure 7 : Résultat obtenu pour le test SubBytes</u></div>

Toutes les assertions sont passés, donc **SubBytes est validé**.

Manuellement : D'après la figure ci-dessus, nous avons exactement ce que l'on attend :

![image-20200111155840432](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111155840432.png)

 <div style="text-align: center; font-size: 12px;"><u>Figure 8 : Extrait de l'énoncé pour la validation SubBytes</u></div>
<div style="page-break-after: always; break-after: page;"></div>

## ShiftRows

ShiftRows doit permuter les octets de chaque ligne de l'état.

Le décalage dépend de indice (0...3) de la ligne.

<img src="C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111160117960.png" alt="image-20200111160117960" style="zoom:67%;" />

 <div style="text-align: center; font-size: 12px;"><u>Figure 9 : Fonctionnement de ShiftRows</u></div>

### ShiftRows Entity

<img src="C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111160208097.png" alt="image-20200111160208097" style="zoom:67%;" />

<div style="text-align: center; font-size: 12px;"><u>Figure 10 : ShiftRows Entity</u></div>

```vhdl
entity subbytes is

  port (
    data_i: in type_state;
    data_o: out type_state
  );

end entity subbytes;
```

<div style="page-break-after: always; break-after: page;"></div>
### ShiftRows Architecture

**Dans la partie descriptive de l'architecture  de ShiftRows,** on utilisera des boucles `generate` afin d'appliquer la permutation de manière concurrente.

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

En entrée :

```vhdl
((x"af", x"16", x"ce", x"bc"),
 (x"44", x"e6", x"91", x"62"),
 (x"d3", x"20", x"01", x"06"),
 (x"ab", x"b1", x"ae", x"d5"))
```

Ce que l'on attend :

```vhdl
((x"a0", x"29", x"43", x"21"),
 (x"ae", x"8e", x"d5", x"fa"),
 (x"2f", x"6d", x"d9", x"21"),
 (x"bc", x"e0", x"81", x"fc"))
```

<div style="page-break-after: always; break-after: page;"></div>

**Résultat :**

![image-20200111162204472](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111162204472.png)

<div style="text-align: center; font-size: 12px;"><u>Figure 11 : Résultat obtenu pour le test ShiftRows</u></div>

Toutes les assertions sont passés, donc **ShiftRows est validé**.

Manuellement : D'après la figure ci-dessus, nous avons exactement ce que l'on attend :

![image-20200111162231815](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111162231815.png)

 <div style="text-align: center; font-size: 12px;"><u>Figure 12 : Extrait de l'énoncé pour la validation ShiftRows</u></div>
<div style="page-break-after: always; break-after: page;"></div>

## MixColumns

MixColumns applique une transformation linaire sur chaque colonne de l'état.

<img src="C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111162430372.png" alt="image-20200111162430372" style="zoom:67%;" />

 <div style="text-align: center; font-size: 12px;"><u>Figure 13 : Fonctionnement de MixColumns</u></div>

### MixColumns Entity

<img src="C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111163104429.png" alt="image-20200111163104429" style="zoom:67%;" />

 <div style="text-align: center; font-size: 12px;"><u>Figure 14 : MixColumns Entity</u></div>

La MixColumns possède comme **entrée** :

- la matrice d'état en entrée que l'on nomme `data_i`, de type `type_state`
- `enable_i`, de type `std_logic`, qui permet :
  - Si `enable = 1`, `data_o <= MixcColumns(data_i)`
  - Sinon, `data_o <= data_i`, ce qui permet le fonctionnement du round final de l'AES

La MixColumns possède comme **sortie** :

- la matrice d'état future que l'on nomme `data_o` de type `type_state`

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

**Dans la partie déclarative de l'architecture  de MixColumns,** on déclare le composant `mixcolumn` qui servira à appliquer la fonction MixColumns. On déclare également des signaux qui permet la conversion entre colonne et état.

```vhdl
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
```

**Dans la partie descriptive de l'architecture  de MixColumns,** on convertit l'état en entrée en colonnes, puis on applique `mixcolumn` et on envoie le résultat.

```vhdl
begin

  -- Slice Data_i in columns
  rows_order_i: for i in 0 to 3 generate
    columns_order_i: for j in 0 to 3 generate
      columns_i_s(j)(i) <= data_i(i)(j);
    end generate columns_order_i;
  end generate rows_order_i;

  -- Apply MixColumn for each column
  columns_order: for j in 0 to 3 generate
    MC: mixcolumn port map(
      data_i => columns_i_s(j),
      data_o => columns_o_s(j)
    );
  end generate columns_order;

  -- Restore state from new columns (or old columns depending enable_i)
  rows_order_o: for i in 0 to 3 generate
    columns_order_o: for j in 0 to 3 generate
      data_o(i)(j) <= columns_o_s(j)(i) when enable_i = '1' else data_i(i)(j);
    end generate columns_order_o;
  end generate rows_order_o;

end architecture mixcolumns_arch;
```

<div style="page-break-after: always; break-after: page;"></div>
### Component MixColumn

Les colonnes doivent être traitées comme des polynômes dans $GF(2^{8})^2$ et multipliées modulo $x^8+x^4+x^3+x+1$.

La multiplication polynômiale par x peut être implémenté à l'aide d'un décalage à gauche suivi d'un ou-exclusif avec la valeur 0b1 0001 1011 conditionné par le bit de poids fort du polynôme.

Exemple avec un octet d'une colonne :

**Cas 1 : Bit de poids fort = 0**
$$
\begin{align}
\{02\} \otimes S_{0,c} &= 0x02 \odot 0b0111\,1111 \\
&= 0b1111\,1110
\end{align}
$$
Donc, le modulo n'est pas nécessaire.

**Cas 2 : Bit de poids fort = 1**
$$
\begin{align}
\{02\} \otimes S_{0,c} &= 0x02 \odot 0b1111\,0000 \oplus 0b1\,0001\,1011 \\
&= 0b1\,1110\,0000 \oplus 0b1\,0001\,1011 \\
&= 0b1111\,1011
\end{align}
$$
Ici, le modulo a été utilisé.

Donc, pour l'implémenter, on le conditionne avec le bit de poids fort du polynôme.

La fonction MixColumn doit être appliqué de cette manière :

<img src="C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111170629737.png" alt="image-20200111170629737" style="zoom:67%;" />

#### Entity

<img src="C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111170820958.png" alt="image-20200111170820958" style="zoom:67%;" />

 <div style="text-align: center; font-size: 12px;"><u>Figure 15 : MixColumn Entity</u></div>

```vhdl
entity mixcolumn is

  port (
    data_i: in column_state;
    data_o: out column_state
  );

end entity mixcolumn;
```

Note : `column_state` est un `array(0 to 3)` de `bit8`.

#### Architecture

Nous partitionnons notre fonction :

- `data2_s` est la colonne en entrée multiplié par 2 dans l'ensemble de Galois

```vhdl
architecture mixcolumn_arch of mixcolumn is
  --[...]
  signal data2_s: column_state;

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
```

- `data3_s` est la colonne en entrée multiplié par 3 dans l'ensemble de Galois

```vhdl
architecture mixcolumn_arch of mixcolumn is

  signal data2_s: column_state;
  signal data3_s: column_state;

begin
  --[...]
  data3_s <= (
    data2_s(0) xor data_i(0),
    data2_s(1) xor data_i(1),
    data2_s(2) xor data_i(2),
    data2_s(3) xor data_i(3)
  );
```

- On applique `data_o` les opérations décrites ci-dessus :

```vhdl
architecture mixcolumn_arch of mixcolumn is

  signal data2_s: column_state;
  signal data3_s: column_state;

begin

  --[...]
  data_o(0) <= data2_s(0) xor data3_s(1) xor data_i(2) xor data_i(3);
  data_o(1) <= data_i(0) xor data2_s(1) xor data3_s(2) xor data_i(3);
  data_o(2) <= data_i(0) xor data_i(1) xor data2_s(2) xor data3_s(3);
  data_o(3) <= data3_s(0) xor data_i(1) xor data_i(2) xor data2_s(3);

end architecture mixcolumn_arch;
```

#### Testbench

En entrée : une colonne

```vhdl
(x"af", x"44", x"d3", x"ab")
```

Ce que l'on attend :

```vhdl
(x"a0", x"ae", x"2f", x"bc")
```

**Résultat :**

![image-20200111173602799](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111173602799.png)

<div style="text-align: center; font-size: 12px;"><u>Figure 16 : Résultat obtenu pour le test MixColumn</u></div>

Toutes les assertions sont passés, donc **MixColumn est validé**.

Manuellement : D'après la figure ci-dessus, nous avons exactement ce que l'on attend :

<img src="C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111173746553.png" alt="image-20200111173746553" style="zoom: 67%;" />

 <div style="text-align: center; font-size: 12px;"><u>Figure 17 : Extrait de l'énoncé pour la validation MixColumn</u></div>

### MixColumns TestBench

En entrée : un état et 2 cas d'utilisation (enabled et disabled)

```vhdl
  data_i_s <= ((x"af", x"16", x"ce", x"bc"),
               (x"e6", x"91", x"62", x"44"),
               (x"01", x"06", x"d3", x"20"),
               (x"d5", x"ab", x"b1", x"ae"));
  
  enable_i_s <= '0',
                '1' after 50 ns;
```

Ce que l'on attend : Quand `enable_i = 1`

```vhdl
((x"a0", x"29", x"43", x"21"),
 (x"ae", x"8e", x"d5", x"fa"),
 (x"2f", x"6d", x"d9", x"51"),
 (x"bc", x"e0", x"81", x"fc"));
```

Quand `enable_i = 0`

```vhdl
((x"af", x"16", x"ce", x"bc"),
 (x"e6", x"91", x"62", x"44"),
 (x"01", x"06", x"d3", x"20"),
 (x"d5", x"ab", x"b1", x"ae"));
```

**Résultat :**

![image-20200112023428259](C:/Users/nguye/AppData/Roaming/Typora/typora-user-images/image-20200112023428259.png)

<div style="text-align: center; font-size: 12px;"><u>Figure 18 : Résultat obtenu pour le test MixColumns</u></div>

Toutes les assertions sont passés, donc **MixColumns est validé**.

<div style="page-break-after: always; break-after: page;"></div>
Manuellement : D'après la figure ci-dessus, nous avons exactement ce que l'on attend :

![image-20200111174856738](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111174856738.png)

 <div style="text-align: center; font-size: 12px;"><u>Figure 19 : Extrait de l'énoncé pour la validation MixColumns</u></div>
<div style="page-break-after: always; break-after: page;"></div>

## AddRoundKey

AddRoundKey fait simplement un XOR entre l'état et une sous clé (round key).

### AddRoundKey Entity

<img src="C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111175354867.png" alt="image-20200111175354867" style="zoom:67%;" />

<div style="text-align: center; font-size: 12px;"><u>Figure 20 : AddRoundKey Entity</u></div>

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

Le résultat est immédiat :

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

<div style="page-break-after: always; break-after: page;"></div>
### AddRoundKey TestBench

En entrée : un state et une sous-clé

State :

```vhdl
((x"52", x"6f", x"20", x"6c"),
 (x"65", x"20", x"76", x"65"),
 (x"73", x"65", x"69", x"20"),
 (x"74", x"6e", x"6c", x"3f"))
```

Sous-clé :

```vhdl
((x"2b", x"28", x"ab", x"09"),
 (x"7e", x"ae", x"f7", x"cf"),
 (x"15", x"d2", x"15", x"4f"),
 (x"16", x"a6", x"88", x"3c"))
```

Ce que l'on attend :

```vhdl
((x"79", x"47", x"8b", x"65"),
 (x"1b", x"8e", x"81", x"aa"),
 (x"66", x"b7", x"7c", x"6f"),
 (x"62", x"c8", x"e4", x"03"))
```

**Résultat :**

![image-20200111180044804](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111180044804.png)

<div style="text-align: center; font-size: 12px;"><u>Figure 21 : Résultat obtenu pour le test AddRoundKey</u></div>

Toutes les assertions sont passés, donc **AddRoundKey est validé**.

<div style="page-break-after: always; break-after: page;"></div>
Manuellement : D'après la figure ci-dessus, nous avons exactement ce que l'on attend :

![image-20200111180158254](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111180158254.png)

 <div style="text-align: center; font-size: 12px;"><u>Figure 22 : Extrait de l'énoncé pour la validation AddRoundKey</u></div>
<div style="page-break-after: always; break-after: page;"></div>

## Round

Un round doit appliquer toute les fonctions que nous avons développé jusque là. En fonction du nombre de round, nous devrons sélectionner quel fonction appliquer :

![image-20200111180655286](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111180655286.png)

 <div style="text-align: center; font-size: 12px;"><u>Figure 23 : Composition des rounds</u></div>

Il nous faudra donc cadencer notre architecture avec un registre D. 

<div style="page-break-after: always; break-after: page;"></div>
### Round Entity

<img src="C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111181933225.png" alt="image-20200111181933225" style="zoom:67%;" />

 <div style="text-align: center; font-size: 12px;"><u>Figure 24 : Round Entity</u></div>

Le Round possède comme **entrée** :

- Le texte clair que l'on nomme `text_i`, de type `bit128`
- La sous-clé en entrée que l'on nomme `current_key_i`, de type `bit128`
- L'horloge `clock_i` en `std_logic` et le reset `resetb_i` (reset si le niveau est bas)
- `enable_round_computing_i` en `std_logic` qui servira de choisir l'entrée entre le texte clair pour le round 0, ou les résultats des précédant round.
- `enable_mix_columns_i` qui servira de d'activer/désactiver MixColumns pour le Round 0 et Round 10

Le round possède comme **sortie** :

- Le texte chiffré du round que l'on nomme `cipher_o` de type `bit128`

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

<div style="page-break-after: always; break-after: page;"></div>
### Round Architecture

Comme nos entrées sont des `bit128` et que notre architecture se base sur des `type_state`, on convertira les `bits128` en entrée en `state`, et les `state` en sortie en `bit128`

On prévoit donc notre architecture VHDL :

![image-20200111182151979](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111182151979.png)

 <div style="text-align: center; font-size: 12px;"><u>Figure 25 : Round Architecture</u></div>

On connecte donc nos différents composants en VHDL :

```vhdl
architecture round_arch of round is

  ...  -- Déclaration des composants et signaux affichés dans le schéma

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

<div style="page-break-after: always; break-after: page;"></div>
### Component Registre D

Le registre D permettra de cadencer notre round et de synchroniser avec un compteur de round et une machine d'état.

#### Entity

<img src="C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111215605203.png" alt="image-20200111215605203" style="zoom:67%;" />

 <div style="text-align: center; font-size: 12px;"><u>Figure 26 : Registre D Entity</u></div>

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

Test 1 : "Le registre D n'est pas initialisé avant le premier coup ascendant d'horloge"

Test 2 : "Le registre D est initialisé après le premier coup ascendant d'horloge"

Test 3 : "Le registre D change d'état après un coup ascendant d'horloge"

Test 4 : "Le registre D se réinitialise avec resetb_i sans attendre l'horloge"

**Résultat :**

![image-20200111185711131](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111185711131.png)

<div style="text-align: center; font-size: 12px;"><u>Figure 27 : Résultat obtenu pour le test Registre D</u></div>

Toutes les assertions sont passés, donc **Registre D est validé**.

<div style="page-break-after: always; break-after: page;"></div>
### Component state_to_bit128 et bit128_to_state

La relation entrée/sortie avec le composant est assez explicite. 

![image-20200111183328696](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111183328696.png)
$$
a0 = \{input_0,\, input_1,\, …,\, input_7\}; \\
a1 = \{input_8,\, input_9,\, …,\, input_{15}\}; \\
\vdots \\
a15 = \{input_{120},\, input_{121},\, …,\, input_{127}\}. \\
$$

<div style="text-align: center; font-size: 12px;"><u>Figure 28 : Concordance des bits avec les octets d'un état</u></div>

Source :  NIST, [“Fips-197, announcing the ADVANCED ENCRYPTION STANDARD (AES)”](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197.pdf)

Avec bit128 to state :

```vhdl
entity bit128_to_state is

  port (
    data_i: in bit128;
    data_o: out type_state
  );

end entity bit128_to_state;

architecture bit128_to_state_arch of bit128_to_state is
begin

  rows: for i in 0 to 3 generate
    cases: for j in 0 to 3 generate
      data_o(3 - i)(3 - j) <= data_i((8 * (i+1) - 1) + (32 * j) downto (i * 8 + j * 32));
    end generate cases;
  end generate rows;

end architecture bit128_to_state_arch;
```

<div style="page-break-after: always; break-after: page;"></div>
### Round TestBench

On teste le Round 0 et le Round 1 inscrit dans l'énoncé.

Test 1 : "Le round n'est pas initialisé avant le coup d'horloge"

Test 2 : "Le resultat du round 1 (791b6662478eb7c88b817ce465aa6f03) est obtenu au premier coup d'horloge."

- En entrée : 
  - `enable_round_computing_s=0`
  - `enable_mix_columns_s=0` 
  - `text_i_s="526573746f20656e2076696c6c65203f"`
  - `current_key_i_s="2b7e151628aed2a6abf7158809cf4f3c"`

Test 3 : "Le resultat du round 2 (d54257ea74ccc710b56066f9de80a1b8) est obtenu au 2e coup d'horloge."

- En entrée : 
  - La suite du test 2 (`791b6662478eb7c88b817ce465aa6f03`)
  - `enable_round_computing_s=1`
  - `enable_mix_columns_s=1` 
  - `text_i_s="526573746f20656e2076696c6c65203f"`
  - `current_key_i_s="75ec78565d42aaf0f6b5bf78ff7af044"`

**Résultat :**

![image-20200111194647748](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111194647748.png)

<div style="text-align: center; font-size: 12px;"><u>Figure 29 : Résultat obtenu pour le test Round</u></div>

Toutes les assertions sont passés, donc **Round est validé**.

Manuellement : D'après la figure ci-dessus, nous avons exactement ce que l'on attend :

![image-20200111195206914](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111195206914.png)

 <div style="text-align: center; font-size: 12px;"><u>Figure 30 : Extrait de l'énoncé pour la validation Round</u></div>
<div style="page-break-after: always; break-after: page;"></div>

## AES

Pour gérer les états de l'AES, nous utiliserons une machine d'état couplé avec un compteur de round. En fonction de l'état, nous fournissons la sous-clé correspondante au round et exécutons le round.

### AES Entity

On utilisera un signal `start_i` pour démarrer l'AES et un signal `aes_on_o` affichant si l'AES est en cours d'exécution.



<img src="C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111215937077.png" alt="image-20200111215937077" style="zoom:67%;" />

 <div style="text-align: center; font-size: 12px;"><u>Figure 31 : AES Entity</u></div>

```vhdl
entity aes is

  port (
    clock_i: in std_logic;
    resetb_i: in std_logic;
    start_i: in std_logic;
    text_i: in bit128;
    aes_on_o: out std_logic;
    cipher_o: out bit128
  );

end entity aes;
```

<div style="page-break-after: always; break-after: page;"></div>
### AES Architecture

On prévoit cette architecture :

![image-20200111225719439](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111225719439.png)

 <div style="text-align: center; font-size: 12px;"><u>Figure 32 : AES Architecture</u></div>

Cela se fait sans problème en VHDL :

```vhdl
architecture aes_arch of aes is

  component KeyExpansion_I_O_table is
    -- [...] I/O décrit sur le schéma
  end component KeyExpansion_I_O_table;

  component counter is
    -- [...] I/O décrit sur le schéma
  end component counter;

  component fsm_aes is
    -- [...] I/O décrit sur le schéma
  end component fsm_aes;
    
  component round is
    -- [...] I/O décrit sur le schéma
  end component round;

  -- [...] Signaux décrit sur le schéma

begin

  KeyExpansion_I_O_instance: KeyExpansion_I_O_table
    port map(
      round_i => round_s,
      expansion_key_o => current_key_s
    );

  counter_instance: counter
    port map(
      clock_i => clock_i,
      resetb_i => resetb_i,
      init_counter_i => init_counter_s,
      start_counter_i => start_counter_s,
      round_o => round_s
    );

  fsm_aes_instance: fsm_aes
    port map(
      round_i => round_s,
      clock_i => clock_i,
      resetb_i => resetb_i,
      start_i => start_i,
      init_counter_o => init_counter_s,
      start_counter_o => start_counter_s,
      enable_output_o => enable_output_s,
      aes_on_o => aes_on_o,
      enable_round_computing_o => enable_round_computing_s,
      enable_mix_columns_o => enable_mix_columns_s
    );

  round_instance: round
    port map(
      text_i => text_i,
      current_key_i => current_key_s,
      clock_i => clock_i,
      resetb_i => resetb_i,
      enable_round_computing_i => enable_round_computing_s,
      enable_mix_columns_i => enable_mix_columns_s,
      cipher_o => cipher_s
    );

  -- Mux
  cipher_o <= cipher_s when enable_output_s='1' else X"00000000000000000000000000000000";

end architecture aes_arch;
```

<div style="page-break-after: always; break-after: page;"></div>
### Component Machine d'Etat

La machine d'état contrôle le comportement du round en fonction du compteur de round.

![image-20191226155750386](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20191226155750386.png)

 <div style="text-align: center; font-size: 12px;"><u>Figure 33 : Machine d'état</u></div>

Voici donc la configuration des données en fonction des états :

|                 | idle  | start_counter | round_0 | round_1to9 | round10 | end_fsm |
| :-------------: | :---: | :-----------: | :-----: | :--------: | :-----: | :-----: |
| init_counter_o  | **1** |     **1**     |    0    |     0      |    0    |    0    |
| start_counter_o |   0   |     **1**     |  **1**  |   **1**    |    0    |    0    |
| enable_output_o |   0   |       0       |    0    |     0      |    0    |  **1**  |
|    aes_on_o     |   0   |       0       |  **1**  |   **1**    |  **1**  |    0    |
|   enable_RC_o   |   0   |       0       |    0    |   **1**    |  **1**  |    0    |
|   enable_MC_o   |   0   |       0       |    0    |   **1**    |    0    |    0    |

<div style="page-break-after: always; break-after: page;"></div>
#### Entity

<img src="C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111220751861.png" alt="image-20200111220751861" style="zoom:67%;" />

 <div style="text-align: center; font-size: 12px;"><u>Figure 34 : Machine d'état Entity</u></div>

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

<div style="page-break-after: always; break-after: page;"></div>
#### Architecture

**Dans la partie déclarative**, on définit nos états : 

```vhdl
architecture fsm_aes_arch of fsm_aes is

  type state_fsm is (idle, start_counter, round_0, round_1to9, round10, end_fsm);
  signal etat_present, etat_futur: state_fsm;

begin
```

**Dans la partie descriptive**, on définit 3 process.

Pour changer d'état en fonction de l'horloge et du reset, nous utiliserons un process dédié, sensible à l'horloge et au reset :

```vhdl
-- architecture fsm_aes_arch
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
-- architecture fsm_aes_arch
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

Pour changer les données en fonction de l'état, nous utiliserons également un process dédié, sensible à l'état présent :

```vhdl
-- architecture fsm_aes_arch
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

#### TestBench

Les tests unitaires sont :

- Test 1 : "Tester que la FSM est en état initial (Idle)"
- Test 2 : "Pendant un signal start, la FSM reste en état initial mais son état futur est start_counter"
- Test 3 : "Après un signal start, la FSM est en état start_counter"
- Test 4 : "Après l'état start, la FSM est en état R0"
- Test 5 : "Après l'état R0, la FSM est en état R1toR9"
- Test 6 : "Après l'état R1toR9, la FSM est en état R10"
- Test 7 : "Après l'état R10, la FSM est en état End"
- Test 8 : "Après l'état End, la FSM est en état Idle"

**Résultat :**

![image-20200112153458095](C:/Users/nguye/AppData/Roaming/Typora/typora-user-images/image-20200112153458095.png)

<div style="text-align: center; font-size: 12px;"><u>Figure 35 : Résultat obtenu pour le test Machine d'Etat</u></div>

Toutes les assertions sont passés, donc **la machine d'état est validé**.

Manuellement : On peut voir que l'ordre des états décrit la même évolution prévu que sur la figure 42.

### Component Compteur de Round

Notre compteur doit aller de 0 à 10, on utilise donc un compteur 4 bits.

#### Entity

![image-20200111221758363](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200111221758363.png)

 <div style="text-align: center; font-size: 12px;"><u>Figure 36 : Compteur Entity</u></div>

Notre compteur devra être armé avec `init_counter_i`, et devra s'incrémenter dès que le `start_counter_i` passe à 1.

```vhdl
entity counter is

  port (
    clock_i: in std_logic;
    resetb_i: in std_logic;
    init_counter_i: in std_logic;
    start_counter_i: in std_logic;
    round_o: out bit4
  );

end entity counter;
```

<div style="page-break-after: always; break-after: page;"></div>
#### Architecture

L'architecture est simplement basé sur un registre D.

```vhdl
architecture counter_arch of counter is

  signal round_s : bit4;

begin
  seq_0 : process (clock_i, resetb_i) is
  begin
    -- Reset clears state
    if resetb_i = '0' then
      round_s <= "0000";
    
    -- New data at RISING
    elsif clock_i'event and clock_i = '1' then
      -- Arm
      if init_counter_i = '1' then
        round_s <= "0000";
        
      -- Start counting
      elsif start_counter_i = '1' then
        round_s <= std_logic_vector(unsigned(round_s) + 1);
        if round_s = "1011" then  -- if round > 10
          round_s <= "0000";
        end if;
      end if;
    end if;
  end process seq_0;

  round_o <= round_s;
end architecture counter_arch;
```

#### TestBench

Les tests unitaires sont :

- Test 1 : "Le compteur s'incrémente et suit le timing prévu"
- Test 2 : "Le compteur s'arrête quand start = 0"
- Test 3 : "Le compteur se réinitialise quand init = 1"

**Résultat :**

![image-20200112011443858](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200112011443858.png)

<div style="text-align: center; font-size: 12px;"><u>Figure 37 : Résultat obtenu pour le test Compteur</u></div>

Toutes les assertions sont passés, donc **la machine d'état est validé**.

Manuellement : On peut voir que nous incrémentons jusqu'à 10, puis s'arrête quand start = 0, et se réinitialise quand init = 1.

<div style="page-break-after: always; break-after: page;"></div>

### AES TestBench

Nous faisons 2 starts.

Les tests unitaires sont :

- Test 1 : "aes_on_o_s = 1 après un start"
- Test 2 : "aes_on_o_s = 0 à la fin et obtient le bon résultat"

**Résultat final :**

![image-20200112021102841](C:\Users\nguye\AppData\Roaming\Typora\typora-user-images\image-20200112021102841.png)

<div style="text-align: center; font-size: 12px;"><u>Figure 38 : Résultat obtenu pour le test AES</u></div>

Toutes les assertions sont passés, donc **l'AES' est validé**.

Manuellement : On peut vérifier chaque `cipher_o` correspond aux fin des rounds :

> Round 0
> AddRoundKey : 79 1b 66 62 47 8e b7 c8 8b 81 7c e4 65 aa 6f 03
> 
> Round 1
> AddRoundKey : d5 42 57 ea 74 cc c7 10 b5 60 66 f9 de 80 a1 b8
> 
> Round 2
> AddRoundKey : 9b f4 64 34 f9 fb 21 92 36 a3 28 d6 e4 27 a8 4d
> 
> Round 3
> AddRoundKey : 24 dd ad 90 50 14 a4 da c0 af 77 b9 0a 7a d6 d7
> 
> Round 4
> AddRoundKey : 26 84 65 31 b7 10 13 be 29 24 bc 90 db a2 6c 0c
> 
> Round 5
> AddRoundKey : 29 8a b2 69 ab d0 4b 5f 75 af af 5b c5 2c 50 56
> 
> Round 6
> AddRoundKey : 8b 91 b0 15 24 bb 54 18 ba fc 4c 1d 42 3d 56 81
> 
> Round 7
> AddRoundKey : 8a 78 9a 75 7b 07 fd 4b 28 93 38 7f 5b a5 ea e9
> 
> Round 8
> AddRoundKey : 77 07 6c ff 86 93 4a dc d8 61 6d b1 43 5c ca d4
> 
> Round 9
> AddRoundKey : c3 29 63 ee d4 bf f1 38 75 f5 96 25 83 f1 64 0f
> 
> Round 10
> AddRoundKey : d4 f1 25 f0 97 f7 ce e7 47 66 9b 78 30 56 ca a7

<div style="page-break-after: always; break-after: page;"></div>

## Conclusion

La modélisation VHDL du chiffrement AES est maintenant validé. Il ne reste plus qu'à intégrer un mode d'opération (tel que [CBC ou Cipher Block Chaining](https://patents.google.com/patent/US4074066A/en)) pour pouvoir chiffrer plusieurs blocs et intégrer au niveau matériel.

Ce projet n'a posé aucune difficulté, ni ralentissement et a été très formateur.