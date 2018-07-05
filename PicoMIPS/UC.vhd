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
        clk:   in std_logic;
        rst:   in std_logic;
        pc_wr: out std_logic;

        icache_en:   out  std_logic;
        icache_done: in std_logic;

        opcode: in std_logic_vector(5 downto 0);
        funct:  in std_logic_vector(5 downto 0);

        reg_write:   out std_logic;

        mux_rbwr:    out std_logic;
        mux_alusrc:  out std_logic;
        mux_wb:      out std_logic;
        mux_mem_src: out std_logic;
        mux_pcsrc1:  out std_logic;
        mux_pcsrc2:  out std_logic;

        ula_zero:    in std_logic;
        ula_control: out  nibble_t;

        dcache_ready: in std_logic;
        dcache_wr:    out  std_logic;
        dcache_en:    out  std_logic
    );
end entity UC;

architecture UC_arch of UC is
    type estado_t is (INICIO, R, ADDI, BEQ, BNE, JUMP, LW, SW);

    signal estado_atual: estado_t := INICIO;
    signal prox_estado:  estado_t := INICIO;
    signal we: std_logic := '0';
begin
    -- estado seguinte
    cycle: process (clk, rst)
    begin
        if rst = '1' then
            estado_atual <= INICIO;
        elsif rising_edge(clk) then
            estado_atual <= prox_estado;
        end if;
    end process cycle;

    -- Funcao combinatoria
    state: process (opcode, funct, ula_zero)
    begin
        case opcode is
            when OP_R    => prox_estado <= R;
            when OP_ADDI => prox_estado <= ADDI;
            when OP_BEQ  => prox_estado <= BEQ;
            when OP_BNE  => prox_estado <= BNE;
            when OP_J    => prox_estado <= JUMP;
            when OP_LW   => prox_estado <= LW;
            when OP_SW   => prox_estado <= SW;
            when others  => prox_estado <= INICIO;
        end case;
    end process state;

    -- with estado_atual select
    --     mux_regdest <= '1' when R,
    --                     '0' when others;

    -- with estado_atual select
    --     mux_memtoreg <= '1' when LW,
    --                     '0' when others;

    -- with estado_atual select
    --     mux_ulasrc <= '1' when ADDI | LW | SW,
    --                   '0' when others;

    -- with estado_atual select
    --     reg_write <= '1' when R | ADDI| LW,
    --                  '0' when others;

    -- with estado_atual select
    --     dmem_enable <= '0' when INICIO,
    --                   '1' when others;

    -- with estado_atual select
    --     dmem_rw <= '1' when SW,
    --                '0' when others;

    -- with estado_atual select
    --     mux_newPC <= "00" when INICIO,
    --                  "11" when others;

    -- with estado_atual select
    --     ula_op <= "0000" when INICIO,
    --               "0001" when others;

    -- dmem_rw <= not clk and we;
end architecture UC_arch;
