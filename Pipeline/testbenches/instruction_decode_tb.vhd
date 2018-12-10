-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: instruction_decode_tb.vhd
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

entity instruction_decode_tb is
end entity instruction_decode_tb;

architecture instruction_arch of instruction_decode_tb is
    signal clk       : std_logic := '0';
    signal reg_write : std_logic := '0';

    signal reg_write_index : nibble_t;
    signal reg_write_data  : word_t;

    signal reg_data1 : word_t;
    signal reg_data2 : word_t;

    signal immed_ext : word_t;
    signal rt : nibble_t;
    signal rd : nibble_t;
    signal shamt : std_logic_vector(04 downto 0);

    signal instruction : instruction_t;
begin
    instr_decode: entity work.instruction_decode port map (
        clk => clk,

        reg_write       => reg_write,
        reg_write_index => reg_write_index,
        reg_write_data  => reg_write_data,

        reg_data1 => reg_data1,
        reg_data2 => reg_data2,

        immed_ext => immed_ext,
        rt        => rt,
        rd        => rd,
        shamt     => shamt,

        instruction => instruction,

        pc4 => (others => '0')
    );

    test: process
        type dec_instruction_array is array (natural range <>) of instruction_t;

        constant instructions: dec_instruction_array := (
            (opcode => "000000", Rs => "00000", Rt => "00001", Rd => "00001", ShAmt => "00000", funct => "000000", immed => x"0820", jumpa => "00010000110000100000100000"),
            (opcode => "000000", Rs => "00010", Rt => "00011", Rd => "00001", ShAmt => "00000", funct => "000000", immed => x"0822", jumpa => "00010000110000100000100010"),
            (opcode => "000000", Rs => "00100", Rt => "00101", Rd => "00000", ShAmt => "00000", funct => "000000", immed => x"0030", jumpa => "00011000100000000000110000"),
            (opcode => "000000", Rs => "00110", Rt => "00111", Rd => "00001", ShAmt => "00000", funct => "000000", immed => x"082A", jumpa => "00010000110000100000101010"),
            (opcode => "000000", Rs => "01000", Rt => "01001", Rd => "11000", ShAmt => "01111", funct => "000000", immed => x"C3D4", jumpa => "01101100101100001111010100"),
            (opcode => "000000", Rs => "01010", Rt => "01011", Rd => "11000", ShAmt => "01111", funct => "000000", immed => x"C3D4", jumpa => "00010000111100001111010100"),
            (opcode => "000000", Rs => "01100", Rt => "01101", Rd => "10100", ShAmt => "01011", funct => "000000", immed => x"A2C3", jumpa => "00010000111010001011000011"),
            (opcode => "000000", Rs => "01110", Rt => "01111", Rd => "10100", ShAmt => "01011", funct => "000000", immed => x"A2C3", jumpa => "00011000101010001011000011"),
            (opcode => "000000", Rs => "10000", Rt => "10001", Rd => "00010", ShAmt => "00010", funct => "000000", immed => x"1080", jumpa => "00000000110001000010000000"),
            (opcode => "000000", Rs => "10010", Rt => "10011", Rd => "00010", ShAmt => "00010", funct => "000000", immed => x"1082", jumpa => "00000000110001000010000010")
        );

    begin
        -- wait for 50 ns;

        for i in instructions'range loop
            wait for 5 ns;
            reg_write <= '1';

            wait for 5 ns;
            reg_write_data <= x"89ABCDEF";
            reg_write_index <= instructions(i).Rs(03 downto 0);

            wait for 5 ns;
            reg_write_index <= instructions(i).Rt(03 downto 0);

            wait for 5 ns;
            reg_write <= '0';

            wait for 5 ns;
            instruction <= instructions(i);

            wait for 10 ns;

            assert reg_data1 = x"89ABCDEF" and reg_data2 = x"89ABCDEF"
                report "Error!" severity error;
        end loop;

        report "End of Instruction Decode testbench";
        wait;
    end process test;

    clock_gen: process
    begin
        clk <= '0', '1' after 5 ns;
        wait for 10 ns;
    end process clock_gen;
end architecture instruction_arch;
