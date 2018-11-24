-- PCS3412 - Organizacao e Arquitetura de Computadores I
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
        in1, in2: in  word_t;
        control:  in  nibble_t;

        result:   out word_t;
        zero:     out std_logic
    );
end entity ULA;

architecture ULA_arch of ULA is
begin
    result <= std_logic_vector(signed(in1)   + signed(in2))   after Tsoma when control = ULA_ADD               else
              std_logic_vector(unsigned(in1) + unsigned(in2)) after Tsub  when control = ULA_ADDU              else
              std_logic_vector(signed(in1)   - signed(in2))   after Tsub  when control = ULA_SUB               else
              in1 and in2                                     after Tgate when control = ULA_AND               else
              in1 or  in2                                     after Tgate when control = ULA_OR                else
              std_logic_vector(shift_left(
                  signed(in2), to_integer(unsigned(in1))))    after Tgate when control = ULA_SLL               else
              x"00000001"                                     after Tsoma when control = ULA_SLT and in1 < in2 else
              x"00000000"                                     after Tsoma when control = ULA_SLT;

    zero   <= '1' after Tsoma when result = x"00000000" else '0' after Tsoma;
end architecture ULA_arch;
