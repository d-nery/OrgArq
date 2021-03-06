-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: PC.vhd
-- Author: Daniel Nery Silva de Oliveira
-- Collaboration: Beatriz de Oliveira Silva
-- Collaboration: Bruno Henrique Vasconcelos Lemos
-- Collaboration: João Raphael de Souza Morales
--
-- Description:
--     Contem o registrador contador de instrucoes (PC)
--     Aponta para o endereco da proxima instrucao a ser
--     executada e retorna.

library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.constants.all;
use work.types.all;

entity PC is
    generic (
        Tprop: in time := 2 ns
    );
    port (
        clk:             in  std_logic;
        new_address:     in  word_t := (others => '0');
        current_address: out word_t := (others => '0');

        reset: in std_logic := '0';
        wr:    in std_logic := '0'
    );
end entity PC;

architecture PC_arch of PC is
    signal address: word_t := (others => '0');
begin
    load_address: process (clk, reset)
    begin
        if reset = '1' then
            address <= (others => '0');
        elsif rising_edge(clk) and wr = '1' then
            address <= new_address;
        end if;
    end process load_address;

    current_address <= address after Tprop;
end architecture PC_arch;
