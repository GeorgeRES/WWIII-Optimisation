##!/bin/bash

FIXwave=/scratch1/NCEPDEV/global/glopara/fix_nco_gfsv16/fix_wave_gfs/

source ../default_vars.sh
#cd $FORCING_PATH

#-----------------------------------------------------------------------------------#
#                                   RMP_SRC_TO_DST*                                 #
#-----------------------------------------------------------------------------------#
  echo ' '                                                                 
  echo '       *****************************************************************'     
  echo "      ***                     RMP_SRC_TO_DST* Prep                     ***"
  echo '       *****************************************************************'    
  echo ' ' 


file_rmp=`( ls ${FIXwave}rmp_src_to_dst_conserv* )`
cp ${FIXwave}rmp_src_to_dst_conserv* ../input
  echo "$file_rmp"
  echo "copied over"
  echo ' '                                                                 
  echo '       *****************************************************************'     
  echo "     ***                            done                               ***"
  echo '       *****************************************************************'    
  echo ' '     

