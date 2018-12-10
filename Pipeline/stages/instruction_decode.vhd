-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: instruction_fetch.vhd
-- Author: Daniel Nery Silva de Oliveira
-- Collaboration: Beatriz de Oliveira Silva
-- Collaboration: Bruno Henrique Vasconcelos Lemos
-- Collaboration: João Raphael de Souza Morales
--
-- Description:
--     Estágio de decodificação de instruções

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.types.all;

entity instruction_decode is
    port (
        clk: in std_logic;

        reg_write:       in std_logic := '0';
        reg_write_index: in nibble_t  := (others => '0');
        reg_write_data:  in word_t    := (others => '0');

        reg_data1: out word_t := (others => '0');
        reg_data2: out word_t := (others => '0');

        immed_ext: out word_t                        := (others => '0');
        rt:        out nibble_t                      := (others => '0');
        rd:        out nibble_t                      := (others => '0');
        shamt:     out std_logic_vector(04 downto 0) := (others => '0');
        jumpa:     out word_t                        := (others => '0');

        instruction: in instruction_t;

        -- PC + 4
        pc4: in word_t := (others => '0')
    );
end entity instruction_decode;

architecture instruction_decode_arch of instruction_decode is
begin
    RB: entity work.register_bank port map (
        clk       => clk,
        reg_write => reg_write,

        write_index => reg_write_index,

        read_index1 => instruction.rs(03 downto 0),
        read_index2 => instruction.rt(03 downto 0),

        write_data => reg_write_data,

        read_data1 => reg_data1,
        read_data2 => reg_data2
    );

    SE: entity work.sign_extend port map (
        in1  => instruction.immed,
        out1 => immed_ext
    );

    shamt <= instruction.ShAmt;
    rt    <= instruction.rt(03 downto 0);
    rd    <= instruction.rd(03 downto 0);
    jumpa <= pc4(31 downto 28) & (instruction.jumpa & "00");
end architecture instruction_decode_arch;
