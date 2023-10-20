from datetime import datetime
import time
import re
import base64

import cx_Oracle
import os
import configparser
import platform
import sys
import requests
import json
import logging
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(message)s')

# setting path
sys.path.append(os.path.join(os.getcwd(), "python"))
sys.path.append(os.path.join(os.getcwd(), "shared"))

# importing
from tools.cit_connect import CIT_connect as cit_connect
from tools.cit_functions import CIT_functions as cit_func
from score_itf_module.m_login import module_login as m_login
from score_itf_module.m_individual import module_individual as m_indiv
from score_itf_module.m_contract import module_contract as m_contract
from score_itf_module.m_case import module_case as m_case
from cit_itf_module.event_services import events_processing as c_event


conn = cit_connect.get_connection('dbCIT')
c1 = conn.cursor()

url_account = os.getenv('ICARE_API_URL_ACCOUNT')
url_opportunity = os.getenv('ICARE_API_URL_OPTY')
url_owner = os.getenv('ICARE_API_URL_OWNER')
url_contact = os.getenv('ICARE_API_URL_CONTACT')
url_activity = os.getenv('ICARE_API_URL_ACTIVITY')
headers = {'Content-Type': 'application/json', 'REST-Framework-Version': '2'}
auths = (os.getenv('ICARE_API_AUTHS_USER'), os.getenv('ICARE_API_AUTHS_PASSWORD'))


def api_request(method, url, data=None):
    idc = 1
    status_code = 504
    while idc <= 5 and status_code == 504:
        if idc > 1:
            time.sleep(5)
        if method == 'GET':
            response = requests.request(method, url, auth=auths, headers=headers)
        else:
            response = requests.request(method, url, auth=auths, headers=headers, data=data)
        status_code = response.status_code
        idc += 1
    return response


def b64_encode(str0):
    return base64.b64encode(str0.encode('ascii')).decode('utf-8')


def logging_info(type, request, response, status):
    l_object = type + chr(10) + 'request: ' + request + chr(10) + 'response: ' + response + chr(10) + 'status: ' + str(status)
    if status == 'Error':
        logging.error(l_object)
    else:
        logging.info(l_object)


