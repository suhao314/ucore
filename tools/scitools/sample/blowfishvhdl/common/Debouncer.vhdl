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

entity Debouncer is
  generic (
    param_COUNTER_WIDTH : natural := 1
    );
  port (
    RST_I : in  std_logic := '0';
    CLK_I : in  std_logic;
    D_I   : in  std_logic;
    D_O   : out std_logic
    );
end entity;

architecture rtl of Debouncer is
  signal d : std_logic;
begin

  u_AsyncFilter : entity work.AsyncFilter
    port map (
      RST_I => RST_I,
      CLK_I => CLK_I,
      D_I   => D_I,
      D_O   => d
      );

  process (RST_I, CLK_I) is
    constant COUNT_MAX : natural := 2**param_COUNTER_WIDTH - 1;
    constant COUNT_MIN : natural := 0;
    variable count     : unsigned(param_COUNTER_WIDTH-1 downto 0) := (others => '0');
    variable q         : std_logic := '0';
  begin

    if RST_I = '1' then
      count := (others => '0');
      q     := '0';
    elsif rising_edge(CLK_I) then

      if d = '1' then
        if count /= COUNT_MAX then
          count := count + 1;
        else
          q := '1';
        end if;
      else
        if count /= COUNT_MIN then
          count := count - 1;
        else
          q := '0';
        end if;
      end if;

    end if;

    D_O <= q;

  end process;

end architecture;
