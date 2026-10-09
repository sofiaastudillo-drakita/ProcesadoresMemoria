set_property SRC_FILE_INFO {cfile:{c:/Users/paula/Downloads/CdeP/FPGA Pipe SW/project_v2sinwrapper/project_v2sinwrapper.gen/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc} rfile:../../../project_v2sinwrapper.gen/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc id:1 order:EARLY scoped_inst:clk_wiz_inst/inst} [current_design]
set_property SRC_FILE_INFO {cfile:{C:/Users/paula/Downloads/CdeP/FPGA Pipe SW/project_v2sinwrapper/project_v2sinwrapper.srcs/constrs_1/imports/ProcesadorPipelinedV2/Nexys4DDR_Master.xdc} rfile:../../../project_v2sinwrapper.srcs/constrs_1/imports/ProcesadorPipelinedV2/Nexys4DDR_Master.xdc id:2} [current_design]
current_instance clk_wiz_inst/inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.100
current_instance
set_property src_info {type:XDC file:2 line:10 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk_100MHz }];
set_property src_info {type:XDC file:2 line:13 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { reset }];      # SW0
