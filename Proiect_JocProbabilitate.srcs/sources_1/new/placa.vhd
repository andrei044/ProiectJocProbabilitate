----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2022 08:52:48 PM
-- Design Name: 
-- Module Name: nexys4 - Behavioral
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

entity placa is
Port (
signal clk:in std_logic;
signal btn:in std_logic_vector(4 downto 0);--0 mijloc,1 up,2 left,3right 4 down
signal sw:in std_logic_vector(15 downto 0);
signal led:out std_logic_vector(15 downto 0);
signal cat:out std_logic_vector(6 downto 0);
signal an:out std_logic_vector(3 downto 0)
 );
end placa;

architecture Behavioral of placa is

signal btn_rst_filtrat:std_logic;
signal btn_up_filtrat:std_logic;
signal btn_down_filtrat:std_logic;
signal btn_move_filtrat:std_logic;
signal btn_right_filtrat:std_logic;
signal btn_left_filtrat:std_logic;
signal full:std_logic;
signal full_all: std_logic;
signal sansa:std_logic_vector(6 downto 0);
signal scor:std_logic_vector(7 downto 0);
signal linie:std_logic_vector(3 downto 0);
signal nr_generat:std_logic_vector(3 downto 0);
signal date:std_logic_vector(27 downto 0);

begin

filtru_left: entity WORK.MPG port map(
    btn=>btn(2),
    clk=>clk,
    rez=>btn_left_filtrat
);

filtru_move: entity WORK.MPG port map(
    btn=>btn(0),
    clk=>clk,
    rez=>btn_move_filtrat
);

filtru_rst: entity WORK.MPG port map(
    btn=>btn(1),
    clk=>clk,
    rez=>btn_rst_filtrat
);

filtru_down: entity WORK.MPG port map(
    btn=>btn(4),
    clk=>clk,
    rez=>btn_down_filtrat
);

filtru_right: entity WORK.MPG port map(
    btn=>btn(3),
    clk=>clk,
    rez=>btn_right_filtrat
);

generator_random: entity WORK.generator_random port map(
    clk=>clk,
    rst=>btn_rst_filtrat,
    rezultat=>nr_generat
);

leduri: entity WORK.linie_led port map(
    clk=>clk,
    rst=>btn_rst_filtrat,
    btn_start=>btn_move_filtrat,
    btn_down=>btn_down_filtrat,
    btn_move=>btn_move_filtrat,
    nr_generat=>nr_generat,
    full=>full,
    full_all=>full_all,
    sansa=>sansa,
    scor=>scor,
    linie=>linie,
    led=>led
);

SSD03: entity WORK.SDD_0to3 port map(
    clk=>clk,
    rst=>btn_rst_filtrat,
    btn_start=>btn_move_filtrat,
    btn_next=>btn_left_filtrat,
    sansa=>sansa,
    full=>full,
    full_all=>full_all,
    linie=>linie,
    scor=>scor,
    date=>date
);

SSD: entity WORK.SSD port map(
    clk=>clk,
    date=>date,
    an=>an,
    cat=>cat
);

end Behavioral;
