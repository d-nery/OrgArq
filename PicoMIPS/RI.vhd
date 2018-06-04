-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: ri.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Contem o registrador de instrucoes (RI), que e composto
--     pelos 32 bits da instrucao que deve ser executada
--     RI = Mem(CI)

library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.constants.all;
use work.types.all;

entity RI is
    port (
        clk:             in  std_logic;
        new_instruction: in  word_t;
        instruction:     out instruction_t
    );
end entity RI;

architecture RI_arch of RI is
    signal instr: std_logic_vector(31 downto 0) := (others => '0');
begin
    load_instruction: process (clk)
    begin
        if rising_edge(clk) then
            instr <= new_instruction;
        end if;
    end process load_instruction;

    instruction.opcode <= instr(31 downto 26);
    instruction.Rs     <= instr(25 downto 21);
    instruction.Rt     <= instr(20 downto 16);
    instruction.Rd     <= instr(15 downto 11);
    instruction.ShAmt  <= instr(10 downto 06);
    instruction.funct  <= instr(05 downto 00);
    instruction.immed  <= instr(15 downto 00);
    instruction.jumpa  <= instr(25 downto 00);
end architecture RI_arch;
