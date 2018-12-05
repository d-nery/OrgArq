-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File:ULA.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Unidade Logico-Aritimetica com 5 operações
--     ADD, SUB, AND, OR e SLT

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity ULA is
    generic (
        Tsoma: in time := 2 ns;
        Tsub:  in time := 2.5 ns;
        Tgate: in time := 1 ns
    );
    port (
        in1, in2: in  word_t := (others => '0');
        control:  in  nibble_t := (others => '0');

        result:   out word_t := (others => '0');
        zero:     out std_logic := '0'
    );
end entity ULA;

architecture ULA_arch of ULA is
begin
    ula_process: process (control, in1, in2)
    begin
        case control is
            when ULA_ADD =>
                result <= std_logic_vector(signed(in1) + signed(in2)) after Tsoma;
            when ULA_ADDU =>
                result <= std_logic_vector(unsigned(in1) + unsigned(in2)) after Tsoma;
            when ULA_SUB =>
                result <= std_logic_vector(signed(in1) - signed(in2)) after Tsub;
            when ULA_AND =>
                result <= in1 and in2 after Tgate;
            when ULA_OR =>
                result <= in1 or in2 after Tgate;
            when ULA_SLL =>
                result <= std_logic_vector(shift_left(signed(in2), to_integer(unsigned(in1)))) after Tgate;
            when ULA_SLT =>
                if in1 < in2 then
                    result <= x"00000001" after Tsoma;
                else
                    result <= x"00000000" after Tsoma;
                end if;
            when others =>
                    result <= (others => '0');
        end case;
    end process ula_process;

    process (result)
    begin
        zero <= '1' when result = x"00000000" else '0';
    end process;

end architecture ULA_arch;
