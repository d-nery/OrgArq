-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: DC_Control.vhd
-- Author: Daniel Nery Silva de Oliveira
-- Collaboration: Beatriz de Oliveira Silva
-- Collaboration: Bruno Henrique Vasconcelos Lemos
-- Collaboration: João Raphael de Souza Morales
--
-- Description:
--     Entidade da Unidade de Controle do Cache de Dados

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity DC_control is
    port (
        uc_address: in word_t := (others => 'U');

        uc_en:   in  std_logic := '0';
        dc_en:   out std_logic := '0';
        dc_done: in  std_logic := '0';

        dc_stall: out std_logic := '0'
    );
end entity DC_control;

architecture DC_control_arch of DC_control is
begin
    DC_control_process: process (uc_address, uc_en, DC_done)
    begin
        if rising_edge(uc_en) or (uc_address'event and (uc_en = '1')) then
            DC_stall <= '1';
            dc_en <= '1';
        end if;

        if rising_edge(DC_done) then
            DC_stall <= '0';
            dc_en <= '0';
        end if;
    end process DC_control_process;
end architecture DC_control_arch;
