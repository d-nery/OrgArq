-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: MP_tb.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Testbench para a Memoria Principal

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity MP_tb is
end entity MP_tb;

architecture MP_tb_arch of MP_tb is
    signal address: word_t;
    signal data: word_t;
    signal mem_ready:  std_logic;
    signal mem_enable: std_logic;
begin
    MP0: entity work.MP generic map (
        filen => "mp_teste.txt"
    ) port map (
        address => address,
        data_o => data,
        data_i => (others => '0'),
        mem_ready => mem_ready,
        enable => mem_enable,
        mem_write => '0'
    );

    process
        type address_range is array (natural range <>) of word_t;
        constant addresses: address_range := (
            x"00000000", x"00000004", x"00000008", x"0000000C", x"00000010", x"00000014",
            x"00000040", x"00000044", x"00000048", x"0000004C", x"00000050", x"00000054"
        );

        constant memories: address_range := (
            x"1000A1CD", x"100026EF", x"10000369", x"100014AC", x"00000000", x"00000000",
            x"2000FFFF", x"20000001", x"20000215", x"0200AECD", x"2000FDEA", x"20001068"
        );
    begin
        for i in addresses'range loop
            address <= addresses(i);
            mem_enable <= '1';
            wait until mem_ready = '1';
            mem_enable <= '0';
            wait for 10 ns;

            assert data = memories(i)
                report "Error on MP assertion"
                severity error;
        end loop;
        report "End of MP testbench";
        wait;
    end process;
end architecture MP_tb_arch;
