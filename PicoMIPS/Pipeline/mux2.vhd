-- PCS3422 - Organizacao e Arquitetura de Computadores II
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
        n:     in natural := 32;  -- Bits per choice
        Tsel:  in time    := 1.5 ns;
        Tdata: in time    := 0.5 ns
    );
    port (
        in1, in2: in std_logic_vector(n - 1 downto 0);
        out1:     out std_logic_vector(n - 1 downto 0);
        choice:   in std_logic
    );
end entity mux2;

architecture mux2_arch of mux2 is
begin
    multiplex: process (in1, in2, choice)
        variable t: time := 0 ns;
    begin
        if choice'event then
            t := Tsel;
        else
            t := Tdata;
        end if;
        out1 <= in1 after t when choice = '0' else in2 after t;
    end process;
end architecture mux2_arch;
