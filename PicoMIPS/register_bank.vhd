-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: register_bank.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Contem os registradores de uso geral e registradores
--     especificos do projeto
--     0 - 3 -> Uso geral
--     4 -> $gp
--     5 -> $sp
--     6 -> $fp
--     7 -> $ra

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity register_bank is
    port (
        clk:         in  std_logic;
        is_write:    in  std_logic;

        write_index: in  nibble_t;

        read_index1: in  nibble_t;
        read_index2: in  nibble_t;

        write_data:  in  word_t;

        read_data1:  out word_t;
        read_data2:  out word_t
    );
end entity register_bank;

architecture register_bank_arch of register_bank is
    type reg_array is array(0 to 7) of word_t;
    signal registers: reg_array := (others => (others => '0'));
begin
    sync_write: process (clk)
    begin
        if (rising_edge(clk) and is_write = '1') then
            registers(to_integer(unsigned(write_index))) <= write_data;
        end if;
    end process sync_write;

    read_data1 <= registers(to_integer(unsigned(read_index1)));
    read_data2 <= registers(to_integer(unsigned(read_index2)));
end architecture register_bank_arch;
