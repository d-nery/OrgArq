-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: FD_tb.vhd
--
-- Description:
--     Testbench para o Flluxo de Dados


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity FD_tb is
end entity FD_tb;

architecture FD_tb_arch of FD_tb is
    signal clk:          std_logic := '0';
    signal rst:          std_logic := '0';
    signal pc_wr:        std_logic := '0';

    signal icache_en:    std_logic := '0';
    signal icache_done:  std_logic := '0';

    signal opcode:       std_logic_vector(5 downto 0) := (others => '0');
    signal funct:        std_logic_vector(5 downto 0) := (others => '0');

    signal reg_write:    std_logic := '0';

    signal mux_rbwr:     std_logic := '0';
    signal mux_alusrc:   std_logic := '0';
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
    FD: entity work.FD port map (
        clk => clk,
        rst => rst,
        pc_wr => pc_wr,

        icache_en => icache_en,
        icache_done => icache_done,

        opcode => opcode,
        funct => funct,

        reg_write => reg_write,

        mux_rbwr => mux_rbwr,
        mux_alusrc => mux_alusrc,
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
        wait for 50 ns;
        mux_mem_src <= '1';
        wait until clk = '1';
        icache_en   <= '1';
        wait until icache_done = '1' and rising_edge(clk); -- Espera término do cache
        icache_en   <= '0';
        wait for 3 ns;

        assert opcode = OP_ADDI
            report "error on fetch" severity error;

        -- ADDI $1, $1, $100
        reg_write   <= '0';
        mux_rbwr    <= '1';
        ula_control <= ULA_ADD;
        mux_alusrc  <= '1';
        mux_mem_src <= '0';
        -- waits next clock cycle
        wait until rising_edge(clk);

        dcache_en <= '1';
        mux_wb    <= '0';
        wait until dcache_ready = '1' and rising_edge(clk);
        dcache_en <= '0';

        reg_write  <= '1';
        mux_pcsrc2 <= '1';
        pc_wr      <= '1';
        mux_mem_src <= '1';
        wait until rising_edge(clk);
        pc_wr <= '0';

        icache_en   <= '1';
        wait until icache_done = '1' and rising_edge(clk); -- Espera término do cache
        icache_en   <= '0';
        wait for 3 ns;

        assert opcode = OP_ADDI
            report "error on fetch" severity error;

        report "Finish testbench";

        wait; -- Finish
    end process;

    clock_gen: process
    begin
        clk <= '0', '1' after 15 ns;
        wait for 30 ns;
    end process clock_gen;

end architecture FD_tb_arch;
