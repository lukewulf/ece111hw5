set_property PACKAGE_PIN G19 [get_ports rst]
set_property PACKAGE_PIN E15 [get_ports y]
set_property PACKAGE_PIN U15 [get_ports clk]

create_clock -period 5.500 -name clk -waveform {0.000 2.750} [get_ports clk]