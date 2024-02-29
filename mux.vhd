library IEEE;
use IEEE.std_logic_1164.all;

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
    process(i_clk)
    begin
        -- o_mem_data <= (others => '0');
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