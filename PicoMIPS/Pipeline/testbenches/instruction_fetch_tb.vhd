-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: instruction_fetch_tb.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Testbench da parte completa de Instruction Fetch

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity instruction_fetch_tb is
end entity instruction_fetch_tb;

architecture instruction_arch of instruction_fetch_tb is
    signal clk:     std_logic := '0';
    signal pc_wr:   std_logic;

    signal decoded_instr: instruction_t;

    signal mem_ready:  std_logic;
    signal mem_write:  std_logic;
    signal mem_enable: std_logic;

    signal cache_en: std_logic := '0';
    signal cache_done: std_logic;

    signal s_addr, s_data: word_t;

    signal d_opcode: std_logic_vector(05 downto 00);
    signal d_Rs:     std_logic_vector(04 downto 00);
    signal d_Rt:     std_logic_vector(04 downto 00);
    signal d_Rd:     std_logic_vector(04 downto 00);
    signal d_ShAmt:  std_logic_vector(04 downto 00);
    signal d_funct:  std_logic_vector(05 downto 00);
    signal d_immed:  std_logic_vector(15 downto 00);
    signal d_jumpa:  std_logic_vector(25 downto 00);
begin
    instr_fetch: entity work.instruction_fetch port map (
        clk => clk,
        rst => '0',

        pc_wr => pc_wr,

        add_result => (others => '0'),
        jump_addr  => (others => '0'),
        zero       => '0',
        branch     => '0',
        jump       => '0',

        pc4 => open,

        -- ICache
        imem_enable => cache_en,
        imem_done   => cache_done,
        instruction => decoded_instr,

        -- To/From MP
        mem_data => s_data,
        mem_rdy  => mem_ready,

        mem_addr => s_addr,
        mem_wr   => mem_write,
        mem_en   => mem_enable
    );

    MP0: entity work.MP generic map (
        filen => "mp_teste_fetch.txt"
    ) port map (
        address   => s_addr,
        data_o    => s_data,
        data_i    => (others => '0'),
        mem_ready => mem_ready,
        enable    => mem_enable,
        mem_write => mem_write
    );

    test: process
        type instruction_array is array (natural range <>) of word_t;
        type dec_instruction_array is array (natural range <>) of instruction_t;

        constant instructions: instruction_array := (
            x"00430820", x"00430822", x"20620030", x"0043082A",
            x"09B2C3D4", x"1443C3D4", x"1043A2C3", x"8C62A2C3", x"00031080", x"00031082"
        );

        constant decoded_instructions: dec_instruction_array := (
            (opcode => "000000", Rs => "00010", Rt => "00011", Rd => "00001", ShAmt => "00000", funct => "100000", immed => x"0820", jumpa => "00010000110000100000100000"), -- ADD
            (opcode => "000000", Rs => "00010", Rt => "00011", Rd => "00001", ShAmt => "00000", funct => "100010", immed => x"0822", jumpa => "00010000110000100000100010"), -- SUB
            (opcode => "001000", Rs => "00011", Rt => "00010", Rd => "00000", ShAmt => "00000", funct => "110000", immed => x"0030", jumpa => "00011000100000000000110000"), -- ADDI
            (opcode => "000000", Rs => "00010", Rt => "00011", Rd => "00001", ShAmt => "00000", funct => "101010", immed => x"082A", jumpa => "00010000110000100000101010"), -- SLT
            (opcode => "000010", Rs => "01101", Rt => "10010", Rd => "11000", ShAmt => "01111", funct => "010100", immed => x"C3D4", jumpa => "01101100101100001111010100"), -- J
            (opcode => "000101", Rs => "00010", Rt => "00011", Rd => "11000", ShAmt => "01111", funct => "010100", immed => x"C3D4", jumpa => "00010000111100001111010100"), -- BNE
            (opcode => "000100", Rs => "00010", Rt => "00011", Rd => "10100", ShAmt => "01011", funct => "000011", immed => x"A2C3", jumpa => "00010000111010001011000011"), -- BEQ
            (opcode => "100011", Rs => "00011", Rt => "00010", Rd => "10100", ShAmt => "01011", funct => "000011", immed => x"A2C3", jumpa => "00011000101010001011000011"), -- LW
            (opcode => "000000", Rs => "00000", Rt => "00011", Rd => "00010", ShAmt => "00010", funct => "000000", immed => x"1080", jumpa => "00000000110001000010000000"), -- SLL
            (opcode => "000000", Rs => "00000", Rt => "00011", Rd => "00010", ShAmt => "00010", funct => "000010", immed => x"1082", jumpa => "00000000110001000010000010")  -- SRL
        );

    begin
        -- wait for 50 ns;

        for i in instructions'range loop
            pc_wr <= '0';
            cache_en <= '1';
            wait until cache_done = '1';
            pc_wr <= '1';
            cache_en <= '0';

            wait for 5 ns;

            wait until cache_done = '0';
            wait for 5 ns;

            assert
                decoded_instr.opcode = decoded_instructions(i).opcode and
                decoded_instr.Rs     = decoded_instructions(i).Rs     and
                decoded_instr.Rt     = decoded_instructions(i).Rt     and
                decoded_instr.Rd     = decoded_instructions(i).Rd     and
                decoded_instr.ShAmt  = decoded_instructions(i).ShAmt  and
                decoded_instr.funct  = decoded_instructions(i).funct  and
                decoded_instr.immed  = decoded_instructions(i).immed  and
                decoded_instr.jumpa  = decoded_instructions(i).jumpa
                report "Decode error"
                    severity error;
        end loop;
        report "End of Instruction fetch testbench";
        wait;
    end process test;

    clock_gen: process
    begin
        clk <= '0', '1' after 20 ns;
        wait for 40 ns;
    end process clock_gen;

    d_opcode <= decoded_instr.opcode;
    d_Rs <= decoded_instr.Rs;
    d_Rt <= decoded_instr.Rt;
    d_Rd <= decoded_instr.Rd;
    d_ShAmt <= decoded_instr.ShAmt;
    d_funct <= decoded_instr.funct;
    d_immed <= decoded_instr.immed;
    d_jumpa <= decoded_instr.jumpa;

end architecture instruction_arch;
