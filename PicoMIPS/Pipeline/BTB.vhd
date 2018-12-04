-- PCS3412 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File:MUL.vhd
-- Author: Beatriz de Oliveira Silva
--
-- Description:
--     Brach Target Buffer com estados
--     BTB

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


--library work;
--use work.constants.all;
--use work.types.all;

entity btb is
    port (
		clk : in std_logic;
        in_address: in  std_logic_vector(31 downto 0);
        out_address: out  std_logic_vector(31 downto 0);
		hit: out std_logic;
		erase: in std_logic;
		enable: in std_logic
    );
end entity btb;

architecture btb_arch of btb is
    
end architecture btb_arch;