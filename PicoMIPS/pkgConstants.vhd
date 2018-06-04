-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: pkgConstants.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Define constantes para o projeto

library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.types.all;

package constants is
    constant MEMORY_WIDTH:   integer := 32;
    constant REGISTER_WIDTH: integer := 32;

    -- Instructions
    constant OP_J:    integer := 02;
    constant OP_JAL:  integer := 03;
    constant OP_BEQ:  integer := 04;
    constant OP_BNE:  integer := 05;
    constant OP_ADDI: integer := 08;
    constant OP_SLTI: integer := 10;
    constant OP_LW:   integer := 35;
    constant OP_SW:   integer := 43;

    constant OP_R:      integer := 00;
    constant FUNC_SLL:  integer := 00;
    constant FUNC_JR:   integer := 08;
    constant FUNC_ADD:  integer := 32;
    constant FUNC_ADDU: integer := 33;
    constant FUNC_SLT:  integer := 42;

    -- ULA Operations
    constant ULA_AND: nibble_t := "0000";
    constant ULA_OR:  nibble_t := "0001";
    constant ULA_ADD: nibble_t := "0010";
    constant ULA_SUB: nibble_t := "0011";
    constant ULA_SLT: nibble_t := "0100";
end package constants;
