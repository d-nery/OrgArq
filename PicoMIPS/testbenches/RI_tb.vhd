-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: RI_tb.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Testbench para o Registrador de Instrucoes

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity RI_tb is
end entity RI_tb;

architecture RI_tb_arch of RI_tb is
    signal clk: std_logic := '0';
    signal instruction: word_t;

    signal decoded_instruction: instruction_t;
begin
    RI0: entity work.RI port map (
        clk => clk,
        new_instruction => instruction,
        instruction => decoded_instruction
    );

    process
        type address_array is array (natural range <>) of word_t;
        type instruction_array is array (natural range <>) of instruction_t;
        constant addresses: address_array := (
            x"A1B2C3D4", x"E5F6AA14", x"12A58EDF", x"36485121", x"ABCDEF12", x"00000000"
        );

        constant instructions: instruction_array := (
            (opcode => "101000", Rs => "01101", Rt => "10010", Rd => "11000", ShAmt => "01111", funct => "010100", immed => x"C3D4", jumpa => "01101100101100001111010100"),
            (opcode => "111001", Rs => "01111", Rt => "10110", Rd => "10101", ShAmt => "01000", funct => "010100", immed => x"AA14", jumpa => "01111101101010101000010100"),
            (opcode => "000100", Rs => "10101", Rt => "00101", Rd => "10001", ShAmt => "11011", funct => "011111", immed => x"8EDF", jumpa => "10101001011000111011011111"),
            (opcode => "001101", Rs => "10010", Rt => "01000", Rd => "01010", ShAmt => "00100", funct => "100001", immed => x"5121", jumpa => "10010010000101000100100001"),
            (opcode => "101010", Rs => "11110", Rt => "01101", Rd => "11101", ShAmt => "11100", funct => "010010", immed => x"EF12", jumpa => "11110011011110111100010010"),
            (opcode => "000000", Rs => "00000", Rt => "00000", Rd => "00000", ShAmt => "00000", funct => "000000", immed => x"0000", jumpa => "00000000000000000000000000")
        );
    begin
        for i in addresses'range loop
            instruction <= addresses(i);
            wait for 40 ns;

            assert decoded_instruction.opcode = instructions(i).opcode
                report "Error on RI assertion"
                severity error;
        end loop;
        report "End of RI testbench";
        wait;
    end process;

    clock_gen: process
    begin
        for i in 1 to 6 loop
            clk <= '0', '1' after 20 ns;
            wait for 40 ns;
        end loop;
        wait;
    end process clock_gen;
end architecture RI_tb_arch;
