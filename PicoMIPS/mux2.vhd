-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: mux2.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Multiplexador de duas entradas

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2 is
    generic (
        n: natural := 1  -- Bits per choice
    );
    port (
        in1, in2: in std_logic_vector(n - 1 downto 0);
        out1: out std_logic_vector(n - 1 downto 0);
        choice: in std_logic
    );
end entity mux2;

architecture mux2_arch of mux2 is
begin
    out1 <= in1 when choice = '0' else in2;
end architecture mux2_arch;
