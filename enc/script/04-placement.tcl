#################################
# PLACEMENT
#################################


### SETUP #######################################################
#
# Setup routing layers and trun off optimization of pre-placed pins:
setTrialRouteMode -maxRouteLayer 6 -minRouteLayer 2 -honorPin true
#
#################################################################


# Place Standard cells:
setPlaceMode -fp false
placeDesign -noPrePlaceOpt

# Set Leakage Power optimization mode (low = priority to speed optimization, high = optimize for speed and leakage):
#setOptMode -leakagePowerEffort low
setOptMode -effort high -reclaimArea true -simplifyNetlist false -allEndPoints true

# Add Tie-Hi/Lo Cells:
deleteTieHiLo -cell $tie_cells
setTieHiLoMode -reset
setTieHiLoMode -maxFanout 12 -maxDistance 200 -cell $tie_cells
addTieHiLo -cell $tie_cells

# Optimize Design:
#setOptMode -fixCap true -fixTran true -fixFanoutLoad false
# fix DRV:
optDesign -preCTS -drv
# fix Timing (setup only, can be omitted for non-critical designs):
optDesign -preCTS -outDir reports/timing

# Report timing:
timeDesign -preCTS

# Save the Design:
saveDesign designs/${TOP_LEVEL_MODULE}_placed.enc
