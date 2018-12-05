-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: register_bank.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Contem os registradores de uso geral e registradores
--     especificos do projeto
--     0  -> zero
--     1- 11 -> Uso geral
--     12 -> $gp
--     13 -> $sp
--     14 -> $fp
--     15 -> $ra

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
        reg_write:   in  std_logic := '0';

        write_index: in  nibble_t := (others => '0');

        read_index1: in  nibble_t := (others => '0');
        read_index2: in  nibble_t := (others => '0');

        write_data:  in  word_t := (others => '0');

        read_data1:  out word_t := (others => '0');
        read_data2:  out word_t := (others => '0')
    );
end entity register_bank;

architecture register_bank_arch of register_bank is
    type reg_array is array(0 to 15) of word_t;
    signal registers: reg_array := (
        x"00000000", -- zero
        x"00000000", -- Geral 1
        x"00000000", -- Geral 2
        x"00000000", -- Geral 3
        x"00000000", -- Geral 4
        x"00000000", -- Geral 5
        x"00000000", -- Geral 6
        x"00000000", -- Geral 7
        x"00000000", -- Geral 8
        x"00000000", -- Geral 9
        x"00000000", -- Geral 10
        x"00000000", -- Geral 11
        x"00000200", -- $gp
        x"FFFFFFFF", -- $sp
        x"FFFFFFFF", -- $fp
        x"00000000"  -- $ra
    );

    -- Internal signals mapped to actual registers for
    -- debugging purposes
    signal s_r0 : word_t;
    signal s_r1 : word_t;
    signal s_r2 : word_t;
    signal s_r3 : word_t;
    signal s_r4 : word_t;
    signal s_r5 : word_t;
    signal s_r6 : word_t;
    signal s_r7 : word_t;
    signal s_r8 : word_t;
    signal s_r9 : word_t;
    signal s_r10: word_t;
    signal s_r11: word_t;
    signal s_gp : word_t;
    signal s_sp : word_t;
    signal s_fp : word_t;
    signal s_ra : word_t;
begin
    sync_write: process (clk)
    begin
        if (rising_edge(clk)) then
            if reg_write = '1' and write_index /= "0000" then
                registers(to_integer(unsigned(write_index))) <= write_data after Twrite;
            end if;
        end if;
    end process sync_write;

    r1: process (clk, registers, read_index1)
    begin
        read_data1 <= registers(to_integer(unsigned(read_index1))) after Tread;
    end process r1;

    r2: process (clk, registers, read_index2)
    begin
        read_data2 <= registers(to_integer(unsigned(read_index2))) after Tread;
    end process r2;

    s_r0  <= registers(0);
    s_r1  <= registers(1);
    s_r2  <= registers(2);
    s_r3  <= registers(3);
    s_r4  <= registers(4);
    s_r5  <= registers(5);
    s_r6  <= registers(6);
    s_r7  <= registers(7);
    s_r8  <= registers(8);
    s_r9  <= registers(9);
    s_r10 <= registers(10);
    s_r11 <= registers(11);
    s_gp  <= registers(12);
    s_sp  <= registers(13);
    s_fp  <= registers(14);
    s_ra  <= registers(15);
end architecture register_bank_arch;
