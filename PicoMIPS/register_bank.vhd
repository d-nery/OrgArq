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
    generic (
        Tread:  in time := 5 ns;
        Twrite: in time := 5 ns
    );
    port (
        clk:         in  std_logic;
        reg_write:   in  std_logic;

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
    signal registers: reg_array := (
        x"00000000", -- Geral 0
        x"00000000", -- Geral 1
        x"00000000", -- Geral 2
        x"00000000", -- Geral 3
        x"00000200", -- $gp
        x"FFFFFFFF", -- $sp
        x"FFFFFFFF", -- $fp
        x"00000000"  -- $ra
    );

    signal r1: nibble_t := (others => '0');
    signal r2: nibble_t := (others => '0');

    -- Internal signals mapped to actual registers for
    -- debugging purposes
    signal s_r0 : word_t;
    signal s_r1 : word_t;
    signal s_r2 : word_t;
    signal s_r3 : word_t;
    signal s_gp : word_t;
    signal s_sp : word_t;
    signal s_fp : word_t;
    signal s_ra : word_t;
begin
    sync_write: process (clk)
    begin
        if (rising_edge(clk)) then
            if (reg_write = '1') then
                registers(to_integer(unsigned(write_index))) <= write_data after Twrite;
            end if;

            r1 <= read_index1;
            r2 <= read_index2;
        end if;
    end process sync_write;

    read_data1 <= registers(to_integer(unsigned(r1))) after Tread;
    read_data2 <= registers(to_integer(unsigned(r2))) after Tread;

    s_r0 <= registers(0);
    s_r1 <= registers(1);
    s_r2 <= registers(2);
    s_r3 <= registers(3);
    s_gp <= registers(4);
    s_sp <= registers(5);
    s_fp <= registers(6);
    s_ra <= registers(7);
end architecture register_bank_arch;
