# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7z010clg400-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.cache/wt [current_project]
set_property parent.project_path /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_FIFO XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property board_part digilentinc.com:zybo:part0:1.0 [current_project]
set_property ip_output_repo /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  {/home/manosx/Documents/Fifth Exercise/Fifth Exercise.srcs/sources_1/new/debayer.vhd}
  /home/manosx/Documents/dvlsi2021_lab5/vhdl_srcs/design_1_wrapper.vhd
  /home/manosx/Documents/dvlsi2021_lab5/vhdl_srcs/dvlsi2021_lab5_top.vhd
}
add_files /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/design_1.bd
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_PL2PS_DMA_0/design_1_PL2PS_DMA_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_PL2PS_DMA_0/design_1_PL2PS_DMA_0.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_PL2PS_DMA_0/design_1_PL2PS_DMA_0_clocks.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_PL_GEN_ARESETN_50_0/design_1_PL_GEN_ARESETN_50_0_board.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_PL_GEN_ARESETN_50_0/design_1_PL_GEN_ARESETN_50_0.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_PL_GEN_ARESETN_50_0/design_1_PL_GEN_ARESETN_50_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_PL_GEN_ARESETN_100_0/design_1_PL_GEN_ARESETN_100_0_board.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_PL_GEN_ARESETN_100_0/design_1_PL_GEN_ARESETN_100_0.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_PL_GEN_ARESETN_100_0/design_1_PL_GEN_ARESETN_100_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_PS2PL_DMA_0/design_1_PS2PL_DMA_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_PS2PL_DMA_0/design_1_PS2PL_DMA_0.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_PS2PL_DMA_0/design_1_PS2PL_DMA_0_clocks.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_PS_ARM_0/design_1_PS_ARM_0.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_5/bd_afc3_s00a2s_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_8/bd_afc3_m00s2a_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_6/bd_afc3_sarn_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_7/bd_afc3_srn_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_1/bd_afc3_psr_aclk_0_board.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_0/bd_0/ip/ip_1/bd_afc3_psr_aclk_0.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_0/ooc.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_1_0/bd_0/ip/ip_5/bd_a878_s00a2s_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_1_0/bd_0/ip/ip_9/bd_a878_m00s2a_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_1_0/bd_0/ip/ip_6/bd_a878_sawn_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_1_0/bd_0/ip/ip_7/bd_a878_swn_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_1_0/bd_0/ip/ip_8/bd_a878_sbn_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_1_0/bd_0/ip/ip_1/bd_a878_psr_aclk_0_board.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_1_0/bd_0/ip/ip_1/bd_a878_psr_aclk_0.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_axi_smc_1_0/ooc.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_xbar_0/design_1_xbar_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/ip/design_1_auto_pc_0/design_1_auto_pc_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/bd/design_1/design_1_ooc.xdc]

read_ip -quiet /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0.xci
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0.xdc]
set_property used_in_implementation false [get_files -all /home/manosx/Documents/dvlsi2021_lab5/dvlsi2021_ask5_prj/dvlsi2021_ask5_prj.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top dvlsi2021_lab5_top -part xc7z010clg400-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef dvlsi2021_lab5_top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file dvlsi2021_lab5_top_utilization_synth.rpt -pb dvlsi2021_lab5_top_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
