#!/usr/bin/ksh
##########################################################
# Script Name : test.ksh
# author :BEVRIG1
# date :15/03/2023
##########################################################
appl=score; export appl
scriptName=testOracleCIT;export scriptName
nbrStep=2; export nbrStep
#
##########################################################
. /home/oracle/bin/scriptBeginning
##########################################################
. ./params/set_env.ini
. ./params/set_env_oracle_CIT
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
echo 'step 1 : '
echo ' '
echo 'USER= ' ${ORANAME}
echo 'PWD= ' ${ORAPASSWD}
echo 'SQL= ' ${CITMAN_SQL}
sqlplus -s ${ORANAME}/${ORAPASSWD} @$CITMAN_SQL/test.sql
errStatus=$?
echo 'status_error = ' ${errStatus}
}
#
function step2 {
#
echo ' '
echo 'step 2 :  End of ksh '
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


