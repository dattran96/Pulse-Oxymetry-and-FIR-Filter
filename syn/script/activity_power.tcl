#################################
# REPORT POWER WITH ANNOTATED SWITCHING ACTIVITY
#################################
# This script can be used to estimate the power consumption of a synthesized design
# based on an activity file for the inputs of the circuit. This activity file can
# be generated using ModelSim based on a testbench with realistic input patterns.

# Define top module name:
set TOP_LEVEL_MODULE	"top_module_name"

saif_map -start

# convert vcd to saif:
sh vcd2saif -i ../src/vcd/activity.vcd -o ../src/vcd/${TOP_LEVEL_MODULE}.saif

# read the design:
read_ddc mapped/${TOP_LEVEL_MODULE}.ddc

# read activity file:
read_saif -input ../src/vcd/${TOP_LEVEL_MODULE}.saif -instance_name ${TOP_LEVEL_MODULE}_tb/${TOP_LEVEL_MODULE}_i -auto_map_names -verbose

# report power consumption:
report_power -analysis_effort high
