#!/usr/bin/ksh
##########################################################
# Script Name : read_imx_events.ksh
# author :BEYCNE1
# date :25/07/2023
##########################################################
appl=score; export appl
scriptName=read_imx_events;export scriptName
nbrStep=4; export nbrStep
#
##########################################################
. /home/oracle/bin/scriptBeginning
##########################################################
#. ./params/set_env.ini
#. ./params/set_env_python
. ./params/set_env_var
##########################################################
##########################################################
DTT=`date +%Y%m%d%H%M%S`
echo ' '
echo '________________________________________'
echo 'date = ' ${DTT}
#echo 'imx_login = ' $IMX_LOGIN
#echo 'imx_tmp = ' $IMX_TMP
echo '________________________________________'
echo ' '
##########################################################
#
# Define of all steps
#
##########################################################
#
function step1 {
#
echo ' '
echo 'step 1 :  Do nothing'
echo ' '
errStatus=$?
echo 'status_error = ' ${errStatus}
}
#
function step2 {
#
echo ' '
echo 'step 2 : call read_imx_events.py'
echo ' '
python3 $CITMAN_PYTHON/events_handling/read_imx_events.py
errStatus=$?
echo 'status_error = ' ${errStatus}
}
#
function step3 {
#
echo ' '
echo 'step 3 : do nothing'
echo ' '
errStatus=$?
echo 'status_error = ' ${errStatus}
}
#
function step4 {
#
echo ' '
echo 'step 4 :  End of ksh '
echo ' '
errStatus=$?
echo 'status_error = ' ${errStatus}
}
#
#
#
# Execution of all steps
#
##########################################################
scriptEnding
##########################################################


