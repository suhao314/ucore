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

entity DualReadPortRAM is

  generic (
    param_ADDR_WIDTH : positive := 10;
    param_DATA_WIDTH : positive := 32
    );

  port (

    -- A-side (read/write) Interface
    A_CLK_I  : in  std_logic;
    A_EN_I   : in  std_logic;
    A_ADDR_I : in  std_logic_vector(param_ADDR_WIDTH-1 downto 0);
    A_WE_I   : in  std_logic;
    A_DATA_I : in  std_logic_vector(param_DATA_WIDTH-1 downto 0);
    A_DATA_O : out std_logic_vector(param_DATA_WIDTH-1 downto 0);

    -- B-side (read-only) Interface
    B_CLK_I  : in  std_logic;
    B_EN_I   : in  std_logic;
    B_ADDR_I : in  std_logic_vector(param_ADDR_WIDTH-1 downto 0);
    B_DATA_O : out std_logic_vector(param_DATA_WIDTH-1 downto 0)

    );

end entity;

architecture rtl of DualReadPortRAM is
  constant const_MEMORY_DEPTH : positive := 2**param_ADDR_WIDTH;

  type memory_t is array (0 to const_MEMORY_DEPTH-1) of std_logic_vector(param_DATA_WIDTH-1 downto 0);
  signal memory : memory_t;
  
begin

  proc_a_port : process (A_CLK_I) is
    variable address : integer;
  begin
    if rising_edge(A_CLK_I) then
      if A_EN_I = '1' then
        address := to_integer(unsigned(A_ADDR_I));
        if A_WE_I = '1' then
          memory(address) <= A_DATA_I;
        end if;
        A_DATA_O <= memory(address);
      end if;
    end if;
  end process;

  proc_b_port : process (B_CLK_I) is
    variable address : integer;
  begin
    if rising_edge(B_CLK_I) then
      if B_EN_I = '1' then
        address := to_integer(unsigned(B_ADDR_I));
        B_DATA_O <= memory(address);
      end if;
    end if;
  end process;
  
end architecture;
