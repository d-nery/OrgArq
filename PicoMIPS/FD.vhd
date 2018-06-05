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
        clk: in std_logic;
        rst: in std_logic;

        opcode: out std_logic_vector(5 downto 0);
        funct:  out std_logic_vector(5 downto 0);

        reg_write:   in std_logic;

        dmem_enable: in std_logic;
        dmem_rw:     in std_logic;

        mux_memtoreg: in std_logic;
        mux_regdest:  in std_logic;
        mux_ulasrc:   in std_logic;
        mux_newPC:    in std_logic_vector(1 downto 0);

        ula_zero: out std_logic;
        ula_op:   in  nibble_t
    );
end entity FD;

architecture FD_arch of FD is
    signal next_instruction: word_t := (others => '0');
    signal instr: instruction_t;

    signal ext_immed: word_t := (others => '0');
    signal ext_immed_shifted: word_t := (others => '0');
    signal jump_address_shifted: word_t := (others => '0');

    signal pc_new_address:   word_t := (others => '0');
    signal pc_address:       word_t := (others => '0');
    signal pc_address_plus4: word_t := (others => '0');

    signal pc4_plus_immed:   word_t := (others => '0');

    signal reg_write_data: word_t := (others => '0');
    signal reg_dest: nibble_t := (others => '0');

    signal reg_data1: word_t := (others => '0');
    signal reg_data2: word_t := (others => '0');
    signal dmem_data: word_t := (others => '0');
    signal ula_result: word_t := (others => '0');

    signal ula_src1: word_t := (others => '0');
begin
    -- ICache

    PC: entity work.PC port map (
        clk => clk,
        new_address => pc_new_address,
        current_address => pc_address
    );

    RI: entity work.RI port map (
        clk              => clk,
        new_instruction  => next_instruction,
        instruction      => instr
    );

    opcode <= instr.opcode;
    funct  <= instr.funct;

    add4: entity work.add4 port map (
        in1 => pc_address,
        out1 => pc_address_plus4
    );

    SExt: entity work.sign_extend port map (
        in1  => instr.immed,
        out1 => ext_immed
    );

    ext_immed_shifted <= ext_immed(31 downto 2) & "00";
    jump_address_shifted <= pc_address_plus4(31 downto 28) & instr.jumpa & "00";
    pc4_plus_immed <= std_logic_vector(unsigned(pc_address_plus4) + unsigned(ext_immed_shifted));

    mux3: entity work.mux3 generic map (n => pc4_plus_immed'length) port map (
        in1    => pc4_plus_immed,
        in2    => jump_address_shifted,
        in3    => pc_address_plus4,
        out1   => pc_new_address,
        choice => mux_newPC
    );

    -- DMEM

    RB: entity work.register_bank port map (
        clk         => clk,
        is_write    => reg_write,
        write_index => reg_dest,
        read_index1 => instr.rs(3 downto 0),
        read_index2 => instr.rt(3 downto 0),
        write_data  => reg_write_data,
        read_data1  => reg_data1,
        read_data2  => reg_data2
    );

    mux21: entity work.mux2 generic map (n => reg_dest'length) port map (
        in1    => instr.rt(3 downto 0),
        in2    => instr.rd(3 downto 0),
        out1   => reg_dest,
        choice => mux_regdest
    );

    mux22: entity work.mux2 generic map (n => dmem_data'length) port map (
        in1    => dmem_data,
        in2    => ula_result,
        out1   => reg_write_data,
        choice => mux_memtoreg
    );

    mux23: entity work.mux2 generic map (n => ext_immed'length) port map (
        in1    => ext_immed,
        in2    => reg_data1,
        out1   => ula_src1,
        choice => mux_ulasrc
    );

    ULA: entity work.ULA port map (
        in1     => ula_src1,
        in2     => reg_data2,
        control => ula_op,
        result  => ula_result,
        zero    => ula_zero
    );
end architecture FD_arch;
