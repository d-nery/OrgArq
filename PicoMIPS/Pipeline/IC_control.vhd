-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: IC_Control.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Entidade da Unidade de Controle da ULA

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity IC_control is
    port (
        pc_value: in word_t := (others => 'U');

        ic_done: in  std_logic := '0';
        ic_en:   out std_logic := '0';

        ic_stall: out std_logic := '0'
    );
end entity IC_control;

architecture IC_control_arch of IC_control is
begin
    ic_control_process: process (pc_value, ic_done)
    begin
        if pc_value'event then
            ic_en    <= '1';
            ic_stall <= '1';
        end if;

        if rising_edge(ic_done) then
            ic_en <= '0';
            ic_stall <= '0';
        end if;
    end process ic_control_process;
end architecture IC_control_arch;
