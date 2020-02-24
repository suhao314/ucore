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

-- Passes an arbitrary-width data bus atomically from one clock domain to
-- the other. Not every value appearing at the write side will necessarily
-- make it to the read side. However, following the first transfer after
-- reset, the data on the read side is always guaranteed to be some value
-- that appeared on the write side. The read and write interfaces have flags
-- that can help identify when data is initially valid after reset, as well
-- as when it is being sampled and updated.
--
-- Asserting either W_RST_I and R_RST_I will asynchronously reset the entire
-- asynchronous boundary. Resets can be asserted at any time, but should be
-- deasserted synchronously to their respective clocks.
--
-- There are no limits on or assumptions of the relationship between W_CLK_I
-- and R_CLK_I. Each can be any frequency or phase, limited only by the
-- underlying physical device or process being targetted.
--
-- W_DATA_I is sampled synchronously on W_CLK_I whenever W_FULL_O is not
-- asserted. Any data value sampled on the write side is guaranteed to show
-- up atomically on the read side.
--
-- W_FULL_O is asserted when data is in the process of being transferred
-- from the write side to the read side. When W_FULL_O is deasserted, data
-- will be sampled on the next rising W_CLK_I edge, so W_FULL_O will only
-- ever be deasserted for one clock cycle in a row.
--
-- R_DATA_O has been updated synchronously to R_CLK_I whenever R_EMPTY_O is not
-- asserted. During and immediately after reset, the value of R_DATA_O is all
-- zeros. Starting with the first deassertion of R_EMPTY_O, R_DATA_O is always
-- guaranteed to be some atomic value that was sampled on the write side.
--
-- R_EMPTY_O is asserted when data is in the processed of being transferred
-- from the write side to the read side. While R_EMPTY_O is asserted, the
-- value of R_DATA_O is held. When R_EMPTY_O is deasserted, it indicates
-- that R_DATA_O has just been atomically updated to the value transferred
-- from the write side, so R_EMPTY_O will only ever be deasserted for one
-- clock cycle in a row.
-- 
-- Maximum data passing period is 2 write clocks cycles plus 2 read clock cycles.
-- Minimum data passing period is 1 write clock  cycle  plus 1 read clock cycle.
--
-- Timing Constraints:
--
--   * W_CLK_I and R_CLK_I domains must independently meet timing.
--
--   * from w_data to r_data in period(W_CLK_I)/2 + period(R_CLK_I)/2
--     This key constraint ensures that data has fully propagated
--     before being captured, even in the absolute worst case scenerio.
--
--   * Other registers between W_CLK_I and R_CLK_I are unconstrained.

entity AsyncBoundary is
  generic (
    param_DATA_WIDTH : positive := 32
    );
  port (

    -- Write Port
    W_RST_I  : in  std_logic := '0';
    W_CLK_I  : in  std_logic;
    W_DATA_I : in  std_logic_vector(param_DATA_WIDTH-1 downto 0);
    W_FULL_O : out std_logic;

    -- Read Port
    R_RST_I   : in  std_logic := '0';
    R_CLK_I   : in  std_logic;
    R_DATA_O  : out std_logic_vector(param_DATA_WIDTH-1 downto 0);
    R_EMPTY_O : out std_logic

    );
end entity;

architecture rtl of AsyncBoundary is
  signal w_write_ptr : std_logic := '0';
  signal r_read_ptr  : std_logic := '0';

  signal w_data : std_logic_vector(param_DATA_WIDTH-1 downto 0) := (others => '0');
  signal r_data : std_logic_vector(param_DATA_WIDTH-1 downto 0) := (others => '0');
begin

  block_write : block is
    signal w_reset      : std_logic;
    signal w_read_reset : std_logic := '0';
    signal w_read_ptr   : std_logic := '0';
    signal w_ready      : std_logic;
  begin

    u_AsyncReset: entity work.AsyncReset
      port map (
        ASYNC_RST_I => R_RST_I,
        CLK_I       => W_CLK_I,
        RST_O       => w_read_reset
        );
    
    w_reset <= W_RST_I or w_read_reset;

    proc_w_read_ptr : process (W_CLK_I, w_reset) is
    begin
      if w_reset = '1' then
        w_read_ptr <= '0';
      elsif falling_edge(W_CLK_I) then
        w_read_ptr <= r_read_ptr;
      end if;
    end process;

    w_ready <= w_write_ptr xnor w_read_ptr;

    proc_write : process (W_CLK_I, w_reset) is
    begin
      if w_reset = '1' then
        w_write_ptr <= '0';
      elsif falling_edge(W_CLK_I) then
        if w_ready = '1' then
          w_write_ptr <= not w_write_ptr;
        end if;
      end if;
    end process;

    proc_data : process (W_CLK_I, w_reset) is
    begin
      if w_reset = '1' then
        w_data <= (others => '0');
      elsif rising_edge(W_CLK_I) then
        if w_ready = '1' then
          w_data <= W_DATA_I;
        end if;
      end if;
    end process;

    W_FULL_O <= not w_ready or w_reset;
    
  end block;

  block_read : block is
    signal r_reset       : std_logic;
    signal r_write_reset : std_logic := '0';
    signal r_write_ptr   : std_logic := '0';
    signal r_ready       : std_logic;
    signal r_empty       : std_logic := '1';
  begin

    u_AsyncReset: entity work.AsyncReset
      port map (
        ASYNC_RST_I => W_RST_I,
        CLK_I       => R_CLK_I,
        RST_O       => r_write_reset
        );
    
    r_reset <= R_RST_I or r_write_reset;

    proc_w_read_ptr : process (R_CLK_I, r_reset) is
    begin
      if r_reset = '1' then
        r_write_ptr <= '0';
      elsif falling_edge(R_CLK_I) then
        r_write_ptr <= w_write_ptr;
      end if;
    end process;

    r_ready <= r_write_ptr xor r_read_ptr;

    proc_read : process (R_CLK_I, r_reset) is
    begin
      if r_reset = '1' then
        r_read_ptr <= '0';
      elsif falling_edge(R_CLK_I) then
        if r_ready = '1' then
          r_read_ptr <= not r_read_ptr;
        end if;
      end if;
    end process;

    proc_data : process (R_CLK_I, r_reset) is
    begin
      if r_reset = '1' then
        r_data  <= (others => '0');
        r_empty <= '1';
      elsif rising_edge(R_CLK_I) then
        if r_ready = '1' then
          r_data <= w_data;
        end if;
        r_empty <= not r_ready;
      end if;
    end process;

    R_DATA_O  <= r_data;
    R_EMPTY_O <= r_empty;
    
  end block;

end architecture;
