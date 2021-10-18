#!/bin/bash

showStepList () {
  echo ""

  currentphaseindice=0
  for key in "${!arr[@]}"
  do
    phase=cut -d',' -f 1 $key | cut -d'[' -f 1
    if [ $phase != $currentphaseindice ]
    then
      case $phase in
        1)
          echo "==================== 1/3 - Installation Start ====================="
          ;;
        2)
          echo "==================== 2/3 - Chroot environment ==================== "
          ;;
        3)
          echo "===================== 3/3 - su username ======================="
          ;;
      esac
    fi

    echo "${arr[$i]}"
  done

  echo ""
}

# Execute a step, takes two parameters, plus one facultative
# 1: The function to execute
# 2: A facultative fonction that can be executed between the title and the
# execution of the main function
step () {
  # Check if we should skip this step
  if [ $skipcount -gt 0 ]
  then
    skipcount=$skipcount - 1
    return
  fi

  # Show the step's title
  echo "\n"$numphase"."$numstep" - "${!arr[$numphase,$numstep]}"\n"

  # Execute the header
  if [ $2 -n ]
  then
    $2
  fi

  # Execute the step:
  set -x
  $1
  set +x

  # Check if we should just continue without yet showing the prompt
  if [ $continuecount -gt 0 ]
  then
    continuecount=$continuecount - 1
    return
  fi

  # Show the prompt
  finish="no"
  while [ $finish == "no" ]
  do
    echo "Step "$numphase"."$numstep" done. (Continue [N step]/Terminal/List/Skip [N step])"
    read -p "c/t/l/s ->" answer num
    case $answer in
      c)
        if [ $num -n ]
        then
          continuecount=$num
        else
          continuecount=1
        fi
        finish="yes"
        ;;
      t)
        bash
        ;;
      l)
        showStepList()
        ;;
      s)
        if [ $num -n ]
        then
          skipcount=$num
        else
          skipcount=1
        fi
        ;;
      *)
        ;;
    esac
  done
}
