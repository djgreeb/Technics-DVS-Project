
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name DVS -dir "C:/Xilinx/Projects/Technics_DVS/planAhead_run_1" -part xc6slx9tqg144-2
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "C:/Xilinx/Projects/Technics_DVS/DVS/XC6SLX9.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {DVS/Main_assy.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top Main_assy $srcset
add_files [list {C:/Xilinx/Projects/Technics_DVS/DVS/XC6SLX9.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx9tqg144-2
