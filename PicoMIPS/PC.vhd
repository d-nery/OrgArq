-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: PC.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Contem o registrador contador de instrucoes (PC)
--     Aponta para o endereco a proxima instrucao a ser
--     executada e retorna.

library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.constants.all;
use work.types.all;

entity PC is
    port (
        clk:             in  std_logic;
        new_address:     in  word_t;
        current_address: out word_t
    );
end entity PC;

architecture PC_arch of PC is
    signal address: word_t := (others => '0');
begin
    load_address: process (clk)
    begin
        if rising_edge(clk) then
            address <= new_address;
        end if;
    end process load_address;

    current_address <= address;
end architecture PC_arch;
