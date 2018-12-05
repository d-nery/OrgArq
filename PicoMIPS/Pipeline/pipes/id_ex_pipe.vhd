-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: id_ex_pipe.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Instruction Decode <-> Execute

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.types.all;

entity id_ex_pipe is
    port (
        clk: in std_logic;

        id_pc4: in  word_t;
        ex_pc4: out word_t;

        id_reg_read1: in  word_t;
        ex_reg_read1: out word_t;

        id_reg_read2: in  word_t;
        ex_reg_read2: out word_t;

        id_immed_ext: in  word_t;
        ex_immed_ext: out word_t;

        id_jumpa: in  word_t;
        ex_jumpa: out word_t;

        id_rt: in  nibble_t;
        ex_rt: out nibble_t;

        id_rd: in  nibble_t;
        ex_rd: out nibble_t;

        id_shamt: in  std_logic_vector(04 downto 0);
        ex_shamt: out std_logic_vector(04 downto 0)

        -- Control signals
    );
end entity id_ex_pipe;

architecture id_ex_pipe_arch of id_ex_pipe is

begin
    ex_pc4       <= id_pc4;
    ex_reg_read1 <= id_reg_read1;
    ex_reg_read2 <= id_reg_read2;
    ex_immed_ext <= id_immed_ext;
    ex_jumpa     <= id_jumpa;
    ex_rt        <= id_rt;
    ex_rd        <= id_rd;
end architecture id_ex_pipe_arch;
