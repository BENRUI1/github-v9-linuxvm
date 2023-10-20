# Module module_case
# Functions:
#  - m_api_get_case_partners (BEODEL1)
#  - m_api_search_case (BEVRIG1)
#
import datetime
import os
import requests
import json
import logging
import sys

# setting path()
sys.path.append(os.path.join(os.getcwd(), "python"))
sys.path.append(os.path.join(os.getcwd(), "shared"))

# importing
from score_itf_module.m_chrono import module_chrono

#logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(message)s')
logging.basicConfig(format='%(asctime)s - %(levelname)s: %(message)s', 
                    level=getattr(logging, os.getenv('LOGGING_LEVEL').upper()))


class  module_case:

  def m_api_get_case_partners(self, p_json):
    
    l_json = json.loads(p_json)
    logging.info('m_api_get_case_partners JSON received: ' + str(l_json))

    xAuthToken = l_json['token']
    caseRef = l_json['caseRef']
    #logging.debug('url for events: ' + str(url))

    payload = {}
    ok_to_continue = True

    try:
        url = os.getenv('SCORE_API_URL_CASE_PARTNER') % (caseRef)
        logging.debug('Url case_partner: ' + str(url))
        headers = {'Content-Type': 'application/json', 'X-AUTH-TOKEN': xAuthToken}
        #response = requests.get(url, headers=headers, verify=False)
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            body = response.json()
            payload['status_code'] = response.status_code
            partners = []
            for partner in body:
                partnerDict = {}
                partnerDict['partnerType'] = partner['roleIndiv']
                partnerDict['partnerRefImx'] = partner['refIndiv']
                partnerDict['partnerName'] = partner['nameIndiv']
                partners.append(partnerDict)
            payload['partners'] = partners
        else:
            payload['status_code'] = response.status_code
            payload['error_message'] = 'case Partner not found'
            ok_to_continue = False

    except:
        logging.error('Cannot call partners API') 
        payload['status_code'] = 500
        payload['error_message'] = 'Cannot call partners API' 

    return json.dumps(payload)

  # Description: 
  #  Function m_api_search_case: function searching a case following a case external reference
  #    Entry: l_json:  {'token': 'XXXXX', 'extCaseRef': YYYYYYYY}
  #    Returns:  {'status_code': 200, 
  #               'case': 
  #                   {'content': [ 
  #                                {'caseRef': '2304260004', 'clientCaseRef': None, 'extCaseRef': '1212121', 'parentCaseId': None, 
  #                                 'caseCateg': 'INSURED', 'displayCaseCateg': 'INSURED', 'currency': 'EUR', 'active': True, 
  #                                 'searchArchived': None, 'party1Name': 'CLAIMS DEPARTMENT BEL', 'party2Name': 'LAURENCE BEL', 
  #                                 'party2Address': 'TEST LA1', 'clAccCode': None, 'dbFirstName': None, 'dbExtRef': None, 
  #                                 'superiorRef': '2303010009', 'territorialDivision': None, 'birthDate': None, 'situationDate': None, 
  #                                 'email': None, 'corpName1': None, 'indivSituation': None, 'displayIndivSituation': None, 'corpSign': None, 
  #                                 'dbPostCode': '6929', 'dbCity': 'DAVERDISSE', 'dbCountry': 'BEL', 'dbAdr2': None, 'dbAdr3': None, 
  #                                 'dbAdr4': None, 'clAddr1': 'AVENUE PRINCE DE LIEGE 78', 'clAddr2': None, 'clAddr3': None, 'clAddr4': None, 
  #                                 'clCountry': 'BEL', 'clCity': 'JAMBES', 'clPostCode': '5100', 'party3Name': None, 'frStatus': None?
  #                                 'dbTel': None, 'finalNote': None}
  #                               ], 
  #                    'pageable': {'sort': 
  #                                    {'unsorted': True, 'empty': True, 'sorted': False}, 
  #                                    'offset': 0, 'pageNumber': 0, 'pageSize': 2000, 'paged': True, 'unpaged': False
  #                                }, 
  #                    'first': True, 
  #                    'sort': {'unsorted': True, 'empty': True, 'sorted': False}, 
  #                    'size': 2000, 'number': 0, 'last': True, 
  #                    'numberOfElements': 1, 
  #                    'empty': False
  #                   }
  #             }
  # Author: BEVRIG1
  # Date: 10/07/2023
  # Last modifications:
  #  version 1.0: BEVRIG1 - 10/07/2023 - initial version 
  #
  def m_api_search_case(self, l_json):
    
    the_json = json.loads(l_json)

    logging.info('m_api_search_case JSON received: ' + str(the_json))

    the_token = the_json['token']
    the_ext_ref = the_json['extCaseRef']
    v_url_to_call = os.getenv('SCORE_API_URL_SEARCH')
    
    logging.debug('m_api_search_case: url_to_call for Search: ' + str(v_url_to_call))
    #logging.debug(print('the_token: ' + str(the_token)))
    logging.debug('m_api_search_case: the_ext_ref: ' + str(the_ext_ref))

    l_data_to_send = {}
    l_data_to_send['extCaseRef'] = the_ext_ref

    logging.debug(str('m_api_search_case: data to send: ') + str(l_data_to_send))

    l_case_json = json.dumps(l_data_to_send)
    
    the_response = {}

    try:
      headers = {'Content-Type': 'application/json',
                 'X-AUTH-TOKEN': the_token}
      #response = requests.put(v_url_to_call, headers=headers, data=l_case_json, verify=False)
      response = requests.put(v_url_to_call, headers=headers, data=l_case_json)
        
      logging.debug('m_api_search_case: Response body: ' + str(response))
      logging.debug('m_api_search_case: response.status_code: ' + str(response.status_code ))
      the_response['status_code'] = response.status_code
      if response.status_code == 200 or response.status_code == 201:
           #logging.debug('m_api_search_case: response.status_code: ' + str(response.status_code ))
           #logging.debug('header received: ' + str(response.headers))
           l_location = response.headers.get("LOCATION") + '?page=1&size=2000'
           logging.debug('m_api_search_case: location: ' + str(l_location))
           #response2 = requests.get(l_location, headers=headers, verify=False)
           response2 = requests.get(l_location, headers=headers)
           logging.debug('m_api_search_case: response2.status_code: ' + str(response2.status_code ))
           if response2.status_code == 200 or response2.status_code == 201:
             #logging.debug('module.login: response2.status_code: ' + str(response2.status_code ))
             #logging.debug("Final Response body: " + str(response2))
             body = response2.json()
             logging.debug('m_api_search_case: numberOfElement: ' + str(body['numberOfElements']))
             #logging.debug("Response2 body: " + str(body))
             the_response['status_code'] = response2.status_code
             the_response['case'] = body
           else:
             the_response['status_code'] = response2.status_code
             the_response['error_message'] = 'Case not found'  
      else:
         the_response['error_message'] = 'Case not found'   

    except:
        error_message = "Cannot call the search API"
        logging.error('m_api_search_case: Cannot call the SEARCH API') 
        the_response['status_code'] = 500
        the_response['error_message'] = 'Cannot call the SEARCH API' 

    #logging.info('m_api_search_case:  returns: ' + str(the_response))
    return json.dumps(the_response)
  
  def m_api_patch_initial_piece(self, l_json):
        
    the_json = json.loads(l_json)

    logging.info('m_api_patch_initial_piece called')
    #logging.debug('m_api_patch_initial_piece JSON received: ' + str(the_json))

    the_token = the_json['token']
    the_ext_ref = the_json['caseIMXReference']
    v_url_to_call = os.getenv('SCORE_API_URL_INITIAL_PIECE') % (the_ext_ref)
    logging.debug('Url initial piece: ' + v_url_to_call)
    the_response = {}
    try:
      #	Find intial piece internal reference
      headers = {'Content-Type': 'application/json',
                 'X-AUTH-TOKEN': the_token}
      #response = requests.get(v_url_to_call, headers=headers, data=the_json, verify=False)
      response = requests.get(v_url_to_call, headers=headers, data=the_json)
      
      logging.debug('m_api_patch_initial_piece: response.status_code: ' + str(response.status_code))
      if response.status_code == 200 or response.status_code == 201:
        body = response.json()
        logging.debug('m_api_patch_initial_piece: Response body: ' + str(body))
        l_documentRef = body['documentRef']
        logging.debug('m_api_patch_initial_piece: documentRef: '+ str(l_documentRef))
        v_url_to_call_2 = os.getenv('SCORE_API_URL_INITIAL_PIECE_INF') % (the_ext_ref, l_documentRef)
        logging.debug('m_api_patch_initial_piece: Url initial piece 2: ' + v_url_to_call_2)
        #response2 = requests.get(v_url_to_call_2, headers=headers, data=the_json, verify=False)
        response2 = requests.get(v_url_to_call_2, headers=headers, data=the_json)
        logging.debug('m_api_patch_initial_piece: response2.status_code: ' + str(response2.status_code))
        body2 = response2.json()
        if response2.status_code == 200 or response2.status_code == 201:
          logging.debug('m_api_patch_initial_piece: Response body2: ' + str(body2))
          data_func = {}
          data_func['infoTabsTr'] = body2
          if the_json['claimType'] is not None:
            data_func['infoTabsTr']['claimType'] = the_json['claimType']
          if the_json['claimHandler'] is not None:
            data_func['infoTabsTr']['claimManager'] = the_json['claimHandler']  
          if the_json['indemnAmount'] is not None:
            data_func['infoTabsTr']['indemAmt'] = the_json['indemnAmount']  
          if the_json['indemnCurr'] is not None:
            data_func['infoTabsTr']['buCurrency'] = the_json['indemnCurr']  
          if the_json['indemnDate'] is not None:
            data_func['infoTabsTr']['indemDate'] = the_json['indemnDate']  
          if the_json['coverageAmount'] is not None:
            data_func['infoTabsTr']['coverageAmount'] = the_json['coverageAmount']  
          if the_json['initialSharingPct'] is not None:
            data_func['infoTabsTr']['initialSharing'] = the_json['initialSharingPct']  
          if the_json['claimNature'] is not None:
            data_func['infoTabsTr']['claimNature'] = the_json['claimNature']
          if the_json['coverageRate'] is not None:
            data_func['infoTabsTr']['coverageRate'] = the_json['coverageRate']
          logging.debug('m_api_patch_initial_piece: Call for patch: ' + str(data_func))
          #response3 = requests.patch(v_url_to_call_2, headers=headers, data=json.dumps(data_func), verify=False)
          response3 = requests.patch(v_url_to_call_2, headers=headers, data=json.dumps(data_func))
          logging.debug('m_api_patch_initial_piece: response3.status_code: ' + str(response3.status_code))
          
          if response3.status_code == 200 or response3.status_code == 201:
            
            #body3 = response3.json()
            #logging.debug('m_api_patch_initial_piece: Response body3: ' + str(body3))

            #policy contract
            if the_json['policyNumber'] is not None or the_json['policyCurr'] is not None or the_json['policyType'] is not None or the_json['productCode'] is not None:
              logging.debug('m_api_patch_initial_piece:Search of the piece Policy Contract')
              m_chrono = module_chrono()
              data_search = {}
              data_search['token'] = the_token
              data_search['caseIMXReference'] = the_ext_ref
              data_search['chronoType'] = 'pr'
              data_search['chronoLibelle'] = 'POLICY CONTRACT'
              l_search_result = m_chrono.m_api_search_chrono(json.dumps(data_search))
              the_json_search = json.loads(l_search_result)
              logging.debug('m_api_patch_initial_piece: Chrono search returned: ' + str(the_json_search['status_code']))
              the_response['status_code'] = the_json_search['status_code']
              if the_json_search['status_code'] == 200 or the_json_search['status_code'] == 201:
                logging.debug('m_api_patch_initial_piece: the_json_search: ' + str(the_json_search))
                logging.debug('m_api_patch_initial_piece: numberOfElement: ' + str(the_json_search['numberOfElements']))
                l_numberOfElements = the_json_search['numberOfElements']
                if l_numberOfElements == 0:
                  logging.debug('m_api_patch_initial_piece: Number of elements returned: ' + str(l_numberOfElements))   
                  error_message = "Search piece Policy Contract: Not Found"
                  logging.error('m_api_patch_initial_piece: Search piece Policy Contract: Not Found')
                  the_response['status_code'] =  903
                  the_response['error_message'] = error_message
                elif l_numberOfElements > 1:
                  logging.debug('m_api_patch_initial_piece: Number of elements returned: ' + str(l_numberOfElements))   
                  error_message = "Search piece Policy Contract: More than one contract Found"
                  logging.debug('m_api_patch_initial_piece: More than one contract Found')
                  the_response['status_code'] =  904
                  the_response['error_message'] = error_message    
                else:
                  logging.debug('m_api_patch_initial_piece: Number of elements returned: ' + str(l_numberOfElements))   
                  l_chronoRef = the_json_search['chronoRef']
                  logging.debug('m_api_patch_initial_piece:  chronoRef: ' + str(l_chronoRef))   
                  v_url_to_call = os.getenv('SCORE_API_URL_POLICY_CONTRACT_INF') % (the_ext_ref, l_chronoRef)  + '?docType=POLICY%20CONTRACT'
                  logging.debug('m_api_patch_initial_piece: url: ' + str(v_url_to_call))
                  #response = requests.get(v_url_to_call, headers=headers, verify=False)
                  response = requests.get(v_url_to_call, headers=headers)
                  the_response['status_code'] = response.status_code
                  logging.debug('m_api_patch_initial_piece: response.status_code: ' + str(response.status_code))
                  if response.status_code == 200 or response.status_code == 201:
                    body = response.json()
                    logging.debug('m_api_patch_initial_piece: Response body: ' + str(body))
                    data_func = {}
                    data_func = body
                    if the_json['policyNumber'] is not None:
                      data_func['policyNb'] = the_json['policyNumber']
                    if the_json['policyCurr'] is not None:
                      data_func['policyCur'] = the_json['policyCurr']  
                    if the_json['policyType'] is not None:
                      data_func['policyType'] = the_json['policyType'] 
                    if the_json['productCode'] is not None:
                      data_func['prodCode'] = the_json['productCode']
                    data_func['docType'] = 'POLICY CONTRACT'
                    data_func['docRef'] = l_chronoRef
                    logging.debug('m_api_patch_initial_piece: Call for patch: ' + str(data_func))
                    #response2 = requests.patch(v_url_to_call, headers=headers, data=json.dumps(data_func), verify=False)
                    response2 = requests.patch(v_url_to_call, headers=headers, data=json.dumps(data_func))
                    logging.debug('m_api_patch_initial_piece: response2.status_code: ' + str(response2.status_code))
                    the_response['status_code'] = response2.status_code
                    if response2.status_code == 200 or response2.status_code == 201:
                       logging.debug('m_api_patch_initial_piece: Completed') 
                    else:
                      error_message = "m_api_patch_initial_piece: PATCH policy contract piece error: " + str(response2.content)
                      logging.error('m_api_patch_initial_piece: Patch policy contract issue') 
                      logging.error('m_api_patch_initial_piece: content: ' + str(response2.content))
                      the_response['error_message'] = error_message   
                  else:
                    error_message = "m_api_patch_initial_piece: Get policy contract piece error: " + str(response.content)
                    logging.error('m_api_patch_initial_piece: Get policy contract issue') 
                    logging.error('m_api_patch_initial_piece: content: ' + str(response.content))
                    the_response['error_message'] = error_message          
              else:
                error_message = "m_api_patch_initial_piece: Chrono search issue"
                logging.error('m_api_patch_initial_piece: Chrono search issue') 
                the_response['error_message'] = error_message     
          else:
            error_message = "Cannot call the PATCH INITIAL_PIECE API INFORMATION"
            logging.error('m_api_patch_initial_piece: Cannot PATCH the INITIAL_PIECE API INFORMATION') 
            logging.error('m_api_patch_initial_piece: response3.content: ' + str(response3.content))
            the_response['status_code'] = response2.status_code
            the_response['error_message'] = error_message     
        else:
          error_message = "Cannot call the GET INITIAL_PIECE API INFORMATION"
          logging.error('m_api_patch_initial_piece: Cannot GET the INITIAL_PIECE API INFORMATION') 
          logging.error('m_api_patch_initial_piece: response2.content: ' + str(response2.content))
          the_response['status_code'] = response2.status_code
          the_response['error_message'] = error_message 

      else:
        error_message = "Cannot call the search INITIAL_PIECE API"
        logging.error('m_api_patch_initial_piece: Cannot GET the INITIAL_PIECE API') 
        logging.error('m_api_patch_initial_piece: response.content: ' + str(response.content))
        the_response['status_code'] = response.status_code
        the_response['error_message'] = 'Cannot get the INITIAL_PIECE API' 

      # as still in development  
      #the_response['status_code'] = 999
      #the_response['error_message'] = 'Currently in development...'
    except:
      error_message = "Cannot call the search INITIAL_PIECE API"
      logging.error('m_api_patch_initial_piece: Cannot call the INITIAL_PIECE API') 
      the_response['status_code'] = 500
      the_response['error_message'] = 'Cannot call the INITIAL_PIECE API' 

    
    return json.dumps(the_response)
  
