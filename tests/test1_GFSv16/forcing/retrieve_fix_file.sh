##!/bin/bash

export TEST_DIR="${PWD%/*}"
export FORCING_DIR="${TEST_DIR}/forcing"
input_i=input_opt
#cd $FORCING_PATH

#-----------------------------------------------------------------------------------#
#                                   RMP_SRC_TO_DST*                                 #
#-----------------------------------------------------------------------------------#
  echo ' '                                                                 
  echo '       *****************************************************************'     
  echo "      ***                     RMP_SRC_TO_DST* Prep                     ***"
  echo '       *****************************************************************'    
  echo ' ' 


file_rmp=`( ls ${FIXwave1}rmp_src_to_dst_conserv* )`
cp ${FIXwave1}rmp_src_to_dst_conserv* ${TEST_DIR}/${input_i}
  echo "$file_rmp"
cp ${FIXwave1}WHTGRIDINT.bin.glo_15mxt ${TEST_DIR}/${input_i}/WHTGRIDINT.bin
  echo "WHTGRIDINT.bin.glo_15mxt"
cp ${FIXwave1}namelist.nml ${TEST_DIR}/${input_i}/
  echo "namelist.nml"
cp ${FIXwave}ww3_grid.inp.glo_15mxt ${TEST_DIR}/${input_i}/ww3_grid_glo_15mxt.inp
  echo "ww3_grid_glo_15mxt.inp"
cp ${FIXwave}ww3_grid.inp.points ${TEST_DIR}/${input_i}/ww3_grid_points.inp
  echo "ww3_grid_points.inp"
cp ${FIXwave}ww3_grid.inp.glix_10m ${TEST_DIR}/${input_i}/ww3_grid_glix_10m.inp
  echo "ww3_grid_glix_10m.inp"
cp ${FIXwave}ww3_grid.inp.glox_10m ${TEST_DIR}/${input_i}/ww3_grid_glox_10m.inp
  echo "ww3_grid_glox_10m.inp"
  echo "copied over"
  echo ' '                                                                 
  echo '       *****************************************************************'     
  echo "     ***                            done                               ***"
  echo '       *****************************************************************'    
  echo ' '     
