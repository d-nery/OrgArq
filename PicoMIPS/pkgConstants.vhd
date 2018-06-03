-- Defines constants, and types

library IEEE;
use IEEE.std_logic_1164.all;

package constants is
    constant MEMORY_WIDTH: integer := 32;
    constant REGISTER_WIDTH: integer := 32;

    subtype reg_t is std_logic_vector(REGISTER_WIDTH - 1 downto 0);

    subtype vec32_t is std_logic_vector(31 downto 0);

    -- 2**14 palavras de 32 bits
    type memory_t is array(0 to 2**14 - 1) of std_logic_vector(MEMORY_WIDTH - 1 downto 0);

    -- Instructions
    constant OP_J:    integer := 2;
    constant OP_JAL:  integer := 3;
    constant OP_BEQ:  integer := 4;
    constant OP_BNE:  integer := 5;
    constant OP_ADDI: integer := 8;
    constant OP_SLTI: integer := 10;
    constant OP_LW:   integer := 35;
    constant OP_SW:   integer := 43;

    constant OP_R:      integer := 0;
    constant FUNC_SLL:  integer := 0;
    constant FUNC_JR:   integer := 8;
    constant FUNC_ADD:  integer := 32;
    constant FUNC_ADDU: integer := 33;
    constant FUNC_SLT:  integer := 42;

    -- ULA Operations
    constant ULA_AND:   std_logic_vector(3 downto 0) := "0000";
    constant ULA_OR:    std_logic_vector(3 downto 0) := "0001";
    constant ULA_ADD:   std_logic_vector(3 downto 0) := "0010";
    constant ULA_SUBNE: std_logic_vector(3 downto 0) := "0011";
    constant ULA_SUB:   std_logic_vector(3 downto 0) := "0110";
    constant ULA_SLT:   std_logic_vector(3 downto 0) := "0111";
end package constants;
