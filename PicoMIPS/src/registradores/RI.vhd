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

        opcode:          out std_logic_vector(5 downto 0);
        field1:          out std_logic_vector(4 downto 0); -- Rs ou endereco
        field2:          out std_logic_vector(4 downto 0); -- Rt ou endereco
        field3:          out std_logic_vector(4 downto 0); -- Rd ou deslocamento | endereco
        field4:          out std_logic_vector(4 downto 0); -- Shamt ou deslocamento | endereco
        field5:          out std_logic_vector(5 downto 0)  -- Func ou deslocamento | endereco
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
    field1 <= instruction(25 downto 21);
    field2 <= instruction(20 downto 16);
    field3 <= instruction(15 downto 11);
    field4 <= instruction(10 downto 06);
    field5 <= instruction(05 downto 00);
end RI_arch;
