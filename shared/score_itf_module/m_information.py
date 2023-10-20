

# Description of the mobile: 
#  Function m_api_add_info: function handling the sent of an information to SCORE
#    Entry: l_json: {'token': 'XXX', 'caseIMXReference': 'YYYYYYYYYY', 'caseExternalReference' : 'AAAAAA', 'title': 'OBSERVATION DE CLEAR', 'info': 'ZZZZZZZZZZZZZZZ'}
#    Returns:  the_response['status_code']
#              the_response['error_message'] if not OK (200 or 201)
# Function m_api_del_info: frunction deleting an information from SCORE    
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

# setting path()
sys.path.append(os.path.join(os.getcwd(), "python"))
sys.path.append(os.path.join(os.getcwd(), "shared"))

from score_itf_module.m_case import module_case

logging.basicConfig(format='%(asctime)s - %(levelname)s: %(message)s', 
                    level=getattr(logging, os.getenv('LOGGING_LEVEL').upper()))

class  module_information:

  def m_api_add_info(self, l_json):
    
    the_json = json.loads(l_json)
    logging.info('module_information - m_api_add_info called')
    logging.debug('m_api_add_info: JSON received: ' + str(the_json))

    the_token = the_json['token']
    l_case = None

    if the_json['caseIMXReference'] is None:
      if the_json['caseExternalReference'] is not None:  
        l_externalRef = the_json['caseExternalReference']
        m_case = module_case()    
        data_search = {}
        data_search['token'] = the_token
        data_search['extCaseRef'] = l_externalRef
        l_search_result = m_case.m_api_search_case(json.dumps(data_search))
        the_json_search = json.loads(l_search_result)
        logging.debug('m_api_add_info: Search returned: ' + str(the_json_search['status_code']))
        if the_json_search['status_code'] == 200 or the_json_search['status_code'] == 201:
            l_numberOfElements = the_json_search['case']['numberOfElements']
            if l_numberOfElements == 0:
              l_error_code =  901
              l_error_message = 'm_api_add_info: No case found for caseRef ' + str(l_externalRef)
            elif l_numberOfElements > 1:
              l_error_code =  902
              l_error_message = 'm_api_add_info: More than one case found for caseRef ' + str(l_externalRef)
            else:
              l_case = the_json_search['case']['content'][0]['caseRef']
              logging.debug("m_api_add_info: : Case: " + l_case)
              #logging.debug("main_clear_score:  Number of elements: " + str(l_numberOfElements))
        else:
            l_error_code = the_json_search['status_code']
            l_error_message = the_json_search['error_message']   
      else:
            l_error_code = 401
            l_error_message = 'module_information: We do NOT received caseIMXReference, neither caseExternalReference'   
    else:
        l_case = the_json['caseIMXReference']

    if l_case is not None:
      
      v_url_to_call = os.getenv('SCORE_API_URL_INFO_ADD') % (l_case)
      #v_url_to_call = v_url_to_call + l_case + '/elements/informations'

      logging.debug('m_api_add_info:url_to_call for information: ' + str(v_url_to_call))
      logging.debug('m_api_add_info:Info to add: ' + the_json['info'])
      output_date = datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S.000Z")
    
      logging.debug('m_api_add_info: Info l_date: ' + str(output_date))
      l_data_to_send = {}
      l_data_to_send['entranceDate'] = str(output_date)
      l_data_to_send['title'] = the_json['title']
      l_data_to_send['freeHandTitle'] = the_json['info']
      logging.debug('m_api_add_info: l_data_to_send ' + str(l_data_to_send))

      l_case_json = json.dumps(l_data_to_send)
    
      the_response = {}

      try:
        headers = {'Content-Type': 'application/json',
                   'X-AUTH-TOKEN': the_token}
        #response = requests.post(v_url_to_call, headers=headers, data=l_case_json, verify=False)
        response = requests.post(v_url_to_call, headers=headers, data=l_case_json)
        
        logging.debug('m_api_add_info: Response body: ' + str(response))
        logging.debug('m_api_add_info: response.status_code: ' + str(response.status_code ))
      
        if response.status_code == 200 or response.status_code == 201:
           the_response['status_code'] = response.status_code
         
        else:
          the_response['status_code'] = response.status_code
          the_response['error_message'] = 'Cannot save the information'   

      except:
        logging.error('m_api_add_info: Cannot call the information API') 
        the_response['status_code'] = 500
        the_response['error_message'] = 'Cannot call the INFO API' 
    else:
       the_response['status_code'] = l_error_code
       the_response['error_message'] = l_error_message     
    
    logging.info('m_api_add_info returns: ' + str(the_response))
    return json.dumps(the_response)

  ###################################################################################################

  def m_api_del_info(self, l_json):
        
    the_json = json.loads(l_json)
    logging.info('module_information - m_api_del_info called')
    logging.debug('m_api_del_info: JSON received: ' + str(the_json))

    the_token = the_json['token']
    l_interfaceName = the_json['interfaceName']
    l_case = the_json['caseIMXReference']
    l_infoIMX = the_json['InformationRefIMX']
    v_url_to_call = os.getenv('SCORE_API_URL_INFO_DEL') % (l_case, l_infoIMX)
    logging.debug('m_api_del_info: url: ' + str(v_url_to_call))
    
    the_response = {}

    try:
      headers = {'Content-Type': 'application/json',
                 'X-AUTH-TOKEN': the_token}
      
      response = requests.delete(v_url_to_call, headers=headers)
        
      logging.debug('m_api_del_info: Response body: ' + str(response))
      logging.debug('m_api_del_info: response.status_code: ' + str(response.status_code ))
      
      if response.status_code == 204:
         the_response['status_code'] = response.status_code
         
      else:
         the_response['status_code'] = response.status_code
         the_response['error_message'] = 'Cannot delete the information'   

    except:
        logging.error('m_api_del_info: Cannot call the delete information API') 
        the_response['status_code'] = 500
        the_response['error_message'] = 'Cannot call the delete INFO API' 
    
    logging.info('m_api_del_info returns: ' + str(the_response))
    return json.dumps(the_response)

########################################################################################################

def m_api_get_info(self, l_json):
        
    the_json = json.loads(l_json)
    logging.info('module_information - m_api_get_info called')
    logging.debug('m_api_get_info: JSON received: ' + str(the_json))

    the_token = the_json['token']
    l_interfaceName = the_json['interfaceName']
    l_case = the_json['caseIMXReference']
    l_infoIMX = the_json['InformationRefIMX']
    v_url_to_call = os.getenv('SCORE_API_URL_INFO_GET') % (l_case, l_infoIMX)
    logging.debug('m_api_get_info: url: ' + str(v_url_to_call))

    the_response = {}

    try:
      headers = {'Content-Type': 'application/json',
                 'X-AUTH-TOKEN': the_token}
      payload = {}

      response = requests.get(v_url_to_call, headers=headers, data=json.dumps(payload))
        
      logging.debug('m_api_get_info: response.status_code: ' + str(response.status_code ))
      
      if response.status_code == 200:
         the_response['status_code'] = response.status_code
         the_response['content'] = response.text
      else:
         the_response['status_code'] = response.status_code
         the_response['error_message'] = 'Cannot delete the information'   

    except:
        logging.error('m_api_get_info: Cannot call the get information API') 
        the_response['status_code'] = 500
        the_response['error_message'] = 'Cannot call the get INFO API' 
    
    logging.info('m_api_get_info returns: ' + str(the_response))
    return json.dumps(the_response)
    
    
      