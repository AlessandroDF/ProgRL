library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity fsm is
    port(
        i_clk   : in std_logic;
        i_rst   : in std_logic;
        i_start : in std_logic;
        i_k     : in std_logic_vector(9 downto 0);
        o_done      : out std_logic;
        o_en_mux    : out std_logic;
        o_sel_mux   : out std_logic;
        o_w_update  : out std_logic;
        o_k_read    : out std_logic;
        o_k_dec     : out std_logic;
        o_add_read  : out std_logic;
        o_add_inc   : out std_logic;
        o_en_mem    : out std_logic;
        o_mem_wr    : out std_logic;
        o_first_val : out std_logic
    );
end fsm;

architecture fsm_arch of fsm is
    type S is (
        INIT,
        READY,
        MEM_READ_FIRST,
        W_MEM_PREP_FIRST,
        W_MEM_PREP,
        W_UPDATE,
        C_MEM_PREP,
        C_UPDATE,
        MEM_READ,
        DONE
    );
    signal curr_state : S;
begin
    -- Funzione di stato prossimo
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            curr_state <= INIT;
        elsif i_clk'event and i_clk = '1' then
            case curr_state is
                when INIT =>
                    if i_rst = '0' then
                        curr_state <= READY;
                    end if;
                when READY =>
                    if i_start = '1' then
                        curr_state <= MEM_READ_FIRST;
                    end if;
                when MEM_READ_FIRST =>
                    if i_k = "0000000000" then
                        curr_state <= DONE;
                    elsif i_k > "0000000000" then
                        curr_state <= W_MEM_PREP_FIRST;  
                    end if;
                when MEM_READ =>
                    if i_k = "0000000000" then
                        curr_state <= DONE;
                    elsif i_k > "0000000000" then
                        curr_state <= W_MEM_PREP;  
                    end if;
                when W_MEM_PREP_FIRST =>
                    curr_state <= W_UPDATE;
                when W_MEM_PREP =>
                    curr_state <= W_UPDATE;
                when W_UPDATE =>
                    curr_state <= C_MEM_PREP;
                when C_MEM_PREP =>
                    curr_state <= C_UPDATE;
                when C_UPDATE =>
                    curr_state <= MEM_READ;
                when DONE =>
                    if i_start = '0' then
                        curr_state <= READY;
                    end if;
            end case;
        end if;
    end process;
    
    -- Funzione di uscita
    process(curr_state)
    begin
        o_done <= '0';
        o_en_mux <= '0';
        o_sel_mux <= '0';
        o_w_update <= '0';
        o_k_read <= '0';
        o_k_dec <= '0';
        o_add_read <= '0';
        o_add_inc <= '0';
        o_en_mem <= '0';
        o_mem_wr <= '0';
        o_first_val <= '0';

        if curr_state = INIT then
            o_done <= '0';
        elsif curr_state = READY then
            o_k_read <= '1';
            o_add_read <= '1';
        elsif curr_state = MEM_READ_FIRST then
            o_en_mem <= '1';
        elsif curr_state = W_MEM_PREP_FIRST then
            o_first_val <= '1';
            o_w_update <= '1';
        elsif curr_state = W_MEM_PREP then
            o_w_update <= '1';
        elsif curr_state = W_UPDATE then
            o_en_mux <= '1';
            o_sel_mux <= '1';
        elsif curr_state = C_MEM_PREP then
            o_en_mux <= '1';
            o_add_inc <= '1';
            o_en_mem <= '1';
            o_mem_wr <= '1';
        elsif curr_state = C_UPDATE then
            o_k_dec <= '1';
            o_add_inc <= '1';
            o_en_mem <= '1';
            o_mem_wr <= '1';
        elsif curr_state = MEM_READ then
            o_en_mem <= '1';
        elsif curr_state = DONE then
            o_done <= '1';
        end if;
    end process;
end fsm_arch;