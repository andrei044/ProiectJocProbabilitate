----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2022 08:55:29 PM
-- Design Name: 
-- Module Name: generator_random - Behavioral
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

entity generator_random is
Port (
signal clk:in std_logic;
signal rst:in std_logic;
signal rezultat:out std_logic_vector(3 downto 0)
 );
end generator_random;

architecture Behavioral of generator_random is

signal num1:std_logic_vector(3 downto 0):="0000";
signal num2:std_logic_vector(3 downto 0):="1111";
signal num3:std_logic_vector(3 downto 0):="0000";

signal counter:integer:=0;
signal semnal_divizat:std_logic:='0';
begin

process(clk,rst)
begin

if rst='1' then
counter<=0;
elsif clk'event and clk='1' then
    if counter<15000000 then      --49999999  => 0,49 s
        counter<=counter+1;
    else
        counter<=0;
        semnal_divizat<=not(semnal_divizat);
    end if;
end if;
end process;

process(semnal_divizat,rst)
begin
if(rst='1') then
    num1<=(others=>'0');
    num2<=(others=>'1');
    num3<=(others=>'0');
elsif semnal_divizat='1' and semnal_divizat'event then
    num1<=num1+1;
    num2<=num2-1;
    num3<=num3+2;
end if;
end process;
rezultat<=(num1 xor num3);
end Behavioral;
