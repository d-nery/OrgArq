-- PCS3412 - Organizacao e Arquitetura de Computadores II
-- PicoMIPS
-- File:MUL.vhd
-- Author: Beatriz de Oliveira Silva
--
-- Description:
--     Predicao de desvios completo, associando sinais de todos estagios
-- 	   Complete Prediction
--     CP

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


--library work;
--use work.constants.all;
--use work.types.all;

entity cp is 
    port (
		clk : in std_logic;
        in_address: in  std_logic_vector(31 downto 0);
		target_address: inout  std_logic_vector(31 downto 0);
		hit: in std_logic;
		taken_prev: in std_logic;
		taken_dec: in std_logic
    );
end entity cp;

architecture cp_arch of cp is
	signal hiti, taken_previ, taken_deci, erase, enable, penalty: std_logic;
	signal ini_address, targeti_address: std_logic_vector(31 downto 0);
	
	component btb 
	port (
		clk : in std_logic;
        in_address: in  std_logic_vector(31 downto 0);
        target_address: inout  std_logic_vector(31 downto 0);
		hit: out std_logic;
		erase: in std_logic;
		enable: in std_logic
	);
	end component;
	
	signal erasei: std_logic;
	signal enablei: std_logic;
	
	begin
		
		btb1: btb port map (clk => clk, in_address => ini_address, target_address => targeti_address, hit=> hiti, erase => erasei, enable=>enablei );
		
		process(clk)
		begin
		hiti <= hit;
		taken_previ <= taken_prev;
		taken_deci <= taken_dec;
		
		if hiti = '1' then
			penalty <= taken_deci nand taken_previ;
			if penalty = '1' then
				erasei <= '1';
				enablei <= '0';
			else 
				erasei <= '0';
				enablei <= '0';
			end if; 
		else 
			penalty <= taken_deci nor taken_previ;
			if penalty = '0' then
				erasei <= '0';
				enablei <= '0';
			else 
				enablei <= '1';
				erasei <= '0';
			end if;
		end if;
		end process;		
end architecture cp_arch;