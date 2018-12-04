-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: ex_mem_pipe.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Execute <-> Memory

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity ex_mem_pipe is
    port (
        clk: in std_logic;

        ex_branch_addr:  in  word_t;
        mem_branch_addr: out word_t;

        ex_jump_addr:  in  word_t;
        mem_jump_addr: out word_t;

        ex_ula_zero:  in  std_logic;
        mem_ula_zero: out std_logic;

        ex_ula_result:  in  std_logic;
        mem_ula_result: out std_logic;

        ex_reg_read2:  in  word_t;
        mem_reg_read2: out word_t;

        ex_reg_write_index:  in  nibble_t;
        mem_reg_write_index: out nibble_t
    );
end entity ex_mem_pipe;

architecture ex_mem_pipe_arch of ex_mem_pipe is

begin
    mem_branch_addr     <= ex_branch_addr;
    mem_jump_addr       <= ex_jump_addr;
    mem_ula_zero        <= ex_ula_zero;
    mem_ula_result      <= ex_ula_result;
    mem_reg_read2       <= ex_reg_read2;
    mem_reg_write_index <= ex_reg_write_index;
end architecture ex_mem_pipe_arch;
