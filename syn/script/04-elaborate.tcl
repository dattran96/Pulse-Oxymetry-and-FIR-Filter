#################################
# ELABORATE THE DESIGN
#################################

elaborate ${TOP_LEVEL_MODULE} -architecture verilog -library WORK

set_fix_multiple_port_nets -all -buffer_constants

### WIRE LOAD MODEL #############################################
#
# You can determine the available wire load models of a technology
# in the following way:
# - execute 01-setup_tech.tcl
# - type "list_lib"
# - find out the correct library name
# - type "report_lib library_name"
# This list all available modes, selection groups and models.
# If no specific model is specified, DC automatically chooses a
# model (HINT: this is typically the most optimistic model available!).
#
# Set wire load model mode (can be: top, segmented, enclosed):
set_wire_load_mode top
#
# Set wire load model selection group (if available):
#set_wire_load_selection_group group_name
#
# Set wire load model (check the library):
set_wire_load_model -name wl10
#
#################################################################

# Check design and write out a report:
# This contains all the warnings that can lead to potential problems in your design.
check_design            > reports/${TOP_LEVEL_MODULE}_check_design.txt
