-- PCS3412 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File:MUL.vhd
-- Author: Beatriz de Oliveira Silva
--
-- Description:
--     Dynamic Branch Prediction
--     DBP

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library STD;
use STD.textio.all;

--library work;
--use work.constants.all;
--use work.types.all;

entity dbp is
    port (
		clk : in std_logic;
		reset: in std_logic;
		taken_decis: in std_logic; -- se ocorreu branch no EX
        taken_prev: out std_logic -- preve se vai ocorrer de novo
    );
end entity dbp;

architecture dbp_arch of dbp is
	signal taken_decisi, taken_previ: std_logic;
	type State_type is (T1, T2 , NT1, NT2);
	signal taken_s: State_type; 
	
	begin
		taken_decisi <= taken_decis;
		taken_prev <= taken_previ;
		process (reset, clk)
		begin
		if reset = '0' then
			taken_s <= NT2;
		elsif (clk'event and clk = '1') then
			case taken_s is
				when NT2 => 
					taken_previ <= '0';
					if taken_decisi = '0'
						then taken_s <= NT1;
						else taken_s <= NT2;
					end if;
				when NT1 => 
					taken_previ <= '0';
					if taken_decisi = '0'
						then taken_s <= NT1;
						else taken_s <= T1;
					end if;
				when T1 => 
					taken_previ <= '1';
					if taken_decisi = '0'
						then taken_s <= NT2;
						else taken_s <= T2;
					end if;
				when T2 => 
					taken_previ <= '1';
					if taken_decisi = '0'
						then taken_s <= T1;
						else taken_s <= T2;
					end if;
			end case;
		end if;	
	end process;
end architecture dbp_arch;