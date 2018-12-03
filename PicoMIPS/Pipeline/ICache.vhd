-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: ICache.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Cache para Memoria de instrucoes

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;

use work.constants.all;
use work.types.all;

entity ICache is
    generic (
        Taccess: in time := 5 ns
    );
    port (
        clk:    in std_logic;
        enable: in std_logic;

        -- From UC/FD
        read_addr: in  word_t;
        data_out:  out word_t := (others => '0');
        uc_done:   out std_logic;

        -- From MP
        mem_addr:   out word_t := (others => '0');
        mem_data:   in  word_t;
        mem_ready:  in  std_logic;
        mem_enable: out std_logic;
        mem_write:  out std_logic
    );
end entity ICache;

architecture ICache_arch of ICache is
    constant cache_size: positive := 2**14; -- 4096*4 bytes
    constant block_size: positive := 2**6;  -- 64 bytes/bloco

    constant words_per_block: positive := block_size / 4;
    constant nb_blocks:       positive := cache_size / block_size; -- 256 blocos

    type set_t is array(0 to words_per_block - 1) of word_t; -- Palavras do bloco
    type entry_t is record -- Cache entries
        valid: boolean;
        tag:   natural;
        data:  set_t;
    end record entry_t;

    type cache_t is array (0 to nb_blocks - 1) of entry_t;

    -- Apenas leitura da memória
    type state_t is (INIT, SLEEP, GET_DATA, READ_MISS, DONE);

    signal cache: cache_t; -- actual cache
    signal state: state_t   := INIT;
    signal s_hit: std_logic := '0';

    -- Debug
    signal state_s: std_logic_vector(2 downto 0) := "000";

begin
    cache_loop: process (clk)
        variable tag:          natural;
        variable index:        natural range 0 to nb_blocks - 1;
        variable offset:       natural range 0 to words_per_block - 1;
        variable word_offset:  natural range 0 to words_per_block - 1;
        variable cpu_addr:     integer;
        variable hit:          boolean;
        variable mem_addr_tmp: word_t := (others => '0');
    begin
        if rising_edge(clk) then
            case state is
                when INIT =>
                    state_s <= "000";
                    mem_write <= '0'; -- Always read
                    for i in 0 to nb_blocks - 1 loop
                        cache(i).valid <= false;
                    end loop;
                    state <= SLEEP;

                when SLEEP =>
                    state_s <= "001";
                    uc_done  <= '0';
                    s_hit    <= '0';
                    hit      := false;
                    word_offset := 0;
                    mem_enable <= '0';
                    if enable = '1' then
                        state <= GET_DATA;
                    end if;

                when GET_DATA =>
                    state_s <= "010";
                    cpu_addr := to_integer(unsigned(read_addr));

                    offset := (cpu_addr mod block_size) / 4;
                    index  := (cpu_addr / block_size) mod nb_blocks;
                    tag    := cpu_addr / block_size / nb_blocks;

                    -- Check hit
                    if (cache(index).valid = true and cache(index).tag = tag) then
                        hit   := true;
                        s_hit <= '1';
                    end if;

                    if hit then
                        data_out <= cache(index).data(offset) after Taccess;
                        uc_done <= '1' after Taccess;
                        state <= DONE;
                    else -- MISS
                        mem_addr_tmp := std_logic_vector(to_unsigned((to_integer(unsigned(read_addr)) / block_size) * block_size, mem_addr_tmp'length));
                        state        <= read_miss;
                        mem_addr     <= mem_addr_tmp;
                        mem_enable   <= '1';
                    end if;

                when READ_MISS =>
                    state_s <= "011";

                    if mem_ready = '1' then
                        cache(index).data(word_offset) <= mem_data;
                        -- Se preecnheu linha, termina
                        if (word_offset = words_per_block - 1) then
                            cache(index).valid <= true;
                            cache(index).tag   <= tag;
                            data_out           <= cache(index).data(offset) after Taccess;
                            uc_done            <= '1' after Taccess;
                            state <= DONE;
                        else
                            word_offset := word_offset + 1;
                            mem_addr_tmp := std_logic_vector(to_unsigned(to_integer(unsigned(mem_addr_tmp)) + 4, mem_addr_tmp'length));
                            mem_addr     <= mem_addr_tmp;
                            mem_enable   <= '0', '1' after 1 ns;
                        end if;
                    end if;

                when DONE =>
                    state_s <= "100";
                    uc_done <= '0';
                    mem_enable <= '0';
                    if enable = '0' then
                        state <= SLEEP;
                    end if;
            end case;
        end if;
    end process cache_loop;

end architecture ICache_arch;
