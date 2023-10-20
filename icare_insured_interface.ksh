#!/usr/bin/ksh
##########################################################
# Script Name : icare_insured_interface.ksh
# author :BEODEL1
# date :17/08/2023
##########################################################
appl=score; export appl
scriptName=icare_insured_interface;export scriptName
nbrStep=5; export nbrStep
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
echo 'step 2 : call icare_insured_select.py'
echo ' '
python3 $CITMAN_PYTHON/icare_insured_select.py
errStatus=$?
echo 'status_error = ' ${errStatus}
}
#
function step3 {
#
echo ' '
echo 'step 3 : call icare_insured_handling.py'
echo ' '
python3 $CITMAN_PYTHON/icare_insured_handling.py
errStatus=$?
echo 'status_error = ' ${errStatus}
}
#
function step4 {
#
echo ' '
echo 'step 4 : call icare_insured_error.py'
echo ' '
python3 $CITMAN_PYTHON/icare_insured_error.py
errStatus=$?
echo 'status_error = ' ${errStatus}
}
#
function step5 {
#
echo ' '
echo 'step 5 :  End of ksh '
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


