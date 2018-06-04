-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: ICache.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Cache para Memoria de instrucoes

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity ICache is
    port (
        read_address: in  word_t;
        instruction:  out word_t
    );
end entity ICache;

architecture ICache_arch of ICache is
begin

end architecture ICache_arch;
