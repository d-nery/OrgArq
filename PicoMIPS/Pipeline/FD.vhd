-- PCS3422 - Organizacao e Arquitetura de Computadores II
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
        clk:   in std_logic;
        rst:   in std_logic
    );
end entity FD;

architecture FD_arch of FD is
    signal if_pc4: word_t := (others => '0');
    signal id_pc4: word_t := (others => '0');
    signal ex_pc4: word_t := (others => '0');

    signal if_instruction: instruction_t;
    signal id_instruction: instruction_t;

    signal id_reg_read1: word_t := (others => '0');
    signal ex_reg_read1: word_t := (others => '0');

    signal id_reg_read2:  word_t := (others => '0');
    signal ex_reg_read2:  word_t := (others => '0');
    signal mem_reg_read2: word_t := (others => '0');

    signal id_immed_ext: word_t := (others => '0');
    signal ex_immed_ext: word_t := (others => '0');

    signal id_jump_addr:  word_t := (others => '0');
    signal ex_jump_addr:  word_t := (others => '0');
    signal mem_jump_addr: word_t := (others => '0');

    signal id_rt: nibble_t := (others => '0');
    signal ex_rt: nibble_t := (others => '0');

    signal id_rd: nibble_t := (others => '0');
    signal ex_rd: nibble_t := (others => '0');

    signal id_shamt: std_logic_vector(04 downto 0) := (others => '0');
    signal ex_shamt: std_logic_vector(04 downto 0) := (others => '0');

    signal ex_branch_addr:  word_t := (others => '0');
    signal mem_branch_addr: word_t := (others => '0');

    signal ex_ula_zero:  std_logic := '0';
    signal mem_ula_zero: std_logic := '0';

    signal ex_ula_result:  word_t := (others => '0');
    signal mem_ula_result: word_t := (others => '0');
    signal wb_ula_result:  word_t := (others => '0');

    signal ex_reg_write_index:  nibble_t := (others => '0');
    signal mem_reg_write_index: nibble_t := (others => '0');
    signal wb_reg_write_index:  nibble_t := (others => '0');

    signal mem_dcache_data: word_t := (others => '0');
    signal wb_dcache_data:  word_t := (others => '0');

    signal wb_reg_write_data: word_t := (others => '0');

    -- Control Unit
    signal id_alu_op: std_logic_vector(1 downto 0) := (others => '0');
    signal ex_alu_op: std_logic_vector(1 downto 0) := (others => '0');

    signal id_alusrc1: std_logic := '0';
    signal ex_alusrc1: std_logic := '0';

    signal id_alusrc2: std_logic := '0';
    signal ex_alusrc2: std_logic := '0';

    signal id_rb_write_src: std_logic := '0';
    signal ex_rb_write_src: std_logic := '0';

    signal ex_funct: std_logic_vector(5 downto 0) := (others => '0');

    signal id_branch:  std_logic := '0';
    signal ex_branch:  std_logic := '0';
    signal mem_branch: std_logic := '0';

    signal id_jump:  std_logic := '1';
    signal ex_jump:  std_logic := '1';
    signal mem_jump: std_logic := '1';

    signal id_reg_write:  std_logic := '0';
    signal ex_reg_write:  std_logic := '0';
    signal mem_reg_write: std_logic := '0';
    signal wb_reg_write:  std_logic := '0';

    signal id_reg_wr_src:  std_logic := '0';
    signal ex_reg_wr_src:  std_logic := '0';
    signal mem_reg_wr_src: std_logic := '0';
    signal wb_reg_wr_src:  std_logic := '0';

    signal id_dcache_wr:  std_logic := '0';
    signal ex_dcache_wr:  std_logic := '0';
    signal mem_dcache_wr: std_logic := '0';

    signal id_dcache_en:  std_logic := '0';
    signal ex_dcache_en:  std_logic := '0';
    signal mem_dcache_en: std_logic := '0';

    signal ula_control: nibble_t := (others => '0');

    -- UC old
    signal branch: std_logic := '0';

    signal dcache_ready: std_logic := '0';

    -- Data Cache
    signal dcache_mem_data_o: word_t := (others => '0');
    signal dcache_mem_data_i: word_t := (others => '0');
    signal dcache_mem_addr:   word_t := (others => '0');
    signal dcache_mem_enable: std_logic := '0';
    signal dcache_mem_write:  std_logic := '0';
    signal dcache_mem_ready:  std_logic := '0';

    -- Instruction Cache
    signal icache_mem_data:   word_t := (others => '0');
    signal icache_mem_addr:   word_t := (others => '0');
    signal icache_mem_enable: std_logic := '0';
    signal icache_mem_ready:  std_logic := '0';

    signal ic_stall: std_logic := '0'; -- Stalling signal from ICache
    signal pipe_stalling: std_logic := '0';
    signal pc_wr: std_logic := '0';
