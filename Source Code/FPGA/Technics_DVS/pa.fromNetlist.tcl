
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name DVS -dir "C:/Xilinx/Projects/Technics_DVS/planAhead_run_1" -part xc6slx9tqg144-2
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Xilinx/Projects/Technics_DVS/Main_assy.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Xilinx/Projects/Technics_DVS} }
set_property target_constrs_file "C:/Xilinx/Projects/Technics_DVS/DVS/XC6SLX9.ucf" [current_fileset -constrset]
add_files [list {C:/Xilinx/Projects/Technics_DVS/DVS/XC6SLX9.ucf}] -fileset [get_property constrset [current_run]]
open_netlist_design
