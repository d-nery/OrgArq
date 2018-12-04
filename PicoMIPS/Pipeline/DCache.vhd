-- PCS3422 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File: ICache.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Cache para Memoria de Dados
-- Nao testado ainda

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;

use work.constants.all;
use work.types.all;

entity DCache is
    generic (
        Taccess: in time := 5 ns
    );
    port (
        clk:    in std_logic;

        -- From/To UC/FD
        uc_enable: in  std_logic;
        uc_write:  in  std_logic;
        uc_addr:   in  word_t;
        uc_ready:  out std_logic;
        uc_data_o: out word_t;
        uc_data_i: in  word_t;

        -- From/To Memory
        mem_enable: out std_logic;
        mem_write:  out std_logic;
        mem_ready:  in  std_logic;
        mem_addr:   out word_t;
        mem_data_o: out word_t;
        mem_data_i: in  word_t
    );
end entity DCache;

architecture DCache_arch of DCache is
    constant cache_size: positive := 2**14; -- 4096*4 bytes
    constant block_size: positive := 2**6;  -- 64 bytes/bloco
    constant associativity: positive := 2;

    constant words_per_block: positive := block_size / 4;
    constant nb_blocks: positive := cache_size / block_size / associativity; -- 128 blocos

    type set_t is array(0 to words_per_block - 1) of word_t; -- Palavras do bloco
    type entry_t is record -- Cache entries
        valid: boolean;
        dirty: boolean;
        tag:   natural;
        data:  set_t;
    end record entry_t;

    type cache_t is array (0 to nb_blocks - 1, 0 to associativity - 1) of entry_t;

begin
    cache_loop: process
        variable cache:       cache_t;
        variable uc_address:  natural;
        variable word_offset: natural range 0 to words_per_block - 1;
        variable block_index: natural range 0 to nb_blocks - 1;
        variable uc_tag:      natural;
        variable entry_index: natural range 0 to associativity - 1;
        variable hit:         boolean;
        variable next_entry:  natural range 0 to associativity - 1 := 0;

    -- procedures
    procedure read_hit is
    begin
        uc_data_o <= cache(block_index, entry_index).data(word_offset);
        uc_ready  <= '1' after Taccess;
        wait until clk = '0';
        uc_ready  <= '0' after Taccess;
    end procedure read_hit;

    procedure write_hit is
    begin
        cache(block_index, entry_index).data(word_offset) := uc_data_i;
        cache(block_index, entry_index).dirty := true;
        uc_ready  <= '1' after Taccess;
        wait until clk = '0';
        uc_ready  <= '0' after Taccess;
    end procedure write_hit;

    procedure write_back is
        variable next_addr:   natural;
        variable old_woffset: natural;
    begin
        next_addr := (cache(block_index, entry_index).tag * nb_blocks + block_index) * block_size;
        wait until clk = '1';
        mem_write  <= '1';
        old_woffset := 0;

        write_l: loop
            mem_enable <= '1';
            mem_addr   <= std_logic_vector(to_unsigned(next_addr, mem_addr'length));
            mem_data_o <= cache(block_index, entry_index).data(old_woffset);

            wait_l: loop
                exit write_l when (mem_ready = '1' and old_woffset = words_per_block - 1);
                exit wait_l  when mem_ready = '1';
            end loop wait_l;

            old_woffset  := old_woffset + 1;
            next_addr := next_addr + 4;
            mem_enable <= '0';
            wait for 2 ns;
        end loop write_l;

        cache(block_index, entry_index).dirty := false;
        mem_write <= '0';
        mem_enable <= '0';
    end procedure write_back;

    procedure read_block is
        variable next_addr: natural;
        variable new_woffset: natural;
    begin
        next_addr := uc_address;
        wait until clk = '1';
        mem_write   <= '0';
        new_woffset := 0;

        read_l: loop
            mem_enable <= '1';
            mem_addr <= std_logic_vector(to_unsigned(next_addr, mem_addr'length));

            wait until mem_ready = '1';

            cache(block_index, entry_index).data(new_woffset) := mem_data_i;

            if new_woffset = words_per_block - 1 then
                exit read_l;
            end if;

            new_woffset := new_woffset + 1;
            next_addr := next_addr + 4;
            mem_enable <= '0';
            wait for 2 ns;

        end loop read_l;

        cache(block_index, entry_index).valid := true;
        cache(block_index, entry_index).tag   := uc_tag;
        cache(block_index, entry_index).dirty := false;
        mem_enable <= '0';
    end procedure read_block;

    procedure replace_block is
    begin
        entry_index := next_entry;
        next_entry := (next_entry + 1) mod associativity;

        if cache(block_index, entry_index).dirty then
            write_back;
        end if;
        read_block;
    end procedure replace_block;

    procedure read_miss is
    begin
        replace_block;
        read_hit;
    end procedure read_miss;

    procedure write_miss is
    begin
        replace_block;
        write_hit;
    end procedure write_miss;

    begin
        -- Initialize cache signals
        uc_ready   <= '0';
        uc_data_o  <= (others => '0');
        mem_enable <= '0';
        mem_write  <= '0';
        mem_addr   <= (others => '0');
        mem_data_o <= (others => '0');

        -- Initialize cache entries
        for i in natural range 0 to nb_blocks - 1 loop
            for j in natural range 0 to associativity - 1 loop
                cache(i, j).dirty := false;
                cache(i, j).valid := false;
            end loop;
        end loop;

        -- Begin
        main_loop: loop
            -- Wait for UC
            wait until clk = '1' and uc_enable = '1';

            -- Decode address
            uc_address  := to_integer(unsigned(uc_addr));
            word_offset := (uc_address mod block_size) / 4;
            block_index := (uc_address / block_size) mod nb_blocks;
            uc_tag      := uc_address / block_size / nb_blocks;

            -- Check hit
            hit := false;
            for i in natural range 0 to associativity - 1 loop
                if cache(block_index, i).valid and cache(block_index, i).tag = uc_tag then
                    hit := true;
                    entry_index := i;
                    exit;
                end if;
            end loop;

            if hit then
                if uc_write = '1' then
                    write_hit;
                else
                    read_hit;
                end if;
            else
                if uc_write = '1' then
                    write_miss;
                else
                    read_miss;
                end if;
            end if;
        end loop main_loop;

    end process cache_loop;

end architecture DCache_arch;
