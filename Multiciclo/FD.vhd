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

        ula_zero:    out std_logic;
        ula_control: in  nibble_t;

        dcache_ready: out std_logic;
        dcache_wr:    in  std_logic;
        dcache_en:    in  std_logic
    );
end entity FD;

architecture FD_arch of FD is
    -- PC
    signal pc_addr:     word_t := (others => '0');
    signal pc_addr_4:   word_t := (others => '0');
    signal pc_new_addr: word_t := (others => '0');

    -- Instruction Cache
    signal icache_data:       word_t := (others => '0');
    signal icache_mem_addr:   word_t := (others => '0');
    signal icache_mem_enable: std_logic := '0';
    signal icache_mem_write:  std_logic := '0';

    -- RI
    signal instruction:  instruction_t;
    signal ri_rs:        std_logic_vector(4  downto 0) := (others => '0');
    signal ri_rt:        std_logic_vector(4  downto 0) := (others => '0');
    signal ri_rd:        std_logic_vector(4  downto 0) := (others => '0');
    signal ri_immed:     std_logic_vector(15 downto 0) := (others => '0');
    signal ri_shamt:     std_logic_vector(4  downto 0) := (others => '0');
    signal ri_jumpa:     std_logic_vector(25 downto 0) := (others => '0');
    signal ri_shamt_ext: word_t := (others => '0');
    signal ri_immed_ext: word_t := (others => '0');

    -- Register Bank
    signal rb_write_index: std_logic_vector(4 downto 0) := (others => '0');
    signal rb_read1:       word_t := (others => '0');
    signal rb_read2:       word_t := (others => '0');
    signal rb_write_data:  word_t := (others => '0');

    -- ULA
    signal ula_src1: word_t := (others => '0');
    signal ula_src2: word_t := (others => '0');
    signal ula_res:  word_t := (others => '0');

    -- Data Cache
    signal dcache_data:       word_t := (others => '0');
    signal dcache_mem_addr:   word_t := (others => '0');
    signal dcache_mem_data:   word_t := (others => '0');
    signal dcache_mem_enable: std_logic := '0';
    signal dcache_mem_write:  std_logic := '0';

    -- MP
    signal mem_ready:   std_logic := '0';
    signal mem_enable:  std_logic := '0';
    signal mem_write:   std_logic := '0';
    signal mem_data:    word_t := (others => '0');
    signal mem_address: word_t := (others => '0');

    -- outros
    signal pcsrc1: word_t := (others => '0');
    signal sll1:   word_t := (others => '0');
    signal temp1:  word_t := (others => '0');
    signal temp2:  word_t := (others => '0');

begin
    R1: entity work.PC port map (
        clk         => clk,
        new_address => pc_new_addr,
        wr          => pc_wr,
        reset       => rst,

        current_address => pc_addr
    );

    add4: entity work.add4 port map (
        in1  => pc_addr,
        out1 => pc_addr_4
    );

    C1: entity work.ICache port map (
        clk       => clk,
        enable    => icache_en,
        read_addr => pc_addr,

        data_out => icache_data,
        uc_done  => icache_done,

        mem_addr   => icache_mem_addr,
        mem_data   => mem_data,
        mem_ready  => mem_ready,
        mem_enable => icache_mem_enable,
        mem_write  => icache_mem_write
    );

    R2: entity work.RI port map (
        clk => clk,

        new_instruction => icache_data,
        instruction     => instruction
    );

    opcode   <= instruction.opcode;
    ri_rs    <= instruction.Rs;
    ri_rt    <= instruction.Rt;
    ri_rd    <= instruction.Rd;
    ri_shamt <= instruction.shamt;
    funct    <= instruction.funct;
    ri_immed <= instruction.immed;
    ri_jumpa <= instruction.jumpa;

    M4: entity work.mux2 generic map (
        n => 5
    ) port map (
        in1    => ri_rt,
        in2    => ri_rd,
        out1   => rb_write_index,
        choice => mux_rbwr
    );

    RB: entity work.register_bank port map (
        clk => clk,
        reg_write   => reg_write,

        read_index1 => ri_rs(3 downto 0),
        read_index2 => ri_rt(3 downto 0),
        write_index => rb_write_index(3 downto 0),
        write_data  => rb_write_data,

        read_data1 => rb_read1,
        read_data2 => rb_read2
    );

    SE: entity work.sign_extend port map (
        in1  => ri_immed,
        out1 => ri_immed_ext
    );

    SE_shamt: entity work.sign_extend generic map (
        in_n => 5
    ) port map (
        in1  => ri_shamt,
        out1 => ri_shamt_ext
    );

    M5: entity work.mux2 port map (
        in1    => rb_read2,
        in2    => ri_immed_ext,
        out1   => ula_src2,
        choice => mux_alusrc2
    );

    M9: entity work.mux2 port map (
        in1    => rb_read1,
        in2    => ri_shamt_ext,
        out1   => ula_src1,
        choice => mux_alusrc1
    );

    ULA1: entity work.ULA port map (
        in1     => ula_src1,
        in2     => ula_src2,
        control => ula_control,
        result  => ula_res,
        zero    => ula_zero
    );

    C2: entity work.DCache port map (
        clk => clk,

        uc_addr   => ula_res,
        uc_data_i => rb_read2,
        uc_ready  => dcache_ready,
        uc_write  => dcache_wr,
        uc_enable => dcache_en,
        uc_data_o => dcache_data,

        mem_enable => dcache_mem_enable,
        mem_write  => dcache_mem_write,
        mem_ready  => mem_ready,
        mem_addr   => dcache_mem_addr,
        mem_data_o => dcache_mem_data,
        mem_data_i => mem_data
    );

    M6: entity work.mux2 port map (
        in1    => ula_res,
        in2    => dcache_data,
        out1   => rb_write_data,
        choice => mux_wb
    );

    sll1  <= ri_immed_ext(29 downto 0) & "00";
    temp1 <= std_logic_vector(unsigned(pc_addr_4) + unsigned(sll1));

    M7: entity work.mux2 port map (
        in1    => pc_addr_4,
        in2    => temp1,
        out1   => pcsrc1,
        choice => mux_pcsrc1
    );

    temp2 <= pc_addr_4(31 downto 28) & (ri_jumpa & "00");

    M8: entity work.mux2 port map (
        in1    => temp2,
        in2    => pcsrc1,
        out1   => pc_new_addr,
        choice => mux_pcsrc2
    );

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
end architecture FD_arch;
