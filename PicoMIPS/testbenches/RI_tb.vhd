-- RI testbench

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;

entity RI_tb is
end RI_tb;

architecture RI_tb_arch of RI_tb is
    component RI is
        port (
            clk:             in  std_logic;
            new_instruction: in  std_logic_vector(31 downto 0);

            opcode:          out std_logic_vector(5 downto 0);
            field1:          out std_logic_vector(4 downto 0);
            field2:          out std_logic_vector(4 downto 0);
            field3:          out std_logic_vector(4 downto 0);
            field4:          out std_logic_vector(4 downto 0);
            field5:          out std_logic_vector(5 downto 0)
        );
    end component RI;

    signal clk: std_logic := '0';
    signal instruction: reg_t;

    signal f1, f2, f3, f4: std_logic_vector(4 downto 0) := (others => '0');
    signal opcode, f5: std_logic_vector(5 downto 0) := (others => '0');
begin
    RI0: RI port map (
        clk => clk,
        new_instruction => instruction,
        field1 => f1,
        field2 => f2,
        field3 => f3,
        field4 => f4,
        field5 => f5
    );

    process
        type address_range is array (natural range <>) of reg_t;
        constant addresses: address_range := (
            x"A1B2C3D4", x"E5F6AA14", x"12A58EDF", x"36485121", x"ABCDEF12", x"00000000",
            x"FFFFFFFF", x"ABCE65F8", x"9415FC25", x"14A5C1E2", x"FF59A51C", x"20000FE5",
            x"EFFFFFFF", x"25145984", x"21456982", x"12024879", x"ABE89C12", x"A25C9E2F"
        );
    begin
        for i in addresses'range loop
            instruction <= addresses(i);
            wait for 40 ns;

            -- assert current_address = addresses(i)
            --     report "Error on RI assertion"
            --     severity error;
        end loop;
        assert false report "End of RI testbench" severity failure;
        wait;
    end process;

    clock_gen: process
    begin
        clk <= '0', '1' after 20 ns;
        wait for 40 ns;
    end process clock_gen;
end RI_tb_arch;
