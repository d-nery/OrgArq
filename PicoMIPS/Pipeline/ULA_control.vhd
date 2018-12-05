-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: ULA_Control.vhd
-- Author: Daniel Nery Silva de Oliveira
-- Collaboration: Beatriz de Oliveira Silva
-- Collaboration: Bruno Henrique Vasconcelos Lemos
-- Collaboration: João Raphael de Souza Morales
--
-- Description:
--     Entidade da Unidade de Controle da ULA

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity ULA_control is
    port (
        alu_op: in std_logic_vector(1 downto 0) := (others => '0');
        funct:  in std_logic_vector(5 downto 0) := (others => '0');

        alu_control: out std_logic_vector(3 downto 0) := (others => '0')
    );
end entity ULA_control;

architecture ULA_control_arch of ULA_control is
begin

    alu_control_process: process (alu_op, funct)
    begin
        case alu_op is
            when ULAC_ADD =>
                alu_control <= ULA_ADD;

            when ULAC_SLT =>
                alu_control <= ULA_SLT;

            when ULAC_BRANCH =>
                alu_control <= ULA_SUB;

            when ULAC_RTYPE =>
                case funct is
                    when FUNC_ADD =>
                        alu_control <= ULA_ADD;

                    when FUNC_ADDU =>
                        alu_control <= ULA_ADDU;

                    when FUNC_SLL =>
                        alu_control <= ULA_SLL;

                    when FUNC_SLT =>
                        alu_control <= ULA_SLT;
                    when others =>
                end case;
            when others =>
        end case;
    end process alu_control_process;
end architecture ULA_control_arch;
