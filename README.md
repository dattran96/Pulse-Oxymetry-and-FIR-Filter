# Pulse-Oxymetry-and-FIR-Filter

This project includes the analog-frontend and the digital-backend

************************ Analog-frontend ************************:
- Signal from dual LED( red led and infrared led) will be amplified through an Op-Amp before it's fed into an ADC.<br/>





************************ Digital-backend ************************ 
- Controller written in Verilog to generate control sigals for these above dual LED. <br/>
- FIR Controller written in Verilog to improve the result. <br/>







Guidence:

1. Open Synopsis Design Vision, import verilog top module to generate Netlist for Controller and FIR filter:
  import Top_Module_Controller_and_FIR.v <br/>

2. Open Cadence Encounter, execute the follow file to do floorplan, placement and routing:
  01-setup_tech <br/>
  02-load_design <br/> 
  03-floorplan.tcl <br/>
  04-placement.tcl <br/>
  05-clock_tree.tcl <br/>
  06-route.tcl <br/>
  07-finishing.tcl <br/>
  08-output_files.tcl <br/>
