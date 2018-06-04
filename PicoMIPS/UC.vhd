-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: UC.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Entidade da Unidade de Controle

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity UC is
    port (
        clk: in std_logic;
        rst: in std_logic;

        opcode: in std_logic_vector(5 downto 0);
        funct:  in std_logic_vector(5 downto 0);

        reg_write:   out std_logic;

        dmem_enable: out std_logic;
        dmem_rw:     out std_logic;

        mux_memtoreg: out std_logic;
        mux_regdest:  out std_logic;
        mux_ulasrc:   out std_logic;
        mux_newPC:    out std_logic_vector(1 downto 0);

        ula_zero: in  std_logic;
        ula_op:   out nibble_t
    );
end entity UC;

architecture UC_arch of UC is

begin

end architecture UC_arch;
