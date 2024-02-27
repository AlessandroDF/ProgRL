library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity w_reg is
    port(
       i_mem_data   : in std_logic_vector(7 downto 0);
       i_clk        : in std_logic;
       i_rst        : in std_logic;
       en_w_update  : in std_logic;
       
       out_w        : out std_logic_vector(7 downto 0);
       out_c        : out std_logic_vector(7 downto 0)
    );
end entity w_reg;

architecture w_reg_arch of w_reg is
begin
end architecture w_reg_arch;