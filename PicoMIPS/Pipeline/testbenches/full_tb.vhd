-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: full_tb.vhd
--
-- Description:
--     Testbench para a Unidade de Controle


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity full_tb is
end entity full_tb;

architecture full_tb_arch of full_tb is
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
        rst <= '1';
        wait for 50 ns;

        rst <= '0';
        wait;
    end process;

    clock_gen: process
    begin
        clk <= '0', '1' after 20 ns;
        wait for 40 ns;
    end process clock_gen;

end architecture full_tb_arch;
