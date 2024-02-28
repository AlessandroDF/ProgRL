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
        if i_clk'event and i_clk = '1' then
            if i_mem_data = "00000000" then
                if en_w_update = '1' then
                    if i_first_val = '1' then
                        stored_w <= i_mem_data;
                        stored_c <= "00000";
                    elsif i_first_val = '0' then
                        -- Non aggiorno stored_w perchè deve mantenere il
                        -- valore aveva precedentemente
                        if stored_c > "00000" then
                            stored_c <= stored_c - "00001";
                        end if;
                    end if;
                end if;
            elsif i_mem_data > "00000000" then
                if en_w_update = '1' then
                    stored_w <= i_mem_data;
                    stored_c <= "11111";
                end if;
            end if;
        end if;
    end process;
end architecture w_reg_arch;