-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: memory.vhd
-- Author: Daniel Nery Silva de Oliveira
-- Collaboration: Beatriz de Oliveira Silva
-- Collaboration: Bruno Henrique Vasconcelos Lemos
-- Collaboration: João Raphael de Souza Morales
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
        uc_enable: in  std_logic := '0';
        uc_write:  in  std_logic := '0';
        uc_addr:   in  word_t := (others => '0');
        uc_data_o: out word_t := (others => '0');
        uc_data_i: in  word_t := (others => '0');

        dc_stall: out std_logic := '0';

        -- From/To Memory
        mem_enable: out std_logic := '0';
        mem_write:  out std_logic := '0';
        mem_ready:  in  std_logic := '0';
        mem_addr:   out word_t := (others => '0');
        mem_data_o: out word_t := (others => '0');
        mem_data_i: in  word_t := (others => '0')
    );
end entity memory;

architecture memory_arch of memory is
    signal dc_ready:  std_logic := '0';
    signal dc_enable: std_logic := '0';
begin
    DCC: entity work.DC_Control port map (
        uc_address => uc_addr,

        uc_en   => uc_enable,
        dc_en   => dc_enable,
        dc_done => dc_ready,

        dc_stall => dc_stall
    );

    DCache: entity work.DCache port map (
        clk => clk,

        uc_enable => dc_enable,
        uc_write  => uc_write,
        uc_addr   => uc_addr,
        uc_ready  => dc_ready,
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
