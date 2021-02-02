#################################
# FLOORPLAN
#################################


# Connect P/G Nets (GUI: Power -> Connect Global Nets...):
clearGlobalNets
globalNetConnect VDD -type pgpin -pin $std_cell_power_name -inst * -module {}
globalNetConnect VSS -type pgpin -pin $std_cell_ground_name -inst * -module {}
globalNetConnect VSS -type tielo -pin $std_cell_ground_name -inst * -module {}
globalNetConnect VDD -type tiehi -pin $std_cell_power_name -inst * -module {}


### FLOORPLAN INIT ##############################################
#
# Initialize floorplan based on aspect ratio (Height/Width) and utilization as a first step (GUI: Floorplan -> Specify Floorplan...):
floorPlan -site CORE -r 1 0.6 5.8 5.8 5.8 5.8
#
# Later use fixed dimensions to ensure everything is on the placement grid (height must be multiple of standard cell height!):
#floorPlan -site CORE -s 30 28.8 5.8 5.8 5.8 5.8
#
# Add power ring (pin access on every corner) (GUI: Power -> Power Planning -> Add Ring):
addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer ME8 -type core_rings -jog_distance 0.1 -threshold 0.1 -nets {VDD VSS } -follow core -stacked_via_bottom_layer ME1 -layer {bottom ME5 top ME5 right ME6 left ME6} -width 2 -spacing 0.5 -offset 0.5 -extend_corner {lt tl tr lb bl br rb rt}
addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer ME8 -type core_rings -jog_distance 0.1 -threshold 0.1 -nets {VDD VSS } -follow core -stacked_via_bottom_layer ME1 -layer {bottom ME3 top ME3 right ME4 left ME4} -width 2 -spacing 0.5 -offset 0.5
addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer ME8 -type core_rings -jog_distance 0.1 -threshold 0.1 -nets {VDD VSS } -follow core -stacked_via_bottom_layer ME1 -layer {bottom ME1 top ME1 right ME2 left ME2} -width 2 -spacing 0.5 -offset 0.5
#
# Route standard cell power rails (GUI: Route -> Special Route...):
sroute -connect { corePin } -layerChangeRange { ME1 ME7 } -blockPinTarget { nearestTarget } -checkAlignedSecondaryPin 1 -allowJogging 1 -crossoverViaBottomLayer ME1 -allowLayerChange 1 -targetViaTopLayer ME7 -crossoverViaTopLayer ME7 -targetViaBottomLayer ME1 -nets { VDD VSS }
#
# Add Power stripes:
# Vertical:
#addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit ME7 -max_same_layer_jog_length 4 -padcore_ring_bottom_layer_limit ME5 -set_to_set_distance 17.4 -skip_via_on_pin Standardcell -stacked_via_top_layer ME8 -padcore_ring_top_layer_limit ME7 -spacing 1 -xleft_offset 17.4 -merge_stripes_value 0.1 -layer ME6 -block_ring_bottom_layer_limit ME5 -width 1 -nets {VDD VSS} -stacked_via_bottom_layer ME1
# Horizontal:
#addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit ME8 -max_same_layer_jog_length 4 -padcore_ring_bottom_layer_limit ME6 -number_of_sets 1 -ybottom_offset 19.35 -skip_via_on_pin Standardcell -stacked_via_top_layer ME8 -padcore_ring_top_layer_limit ME8 -spacing 0.5 -merge_stripes_value 0.1 -direction horizontal -layer ME7 -block_ring_bottom_layer_limit ME6 -ytop_offset 19.35 -width 2 -nets {VDD VSS} -stacked_via_bottom_layer ME6
#
# Define pin locations (GUI: Edit -> Pin Editor):
#editPin -pin clk_sample_in -use CLOCK
#editPin -pinWidth 0.1 -pinDepth 0.52 -fixOverlap 1 -fixedPin 1 -unit MICRON -spreadDirection clockwise -side Left -layer 3 -spreadType start -spacing 0.2 -start 0.0 18.65 -pin {clk_pi_in}
#editPin -pinWidth 0.1 -pinDepth 0.52 -fixOverlap 1 -fixedPin 1 -unit MICRON -spreadDirection clockwise -side Left -layer 3 -spreadType start -spacing 1.8 -start 0.0 8.735 -pin {clk_dll_n_in clk_dll_in}
#editPin -pinWidth 0.1 -pinDepth 0.52 -fixOverlap 1 -fixedPin 1 -unit MICRON -spreadDirection clockwise -side Left -layer 3 -spreadType start -spacing 1.8 -start 0.0 26.925 -pin {clk_ref_n_in clk_ref_in}
#editPin -fixOverlap 1 -fixedPin 1 -unit MICRON -spreadDirection clockwise -side Top -layer 4 -spreadType center -spacing 6 -pin {clk_sample_in rst_n}
#editPin -pinWidth 0.1 -pinDepth 0.52 -fixOverlap 1 -fixedPin 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 4 -spreadType center -spacing 1.5 -pin {{phase_ref_out[0]} {phase_dll_out[0]} {phase_pi_out[0]} {phase_ref_out[1]} {phase_dll_out[1]} {phase_pi_out[1]} {phase_ref_out[2]} {phase_dll_out[2]} {phase_pi_out[2]} {phase_ref_out[3]} {phase_dll_out[3]}  {phase_pi_out[3]} clk_out {phase_ref_out[4]} {phase_dll_out[4]} {phase_pi_out[4]} {phase_ref_out[5]} {phase_dll_out[5]} {phase_pi_out[5]}}
#
#################################################################


# Add well taps:
setPrerouteAsObs {1 2 3 4 5 6 7 8}
addWellTap -cell $well_tap_cell -cellInterval 30 -prefix WELLTAP
verifyWellTap -cell $well_tap_cell -rule 30 -report welltap.rpt


### FLOORPLAN PLACEMENT #########################################
#
# Preplace registers (structured data path):
#readSdpFile -file script/pdc_regs.sdp
#setPlaceMode -sdpPlace true
#setPlaceMode -sdpAlignment true
#placeSdpGroup
#
# Place Macros and Plan Groups:
#relativePlace cfg_mem_i_cfg_sram_i CORE -orientation R90 -relation L -alignedBy B -xSpace 0.00 -ySpace 0.00
#addHaloToBlock 4 4 4 4 -allBlock
#setObjFPlanBox Module reg_file_i 90.0 7.000 232.0 148.12
#setObjFPlanBox Module alu_i 90.0 148.12 232.0 217.0
#
#################################################################


# Fit to screen:
fit

# Postprocessing:
fixVia -minCut
fillNotch

# Write floorplan def file:
defOut -floorplan output/${TOP_LEVEL_MODULE}_fp.def
