-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: FD2.vhd
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

entity FD2 is
    port (
        clk:   in std_logic;
        rst:   in std_logic;
        pc_wr: in std_logic;

        icache_en:   in  std_logic;
        icache_done: out std_logic;

        opcode: out std_logic_vector(5 downto 0);
        funct:  out std_logic_vector(5 downto 0);

        reg_write:   in std_logic;

        mux_alusrc1: in std_logic;
        mux_alusrc2: in std_logic;
        mux_rbwr:    in std_logic;
        mux_wb:      in std_logic;
        mux_mem_src: in std_logic;
        mux_pcsrc1:  in std_logic;
        mux_pcsrc2:  in std_logic;

        branch: in std_logic;

        ula_zero:    out std_logic;
        ula_control: in  nibble_t;

        dcache_ready: out std_logic;
        dcache_wr:    in  std_logic;
        dcache_en:    in  std_logic
    );
end entity FD2;

architecture FD2_arch of FD2 is
    signal if_pc4: word_t;
    signal id_pc4: word_t;
    signal ex_pc4: word_t;

    signal if_instruction: instruction_t;
    signal id_instruction: instruction_t;

    signal id_reg_read1: word_t;
    signal ex_reg_read1: word_t;

    signal id_reg_read2: word_t;
    signal ex_reg_read2: word_t;

    signal id_immed_ext: word_t;
    signal ex_immed_ext: word_t;

    signal id_jump_addr: word_t;
    signal ex_jump_addr: word_t;

    signal id_rt: nibble_t;
    signal ex_rt: nibble_t;

    signal id_rd: nibble_t;
    signal ex_rd: nibble_t;

    signal id_shamt: std_logic_vecotr(04 downto 0);
    signal ex_shamt: std_logic_vecotr(04 downto 0);

begin
    IF0: entity work.instruction_fetch port map (
        clk => clk,
        rst => rst,

        pc_wr => pc_wr,

        add_result =>
        jump_addr  =>
        zero       => ula_zero,
        branch     => mux_pcsrc1,
        jump       => mux_pcsrc2,

        pc4 => if_pc4,

        instruction => if_instruction,

        -- ICache
        imem_enable => icache_en,
        imem_done   => icache_done,

        -- To/From MP
        mem_data => mem_data,
        mem_rdy  => mem_ready,

        mem_addr => icache_mem_addr,
        mem_wr   => icache_mem_write,
        mem_en   => icache_en
    );

    IF_ID: entity work.if_id_pipe port map (
        clk => clk,

        if_pc4 => if_pc4,
        id_pc4 => id_pc4,

        if_instruction => if_instruction;
        id_instruction => id_instruction;
    );

    ID: entity work.instruction_decode port map (
        clk => clk,

        reg_write       =>
        reg_write_index =>
        reg_write_data  =>

        reg_data1 => id_reg_read1,
        reg_data2 => id_reg_read2,

        immed_ext => id_immed_ext,
        rt        => id_rt,
        rd        => id_rd,
        shamt     => id_shamt,
        jumpa     => id_jump_addr,

        instruction => id_instruction;

        pc4 => id_pc4
    );

    ID_EX: entity work.id_ex_pipe port map (
        clk => clk;

        id_pc4 => id_pc4;
        ex_pc4 => ex_pc4;

        id_reg_read1 => id_reg_read1,
        ex_reg_read1 => ex_reg_read1,

        id_reg_read2 => id_reg_read2,
        ex_reg_read2 => ex_reg_read2,

        id_immed_ext => id_immed_ext,
        ex_immed_ext => ex_immed_ext,

        id_jumpa => id_jump_addr,
        ex_jumpa => ex_jump_addr,

        id_rt => id_rt,
        ex_rt => ex_rt,

        id_rd => id_rd,
        ex_rd => ex_rd,

        id_shamt => id_shamt,
        ex_shamt => ex_shamt,
    );

    EX: entity work.execute port map (
        clk => clk,

        pc4         => ex_pc4,
        branch_addr =>

        shamt  => ex_shamt,
        rdata1 => ex_reg_read1,
        rdata2 => ex_reg_read2,
        immed  => ex_immed_ext,

        alu_control =>
        alu_result  =>
        alu_zero    =>

        alu_src1 =>
        alu_src2 =>

        rt => ex_rt,
        rd => ex_rd,

        wb_src =>
        wb_index =>
    );

    EX_MEM: entity work.ex_mem_pipe port map (
        clk =>

        ex_branch_addr =>
        mem_branch_addr =>

        ex_jump_addr =>
        mem_jump_addr =>

        ex_ula_zero =>
        mem_ula_zero =>

        ex_ula_result =>
        mem_ula_result =>

        ex_reg_read2 =>
        mem_reg_read2 =>

        ex_reg_write_index =>
        mem_reg_write_index =>
    );

    -- Main Memory
    mem_enable  <= dcache_mem_enable when mux_mem_src = '0' else icache_mem_enable;
    mem_address <= dcache_mem_addr   when mux_mem_src = '0' else icache_mem_addr;
    mem_write   <= dcache_mem_write  when mux_mem_src = '0' else icache_mem_write;

    MEM: entity work.MP generic map (
        filen => "mp_teste_soma.txt"
    ) port map (
        mem_ready => mem_ready,
        data_o    => mem_data,
        enable    => mem_enable,
        address   => mem_address,
        mem_write => mem_write,
        data_i    => dcache_mem_data
    );
end architecture FD2_arch;
