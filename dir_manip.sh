#!/bin/bash
#
#  bash script to:
#  Check for directory
#  Move a directory
#  checking on each action
#

# Check for directory
#
check_for_dir(){
  local DIR=$1
  if [ -d "$DIR" ]; then
    echo "cfd--dir :${DIR}: exists"
    return 0
  else
    echo "cfd--dir :${DIR}: does not  exist"
    return 1
  fi
} # check_for_dir

# Move a directory
# takes source and destination directories
# checks if the source dir exists
move_dir(){
  local source_dir=$1
  local dest_dir=$2
  echo "moving -${source_dir}- to -${dest_dir}-"

  # Check for the source dir
  #
  check_for_dir ${source_dir} 
  ret_val=$?
  if [ $ret_val -ne 0 ]; then
    echo "source dir not found - ${source_dir} - ret_val = ${ret_val}"
    #
    # Check for dest dir
    # going to move it to OLD_LAST_obj to signify there was no obj dir
    #
    echo "checking and moving dest_dir - ${dest_dir} - to OLD_${dest_dir}"

    check_for_dir ${dest_dir} 
    ret_val=$?
    if [ $ret_val -ne 0 ]; then
      echo "dest_dir - ${dest_dir} does not exist - Not moving to OLD${dest_dir} - ${ret_val}"
    else
      old_dest="OLD"
      old_dest+=${dest_dir}
      mv -f -v ${dest_dir} ${old_dest}
      ret_val=$?
      if [ ${ret_val} -ne 0 ]; then
        echo "ERROR: moving ${dest_dir} to  OLD_${dest_dir} - ${ret_val}"
      else
        echo "Moved ${dest_dir} to  OLD_${dest_dir}"
      fi
    fi
    return ${ret_val} 
  fi
  #
  # source and dest dirs exist do the move
  #
  mv -f -v ${source_dir} ${dest_dir}
  ret_code=$?
  if [ ${ret_code} == "0" ]; then
    echo "moved ${source_dir} to ${dest_dir} - ret_code=${ret_code}"
    return 0
  else
    echo "ERROR: failed to move ${source_dir} to ${dest_dir} - ret_code=${ret_code}"
    return 1
  fi
} # move_dir


DIRS=('obj' 'objd')


for dir in "${DIRS[@]}"
do
  echo "dir = ${dir}"
  move_dir "${dir}" "LAST_${dir}"
  ret_val=$?
  echo "RETURN VALUE = ret_val = $ret_val"
  if [ $ret_val != 0  ]; then
    echo "dir - ${dir} move_dir problem- ret_val=${ret_val}"
  else
    echo "dir - ${dir}  moved exists - ret_val=${ret_val}"
  fi
done


