-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: mux3.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Multiplexador de tres entradas

library IEEE;
use IEEE.std_logic_1164.all;

entity mux3 is
    generic (
        n: natural := 1  -- Bits per choice
    );

    port (
        in1, in2, in3: in std_logic_vector(n - 1 downto 0);
        out1: out std_logic_vector(n - 1 downto 0);
        choice: in std_logic_vector(1 downto 0)
    );
end entity mux3;

architecture mux3_arch of mux3 is
begin
    out1 <= in1 when choice = "00" else
            in2 when choice = "01" else
            in3;
end architecture mux3_arch;
