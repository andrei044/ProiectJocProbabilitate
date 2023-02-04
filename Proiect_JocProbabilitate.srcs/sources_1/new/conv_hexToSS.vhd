----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2022 06:30:13 PM
-- Design Name: 
-- Module Name: conv_hexToSS - Behavioral
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity conv_hexToSS is
Port ( 
signal hexa:in std_logic_vector(3 downto 0);
signal SS:out std_logic_vector(6 downto 0)
);
end conv_hexToSS;

architecture Behavioral of conv_hexToSS is

begin

process(hexa)
begin
case hexa is
    when "0000" =>SS<="1000000";
    when "0001" =>SS<="1111001";
    when "0010" =>SS<="0100100";
    when "0011" =>SS<="0110000";
    when "0100" =>SS<="0011001";
    when "0101" =>SS<="0010010";
    when "0110" =>SS<="0000010";
    when "0111" =>SS<="1111000";
    when "1000" =>SS<="0000000";
    when "1001" =>SS<="0010000";
    when "1010" =>SS<="0000000";
    when "1011" =>SS<="0000000";
    when "1100" =>SS<="0000000";
    when "1101" =>SS<="0000000";
    when "1110" =>SS<="0000000";
    when others =>SS<="0000000";
end case;
end process;

end Behavioral;
