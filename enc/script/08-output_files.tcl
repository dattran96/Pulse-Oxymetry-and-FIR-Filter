#################################
# OUTPUT FILES
#################################


########################
# PARASITICS EXTRACTION
########################

# Setup Engine:
setExtractRCMode -engine postRoute -effortLevel high -coupled true -capFilterMode relAndCoup -coupling_c_th 0.1 -total_c_th 0 -relative_c_th 1

# Set analysis views (include typical view):
set_analysis_view -setup {worst typ} -hold {best}

# Report Timing:
timeDesign -postRoute
timeDesign -postRoute -hold

# Extract parasitics:
extractRC

# Create parasitics files:
rcOut -spef output/${TOP_LEVEL_MODULE}.rcmax.spef -rc_corner worst
rcOut -spef output/${TOP_LEVEL_MODULE}.rcmin.spef -rc_corner best
rcOut -spef output/${TOP_LEVEL_MODULE}.rctyp.spef -rc_corner typ


########################
# POWER ANALYSIS
########################

# Setup analysis mode for typical corner:
set_power_analysis_mode -method static -analysis_view typ -corner max -create_binary_db true -write_static_currents true -honor_negative_energy true -ignore_control_signals true

# Report output directory:
set_power_output_dir reports/power


### SETUP #######################################################
#
# Define switching activity and dominant frequency:
# Activity: at least ever 32nd cycle -> 0.03125 + some glitches -> 0.4
set_default_switching_activity -input_activity 0.04 -period 0.4
#
# (Optional) Read in an activity file:
read_activity_file -reset
#
#################################################################


# Analyze power:
report_power -rail_analysis_format VS -outfile reports/power/${TOP_LEVEL_MODULE}_power.txt


########################
# OTHER OUTPUT FILES
########################

# Write GDSII file (if standard cell layouts are not available in virtuoso: use the option "-merge {hvt_file_name.gds lvt_file_name.gds rvt_file_name.gds}" to merge layouts):
streamOut output/${TOP_LEVEL_MODULE}.gds -mapFile encounter_gds.map -libName DesignLib -structureName ${TOP_LEVEL_MODULE} -dieAreaAsBoundary -mode ALL

# Write netlist files (normal, with P/G nets, physical):
saveNetlist output/${TOP_LEVEL_MODULE}.v -excludeLeafCell
saveNetlist -includePowerGround -includePhysicalInst output/${TOP_LEVEL_MODULE}.pg.v
saveNetlist -phys output/${TOP_LEVEL_MODULE}.phys.v

# Write SDF file:
write_sdf -max_view worst -min_view best -typ_view typ -precision 5 output/${TOP_LEVEL_MODULE}.sdf

# Write LEF file:
lefOut output/${TOP_LEVEL_MODULE}.lef

# Write DEF file:
defOut -floorplan -netlist -routing output/${TOP_LEVEL_MODULE}.def

# Write .lib file (takes a lot of time):
#set_global timing_extract_model_slew_propagation_mode worst_slew
#do_extract_model output/${TOP_LEVEL_MODULE}.lib -lib_name ${TOP_LEVEL_MODULE} -cell_name ${TOP_LEVEL_MODULE} -tolerance 0.0 -verilog_shell_file output/${TOP_LEVEL_MODULE}.v -verilog_shell_module ${TOP_LEVEL_MODULE}

# Write Timing Model report (takes a lot of time):
#write_model_timing -type arc ${TOP_LEVEL_MODULE}.rpt
