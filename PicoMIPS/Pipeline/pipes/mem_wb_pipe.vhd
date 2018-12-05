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
        stall: in std_logic := '0';

        mem_dcache_data: in  word_t := (others => '0');
        wb_dcache_data:  out word_t := (others => '0');

        mem_ula_result: in  word_t := (others => '0');
        wb_ula_result:  out word_t := (others => '0');

        mem_reg_write_index: in  nibble_t := (others => '0');
        wb_reg_write_index:  out nibble_t := (others => '0');

        -- Control
        mem_reg_write: in  std_logic := '0';
        wb_reg_write:  out std_logic := '0';

        mem_reg_wr_src: in  std_logic := '0';
        wb_reg_wr_src:  out std_logic := '0'
    );
end entity mem_wb_pipe;

architecture mem_wb_pipe_arch of mem_wb_pipe is

begin
    process (clk)
    begin
        if rising_edge(clk) and (stall = '0') then
            wb_dcache_data     <= mem_dcache_data;
            wb_ula_result      <= mem_ula_result;
            wb_reg_write_index <= mem_reg_write_index;
            wb_reg_write       <= mem_reg_write;
            wb_reg_wr_src      <= mem_reg_wr_src;
        end if;
    end process;
end architecture mem_wb_pipe_arch;
