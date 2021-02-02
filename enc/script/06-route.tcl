#################################
# ROUTE
#################################


### SETUP #######################################################
#
# Setup routing layers:
setNanoRouteMode -quiet -routeBottomRoutingLayer 2
setNanoRouteMode -quiet -routeTopRoutingLayer 6
#
#################################################################


# Route design (with default settings):
routeDesign

# Turn off AAE-SI optimization since we are not considering On-Chip Variation (OCV):
setDelayCalMode -engine aae -SIAware false

# Optimize Design setup AND hold:
optDesign -postRoute -outDir reports/timing
optDesign -postRoute -hold -outDir reports/timing

# Minimize Via count and replace single-cut with double-cut vias:
setNanoRouteMode -droutePostRouteMinimizeViaCount true
setNanoRouteMode -droutePostRouteSwapVia multiCut
routeDesign -viaOpt

# Report timing and remaining violations:
timeDesign -postRoute 
timeDesign -postRoute -hold
reportCapViolation
reportTranViolation

# Save the Design:
saveDesign designs/${TOP_LEVEL_MODULE}_routed.enc
