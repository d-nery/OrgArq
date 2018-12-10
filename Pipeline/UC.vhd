-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: UC.vhd
-- Author: Daniel Nery Silva de Oliveira
-- Collaboration: Beatriz de Oliveira Silva
-- Collaboration: Bruno Henrique Vasconcelos Lemos
-- Collaboration: João Raphael de Souza Morales
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
        clk:   in  std_logic;
        rst:   in  std_logic;

        opcode: in std_logic_vector(5 downto 0) := (others => '0');

        reg_write:   out std_logic := '0';

        mux_alusrc2: out std_logic := '0';
        mux_rbwr:    out std_logic := '0';
        mux_wb:      out std_logic := '0';
        mux_pcsrc1:  out std_logic := '0';
        mux_pcsrc2:  out std_logic := '1';

        ula_op:      out std_logic_vector(1 downto 0) := (others => '0');

        dcache_ready: in  std_logic := '0';
        dcache_wr:    out std_logic := '0';
        dcache_en:    out std_logic := '0'
    );
end entity UC;

architecture UC_arch of UC is
    -- Mapped state for debugging purposes
    signal d_current_execute_state: nibble_t := (others => '0');
begin
    opcode_decode: process (opcode)
    begin
        mux_wb <= MUX_WB_ULA;

        dcache_wr <= '0';
        dcache_en <= '0';

        case opcode is
            when OP_R =>
                d_current_execute_state <= "0001";

                mux_rbwr    <= MUX_RBWR_RD;
                mux_alusrc2 <= MUX_ALUSRC2_RB;

                mux_pcsrc1  <= '0';
                mux_pcsrc2  <= '1';

                reg_write <= '1';
                ula_op <= ULAC_RTYPE;

            when OP_ADDI =>
                d_current_execute_state <= "0010";

                ula_op      <= ULAC_ADD;
                mux_rbwr    <= MUX_RBWR_RT;
                mux_alusrc2 <= MUX_ALUSRC2_IMMED;

                mux_pcsrc1  <= '0';
                mux_pcsrc2  <= '1';

                reg_write <= '1';

            when OP_SLTI =>
                d_current_execute_state <= "0011";

                ula_op      <= ULAC_SLT;
                mux_rbwr    <= MUX_RBWR_RT;
                mux_alusrc2 <= MUX_ALUSRC2_IMMED;

                mux_pcsrc1  <= '0';
                mux_pcsrc2  <= '1';

                reg_write <= '1';

            when OP_J =>
                d_current_execute_state <= "0100";

                mux_pcsrc1  <= '0';
                mux_pcsrc2  <= '0';
                mux_alusrc2 <= MUX_ALUSRC2_IMMED;

                reg_write <= '0';

            when OP_LW =>
                d_current_execute_state <= "0101";
                reg_write <= '1';
                dcache_en <= '1';

                mux_rbwr    <= MUX_RBWR_RT;
                mux_alusrc2 <= MUX_ALUSRC2_IMMED;
                mux_wb      <= MUX_WB_DC;

                mux_pcsrc1  <= '0';
                mux_pcsrc2  <= '1';

                ula_op <= ULAC_ADD;

                dcache_wr <= '0';

            when others =>
                d_current_execute_state <= "0000";

        end case;
    end process opcode_decode;
end architecture UC_arch;
