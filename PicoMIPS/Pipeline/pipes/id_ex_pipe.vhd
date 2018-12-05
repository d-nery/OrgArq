-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: id_ex_pipe.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Instruction Decode <-> Execute

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.types.all;

entity id_ex_pipe is
    port (
        clk: in std_logic;
        stall: in std_logic := '0';

        id_pc4: in  word_t := (others => '0');
        ex_pc4: out word_t := (others => '0');

        id_reg_read1: in  word_t := (others => '0');
        ex_reg_read1: out word_t := (others => '0');

        id_reg_read2: in  word_t := (others => '0');
        ex_reg_read2: out word_t := (others => '0');

        id_immed_ext: in  word_t := (others => '0');
        ex_immed_ext: out word_t := (others => '0');

        id_jumpa: in  word_t := (others => '0');
        ex_jumpa: out word_t := (others => '0');

        id_rt: in  nibble_t := (others => '0');
        ex_rt: out nibble_t := (others => '0');

        id_rd: in  nibble_t := (others => '0');
        ex_rd: out nibble_t := (others => '0');

        id_shamt: in  std_logic_vector(04 downto 0) := (others => '0');
        ex_shamt: out std_logic_vector(04 downto 0) := (others => '0');

        id_funct: in  std_logic_vector(5 downto 0) := (others => '0');
        ex_funct: out std_logic_vector(5 downto 0) := (others => '0');

        -- Control signals
        id_alu_op: in  std_logic_vector(1 downto 0) := (others => '0');
        ex_alu_op: out std_logic_vector(1 downto 0) := (others => '0');

        id_alusrc1: in  std_logic := '0';
        ex_alusrc1: out std_logic := '0';

        id_alusrc2: in  std_logic := '0';
        ex_alusrc2: out std_logic := '0';

        id_rb_write_src: in  std_logic := '0';
        ex_rb_write_src: out std_logic := '0';

        id_jump: in  std_logic := '1';
        ex_jump: out std_logic := '1';

        id_branch: in  std_logic := '0';
        ex_branch: out std_logic := '0';

        id_reg_write: in  std_logic := '0';
        ex_reg_write: out std_logic := '0';

        id_dcache_wr: in  std_logic := '0';
        ex_dcache_wr: out std_logic := '0';

        id_dcache_en: in  std_logic := '0';
        ex_dcache_en: out std_logic := '0';

        id_reg_wr_src: in  std_logic := '0';
        ex_reg_wr_src: out std_logic := '0'
    );
end entity id_ex_pipe;

architecture id_ex_pipe_arch of id_ex_pipe is

begin
    process (clk)
    begin
        if rising_edge(clk) and (stall = '0') then
            ex_pc4          <= id_pc4;
            ex_reg_read1    <= id_reg_read1;
            ex_reg_read2    <= id_reg_read2;
            ex_immed_ext    <= id_immed_ext;
            ex_jumpa        <= id_jumpa;
            ex_rt           <= id_rt;
            ex_rd           <= id_rd;
            ex_shamt        <= id_shamt;
            ex_funct        <= id_funct;

            ex_alu_op       <= id_alu_op;
            ex_alusrc1      <= id_alusrc1;
            ex_alusrc2      <= id_alusrc2;
            ex_rb_write_src <= id_rb_write_src;
            ex_jump         <= id_jump;
            ex_branch       <= id_branch;
            ex_reg_write    <= id_reg_write;
            ex_dcache_wr    <= id_dcache_wr;
            ex_dcache_en    <= id_dcache_en;
            ex_reg_wr_src   <= id_reg_wr_src;
        end if;
    end process;
end architecture id_ex_pipe_arch;
