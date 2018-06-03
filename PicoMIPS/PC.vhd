-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: pc.vhd
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

entity PC is
    port (
        clk:             in  std_logic;
        new_address:     in  reg_t;
        current_address: out reg_t
    );
end PC;

architecture PC_arch of PC is
    signal address: reg_t := (others => '0');
begin
    load_address: process (clk)
    begin
        if rising_edge(clk) then
            address <= new_address;
        end if;
    end process load_address;

    current_address <= address;
end PC_arch;
