#!/usr/bin/ksh
##########################################################
# Script Name : creditsafe_score_interface.ksh
# author :BEYCNE1
# date :07/07/2023
##########################################################
appl=score; export appl
scriptName=creditsafe_score_interface;export scriptName
nbrStep=4; export nbrStep
#
##########################################################
. /home/oracle/bin/scriptBeginning
##########################################################
#. ./params/set_env.ini
#. ./params/set_env_python
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
echo 'step 2 : call cs_score_itf.py'
echo ' '
python3 $CITMAN_PYTHON/cs_score_itf.py
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


