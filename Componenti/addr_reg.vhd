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