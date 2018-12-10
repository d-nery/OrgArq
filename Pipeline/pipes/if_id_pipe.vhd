-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: if_id_pipe.vhd
-- Author: Daniel Nery Silva de Oliveira
-- Collaboration: Beatriz de Oliveira Silva
-- Collaboration: Bruno Henrique Vasconcelos Lemos
-- Collaboration: João Raphael de Souza Morales
--
-- Description:
--     Instruction Fetch <-> Instruction Decode

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.types.all;

entity if_id_pipe is
    port (
        clk: in std_logic;
        stall: in std_logic := '0';

        if_pc4: in  word_t := (others => '0');
        id_pc4: out word_t := (others => '0');

        if_instruction: in  instruction_t;
        id_instruction: out instruction_t
    );
end entity if_id_pipe;

architecture if_id_pipe_arch of if_id_pipe is
begin
    signal_propagate: process (clk)
    begin
        if rising_edge(clk) and (stall = '0') then
            id_pc4 <= if_pc4;
            id_instruction <= if_instruction;
        end if;
    end process signal_propagate;
end architecture if_id_pipe_arch;
