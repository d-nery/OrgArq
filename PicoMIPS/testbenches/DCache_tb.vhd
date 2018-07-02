-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: DCache_tb.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Testbench para o Cache de Dados

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity DCache_tb is
end entity DCache_tb;

architecture DCache_tb_arch of DCache_tb is
    signal address: word_t := (others => '0');

    signal mem_ready:  std_logic;
    signal mem_write:  std_logic;
    signal mem_enable: std_logic;
    signal mem_addr:   word_t;
    signal mem_data_i: word_t;
    signal mem_data_o: word_t;

    signal clk: std_logic := '0';
    signal uc_ready:  std_logic;
    signal uc_write:  std_logic;
    signal uc_enable: std_logic := '0';
    signal uc_data_i: word_t;
    signal uc_data_o: word_t;
begin
    cache: entity work.DCache port map (
        clk => clk,

        uc_enable => uc_enable,

        uc_write  => uc_write,
        uc_addr   => address,
        uc_ready  => uc_ready,
        uc_data_i => uc_data_i,
        uc_data_o => uc_data_o,

        mem_enable => mem_enable,
        mem_write  => mem_write,
        mem_ready  => mem_ready,
        mem_addr   => mem_addr,
        mem_data_i => mem_data_i,
        mem_data_o => mem_data_o
    );

    MP0: entity work.MP generic map (
        filen => "mp_teste.txt"
    ) port map (
        address   => mem_addr,
        data_i    => mem_data_o,
        data_o    => mem_data_i,
        mem_ready => mem_ready,
        enable    => mem_enable,
        mem_write => mem_write
    );

    process
        type address_range is array (natural range <>) of word_t;
        constant r_addresses: address_range := (
            x"00000000", x"00000004", x"00000008", x"0000000C", x"00000010", x"00000014",
            x"00000040", x"00000044", x"00000048", x"0000004C", x"00000050", x"00000054"
        );

        constant memories: address_range := (
            x"1000A1CD", x"100026EF", x"10000369", x"100014AC", x"00000000", x"00000000",
            x"2000FFFF", x"20000001", x"20000215", x"0200AECD", x"2000FDEA", x"20001068"
        );

        constant w_addresses: address_range := (
            x"00001230", x"00001234", x"00001238", x"0000123C", x"00001240", x"00001244",
            x"00000000", x"00000004", x"00000008", x"0000000C", x"00000010", x"00000014"
        );

    begin
        wait for 50 ns;

        -- Initial read test
        uc_write <= '0';
        for i in r_addresses'range loop
            uc_enable <= '1';
            address <= r_addresses(i);
            wait until uc_ready = '1';
            uc_enable <= '0';

            assert uc_data_o = memories(i)
                report "Error on Cache assertion"
                severity error;
            wait until uc_ready = '0';
        end loop;

        report "End of Initial Read";

        wait for 50 ns;

        uc_write <= '1';
        for i in w_addresses'range loop
            address   <= w_addresses(i);
            uc_data_i <= memories(i);
            uc_enable <= '1';
            wait until uc_ready = '1';
            uc_enable <= '0';
            wait until uc_ready = '0';
        end loop;

        report "End of Write";

        wait for 50 ns;

        uc_write <= '0';
        for i in w_addresses'range loop
            address   <= w_addresses(i);
            uc_enable <= '1';
            wait until uc_ready = '1';
            uc_enable <= '0';

            assert uc_data_o = memories(i)
                report "Error on Cache assertion"
                severity error;
            wait until uc_ready = '0';
        end loop;

        report "End of DCache testbench";
        wait;
    end process;

    clock_gen: process
    begin
        clk <= '0', '1' after 10 ns;
        wait for 20 ns;
    end process clock_gen;
end architecture DCache_tb_arch;
