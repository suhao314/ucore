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

library common;

entity BlowfishSBox is
  port (
    -- Clock
    CLK_I : in std_logic;

    -- S-Box Read Interface
    R_EN_I   : in  std_logic;
    R_ADDR_I : in  std_logic_vector(7 downto 0);
    R_DATA_O : out std_logic_vector(31 downto 0);

    -- S-Box Update Interface
    W_EN_I   : in std_logic;
    W_ADDR_I : in std_logic_vector(7 downto 0);
    W_DATA_I : in std_logic_vector(31 downto 0)

    );
end entity;

architecture rtl of BlowfishSBox is
begin

  u_DualReadPortRAM : entity common.DualReadPortRAM
    generic map (
      param_ADDR_WIDTH => 8,
      param_DATA_WIDTH => 32
      )
    port map (
      A_CLK_I  => CLK_I,
      A_EN_I   => W_EN_I,
      A_ADDR_I => W_ADDR_I,
      A_WE_I   => '1',
      A_DATA_I => W_DATA_I,
      A_DATA_O => open,
      B_CLK_I  => CLK_I,
      B_EN_I   => R_EN_I,
      B_ADDR_I => R_ADDR_I,
      B_DATA_O => R_DATA_O
      );

end architecture rtl;
