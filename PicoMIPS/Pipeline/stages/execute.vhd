-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: instruction_fetch.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Estágio de execução

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.types.all;

entity execute is
    port (
        clk: in std_logic;

        pc4:         in  word_t;
        branch_addr: out word_t;

        shamt:  in std_logic_vector(04 downto 0);
        rdata1: in word_t;
        rdata2: in word_t;
        immed:  in word_t;

        alu_control: in  nibble_t;
        alu_result:  out word_t;
        alu_zero:    out std_logic;

        alu_src1:    in std_logic;
        alu_src2:    in std_logic;

        rt: in nibble_t;
        rd: in nibble_t;

        wb_src:   in  std_logic;
        wb_index: out nibble_t
    );
end entity execute;

architecture execute_arch of execute is
    signal shamt_ext : word_t := (others => '0');
    signal alu_in1 :   word_t := (others => '0');
    signal alu_in2 :   word_t := (others => '0');
    signal sll1:       word_t := (others => '0');

begin
    SE_shamt: entity work.sign_extend generic map (
        in_n => 5
    ) port map (
        in1  => shamt,
        out1 => shamt_ext
    );

    M1: entity work.mux2 port map (
        in1    => rdata2,
        in2    => immed,
        out1   => alu_in2,
        choice => alu_src2
    );

    M2: entity work.mux2 port map (
        in1    => rdata1,
        in2    => shamt_ext,
        out1   => alu_in1,
        choice => alU_src1
    );

    M3: entity work.mux2 generic map (
        n => 4
    ) port map (
        in1    => rt,
        in2    => rd,
        out1   => wb_index,
        choice => wb_src
    );

    ULA: entity work.ULA port map (
        in1     => alu_in1,
        in2     => alu_in2,
        control => alu_control,
        result  => alu_result,
        zero    => alu_zero
    );

    sll1  <= immed(29 downto 0) & "00";
    branch_addr <= std_logic_vector(unsigned(pc4) + unsigned(sll1));

end architecture execute_arch;
