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
    port (
        in1, in2: in  word_t;
        control:  in  nibble_t;

        result:   out word_t;
        zero:     out std_logic
    );
end entity ULA;

architecture ULA_arch of ULA is
    signal s_result: word_t;
begin
    s_result <= std_logic_vector(signed(in1)  +  signed(in2)) when control = ULA_ADD               else
                std_logic_vector(signed(in1)  -  signed(in2)) when control = ULA_SUB               else
                in1 and in2                                   when control = ULA_AND               else
                in1 or  in2                                   when control = ULA_OR                else
                x"00000001"                                   when control = ULA_SLT and in1 < in2 else
                x"00000000"                                   when control = ULA_SLT;

    zero   <= '1' when s_result = x"00000000" else '0';
    result <= s_result;
end architecture ULA_arch;
