----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2022 07:54:02 PM
-- Design Name: 
-- Module Name: linie_led - Behavioral
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

entity linie_led is
Port (
signal clk:in std_logic;
signal rst:in std_logic;
signal btn_start:in std_logic;
signal btn_down:in std_logic;
signal btn_move:in std_logic;
signal nr_generat:in std_logic_vector(3 downto 0);
signal full:out std_logic;
signal full_all:out std_logic;
signal sansa:out std_logic_vector(6 downto 0);
signal scor:out std_logic_vector(7 downto 0);
signal linie:out std_logic_vector(3 downto 0);
signal led:out std_logic_vector(15 downto 0)

 );
end linie_led;

architecture Behavioral of linie_led is

type stari is(idle,activ,inc_linie,modif_vect,schimb_linie);

type matrice is array(4 downto 0) of std_logic_vector(16 downto 0);
signal m:matrice:=(
0=>"00000000000000001",
1=>"00000000000000001",
2=>"00000000000000001",
3=>"00000000000000001",
4=>"00000000000000001"
);

type int_array is array(0 to 4)of integer;

signal stare_curenta:stari:=idle;
signal stare_urmatoare:stari:=idle;

signal full_curent:std_logic:='0';
signal scor_linie:int_array:=(5,2,1,3,4);
signal ultima_poz:int_array:=(others=>-1);
signal sansa_curenta:std_logic_vector(6 downto 0):="1001011";
signal sansa_4biti:std_logic_vector(3 downto 0):="1011";
signal scor_curent:std_logic_vector(7 downto 0):="00000000";
signal iscor:integer:=0;
signal linie_curenta:std_logic_vector(3 downto 0):="0000";
signal ilinie_curenta:integer:=0;
signal led_curent:std_logic_vector(15 downto 0):=m(0)(15 downto 0);

begin


process (clk,rst)
begin
if rst='1' then

stare_curenta<=idle;
elsif rising_edge(clk) then
    stare_curenta<=stare_urmatoare;
end if;
end process;

--process pt stari
process(stare_curenta,btn_start,btn_move,btn_down,ilinie_curenta,ultima_poz)
begin
case stare_curenta is
when idle=> if(btn_start='1')then
                stare_urmatoare<=activ;
            else
                stare_urmatoare<=idle;
            end if;
when activ=>
            if btn_move='1' then
                if ultima_poz(ilinie_curenta)<15 then
                    stare_urmatoare<=inc_linie;
                else
                    stare_urmatoare<=activ;
                    end if;   
            elsif btn_down='1' then
                stare_urmatoare<=schimb_linie;
            else stare_urmatoare<=activ;
            end if;
when inc_linie=>stare_urmatoare<=modif_vect;
when modif_vect=>stare_urmatoare<=activ;
when others=> stare_urmatoare<=activ;
              
end case;
end process;

--process pt operatii pe stari
process(stare_curenta)
begin
case stare_curenta is
when idle=> led_curent<="1111111111111111";
            
when activ=>led_curent<=m(ilinie_curenta)(15 downto 0);       
when inc_linie=>
when modif_vect=>
when others=>
end case;
end process;

process(clk)
begin
if clk='1' and clk'event then
    if stare_curenta=idle then
            m(0)<="00000000000000001";
            m(1)<="00000000000000001";
            m(2)<="00000000000000001";
            m(3)<="00000000000000001";
            m(4)<="00000000000000001";
            sansa_4biti<="1011";
            ultima_poz<=(others=>-1);
            iscor<=0;
            linie_curenta<=(others=>'0');
            full_all<='0';
    end if;
    if stare_curenta=activ then
        if m(ilinie_curenta)(16)='0' then
                full_curent<='0';
            else
                full_curent<='1';
            end if;
        if (((m(0)(16)='1' and m(1)(16)='1') and m(2)(16)='1')and m(3)(16)='1')and m(4)(16)='1' then
            full_all<='1';
        else
            full_all<='0';
        end if;
    end if;
    if stare_curenta=inc_linie then
        ultima_poz(ilinie_curenta)<=ultima_poz(ilinie_curenta)+1;
        
        
        
    end if;
    if stare_curenta=modif_vect then
        if(ilinie_curenta<=2) then
            if(nr_generat<sansa_4biti)then
                m(ilinie_curenta)(ultima_poz(ilinie_curenta))<='1';
                iscor<=iscor+scor_linie(ilinie_curenta);
                if(sansa_4biti>2)then
                    sansa_4biti<=sansa_4biti-1;
                end if;
            else
                if(sansa_4biti<12)then
                    sansa_4biti<=sansa_4biti+1;
                end if;
                m(ilinie_curenta)(ultima_poz(ilinie_curenta))<='0';
                iscor<=iscor-scor_linie(ilinie_curenta);
            end if;
        else
            if(nr_generat>sansa_4biti)then
                m(ilinie_curenta)(ultima_poz(ilinie_curenta))<='1';
                if(sansa_4biti<12)then
                    sansa_4biti<=sansa_4biti+1;
                end if;
                iscor<=iscor-scor_linie(ilinie_curenta);
            else
                if(sansa_4biti>2)then
                    sansa_4biti<=sansa_4biti-1;
                end if;
                m(ilinie_curenta)(ultima_poz(ilinie_curenta))<='0';
                iscor<=iscor+scor_linie(ilinie_curenta);
            end if;
        end if;
        m(ilinie_curenta)(ultima_poz(ilinie_curenta)+1)<='1';
    end if;
    if stare_curenta=schimb_linie then
     if ilinie_curenta<4 then
            linie_curenta<=linie_curenta+1;
        else
            linie_curenta<="0000";
        end if;
    end if;
end if;
end process;

ilinie_curenta<=conv_integer(linie_curenta);
sansa<="000" & sansa_4biti;
scor<=conv_std_logic_vector(iscor,8);
linie<=conv_std_logic_vector(ilinie_curenta,4);
full<=full_curent;
led<=led_curent;

end Behavioral;
