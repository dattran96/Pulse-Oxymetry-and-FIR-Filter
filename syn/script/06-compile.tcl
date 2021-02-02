#################################
# COMPILE THE DESIGN
#################################

# optimize for area:
#set_max_area 0

check_timing

# compile:
compile_ultra
# if some submodules should not be ungrouped use this:
#ungroup -start_level 2 -all
#compile_ultra -no_autoungroup

# naming rules:
change_names -rules verilog -hierarchy

# write mapped .ddc file:
write -hierarchy -format ddc -output mapped/${TOP_LEVEL_MODULE}.ddc

# export mapped design as verilog netlist file for gate-level simulation:
write -hierarchy -format verilog -output netlist/${TOP_LEVEL_MODULE}_gl.v

# export timing annotations:
write_sdf netlist/${TOP_LEVEL_MODULE}_timing.sdf
write_sdc netlist/${TOP_LEVEL_MODULE}_timing.sdc
