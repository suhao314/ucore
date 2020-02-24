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

library common;

entity Blowfish is
  generic (
    param_KEY_WIDTH : natural := 448
    );
  port (

    -- Clock & Reset
    RST_I : in std_logic;
    CLK_I : in std_logic;

    -- Key FIFO Interface
    KEY_EN_I   : in  std_logic;
    KEY_DATA_I : in  std_logic_vector(param_KEY_WIDTH-1 downto 0);
    KEY_FULL_O : out std_logic;

    -- Input Data FIFO Interface
    W_EN_I   : in  std_logic;
    W_ENC_I  : in  std_logic;
    W_DATA_I : in  std_logic_vector(63 downto 0);
    W_FULL_O : out std_logic;

    -- Output Data FIFO Interface
    R_EN_I    : in  std_logic;
    R_DATA_O  : out std_logic_vector(63 downto 0);
    R_EMPTY_O : out std_logic

    );
end entity;

architecture rtl of Blowfish is

  signal key_r_en    : std_logic;
  signal key_r_data  : std_logic_vector(447 downto 0);
  signal key_r_empty : std_logic;

  signal i_data_r_en    : std_logic;
  signal i_data_r_enc   : std_logic;
  signal i_data_r_data  : std_logic_vector(63 downto 0);
  signal i_data_r_empty : std_logic;

  signal o_data_w_en   : std_logic;
  signal o_data_w_full : std_logic;

  signal Pi_addr : std_logic_vector(9 downto 0);
  signal Pi_data : std_logic_vector(31 downto 0);

  signal P_enc      : std_logic;
  signal P_r_en     : std_logic;
  signal P_r_addr   : std_logic_vector(4 downto 0);
  signal P_r_data   : std_logic_vector(31 downto 0);
  signal p_w_en     : std_logic;
  signal p_w_addr   : std_logic_vector(4 downto 0);
  signal p_w_data_i : std_logic_vector(31 downto 0);

  signal S1_r_en     : std_logic;
  signal S1_r_addr   : std_logic_vector(7 downto 0);
  signal S1_r_data   : std_logic_vector(31 downto 0);
  signal S1_w_en     : std_logic;
  signal S1_w_addr   : std_logic_vector(7 downto 0);
  signal S1_w_data_i : std_logic_vector(31 downto 0);

  signal S2_r_en     : std_logic;
  signal S2_r_addr   : std_logic_vector(7 downto 0);
  signal S2_r_data   : std_logic_vector(31 downto 0);
  signal S2_w_en     : std_logic;
  signal S2_w_addr   : std_logic_vector(7 downto 0);
  signal S2_w_data_i : std_logic_vector(31 downto 0);

  signal S3_r_en     : std_logic;
  signal S3_r_addr   : std_logic_vector(7 downto 0);
  signal S3_r_data   : std_logic_vector(31 downto 0);
  signal S3_w_en     : std_logic;
  signal S3_w_addr   : std_logic_vector(7 downto 0);
  signal S3_w_data_i : std_logic_vector(31 downto 0);

  signal S4_r_en     : std_logic;
  signal S4_r_addr   : std_logic_vector(7 downto 0);
  signal S4_r_data   : std_logic_vector(31 downto 0);
  signal S4_w_en     : std_logic;
  signal S4_w_addr   : std_logic_vector(7 downto 0);
  signal S4_w_data_i : std_logic_vector(31 downto 0);

  signal cipher_en_i   : std_logic;
  signal cipher_data_i : std_logic_vector(63 downto 0);
  signal cipher_busy   : std_logic;
  signal cipher_en_o   : std_logic;
  signal cipher_data_o : std_logic_vector(63 downto 0);
  signal cipher_p_init : std_logic;
  
