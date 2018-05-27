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

entity register_bank is
    port (
        clk:         in  std_logic;
        is_write:    in  std_logic;

        write_index: in  std_logic_vector(2 downto 0);
        read_index:  in  std_logic_vector(2 downto 0);

        write_data:  in  std_logic_vector(31 downto 0);
        read_data:   out std_logic_vector(31 downto 0)
    );
end register_bank;

architecture register_bank_arch of register_bank is
    type reg_t is array(0 to 7) of std_logic_vector(31 downto 0);
    signal registers: reg_t := (others => (others => '0'));
begin
    sync_write: process (clk)
    begin
        if (rising_edge(clk) and is_write = '1') then
            registers(to_integer(unsigned(write_index))) <= write_data;
        end if;
    end process sync_write;

    read_data <= registers(to_integer(unsigned(read_index)));
end register_bank_arch;
