#!/usr/bin/ksh
##########################################################
# title  : script_proactive_comm.ksh
# explanation
# 
# author : BEYCNE1
# date : 28/09/2020
##########################################################
appl=score; export appl
scriptName=script_proactive_comm; export scriptName
nbrStep=3; export nbrStep
#
##########################################################
. /home/oracle/bin/scriptBeginning

. $CITMAN_PARAMS/set_env_oracle
##########################################################

DTT=`date +%Y%m%d`
echo 'date = ' ${DTT}
echo '____________________________________ '
#
##########################################################
#
# Define internal variables
##########################################################
#
##########################################################
# Define of all steps
#
# Step 1 = call sql qo query all triggers and put them in output proactive_comm.txt 
# Step 2 = run through proactive_comm and send out a mail for each line
# 
# Step 3 = copy files to archive folder, empty tmp folder (and update param_date, but later on)
#
##########################################################
#
function step1 {
#
echo ' '
echo 'step 1 : Call sql to query all received calls from debtors on previous day for insured companies'
echo ' '
chmod 777 $CITMAN_TMP_FILE
rm -f $CITMAN_TMP_FILE/proactive_comm.txt
sqlplus -s $DBCIT_ORANAME/$DBCIT_PASSWORD @$CITMAN_SQL/proactive_comm.sql
errStatus=$?
echo 'status_error = ' ${errStatus}
echo 'einde step1'
}
#
function step2 {
#
echo ' '
echo 'step 2 : Open file and create for each entry a corresponding mail'
echo ' '
inp_file=$CITMAN_TMP_FILE/proactive_comm.txt
while IFS='|' read caseReference clientName clientEmail clientLanguage debtorName collectorName collectorEmail freeComment claimsReference commType countryUnit labelInfo
do
	script_proactive_comm_mail.ksh $caseReference "$clientName" "$clientEmail" "$clientLanguage" "$debtorName" "$collectorName" "$collectorEmail" "$freeComment" "$claimsReference" "$commType" "$countryUnit" "$labelInfo"
done <"$inp_file"

cp $CITMAN_TMP_FILE/proactive_comm.txt $CITMAN_DATA/proactive_comm_$DTT.txt
}
#

##########################################################
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
