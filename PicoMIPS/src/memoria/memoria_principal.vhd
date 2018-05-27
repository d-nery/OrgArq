-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: memoria_principal.vhd
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

entity MP is
    port (
        address: in  std_logic_vector(2**14 - 1 downto 0);
        data:    out std_logic_vector(31 downto 0)
    );
end MP;

architecture MP_arch of MP is
    -- 2**14 palavras de 32 bits
    type memory_t is array(0 to 2**14 - 1) of std_logic_vector(data'length - 1 downto 0);

    -- Funcao que carrega um arquivo txt de memoria
    -- Formato:
    --     [END] [Numero de Words] [Comentarios]
    --     [Dado1] [Dado2] ... [Dadon] [Comentarios]
    impure function parse_mp(filename: string) return memory_t is
        type hex_table is array (character range '0' to 'F') of integer;

        constant hex_to_int: hex_table :=
            (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, -1, -1, -1, -1, -1, -1, -1, 10, 11, 12, 13, 14, 15);

        file fp: text open READ_MODE is filename;

        variable buff: line;

        variable address_string: string(9 downto 1);
        variable address_v:      std_logic_vector(31 downto 0);
        variable data_string:    string(9 downto 1);
        variable data_v:         std_logic_vector(31 downto 0);
        variable count:          integer := 0;
        variable it:             integer := 0;

        variable temp_memory:    memory_t := (others => (others => '0'));
    begin
        while not endfile(fp) loop
            -- Le primeira linha
            readline(fp, buff);
            read(buff, address_string);
            read(buff, count);

            address_v := std_logic_vector(to_unsigned(
                hex_to_int(address_string(9)) * 268435456 +
                hex_to_int(address_string(8)) * 16777216 +
                hex_to_int(address_string(7)) * 1048576 +
                hex_to_int(address_string(6)) * 65536 +
                hex_to_int(address_string(5)) * 4096 +
                hex_to_int(address_string(4)) * 256 +
                hex_to_int(address_string(3)) * 16 +
                hex_to_int(address_string(2)) * 1, address_v'length));

            it := to_integer(unsigned(address_v));

            -- Le segunda linha
            readline(fp, buff);
            for i in 1 to count loop
                read(buff, data_string);

                data_v := std_logic_vector(to_unsigned(
                    hex_to_int(data_string(9)) * 268435456 +
                    hex_to_int(data_string(8)) * 16777216 +
                    hex_to_int(data_string(7)) * 1048576 +
                    hex_to_int(data_string(6)) * 65536 +
                    hex_to_int(data_string(5)) * 4096 +
                    hex_to_int(data_string(4)) * 256 +
                    hex_to_int(data_string(3)) * 16 +
                    hex_to_int(data_string(2)) * 1, data_v'length));

                temp_memory(it) := data_v;
                it := it + 1;
            end loop;
        end loop;

        return temp_memory;
    end function;

    constant main_memory: memory_t := parse_mp(filename => "memoria/memoria_principal.txt");

begin
    --
    data <= main_memory(to_integer(unsigned(address)));

end MP_arch;
