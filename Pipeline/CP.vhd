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
		hit: in std_logic;
		taken_prev: in std_logic;
		taken_dec: in std_logic
    );
end entity cp;

architecture cp_arch of cp is
	signal hiti, taken_previ, taken_deci, erase, enable, penalty: std_logic;
	signal in_address, out_address: std_logic_vector(31 downto 0);
	
	component btb 
	port (
		clk : in std_logic;
        in_address: in  std_logic_vector(31 downto 0);
        out_address: out  std_logic_vector(31 downto 0);
		hit: out std_logic;
		erase: in std_logic;
		enable: in std_logic
	);
	end component;
	
	begin	
		hiti <= hit;
		taken_previ <= taken_prev;
		taken_deci <= taken_dec;
		
		if hiti = '1' then
			penalty <= taken_deci nand taken_previ;
			if penalty = '0' then
				btb1: btb port map(clk => clk, in_address => in_address, out_address => out_address, hit=> hiti, erase => '0', enable=>'0' );
			else 
				btb2: btb port map(clk => clk, in_address => in_address, out_address => out_address, hit=> hiti, erase => '1', enable=>'0' );
		else 
			penalty <= taken_deci nor taken_previ;
			if penalty = '0' then
				btb3: btb port map(clk => clk, in_address => in_address, out_address => out_address, hit=> hiti, erase => '0', enable=>'0' );
			else 
                btb4: btb port map(clk => clk, in_address => in_address, out_address => out_address, hit=> hiti, erase => '0', enable=>'1' );
end architecture cp_arch;