begin
    pipe_stalling <= ic_stall;
    pc_wr <= not pipe_stalling;

    IF0: entity work.instruction_fetch port map (
        clk => clk,
        rst => rst,

        pc_wr => pc_wr,

        add_result => mem_branch_addr,
        jump_addr  => mem_jump_addr,
        zero       => mem_ula_zero,
        branch     => mem_branch,
        jump       => mem_jump,

        pc4 => if_pc4,

        instruction => if_instruction,

        -- ICache
        ic_stall => ic_stall,

        -- To/From MP
        mem_data => icache_mem_data,
        mem_rdy  => icache_mem_ready,

        mem_addr => icache_mem_addr,
        mem_wr   => open,
        mem_en   => icache_mem_enable
    );

    IF_ID: entity work.if_id_pipe port map (
        clk   => clk,
        stall => pipe_stalling,

        if_pc4 => if_pc4,
        id_pc4 => id_pc4,

        if_instruction => if_instruction,
        id_instruction => id_instruction
    );

    ID: entity work.instruction_decode port map (
        clk => clk,

        reg_write       => wb_reg_write,
        reg_write_index => wb_reg_write_index,
        reg_write_data  => wb_reg_write_data,

        reg_data1 => id_reg_read1,
        reg_data2 => id_reg_read2,

        immed_ext => id_immed_ext,
        rt        => id_rt,
        rd        => id_rd,
        shamt     => id_shamt,
        jumpa     => id_jump_addr,

        instruction => id_instruction,

        pc4 => id_pc4
    );

    UC: entity work.UC2 port map (
        clk   => clk,
        rst   => rst,

        opcode    => id_instruction.opcode,

        reg_write => id_reg_write,

        mux_alusrc1 => id_alusrc1,
        mux_alusrc2 => id_alusrc2,
        mux_rbwr    => id_rb_write_src,
        mux_wb      => id_reg_wr_src,
        mux_pcsrc1  => id_branch,
        mux_pcsrc2  => id_jump,

        ula_op => id_alu_op,

        dcache_ready => dcache_ready,
        dcache_wr    => id_dcache_wr,
        dcache_en    => id_dcache_en
    );

    ID_EX: entity work.id_ex_pipe port map (
        clk   => clk,
        stall => pipe_stalling,

        id_pc4 => id_pc4,
        ex_pc4 => ex_pc4,

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

        id_funct => id_instruction.funct,
        ex_funct => ex_funct,

        id_alu_op => id_alu_op,
        ex_alu_op => ex_alu_op,

        id_alusrc1 => id_alusrc1,
        ex_alusrc1 => ex_alusrc1,

        id_alusrc2 => id_alusrc2,
        ex_alusrc2 => ex_alusrc2,

        id_rb_write_src => id_rb_write_src,
        ex_rb_write_src => ex_rb_write_src,

        id_jump => id_jump,
        ex_jump => ex_jump,

        id_branch => id_branch,
        ex_branch => ex_branch,

        id_reg_write => id_reg_write,
        ex_reg_write => ex_reg_write,

        id_dcache_wr => id_dcache_wr,
        ex_dcache_wr => ex_dcache_wr,

        id_dcache_en => id_dcache_en,
        ex_dcache_en => ex_dcache_en,

        id_reg_wr_src => id_reg_wr_src,
        ex_reg_wr_src => ex_reg_wr_src
    );

    ULAC: entity work.ULA_control port map (
        alu_op => ex_alu_op,
        funct  => ex_funct,

        alu_control => ula_control
    );

    EX: entity work.execute port map (
        clk => clk,

        pc4         => ex_pc4,
        branch_addr => ex_branch_addr,

        shamt  => ex_shamt,
        rdata1 => ex_reg_read1,
        rdata2 => ex_reg_read2,
        immed  => ex_immed_ext,

        alu_control => ula_control,
        alu_result  => ex_ula_result,
        alu_zero    => ex_ula_zero,

        alu_src1 => ex_alusrc1,
        alu_src2 => ex_alusrc2,

        rt => ex_rt,
        rd => ex_rd,

        wb_src   => ex_rb_write_src,
        wb_index => ex_reg_write_index
    );

    EX_MEM: entity work.ex_mem_pipe port map (
        clk   => clk,
        stall => pipe_stalling,

        ex_branch_addr  => ex_branch_addr,
        mem_branch_addr => mem_branch_addr,

        ex_jump_addr  => ex_jump_addr,
        mem_jump_addr => mem_jump_addr,

        ex_ula_zero  => ex_ula_zero,
        mem_ula_zero => mem_ula_zero,

        ex_ula_result  => ex_ula_result,
        mem_ula_result => mem_ula_result,

        ex_reg_read2  => ex_reg_read2,
        mem_reg_read2 => mem_reg_read2,

        ex_reg_write_index  => ex_reg_write_index,
        mem_reg_write_index => mem_reg_write_index,

        ex_branch  => ex_branch,
        mem_branch => mem_branch,

        ex_jump  => ex_jump,
        mem_jump => mem_jump,

        ex_reg_write  => ex_reg_write,
        mem_reg_write => mem_reg_write,

        ex_dcache_wr  => ex_dcache_wr,
        mem_dcache_wr => mem_dcache_wr,

        ex_dcache_en  => ex_dcache_en,
        mem_dcache_en => mem_dcache_en,

        ex_reg_wr_src  => ex_reg_wr_src,
        mem_reg_wr_src => mem_reg_wr_src
    );

    MEM: entity work.memory port map (
        clk => clk,

        uc_enable => mem_dcache_en,
        uc_write  => mem_dcache_wr,
        uc_ready  => dcache_ready,
        uc_addr   => mem_ula_result,
        uc_data_o => mem_dcache_data,
        uc_data_i => mem_reg_read2,

        mem_enable => dcache_mem_enable,
        mem_write  => dcache_mem_write,
        mem_ready  => dcache_mem_ready,
        mem_addr   => dcache_mem_addr,
        mem_data_o => dcache_mem_data_o,
        mem_data_i => dcache_mem_data_i
    );

    MEM_WB: entity work.mem_wb_pipe port map (
        clk   => clk,
        stall => pipe_stalling,

        mem_dcache_data => mem_dcache_data,
        wb_dcache_data  => wb_dcache_data,

        mem_ula_result => mem_ula_result,
        wb_ula_result  => wb_ula_result,

        mem_reg_write_index => mem_reg_write_index,
        wb_reg_write_index  => wb_reg_write_index,

        mem_reg_write => mem_reg_write,
        wb_reg_write  => wb_reg_write,

        mem_reg_wr_src => mem_reg_wr_src,
        wb_reg_wr_src  => wb_reg_wr_src
    );

    WB: entity work.write_back port map (
        alu_res   => wb_ula_result,
        dmem_data => wb_dcache_data,

        reg_write_data => wb_reg_write_data,
        mux_src => wb_reg_wr_src
    );

    -- Main Memory
    MP: entity work.MP generic map (
        filen => "mp_teste_soma.txt"
    ) port map (
        mem_ready => dcache_mem_ready,
        data_o    => dcache_mem_data_i,
        enable    => dcache_mem_enable,
        address   => dcache_mem_addr,
        mem_write => dcache_mem_write,
        data_i    => dcache_mem_data_o,

        ro_addr   => icache_mem_addr,
        ro_data_o => icache_mem_data,
        ro_ready  => icache_mem_ready,
        ro_en     => icache_mem_enable
    );
end architecture FD_arch;
