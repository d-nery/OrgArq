-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: PC.vhd
-- Author: Daniel Nery Silva de Oliveira
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
        new_address:     in  word_t;
        current_address: out word_t;

        reset: in std_logic;
        wr:    in std_logic
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
