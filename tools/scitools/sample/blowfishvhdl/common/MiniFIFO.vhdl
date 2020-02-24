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

entity MiniFIFO is
  generic (
    param_DATA_WIDTH : positive := 32
    );
  port (

    -- Reset & Clock
    RST_I : in std_logic := '0';
    CLK_I : in std_logic;

    -- Write Interface
    W_EN_I   : in  std_logic;
    W_DATA_I : in  std_logic_vector(param_DATA_WIDTH-1 downto 0);
    W_FULL_O : out std_logic;

    -- Read Interface
    R_EN_I    : in  std_logic;
    R_DATA_O  : out std_logic_vector(param_DATA_WIDTH-1 downto 0);
    R_EMPTY_O : out std_logic

    );
end entity;

architecture rtl of MiniFIFO is

  signal valid : std_logic := '0';
  
begin
  
  proc_valid : process (CLK_I, RST_I) is
  begin
    if RST_I = '1' then
      valid <= '0';
    elsif rising_edge(CLK_I) then
      if W_EN_I = '1' then
        valid <= '1';
      elsif R_EN_I = '1' and valid = '1' then
        valid <= '0';
      end if;
    end if;
  end process;

  W_FULL_O  <= (valid and not R_EN_I) or RST_I;
  R_EMPTY_O <= not valid or RST_I;

  proc_data : process (CLK_I) is
    variable write_ok : std_logic;
  begin
    if rising_edge(CLK_I) then
      if RST_I = '1' then
        write_ok := '0';
      else
        write_ok := not valid or R_EN_I;
      end if;
      if (W_EN_I and write_ok) = '1' then
        R_DATA_O <= W_DATA_I;
      end if;
    end if;
  end process;
  
end architecture;
