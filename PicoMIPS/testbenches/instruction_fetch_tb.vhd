-- PCS3412 - Organizacao e Arquitetura de Computadores I
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
    signal address: word_t;
    signal instr:   word_t;
    signal newPC:   word_t;

    signal decoded_instr: instruction_t;
begin
    PC0: entity work.PC port map (
        clk => clk,
        new_address => newPC,
        current_address => address
    );

    U1: entity work.add4 port map(
        in1  => address,
        out1 => newPC
    );

    MP0: entity work.MP generic map (
        filen => "mp_teste_fetch.txt",
        Tread => 5 ns
    ) port map (
        address => address,
        data => instr
    );

    RI0: entity work.RI port map (
        clk => clk,
        new_instruction => instr,
        instruction => decoded_instr
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
        for i in instructions'range loop
            wait for 10 ns; -- MP delay

            assert instr = instructions(i)
                report "instruction error"
                severity error;

            wait for 30 ns;
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
        for i in 1 to 10 loop
            clk <= '0', '1' after 20 ns;
            wait for 40 ns;
        end loop;
        wait;
    end process clock_gen;
end architecture instruction_arch;
