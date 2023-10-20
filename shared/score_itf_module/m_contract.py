import datetime

import os
import requests
import json
import logging
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(message)s')


class  module_contract:

  def m_api_get_contract(self, p_json):
    
    l_json = json.loads(p_json)
    logging.info('m_api_get_events JSON received: ' + str(l_json))

    xAuthToken = l_json['token']
    caseRef = l_json['caseRef']
    contractId = l_json['contractId']
    logging.info('url for events: ' + str(url))

    payload = {}
    ok_to_continue = True

    try:
        url = os.getenv('SCORE_API_URL_CONTRACT_HEADER') % (caseRef, contractId)
        logging.info('Url Contract_header: ' + url)
        headers = {'Content-Type': 'application/json', 'X-AUTH-TOKEN': xAuthToken}
        response = requests.get(url, headers=headers, verify=False)
        if response.status_code == 200:
            body = response.json()
            payload['caseRef'] = caseRef
            payload['contractId'] = contractId
            payload['statusAbrev'] = body['statusAbrev']
            payload['statusValue'] = body['statusValue']
        else:
            payload['status_code'] = response.status_code
            payload['error_message'] = 'Contract Header not found'
            ok_to_continue = False

        if ok_to_continue is True:
            url = os.getenv('SCORE_API_URL_CONTRACT_PARAMS') % (caseRef, contractId)
            logging.info('Url Contract_parameters: ' + url)
            headers = {'Content-Type': 'application/json', 'X-AUTH-TOKEN': xAuthToken}
            response = requests.get(url, headers=headers, verify=False)
            if response.status_code == 200:
                body = response.json()
                payload['contractStartDate'] = body['contractStartDate']
                payload['saleAgent'] = body['saleAgent']
                payload['saleAgentRef'] = body['saleAgentRef']
            else:
                payload['status_code'] = response.status_code
                payload['error_message'] = 'Contract Parameters not found'
                ok_to_continue = False

        if ok_to_continue is True:
            url = os.getenv('SCORE_API_URL_CONTRACT_INV_PARAMS') % (caseRef, contractId)
            logging.info('Url Contract_Inv_parameters: ' + url)
            headers = {'Content-Type': 'application/json', 'X-AUTH-TOKEN': xAuthToken}
            response = requests.get(url, headers=headers, verify=False)
            if response.status_code == 200:
                body = response.json()
                payload['invoiceCurrency'] = body['invoiceCurrency']
            else:
                payload['status_code'] = response.status_code
                payload['error_message'] = 'Contract Invoicing Parameters not found'
                ok_to_continue = False


    except:
        logging.error('Cannot call contract APIs') 
        payload['status_code'] = 500
        payload['error_message'] = 'Cannot call contract APIs' 

    return json.dumps(payload)
