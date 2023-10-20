# Description of class module_login: 
#   - m_api_login: function to login to SCORE API (to get a SCORE token)
#                  Entry: json: {'api_login': 'SCORE_INTERFACE_CLEAR'}
#                  Returns: json: {'status_code': 200, 'token': 'the_token'}
#                           or
#                           json: {'status_code': error_code, 'error_message': 'the_error_message'}
# Author: BEVRIG1
# Date: 21/06/2023
# Last modifications:
#  version 1.0: BEVRIG1 - 21/06/2023 - initial version
#

import os
import requests
import json
import logging
logging.basicConfig(format='%(asctime)s - %(levelname)s: %(message)s', 
                    level=getattr(logging, os.getenv('LOGGING_LEVEL').upper()))

class  module_login:

  def m_api_login(self, l_json):
    
    the_json = json.loads(l_json)

    logging.info('m_api_login JSON received: ' + str(the_json))

    user_json = str(the_json['api_login']).strip()

    logging.info('m_api_login: user received: ' + user_json)
    v_url_to_call = os.getenv('SCORE_API_URL_LOGIN')
    api_login= os.getenv(user_json + '_USR')
    api_password= os.getenv(user_json + '_PSW')

    logging.debug('m_api_login: url_to_call: ' + str(v_url_to_call))
    l_data_to_send = {}
    l_data_to_send['userName'] = str(api_login)
    l_data_to_send['userPass'] = str(api_password)
    #logging.debug(str('to send: ') + str(l_data_to_send))

    l_case_json = json.dumps(l_data_to_send)

    the_response = {}

    try:
      the_headers = {'Content-Type': 'application/json'}
      #response = requests.put(v_url_to_call, headers=the_headers, data=l_case_json, verify=False)
      #logging.debug('Tests whitout verify=False')
      response = requests.put(v_url_to_call, headers=the_headers, data=l_case_json)
        
      body = response.json()
      #logging.debug("module.login: Response body: " + str(body))
      logging.debug(('m_api_login: response.status_code: ' + str(response.status_code )))
    
    
      the_response['status_code'] = response.status_code
      if response.status_code == 200 or response.status_code == 201:
           #logging.debug('module.login: response.status_code: ' + str(response.status_code ))
           the_response['status_code'] = 200
           the_token = response.headers.get("X-AUTH-TOKEN")
           #logging.debug('module.login: token received: ' + str(the_token))
           the_response['token'] = the_token
      else:
         the_response['status_code'] = response.status_code
         logging.error('m_api_login: content: ' + str(response.content))
         the_response['error_message'] = 'Login denied'   

    except:
        error_message = "Cannot call the login API"
        logging.error('m_api_login: Cannot call the login API') 
        the_response['status_code'] = 500
        the_response['error_message'] = 'Cannot call the login API' 

    logging.info('m_api_login returns: ' + str(the_response))
    return json.dumps(the_response)

   