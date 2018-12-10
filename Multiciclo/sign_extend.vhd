-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: sign_extend.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Extende 16 bits para 32 bits, considerando o sinal

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity sign_extend is
    generic (
        in_n: integer := 16
    );
    port (
        in1:  in  std_logic_vector(in_n - 1 downto 0);
        out1: out word_t
    );
end entity sign_extend;

architecture sign_extend_arch of sign_extend is
begin
    out1 <= std_logic_vector(resize(signed(in1), out1'length));
end architecture sign_extend_arch;
