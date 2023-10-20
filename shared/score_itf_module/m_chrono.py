# Description of class module_chrono: 
#
#
# Author: BEVRIG1
# Date: 21/06/2023
# Last modifications:
#  version 1.0: BEVRIG1 - 11/07/2023 - initial version
#

import os
import requests
import json
import logging

logging.basicConfig(format='%(asctime)s - %(levelname)s: %(message)s', 
                    level=getattr(logging, os.getenv('LOGGING_LEVEL').upper()))

class  module_chrono:

  def m_api_search_chrono(self, l_json):
        
    the_json = json.loads(l_json)

    logging.info('m_api_search_chrono JSON received: ' + str(the_json))

    the_token = the_json['token']
    l_caseIMXReference = the_json['caseIMXReference']
    l_chronoType = the_json['chronoType']
    l_chronoLibelle = the_json['chronoLibelle']
    
    v_url_to_call = os.getenv('SCORE_API_URL_SEARCH_CHRONO') % (l_caseIMXReference)
    
    logging.debug('m_api_search_chrono: url_to_call for Search: ' + str(v_url_to_call))
    #logging.debug(print('the_token: ' + str(the_token)))
    logging.debug('m_api_search_chrono: caseIMXReference: ' + str(l_caseIMXReference))
    logging.debug('m_api_search_chrono: chronoType: ' + str(l_chronoType))
    logging.debug('m_api_search_chrono: chronoLibelle: ' + str(l_chronoLibelle))

    l_data_to_send = {}
    l_data_to_send['fltrEventType'] = l_chronoType
    l_data_to_send['fltrTitle'] = l_chronoLibelle

    logging.debug(str('m_api_search_chrono: data to send: ') + str(l_data_to_send))

    l_case_json = json.dumps(l_data_to_send)
    
    the_response = {}

    try:
      headers = {'Content-Type': 'application/json',
                 'X-AUTH-TOKEN': the_token}
      #response = requests.put(v_url_to_call, headers=headers, data=l_case_json, verify=False)
      response = requests.put(v_url_to_call, headers=headers, data=l_case_json)
        
      logging.debug('m_api_search_chrono: Response body: ' + str(response))
      logging.debug('m_api_search_chrono: response.status_code: ' + str(response.status_code ))
      the_response['status_code'] = response.status_code
      if response.status_code == 200 or response.status_code == 201:
           logging.debug('m_api_search_chrono: header received: ' + str(response.headers)) 
           l_location = response.headers.get("LOCATION") + '?page=1&size=2000'
           logging.debug('m_api_search_chrono: location: ' + str(l_location))
           #response2 = requests.get(l_location, headers=headers, verify=False)
           response2 = requests.get(l_location, headers=headers)
           logging.debug('m_api_search_chrono: response2.status_code: ' + str(response2.status_code ))
           if response2.status_code == 200 or response2.status_code == 201:
             logging.debug('m_api_search_chrono: response2.status_code: ' + str(response2.status_code ))
             body = response2.json()
             logging.debug('m_api_search_chrono: body ' + str(body))
             the_response['status_code'] = response2.status_code
             the_response['numberOfElements'] = body['numberOfElements']
             if body['numberOfElements'] > 0:
               the_response['content'] = body['content']
               the_response['chronoRef'] = body['content'][0]['eventRef']
           else:
             the_response['status_code'] = response2.status_code
             the_response['error_message'] = str(response2.content)
      else:
         the_response['error_message'] = 'Chrono not found'   
         logging.error('m_api_search_chrono: response.content: ' + str(response.content))

    except:
        error_message = "Cannot call the search API"
        logging.error('m_api_search_chrono: Cannot call the SEARCH API') 
        the_response['status_code'] = 500
        the_response['error_message'] = 'Cannot call the SEARCH API' 

    logging.info('m_api_search_case:  returns: ' + str(the_response))
    return json.dumps(the_response)

   