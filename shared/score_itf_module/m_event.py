import datetime

import os
import requests
import json
import logging
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(message)s')


class  module_event:

    def m_api_get_events(self, p_json):
        
        l_json = json.loads(p_json)
        logging.info('m_api_get_events JSON received: ' + str(l_json))

        xAuthToken = l_json['token']
        url = os.getenv('SCORE_API_URL_EVENT_SEARCH')
        logging.info('url for events: ' + str(url))

        criteria = {"alreadyExported": False}
        payload = {}
        payload = json.dumps({})

        try:
            headers = {'Content-Type': 'application/json', 'X-AUTH-TOKEN': xAuthToken}
            response = requests.put(url, headers=headers, data=payload)
            #response = requests.put(url, headers=headers)

            logging.info('Response: ' + str(response))
            logging.info(('Status_code: ' + str(response.status_code )))
        
            if response.status_code == 200 or response.status_code == 201:
                payload = {}
                url = response.headers['LOCATION'] + '?page=1&size=2000'
                logging.info(' location: ' + str(url))
                response = requests.get(url, headers=headers)
                body = response.json()
                if body['numberOfElements'] == 0:
                    logging.info('No events found')                    
                    payload['status_code'] =  901
                    payload['error_message'] = 'No event found'
                else:
                    logging.info('Events found')  
                    logging.info(body['numberOfElements'])					
                    payload['status_code'] = response.status_code
                    payload['events'] = body
            else:
                payload['status_code'] = response.status_code
                payload['error_message'] = 'Event not found'

        except:
            logging.error('Cannot call events API') 
            payload['status_code'] = 500
            payload['error_message'] = 'Cannot call events API' 

        return json.dumps(payload)

    def m_api_patch_events(self, p_json):

        l_json = json.loads(p_json)
        logging.info('m_api_patch_events JSON received')

        xAuthToken = l_json['token']
        process = l_json['process']
        imxUnIdList = l_json['imxUnIdList']
        url = os.getenv('SCORE_API_URL_EVENT_ACTION')
        logging.info('url for events: ' + str(url))

        payload = {
            'process': process,
            'imxUnIdList': imxUnIdList
        }

        the_response = {}
        try:
            headers = {'Content-Type': 'application/json', 'X-AUTH-TOKEN': xAuthToken}
            response = requests.post(url, headers=headers, data=json.dumps(payload))
            
            logging.info('Response: ' + str(response))
            logging.info('Status_code: ' + str(response.status_code ))

            if response.status_code == 200:
                the_response['status_code'] = response.status_code
            else:
                the_response['status_code'] = response.status_code
                the_response['error_message'] = str(response.content)
                logging.info('Error: ' + str(response.content))					

        except:
            logging.error('Cannot call events API') 
            the_response['status_code'] = 500
            the_response['error_message'] = str(response.content) 
			
        return json.dumps(the_response)		
