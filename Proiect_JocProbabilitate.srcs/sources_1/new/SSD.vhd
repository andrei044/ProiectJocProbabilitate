----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2022 09:30:21 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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

entity SSD is
Port ( 
signal clk:in std_logic;
signal date:in std_logic_vector(27 downto 0);
signal an:out std_logic_vector(3 downto 0);
signal cat:out std_logic_vector(6 downto 0)
);
end SSD;

architecture Behavioral of SSD is

signal counter:std_logic_vector(16 downto 0):=(others=>'0');
signal hexa:std_logic_vector(3 downto 0);

begin



process(clk)
begin
if clk='1' and clk'event then
    counter<=counter+1;
end if; 
end process;

process(counter,date)
begin
case counter(16 downto 14) is 
when "000"=> an<="0111";cat<=date(6 downto 0);
when "001"=>an<="1011";cat<=date(13 downto 7);
when "010"=>an<="1101";cat<=date(20 downto 14);
when others=>an<="1110";cat<=date(27 downto 21);
end case;
end process;

end Behavioral;
