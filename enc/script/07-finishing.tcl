#################################
# ROUTE
#################################


# Add filler cells:
addFiller -cell $filler_cells -prefix FILLER

# Reconnect all Power and Ground nets (ensure filler cells are also connected):
clearGlobalNets
globalNetConnect VDD -type pgpin -pin $std_cell_power_name -inst * -module {} -verbose
globalNetConnect VSS -type pgpin -pin $std_cell_ground_name -inst * -module {} -verbose

# Report Geometry violations (will be highlighted in layout):
verifyGeometry

# Fix DRC errors:
addFiller -cell $filler_cells -prefix FILLER -fixDRC

# Report Geometry violations (should be zero now):
verifyGeometry

# Report Connectivity violations:
verifyConnectivity -type all -error 1000 -warning 50

# Report Antenna rule violations:
verifyProcessAntenna -reportfile reports/antenna.txt -error 1000

# Save the Design:
saveDesign designs/${TOP_LEVEL_MODULE}_finished.enc
