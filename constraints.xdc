set_property PACKAGE_PIN G19 [get_ports rst]
set_property PACKAGE_PIN E15 [get_ports y]
set_property PACKAGE_PIN U15 [get_ports clk]

create_clock -period 7.00 -name clk -waveform {0.000 3.5} [get_ports clk]