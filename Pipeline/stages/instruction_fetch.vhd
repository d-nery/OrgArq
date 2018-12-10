-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: instruction_fetch.vhd
-- Author: Daniel Nery Silva de Oliveira
-- Collaboration: Beatriz de Oliveira Silva
-- Collaboration: Bruno Henrique Vasconcelos Lemos
-- Collaboration: João Raphael de Souza Morales
--
-- Description:
--     Estágio de busca de instruções

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.types.all;

entity instruction_fetch is
    port (
        clk: in std_logic;
        rst: in std_logic;

        pc_wr: in std_logic := '1';

        add_result: in word_t := (others => '0');
        jump_addr:  in word_t := (others => '0');
        zero:       in std_logic := '0';
        branch:     in std_logic := '0';
        jump:       in std_logic := '1';

        pc4: out word_t := (others => '0') ;

        instruction: out instruction_t;

        ic_stall: out std_logic;

        -- To/From MP
        mem_data:    in word_t := (others => '0');
        mem_rdy:     in std_logic := '0';

        mem_addr:    out word_t := (others => '0');
        mem_wr:      out std_logic := '0';
        mem_en:      out std_logic := '0'
    );
end entity instruction_fetch;

architecture instruction_fetch_arch of instruction_fetch is
    signal current_pc : word_t := (others => '0');
    signal pc_plus_4  : word_t := (others => '0');
    signal new_pc     : word_t := (others => '0');
    signal new_pc_branch: word_t := (others => '0');

    signal zero_and_branch : std_logic := '0';
    signal new_instruction : word_t := (others => '0');

     -- ICache
     signal imem_enable: std_logic := '0';
     signal imem_done:   std_logic := '0';
begin
    PC: entity work.PC port map (
        clk             => clk,
        new_address     => new_pc,
        current_address => current_pc,

        reset => rst,
        wr    => pc_wr
    );

    zero_and_branch <= zero and branch;

    mux_branch: entity work.mux2 port map (
        in1    => pc_plus_4,
        in2    => add_result,
        out1   => new_pc_branch,
        choice => zero_and_branch
    );

    mux_jump: entity work.mux2 port map (
        in1    => jump_addr,
        in2    => new_pc_branch,
        out1   => new_pc,
        choice => jump
    );

    add4: entity work.add4 port map (
        in1  => current_pc,
        out1 => pc_plus_4
    );

    ICC: entity work.IC_control port map (
        pc_value => current_pc,

        ic_done  => imem_done,
        ic_en    => imem_enable,

        ic_stall => ic_stall
    );

    ICache: entity work.ICache port map (
        clk     => clk,
        enable  => imem_enable,

        read_addr => current_pc,
        data_out  => new_instruction,
        uc_done   => imem_done,

        mem_addr    => mem_addr,
        mem_data    => mem_data,
        mem_ready   => mem_rdy,
        mem_enable  => mem_en,
        mem_write   => mem_wr
    );

    pc4 <= pc_plus_4;

    -- Translate word_t to record
    instruction.opcode <= new_instruction(31 downto 26);
    instruction.Rs     <= new_instruction(25 downto 21);
    instruction.Rt     <= new_instruction(20 downto 16);
    instruction.Rd     <= new_instruction(15 downto 11);
    instruction.ShAmt  <= new_instruction(10 downto 06);
    instruction.funct  <= new_instruction(05 downto 00);
    instruction.immed  <= new_instruction(15 downto 00);
    instruction.jumpa  <= new_instruction(25 downto 00);

end architecture instruction_fetch_arch;
