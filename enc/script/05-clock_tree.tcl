#################################
# CLOCK TREE SYNTHESIS
#################################

# Setup analysis views:
set_analysis_view -setup {worst} -hold {best}

# Ensure no propagated clock command is active:
set_interactive_constraint_modes timing_constraints
reset_propagated_clock [all_clocks]

#################################
# CTS flow using ck engine (obsolete but still supported)
#################################

# set CTS engine:
#setCTSMode -engine ck

# Create clock tree specification (based on sdc file and buffer list, only once needed):
#createClockTreeSpec -bufferList $clock_buffer_cells -file script/Clock.ctstch

# read Clock tree specification:
#specifyClockTree -file script/Clock.ctstch

# Delete existing clock trees:
#deleteClockTree -all

# synthesize Clock tree:
#clockDesign -specFile script/Clock.ctstch -outDir reports/clock

#################################
# CTS flow using CCOpt engine
#################################

# Define buffer cells:
set_ccopt_property buffer_cells $clock_buffer_cells

# Define inverter cells:
set_ccopt_property inverter_cells $clock_inverter_cells

# Define clock gating cells (optional):
#set_ccopt_property clock_gating_cells $clock_gated_cells

# Enable the use of inverters:
set_ccopt_property use_inverters true

# Create clock tree specification from timing constraints:
create_ccopt_clock_tree_spec

# Run Clock tree synthesis (CTS):
ccopt_design

# Generate reports:
report_ccopt_clock_trees -filename reports/clock/clock_trees.rpt
report_ccopt_skew_groups -filename reports/clock/skew_groups.rpt

# update timing settings to use calculated clock tree delays instead of sdc constraints:
set_interactive_constraint_modes timing_constraints
set_propagated_clock [all_clocks]


### SETUP #######################################################
#
# Set false path for reset to avoid hold time violations (modify name):
set_false_path -from rst_n
#
#################################################################


# optimize Design:
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postCTS -outDir reports/timing
optDesign -postCTS -hold -outDir reports/timing

# Report timing:
timeDesign -postCTS 
timeDesign -postCTS -hold

# Save the Design:
saveDesign designs/${TOP_LEVEL_MODULE}_clocked.enc
