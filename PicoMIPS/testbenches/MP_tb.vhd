-- Tesbench
-- Memoria Principal

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity MP_tb is
end entity MP_tb;

architecture MP_tb_arch of MP_tb is
    signal address: word_t;
    signal data: word_t;
begin
    MP0: entity work.MP generic map (
        filen => "mp_teste.txt"
    ) port map (
        address => address,
        data => data
    );

    process
        type address_range is array (natural range <>) of word_t;
        constant addresses: address_range := (
            x"00000000", x"00000001", x"00000002", x"00000003", x"00000004", x"00000005",
            x"00000010", x"00000011", x"00000012", x"00000013", x"00000014", x"00000015"
        );

        constant memories: address_range := (
            x"1000A1CD", x"100026EF", x"10000369", x"100014AC", x"00000000", x"00000000",
            x"2000FFFF", x"20000001", x"20000215", x"0200AECD", x"2000FDEA", x"20001068"
        );
    begin
        for i in addresses'range loop
            address <= addresses(i);
            wait for 60 ns;

            assert data = memories(i)
                report "Error on MP assertion"
                severity error;
        end loop;
        report "End of MP testbench";
        wait;
    end process;
end architecture MP_tb_arch;
