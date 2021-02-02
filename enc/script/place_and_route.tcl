#################################
# COMPLETE PLACE AND ROUTE FLOW
#################################

# Setup technology libraries:
source script/01-setup_tech.tcl

# Load Design:
source script/02-load_design.tcl

# Floorplan:
source script/03-floorplan.tcl

# Placement:
source script/04-placement.tcl

# Clock Tree Syntehsis:
source script/05-clock_tree.tcl

# Routing:
source script/06-route.tcl

# Chip Finishing (Filler cells...):
source script/07-finishing.tcl

# Output files (netlist, sdf, gds, lef...):
source script/08-output_files.tcl
