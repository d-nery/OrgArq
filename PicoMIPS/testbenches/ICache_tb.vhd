-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: ICache_tb.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Testbench para o Cache

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity ICache_tb is
end entity ICache_tb;

architecture ICache_tb_arch of ICache_tb is
    signal address: word_t := (others => '0');
    signal data: word_t;

    signal clk: std_logic := '0';
    signal cache_en: std_logic := '0';
    signal cache_done: std_logic;

    signal s_addr, s_data: word_t;
begin
    cache: entity work.ICache port map (
        clk => clk,
        enable => cache_en,

        -- From UC/FD
        read_addr => address,
        data_out  => data,
        uc_done   => cache_done,

        -- From MP
        mem_addr => s_addr,
        mem_data => s_data
    );

    MP0: entity work.MP generic map (
        filen => "mp_teste.txt"
    ) port map (
        address => s_addr,
        data => s_data
    );

    process
        type address_range is array (natural range <>) of word_t;
        constant addresses: address_range := (
            x"00000000", x"00000001", x"00000002", x"00000003", x"00000004", x"00000005",
            x"00000010", x"00000011", x"00000012", x"00000013", x"00000014", x"00000015"
        );

        constant memories: address_range := (
            x"1000A1CD", x"100026EF", x"10000369", x"100014AC", x"00000000", x"00000000",
            x"2000FFFF", x"20000001", x"20000215", x"0200AECD", x"2000FDEA", x"20001068"
        );
    begin
        wait for 50 ns;

        for i in addresses'range loop
            cache_en <= '1';
            address <= addresses(i);
            wait on cache_done until cache_done = '1';
            cache_en <= '0';

            assert data = memories(i)
                report "Error on MP assertion"
                severity error;
            wait for 100 ns;
        end loop;
        report "End of MP testbench";
        wait;
    end process;

    clock_gen: process
    begin
        clk <= '0', '1' after 60 ns;
        wait for 60 ns;
    end process clock_gen;
end architecture ICache_tb_arch;
