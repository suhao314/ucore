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

entity AsyncFilter is
  generic (
    param_NEGATIVE_EDGE : boolean := false
    );
  port (
    RST_I : in  std_logic := '0';
    CLK_I : in  std_logic;
    D_I   : in  std_logic;
    D_O   : out std_logic
    );
end entity;

architecture rtl of AsyncFilter is
begin

  process (CLK_I, RST_I) is
    variable data : std_logic_vector(1 downto 0) := (others => '0');
  begin
    if (param_NEGATIVE_EDGE) then
      if RST_I = '1' then
        data(0) := '0';
      elsif falling_edge(CLK_I) then
        data(0) := D_I;
      end if;
      if RST_I = '1' then
        data(1) := '0';
      elsif rising_edge(CLK_I) then
        data(1) := data(0);
      end if;
    else
      if RST_I = '1' then
        data(0) := '0';
      elsif rising_edge(CLK_I) then
        data(0) := D_I;
      end if;
      if RST_I = '1' then
        data(1) := '0';
      elsif falling_edge(CLK_I) then
        data(1) := data(0);
      end if;
    end if;

    D_O <= data(1);

  end process;

end architecture;
