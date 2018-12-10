-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: full_tb.vhd
--
-- Description:
--     Testbench para a Unidade de Controle


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity full_tb is
end entity full_tb;

architecture full_tb_arch of full_tb is
    signal clk:          std_logic := '0';
    signal rst:          std_logic := '0';
begin
    FD: entity work.FD port map (
        clk => clk,
        rst => rst
    );

    test1: process
    begin
        -- reset inputs
        rst <= '1';
        wait for 50 ns;

        rst <= '0';
        wait;
    end process;

    clock_gen: process
    begin
        clk <= '0', '1' after 20 ns;
        wait for 40 ns;
    end process clock_gen;

end architecture full_tb_arch;
