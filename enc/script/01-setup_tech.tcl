#################################
# SETUP TECHNOLOGY LIBRARIES
#################################

# Enable multi CPU usage:
setMultiCpuUsage -localCpu 4 -cpuPerRemoteHost 1 -remoteHost 0 -keepLicense true
setDistributeHost -local


### TECH FILE SETUP #############################################
#
# Set Process node:
setDesignMode -process 65
#
# Setup LEF files (Tech-file first):
# Add LEF files for macros (e.g. SRAM, I/O pads, IP cores) here.
set init_lef_file {/cad/synopsys/libs/UMC_65_LL/lef/tf/u065gioll33gpir_8m1t0f1u.lef /cad/synopsys/libs/UMC_65_LL/lef/uk65lscllmvbbr.lef /cad/synopsys/libs/UMC_65_LL/lef/uk65lscllmvbbl.lef /cad/synopsys/libs/UMC_65_LL/lef/uk65lscllmvbbh.lef}
#
# Define Power and Ground pin names (as defined in standard cell library):
set std_cell_power_name VDD
set std_cell_ground_name VSS
#
# Define Well-tap cell name:
set well_tap_cell WT3R
#
# Define Tie-Hi/Lo cell names:
set tie_cells {TIE1R TIE0R}
#
# ---------------------------------------------------------------
# Define filler cell names (here, only regular-Vt cells are being used to avoid minimum distance violations on implant layers):
#
# Choose this line for fillers with integrated decoupling capacitors (less power supply ripple, but increased leakage power):
# IMPORTANT: There are different types of capacitors (NMOS and PMOS, PMOS only...) in the library to tune the capacitance/leakage tradeoff. Also HVT or LVT cells can be used if power is a major concern.
set filler_cells "FILE64R FILE32R FILE16R FILE8R FILE6R FILE4R FILE3R FIL2R FIL1R"
#
# Choose this line for fillers without capacitors (for ultra-low power designs):
#set filler_cells "FILE64R FILE32R FILE16R FILE8R FILE6R FILE4R FILE3R FIL2R FIL1R"
# ---------------------------------------------------------------
#
# Define clock tree buffer cell names:
set clock_buffer_cells {CKBUFM12R CKBUFM12S CKBUFM12W CKBUFM16R CKBUFM16S CKBUFM16W CKBUFM1R CKBUFM1S CKBUFM1W CKBUFM20R CKBUFM20S CKBUFM20W CKBUFM22RA CKBUFM22SA CKBUFM22WA CKBUFM24R CKBUFM24S CKBUFM24W CKBUFM26RA CKBUFM26SA CKBUFM26WA CKBUFM2R CKBUFM2S CKBUFM2W CKBUFM32R CKBUFM32S CKBUFM32W CKBUFM3R CKBUFM3S CKBUFM3W CKBUFM40R CKBUFM40S CKBUFM40W CKBUFM48R CKBUFM48S CKBUFM48W CKBUFM4R CKBUFM4S CKBUFM4W CKBUFM6R CKBUFM6S CKBUFM6W CKBUFM8R CKBUFM8S CKBUFM8W DEL1M1R DEL1M1S DEL1M1W DEL1M4R DEL1M4S DEL1M4W DEL2M1R DEL2M1S DEL2M1W DEL2M4R DEL2M4S DEL2M4W DEL3M1R DEL3M1S DEL3M1W DEL3M4R DEL3M4S DEL3M4W DEL4M1R DEL4M1S DEL4M1W DEL4M4R DEL4M4S DEL4M4W}
#
# Define clock tree inverter cell names:
set clock_inverter_cells {CKINVM12R CKINVM12S CKINVM12W CKINVM16R CKINVM16S CKINVM16W CKINVM1R CKINVM1S CKINVM1W CKINVM20R CKINVM20S CKINVM20W CKINVM22RA CKINVM22SA CKINVM22WA CKINVM24R CKINVM24S CKINVM24W CKINVM26RA CKINVM26SA CKINVM26WA CKINVM2R CKINVM2S CKINVM2W CKINVM32R CKINVM32S CKINVM32W CKINVM3R CKINVM3S CKINVM3W CKINVM40R CKINVM40S CKINVM40W CKINVM48R CKINVM48S CKINVM48W CKINVM4R CKINVM4S CKINVM4W CKINVM6R CKINVM6S CKINVM6W CKINVM8R CKINVM8S CKINVM8W}
#
#################################################################


# Define power and ground net names:
set init_gnd_net {VSS}
set init_pwr_net {VDD}

# Setup timing and SI libraries, corners, analysis views, extraction techfiles:
# Defines worst corner libraries for setup analysis and best corner libraries for hold analysis.
set init_mmmc_file {script/analysis.view}

# Default settings (generated using File -> Import Design...):
set ::TimeLib::tsgMarkCellLatchConstructFlag 1
set defHierChar {/}
set distributed_client_message_echo {1}
set gpsPrivate::dpgNewAddBufsDBUpdate 1
set gpsPrivate::lsgEnableNewDbApiInRestruct 1
set init_design_settop 0
set init_oa_search_lib {}
set lsgOCPGainMult 1.000000
set pegDefaultResScaleFactor 1.000000
set pegDetailResScaleFactor 1.000000
set timing_library_float_precision_tol 0.000010
set timing_library_load_pin_cap_indices {}
set tso_post_client_restore_command {update_timing ; write_eco_opt_db ;}


