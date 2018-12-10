-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: ex_mem_pipe.vhd
-- Author: Daniel Nery Silva de Oliveira
-- Collaboration: Beatriz de Oliveira Silva
-- Collaboration: Bruno Henrique Vasconcelos Lemos
-- Collaboration: João Raphael de Souza Morales
--
-- Description:
--     Execute <-> Memory

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.types.all;

entity ex_mem_pipe is
    port (
        clk:   in std_logic;
        stall: in std_logic := '0';

        ex_branch_addr:  in  word_t := (others => '0');
        mem_branch_addr: out word_t := (others => '0');

        ex_jump_addr:  in  word_t := (others => '0');
        mem_jump_addr: out word_t := (others => '0');

        ex_ula_zero:  in  std_logic := '0';
        mem_ula_zero: out std_logic := '0';

        ex_ula_result:  in  word_t := (others => '0');
        mem_ula_result: out word_t := (others => '0');

        ex_reg_read2:  in  word_t := (others => '0');
        mem_reg_read2: out word_t := (others => '0');

        ex_reg_write_index:  in  nibble_t := (others => '0');
        mem_reg_write_index: out nibble_t := (others => '0');

        -- Control
        ex_branch:  in  std_logic := '0';
        mem_branch: out std_logic := '0';

        ex_jump:  in  std_logic := '1';
        mem_jump: out std_logic := '1';

        ex_reg_write:  in  std_logic := '0';
        mem_reg_write: out std_logic := '0';

        ex_dcache_wr:  in  std_logic := '0';
        mem_dcache_wr: out std_logic := '0';

        ex_dcache_en:  in  std_logic := '0';
        mem_dcache_en: out std_logic := '0';

        ex_reg_wr_src:  in  std_logic := '0';
        mem_reg_wr_src: out std_logic := '0'
    );
end entity ex_mem_pipe;

architecture ex_mem_pipe_arch of ex_mem_pipe is

begin
    process (clk)
    begin
        if rising_edge(clk) and (stall = '0') then
            mem_branch_addr     <= ex_branch_addr;
            mem_jump_addr       <= ex_jump_addr;
            mem_ula_zero        <= ex_ula_zero;
            mem_ula_result      <= ex_ula_result;
            mem_reg_read2       <= ex_reg_read2;
            mem_reg_write_index <= ex_reg_write_index;

            mem_branch     <= ex_branch;
            mem_jump       <= ex_jump;
            mem_reg_write  <= ex_reg_write;
            mem_dcache_wr  <= ex_dcache_wr;
            mem_dcache_en  <= ex_dcache_en;
            mem_reg_wr_src <= ex_reg_wr_src;
        end if;
    end process;
end architecture ex_mem_pipe_arch;
