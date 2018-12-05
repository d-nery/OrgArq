-- PCS3422 - Organizacao e Arquitetura de Computadores II
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
    constant OP_J:    std_logic_vector(5 downto 0) := "000010";
    constant OP_JAL:  std_logic_vector(5 downto 0) := "000011";
    constant OP_BEQ:  std_logic_vector(5 downto 0) := "000100";
    constant OP_BNE:  std_logic_vector(5 downto 0) := "000101";
    constant OP_ADDI: std_logic_vector(5 downto 0) := "001000";
    constant OP_SLTI: std_logic_vector(5 downto 0) := "001010";
    constant OP_LW:   std_logic_vector(5 downto 0) := "100011";
    constant OP_SW:   std_logic_vector(5 downto 0) := "101011";

    constant OP_R:      std_logic_vector(5 downto 0) := "000000";
    constant FUNC_SLL:  std_logic_vector(5 downto 0) := "000000";
    constant FUNC_JR:   std_logic_vector(5 downto 0) := "001000";
    constant FUNC_ADD:  std_logic_vector(5 downto 0) := "100000";
    constant FUNC_ADDU: std_logic_vector(5 downto 0) := "100001";
    constant FUNC_SLT:  std_logic_vector(5 downto 0) := "101010";

    -- ULA Control Operations
    constant ULAC_ADD:    std_logic_vector(1 downto 0) := "00";
    constant ULAC_BRANCH: std_logic_vector(1 downto 0) := "01";
    constant ULAC_RTYPE:  std_logic_vector(1 downto 0) := "10";
    constant ULAC_SLT:    std_logic_vector(1 downto 0) := "11";

    -- ULA Operations
    constant ULA_AND:  nibble_t := "0000";
    constant ULA_OR:   nibble_t := "0001";
    constant ULA_ADD:  nibble_t := "0010";
    constant ULA_SUB:  nibble_t := "0011";
    constant ULA_SLT:  nibble_t := "0100";
    constant ULA_ADDU: nibble_t := "0101";
    constant ULA_SLL:  nibble_t := "0110";

    -- MUXES
    constant MUX_MEM_DC: std_logic := '0';
    constant MUX_MEM_IC: std_logic := '1';

    constant MUX_RBWR_RT: std_logic := '0';
    constant MUX_RBWR_RD: std_logic := '1';

    constant MUX_ALUSRC1_RB:    std_logic := '0';
    constant MUX_ALUSRC1_SHAMT: std_logic := '1';

    constant MUX_ALUSRC2_RB:    std_logic := '0';
    constant MUX_ALUSRC2_IMMED: std_logic := '1';

    constant MUX_WB_ULA: std_logic := '0';
    constant MUX_WB_DC:  std_logic := '1';
end package constants;
