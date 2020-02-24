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

entity AsyncFIFO_write is
  generic (
    param_ADDR_WIDTH         : positive := 4;
    param_DATA_WIDTH         : positive := 32;
    param_ALMOST_FULL_OFFSET : positive := 1
    );
  port (

    -- User Interface
    W_RST_I         : in  std_logic;
    W_CLK_I         : in  std_logic;
    W_EN_I          : in  std_logic;
    W_DATA_I        : in  std_logic_vector(param_DATA_WIDTH-1 downto 0);
    W_FULL_O        : out std_logic;
    W_ALMOST_FULL_O : out std_logic;
    W_COUNT_O       : out std_logic_vector(param_ADDR_WIDTH-1 downto 0);

    -- Memory Interface
    RAM_W_EN_O   : out std_logic;
    RAM_W_ADDR_O : out std_logic_vector(param_ADDR_WIDTH-1 downto 0);
    RAM_W_DATA_O : out std_logic_vector(param_DATA_WIDTH-1 downto 0);

    -- Pointer Interface
    PTR_W_O : out std_logic_vector(param_ADDR_WIDTH-1 downto 0);
    PTR_R_I : in  std_logic_vector(param_ADDR_WIDTH-1 downto 0)

    );
end entity;

architecture rtl of AsyncFIFO_write is

  signal w_en : std_logic;

  signal w_full        : std_logic                         := '1';
  signal w_almost_full : std_logic                         := '1';
  signal w_count       : std_logic_vector(W_COUNT_O'range) := (others => '1');

  signal w_ptr : unsigned(PTR_W_O'range) := (others => '0');
  signal r_ptr : unsigned(PTR_R_I'range);
  
begin

  w_en <= W_EN_I and not w_full;

  proc_write : process (W_CLK_I) is
  begin
    if rising_edge(W_CLK_I) then
      RAM_W_EN_O   <= w_en;
      RAM_W_ADDR_O <= std_logic_vector(w_ptr);
      RAM_W_DATA_O <= W_DATA_I;
    end if;
  end process;

  proc_pointers : process (W_CLK_I, W_RST_I) is
  begin
    if W_RST_I = '1' then
      w_ptr <= (others => '0');
    elsif rising_edge(W_CLK_I) then
      if w_en = '1' then
        w_ptr <= w_ptr + 1;
      end if;
    end if;
  end process;

  PTR_W_O <= std_logic_vector(w_ptr);
  r_ptr   <= unsigned(PTR_R_I);

  block_flags : block is
    constant const_FIFO_DEPTH  : positive := 2**param_ADDR_WIDTH;
    constant const_FULL        : positive := const_FIFO_DEPTH-1;
    constant const_ALMOST_FULL : positive := const_FULL-param_ALMOST_FULL_OFFSET;

    signal count : unsigned(w_count'range);
  begin

    assert param_ALMOST_FULL_OFFSET < const_FIFO_DEPTH-1
      report "Invalid ALMOST_FULL_OFFSET (must be < 2**ADDR_WIDTH-1)" severity failure;
    
    proc_count : process (r_ptr, w_en, w_ptr) is
    begin
      count <= w_ptr - r_ptr;
      if w_en = '1' then
        count <= (w_ptr + 1) - r_ptr;
      end if;
    end process;

    proc_flags : process (W_CLK_I, W_RST_I) is
    begin
      if W_RST_I = '1' then
        w_full        <= '1';
        w_almost_full <= '1';
        w_count       <= (others => '1');
      elsif rising_edge(W_CLK_I) then
        w_full        <= '0';
        w_almost_full <= '0';
        w_count       <= std_logic_vector(count);
        if count = const_FULL then
          w_full        <= '1';
          w_almost_full <= '1';
        elsif count >= const_ALMOST_FULL then
          w_almost_full <= '1';
        end if;
      end if;
    end process;

    W_FULL_O        <= w_full;
    W_ALMOST_FULL_O <= w_almost_full;
    W_COUNT_O       <= w_count;
    
  end block;
  
end architecture;
