-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: UC_tb.vhd
--
-- Description:
--     Testbench para a Unidade de Controle


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity UC_tb is
end entity UC_tb;

architecture UC_tb_arch of UC_tb is
    signal clk:          std_logic := '0';
    signal rst:          std_logic := '0';
    signal pc_wr:        std_logic := '0';

    signal icache_en:    std_logic := '0';
    signal icache_done:  std_logic := '0';

    signal opcode:       std_logic_vector(5 downto 0) := (others => '0');
    signal funct:        std_logic_vector(5 downto 0) := (others => '0');

    signal reg_write:    std_logic := '0';

    signal mux_alusrc1:  std_logic := '0';
    signal mux_alusrc2:  std_logic := '0';
    signal mux_rbwr:     std_logic := '0';
    signal mux_wb:       std_logic := '0';
    signal mux_mem_src:  std_logic := '0';
    signal mux_pcsrc1:   std_logic := '0';
    signal mux_pcsrc2:   std_logic := '0';

    signal ula_zero:      std_logic := '0';
    signal ula_control:   nibble_t  := ULA_AND;

    signal dcache_ready:  std_logic := '0';
    signal dcache_wr:     std_logic := '0';
    signal dcache_en:     std_logic := '0';
begin
    UC: entity work.UC port map (
        clk => clk,
        rst => rst,
        pc_wr => pc_wr,

        icache_en => icache_en,
        icache_done => icache_done,

        opcode => opcode,
        funct => funct,

        reg_write => reg_write,

        mux_rbwr => mux_rbwr,
        mux_alusrc1 => mux_alusrc1,
        mux_alusrc2 => mux_alusrc2,
        mux_wb => mux_wb,
        mux_mem_src => mux_mem_src,
        mux_pcsrc1 => mux_pcsrc1,
        mux_pcsrc2 => mux_pcsrc2,

        ula_zero => ula_zero,
        ula_control => ula_control,

        dcache_ready => dcache_ready,
        dcache_wr => dcache_wr,
        dcache_en => dcache_en
    );

    test1: process

    begin
        -- reset inputs
        rst         <= '1';
        icache_done <= '0';
        opcode      <= OP_R;
        funct       <= FUNC_SLL;
        ula_zero    <= '0';

        wait for 20 ns;

        ---------------------------
        -- IDLE
        ---------------------------

        rst <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;

        assert icache_en = '1'
            report "Instruction Cache not enabled"
            severity failure;

        assert mux_mem_src = MUX_MEM_IC
            report "Memory source not Instruction Cache"
            severity error;

        ---------------------------
        -- FETCH
        ---------------------------

        wait for 100 ns; -- "Reading memory"

        -- ADDI $2, $2, $100
        icache_done <= '1';
        opcode      <= "001000";

        wait until rising_edge(clk);
        wait for 1 ns;

        assert icache_en = '0'
            report "Instruction Cache not disabled"
            severity failure;

        icache_done <= '0';

        ---------------------------
        -- EXECUTE
        ---------------------------

        -- Check all signals
        assert reg_write = '0'
            report "Error on RB write"
            severity error;

        assert mux_rbwr = MUX_RBWR_RT
            report "Error on RB write source"
            severity error;

        assert mux_alusrc2 = MUX_ALUSRC2_IMMED
            report "Error on ULA source"
            severity error;

        wait until rising_edge(clk);
        wait for 1 ns;

        ---------------------------
        -- WRITE BACK
        ---------------------------

        -- Check all signals
        assert reg_write = '1'
            report "Error on RB write"
            severity error;

        assert pc_wr = '1'
            report "Error on PC write"
            severity error;

        assert mux_pcsrc1 = '0'
            report "Error on PCSRC1"
            severity error;

        assert mux_pcsrc2 = '1'
            report "Error on PCSRC2"
            severity error;

        report "Finish testbench";

        wait; -- Finish
    end process;

    clock_gen: process
    begin
        clk <= '0', '1' after 15 ns;
        wait for 30 ns;
    end process clock_gen;

end architecture UC_tb_arch;
