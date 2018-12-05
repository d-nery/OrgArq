-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: write_back.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Estágio de memória de dados

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.types.all;

entity write_back is
    port (
        alu_res:   in word_t := (others => '0');
        dmem_data: in word_t := (others => '0');

        reg_write_data: out word_t := (others => '0');
        mux_src:        in  std_logic := '0'
    );
end entity write_back;

architecture write_back_arch of write_back is
begin
    M5: entity work.mux2 port map (
        in1    => alu_res,
        in2    => dmem_data,
        out1   => reg_write_data,
        choice => mux_src
    );
end architecture write_back_arch;
