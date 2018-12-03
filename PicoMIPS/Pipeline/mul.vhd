-- PCS3412 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File:MUL.vhd
-- Author: Beatriz de Oliveira Silva
--
-- Description:
--     Unidade de Multiplicacao com 3 ciclos de clock
--     MUL

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--library work;
--use work.constants.all;
--use work.types.all;

entity mul is
    port (
		clk : in std_logic;
        in1, in2: in  std_logic_vector(31 downto 0);
        result:   out std_logic_vector(63 downto 0)
    );
end entity mul;

architecture mul_arch of mul is
signal i: integer := 0;
signal in1_p, in2_p, partial: std_logic_vector(31 downto 0) := (others =>'0');
signal result_p, temp1, temp2: std_logic_vector(63 downto 0) := (others =>'0');

begin

	partial(0) <= '1';
	in1_p <= in1;
	in2_p <= in2;
	result <= result_p;

	--process for calcultation of the equation.
	process(clk)
	begin
		if(rising_edge(clk)) then
		--Implement the 3 stages pipeline multiplication
			for i in 0 to 2 loop 
				case i is 
					when 0 => temp1 <= std_logic_vector(signed(in1_p)*signed(partial));
					when 1 => temp2 <= std_logic_vector(signed(temp1)*signed(in2_p));
					when 2 => result_p <= std_logic_vector(signed(temp2)*signed(partial));
					when others => null;
				end case;
			end loop; 
		end if; 
	end process;
  
	--process (result) 
	--begin
	--	zero <= '1' when result = x"00000000" else '0';
	--end process;	

end architecture mul_arch;