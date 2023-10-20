#!/usr/bin/ksh
##########################################################
# Script Name : curr_rates_daily.ksh
# author :BEVRIG1
# date :19/10/2023
##########################################################
appl=score; export appl
scriptName=curr_rates_daily;export scriptName
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
echo 'step 2 : call python program'
echo ' '
python3 $CITMAN_PYTHON/curr_rates/CIT_curr_rates_daily.py
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


