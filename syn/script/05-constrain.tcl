#################################
# CONSTRAIN THE DESIGN
#################################
# IMPORTANT: Nearly all values in this file need to be adapted to your design!
#            You might not need all constraints listed, these are just examples!
#
# The units of the constraints depend on the library used. Typical units are: time = ns, resistance = kOhm, capacitance = pF
# Check the units of your library in the following way:
# - Open DesignVision
# - Source the technology setup script (source 01-setup_tech.tcl)
# - Type: list_lib
# - Find out the name of your library (it may differ from the filename)
# - Type: report_lib library_name

#################################
# Constrain asynchronous reset:
#################################
# ToDo:
# - Change the name of the reset port to match your design
# - Change the values of latency and transition time

# set as ideal net for synthesis
set_ideal_network [get_port rst_n]

# Async reset assertion timing is not important (only the de-assertion is important)
set_false_path -fall_from [get_ports rst_n]

# model latency:
set_ideal_latency -max 0.0  [get_port rst_n]

# model transition:
set_ideal_transition -max 0.03 [get_port rst_n]


#################################
# Constrain clock:
#################################
# ToDo:
# - Change the name of the clock port to match your design
# - Change the clock period to match your design
# - Change the values of the clock model

# Default unit for all timing constraints: ns

# create clock constraint:
create_clock [get_ports clk] -name "CLOCK" -period 1000000

# model clock network insertion delay (from clk root to synchronous elements):
set_clock_latency -max 0.0 [get_clocks CLOCK]

# model clock transisition time:
set_clock_transition -max 0.1 [get_clocks CLOCK]

# model clock uncertainty (jitter + skew):
# HINT: use worst corner for setup and best corner for hold
set_clock_uncertainty -setup 0.03 [get_clocks CLOCK]
set_clock_uncertainty -hold 0.03 [get_clocks CLOCK]


#################################
# (Optional but recommended) Constrain inputs:
#################################
# model input delay:
#set_input_delay -max 2.5  -clock CLOCK [remove_from_collection [all_inputs] clk_sample_in] -network_latency_included
#set_input_delay -min 0.01 -clock CLOCK [remove_from_collection [all_inputs] clk_sample_in] -network_latency_included

# model drive resistance of inputs (unit depends on library, typ. kOhm):
#set_drive -max 1    [remove_from_collection [all_inputs] clk]
#set_drive -min 0.01 [remove_from_collection [all_inputs] clk]


#################################
# (Optional) Special constraints for analog inputs:
#################################
# 1) Ensure it feeds into only one cell (simplification for simulation)
#    So that the input is buffered before being used by multiple downstream cells
#set_max_fanout 1 [get_ports comp]
# 2) Constrain the input capacitance below a limit
#    So that it doesn't overly load the comparator
# **** May want to tweak this value for max_cap ****
#set_max_capacitance 0.05 [get_ports comp]


#################################
# (Optional but recommended) Constrain outputs:
#################################
# model output delay:
#set_output_delay -max 2.5  -clock sar_clock [all_outputs] -network_latency_included
#set_output_delay -min 0.01 -clock sar_clock [all_outputs] -network_latency_included

# model load capacitance (unit depends on library, typ. pF):
#set_load -max -pin_load 0.8  [all_outputs]
#set_load -max -pin_load 0.5  [get_ports *busy*]
#set_load -max -pin_load 0.1  [get_ports *sar_out*]
#set_load -min -pin_load 0.001 [all_outputs]


################################# 
# (Optional) Electrical Design Rule Constraints
# check specification in library
#################################
set_max_transition 1 [all_outputs]
set_max_transition 1 [all_inputs]


#################################
# (Optional) 5% WC OCV Timing Derate
# For local cell and interconnect delay variation
#################################
#set_timing_derate -early 0.95
# Derate applies to cell and incterconnect delays

