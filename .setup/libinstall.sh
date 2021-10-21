#!/bin/bash

stepNames=()

numphase=0
numstep=1
absolutenumstep=0


phaseindice=0
stepindice=1

showStageName () {
  aaa=$1
  if [[ ${aaa:0:1} == "[" ]]
  then
    title="${aaa:1:${#aaa}-2}"
    echo "==================  $title  =================="
    return 1
  else
    return 0
  fi
}

showStepList () {
  echo ""

  phaseindice=0
  stepindice=1

  for stepName in "${stepNames[@]}"; do
    showStageName "$stepName"
    result=$?
    if [[ $result -eq 0 ]]
    then
      # Show a star if we already did the step or an arrow if it is the
      # current step
      if [[ $phaseindice -lt $numphase ]]
      then
        printf "* "
      else
        if [[ $phaseindice -eq $numphase ]]
        then
          if [[ $stepindice -lt $numstep+1 ]]
          then
            printf "* "
          else
            if [[ $stepindice -eq $numstep+1 ]]
            then
              printf "> "
            else
              printf "  "
            fi
          fi
        else
          printf "  "
        fi
      fi
      echo $phaseindice"."$stepindice" - "$stepName
      stepindice=$((stepindice+1))
    else
      phaseindice=$((phaseindice+1))
      stepindice=1
    fi
  done

  echo ""
}

showPrompt () {
  # Show the prompt
  finish="no"
  while [ $finish == "no" ]
  do
    textSuggestedInput="(Continue [N step]/Terminal/List/Skip [N step])"
    echo -e "}\n--> Step "$numphase"."$numstep" Done. "$textSuggestedInput
    read -p "c/t/l/s -> " answer num
    case $answer in
      c)
        if [[ -n $num ]]
        then
          continuecount=$num
        else
          continuecount=0
        fi
        finish="yes"
        echo ""
        ;;
      t)
        echo -e "\n[Entering bash]"
        bash
        echo -e "[Exiting bash]\n"
        sleep 0.3
        ;;
      l)
        showStepList
        ;;
      s)
        if [ -n $num ]
        then
          skipcount=$num
        else
          skipcount=1
        fi
        finish="yes"
        ;;
      *)
        ;;
    esac
  done

}

stepNoPrompt () {
  if [ (namesInitialisation == "true") ]
  then
    return
  fi

  $1
}

continuecount=0
skipcount=0

# Execute a step, takes two parameters, plus one facultative
# 1: The function to execute
# 2: A facultative fonction that can be executed between the title and the
# execution of the main function
step () {
  if [ (namesInitialisation == "true") ]
  then
    return
  fi

  # Show the step title
  stepTitle="${stepNames[$absolutenumstep]}"

  showStageName "$stepTitle"
  result=$?
  if [[ $result -eq 1 ]]
  then
    echo ""
    numphase=$((numphase+1))
    absolutenumstep=$((absolutenumstep+1))
    numstep=1
    if [ "$1" == "" ]
    then
      return
    else
      stepTitle="${stepNames[$absolutenumstep]}"
    fi
  fi

  # Check if we should skip this step
  if [ $skipcount -gt 1 ]
  then
    skipcount=$((skipcount-1))
    numstep=$((numstep+1))
    absolutenumstep=$((absolutenumstep+1))
    return
  else
    if [ $skipcount -eq 1 ]
    then
      showPrompt
    fi
  fi


  echo -e "--> Executing Step "$numphase"."$numstep" - "$stepTitle
  echo -e "{"
  sleep 0.3

  # Execute the header
  if [ "$2" != "" ]
  then
    echo ""
    $2
  fi

  # Execute the step:
  echo ""
  set -x
  $1
  set +x
  echo ""

  # Check if we should just continue without yet showing the prompt
  if [ $continuecount -gt 1 ]
  then
    continuecount=$((continuecount-1))
    numstep=$((numstep+1))
    absolutenumstep=$((absolutenumstep+1))
    return
  fi

  showPrompt

  numstep=$((numstep+1))
  absolutenumstep=$((absolutenumstep+1))
}
