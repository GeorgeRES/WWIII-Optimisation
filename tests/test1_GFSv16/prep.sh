#!/bin/bash
set -eux

HOME=${PWD}

source default_vars.sh
source edit_inputs.sh


#-----------------------------------------------------------------------------------#
#                           1- Fill namelist templates                              #
#-----------------------------------------------------------------------------------#
echo -e "\e[36mFill namelist templates\e[0m"
#inp prep
edit_ww3_multi < parm/ww3_multi.inp.IN > input/ww3_multi_grdset_a.inp
edit_ww3_fld < parm/ww3_gint.inp.IN > input/ww3_gint_grdset_a.inp
edit_ww3_fld < parm/ww3_ounf.inp.IN > input/ww3_ounf.inp
edit_ww3_fld < parm/ww3_grib_gnh_10m.inp.IN > input/ww3_grib_gnh_10m.inp
edit_ww3_fld < parm/ww3_grib_gsh_15m.inp.IN > input/ww3_grib_gsh_15m.inp
edit_ww3_fld < parm/ww3_grib_aoc_9km.inp.IN > input/ww3_grib_aoc_9km.inp
edit_ww3_fld < parm/ww3_grib_glo_15mxt.inp.IN > input/ww3_grib_glo_15mxt.inp
edit_ww3_ounp < parm/ww3_ounp.inp.IN > input/ww3_ounp_points.inp
echo -e "\e[34minputs templates are filled\e[0m"
#-----------------------------------------------------------------------------------#
#ww3_grid parameters
edit_ww3_grid < parm/ww3_grid_gnh_10m.inp.IN > input/ww3_grid_gnh_10m.inp
edit_ww3_grid < parm/ww3_grid_gsh_15m.inp.IN > input/ww3_grid_gsh_15m.inp
edit_ww3_grid < parm/ww3_grid_aoc_9km.inp.IN > input/ww3_grid_aoc_9km.inp
echo -e "\e[34mww3_grid.inp files are filled\e[0m"
#-----------------------------------------------------------------------------------#
#forcing
edit_forcing < parm/retreive_wind_hpss.sh.IN > forcing/retreive_wind_hpss.sh
edit_forcing < parm/retreive_ice.sh.IN > forcing/retreive_ice.sh
edit_forcing < parm/retreive_cur.sh.IN > forcing/retreive_cur.sh
edit_forcing < parm/retreive_restart_hpss.sh.IN > forcing/retreive_restart_hpss.sh
echo -e "\e[34mForcing templates are filled\e[0m"
#-----------------------------------------------------------------------------------#
#                     2- Forcing and Restart Retreival                              #
#-----------------------------------------------------------------------------------#
cd ${HOME}/forcing
    echo -e "\e[36mForcing and Restart Retreival\e[0m"
    if [ -f ../input/rtofs_current.nc ]
    then
       echo -e "\e[34mrtofs._current.nc exists\e[0m"
   else
       bash retreive_cur.sh               
       echo -e "\e[31mcurrent file is retreived\e[0m"
   fi
#-----------------------------------------------------------------------------------#
    if [ -f ../input/ice.nc ]
    then
       echo -e "\e[34mice.nc exists\e[0m"
    else
       bash retreive_ice.sh
       echo -e "\e[31mice file is retreived\e[0m"
   fi
#-----------------------------------------------------------------------------------#
    if [ -f ../input/gfs_wnd.nc ]
    then
      echo -e "\e[34mgfs_wnd.nc exists\e[0m"        
    else
      bash retreive_wind_hpss.sh
      echo -e "\e[31mwind file is retreived\e[0m"     
    fi
#-----------------------------------------------------------------------------------#
    if [ -f ../input/restart.aoc_9km ] && [ -f ../input/restart.gnh_10m ] && [ -f ../input/restart.gsh_15m ]
    then
       echo -e "\e[34mrestart files exist\e[0m"
    else
       bash retreive_restart_hpss.sh
       echo -e "\e[31mrestart files are retreived\e[0m"     
    fi
#-----------------------------------------------------------------------------------#
    if [ -f ../input/rmp_src_to_dst_conserv_002_001.nc ] && [ -f ../input/rmp_src_to_dst_conserv_003_001.nc ]
    then
       echo -e "\e[34mrmp_src_to_dst_conserv_002_001.nc and rmp_src_to_dst_conserv_003_001.nc files exist\e[0m"
    else
       bash retreive_fix_file.sh
       echo -e "\e[31mfix files are retreived\e[0m"
    fi
#-----------------------------------------------------------------------------------#

