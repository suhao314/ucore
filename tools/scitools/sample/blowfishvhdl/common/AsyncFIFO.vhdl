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

--
-- Behavior:
--
--   * All signals are synchronous, except the assertion of reset.
--
--   * Asserting either W_RST_I and R_RST_I will asynchronously reset the
--     entire FIFO. Resets must be deasserted synchronously to their
--     respective clocks.
--
--   * Flags are only asserted on the cycle following a read or write.
--
--   * Flags may be deasserted on any clock cycle.
--
--   * Performing a write while full is asserted has no effect.
--
--   * Performing a read while empty is asserted has no effect.
--
--   * Assertion of almost full indicates that ALMOST_FULL_OFFSET writes or
--     less can be made before full is asserted, assuming no reads happen.
--
--   * Initial assertion of almost full indicates that ALMOST_FULL_OFFSET
--     writes can be made safely from that point without checking flags.
--
--   * Negation of almost full indicates that ALMOST_FULL_OFFSET + 1
--     writes can be made safely from that point without checking flags.
--
--   * Assertion of almost empty indicates that ALMOST_EMPTY_OFFSET reads or
--     less can be made before empty is asserted, assuming no writes happen.
--
--   * Initial assertion of almost empty indicates that ALMOST_EMPTY_OFFSET
--     reads can be made safely from that point without checking flags.
--
--   * Negation of almost empty indicates that ALMOST_EMPTY_OFFSET + 1
--     reads can be made safely from that point without checking flags.
--
--   * Write count always reflects the maximum number of entries in the FIFO,
--     and is always exactly correct assuming no reads happen.
--
--   * Read count always reflects the minimum number of entries in the FIFO,
--     and is always exactly correct assuming no writes happen.
--
--   * FIFO maximum capacity is 2**ADDR_WIDTH-1 entries.
-- 
--   * Maximum latency is 4 write cycles plus 4 read cycles.
--     In SYNCHRONOUS mode, latency is reduced to 2 cycles.
--
--   * SYNCHRONOUS may be set if using a single clock for read and write.
--
--   * ADDR_WIDTH >= 5 will guarantee no latency stalls.
--
--   * ADDR_WIDTH >= 3 will guarantee no latency stalls in SYNCHRONOUS mode.
--

entity AsyncFIFO is
  generic (
    param_ADDR_WIDTH          : positive := 5;
    param_ADDR_WIDTH_WARNING  : boolean  := true;
    param_DATA_WIDTH          : positive := 32;
    param_ALMOST_FULL_OFFSET  : positive := 1;
    param_ALMOST_EMPTY_OFFSET : positive := 1;
    param_SYNCHRONOUS         : boolean  := false
    );
  port (

    -- Write Interface
    W_RST_I         : in  std_logic := '0';
    W_CLK_I         : in  std_logic;
    W_EN_I          : in  std_logic;
    W_DATA_I        : in  std_logic_vector(param_DATA_WIDTH-1 downto 0);
    W_FULL_O        : out std_logic;
    W_ALMOST_FULL_O : out std_logic;
    W_COUNT_O       : out std_logic_vector(param_ADDR_WIDTH-1 downto 0);

    -- Read Interface
    R_RST_I          : in  std_logic := '0';
    R_CLK_I          : in  std_logic;
    R_EN_I           : in  std_logic;
    R_DATA_O         : out std_logic_vector(param_DATA_WIDTH-1 downto 0);
    R_EMPTY_O        : out std_logic;
    R_ALMOST_EMPTY_O : out std_logic;
    R_COUNT_O        : out std_logic_vector(param_ADDR_WIDTH-1 downto 0)

    );
end entity;

architecture rtl of AsyncFIFO is

  signal w_r_rst : std_logic := '0';
  signal r_w_rst : std_logic := '0';
  signal w_rst   : std_logic;
  signal r_rst   : std_logic;

  signal RAM_W_EN_O   : std_logic;
  signal RAM_W_ADDR_O : std_logic_vector(param_ADDR_WIDTH-1 downto 0);
  signal RAM_W_DATA_O : std_logic_vector(param_DATA_WIDTH-1 downto 0);

  signal RAM_R_EN_O   : std_logic;
  signal RAM_R_ADDR_O : std_logic_vector(param_ADDR_WIDTH-1 downto 0);
  signal RAM_R_DATA_I : std_logic_vector(param_DATA_WIDTH-1 downto 0);

  signal PTR_W_O : std_logic_vector(param_ADDR_WIDTH-1 downto 0);
  signal PTR_R_I : std_logic_vector(param_ADDR_WIDTH-1 downto 0);

  signal PTR_W_I : std_logic_vector(param_ADDR_WIDTH-1 downto 0);
  signal PTR_R_O : std_logic_vector(param_ADDR_WIDTH-1 downto 0);
  
