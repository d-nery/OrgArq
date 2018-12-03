library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--library work;
--use work.constants.all;
--use work.types.all;

-- entity declaration for your testbench.Dont declare any ports here
entity multb is
end multb;

architecture behavior of multb is

	component mul
		port
		(
		clk : in std_logic;
        in1, in2: in  std_logic_vector(31 downto 0);
        result:   out std_logic_vector(63 downto 0)
		);
	end component;

   --declare inputs and initialize them
   signal clk : std_logic := '0';
   signal i: integer := 0;
   signal in1, in2, partial: std_logic_vector(31 downto 0);
   signal result: std_logic_vector(63 downto 0); 
   -- Clock period definitions
   constant clk_period : time := 10 ns;
    
begin
	mul_portmap: mul port map (in1 => in1, in2 => in2, clk => clk, result => result);

	in1 <= "00000000000000000000000000000011";
	partial<= "00000000000000000000000000000001";

	-- Clock process definitions( clock with 50% duty cycle is generated here.
	clk_process :process
	begin
		clk <= '0';
		wait for clk_period/2;  --for 5 ns signal is '0'.
		clk <= '1';
		wait for clk_period/2;  --for next 5 ns signal is '1'.
	end process;

	-- Stimulus process
	stim_proc: process
	begin       
			wait for clk_period;
		in2<= "00000000000000000000000000000001";
			wait for clk_period;
		in2 <= "00000000000000000000000000000010";
			wait for clk_period;
		in2<= "00000000000000000000000000000011";
		assert false report "Reached end of test";
			wait;
	end process;

end behavior;