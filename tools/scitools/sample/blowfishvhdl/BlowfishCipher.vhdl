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

entity BlowfishCipher is
  port (

    -- Clock & Reset
    RST_I : in std_logic;
    CLK_I : in std_logic;

    -- Input Data Interface
    EN_I   : in  std_logic;
    DATA_I : in  std_logic_vector(63 downto 0);
    BUSY_O : out std_logic;

    -- Output Data Interface
    EN_O   : out std_logic;
    DATA_O : out std_logic_vector(63 downto 0);

    -- P-Array Interface
    P_INIT_I : in  std_logic;
    P_EN_O   : out std_logic;
    P_ADDR_O : out std_logic_vector(4 downto 0);
    P_DATA_I : in  std_logic_vector(31 downto 0);

    -- S-Box Interface
    S1_EN_O   : out std_logic;
    S1_ADDR_O : out std_logic_vector(7 downto 0);
    S1_DATA_I : in  std_logic_vector(31 downto 0);

    -- S-Box Interface
    S2_EN_O   : out std_logic;
    S2_ADDR_O : out std_logic_vector(7 downto 0);
    S2_DATA_I : in  std_logic_vector(31 downto 0);

    -- S-Box Interface
    S3_EN_O   : out std_logic;
    S3_ADDR_O : out std_logic_vector(7 downto 0);
    S3_DATA_I : in  std_logic_vector(31 downto 0);

    -- S-Box Interface
    S4_EN_O   : out std_logic;
    S4_ADDR_O : out std_logic_vector(7 downto 0);
    S4_DATA_I : in  std_logic_vector(31 downto 0)

    );
end entity;

--                                       (For 4 rounds instead of 16)
-- CLK  ___/~~~\___/~~~\___/~~~\___/~~~\___/~~~\___/~~~\___/~~~\___/~~~\___/~~~\___/~~~\___/~~~\___
-- EN_I ____/~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\______________________________________
-- DATI ====<     DATA0     X             DATA1             >======================================
-- BUSY ~~~~~~~~~~~~\_______/~~~~~~~~~~~~~~~~~~~~~~~\_______/~~~~~~~~~~~~~~~~~~~~~~~\______________
-- EN_O ____________________________________________/~~~~~~~\_______________________/~~~~~~~\______
-- REN  ____________/~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\______________
-- R#   ============<   0   X   1   X   2   X   3   X   0   X   1   X   2   X   3   >==============
-- RDI  ============< DATA0 X DA0R0 X DA0R1 X DA0R2 X DATA1 X DA1R0 X DA1R1 X DA1R2 X DA1R3 >======
-- RDO  ====================< DA0R0 X DA0R1 X DA0R2 X DA0R3 X DA1R0 X DA1R1 X DA1R2 X DA1R3 >======
-- DATO ============================================< DA0PX >=======================< DA1PX >======
-- PAA  

architecture rtl of BlowfishCipher is

  signal next_round_en               : std_logic;
  signal round_data, next_round_data : std_logic_vector(63 downto 0);

  signal p16 : std_logic_vector(31 downto 0);
  signal p17 : std_logic_vector(31 downto 0);

  signal en : std_logic;
  
begin

  block_control : block is
    type state_t is (S_INIT, S_INIT_P16, S_INIT_P17, S_INIT_WAIT, S_IDLE, S_CIPHER);
    signal state, next_state : state_t := S_INIT;
    signal round, next_round : unsigned(3 downto 0);
  begin
    
    proc_next_state : process (DATA_I, EN_I, P_INIT_I, next_round, round,
                               round_data, state) is
    begin
      en              <= '0';
      BUSY_O          <= '0';
      P_EN_O          <= '0';
      P_ADDR_O        <= std_logic_vector(resize(unsigned(next_round), P_ADDR_O'length) + 1);
      next_round      <= (others => '0');
      next_round_en   <= '0';
      next_round_data <= round_data;
      next_state      <= state;

      case state is

        when S_INIT =>
          BUSY_O     <= '1';
          P_EN_O     <= '1';
          P_ADDR_O   <= "10000";
          next_state <= S_INIT_P16;

        when S_INIT_P16 =>
          BUSY_O     <= '1';
          P_EN_O     <= '1';
          P_ADDR_O   <= "10001";
          next_state <= S_INIT_P17;

        when S_INIT_P17 =>
          BUSY_O     <= '1';
          P_EN_O     <= '1';
          P_ADDR_O   <= (others => '0');
          next_state <= S_INIT_WAIT;

        when S_INIT_WAIT =>
          BUSY_O <= '1';
          if P_INIT_I = '0' then
            next_state <= S_IDLE;
          end if;

        when S_IDLE =>
          if P_INIT_I = '1' then
            next_state <= S_INIT;
          elsif EN_I = '1' then
            P_EN_O          <= '1';
            next_round_en   <= '1';
            next_round_data <= DATA_I;
            next_state      <= S_CIPHER;
          end if;
          
        when S_CIPHER =>
          BUSY_O        <= '1';
          P_EN_O        <= '1';
          next_round    <= round + 1;
          next_round_en <= '1';
          if next_round = 15 then
            P_ADDR_O <= (others => '0');
          elsif round = 15 then
            BUSY_O        <= '0';
            P_EN_O        <= '0';
            en            <= '1';
            next_round_en <= '0';
            next_state    <= S_IDLE;
            if P_INIT_I = '1' then
              next_state <= S_INIT;
            elsif EN_I = '1' then
              P_EN_O          <= '1';
              next_round_en   <= '1';
              next_round_data <= DATA_I;
              next_round      <= (others => '0');
              next_state      <= S_CIPHER;
            end if;
          end if;

        when others =>
          next_state <= S_INIT;
          
      end case;
    end process;

    proc_state : process (CLK_I) is
    begin
      if (rising_edge(CLK_I)) then
        state <= next_state;
        round <= next_round;
        if state = S_INIT_P16 then
          p16 <= P_DATA_I;
        end if;
        if state = S_INIT_P17 then
          p17 <= P_DATA_I;
        end if;
        if RST_I = '1' then
          state <= S_INIT;
        end if;
      end if;
    end process;
    
  end block;

  u_BlowfishRound : entity work.BlowfishRound
    port map (
      CLK_I     => CLK_I,
      EN_I      => next_round_en,
      DATA_I    => next_round_data,
      DATA_O    => round_data,
      P_DATA_I  => P_DATA_I,
      S1_EN_O   => S1_EN_O,
      S1_ADDR_O => S1_ADDR_O,
      S1_DATA_I => S1_DATA_I,
      S2_EN_O   => S2_EN_O,
      S2_ADDR_O => S2_ADDR_O,
      S2_DATA_I => S2_DATA_I,
      S3_EN_O   => S3_EN_O,
      S3_ADDR_O => S3_ADDR_O,
      S3_DATA_I => S3_DATA_I,
      S4_EN_O   => S4_EN_O,
      S4_ADDR_O => S4_ADDR_O,
      S4_DATA_I => S4_DATA_I
      );

  block_DATA_O : block is
    signal prev_data, data : std_logic_vector(63 downto 0);
  begin

    data <= (round_data(31 downto 0) & round_data(63 downto 32)) xor (p17 & p16);

    proc_prev_data : process (CLK_I) is
    begin
      if rising_edge(CLK_I) then
        if en = '1' then
          prev_data <= data;
        end if;
      end if;
    end process;

    EN_O   <= en;
    DATA_O <= data when en = '1' else prev_data;
    
  end block;

end architecture rtl;
