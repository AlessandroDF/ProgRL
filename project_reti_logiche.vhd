library IEEE;
use IEEE.STD_LOGIC_1164.all;

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