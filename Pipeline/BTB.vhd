-- PCS3412 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File:MUL.vhd
-- Author: Beatriz de Oliveira Silva
--
-- Description:
--     Brach Target Buffer com estados
--     BTB

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
 
--library work;
--use work.constants.all;
--use work.types.all;

entity btb is
    port (
		clk : in std_logic;
		reset: in std_logic;
        in_address: in  std_logic_vector(31 downto 0);
		target_address: inout std_logic_vector(31 downto 0);
		hit: out std_logic;
		erase: in std_logic;
		enable: in std_logic
    );
end entity btb;



architecture btb_arch of btb is

    type entry_t is record -- Cache entries
        in_address: std_logic_vector(31 downto 0);
		target_address: std_logic_vector(31 downto 0);
		taken: std_logic;
    end record entry_t;
	
	type matrix_t is array (0 to 50, 0 to 2) of entry_t; 


begin

	process(reset)
			variable j : integer range 0 to 2 := 0;
			variable i : integer range 0 to 50 := 0;
			variable matrix : matrix_t;
			variable ret: matrix_t;
	begin
		if reset = '0' then

			for i in matrix'range(1) loop 
				for j in matrix'range(2) loop 
					ret (i,j) := (in_address => "00000000000000000000000000000000",
                                  target_address => "00000000000000000000000000000000",
                                  taken => '0');
				end loop; 
			end loop; 
		else
			if enable='1' then
				ret (i, j) := (in_address => in_address,
                                  target_address => target_address,
                                  taken => '1');
			elsif erase='1' then
				ret (i, j) := (in_address => "00000000000000000000000000000000",
                                  target_address => "00000000000000000000000000000000",
                                  taken => '0');
			else	
				if in_address = ret(i, j).in_address then
					hit <= '1';
					target_address <= ret(i, j).target_address;
				else
					hit <= '0';
					target_address <= ret(i, j).target_address;
				end if; 
			end if;
			i := i +1;
			j := j + 1;
		end if;

	end process;
	
end architecture btb_arch;