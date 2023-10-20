#!/usr/bin/ksh
##########################################################
# title  : Auto_load_info.ksh
# explanation: CRN153586
# Automatic load of information in a case (STA - Free text)
# KSH to be called once a day (during the night)
#
# author : BEVRIG1
# analyst: BECDEL3
# date : 22/06/2021
# update: 30/01/2023 (Sunshade)
##########################################################
appl=auto_load_info; export appl
scriptName=auto_load_info; export scriptName
nbrStep=3; export nbrStep
#
##########################################################
. /home/oracle/bin/scriptBeginning
##########################################################
. ./params/set_env.ini
. ./params/set_env_python
#
##########################################################
##########################################################
DTT=`date +%Y%m%d%H%M%S`
echo ' '
echo '________________________________________'
echo 'date = ' ${DTT}
echo 'imx_appman_env = ' $CITMAN_ENV
echo 'imx_appman_sql = ' $CITMAN_SQL
echo 'imx_appman_log = ' $CITMAN_LOG
echo 'imx_appman_trc = ' $CITMAN_TRC
echo 'imx_appman_data = ' $CITMAN_DATA
echo 'imx_appman_ctl = ' $CITMAN_CTL
echo 'imx_appman_bin = ' $CITMAN_BIN
echo 'imx_appman_python = ' $CITMAN_PYTHON
echo 'imx_appman_params = ' $CITMAN_PARAMS
echo '____________________________________ '
echo '________________________________________'
echo ' '

#
##########################################################
. /home/oracle/bin/scriptBeginning
##########################################################
#
# Define internal variables
#
. ./params/set_env_var
##########################################################
#
##########################################################
# Define of all steps
#
# 
function step1 { 
#
echo ' '
echo "Step 1 : Do Nothing"
echo ' '
errStatus=0
echo 'status_error = ' ${errStatus}
}
#
#
# 
function step2 { 
#
echo ' '
echo "Step 2 : Call python program auto_load_info.py"
python3 $CITMAN_PYTHON/auto_load_infos.py
errStatus=0
echo 'status_error = ' ${errStatus}
}
#
#
function step3 {
#
echo ' '
echo "Step 3 : End of ksh"
echo ' '
errStatus=$?
echo 'status_error = ' ${errStatus}
echo ' '
}
#
#
# Execution of all steps
#
##########################################################
scriptEnding
##########################################################
