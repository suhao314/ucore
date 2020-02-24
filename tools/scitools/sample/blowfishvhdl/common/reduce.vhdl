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

package reduce is
  function and_reduce(i  : std_logic_vector) return std_logic;
  function or_reduce(i   : std_logic_vector) return std_logic;
  function xor_reduce(i  : std_logic_vector) return std_logic;
  function nand_reduce(i : std_logic_vector) return std_logic;
  function nor_reduce(i  : std_logic_vector) return std_logic;
  function xnor_reduce(i : std_logic_vector) return std_logic;

  function and_reduce(i  : std_ulogic_vector) return std_logic;
  function or_reduce(i   : std_ulogic_vector) return std_logic;
  function xor_reduce(i  : std_ulogic_vector) return std_logic;
  function nand_reduce(i : std_ulogic_vector) return std_logic;
  function nor_reduce(i  : std_ulogic_vector) return std_logic;
  function xnor_reduce(i : std_ulogic_vector) return std_logic;

  function and_reduce(i  : signed) return std_logic;
  function or_reduce(i   : signed) return std_logic;
  function xor_reduce(i  : signed) return std_logic;
  function nand_reduce(i : signed) return std_logic;
  function nor_reduce(i  : signed) return std_logic;
  function xnor_reduce(i : signed) return std_logic;

  function and_reduce(i  : unsigned) return std_logic;
  function or_reduce(i   : unsigned) return std_logic;
  function xor_reduce(i  : unsigned) return std_logic;
  function nand_reduce(i : unsigned) return std_logic;
  function nor_reduce(i  : unsigned) return std_logic;
  function xnor_reduce(i : unsigned) return std_logic;
  
end package reduce;

package body reduce is

  function and_reduce(i : std_logic_vector) return std_logic is
    variable result : std_logic;
    variable mid    : integer;
  begin
    if i'length < 1 then
      result := '1';
    elsif i'length = 1 then
      result := i(i'low);
    else
      mid    := (i'length+1)/2 + i'low;
      result := and_reduce(i(i'high downto mid)) and
                and_reduce(i(mid-1 downto i'low));
    end if;
    return result;
  end function;

  function or_reduce(i : std_logic_vector) return std_logic is
    variable result : std_logic;
    variable mid    : integer;
  begin
    if i'length < 1 then
      result := '0';
    elsif i'length = 1 then
      result := i(i'low);
    else
      mid    := (i'length+1)/2 + i'low;
      result := or_reduce(i(i'high downto mid)) or
                or_reduce(i(mid-1 downto i'low));
    end if;
    return result;
  end function;

  function xor_reduce(i : std_logic_vector) return std_logic is
    variable result : std_logic;
    variable mid    : integer;
  begin
    if i'length < 1 then
      result := '0';
    elsif i'length = 1 then
      result := i(i'low);
    else
      mid    := (i'length+1)/2 + i'low;
      result := xor_reduce(i(i'high downto mid)) xor
                xor_reduce(i(mid-1 downto i'low));
    end if;
    return result;
  end function;

  function nand_reduce(i : std_logic_vector) return std_logic is
  begin
    return not and_reduce(i);
  end function;

  function nor_reduce(i : std_logic_vector) return std_logic is
  begin
    return not or_reduce(i);
  end function;

  function xnor_reduce(i : std_logic_vector) return std_logic is
  begin
    return not xor_reduce(i);
  end function;

  -- std_ulogic_vector

  function and_reduce(i : std_ulogic_vector) return std_logic is
  begin
    return and_reduce(std_logic_vector(i));
  end function;

  function or_reduce(i : std_ulogic_vector) return std_logic is
  begin
    return or_reduce(std_logic_vector(i));
  end function;

  function xor_reduce(i : std_ulogic_vector) return std_logic is
  begin
    return xor_reduce(std_logic_vector(i));
  end function;

  function nand_reduce(i : std_ulogic_vector) return std_logic is
  begin
    return nand_reduce(std_logic_vector(i));
  end function;

  function nor_reduce(i : std_ulogic_vector) return std_logic is
  begin
    return nor_reduce(std_logic_vector(i));
  end function;

  function xnor_reduce(i : std_ulogic_vector) return std_logic is
  begin
    return xnor_reduce(std_logic_vector(i));
  end function;

  -- signed

  function and_reduce(i : signed) return std_logic is
  begin
    return and_reduce(std_logic_vector(i));
  end function;

  function or_reduce(i : signed) return std_logic is
  begin
    return or_reduce(std_logic_vector(i));
  end function;

  function xor_reduce(i : signed) return std_logic is
  begin
    return xor_reduce(std_logic_vector(i));
  end function;

  function nand_reduce(i : signed) return std_logic is
  begin
    return nand_reduce(std_logic_vector(i));
  end function;

  function nor_reduce(i : signed) return std_logic is
  begin
    return nor_reduce(std_logic_vector(i));
  end function;

  function xnor_reduce(i : signed) return std_logic is
  begin
    return xnor_reduce(std_logic_vector(i));
  end function;

  -- unsigned

  function and_reduce(i : unsigned) return std_logic is
  begin
    return and_reduce(std_logic_vector(i));
  end function;

  function or_reduce(i : unsigned) return std_logic is
  begin
    return or_reduce(std_logic_vector(i));
  end function;

  function xor_reduce(i : unsigned) return std_logic is
  begin
    return xor_reduce(std_logic_vector(i));
  end function;

  function nand_reduce(i : unsigned) return std_logic is
  begin
    return nand_reduce(std_logic_vector(i));
  end function;

  function nor_reduce(i : unsigned) return std_logic is
  begin
    return nor_reduce(std_logic_vector(i));
  end function;

  function xnor_reduce(i : unsigned) return std_logic is
  begin
    return xnor_reduce(std_logic_vector(i));
  end function;
  
end package body;
