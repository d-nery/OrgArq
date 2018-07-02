-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: MP.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Contem a inicializacao da memoria principal do projetos
--     a partir de um arquivo de texto no formato especificado

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library STD;
use STD.textio.all;

library work;
use work.constants.all;
use work.types.all;

entity MP is
    generic (
        filen:  in string;
        Tread:  in time := 50 ns;
        Twrite: in time := 50 ns
    );
    port (
        address:   in  word_t;
        data_i:    in  word_t;
        data_o:    out word_t;
        mem_ready: out std_logic := '0';
        enable:    in  std_logic;
        mem_write: in  std_logic
    );
end entity MP;

architecture MP_arch of MP is
    -- Funcao que carrega um arquivo txt de memoria
    -- Formato:
    --     [END] [Numero de Words] [Comentarios]
    --     [Dado1] [Dado2] ... [Dadon] [Comentarios]
    impure function parse_mp(filename: string) return memory_t is
        file fp: text open READ_MODE is filename;

        variable buff: line;

        variable address_v:   word_t;
        variable data_v:      word_t;
        variable count:       integer := 0;
        variable it:          integer := 0;

        variable temp_memory: memory_t := (others => (others => '0'));
    begin
        while not endfile(fp) loop
            -- Le primeira linha
            readline(fp, buff);
            hex_read(buff, address_v);
            read(buff, count);

            it := to_integer(unsigned(address_v));
            readline(fp, buff);
            for i in 1 to count loop
                hex_read(buff, data_v);
                temp_memory(it) := data_v;
                it := it + 1;
            end loop;
        end loop;
        return temp_memory;
    end function;

    signal main_memory: memory_t := parse_mp(filename => filen);

begin
    -- byte index -> word index
    process (enable) begin
        if rising_edge(enable) then
            if mem_write = '0' then
                data_o <= main_memory(to_integer(unsigned(address(31 downto 2)))) after Tread;
                mem_ready <= '1' after Tread;
            elsif mem_write = '1' then
                main_memory(to_integer(unsigned(address(31 downto 2)))) <= data_i after Twrite;
                mem_ready <= '1' after Twrite;
            end if;
        end if;

        if falling_edge(enable) then
            mem_ready <= '0';
        end if;
    end process;
end architecture MP_arch;
