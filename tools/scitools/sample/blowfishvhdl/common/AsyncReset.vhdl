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

entity AsyncReset is
  port (
    ASYNC_RST_I : in  std_logic := '0';
    CLK_I       : in  std_logic;
    RST_O       : out std_logic
    );
end entity;

architecture rtl of AsyncReset is
  signal rst : std_logic := '1';
begin

  process (ASYNC_RST_I, CLK_I) is
  begin
    if ASYNC_RST_I = '1' then
      rst <= '1';
    elsif rising_edge(CLK_I) then
      rst <= '0';
    end if;
  end process;
  
  RST_O <= rst;
  
end architecture;
