-- PCS3412 - Organizacao e Arquitetura de Computadores I
-- PicoMIPS
-- File: UC.vhd
-- Author: Daniel Nery Silva de Oliveira
--
-- Description:
--     Entidade da Unidade de Controle

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.constants.all;
use work.types.all;

entity UC is
    port (
        clk:   in  std_logic;
        rst:   in  std_logic;
        pc_wr: out std_logic;

        icache_en:   out std_logic;
        icache_done: in  std_logic;

        opcode: in std_logic_vector(5 downto 0);
        funct:  in std_logic_vector(5 downto 0);

        reg_write:   out std_logic;

        mux_alusrc1: out std_logic;
        mux_alusrc2: out std_logic;
        mux_rbwr:    out std_logic;
        mux_wb:      out std_logic;
        mux_mem_src: out std_logic;
        mux_pcsrc1:  out std_logic;
        mux_pcsrc2:  out std_logic;

        ula_zero:    in  std_logic;
        ula_control: out nibble_t;

        dcache_ready: in  std_logic;
        dcache_wr:    out std_logic;
        dcache_en:    out std_logic
    );
end entity UC;

architecture UC_arch of UC is
    --                0000   0001    0010      0011       0100
    type estado_t is (IDLE, FETCH, EXECUTE, DMEM_WAIT, WRITE_BACK);

    signal current_state: estado_t := IDLE;
    signal next_state:    estado_t := IDLE;

    signal wb_should_reg_write: std_logic := '0';

    -- Mapped state for debugging purposes
    signal d_current_state: nibble_t         := (others => '0');
    signal d_current_execute_state: nibble_t := (others => '0');

begin
    cycle: process (clk, rst)
    begin
        if rst = '1' then
            current_state <= IDLE;    -- async reset
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process cycle;

    state: process (clk, opcode, icache_done, dcache_ready)
    begin
        case current_state is
            when IDLE =>
                next_state <= FETCH;

            when FETCH  =>
                if icache_done = '1' then
                    next_state <= EXECUTE;
                end if;

            when EXECUTE =>
                if opcode = OP_LW or opcode = OP_SW then
                    next_state <= DMEM_WAIT;
                else
                    next_state <= WRITE_BACK;
                end if;

            when DMEM_WAIT =>
                if dcache_ready = '1' then
                    next_state <= WRITE_BACK;
                end if;

            when WRITE_BACK =>
                next_state <= FETCH;
        end case;
    end process state;

    decode: process (current_state, opcode, funct)
    begin
        case current_state is
            when IDLE =>
                d_current_state <= "0000";

                pc_wr <= '0';

                icache_en <= '0';
                reg_write <= '0';

                mux_alusrc1 <= MUX_ALUSRC1_RB;
                mux_alusrc2 <= MUX_ALUSRC2_RB;
                mux_rbwr    <= MUX_RBWR_RT;
                mux_wb      <= MUX_WB_ULA;
                mux_mem_src <= MUX_MEM_IC;
                mux_pcsrc1  <= '0';
                mux_pcsrc2  <= '0';

                ula_control <= ULA_AND;

                dcache_wr <= '0';
                dcache_en <= '0';

                wb_should_reg_write <= '0';

            when FETCH =>
                d_current_state <= "0001";

                pc_wr <= '0';

                icache_en <= '1';
                reg_write <= '0';
                wb_should_reg_write <= '0';

                mux_rbwr    <= MUX_RBWR_RT;
                mux_alusrc1 <= MUX_ALUSRC1_RB;
                mux_alusrc2 <= MUX_ALUSRC2_RB;
                mux_wb      <= MUX_WB_ULA;
                mux_mem_src <= MUX_MEM_IC;
                mux_pcsrc1  <= '0';
                mux_pcsrc2  <= '0';

                ula_control <= ULA_AND;

                dcache_wr <= '0';
                dcache_en <= '0';

            when EXECUTE =>
                d_current_state <= "0010";

                pc_wr <= '0';

                icache_en <= '0';

                mux_wb      <= MUX_WB_ULA;
                mux_mem_src <= MUX_MEM_DC;

                dcache_wr <= '0';
                dcache_en <= '0';

                case opcode is
                    when OP_R =>
                        d_current_execute_state <= "0001";

                        mux_rbwr    <= MUX_RBWR_RD;

                        mux_pcsrc1  <= '0';
                        mux_pcsrc2  <= '1';

                        wb_should_reg_write <= '1';

                        case funct is
                            when FUNC_ADD =>
                                ula_control <= ULA_ADD;
                                mux_alusrc2 <= MUX_ALUSRC2_RB;

                            when FUNC_ADDU =>
                                ula_control <= ULA_ADDU;
                                mux_alusrc2 <= MUX_ALUSRC2_RB;

                            when FUNC_SLL =>
                                ula_control <= ULA_SLL;
                                mux_alusrc1 <= MUX_ALUSRC1_SHAMT;
                                mux_alusrc2 <= MUX_ALUSRC2_RB;

                            when FUNC_SLT =>
                                ula_control <= ULA_SLT;
                                mux_alusrc1 <= MUX_ALUSRC1_RB;
                                mux_alusrc2 <= MUX_ALUSRC2_RB;

                            when others =>
                        end case;

                    when OP_ADDI =>
                        d_current_execute_state <= "0010";

                        ula_control <= ULA_ADD;
                        mux_rbwr    <= MUX_RBWR_RT;
                        mux_alusrc2 <= MUX_ALUSRC2_IMMED;

                        mux_pcsrc1  <= '0';
                        mux_pcsrc2  <= '1';

                        wb_should_reg_write <= '1';

                    when OP_SLTI =>
                        d_current_execute_state <= "0011";

                        ula_control <= ULA_SLT;
                        mux_rbwr    <= MUX_RBWR_RT;
                        mux_alusrc2 <= MUX_ALUSRC2_IMMED;

                        mux_pcsrc1  <= '0';
                        mux_pcsrc2  <= '1';

                        wb_should_reg_write <= '1';

                    when OP_J =>
                        d_current_execute_state <= "0100";

                        mux_pcsrc1  <= '0';
                        mux_pcsrc2  <= '0';

                        wb_should_reg_write <= '0';

                    when OP_LW =>
                        d_current_execute_state <= "0101";
                        wb_should_reg_write <= '1';

                        mux_rbwr    <= MUX_RBWR_RT;
                        mux_alusrc1 <= MUX_ALUSRC1_RB;
                        mux_alusrc2 <= MUX_ALUSRC2_IMMED;
                        mux_wb      <= MUX_WB_DC;

                        mux_mem_src <= MUX_MEM_DC;

                        mux_pcsrc1  <= '0';
                        mux_pcsrc2  <= '1';

                        ula_control <= ULA_ADD;

                        dcache_wr <= '0';
                        
                    when others =>
                        d_current_execute_state <= "0000";
                        
                end case;
                
            when DMEM_WAIT =>
                dcache_en <= '1' after 10 ns;
                d_current_state <= "0011";
                
            when WRITE_BACK =>
                dcache_en <= '0';
                d_current_state <= "0100";
                pc_wr           <= '1';
                reg_write       <= wb_should_reg_write;

        end case;
    end process decode;
end architecture UC_arch;
