-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: ri.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--

library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.constants.all;
use work.types.all;

entity RI is
    generic (
        Tprop: in time := 2 ns
    );
    port (
        clk:             in  std_logic;
        new_instruction: in  word_t := (others => '0');
        instruction:     out instruction_t
    );
end entity RI;

architecture RI_arch of RI is
begin
    instruction.opcode <= new_instruction(31 downto 26);
    instruction.Rs     <= new_instruction(25 downto 21);
    instruction.Rt     <= new_instruction(20 downto 16);
    instruction.Rd     <= new_instruction(15 downto 11);
    instruction.ShAmt  <= new_instruction(10 downto 06);
    instruction.funct  <= new_instruction(05 downto 00);
    instruction.immed  <= new_instruction(15 downto 00);
    instruction.jumpa  <= new_instruction(25 downto 00);
end architecture RI_arch;
