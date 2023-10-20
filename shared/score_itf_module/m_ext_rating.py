

# Description: 
#  Module m_ext_rating: functions handling CRUD operations in Score on the external ratings
#    Entry: l_json: {'token': 'XXX', 'refindividu': 'YYYYYYYYYY', 'title': 'OBSERVATION DE CLEAR', 'info': 'ZZZZZZZZZZZZZZZ'}
#    Returns:  the_response['status_code']
#              the_response['error_message'] if not OK (200 or 201)
# Author: BEYCNE1
# Date: 12/07/2023
# Last modifications:
#  version 1.0: BEYCNE1 - 12/07/2023 - initial version
#

import datetime

import os
import requests
import json
import logging
import sys
logging.basicConfig(format='%(asctime)s - %(levelname)s: %(message)s', 
                    level=getattr(logging, os.getenv('LOGGING_LEVEL').upper()))

class module_ext_rating:

  def m_api_post_ext_rating(self, l_json):
    
    the_json = json.loads(l_json)

    logging.info('m_api_add_ext_rating: JSON received: ' + str(the_json))

    the_token = the_json['token']
    
    v_url_to_call = os.getenv('SCORE_API_URL_EXT_RATING_POST') % the_json['refindividu'] 

    logging.info('m_api_post_ext_rating: url: ' + str(v_url_to_call))
    
    l_data_to_send = {}
    l_data_to_send['issuerAbbrev'] = the_json['rating_issuer']
    l_data_to_send['rateDate'] = the_json['rating_date']
    l_data_to_send['rating'] = the_json['rating']
    logging.info('m_api_post_ext_rating: l_data_to_send ' + str(l_data_to_send))

    l_json = json.dumps(l_data_to_send)
    
    try:
      headers = {'Content-Type': 'application/json',
                 'X-AUTH-TOKEN': the_token}
      response = requests.post(v_url_to_call, headers=headers, data=l_json)
        
      if response.status_code == 200 or response.status_code == 201:
         return response.status_code
         
      else:
         logging.error(('Status_code: ' + str(response.status_code)))
         logging.error(('Content: ' + str(response.content)))						
         sys.exit(1)	  
    except:
        logging.error('m_api_add_ext_rating: cannot call the external rating API') 
        sys.exit(1)	

  def m_api_put_ext_rating(self, l_json):
    
    the_json = json.loads(l_json)

    logging.info('m_api_put_ext_rating: JSON received: ' + str(the_json))

    the_token = the_json['token']
    
    v_url_to_call = os.getenv('SCORE_API_URL_EXT_RATING_PATCH') % (the_json['refindividu'], the_json['ext_rating_id'])

    logging.info('m_api_put_ext_rating: url_to_call : ' + str(v_url_to_call))
	
    l_data_to_send = {}
    l_data_to_send['issuerAbbrev'] = the_json['rating_issuer']
    l_data_to_send['rateDate'] = the_json['rating_date']
    l_data_to_send['valDate'] = the_json['val_date']	
    l_data_to_send['rating'] = the_json['rating']
    logging.info('m_api_put_ext_rating: l_data_to_send ' + str(l_data_to_send))

    l_json = json.dumps(l_data_to_send)
    
    try:
      headers = {'Content-Type': 'application/json',
                 'X-AUTH-TOKEN': the_token}
      response = requests.patch(v_url_to_call, headers=headers, data=l_json)
        
      if response.status_code == 204:
         return response.status_code
         
      else:
         logging.error(('Status_code: ' + str(response.status_code)))
         logging.error(('Content: ' + str(response.content)))						
         sys.exit(1)	  
    except:
        logging.error('m_api_put_ext_rating: cannot call the external rating API') 
        sys.exit(1)	   