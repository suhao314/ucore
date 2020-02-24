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

entity FIFO2FIFO is
  generic (
    param_DATA_WIDTH : positive := 32
    );
  port (

    -- Read Interface
    R_EN_O    : out std_logic;
    R_DATA_I  : in  std_logic_vector(param_DATA_WIDTH-1 downto 0);
    R_EMPTY_I : in  std_logic;

    -- Write Interface
    W_EN_O   : out std_logic;
    W_DATA_O : out std_logic_vector(param_DATA_WIDTH-1 downto 0);
    W_FULL_I : in  std_logic

    );
end entity;

architecture rtl of FIFO2FIFO is
begin

  R_EN_O <= not W_FULL_I;
  W_EN_O <= not R_EMPTY_I;
  W_DATA_O <= R_DATA_I;
  
end architecture;
