-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: PC_tb.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Testbench para a Contador de Instrucoes

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity PC_tb is
end entity PC_tb;

architecture PC_tb_arch of PC_tb is
    signal clk : std_logic := '0';
    signal new_address : word_t;
    signal current_address : word_t;
begin
    PC0: entity work.PC port map (
        clk => clk,
        new_address => new_address,
        current_address => current_address
    );

    process
        type address_range is array (natural range <>) of word_t;
        constant addresses: address_range := (
            x"A1B2C3D4", x"E5F6AA14", x"12A58EDF", x"36485121", x"ABCDEF12", x"00000000",
            x"FFFFFFFF", x"ABCE65F8", x"9415FC25", x"14A5C1E2", x"FF59A51C", x"20000FE5",
            x"EFFFFFFF", x"25145984", x"21456982", x"12024879", x"ABE89C12", x"A25C9E2F"
        );
    begin
        for i in addresses'range loop
            new_address <= addresses(i);
            wait for 40 ns;

            assert current_address = addresses(i)
                report "Error on PC assertion"
                severity error;
        end loop;
        report "End of PC testbench";
        wait;
    end process;

    clock_gen: process
    begin
        for i in 1 to 18 loop
            clk <= '0', '1' after 20 ns;
            wait for 40 ns;
        end loop;
        wait;
    end process clock_gen;
end architecture PC_tb_arch;
