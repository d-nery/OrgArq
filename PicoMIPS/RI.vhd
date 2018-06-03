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

entity RI is
    port (
        clk:             in  std_logic;
        new_instruction: in  std_logic_vector(31 downto 0);

        opcode: out std_logic_vector(5 downto 0);
        Rs:     out std_logic_vector(4 downto 0);
        Rt:     out std_logic_vector(4 downto 0);
        Rd:     out std_logic_vector(4 downto 0);
        ShAmt:  out std_logic_vector(4 downto 0);
        funct:  out std_logic_vector(5 downto 0);
        immed:  out std_logic_vector(15 downto 0);
        jumpa:  out std_logic_vector(25 downto 0)
    );
end RI;

architecture RI_arch of RI is
    signal instruction: std_logic_vector(31 downto 0) := (others => '0');
begin
    load_instruction: process (clk)
    begin
        if rising_edge(clk) then
            instruction <= new_instruction;
        end if;
    end process load_instruction;

    opcode <= instruction(31 downto 26);
    Rs     <= instruction(25 downto 21);
    Rt     <= instruction(20 downto 16);
    Rd     <= instruction(15 downto 11);
    ShAmt  <= instruction(10 downto 06);
    funct  <= instruction(05 downto 00);
    immed  <= instruction(15 downto 00);
    jumpa  <= instruction(25 downto 00);
end RI_arch;
