-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File:ULA.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Unidade Logico-Aritimetica

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;

entity ULA is
    port (
        in1, in2: in  vec32_t;
        control:  in  std_logic_vector(3 downto 0);
        result:   out vec32_t;
        zero:     out std_logic
    );
end ULA;

architecture ULA_arch of ULA is
begin
    result <= std_logic_vector(unsigned(in1)  +  unsigned(in2)) when control = ULA_ADD                        else
              std_logic_vector(unsigned(in1)  -  unsigned(in2)) when control = ULA_SUB or control = ULA_SUBNE else
              in1 and in2                                       when control = ULA_AND                        else
              in1 or  in2                                       when control = ULA_OR                         else
              std_logic_vector(to_unsigned(1, 32))              when control = ULA_SLT and in1 < in2          else
              (others => '0')                                   when control = ULA_SLT;

    zero <= '1' when in1 /= in2 and control = ULA_SUBNE else
            '0' when in1 =  in2 and control = ULA_SUBNE else
            '1' when in1 =  in2                         else
            '0';

end ULA_arch;
