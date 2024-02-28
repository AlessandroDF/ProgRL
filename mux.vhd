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
    signal stored_w : std_logic_vector(7 downto 0);
    signal stored_c : std_logic_vector(4 downto 0);
begin
    in_w <= stored_w;
    in_c <= stored_c;
    process(i_clk, en_mux, sel_mux)
    begin
        o_mem_data <= (others => '0');
        if i_clk'event AND i_clk = '1' then
            if en_mux = '1' then
                case sel is
                    when '1' => o_mem_data <= stored_w;
                    when '0' => o_mem_data <= "000" & stored_c;
                end case;
            end if;
        end if;
    end process;
end architecture mux_arch;