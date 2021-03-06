----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2020 08:18:03 PM
-- Design Name: 
-- Module Name: tb_permutation_hash_init - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_permutation_parts is
--  Port ( );
end tb_permutation_parts;

architecture Behavioral of tb_permutation_parts is
    component ascon_xor
    port (
        state_in : in STD_LOGIC_VECTOR (319 downto 0);
        state_out : out STD_LOGIC_VECTOR (319 downto 0);
        round_number : in STD_LOGIC_VECTOR (3 downto 0)
    );
    end component;
    component ascon_sbox
    port (
        state_in : in STD_LOGIC_VECTOR (319 downto 0);
        state_out : out STD_LOGIC_VECTOR (319 downto 0)
    );
    end component;
    component ascon_linear
    port (
        state_in : in STD_LOGIC_VECTOR (319 downto 0);
        state_out : out STD_LOGIC_VECTOR (319 downto 0)
    );
    end component;
    signal clk: STD_LOGIC;
    signal state_in: STD_LOGIC_VECTOR (319 downto 0) := (others => '0');
    signal state_out_xor: STD_LOGIC_VECTOR (319 downto 0);
    signal state_out_sbox: STD_LOGIC_VECTOR (319 downto 0);
    signal state_out_linear: STD_LOGIC_VECTOR (319 downto 0);
    signal switch_ctr: UNSIGNED (3 downto 0) := (others => '0');
begin
    permutation_xor: ascon_xor
    port map(
        state_in => state_in,
        state_out => state_out_xor,
        round_number => "0001"
    );
    permutation_sbox: ascon_sbox
    port map(
        state_in => state_in,
        state_out => state_out_sbox
    );
    permutation_linear: ascon_linear
    port map(
        state_in => state_in,
        state_out => state_out_linear
    );
    
    clk_gen: process is
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;
    
    ctr_increment: process is
    begin
        wait until rising_edge(clk);
        switch_ctr <= switch_ctr+1;
    end process;
    
    make_iv: process is
    begin
        state_in (319 downto 256) <= x"00400c0000000000";
        wait until switch_ctr = 15;
        state_in (319 downto 256) <= x"00400c0000000100";
        wait until switch_ctr = 15;
    end process;

end Behavioral;
