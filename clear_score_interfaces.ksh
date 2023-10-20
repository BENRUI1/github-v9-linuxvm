#!/usr/bin/ksh
##########################################################
# Script Name : check_default_template.ksh
# author :BEVRIG1
# date :24/03/2023
##########################################################
appl=score; export appl
scriptName=clear_score_interfaces;export scriptName
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
echo 'step 2 : call main_clear_score.py'
echo ' '
python3 $CITMAN_PYTHON/clear_score_itf/main_clear_score.py
errStatus=$?
echo 'status_error = ' ${errStatus}
}
#
function step3 {
#
echo ' '
echo 'step 3 : do nothing for the moment, will have to call later main_score_clear.py'
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


