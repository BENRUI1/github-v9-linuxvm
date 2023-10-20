# Description of the mobile: 
#  Function m_api_create_direct_payment: function handling the creation of a direct payment to SCORE
#  Function m_api_create_payment_to_AC: function handling the creation of a payment to AC to SCORE    
#  Function mm_api_cancel_payment: function to delete a payment in SCORE (in development)
# Author: BEVRIG1
# Date: 21/06/2023
# Last modifications:
#  version 1.0: BEVRIG1 - 21/06/2023 - initial version
#

import datetime
import os
import requests
import json
import logging
import sys
import urllib3

# setting path()
sys.path.append(os.path.join(os.getcwd(), "python"))
sys.path.append(os.path.join(os.getcwd(), "shared"))

# importing
from score_itf_module.m_case import module_case

#logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(message)s')
logging.basicConfig(format='%(asctime)s - %(levelname)s: %(message)s', 
                    level=getattr(logging, os.getenv('LOGGING_LEVEL').upper()))

class  module_payment:

    def m_api_create_direct_payment(self, p_json):
        
        l_json = json.loads(p_json)
        logging.info('m_api_create_direct_payment JSON received: ' + str(l_json))
        
        xAuthToken = l_json['token']
        l_caseRef = l_json['caseImxReference']

        partners = {}
        partners['token'] = xAuthToken
        partners['caseRef'] = l_caseRef

        the_response = {}

        m_case = module_case()
        response_partners = m_case.m_api_get_case_partners(json.dumps(partners))

        logging.debug('m_api_create_direct_payment: response_partners: ' +str(response_partners))
        the_return_partner = json.loads(response_partners)
        
        l_refpayer = None
        l_refbenef = None

        the_response['status_code'] = the_return_partner['status_code']
        if the_return_partner['status_code'] == 200:
          the_response['error_message'] = None  
          
          for partner in the_return_partner['partners']:
                if partner['partnerType'] == 'DB':
                  l_refpayer = partner['partnerRefImx']
                elif partner['partnerType'] == 'CL':
                   l_refbenef = partner['partnerRefImx']
         
          logging.debug('m_api_create_direct_payment: l_refpayer : ' + str(l_refpayer))
          logging.debug('m_api_create_direct_payment: l_refbenef : ' + str(l_refbenef))

          l_data_to_send = {}
          l_data_to_send['caseRef'] = str(l_caseRef)
          l_data_to_send['receptionDate'] = str(l_json['payReceptionDate'])
          l_data_to_send['refpayer'] = str(l_refpayer)
          l_data_to_send['refbenef'] = str(l_refbenef)
          l_data_to_send['pmtCurr'] = str(l_json['payCurrency'])
          l_data_to_send['pmtAmt'] = str(l_json['payAmount'])
          pmtTitle = {}
          pmtTitle['abbrev'] = str(l_json['payTitle'])
          l_data_to_send['pmtTitle'] = pmtTitle
          pmtMethod = {}
          pmtMethod['abbrev'] = str(l_json['payMethod'])
          l_data_to_send['pmtMethod'] = pmtMethod
          # put in comment because Codix has remove these fields as mandatory
          #l_data_to_send['showBankFields'] = True
          #bankAccount = {}
          #bankAccount['dom'] = False
          #bankAccount['payment'] = False
          #bankAccount['sepa'] = False
          #bankAccount['act'] = False
          #bankAccount['guaranteeAccount'] = False
          #l_data_to_send['bankAccount'] = bankAccount
          #l_data_to_send['refperso'] = 83
          # new field, waiting feedback from Codix
          l_data_to_send['pmtExternalRef'] = str(l_json['payExtRef'])
          logging.debug('m_api_create_direct_payment:  l_data_to_send: ' + str(l_data_to_send))
          v_url_to_call = os.getenv('SCORE_API_URL_CREATE_DIRECT_PAYMENT') % (l_caseRef)
          logging.debug('m_api_create_direct_payment: url: ' + str(v_url_to_call))
          headers = {'Content-Type': 'application/json',
                     'X-AUTH-TOKEN': xAuthToken}
          logging.debug('m_api_create_direct_payment: token: ' + str(xAuthToken))
          
          response = requests.put(v_url_to_call, headers=headers, data=json.dumps(l_data_to_send))
      
          logging.debug('m_api_create_direct_payment: response.status_code: ' + str(response.status_code))
          the_response['status_code'] = response.status_code
          if response.status_code == 200 or response.status_code == 201:
            l_location = response.headers.get("LOCATION")
            logging.debug('m_api_create_direct_payment: location: ' + str(l_location))
            #logging.debug('m_api_create_direct_payment: content: ' + str(response.content))
            #logging.debug('m_api_create_direct_payment: headers: ' + str(response.headers))
            the_date = datetime.datetime.now().strftime("%Y-%m-%d")
            print('date: ' + str(the_date))
            l_data_to_send2 = {}
            l_data_to_send2['currentDate'] = str(the_date)
            allocationList = []
            allocationListDict = {}
            allocationListDict['intCaseRef'] = l_caseRef
            allocationListDict['caseCurr'] = str(l_json['payCurrency'])
            allocationListDict['amt'] = str(l_json['payAmount'])
            paymentReason = {}
            paymentReason['value'] = ""
            paymentReason['abbreviation'] = ""
            paymentReason['displayValue'] = ""
            paymentReason['displayAbbreviation'] = ""
            allocationListDict['paymentReason'] = paymentReason
            allocationList.append(allocationListDict)
            #l_data_to_send2['allocationList'] = json.dumps(allocationList)
            l_data_to_send2['allocationList'] = allocationList

            files = {
                     'directPmtCtx': ('None', json.dumps(l_data_to_send2), 'application/json')
            }

            l_encoded, l_content_type = urllib3.filepost.encode_multipart_formdata(files, boundary=None)

            headers2 = {'Content-Type': l_content_type,
                        'x-auth-token': xAuthToken}
            logging.debug('m_api_create_direct_payment:  l_headers2: ' + str(headers2))
            logging.debug('m_api_create_direct_payment:  l_encoded: ' + str(l_encoded))
            
            response2 = requests.post(l_location, headers=headers2, data=l_encoded)
            logging.debug('m_api_create_direct_payment: response2.status_code: ' + str(response2.status_code ))
            the_response['status_code'] = str(response2.status_code)
            if response2.status_code == 200 or response2.status_code == 201:
               body = response2.json()
               logging.debug('m_api_create_direct_payment: body: ' + str(body))
               the_response['pmtIMXRef'] = str(body['refDirectPayment'])
            else:
               the_response['error_message'] = str(response2.content)  
               logging.error('m_api_create_direct_payment: ' + str(str(response2.content)))
          else:
            the_response['error_message'] = str(response.content)          
            logging.error('m_api_create_direct_payment: ' + str(str(response.content)))

        else:
          the_response['error_message'] = the_return_partner['error_message']

        return json.dumps(the_response)

    ##########################################################################################

    def m_api_create_payment_to_AC(self, p_json):
            
        l_json = json.loads(p_json)
        logging.info('m_api_create_payment_to_AC JSON received: ' + str(l_json))
        xAuthToken = l_json['token']
        l_caseRef = l_json['caseImxReference']

        partners = {}
        partners['token'] = xAuthToken
        partners['caseRef'] = l_caseRef

        the_response = {}

        m_case = module_case()
        response_partners = m_case.m_api_get_case_partners(json.dumps(partners))

        logging.debug('m_api_create_payment_to_AC: response_partners: ' +str(response_partners))
        the_return_partner = json.loads(response_partners)
        
        l_refpayer = None
        l_refbenef = None

        the_response['status_code'] = the_return_partner['status_code']
        if the_return_partner['status_code'] == 200:
          the_response['error_message'] = None  
          
          for partner in the_return_partner['partners']:
                if partner['partnerType'] == 'DB':
                  l_refpayer = partner['partnerRefImx']
                elif partner['partnerType'] == 'BU':
                   l_refbenef = partner['partnerRefImx']
         
          logging.debug('m_api_create_payment_to_AC: l_refpayer : ' + str(l_refpayer))
          logging.debug('m_api_create_payment_to_AC: l_refbenef : ' + str(l_refbenef))

          l_data_to_send = {}
          l_data_to_send['caseRef'] = str(l_caseRef)
          l_data_to_send['dateReception'] = str(l_json['payReceptionDate'])
          l_data_to_send['remitterRef'] = str(l_refpayer)
          l_data_to_send['payeeRef'] = str(l_refbenef)
          l_data_to_send['amt'] = str(l_json['payAmount'])
          l_data_to_send['curr'] = str(l_json['payCurrency'])
          pmtMethod = {}
          pmtMethod['abbrev'] = str(l_json['payMethod'])
          l_data_to_send['pmtMethod'] = pmtMethod
          paymentMethod = {}
          paymentMethod['abbrev'] = str(l_json['payMethod'])
          l_data_to_send['paymentMethod'] = paymentMethod
          paymentReason = {}
          paymentReason['abbrev'] = str(l_json['payTitle'])
          l_data_to_send['paymentReason'] = paymentReason
          #l_data_to_send['refperso'] = 83
          # new field, waiting feedback from Codix
          l_data_to_send['pmtExternalRef'] = str(l_json['payExtRef'])
          logging.debug('m_api_create_payment_to_AC:  l_data_to_send: ' + str(l_data_to_send))
          v_url_to_call = os.getenv('SCORE_API_URL_CREATE_PAYMENT_TO_AC') % (l_caseRef, l_refpayer)
          logging.debug('m_api_create_payment_to_AC: url: ' + str(v_url_to_call))
          headers = {'Content-Type': 'application/json',
                     'X-AUTH-TOKEN': xAuthToken}
          logging.debug('m_api_create_payment_to_AC: token: ' + str(xAuthToken))
          
          response = requests.put(v_url_to_call, headers=headers, data=json.dumps(l_data_to_send))
      
          logging.debug('m_api_create_payment_to_AC: response.status_code: ' + str(response.status_code))
          the_response['status_code'] =response.status_code
          if response.status_code == 200 or response.status_code == 201:
            l_location = response.headers.get("LOCATION")
            logging.debug('m_api_create_payment_to_AC: location: ' + str(l_location))
            #logging.debug('m_api_create_payment_to_AC: content: ' + str(response.content))
            #logging.debug('m_api_create_payment_to_AC: headers: ' + str(response.headers))
            the_date = datetime.datetime.now().strftime("%Y-%m-%d")
            print('date: ' + str(the_date))

            l_data_to_send2 = {}
            l_data_to_send2['currentDate'] = str(the_date)
            allocationList = []
            allocationListDict = {}
            allocationListDict['intCaseRef'] = l_caseRef
            paymentReason = {}
            paymentReason['abbrev'] = str(l_json['payTitle'])
            allocationListDict['paymentReason'] = paymentReason
            allocationListDict['amt'] = str(l_json['payAmount'])
            allocationList.append(allocationListDict)
            l_data_to_send2['allocationList'] = allocationList

            logging.debug('m_api_create_payment_to_AC: l_data_to_send2: ' + str(l_data_to_send2))

            response2 = requests.post(l_location, headers=headers, data=json.dumps(l_data_to_send2))
            logging.debug('m_api_create_payment_to_AC: response2.status_code: ' + str(response2.status_code ))
            the_response['status_code'] = response2.status_code
            if response2.status_code == 200 or response2.status_code == 201:
               body = response2.json()
               logging.debug('m_api_create_payment_to_AC: body: ' + str(body))
               the_response['pmtIMXRef'] = str(body['refPayment'])
            else:
               the_response['error_message'] = str(response2.content)  
               logging.error('m_api_create_payment_to_AC: ' + str(str(response2.content)))
          else:
            the_response['error_message'] = str(response.content)          
            logging.error('m_api_create_payment_to_AC: ' + str(str(response.content)))

        else:
          the_response['error_message'] = the_return_partner['error_message']

        return json.dumps(the_response)

    ##########################################################################################
    
    def m_api_cancel_payment(self, p_json):
            
        the_json = json.loads(p_json)

        logging.info('m_api_cancel_payment JSON received: ' + str(the_json))

        the_token = the_json['token']
        l_case = the_json['caseIMXReference']
        l_infoIMX = the_json['pmtIMXRef']
        l_pmtType = the_json['pmtType']
        v_url_to_call = os.getenv('SCORE_API_URL_DELETE_PAYMENT') % (l_case, l_infoIMX, l_pmtType)
        logging.debug('m_api_cancel_payment: url: ' + str(v_url_to_call))
    
        the_response = {}

        try:
          headers = {'Content-Type': 'application/json',
                    'X-AUTH-TOKEN': the_token}
          payload = json.dumps({
                                "cancellationReason": "test"
                              })

          response = requests.post(v_url_to_call, headers=headers, data=payload)
        
          logging.debug('m_api_cancel_payment: Response body: ' + str(response))
          logging.debug('m_api_cancel_payment: response.status_code: ' + str(response.status_code ))
      
          if response.status_code == 200 or response.status_code == 201 or response.status_code == 204:
            the_response['status_code'] = response.status_code
         
          else:
            the_response['status_code'] = response.status_code
            the_response['error_message'] = str(response.content)   

        except:
           logging.error('m_api_cancel_payment: Cannot call the delete information API') 
           the_response['status_code'] = 500
           the_response['error_message'] = 'Cannot call the delete Payment API' 
    
        logging.info('m_api_cancel_payment returns: ' + str(the_response))

        return json.dumps(the_response)

