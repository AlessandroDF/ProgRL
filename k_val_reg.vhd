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
        
        o_k_val     : out std_logic_vector(15 downto 0)
    );
end entity k_val_reg;

architecture k_val_reg_arch of k_val_reg is
    signal stored_k : std_logic_vector(15 downto 0);
begin
    o_k_val <= stored_k;
    process(i_rst, i_clk)
        if i_clk'event AND i_clk = '1' then
            if en_k_read = '1' then
                stored_k <= i_k;
                -- Quando non lo aggiorno più, essendo un segnale
                -- mi rimane un elemento di memoria e conserva il valore
            end if;
            if en_k_dec = '1' then
                if stored_k > 0 then
                    stored_k <= stored_k - "0000000000000001"
                end if;
            end if;
        end if;
    end process;
end architecture k_val_reg_arch;