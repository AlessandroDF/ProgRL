-- PROVA FINALE
-- Progetto di Reti Logiche
--
-- Politecnico di Milano
-- Corso di laurea in ingegneria informatica
-- A.A.: 2023/2024
--
-- Alessandro Del Fatti
-- C.P.: 10790553

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity project_reti_logiche is
    port (
            i_clk : in std_logic;
            i_rst : in std_logic;
            i_start : in std_logic;
            i_add : in std_logic_vector(15 downto 0);
            i_k   : in std_logic_vector(9 downto 0);
            
            o_done : out std_logic;
            
            o_mem_addr : out std_logic_vector(15 downto 0);
            i_mem_data : in  std_logic_vector(7 downto 0);
            o_mem_data : out std_logic_vector(7 downto 0);
            o_mem_we   : out std_logic;
            o_mem_en   : out std_logic
    );
end entity project_reti_logiche;

architecture project_reti_logiche_arch of project_reti_logiche is
    component addr_reg is
        port(
            i_addr      : in std_logic_vector(15 downto 0);
            i_clk       : in std_logic;
            i_rst       : in std_logic;
            en_add_inc  : in std_logic;
            en_add_read : in std_logic;
    
            o_mem_addr  : out std_logic_vector(15 downto 0)
        );
    end component addr_reg;
    component fsm is
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
    end component fsm;
    component k_val_reg is
        port(
            i_k         : in std_logic_vector(9 downto 0);
            i_clk       : in std_logic;
            i_rst       : in std_logic;
            en_k_read   : in std_logic;
            en_k_dec    : in std_logic;
            
            o_k_val     : out std_logic_vector(9 downto 0)
        );
    end component k_val_reg;
    component mux is
        port(
            in_w        : in std_logic_vector(7 downto 0);
            in_c        : in std_logic_vector(4 downto 0);
            en_mux      : in std_logic;
            sel_mux     : in std_logic;
            i_clk       : in std_logic;
            i_rst       : in std_logic;
    
            o_mem_data  : out std_logic_vector(7 downto 0)
        );
    end component mux;
    component w_reg is
        port(
            i_mem_data   : in std_logic_vector(7 downto 0);
            i_clk        : in std_logic;
            i_rst        : in std_logic;
            i_first_val  : in std_logic;
            en_w_update  : in std_logic;
            
            out_w        : out std_logic_vector(7 downto 0);
            out_c        : out std_logic_vector(4 downto 0)
         );
    end component w_reg;

    signal en_add_inc : std_logic;
    signal en_add_read : std_logic;
    signal en_k_dec : std_logic;
    signal en_k_read : std_logic;
    signal w : std_logic_vector(7 downto 0);
    signal c : std_logic_vector(4 downto 0);
    signal k : std_logic_vector(9 downto 0);
    signal en_w_update : std_logic;
    signal en_mux : std_logic;
    signal sel_mux : std_logic;
    signal fv : std_logic;
begin 
    addreg : addr_reg port map(
        i_addr => i_add,
        i_clk => i_clk,   
        i_rst => i_rst,
        en_add_inc => en_add_inc,
        en_add_read => en_add_read,
        o_mem_addr => o_mem_addr
    );
    fsm_1 : fsm port map(
        i_clk => i_clk,
        i_rst => i_rst,
        i_start => i_start,
        i_k => k,
        o_done => o_done,
        o_en_mux => en_mux,
        o_sel_mux => sel_mux,
        o_w_update => en_w_update,
        o_k_read => en_k_read,
        o_k_dec => en_k_dec,
        o_add_read => en_add_read,
        o_add_inc => en_add_inc,
        o_en_mem => o_mem_en,
        o_mem_wr => o_mem_we,
        o_first_val => fv
    );
    kreg : k_val_reg port map(
        i_k => i_k,
        i_clk => i_clk,
        i_rst => i_rst,
        en_k_read => en_k_read,
        en_k_dec => en_k_dec,
        o_k_val => k
    );
    mux_1 : mux port map(
        in_w => w,
        in_c => c, 
        en_mux => en_mux,
        sel_mux => sel_mux,
        i_clk => i_clk,
        i_rst => i_rst,
        o_mem_data => o_mem_data
    );
    wreg : w_reg port map(
        i_mem_data => i_mem_data,
        i_clk => i_clk,
        i_rst => i_rst,
        i_first_val => fv,
        en_w_update => en_w_update,
        out_w => w,
        out_c => c
    );
end architecture project_reti_logiche_arch;

