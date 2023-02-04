----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2022 09:11:24 PM
-- Design Name: 
-- Module Name: SDD_0to3 - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SDD_0to3 is
Port (

signal clk:in std_logic;
signal rst:in std_logic;
signal btn_start:in std_logic;
signal btn_next:in std_logic;
signal sansa:in std_logic_vector(6 downto 0);
signal full:in std_logic;
signal full_all:in std_logic;
signal linie:in std_logic_vector(3 downto 0);
signal scor:in std_logic_vector(7 downto 0);
signal date:out std_logic_vector(27 downto 0)
);
end SDD_0to3;

architecture Behavioral of SDD_0to3 is

signal inr:integer:=0;
signal icifraz:integer:=0;
signal icifrau:integer:=0;

signal cifraz:std_logic_vector(3 downto 0):="0000";
signal cifrau:std_logic_vector(3 downto 0):="0000";

signal SScifraz:std_logic_vector(6 downto 0):="0000000";
signal SScifrau:std_logic_vector(6 downto 0):="0000000";

type stari is(idle,sanse,stare_linie,scor_linie_curenta,afis_scor,afis_linie,stop);

signal stare_curenta:stari:=idle;
signal stare_urmatoare:stari:=idle;

signal numara:integer:=0;

signal iscor_semn:integer;
signal iscor:integer:=0;
signal icifra1:integer:=0;
signal icifra2:integer:=0;
signal icifra3:integer:=0;
signal icifra4:integer:=0;
signal cifra1:std_logic_vector(3 downto 0):="0000";
signal cifra2:std_logic_vector(3 downto 0):="0000";
signal cifra3:std_logic_vector(3 downto 0):="0000";
signal cifra4:std_logic_vector(3 downto 0):="0000";

signal SScifra1:std_logic_vector(6 downto 0):="0000000";
signal SScifra2:std_logic_vector(6 downto 0):="0000000";
signal SScifra3:std_logic_vector(6 downto 0):="0000000";
signal SScifra4:std_logic_vector(6 downto 0):="0000000";

signal SSlinie:std_logic_vector(6 downto 0):="0000000";

signal counter:integer:=0;
signal semnal_divizat:std_logic:='0';

begin

convertor_hex_to_SS5: entity WORK.conv_hexToSS port map(
    hexa=>cifraz,
    SS=>SScifraz
);

convertor_hex_to_SS6: entity WORK.conv_hexToSS port map(
    hexa=>cifrau,
    SS=>SScifrau
);

convertor_hex_to_SS1: entity WORK.conv_hexToSS port map(
    hexa=>cifra1,
    SS=>SScifra1
);

convertor_hex_to_SS2: entity WORK.conv_hexToSS port map(
    hexa=>cifra2,
    SS=>SScifra2
);

convertor_hex_to_SS3: entity WORK.conv_hexToSS port map(
    hexa=>cifra3,
    SS=>SScifra3
);

convertor_hex_to_SS4: entity WORK.conv_hexToSS port map(
    hexa=>cifra4,
    SS=>SScifra4
);

convertor_hex_to_SSlinie: entity WORK.conv_hexToSS port map(
    hexa=>linie,
    SS=>SSlinie
);

process (clk,rst)
begin
if rst='1' then
stare_curenta<=idle;
elsif rising_edge(clk) then
    stare_curenta<=stare_urmatoare;
end if;
end process;

process (stare_curenta,btn_start,sansa,full,linie,btn_next,full_all)
begin

case stare_curenta is
when idle=> if full_all='0' then
                if(btn_start='1')then
                    stare_urmatoare<=sanse;
                else
                    stare_urmatoare<=idle;
                end if;
            else
                stare_urmatoare<=stop;
            end if;
when sanse=>if full_all='0' then 
                if(btn_next='1')then
                    stare_urmatoare<=stare_linie;
                 else
                    stare_urmatoare<=sanse;
                 end if;
             else
                stare_urmatoare<=stop;
            end if;
when stare_linie=>if full_all='0' then 
                     if(btn_next='1')then
                        stare_urmatoare<=scor_linie_curenta;
                     else
                        stare_urmatoare<=stare_linie;
                     end if;
                else
                stare_urmatoare<=stop;
            end if;
when scor_linie_curenta=>if full_all='0' then 
                if(btn_next='1')then
                stare_urmatoare<=afis_scor;
             else
                stare_urmatoare<=scor_linie_curenta;
             end if;
             else
                stare_urmatoare<=stop;
            end if;
when afis_scor=>if full_all='0' then 
                if(btn_next='1')then
                stare_urmatoare<=afis_linie;
             else
                stare_urmatoare<=afis_scor;
             end if;
             else
                --if semnal_divizat='1' then
                    stare_urmatoare<=stop;
                --else
                    --stare_urmatoare<=afis_scor;
                --end if;
            end if;
