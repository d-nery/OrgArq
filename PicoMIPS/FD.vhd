-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: FD.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Entidade do Fluxo de Dados

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity FD is
    port (
        clk: in std_logic;
        rst: in std_logic;

        opcode: out std_logic_vector(5 downto 0);
        funct:  out std_logic_vector(5 downto 0);

        reg_write:   in std_logic;

        dmem_enable: in std_logic;
        dmem_rw:     in std_logic;

        mux_memtoreg: in std_logic;
        mux_regdest:  in std_logic;
        mux_ulasrc:   in std_logic;
        mux_newPC:    in std_logic_vector(1 downto 0);

        ula_zero: out std_logic;
        ula_op:   in  nibble_t
    );
end entity FD;

architecture FD_arch of FD is

begin

end architecture FD_arch;
