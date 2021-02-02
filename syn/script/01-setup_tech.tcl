#################################
# SETUP TECHNOLOGY FILES
#################################

# add Synopsys libraries and source folder to search path:
set search_path			[concat $search_path				\
					$env(SYNOPSYS)/libraries/syn		\
					../src					\
				]

# Set designer name:
set designer "IES"

# Set maximum number of CPU cores:
set_host_options -max_cores 16

# Define aliases
alias h history
alias rc report_constraint -all_violators

# Clear library lists:
set symbol_library ""
set target_library ""


### TECHNOLOGY DEFINITION #######################################
#
# Print Process name:
puts "UMC 65nm LL process"
#
# Define Technology directory:
set TECH_HOME /cad/synopsys/libs/UMC_65_LL/synopsys
#
# Define Model directory (if different from Technology directory):
# HINT: Always prefer CCS or ECSM models over NLDM model!
set MODEL_HOME ${TECH_HOME}/ccs
#
# Include symbol libraries (can be multiple for different threshold voltages):
lappend symbol_library uk65lscllmvbbh.sdb
lappend symbol_library uk65lscllmvbbl.sdb
lappend symbol_library uk65lscllmvbbr.sdb
#
# Include cell libraries (can be multiple for different threshold voltages):
# Use worst-case corner for implementation to ensure timing is met under all conditions!
lappend target_library uk65lscllmvbbh_108c125_wc_ccs.db
lappend target_library uk65lscllmvbbl_108c125_wc_ccs.db
lappend target_library uk65lscllmvbbr_108c125_wc_ccs.db
#
# (Optional) Typical-case corner can be used instead for rough power estimation:
#lappend target_library uk65lscllmvbbh_120c25_tc_ccs.db
#lappend target_library uk65lscllmvbbl_120c25_tc_ccs.db
#lappend target_library uk65lscllmvbbr_120c25_tc_ccs.db
#################################################################


# Add Technology directory to search path:
lappend search_path "${TECH_HOME}"

# Add model directory to search path:
lappend search_path "${MODEL_HOME}"

# Add DesignWare library:
set synthetic_library [list dw_foundation.sldb standard.sldb]
set link_library [concat  [concat  * $target_library] $synthetic_library]

# Specify the directory for the alib libraries:
set alib_library_analysis_path "[getenv HOME]/synopsys_alib_dir"

# Read in the target libraries:
read_db $target_library
