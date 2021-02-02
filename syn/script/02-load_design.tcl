#################################
# SETUP THE DESIGN
#################################

# Check that the design is free of latches:
set hdlin_check_no_latch true

### DEFINE DESIGN FILES #########################################
#
# Set the name of the top-module:
set TOP_LEVEL_MODULE	 "Top_Module_Controller_and_FIR"
#
# List all source files of the design:
set FILE_LIST	{Top_Module_Controller_and_FIR.v Controller_StateMachine.v FIR_Filter_Optimized.v}
#
#################################################################

#set verilogout_no_tri true

# Create subdirectories for temporary files to keep syn folder clean:
if [file exists results] {
  file delete -force results
}
file mkdir results
set_vsdc results/design.vsdc
set_svf  results/design.svf

if [file exists WORK] {
  file delete -force WORK
}
file mkdir WORK
define_design_lib WORK -path ./WORK
