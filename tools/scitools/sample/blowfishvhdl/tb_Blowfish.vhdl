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

entity tb_Blowfish is
end entity;

architecture tb of tb_Blowfish is

  signal TB_DONE : boolean;

  constant param_KEY_WIDTH : natural := 64;

  signal RST_I      : std_logic;
  signal CLK_I      : std_logic;
  signal KEY_EN_I   : std_logic;
  signal KEY_DATA_I : std_logic_vector(param_KEY_WIDTH-1 downto 0);
  signal KEY_FULL_O : std_logic;
  signal W_EN_I     : std_logic;
  signal W_ENC_I    : std_logic;
  signal W_DATA_I   : std_logic_vector(63 downto 0);
  signal W_FULL_O   : std_logic;
  signal R_EN_I     : std_logic;
  signal R_DATA_O   : std_logic_vector(63 downto 0);
  signal R_EMPTY_O  : std_logic;
  
begin

  proc_clock : process is
  begin
    CLK_I <= '1';
    wait for 10.0 ns;
    CLK_I <= '0';
    wait for 10.0 ns;
    if TB_DONE then
      wait;
    end if;
  end process;

  proc_clear : process is
  begin
    RST_I <= '1';
    wait for 342 ns;
    wait until rising_edge(CLK_I);
    RST_I <= '0';
    wait;
  end process;

  proc_master : process is
    type test_vector_t is array (0 to 2) of std_logic_vector(63 downto 0);
    type test_vectors_t is array (natural range <>) of test_vector_t;
    variable test_vectors : test_vectors_t(0 to 33) := (
      (x"0000000000000000", x"0000000000000000", x"4EF997456198DD78"),
      (x"FFFFFFFFFFFFFFFF", x"FFFFFFFFFFFFFFFF", x"51866FD5B85ECB8A"),
      (x"3000000000000000", x"1000000000000001", x"7D856F9A613063F2"),
      (x"1111111111111111", x"1111111111111111", x"2466DD878B963C9D"),
      (x"0123456789ABCDEF", x"1111111111111111", x"61F9C3802281B096"),
      (x"1111111111111111", x"0123456789ABCDEF", x"7D0CC630AFDA1EC7"),
      (x"0000000000000000", x"0000000000000000", x"4EF997456198DD78"),
      (x"FEDCBA9876543210", x"0123456789ABCDEF", x"0ACEAB0FC6A0A28D"),
      (x"7CA110454A1A6E57", x"01A1D6D039776742", x"59C68245EB05282B"),
      (x"0131D9619DC1376E", x"5CD54CA83DEF57DA", x"B1B8CC0B250F09A0"),
      (x"07A1133E4A0B2686", x"0248D43806F67172", x"1730E5778BEA1DA4"),
      (x"3849674C2602319E", x"51454B582DDF440A", x"A25E7856CF2651EB"),
      (x"04B915BA43FEB5B6", x"42FD443059577FA2", x"353882B109CE8F1A"),
      (x"0113B970FD34F2CE", x"059B5E0851CF143A", x"48F4D0884C379918"),
      (x"0170F175468FB5E6", x"0756D8E0774761D2", x"432193B78951FC98"),
      (x"43297FAD38E373FE", x"762514B829BF486A", x"13F04154D69D1AE5"),
      (x"07A7137045DA2A16", x"3BDD119049372802", x"2EEDDA93FFD39C79"),
      (x"04689104C2FD3B2F", x"26955F6835AF609A", x"D887E0393C2DA6E3"),
      (x"37D06BB516CB7546", x"164D5E404F275232", x"5F99D04F5B163969"),
      (x"1F08260D1AC2465E", x"6B056E18759F5CCA", x"4A057A3B24D3977B"),
      (x"584023641ABA6176", x"004BD6EF09176062", x"452031C1E4FADA8E"),
      (x"025816164629B007", x"480D39006EE762F2", x"7555AE39F59B87BD"),
      (x"49793EBC79B3258F", x"437540C8698F3CFA", x"53C55F9CB49FC019"),
      (x"4FB05E1515AB73A7", x"072D43A077075292", x"7A8E7BFA937E89A3"),
      (x"49E95D6D4CA229BF", x"02FE55778117F12A", x"CF9C5D7A4986ADB5"),
      (x"018310DC409B26D6", x"1D9D5C5018F728C2", x"D1ABB290658BC778"),
      (x"1C587F1C13924FEF", x"305532286D6F295A", x"55CB3774D13EF201"),
      (x"0101010101010101", x"0123456789ABCDEF", x"FA34EC4847B268B2"),
      (x"1F1F1F1F0E0E0E0E", x"0123456789ABCDEF", x"A790795108EA3CAE"),
      (x"E0FEE0FEF1FEF1FE", x"0123456789ABCDEF", x"C39E072D9FAC631D"),
      (x"0000000000000000", x"FFFFFFFFFFFFFFFF", x"014933E0CDAFF6E4"),
      (x"FFFFFFFFFFFFFFFF", x"0000000000000000", x"F21E9A77B71C49BC"),
      (x"0123456789ABCDEF", x"0000000000000000", x"245946885754369A"),
      (x"FEDCBA9876543210", x"FFFFFFFFFFFFFFFF", x"6B5C5A9C5D9E0A5A")
      );
    variable data : std_logic_vector(63 downto 0);
  begin
    TB_DONE    <= false;
    KEY_EN_I   <= '0';
    KEY_DATA_I <= (others => '0');
    W_EN_I     <= '0';
    W_ENC_I    <= '1';
    W_DATA_I   <= (others => '0');
    R_EN_I     <= '0';
    wait until rising_edge(CLK_I) and RST_I = '0';
    report "TEST: official test vectors" severity note;
    for t in test_vectors'range loop
      wait until rising_edge(CLK_I) and KEY_FULL_O = '0';
      report "  ." severity note;
      KEY_EN_I   <= '1';
      KEY_DATA_I <= test_vectors(t)(0);
      wait until rising_edge(CLK_I);
      KEY_EN_I   <= '0';
      wait until rising_edge(CLK_I) and W_FULL_O = '0';
      W_EN_I     <= '1';
      W_ENC_I    <= '1';
      W_DATA_I   <= test_vectors(t)(1);
      wait until rising_edge(CLK_I);
      W_EN_I     <= '0';
      wait until rising_edge(CLK_I) and R_EMPTY_O = '0';
      assert R_DATA_O = test_vectors(t)(2) report "  FAIL: data mismatch" severity failure;
      R_EN_I     <= '1';
      wait until rising_edge(CLK_I);
      wait until rising_edge(CLK_I);
      wait until rising_edge(CLK_I);
    end loop;
    report "  DONE" severity note;
    report "TEST: encrypt -> decrypt loopback" severity note;
    for t in test_vectors'range loop
      wait until rising_edge(CLK_I) and KEY_FULL_O = '0';
      report "  ." severity note;
      KEY_EN_I   <= '1';
      KEY_DATA_I <= test_vectors(t)(0);
      wait until rising_edge(CLK_I);
      KEY_EN_I   <= '0';
      for i in 1 to 1024 loop
        wait until rising_edge(CLK_I) and W_FULL_O = '0';
        W_EN_I   <= '1';
        W_ENC_I  <= '1';
        data     := std_logic_vector(unsigned(test_vectors(t)(1)) + 17*i);
        W_DATA_I <= data;
        wait until rising_edge(CLK_I);
        W_EN_I   <= '0';
        wait until rising_edge(CLK_I) and R_EMPTY_O = '0' and W_FULL_O = '0';
        W_EN_I   <= '1';
        R_EN_I   <= '1';
        W_ENC_I  <= '0';
        W_DATA_I <= R_DATA_O;
        wait until rising_edge(CLK_I);
        W_EN_I   <= '0';
        R_EN_I   <= '0';
        wait until rising_edge(CLK_I) and R_EMPTY_O = '0';
        assert R_DATA_O = data report "  FAIL: data mismatch" severity failure;
        R_EN_I   <= '1';
        wait until rising_edge(CLK_I);
        R_EN_I   <= '0';
        wait until rising_edge(CLK_I);
      end loop;
      wait until rising_edge(CLK_I);
      wait until rising_edge(CLK_I);
      wait until rising_edge(CLK_I);
    end loop;
    report "  DONE" severity note;
    wait until rising_edge(CLK_I);
    wait until rising_edge(CLK_I);
    wait until rising_edge(CLK_I);
    wait until rising_edge(CLK_I);
    TB_DONE <= true;
    wait;
  end process;

  u_Blowfish : entity work.Blowfish
    generic map (
      param_KEY_WIDTH => param_KEY_WIDTH
      )
    port map (
      RST_I      => RST_I,
      CLK_I      => CLK_I,
      KEY_EN_I   => KEY_EN_I,
      KEY_DATA_I => KEY_DATA_I,
      KEY_FULL_O => KEY_FULL_O,
      W_EN_I     => W_EN_I,
      W_ENC_I    => W_ENC_I,
      W_DATA_I   => W_DATA_I,
      W_FULL_O   => W_FULL_O,
      R_EN_I     => R_EN_I,
      R_DATA_O   => R_DATA_O,
      R_EMPTY_O  => R_EMPTY_O
      );

end architecture;
