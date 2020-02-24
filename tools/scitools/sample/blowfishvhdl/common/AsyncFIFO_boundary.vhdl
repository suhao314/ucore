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

entity AsyncFIFO_boundary is
  generic (
    param_ADDR_WIDTH  : natural := 4;
    param_SYNCHRONOUS : boolean := false
    );
  port (

    -- Write Interface
    W_RST_I : in std_logic := '0';
    W_CLK_I : in std_logic;
    W_PTR_I : in std_logic_vector(param_ADDR_WIDTH-1 downto 0);

    -- Read Interface
    R_RST_I : in  std_logic := '0';
    R_CLK_I : in  std_logic;
    R_PTR_O : out std_logic_vector(param_ADDR_WIDTH-1 downto 0) := (others => '0')

    );
  
end entity;

architecture rtl of AsyncFIFO_boundary is
begin

  if_SYNCHRONOUS : if param_SYNCHRONOUS generate
    process (R_CLK_I, R_RST_I, W_RST_I) is
    begin
      if W_RST_I = '1' or R_RST_I = '1' then
        R_PTR_O <= (others => '0');
      elsif rising_edge(R_CLK_I) then
        R_PTR_O <= W_PTR_I;
      end if;
    end process;
  end generate;

  if_not_SYNCHRONOUS : if not param_SYNCHRONOUS generate

    u_AsyncBoundary : entity work.AsyncBoundary
      generic map (
        param_DATA_WIDTH => param_ADDR_WIDTH
        )
      port map (
        W_RST_I  => W_RST_I,
        W_CLK_I  => W_CLK_I,
        W_DATA_I => W_PTR_I,
        R_RST_I  => R_RST_I,
        R_CLK_I  => R_CLK_I,
        R_DATA_O => R_PTR_O
        );

  end generate;

end architecture;
