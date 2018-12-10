-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: pkgTypes.vhd
-- Author: Daniel Nery Silva de Oliveira
-- Collaboration: Beatriz de Oliveira Silva
-- Collaboration: Bruno Henrique Vasconcelos Lemos
-- Collaboration: João Raphael de Souza Morales
--
-- Description:
--     Define tipos especificos para o projeto

library IEEE;
use IEEE.std_logic_1164.all;

package types is
    subtype word_t     is std_logic_vector(31 downto 0);
    subtype halfword_t is std_logic_vector(15 downto 0);
    subtype byte_t     is std_logic_vector(07 downto 0);
    subtype nibble_t   is std_logic_vector(03 downto 0);

    -- 2**14 palavras de 32 bits
    type memory_t is array(0 to 2**14 - 1) of word_t;

    type instruction_t is record
        opcode: std_logic_vector(05 downto 00);
        Rs:     std_logic_vector(04 downto 00);
        Rt:     std_logic_vector(04 downto 00);
        Rd:     std_logic_vector(04 downto 00);
        ShAmt:  std_logic_vector(04 downto 00);
        funct:  std_logic_vector(05 downto 00);
        immed:  std_logic_vector(15 downto 00);
        jumpa:  std_logic_vector(25 downto 00);
    end record instruction_t;
end package types;