begin

  assert
    not param_SYNCHRONOUS or (not param_ADDR_WIDTH_WARNING or param_ADDR_WIDTH >= 3)
    report "ADDR_WIDTH < 3 may result in stalls due to latency" severity warning;

  assert
    param_SYNCHRONOUS or (not param_ADDR_WIDTH_WARNING or param_ADDR_WIDTH >= 5)
    report "ADDR_WIDTH < 5 may result in stalls due to latency" severity warning;

  u_w_r_AsyncReset: entity work.AsyncReset
    port map (
      ASYNC_RST_I => R_RST_I,
      CLK_I       => W_CLK_I,
      RST_O       => w_r_rst
      );

  u_r_w_AsyncReset: entity work.AsyncReset
    port map (
      ASYNC_RST_I => W_RST_I,
      CLK_I       => R_CLK_I,
      RST_O       => r_w_rst
      );
  
  w_rst <= W_RST_I or w_r_rst;
  r_rst <= R_RST_I or r_w_rst;

  u_AsyncFIFO_write : entity work.AsyncFIFO_write
    generic map (
      param_ADDR_WIDTH         => param_ADDR_WIDTH,
      param_DATA_WIDTH         => param_DATA_WIDTH,
      param_ALMOST_FULL_OFFSET => param_ALMOST_FULL_OFFSET
      )
    port map (
      W_RST_I         => w_rst,
      W_CLK_I         => W_CLK_I,
      W_EN_I          => W_EN_I,
      W_DATA_I        => W_DATA_I,
      W_FULL_O        => W_FULL_O,
      W_ALMOST_FULL_O => W_ALMOST_FULL_O,
      W_COUNT_O       => W_COUNT_O,
      RAM_W_EN_O      => RAM_W_EN_O,
      RAM_W_ADDR_O    => RAM_W_ADDR_O,
      RAM_W_DATA_O    => RAM_W_DATA_O,
      PTR_W_O         => PTR_W_O,
      PTR_R_I         => PTR_R_I
      );

  u_AsyncFIFO_read : entity work.AsyncFIFO_read
    generic map (
      param_ADDR_WIDTH          => param_ADDR_WIDTH,
      param_DATA_WIDTH          => param_DATA_WIDTH,
      param_ALMOST_EMPTY_OFFSET => param_ALMOST_EMPTY_OFFSET
      )
    port map (
      R_RST_I          => r_rst,
      R_CLK_I          => R_CLK_I,
      R_EN_I           => R_EN_I,
      R_DATA_O         => R_DATA_O,
      R_EMPTY_O        => R_EMPTY_O,
      R_ALMOST_EMPTY_O => R_ALMOST_EMPTY_O,
      R_COUNT_O        => R_COUNT_O,
      RAM_R_EN_O       => RAM_R_EN_O,
      RAM_R_ADDR_O     => RAM_R_ADDR_O,
      RAM_R_DATA_I     => RAM_R_DATA_I,
      PTR_W_I          => PTR_W_I,
      PTR_R_O          => PTR_R_O
      );

  u_PTR_W_AsyncFIFO_boundary : entity work.AsyncFIFO_boundary
    generic map (
      param_ADDR_WIDTH  => param_ADDR_WIDTH,
      param_SYNCHRONOUS => param_SYNCHRONOUS
      )
    port map (
      W_RST_I => W_RST_I,
      W_CLK_I => W_CLK_I,
      W_PTR_I => PTR_W_O,
      R_RST_I => R_RST_I,
      R_CLK_I => R_CLK_I,
      R_PTR_O => PTR_W_I
      );

  u_PTR_R_AsyncFIFO_boundary : entity work.AsyncFIFO_boundary
    generic map (
      param_ADDR_WIDTH  => param_ADDR_WIDTH,
      param_SYNCHRONOUS => param_SYNCHRONOUS
      )
    port map (
      W_RST_I => W_RST_I,
      W_CLK_I => R_CLK_I,
      W_PTR_I => PTR_R_O,
      R_RST_I => R_RST_I,
      R_CLK_I => W_CLK_I,
      R_PTR_O => PTR_R_I
      );

  u_DualReadPortRAM : entity work.DualReadPortRAM
    generic map (
      param_ADDR_WIDTH => param_ADDR_WIDTH,
      param_DATA_WIDTH => param_DATA_WIDTH
      )
    port map (
      A_CLK_I  => W_CLK_I,
      A_EN_I   => RAM_W_EN_O,
      A_ADDR_I => RAM_W_ADDR_O,
      A_WE_I   => RAM_W_EN_O,
      A_DATA_I => RAM_W_DATA_O,
      A_DATA_O => open,
      B_CLK_I  => R_CLK_I,
      B_EN_I   => RAM_R_EN_O,
      B_ADDR_I => RAM_R_ADDR_O,
      B_DATA_O => RAM_R_DATA_I
      );

end architecture;