when afis_linie=>if full_all='0' then  
                    if btn_next='1' then
                    stare_urmatoare<=sanse;
                   else
                    stare_urmatoare<=afis_linie;
                    end if;
                else
                stare_urmatoare<=stop;
            end if;
when others=>   --if semnal_divizat='1' then
                    --stare_urmatoare<=afis_scor;
                --else
                    stare_urmatoare<=stop;
             --end if;
end case;
end process;

process(clk)
begin
if rising_edge(clk) then
    if stare_curenta=idle then
        date(6 downto 0)<="1111001";
        date(13 downto 7)<="0100001";
        date(20 downto 14)<="1000111";
        date(27 downto 21)<="0000110"; 
    end if;
    if stare_curenta=sanse then
        date(6 downto 0)<="1000000";
        date(13 downto 7)<="1000000";
        date(20 downto 14)<=SScifraz;
        date(27 downto 21)<=SScifrau; 
    end if;
    if stare_curenta=stare_linie then
         if(full='1')then --FULL
            date(6 downto 0)<="0001110";
            date(13 downto 7)<="1000001";
            date(20 downto 14)<="1000111";
            date(27 downto 21)<="1000111";
        else--FREE
            date(6 downto 0)<="0001110";
            date(13 downto 7)<="0101111";
            date(20 downto 14)<="0000110";
            date(27 downto 21)<="0000110";
        end if; 
    end if;
    if stare_curenta=scor_linie_curenta then
        case linie is
             when "000"=>   date(6 downto 0)<="1000000";
                            date(13 downto 7)<="1000000";
                            date(20 downto 14)<="1000000";
                            date(27 downto 21)<="0010010";
             when "001"=>   date(6 downto 0)<="1000000";
                            date(13 downto 7)<="1000000";
                            date(20 downto 14)<="1000000";
                            date(27 downto 21)<="0100100";
             when "010"=>   date(6 downto 0)<="1000000";
                            date(13 downto 7)<="1000000";
                            date(20 downto 14)<="1000000";
                            date(27 downto 21)<="1111001";
             when "011"=>   date(6 downto 0)<="1000000";
                            date(13 downto 7)<="1000000";
                            date(20 downto 14)<="0111111";
                            date(27 downto 21)<="0110000";
             when others=>  date(6 downto 0)<="1000000";
                            date(13 downto 7)<="1000000";
                            date(20 downto 14)<="0111111";
                            date(27 downto 21)<="0011001";          
        end case;
    end if;
    if stare_curenta=afis_scor then
         date(13 downto 7)<=SScifra3;
         date(20 downto 14)<=SScifra2;
         date(27 downto 21)<=SScifra1;
         if(iscor_semn>=0)then
            date(6 downto 0)<=SScifra4;
         else
            date(6 downto 0)<="0111111";
         end if;
    end if;
    if stare_curenta=afis_linie then
        date(6 downto 0)<="1000000";
        date(13 downto 7)<="1000000";
        date(20 downto 14)<="1000000";
        date(27 downto 21)<=SSlinie;
    end if;
    if stare_curenta=stop then
        if semnal_divizat='1' then
        date(6 downto 0)<="0100001";
            date(13 downto 7)<="1000000";
             date(20 downto 14)<="1001000";
             date(27 downto 21)<="0000110";
        else
            date(13 downto 7)<=SScifra3;
         date(20 downto 14)<=SScifra2;
         date(27 downto 21)<=SScifra1;
         if(iscor_semn>=0)then
            date(6 downto 0)<=SScifra4;
         else
            date(6 downto 0)<="0111111";
         end if;
        end if;
    end if;
end if;

end process;


process(clk,rst)
begin

if rst='1' then
counter<=0;
elsif clk'event and clk='1' then
    if counter<99999999 then
        counter<=counter+1;
    else
        counter<=0;
        semnal_divizat<=not(semnal_divizat);
    end if;
end if;
end process;


inr<=(conv_integer(unsigned(sansa))*100)/15;
icifraz<=inr/10;
icifrau<=inr mod 10;
cifraz<=conv_std_logic_vector(icifraz,4);
cifrau<=conv_std_logic_vector(icifrau,4);

iscor_semn<=conv_integer(signed(scor));
iscor<=abs(conv_integer(signed(scor)));
icifra1<=iscor mod 10;
icifra2<=(iscor/10) mod 10;
icifra3<=(iscor/100)mod 10;
icifra4<=iscor/1000;
cifra1<=conv_std_logic_vector(icifra1,4);
cifra2<=conv_std_logic_vector(icifra2,4);
cifra3<=conv_std_logic_vector(icifra3,4);
cifra4<=conv_std_logic_vector(icifra4,4);

end Behavioral;
