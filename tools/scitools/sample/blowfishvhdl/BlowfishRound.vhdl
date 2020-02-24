-- Copyright © 2007 Wesley J. Landaker <wjl@icecavern.net>
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BlowfishRound is
  port (

    -- Clock
    CLK_I : in std_logic;

    -- Data Interface
    EN_I   : in  std_logic;
    DATA_I : in  std_logic_vector(63 downto 0);
    DATA_O : out std_logic_vector(63 downto 0);

    -- P-Array Interface
    P_DATA_I : in std_logic_vector(31 downto 0);

    -- S-Box #1 Interface
    S1_EN_O   : out std_logic;
    S1_ADDR_O : out std_logic_vector(7 downto 0);
    S1_DATA_I : in  std_logic_vector(31 downto 0);

    -- S-Box #2 Interface
    S2_EN_O   : out std_logic;
    S2_ADDR_O : out std_logic_vector(7 downto 0);
    S2_DATA_I : in  std_logic_vector(31 downto 0);

    -- S-Box #3 Interface
    S3_EN_O   : out std_logic;
    S3_ADDR_O : out std_logic_vector(7 downto 0);
    S3_DATA_I : in  std_logic_vector(31 downto 0);

    -- S-Box #4 Interface
    S4_EN_O   : out std_logic;
    S4_ADDR_O : out std_logic_vector(7 downto 0);
    S4_DATA_I : in  std_logic_vector(31 downto 0)

    );
end entity;

--                                 (For 4 rounds instead of 16)
-- CLK  ___/~~~\___/~~~\___/~~~\___/~~~\___/~~~\___/~~~\___/~~~\___/~~~\___/~~~\___/~~~\___
-- EN_I ____/~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\______________
-- DATI ====< DI0R0 X DI0R1 X DI0R2 X DI0R3 X DI1R0 X DI1R1 X DI1R2 X DI1R3 >==============
-- DATO ============< DO0R0 X DO0R1 X DO0R2 X DO0R3 X DO1R0 X DO1R1 X DO1R2 X DO1R3 >======
-- PSEN ____/~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\______________
-- PSAD ====< PS0A0 X PS0A1 X PS0A2 X PS0A3 X PS1A0 X PS1A1 X PS1A2 X PS1A3 >==============
-- PSDT ============< PS0D0 X PS0D1 X PS0D2 X PS0D3 X PS1D0 X PS1D1 X PS1D2 X PS1D3 >======

architecture rtl of BlowfishRound is
  signal xL, next_xL, xR, next_xR, FxL : std_logic_vector(31 downto 0);
begin

  next_xL <= DATA_I(63 downto 32) xor P_DATA_I;
  next_xR <= DATA_I(31 downto 0);

  S1_EN_O <= EN_I;
  S2_EN_O <= EN_I;
  S3_EN_O <= EN_I;
  S4_EN_O <= EN_I;

  S1_ADDR_O <= next_xL(31 downto 24);
  S2_ADDR_O <= next_xL(23 downto 16);
  S3_ADDR_O <= next_xL(15 downto 8);
  S4_ADDR_O <= next_xL(7 downto 0);

  process (CLK_I) is
  begin
    if rising_edge(CLK_I) then
      if EN_I = '1' then
        xL <= next_xL;
        xR <= next_xR;
      end if;
    end if;
  end process;

  process (S1_DATA_I, S2_DATA_I, S3_DATA_I, S4_DATA_I) is
    variable next_FxL : unsigned(31 downto 0);
  begin
    next_FxL := (others => '0');
    next_FxL := next_FxL xor unsigned(S1_DATA_I);
    next_FxL := next_FxL + unsigned(S2_DATA_I);
    next_FxL := next_FxL xor unsigned(S3_DATA_I);
    next_FxL := next_FxL + unsigned(S4_DATA_I);
    FxL      <= std_logic_vector(next_FxL);
  end process;

  DATA_O <= (xR xor FxL) & xL;
  
end architecture rtl;
