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

entity AsyncFIFO_read is
  generic (
    param_ADDR_WIDTH          : positive := 4;
    param_DATA_WIDTH          : positive := 32;
    param_ALMOST_EMPTY_OFFSET : positive := 1
    );
  port (

    -- User Interface
    R_RST_I          : in  std_logic;
    R_CLK_I          : in  std_logic;
    R_EN_I           : in  std_logic;
    R_DATA_O         : out std_logic_vector(param_DATA_WIDTH-1 downto 0);
    R_EMPTY_O        : out std_logic;
    R_ALMOST_EMPTY_O : out std_logic;
    R_COUNT_O        : out std_logic_vector(param_ADDR_WIDTH-1 downto 0);

    -- Memory Interface
    RAM_R_EN_O   : out std_logic;
    RAM_R_ADDR_O : out std_logic_vector(param_ADDR_WIDTH-1 downto 0);
    RAM_R_DATA_I : in  std_logic_vector(param_DATA_WIDTH-1 downto 0);

    -- Pointer Interface
    PTR_W_I : in  std_logic_vector(param_ADDR_WIDTH-1 downto 0);
    PTR_R_O : out std_logic_vector(param_ADDR_WIDTH-1 downto 0)

    );
end entity;

architecture rtl of AsyncFIFO_read is

  signal r_en : std_logic;

  signal r_empty        : std_logic                         := '1';
  signal r_almost_empty : std_logic                         := '1';
  signal r_count        : std_logic_vector(R_COUNT_O'range) := (others => '0');

  signal w_ptr : unsigned(PTR_W_I'range);
  signal r_ptr : unsigned(PTR_R_O'range) := (others => '0');
  
begin
  
  r_en <= R_EN_I and not r_empty;

  block_read : block is
  begin

    RAM_R_EN_O <= r_en or r_empty;

    proc_address : process (r_empty, r_ptr) is
    begin
      RAM_R_ADDR_O <= std_logic_vector(r_ptr + 1);
      if r_empty = '1' then
        RAM_R_ADDR_O <= std_logic_vector(r_ptr);
      end if;
    end process;

    R_DATA_O <= RAM_R_DATA_I;
    
  end block;

  proc_pointers : process (R_CLK_I, R_RST_I) is
  begin
    if R_RST_I = '1' then
      r_ptr <= (others => '0');
    elsif rising_edge(R_CLK_I) then
      if r_en = '1' then
        r_ptr <= r_ptr + 1;
      end if;
    end if;
  end process;

  w_ptr   <= unsigned(PTR_W_I);
  PTR_R_O <= std_logic_vector(r_ptr);

  block_flags : block is
    constant const_FIFO_DEPTH   : positive := 2**param_ADDR_WIDTH;
    constant const_EMPTY        : natural  := 0;
    constant const_ALMOST_EMPTY : positive := const_EMPTY+param_ALMOST_EMPTY_OFFSET;

    signal count : unsigned(r_count'range);
    
  begin

    assert param_ALMOST_EMPTY_OFFSET < const_FIFO_DEPTH-1
      report "Invalid ALMOST_EMPTY_OFFSET (must be < 2**ADDR_WIDTH-1)" severity failure;

    proc_count : process (r_en, r_ptr, w_ptr) is
    begin
      count <= w_ptr - r_ptr;
      if r_en = '1' then
        count <= w_ptr - (r_ptr + 1);
      end if;
    end process;

    proc_flags : process (R_CLK_I, R_RST_I) is
    begin
      if R_RST_I = '1' then
        r_empty        <= '1';
        r_almost_empty <= '1';
        r_count        <= (others => '0');
      elsif rising_edge(R_CLK_I) then
        r_empty        <= '0';
        r_almost_empty <= '0';
        r_count        <= std_logic_vector(count);
        if (count = const_EMPTY) then
          r_empty        <= '1';
          r_almost_empty <= '1';
        elsif count <= const_ALMOST_EMPTY then
          r_almost_empty <= '1';
        end if;
      end if;
    end process;

    R_EMPTY_O        <= r_empty;
    R_ALMOST_EMPTY_O <= r_almost_empty;
    R_COUNT_O        <= r_count;
    
  end block;

end architecture;
