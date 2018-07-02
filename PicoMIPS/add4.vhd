-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: add4.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     -Somador fixo em 4 unidades

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity add4 is
    port (
        in1:  in  word_t;
        out1: out word_t
    );
end entity add4;

architecture add4_arch of add4 is
begin
    out1 <= std_logic_vector(unsigned(in1) + 4);
end architecture add4_arch;
