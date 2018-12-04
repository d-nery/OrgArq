-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: if_id_pipe.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Instruction Fetch <-> Instruction Decode

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity if_id_pipe is
    port (
        clk: in std_logic;

        if_pc4: in  word_t;
        id_pc4: out word_t;

        if_instruction: in  instruction_t;
        id_instruction: out instruction_t
    );
end entity if_id_pipe;

architecture if_id_pipe_arch of if_id_pipe is
begin
    id_pc4 <= if_pc4;
    id_instruction <= if_instruction;
end architecture if_id_pipe_arch;