def main():
    err_msg = {
        'dupl_opty': 'Opportunity already exists'
    }
    c1 = conn.cursor()

    http_status_code = {}
    for r in cit_func.sql_select(conn, 'all', """select place,valeur_an from v_domaine where type='CIT_HTTP_STATUS_CODE'"""):
        http_status_code[r[0]] = r[1]

    accounts = cit_func.sql_select(conn, 'all', "select * from ICARE_INSURED where nvl(cit.caed,'N') = 'N'", assoc=1)
    for account in accounts:
        caed = 'N'
        cusAccount = account['CUSACCOUNT']
        conRef = account['CONREF']
        cusRef = None
        cusHmo = None
        keyAccountNumber = None
        keyClearNumber = None
        keyNationalNumber = None
        keyDunsNumber = None
        a_phone = None
        b_office = None
        c_mobile = None
        optyNotCompliantFlag = account['OPTYNOTCOMPLIANTFLAG']

        params = {}
        params['api_login'] = 'SCORE_EVENTS'
        l_return = m_login.m_api_login(json.dumps(params))
        l_return = json.loads(l_return)
        logging.info('icare_insured_select login returns: ' + str(l_return))
        if l_return['status_code'] == 200:
            xAuthToken =  l_return['token']
        else:
            ok_to_continue = False
            caed = 'E'
            caed_fault = l_return['status_code']
            caed_fault_string = 'login: ' + l_return['error_message']
        
        if ok_to_continue is True:
            params = {}
            params['token'] = xAuthToken
            params['caseRef'] = cusAccount
            params['contractId'] = conRef
            l_return = m_contract.m_api_get_contract(json.dumps(params))
            if l_return['status_code'] == 200:
                contract = l_return
                conStatus = contract['statusValue']
                conCurrency = contract['invoiceCurrency']
                cusSalesMgr = contract['saleAgentRef']
            else:
                ok_to_continue = False
                caed = 'E'
                caed_fault = l_return['status_code']
                caed_fault_string = 'contract: ' + l_return['error_message']
        
        if ok_to_continue is True:
            params = {}
            params['token'] = xAuthToken
            params['caseRef'] = cusAccount
            l_return = m_case.m_api_get_case_partners(json.dumps(params))
            if l_return['status_code'] == 200:
                for casePartner in l_return['partners']:
                    if casePartner['partnerType'] == 'DB':
                        cusRef = casePartner['partnerRefImx']
                    if casePartner['partnerType'] == 'BU':
                        cusHmo = casePartner['partnerRefImx']
            else:
                ok_to_continue = False
                caed = 'E'
                caed_fault = l_return['status_code']
                caed_fault_string = 'partners: ' + l_return['error_message']

        if ok_to_continue is True:
            params = {}
            params['token'] = xAuthToken
            params['refIndividual'] = cusRef
            l_return = m_indiv.m_api_get_individual(json.dumps(params))
            l_return = json.loads(l_return)
            if l_return['status_code'] == 200:
                individual = l_return
                indivStatus = individual['legalIndividualStatusnGet']
                cusName = indivStatus['nameLegal']
                cusClientType = indivStatus['indivTypeLegal']
                cusLang = indivStatus['langLegal']
                if cusLang == 'AN':
                    cusLang = 'EN'
                indivReg = individual['legalIndividualRegistrationGet']
                cusNationalNumber = indivReg['vatNbLegal']
                indivAddress = individual['legalIndividualAddressGet']
                cusCountry = indivAddress['countryAddrLegal']
                cusAdr1 = indivAddress['addrLine1Legal']
                cusAdr2 = indivAddress['addrLine2Legal']
                cusCity = indivAddress['cityLegal']
                cusState = indivAddress['stateLegal']
                cusPostalCode = indivAddress['postCodeLegal']
                if cusNationalNumber is not None:
                    cusNationalNumber = cusCountry + re.sub(cusCountry + '(.*)', '\\1', cusNationalNumber)
                for externalReference in individual['externalReferences']:
                    if externalReference['refType'] == 'ICARE':
                        accountNumber = externalReference['externalRef']
                    elif externalReference['refType'] == 'CLEAR':
                        keyClearNumber = externalReference['externalRef']
                    elif externalReference['refType'] == 'NATIONAL':
                        keyNationalNumber = externalReference['externalRef']
                    elif externalReference['refType'] == 'DUN':
                        keyDunsNumber = externalReference['externalRef']
                for communicationChannel in individual['communicationChannels']:
                    if communicationChannel['typeTel'] == 'DOM':
                        a_phone = communicationChannel['nbOrEmail']
                    elif communicationChannel['typeTel'] == 'BUR':
                        b_office = communicationChannel['nbOrEmail']
                    elif communicationChannel['typeTel'] == 'GSM':
                        c_mobile = communicationChannel['nbOrEmail']
                if a_phone is None:
                    cusPhoneNumber1 = b_office
                    cusPhoneNumber2 = c_mobile
                else:
                    cusPhoneNumber1 = a_phone;
                    if b_office is None:
                        cusPhoneNumber2 = c_mobile
                    else:
                        cusPhoneNumber2 = b_office
                contact = individual['contacts'][0]
                cusContactName = contact['firstName'] + ' ' + contact['name']
                cusEmail : contact['email']
            else:
                ok_to_continue = False
                caed = 'E'
                caed_fault = l_return['status_code']
                caed_fault_string = 'individual: ' + l_return['error_message']

        if ok_to_continue is True:
            country = cit_func.sql_select(conn, 'one', "select nat_mandatory from LOV_COUNTRY where iso3=:1", [cusCountry])
            cusNatMandatory = country[0]

            owner = cit_func.sql_select(conn, 'one', "select login from ICARE_LOGIN where refindividu=:1", [cusSalesMgr])
            cusOwnerLogin = owner['OWNERLOGIN']

            if account['CUSNATIONALNUMBER'] != cusNationalNumber \
                or account['CUSCLIENTTYPE'] != cusClientType \
                or account['CUSSALESMGR'] != cusSalesMgr \
                or account['CUSLANG'] != cusLang \
                or account['CUSOWNERLOGIN'] != cusOwnerLogin \
                or account['CONREF'] != conRef \
                or account['CONCURRENCY'] != conCurrency \
                or account['CUSCONTACTNAME'] != cusContactName \
                or account['CUSPHONENUMBER1'] != cusPhoneNumber1:
                caedCount = 0

        if ok_to_continue is True:
            caed = 'N'
            caedError = ''
            caedFaultString = ''
            caedDat = None
            accounted = 'N'
            accountedError = ''
            accountedFault = ''
            accountedFaultString = ''
            accountedDat = None
            sw_UpdateAccount = 'N'
            accountId = ''
            ownerId = ''
            ownerName = ''
            contactId = ''
            contactNumber = ''
            optyId = ''
            optyNumber = ''
            activityId = ''
            activityNumber = ''

            if cusClientType is None:
                caed = 'E2'
                caedError = 'ERR'
                caedFaultString += ', Missing Client Type'

            if cusNationalNumber is None and cusNatMandatory == 'Y':
                cusNationalNumber = None
                caed = 'E2'
                caedError = 'ERR'
                caedFaultString += ', Missing Nat.Number'

            if cusLang is None:
                caed = 'E2'
                caedError = 'ERR'
                caedFaultString += ', Missing Language'

            if cusPhoneNumber1 is None and cusPhoneNumber2 is None:
                caed = 'E2'
                caedError = 'ERR'
                caedFaultString += ', Missing Phone Number'

            if cusContactName is None:
                caed = 'E2'
                caedError = 'ERR'
                caedFaultString += ', Missing Contact'

            if cusOwnerLogin is None:
                caed = 'E2'
                caedError = 'ERR'
                caedFaultString += ', Owner not found'

            if cusSalesMgr is None:
                caed = 'E2'
                caedError = 'ERR'
                caedFaultString += ', Missing Sales Mgr'

            if keyClearNumber is not None:
                if keyClearNumber in cusName:
                    caed = 'E2'
                    caedError = 'ERR'
                    caedFaultString += ', Anonymized Name'

                if keyClearNumber in cusAdr1:
                    caed = 'E2'
                    caedError = 'ERR'
                    caedFaultString += ', Anonymized Address 1'

                if keyClearNumber in (cusAdr2 or ''):
                    caed = 'E2'
                    caedError = 'ERR'
                    caedFaultString += ', Anonymized Address 2'

            logging.info(chr(10) + 'cusAccount: ' + cusAccount + ' (cusRef: ' + cusRef + ')')
 
            if caed == 'N':
 
                factor = cit_func.sql_select(conn, 'one', "select accountNumber from ICARE_FACTOR where nationalNumber=:1", [cusNationalNumber])
                if factor is not None:
                    c1.execute("insert into t_individu(refindividu, societe, refext) values(:1, 'ICARE', :2)", [cusRef, factor[0]])
                    caed = 'YF'
                    accounted = 'YF'
                    accountNumber = factor[0]
                    ok_to_continue = False

            if caed == 'N':
                # sw_UpdateAccount = 'Y'
                sw_GetOwner = 'N'
                sw_GetOpty = 'N'

                if accountNumber is None:
                    caed = 'Y'
                    if cusNationalNumber is None:
                        sw_GetOwner = 'Y'
                    else:
                        logging.info('get Account A')
                        url = url_account + "?onlyData=true&q=OrganizationDEO_NationalNumberKey_c='" + cusNationalNumber.replace('*', '') + \
                            "'&fields=PartyNumber,PartyId,OwnerPartyId,OwnerName"
                        response = api_request("GET", url)
                        logging.info(url + ' (' + str(response.status_code) + ')')
                        if response.status_code == 200:
                            body = response.json()
                            clob = json.dumps(body)
                            sw_UpdateAccount = 'Y'
                        else:
                            clob = 'ECID' + response.headers['X-ORACLE-DMS-ECID'] + "\n" + \
                                http_status_code[response.status_code] + ' (' + str(response.status_code) + '): ' + response.text + ' (Account A)'
                            sw_GetOwner = 'Y'
                        logging_info('Account', url, clob, None)
                else:
                    caed = 'Y'
                    logging.info('get Account B')
                    url = url_account + "?onlyData=true&q=OrganizationDEO_NationalNumberKey_c='" + (cusNationalNumber or 'NumNatEmpty').replace('*', '') + \
                        "' OR OrganizationDEOOrganizationId_c='" + keyClearNumber + \
                        "'&fields=PartyNumber,PartyId,OwnerPartyId,OwnerName"
                    response = api_request("GET", url)
                    logging.info(url + ' (' + str(response.status_code) + ')')
                    if response.status_code == 200:
                        body = response.json()
                        clob = json.dumps(body)
                        sw_UpdateAccount = 'Y'
                    else:
                        clob = 'ECID' + response.headers['X-ORACLE-DMS-ECID'] + "\n" + \
                            http_status_code[response.status_code] + ' (' + str(response.status_code) + '): ' + response.text + ' (Account B)'
                        sw_GetOwner = 'Y'
                    logging_info('Account', url, clob, None)

            if caed == 'Y' and sw_UpdateAccount == 'Y':
                logging.info('update Account(' + str(body['count']) + ')')
                if body['count'] == 0:
                    sw_GetOwner = 'Y'
                else:
                    items = body['items'][0]
                    accountId = items['PartyId']
                    accountNumber = items['PartyNumber']
                    ownerId = items['OwnerPartyId']
                    ownerName = items['OwnerName']

                    url = url_account + '/' + accountNumber
                    payload = '{"OrganizationDEO_InsuredNonInsured_c": "INSURED"}'
                    response = api_request("PATCH", url, data=payload)
                    if response.status_code == 200:
                        body = response.json()
                        clob = json.dumps(body)
                        sw_GetOpty = 'Y'
                        logging.info('Account Upd OK')
                        status = 'Complete'
                    else:
                        accounted = 'E'
                        accountedError = response.status_code
                        accountedFault = http_status_code[response.status_code]
                        accountedFaultString = 'ECID' + response.headers['X-ORACLE-DMS-ECID'] + '<br/>' + \
                            accountedFault + ' (' + str(response.status_code) + '): ' + response.text + ' (Account Update)'
                        clob = 'ECID' + response.headers['X-ORACLE-DMS-ECID'] + "\n" + response.text
                        logging.info('Account Upd ERROR', payload)
                        status = 'Error'
                    logging_info('Account Upd', url + chr(10) + payload, clob, status)

            if caed == 'Y' and sw_GetOpty == 'Y':
                logging.info('get Opty')
                url = url_opportunity + "q=AccountPartyNumber=" + accountNumber + " and SalesMethod='Insured Sales Process' and StatusCode='WON'&onlyData=true"
                response = api_request("GET", url)
                logging.info(url + ': ' + str(response.status_code))
                if response.status_code == 200:
                    body = response.json()
                    clob = json.dumps(body)
                    if body['count'] > 0:
                        caed = 'E'
                        caedError = err_msg['dupl_opty']
                        items = body['items'][0]
                        optyId = items['OptyId']
                        optyNumber = items['OptyNumber']
                        logging.info(caedError)
                    else:
                        accounted = 'Y'
                    status = 'Complete'
                else:
                    accountedError = response.status_code
                    accountedFault = http_status_code[response.status_code]
                    accountedFaultString = 'ECID' + response.headers['X-ORACLE-DMS-ECID'] + '<br/>' + response.text + ' (Missing Opportunity)'
                    clob = 'ECID' + response.headers['X-ORACLE-DMS-ECID'] + "\n" + \
                        accountedFault + ' (' + str(response.status_code) + '): ' + response.text
                    status = 'Error'

                logging_info('Opty', url, clob, status)

            if caed == 'Y' and sw_GetOwner == 'Y':
                logging.info('get Owner')
                url = url_owner + "?fields=Username,PartyName,ResourcePartyId&q=Username='" + cusOwnerLogin + "'&onlyData=true"
                response = api_request("GET", url)
                if response.status_code == 200:
                    body = response.json()
                    if body['count'] == 0:
                        caed = 'E2'
                    else:
                        items = body['items'][0]
                        owner = items['Username']
                        ownerId = items['ResourcePartyId']
                        ownerName = items['PartyName']

                        l_cusNationalNumber = None
                        if cusNationalNumber is None and optyNotCompliantFlag != 'Y':
                            l_cusNationalNumber = cusCountry + cusRef + '*NN'
                        else:
                            l_cusNationalNumber = cusNationalNumber
                        cusNationalNumber = re.sub(r'(-|\\.|_|)', '', (l_cusNationalNumber or ''))

                        url = '/accounts'
                        payload = {}
                        if l_cusNationalNumber is not None:
                            payload['OrganizationDEO_NationalNumber_c'] = l_cusNationalNumber
                        if keyClearNumber is not None:
                            payload['OrganizationDEO_OrganizationIdText_c'] = keyClearNumber
                        payload['OrganizationName'] = cusName.replace('"', '\\"')
                        payload['Type'] = 'ZCA_CUSTOMER'
                        payload['OrganizationDEO_ClientType_c'] = cusClientType
                        payload['OwnerPartyId'] = ownerId
                        payload['OrganizationDEO_HMO_c'] = cusHmo
                        primaryAddress = {}
                        if cusAdr1 is not None:
                            primaryAddress['AddressLine1'] = cusAdr1.replace('"', '\\"')
                        if cusAdr2 is not None:
                            primaryAddress['AddressLine2'] = cusAdr2.replace('"', '\\"')
                        if cusCity is not None:
                            primaryAddress['City'] = cusCity.replace('"', '\\"')
                        if cusState is not None:
                            primaryAddress['State'] = cusState
                        if cusPostalCode is not None:
                            primaryAddress['PostalCode'] = cusPostalCode
                        primaryAddress['Country'] = cusCountry
                        payload['PrimaryAddress'] = [primaryAddress]
                        if keyDunsNumber is not None:
                            payload['DUNSNumber'] = keyDunsNumber
                        payload['OrganizationDEO_CDDIdentityCheck_c'] = True
                        payload['OrganizationDEO_CustomerLanguage_c'] = cusLang
                        payload['OrganizationDEO_InsuredNonInsured_c'] = 'INSURED'

                        response = api_request("POST", url, data=json.dumps(payload).encode('utf8'))
                        if response.status_code == 201:
                            accounted = 'Y'
                            body = response.json()
                            clob = json.dumps(body)
                            accountId = body['PartyId']
                            accountNumber = body['PartyNumber']
                            logging.info('create Account OK:', accountNumber)
                            status = 'Complete'
                        else:
                            accounted = 'E'
                            accountedError = response.status_code
                            accountedFault = http_status_code[response.status_code]
                            accountedFaultString = 'ECID' + response.headers['X-ORACLE-DMS-ECID'] + '<br/>' + response.text + ' (Account Creation)'
                            clob = 'ECID' + response.headers['X-ORACLE-DMS-ECID'] + "\n" + \
                                accountedFault + ' (' + str(response.status_code) + '): ' + response.text
                            accountId = ''
                            accountNumber = ''
                            logging.info('create Account ERROR:', payload)
                            status = 'Error'

                        logging_info('Account Cre', url + chr(10) + payload, clob, status)

                else:
                    caed = 'E2'

                if caed == 'E2':
                    caedError = 'ERR'
                    caedFaultString = 'Owner not found'

            if accounted == 'Y':
                if cusContactName is not None:
                    url = url_contact
                    payload = {}
                    payload['AccountPartyNumber'] = accountNumber
                    payload['ContactIsPrimaryForAccount'] = 'Y'
                    payload['LastName'] = cusContactName.rstrip('\t')
                    payload['OwnerPartyId'] = ownerId
                    if cusPhoneNumber1 is not None:
                        payload['RawWorkPhoneNumber'] = cusPhoneNumber1.replace(chr(9), '')
                        payload['WorkPhoneCountryCode'] = ''
                    if cusPhoneNumber2 is not None:
                        payload['RawMobileNumber'] = cusPhoneNumber2.replace(chr(9), '')
                        payload['MobileCountryCode'] = ''
                    if cusEmail is not None:
                        payload['EmailAddress'] = cusEmail.strip('\n\r\t ')
                    response = api_request("POST", url, data=json.dumps(payload).encode('utf8'))
                    if response.status_code == 201:
                        body = response.json()
                        clob = json.dumps(body)
                        contactId = body['PartyId']
                        contactNumber = body['PartyNumber']
                        logging.info('create Contact OK:', contactNumber)
                        status = 'Complete'
                    elif response.status_code == 400:
                        caed = 'E2'
                        accounted = 'N'
                        accountedError = response.status_code
                        accountedFault = http_status_code[response.status_code]
                        accountedFaultString = 'ECID' + response.headers['X-ORACLE-DMS-ECID'] + '<br/>' + response.text + ' (Contact Creation)'
                        clob = 'ECID' + response.headers['X-ORACLE-DMS-ECID'] + "\n" + \
                            accountedFault + ' (' + str(response.status_code) + '): ' + response.text
                        logging.info('create Contact ERROR:', payload)
                        status = 'Error'
                    else:
                        accounted = 'E'
                        accountedError = response.status_code
                        accountedFault = http_status_code[response.status_code]
                        accountedFaultString = 'ECID' + response.headers['X-ORACLE-DMS-ECID'] + '<br/>' + response.text + ' (Contact Creation)'
                        clob = 'ECID' + response.headers['X-ORACLE-DMS-ECID'] + "\n" + \
                            accountedFault + ' (' + str(response.status_code) + '): ' + response.text
                        logging.info('create Contact ERROR:', payload)
                        status = 'Error'

                    logging_info('Contact Cre', url + chr(10) + payload, clob, status)

            if accounted == 'Y':
                url = url_opportunity
                payload = {}
                payload['AccountPartyNumber'] = accountNumber
                if contactId is not None:
                    payload['KeyContactId'] = contactId
                payload['Name'] = cusName.replace('"', '\\"') + '_Insured'
                payload['CurrencyCode'] = 'EUR'
                payload['SalesMethodId'] = 300000000974046
                payload['StatusCode'] = 'WON'
                payload['OwnerResourcePartyId'] = ownerId
                payload['ReasonWonLostCode'] = 'OTHER'
                payload['LeadSource2_c'] = 'ACI-INSURED-CUSTOMER'
                payload['SalesStageId'] = 300000000974136
                payload['EffectiveDate'] = datetime.now().strftime('%Y-%m-%d')
                payload['CreatedScore_c'] = True
                payload['ScoreStatus_c'] = 'Successful replication'
                payload['ScoreStatusDetail_c'] = b64_encode('Insured Customer successfully created (from Score to Icare)')
                if optyNotCompliantFlag == 'Y':
                    payload['CompliantFlag_c'] = False
                else:
                    payload['CompliantFlag_c'] = True
                response = api_request("POST", url, data=payload.encode('utf8'))
                if response.status_code == 201:
                    body = response.json()
                    clob = json.dumps(body)
                    optyId = body['OptyId']
                    optyNumber = body['OptyNumber']
                    logging.info('create Opportunity OK:', optyNumber)
                    status = 'Complete'
                else:
                    accounted = 'E'
                    accountedError = response.status_code
                    accountedFault = http_status_code[response.status_code]
                    accountedFaultString = 'ECID' + response.headers['X-ORACLE-DMS-ECID'] + '<br/>' + response.text + ' (Opportunity Creation)'
                    clob = 'ECID' + response.headers['X-ORACLE-DMS-ECID'] + "\n" + \
                        accountedFault + ' (' + str(response.status_code) + '): ' + response.text
                    status = 'Error'
                    logging.info('create Opportunity ERROR:', payload)
                logging_info('Opportunity Cre', url + chr(10) + payload, clob, status)

            if accounted == 'Y':
                url = url_activity
                payload = {}
                payload['AccountId'] = accountId
                payload['OwnerId'] = ownerId
                payload['Subject'] = 'Check contact'
                payload['ActivityFunctionCode'] = 'TASK'
                payload['ActivityTypeCode'] = 'TODO'
                payload['OpportunityId'] = optyId
                if contactNumber is not None:
                    payload['ActivityDescription'] = b64_encode(
                        'This Insured customer has been replicated automatically from Score to Icare.' + chr(10) +
                        'Please check the linked contact: contact name (split first name / last name) + format phone number.' +
                        chr(10) + 'Remark: additional phone number can be displayed in the Score customer card.') + \
                        '","ContactNumber": "' + contactNumber
                else:
                    payload['ActivityDescription'] = b64_encode(
                        'This Insured customer has been replicated automatically from Score to Icare.' + chr(10) +
                        'The contact was missing in Score.')
                payload['DueDate'] = datetime.now().strftime('%Y-%m-%d')
                response = api_request("POST", url, data=json.dumps(payload))
                if response.status_code == 201:
                    body = response.json()
                    clob = json.dumps(body)
                    activityId = body['ActivityId']
                    activityNumber = body['ActivityNumber']
                    logging.info('create Activity OK:', activityNumber)

                    l_response = None
                    params['token'] = xAuthToken
                    params['refIndividual'] = cusRef
                    params['refType'] = 'ICARE'
                    params['externalRef'] = accountNumber
                    l_return = m_indiv.m_api_post_external_ref(json.dumps(params))
                    if l_return['status_code'] != 200:
                        l_response = (l_response or '') + ', ICARE key already exists'

                    if cusNationalNumber is not None:
                        params['refType'] = 'NATIONAL'
                        params['externalRef'] = cusNationalNumber
                        l_return = m_indiv.m_api_post_external_ref(json.dumps(params))
                        if l_return['status_code'] != 200:
                            l_response = (l_response or '') + ', NATIONAL key already exists'

                    if keyClearNumber is not None:
                        params['refType'] = 'ORG'
                        params['externalRef'] = keyClearNumber
                        l_return = m_indiv.m_api_post_external_ref(json.dumps(params))
                        if l_return['status_code'] != 200:
                            l_response = (l_response or '') + ', ORG key already exists'

                    logging.info(l_response)
                    if l_response is None:
                        accounted = 'Y'
                    else:
                        accounted = 'E2'
                        accountedError = 'ERR'
                        accountedFaultString = re.sub('^, (.*)', '\\1', l_response)

                    status = 'Complete'
                else:
                    accounted = 'E'
                    accountedError = response.status_code
                    accountedFault = http_status_code[response.status_code]
                    accountedFaultString = 'ECID' + response.headers['X-ORACLE-DMS-ECID'] + '<br/>' + response.text + ' (Activity Creation)'
                    clob = 'ECID' + response.headers['X-ORACLE-DMS-ECID'] + "\n" + \
                        accountedFault + ' (' + str(response.status_code) + '): ' + response.text
                    activityId = ''
                    activityNumber = ''
                    logging.info('create Activity ERROR:', payload)
                    status = 'Error'

                logging_info('Activity Cre', url + chr(10) + payload, clob, status)

            logging.info(caed)
            if caed.startswith('E'):
                caedCount = (caedCount or 0) + 1
            if caed != 'E2' or caedCount == 1:
                caedDat = datetime.now().strftime('%Y/%m/%d %H:%M:%S')
            if accounted != 'N':
                accountedDat = datetime.now().strftime('%Y/%m/%d %H:%M:%S')
            c1.execute("""update cit_intg_insured
                set cusNationalNumber=:1, cusClientType=:2, cusSalesMgr=:3, cusLang=:4, cusOwnerLogin=:5, conRef=:6, 
                    conCurrency=:7, cusContactName=:8, cusPhoneNumber1=:9, cusPhoneNumber2=:10, cusEmail=:11,
                    cusName=:12, cusAdr1=:13, cusAdr2=:14,
                    AccountId=:15, AccountNumber=:16, OwnerId=:17, OwnerName=:18, ContactId=:19, ContactNumber=:20, 
                    OptyId=:21, OptyNumber=:22, ActivityId=:23, ActivityNumber=:24, 
                    caed=:25, dat_caed=to_date(:26, 'yyyy/mm/dd hh24:mi:ss'), caed_count=:27, caed_error=:28, 
                    caed_fault_string=:29, accounted=:30, dat_accounted=to_date(:31, 'yyyy/mm/dd hh24:mi:ss'), 
                    accounted_error=:32, accounted_fault=:33, accounted_fault_string=:34
                where cusAccount=:35""", [
                    cusNationalNumber, cusClientType, cusSalesMgr, cusLang, cusOwnerLogin, conRef,
                    conCurrency, cusContactName, cusPhoneNumber1, cusPhoneNumber2, cusEmail,
                    cusName, cusAdr1, cusAdr2,
                    accountId, accountNumber, ownerId, ownerName, contactId, contactNumber,
                    optyId, optyNumber, activityId, activityNumber,
                    caed, caedDat, caedCount, caedError,
                    caedFaultString, accounted, accountedDat,
                    accountedError, accountedFault, accountedFaultString, cusAccount])
            conn.commit()
            params = {}
            params['id'] = account['EVENTID']
            if caed.startswith('Y') and accounted.startswith('Y'):
                params['event_status'] = 'SUCCESS'
            else:
                params['event_status'] = 'ERROR'
            l_return = c_event.m_cit_patch_event(json.dumps(params))

        c1.close()


# ----------------------------------------------------------------------------------------------------------------------
if __name__ == "__main__":
    main()
    conn.close()