-- FSM
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
                        curr_state <= MEM_READ;
                    end if;
                when MEM_READ =>
                    if i_k = "0000000000" then
                        curr_state <= DONE;
                    elsif i_k > "0000000000" then
                        curr_state <= W_MEM_PREP;  
                    end if;
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
            -- Lo stato di ready indica che avviene una prima lettura
            o_first_val <= '1';
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

-- ADDR_REG
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
entity addr_reg is
    port(
        i_addr      : in std_logic_vector(15 downto 0);
        i_clk       : in std_logic;
        i_rst       : in std_logic;
        en_add_inc  : in std_logic;
        en_add_read : in std_logic;
        o_mem_addr  : out std_logic_vector(15 downto 0)
    );
end entity addr_reg;

architecture addr_reg_arch of addr_reg is
    signal stored_addr : std_logic_vector(15 downto 0);
begin
    o_mem_addr <= stored_addr;
    process(i_rst, i_clk)
    begin
        if i_rst = '1' then
            stored_addr <= (others => '0');
        elsif i_clk'event AND i_clk = '1' then
            if en_add_read = '1' then
                stored_addr <= i_addr;
            end if;
            if en_add_inc = '1' then
                stored_addr <= stored_addr + "0000000000000001";
            end if;
        end if;
    end process;
end architecture addr_reg_arch;

-- K_REG
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
entity k_val_reg is
    port(
        i_k         : in std_logic_vector(9 downto 0);
        i_clk       : in std_logic;
        i_rst       : in std_logic;
        en_k_read   : in std_logic;
        en_k_dec    : in std_logic;
        o_k_val     : out std_logic_vector(9 downto 0)
    );
end entity k_val_reg;

architecture k_val_reg_arch of k_val_reg is
    signal stored_k : std_logic_vector(9 downto 0);
begin
    o_k_val <= stored_k;
    process(i_rst, i_clk)
    begin
        if i_rst = '1' then
            stored_k <= (others => '0');
        elsif i_clk'event AND i_clk = '1' then
            if en_k_read = '1' then
                stored_k <= i_k;
                -- Quando non lo aggiorno più, essendo un segnale
                -- mi rimane un elemento di memoria e conserva il valore
            end if;
            if en_k_dec = '1' then
                if stored_k > 0 then
                    stored_k <= stored_k - "0000000001";
                end if;
            end if;
        end if;
    end process;
end architecture k_val_reg_arch;

-- W_REG
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
entity w_reg is
    port(
       i_mem_data   : in std_logic_vector(7 downto 0);
       i_clk        : in std_logic;
       i_rst        : in std_logic;
       i_first_val  : in std_logic;
       en_w_update  : in std_logic;
       out_w        : out std_logic_vector(7 downto 0);
       out_c        : out std_logic_vector(4 downto 0)
    );
end entity w_reg;

architecture w_reg_arch of w_reg is
    signal stored_w : std_logic_vector(7 downto 0);
    signal stored_c : std_logic_vector(4 downto 0);
begin
    out_w <= stored_w;
    out_c <= stored_c;
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            stored_w <= (others => '0');
            stored_c <= (others => '0');
        elsif i_clk'event and i_clk = '1' then
            if i_first_val = '1' then
                -- Serve anche qui l'inizializzazione perchè, per letture successiva
                -- non è necessario passare per lo stato di reset. Ma ho comunque
                -- bisogno di avere inizializzati a 0 i due segnali (per gestire la
                -- prima lettura)
                stored_w <= (others => '0');
                stored_c <= (others => '0');
            elsif en_w_update = '1' then
                if i_mem_data = "00000000" then
                    -- Non aggiorno stored_w perchè deve mantenere il
                    -- valore aveva precedentemente
                    if stored_c > "00000" then
                        stored_c <= stored_c - "00001";
                    end if;
                elsif i_mem_data > "00000000" then
                    stored_w <= i_mem_data;
                    stored_c <= "11111";
                end if;
            end if;
        end if;
    end process;
end architecture w_reg_arch;

-- MUX
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
entity mux is
    port(
        in_w        : in std_logic_vector(7 downto 0);
        in_c        : in std_logic_vector(4 downto 0);
        en_mux      : in std_logic;
        sel_mux     : in std_logic;
        i_clk       : in std_logic;
        i_rst       : in std_logic;
        o_mem_data  : out std_logic_vector(7 downto 0)
    );
end entity mux;

architecture mux_arch of mux is
begin
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            o_mem_data <= (others => '0');
        end if;
        if i_clk'event AND i_clk = '1' then
            if en_mux = '1' then -- Modifica effettuata post-funzionamento (1)
                if sel_mux = '1' then
                    o_mem_data <= in_w;
                elsif sel_mux = '0' then
                    o_mem_data <= "000" & in_c;
                end if;
            end if;
        end if;
    end process;
end architecture mux_arch;