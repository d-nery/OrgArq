-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: mem_wb_pipe.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Memory <-> Write Back

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.types.all;

entity mem_wb_pipe is
    port (
        clk: in std_logic;

        mem_dcache_data: in  word_t;
        wb_dcache_data:  out word_t;

        mem_ula_result: in  word_t;
        wb_ula_result:  out word_t;

        mem_reg_write_index: in  nibble_t;
        wb_reg_write_index:  out nibble_t
    );
end entity mem_wb_pipe;

architecture mem_wb_pipe_arch of mem_wb_pipe is

begin
    wb_dcache_data     <= mem_dcache_data;
    wb_ula_result      <= mem_ula_result;
    wb_reg_write_index <= mem_reg_write_index;
end architecture mem_wb_pipe_arch;