begin

  block_key : block is
    signal key_r_data_raw : std_logic_vector(KEY_DATA_I'range);
  begin

    u_key_FIFO : entity common.MiniFIFO
      generic map (
        param_DATA_WIDTH => param_KEY_WIDTH
        )
      port map (
        RST_I     => RST_I,
        CLK_I     => CLK_I,
        W_EN_I    => KEY_EN_I,
        W_DATA_I  => KEY_DATA_I,
        W_FULL_O  => KEY_FULL_O,
        R_EN_I    => key_r_en,
        R_DATA_O  => key_r_data_raw,
        R_EMPTY_O => key_r_empty
        );

    proc_key_r_data : process (key_r_data_raw) is
      variable j : natural;
    begin
      j := key_r_data_raw'high;
      for i in 447 downto 0 loop
        key_r_Data(i) <= key_r_data_raw(j);
        if j = 0 then
          j := key_r_data_raw'high;
        else
          j := j - 1;
        end if;
      end loop;
    end process;
    
  end block;

  u_i_data_FIFO : entity common.MiniFIFO
    generic map (
      param_DATA_WIDTH => 65
      )
    port map (
      RST_I                 => RST_I,
      CLK_I                 => CLK_I,
      W_EN_I                => W_EN_I,
      W_DATA_I(64)          => W_ENC_I,
      W_DATA_I(63 downto 0) => W_DATA_I,
      W_FULL_O              => W_FULL_O,
      R_EN_I                => i_data_r_en,
      R_DATA_O(64)          => i_data_r_enc,
      R_DATA_O(63 downto 0) => i_data_r_data,
      R_EMPTY_O             => i_data_r_empty
      );

  u_o_data_FIFO : entity common.MiniFIFO
    generic map (
      param_DATA_WIDTH => 64
      )
    port map (
      RST_I     => RST_I,
      CLK_I     => CLK_I,
      W_EN_I    => o_data_w_en,
      W_DATA_I  => cipher_data_o,
      W_FULL_O  => o_data_w_full,
      R_EN_I    => R_EN_I,
      R_DATA_O  => R_DATA_O,
      R_EMPTY_O => R_EMPTY_O
      );

  block_control : block is
    type state_t is (S_STARTUP, S_IDLE, S_CIPHER, S_KEY, S_KEY_PARRAY_INIT, S_KEY_SBOX_INIT,
                     S_KEY_PARRAY_CIPHER, S_KEY_PARRAY_WRITE_HIGH, S_KEY_PARRAY_WRITE_LOW,
                     S_KEY_SBOX_CIPHER, S_KEY_SBOX_WRITE_HIGH, S_KEY_SBOX_WRITE_LOW);
    signal state, next_state : state_t := S_IDLE;
    signal count, next_count : unsigned(9 downto 0);
    signal prev_P_enc        : std_logic;
  begin

    S1_w_addr <= std_logic_vector(count(7 downto 0));
    S2_w_addr <= std_logic_vector(count(7 downto 0));
    S3_w_addr <= std_logic_vector(count(7 downto 0));
    S4_w_addr <= std_logic_vector(count(7 downto 0));
    
    proc_next_state : process (P_enc, Pi_data, cipher_busy, cipher_data_o,
                               cipher_en_o, count, i_data_r_data,
                               i_data_r_empty, i_data_r_enc, key_r_data,
                               key_r_empty, next_count, o_data_w_full,
                               prev_P_enc, state) is
      subtype pcount_t is natural range 0 to 17;
      variable pcount : natural;
    begin

      key_r_en <= '0';

      i_data_r_en <= '0';
      o_data_w_en <= '0';

      Pi_addr <= std_logic_vector(next_count);

      P_enc      <= '1';
      p_w_en     <= '0';
      p_w_addr   <= std_logic_vector(count(4 downto 0));
      p_w_data_i <= (others => '-');

      S1_w_en     <= '0';
      S1_w_data_i <= Pi_data;

      S2_w_en     <= '0';
      S2_w_data_i <= Pi_data;

      S3_w_en     <= '0';
      S3_w_data_i <= Pi_data;

      S4_w_en     <= '0';
      S4_w_data_i <= Pi_data;

      cipher_en_i   <= '0';
      cipher_data_i <= i_data_r_data;
      cipher_p_init <= '0';

      next_state <= state;
      next_count <= count;

      case state is
        
        when S_IDLE =>
          P_enc <= i_data_r_enc;
          if prev_P_enc /= P_enc then
            cipher_p_init <= '1';
          elsif cipher_busy = '0' then
            if key_r_empty = '0' then
              next_state <= S_KEY;
            elsif i_data_r_empty = '0' and o_data_w_full = '0' then
              next_state <= S_CIPHER;
            end if;
          end if;

        when S_CIPHER =>
          P_enc <= i_data_r_enc;
          if cipher_en_o = '1' then
            i_data_r_en <= '1';
            o_data_w_en <= '1';
            next_state  <= S_IDLE;
          elsif cipher_busy = '0' then
            cipher_en_i <= '1';
          end if;

        when S_KEY =>
          next_state <= S_KEY_PARRAY_INIT;
          next_count <= (others => '0');

        when S_KEY_PARRAY_INIT =>
          p_w_en     <= '1';
          pcount     := to_integer(count(4 downto 0));
          next_count <= count + 1;
          case pcount is
            when 0      => p_w_data_i <= x"243f6a88" xor key_r_data(447 downto 416);
            when 1      => p_w_data_i <= x"85a308d3" xor key_r_data(415 downto 384);
            when 2      => p_w_data_i <= x"13198a2e" xor key_r_data(383 downto 352);
            when 3      => p_w_data_i <= x"03707344" xor key_r_data(351 downto 320);
            when 4      => p_w_data_i <= x"a4093822" xor key_r_data(319 downto 288);
            when 5      => p_w_data_i <= x"299f31d0" xor key_r_data(287 downto 256);
            when 6      => p_w_data_i <= x"082efa98" xor key_r_data(255 downto 224);
            when 7      => p_w_data_i <= x"ec4e6c89" xor key_r_data(223 downto 192);
            when 8      => p_w_data_i <= x"452821e6" xor key_r_data(191 downto 160);
            when 9      => p_w_data_i <= x"38d01377" xor key_r_data(159 downto 128);
            when 10     => p_w_data_i <= x"be5466cf" xor key_r_data(127 downto 96);
            when 11     => p_w_data_i <= x"34e90c6c" xor key_r_data(95 downto 64);
            when 12     => p_w_data_i <= x"c0ac29b7" xor key_r_data(63 downto 32);
            when 13     => p_w_data_i <= x"c97c50dd" xor key_r_data(31 downto 0);
            when 14     => p_w_data_i <= x"3f84d5b5" xor key_r_data(447 downto 416);
            when 15     => p_w_data_i <= x"b5470917" xor key_r_data(415 downto 384);
            when 16     => p_w_data_i <= x"9216d5d9" xor key_r_data(383 downto 352);
            when others => p_w_data_i <= x"8979fb1b" xor key_r_data(351 downto 320);
                           cipher_p_init <= '1';
                           next_state    <= S_KEY_SBOX_INIT;
                           next_count    <= (others => '0');
          end case;
          
        when S_KEY_SBOX_INIT =>
          S1_w_en <= not count(9) and not count(8);
          S2_w_en <= not count(9) and count(8);
          S3_w_en <= count(9) and not count(8);
          S4_w_en <= count(9) and count(8);
          if count = 1023 then
            next_state <= S_KEY_PARRAY_CIPHER;
          end if;
          next_count <= count + 1;

        when S_KEY_PARRAY_CIPHER =>
          if cipher_busy = '0' then
            cipher_en_i <= '1';
            if count = 0 then
              cipher_data_i <= (others => '0');
            else
              cipher_data_i <= cipher_data_o;
            end if;
            next_state <= S_KEY_PARRAY_WRITE_HIGH;
          end if;

        when S_KEY_PARRAY_WRITE_HIGH =>
          if cipher_en_o = '1' then
            p_w_en     <= '1';
            p_w_data_i <= cipher_data_o(63 downto 32);
            next_state <= S_KEY_PARRAY_WRITE_LOW;
            next_count <= count + 1;
          end if;

        when S_KEY_PARRAY_WRITE_LOW =>
          p_w_en        <= '1';
          p_w_data_i    <= cipher_data_o(31 downto 0);
          next_state    <= S_KEY_PARRAY_CIPHER;
          next_count    <= count + 1;
          cipher_p_init <= '1';
          if count = 17 then
            next_state <= S_KEY_SBOX_CIPHER;
            next_count <= (others => '0');
          end if;

        when S_KEY_SBOX_CIPHER =>
          if cipher_busy = '0' then
            cipher_en_i   <= '1';
            cipher_data_i <= cipher_data_o;
            next_state    <= S_KEY_SBOX_WRITE_HIGH;
          end if;
          
        when S_KEY_SBOX_WRITE_HIGH =>
          if cipher_en_o = '1' then
            S1_w_en     <= not count(9) and not count(8);
            S2_w_en     <= not count(9) and count(8);
            S3_w_en     <= count(9) and not count(8);
            S4_w_en     <= count(9) and count(8);
            S1_w_data_i <= cipher_data_o(63 downto 32);
            S2_w_data_i <= cipher_data_o(63 downto 32);
            S3_w_data_i <= cipher_data_o(63 downto 32);
            S4_w_data_i <= cipher_data_o(63 downto 32);
            next_state  <= S_KEY_SBOX_WRITE_LOW;
            next_count  <= count + 1;
          end if;

        when S_KEY_SBOX_WRITE_LOW =>
          S1_w_en     <= not count(9) and not count(8);
          S2_w_en     <= not count(9) and count(8);
          S3_w_en     <= count(9) and not count(8);
          S4_w_en     <= count(9) and count(8);
          S1_w_data_i <= cipher_data_o(31 downto 0);
          S2_w_data_i <= cipher_data_o(31 downto 0);
          S3_w_data_i <= cipher_data_o(31 downto 0);
          S4_w_data_i <= cipher_data_o(31 downto 0);
          next_state  <= S_KEY_SBOX_CIPHER;
          next_count  <= count + 1;
          if count = 1023 then
            key_r_en   <= '1';
            P_enc      <= i_data_r_enc;
            next_state <= S_IDLE;
          end if;
          
        when others =>
          next_state <= S_IDLE;
          
      end case;
    end process;

    proc_state : process (CLK_I) is
    begin
      if rising_edge(CLK_I) then
        state      <= next_state;
        count      <= next_count;
        prev_P_enc <= P_enc;
        if RST_I = '1' then
          state <= S_IDLE;
        end if;
      end if;
    end process;
    
  end block;

  u_BlowfishPiROM : entity work.BlowfishPiROM
    port map (
      CLK_I  => CLK_I,
      ADDR_I => Pi_addr,
      DATA_O => Pi_data
      );

  u_BlowfishPArray : entity work.BlowfishPArray
    port map (
      CLK_I    => CLK_I,
      ENC_I    => P_enc,
      R_EN_I   => P_r_en,
      R_ADDR_I => P_r_addr,
      R_DATA_O => P_r_data,
      W_EN_I   => p_w_en,
      W_ADDR_I => p_w_addr,
      W_DATA_I => p_w_data_i
      );

  u_BlowfishSBox1 : entity work.BlowfishSBox
    port map (
      CLK_I    => CLK_I,
      R_EN_I   => S1_r_en,
      R_ADDR_I => S1_r_addr,
      R_DATA_O => S1_r_data,
      W_EN_I   => S1_w_en,
      W_ADDR_I => S1_w_addr,
      W_DATA_I => S1_w_data_i
      );

  u_BlowfishSBox2 : entity work.BlowfishSBox
    port map (
      CLK_I    => CLK_I,
      R_EN_I   => S2_r_en,
      R_ADDR_I => S2_r_addr,
      R_DATA_O => S2_r_data,
      W_EN_I   => S2_w_en,
      W_ADDR_I => S2_w_addr,
      W_DATA_I => S2_w_data_i
      );

  u_BlowfishSBox3 : entity work.BlowfishSBox
    port map (
      CLK_I    => CLK_I,
      R_EN_I   => S3_r_en,
      R_ADDR_I => S3_r_addr,
      R_DATA_O => S3_r_data,
      W_EN_I   => S3_w_en,
      W_ADDR_I => S3_w_addr,
      W_DATA_I => S3_w_data_i
      );

  u_BlowfishSBox4 : entity work.BlowfishSBox
    port map (
      CLK_I    => CLK_I,
      R_EN_I   => S4_r_en,
      R_ADDR_I => S4_r_addr,
      R_DATA_O => S4_r_data,
      W_EN_I   => S4_w_en,
      W_ADDR_I => S4_w_addr,
      W_DATA_I => S4_w_data_i
      );

  u_BlowfishCipher : entity work.BlowfishCipher
    port map (
      RST_I     => RST_I,
      CLK_I     => CLK_I,
      EN_I      => cipher_en_i,
      DATA_I    => cipher_data_i,
      BUSY_O    => cipher_busy,
      EN_O      => cipher_en_o,
      DATA_O    => cipher_data_o,
      P_INIT_I  => cipher_p_init,
      P_EN_O    => P_r_en,
      P_ADDR_O  => P_r_addr,
      P_DATA_I  => P_r_data,
      S1_EN_O   => S1_r_en,
      S1_ADDR_O => S1_r_addr,
      S1_DATA_I => S1_r_data,
      S2_EN_O   => S2_r_en,
      S2_ADDR_O => S2_r_addr,
      S2_DATA_I => S2_r_data,
      S3_EN_O   => S3_r_en,
      S3_ADDR_O => S3_r_addr,
      S3_DATA_I => S3_r_data,
      S4_EN_O   => S4_r_en,
      S4_ADDR_O => S4_r_addr,
      S4_DATA_I => S4_r_data
      );

end architecture rtl;
