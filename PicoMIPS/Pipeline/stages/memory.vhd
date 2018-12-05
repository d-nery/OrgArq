-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: memory.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Estágio de memória de dados

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.types.all;

entity memory is
    port (
        clk:    in std_logic;

        -- From/To UC/FD
        uc_enable: in  std_logic;
        uc_write:  in  std_logic;
        uc_addr:   in  word_t;
        uc_ready:  out std_logic;
        uc_data_o: out word_t;
        uc_data_i: in  word_t;

        -- From/To Memory
        mem_enable: out std_logic;
        mem_write:  out std_logic;
        mem_ready:  in  std_logic;
        mem_addr:   out word_t;
        mem_data_o: out word_t;
        mem_data_i: in  word_t
    );
end entity memory;

architecture memory_arch of memory is

begin
    DCache: entity work.DCache port map (
        clk => clk,

        uc_enable => uc_enable,
        uc_write  => uc_write,
        uc_addr   => uc_addr,
        uc_ready  => uc_ready,
        uc_data_o => uc_data_o,
        uc_data_i => uc_data_i,

        mem_enable => mem_enable,
        mem_write  => mem_write,
        mem_ready  => mem_ready,
        mem_addr   => mem_addr,
        mem_data_o => mem_data_o,
        mem_data_i => mem_data_i
    );
end architecture memory_arch;
