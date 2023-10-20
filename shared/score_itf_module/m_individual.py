

# Description of the mobile: 
#  Function m_api_get_individual
#    Entry: l_json: {'token': '', 'refIndividual': ''}
#    Returns:  payload if OK
#              status_code 500 + error_message if not OK
# Function m_api_post_external_ref    
#    Entry: l_json: {'token': '', 'refIndividual': '', 'refType': '', 'externalRef': ''}
# Function m_api_communication_channel    
#    Entry: l_json: {'token': '', 'refIndividual': '', 'country': '', 'nbOrEmail': '', 'type': '', 'val': '', 'countryPrefix': '', 'mobilePrefix': ''}
# Author: BEODEL1
# Date: 21/06/2023
# Last modifications:
#  version 1.0: BEODEL1 + BEYCNE1 - 21/06/2023 - initial version
#  version 1.1: BEODEL1 - 21/08/2023 - searchIndiv + split get into separated functions
#

import datetime

import os
import requests
import json
import logging
import sys
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(message)s')


class  module_individual:

    def m_api_search_Indiv(self, p_json):
        
        l_json = json.loads(p_json)
        logging.info('m_api_searchIndiv JSON received: ' + str(l_json))

        xAuthToken = l_json['token']
        url = os.getenv('SCORE_API_URL_INDIV_SEARCH')
        logging.info('url for search: ' + str(url))
 
        criteria = {}
        criteria['indivExRef'] = l_json['indivExRef']
        criteria['indivExRefType'] = l_json['indivExRefType']
        ok_to_continue = True

        try:
            headers = {'Content-Type': 'application/json', 'X-AUTH-TOKEN': xAuthToken}
            response = requests.put(url, headers=headers, data=criteria)
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
                    logging.info('No individuals found')                    
                    payload['status_code'] =  901
                    payload['error_message'] = 'No individual found'
                else:
                    logging.info('individuals found')  
                    logging.info(body['numberOfElements'])					                    
                    payload['status_code'] = response.status_code
                    payload['individuals'] = body
            else:
                payload['status_code'] = response.status_code
                payload['error_message'] = 'Individual not found'

        except:
            logging.error('Cannot call individuals API') 
            payload['status_code'] = 500
            payload['error_message'] = 'Cannot call individual API' 

        return json.dumps(payload)


    def m_api_get_indivMain(self, p_json):
        
        l_json = json.loads(p_json)
        logging.info('m_api_get_indivMain JSON received: ' + str(l_json))

        xAuthToken = l_json['token']
        refIndividual = l_json['refIndividual']
        ok_to_continue = True

        try:
            payload = {}
            url = os.getenv('SCORE_API_URL_LEGAL_CIVIL') % refIndividual
            logging.info('Url Legal_civil: ' + url)
            headers = {'Content-Type': 'application/json', 'X-AUTH-TOKEN': xAuthToken}

            response = requests.get(url, headers=headers, data=json.dumps({}))
            payload['status_code'] = response.status_code
			
            if response.status_code == 200 or response.status_code == 201:
                body = response.json()
                individual = {}
                legalIndividualStatusGet = body['legalIndividualStatusGet']
                individual['refIndividual'] = legalIndividualStatusGet['imxRefLegal']
                individual['nameLegal'] = legalIndividualStatusGet['nameLegal']
                individual['langLegal'] = legalIndividualStatusGet['langLegal']
                individual['indivTypeLegal'] = legalIndividualStatusGet['indivTypeLegal']
                legalIndividualRegistrationGet = body['legalIndividualRegistrationGet']
                individual['vatNbLegal'] = legalIndividualRegistrationGet['vatNbLegal']
                individual['rcsNb'] = legalIndividualRegistrationGet['rcsNbLegal']
                payload['individual'] = individual

                mainAddress = {}
                legalIndividualAddressGet = body['legalIndividualAddressGet']
                mainAddress['updDtAddr'] = legalIndividualAddressGet['dateUpdAddrLegal']
                mainAddress['updLoginUser'] = legalIndividualAddressGet['srcrUpdAddrLegal']
                mainAddress['addr1'] = legalIndividualAddressGet['addrLine1Legal']
                mainAddress['addr2'] = legalIndividualAddressGet['addrLine2Legal']
                mainAddress['addr3'] = legalIndividualAddressGet['addrLine3Legal']
                mainAddress['addr4'] = legalIndividualAddressGet['addrLine4Legal']
                mainAddress['stateAddr'] = legalIndividualAddressGet['stateLegal']
                mainAddress['postCode'] = legalIndividualAddressGet['postCodeLegal']
                mainAddress['city'] = legalIndividualAddressGet['cityLegal']
                mainAddress['country'] = legalIndividualAddressGet['countryAddrLegal']
                mainAddress['displayCountry'] = legalIndividualAddressGet['displayPaysLegal']
                payload['mainAddress'] = mainAddress
                payload['status_code'] = 200

            else:
                payload['status_code'] = response.status_code
                payload['error_message'] = 'Individual Legal Civil not found'
                # payload['faultCode'] = body['faultCode']
                # payload['faultMessage'] = body['faultMessage']
                # payload['incidentId'] = body['incidentId']

        except:
            logging.error('Cannot call legal-civil-full API') 
            payload['status_code'] = 500
            payload['error_message'] = 'Cannot call legal-civil-full API' 

        return json.dumps(payload)


    def m_api_get_indivAddr(self, p_json):
        
        l_json = json.loads(p_json)
        logging.info('m_api_get_indivAddr JSON received: ' + str(l_json))

        xAuthToken = l_json['token']
        refIndividual = l_json['refIndividual']
        if 'typeAddr' in l_json:
            typeAddr = l_json['typeAddr']
        else:
            typeAddr = None

        try:
            payload = {}
            url = os.getenv('SCORE_API_URL_INDIV_ADDR') % refIndividual
            logging.info('Url address: ' + url)
            headers = {'Content-Type': 'application/json', 'X-AUTH-TOKEN': xAuthToken}

            response = requests.get(url, headers=headers, data=json.dumps({}))
            payload['status_code'] = response.status_code    
            
            if response.status_code == 200 or response.status_code == 201:
                body = response.json()
                addressDict = {}
                mainAddressIndividual = body['mainAddressIndividual']
                addressDict['typeAddr'] = mainAddressIndividual['typeAddr']
                addressDict['updDate'] = mainAddressIndividual['updDtAddr']
                addressDict['updLoginUser'] = mainAddressIndividual['updLoginUser']
                addressDict['addrLine1'] = mainAddressIndividual['addr1']
                addressDict['addrLine2'] = mainAddressIndividual['addr2']
                addressDict['addrLine3'] = mainAddressIndividual['addr3']
                addressDict['addrLine4'] = mainAddressIndividual['addr4']
                addressDict['state'] = mainAddressIndividual['stateAddr']
                addressDict['displayState'] = mainAddressIndividual['displayStateAddr']
                addressDict['postCode'] = mainAddressIndividual['postCode']
                addressDict['city'] = mainAddressIndividual['city']
                addressDict['country'] = mainAddressIndividual['country']
                addressDict['displayCountry'] = mainAddressIndividual['displayCountry']
                payload['mainAddress'] = addressDict

                addresses = []
                if type == None or type == 'A':
                    addresses.append(addressDict)

                for otherAddressIndividual in body['otherAddressesIndividual']:
                    if type == None or type == otherAddressIndividual['typeAddr']:
                        addressDict = {}
                        addressDict['typeAddr'] = mainAddressIndividual['typeAddr']
                        addressDict['updDate'] = mainAddressIndividual['updDtAddr']
                        addressDict['updLoginUser'] = mainAddressIndividual['updLoginUser']
                        addressDict['addrLine1'] = mainAddressIndividual['addr1']
                        addressDict['addrLine2'] = mainAddressIndividual['addr2']
                        addressDict['addrLine3'] = mainAddressIndividual['addr3']
                        addressDict['addrLine4'] = mainAddressIndividual['addr4']
                        addressDict['state'] = mainAddressIndividual['stateAddr']
                        addressDict['displayState'] = mainAddressIndividual['displayStateAddr']
                        addressDict['postCode'] = mainAddressIndividual['postCode']
                        addressDict['city'] = mainAddressIndividual['city']
                        addressDict['country'] = mainAddressIndividual['country']
                        addressDict['displayCountry'] = mainAddressIndividual['displayCountry']
                        addresses.append(addressDict)
                payload['addresses'] = addresses
            else:
                payload['status_code'] = 200
                payload['error_message'] = 'Individual Addresses not found'
                ok_to_continue = False

        except:
            logging.error('Cannot call address API') 
            payload['status_code'] = 500
            payload['error_message'] = 'Cannot call address API' 

        return json.dumps(payload)


    def m_api_get_indivComm(self, p_json):
        
        l_json = json.loads(p_json)
        logging.info('m_api_get_indivComm JSON received: ' + str(l_json))

        xAuthToken = l_json['token']
        refIndividual = l_json['refIndividual']
        if 'type' in l_json:
            type = l_json['type']
        else:
            type = None
        if 'valid' in l_json:
            valid = l_json['valid']
        else:
            valid = None

        try:
            payload = {}
            url = os.getenv('SCORE_API_URL_COMM_CHANNELS') % refIndividual
            logging.info('Url commChannel: ' + url)
            headers = {'Content-Type': 'application/json', 'X-AUTH-TOKEN': xAuthToken}

            response = requests.get(url, headers=headers, data=json.dumps({}))
            payload['status_code'] = response.status_code
			
            if response.status_code == 200 or response.status_code == 201:
                body = response.json()
                communicationChannels = []
                for channel in body['content']:
                    if (type == None or type == channel['type']) and (valid == None or valid == channel['valid']):
                        communicationChannelDict = {}
                        communicationChannelDict['type'] = channel['type']
                        communicationChannelDict['typeValue'] = channel['typeValue']
                        communicationChannelDict['country'] = channel['country']
                        communicationChannelDict['nbOrEmail'] = channel['nbOrEmail']
                        communicationChannelDict['valid'] = channel['val']
                        communicationChannelDict['validStartDate'] = channel['validityStartDate']
                        communicationChannelDict['validEndDate'] = channel['validityEndDate']
                        communicationChannelDict['updDate'] = channel['updDate']
                        communicationChannelDict['updUserid'] = channel['updSource']
                        communicationChannels.append(communicationChannelDict)
                payload['communicationChannels'] = communicationChannels
            else:
                payload['status_code'] = 200
                payload['error_message'] = 'Individual Comm not found'

        except:
            logging.error('Cannot call CommChannel API') 
            payload['status_code'] = 500
            payload['error_message'] = 'Cannot call CommChannel API' 

        return json.dumps(payload)


    def m_api_get_indivContact(self, p_json):
        
        l_json = json.loads(p_json)
        logging.info('m_api_get_indivContact JSON received: ' + str(l_json))

        xAuthToken = l_json['token']
        refIndividual = l_json['refIndividual']
        if 'type' in l_json:
            type = l_json['type']
        else:
            type = None

        try:
            payload = {}
            url = os.getenv('SCORE_API_URL_CONTACTS') % refIndividual
            logging.info('Url contact: ' + url)
            headers = {'Content-Type': 'application/json', 'X-AUTH-TOKEN': xAuthToken}

            response = requests.get(url, headers=headers, data=json.dumps({}))
            payload['status_code'] = response.status_code    
            
            if response.status_code == 200:
                body = response.json()
                contacts = []
                idx = 0
                while idx < len(body):					   
                    contact = body[idx]
                    if type == None or type == contact['abbreviation']:
                        contactDict = {}
                        contactDict['contactRef'] = contact['contactRef']
                        contactDict['type'] = contact['abbreviation']
                        contactDict['firstName'] = contact['firstName']
                        contactDict['name'] = contact['name']
                        contactDict['phone'] = contact['phone']
                        contactDict['mobile'] = contact['mobile']
                        contactDict['email'] = contact['email']
                        contacts.append(contactDict)
                    idx += 1
                payload['status_code'] = 200
                payload['contacts'] = contacts
            else:
                payload['error_message'] = 'Individual Contacts not found'
                ok_to_continue = False

        except:
            logging.error('Cannot call contact API') 
            payload['status_code'] = 500
            payload['error_message'] = 'Cannot call contact API' 

        return json.dumps(payload)


    def m_api_get_indivExtRef(self, p_json):
       
        l_json = json.loads(p_json)
        logging.info('m_api_searchExtRef JSON received: ' + str(l_json))

        xAuthToken = l_json['token']
        refIndividual = l_json['refIndividual']
        if 'refType' in l_json:
            refType = l_json['refType']
        else:
            refType = None

        try:
            url = os.getenv('SCORE_API_URL_EXT_REF_SEARCH') % refIndividual
            logging.info('url for search: ' + str(url))
            headers = {'Content-Type': 'application/json', 'X-AUTH-TOKEN': xAuthToken}
            response = requests.put(url, headers=headers, data=json.dumps({}))
            #response = requests.put(url, headers=headers)

            logging.info('Response: ' + str(response))
            logging.info(('Status_code: ' + str(response.status_code )))
        
            if response.status_code == 200 or response.status_code == 201:
                payload = {}
                url = response.headers['LOCATION'] + '?page=1&size=2000'
                logging.info(' location: ' + str(url))
                response = requests.get(url, headers=headers)
                body = response.json()
                externalReferences = []
                for externalReference in body['content']:
                    if refType == None or refType == externalReference['refType']:
                        externalReferenceDict = {}
                        externalReferenceDict['refType'] = externalReference['refType']
                        externalReferenceDict['externalRef'] = externalReference['externalRef']
                        externalReferences.append(externalReferenceDict)
                payload['status_code'] = 200
                payload['externalReferences'] = externalReferences
            else:
                payload['status_code'] = response.status_code
                payload['error_message'] = 'Individual ExtRef not found'

        except:
            logging.error('Cannot call extRef API') 
            payload['status_code'] = 500
            payload['error_message'] = 'Cannot call extRef API' 

        return json.dumps(payload)


    def m_api_get_indivFull(self, p_json):
        m_indiv = module_individual()
        l_json = json.loads(p_json)
        logging.info('m_api_searchExtRef JSON received: ' + str(l_json))

        xAuthToken = l_json['token']
        refIndividual = l_json['refIndividual']
        ok_to_continue = True

        params = {}
        params['token'] = xAuthToken
        params['refIndividual'] = refIndividual
        l_return = m_indiv.m_api_get_indivMain(json.dumps(params))

        payload = {}
        l_return = json.loads(l_return)
        if l_return['status_code'] == 200 or l_return['status_code'] == 201:
            payload['individual'] = l_return['individual']
        else:
            ok_to_continue = False
        
        if ok_to_continue is True:
            l_return = m_indiv.m_api_get_indivAddr(json.dumps(params))
            l_return = json.loads(l_return)
            if l_return['status_code'] == 200 or l_return['status_code'] == 201:
                payload['mainAddress'] = l_return['mainAddress']
                payload['addresses'] = l_return['addresses']
            else:
                ok_to_continue = False
        
        if ok_to_continue is True:
            l_return = m_indiv.m_api_get_indivComm(json.dumps(params))
            l_return = json.loads(l_return)
            if l_return['status_code'] == 200 or l_return['status_code'] == 201:
                payload['communicationChannels'] = l_return['communicationChannels']
            else:
                ok_to_continue = False
        
        if ok_to_continue is True:
            l_return = m_indiv.m_api_get_indivContact(json.dumps(params))
            l_return = json.loads(l_return)
            if l_return['status_code'] == 200 or l_return['status_code'] == 201:
                payload['contacts'] = l_return['contacts']
            else:
                ok_to_continue = False
        
        if ok_to_continue is True:
            l_return = m_indiv.m_api_get_indivExtRef(json.dumps(params))
            l_return = json.loads(l_return)
            if l_return['status_code'] == 200 or l_return['status_code'] == 201:
                payload['externalReferences'] = l_return['externalReferences']
            else:
                ok_to_continue = False

        if ok_to_continue is True:
            payload['status_code'] = 200
        else:
            logging.error('Cannot call extRef API') 
            payload['status_code'] = 500
            payload['error_message'] = 'Cannot call extRef API' 

        return json.dumps(payload)


    def m_api_post_external_ref(self, p_json):

        l_json = json.loads(p_json)
        logging.info('m_api_post_external_ref JSON received: ' + str(l_json))

        xAuthToken = l_json['token']
        url = os.getenv('SCORE_API_URL_EXT_REF_ADD') % l_json['refindividu']
        logging.info('url for events: ' + str(url))

        payload = {
            'refType': l_json['reftype'],
            'externalRef': l_json['external_ref']
        }
        logging.info(str(payload))
        try:
            headers = {'Content-Type': 'application/json', 'X-AUTH-TOKEN': xAuthToken}
            response = requests.post(url, headers=headers, data=json.dumps(payload))
            
            if response.status_code == 200 or response.status_code == 201:
                return response.status_code
            else:
                logging.error(('Status_code: ' + str(response.status_code)))
                logging.error(('Content: ' + str(response.content)))						
                sys.exit(1)
        except:
            logging.error('Cannot call post external ref API')
            sys.exit(1)			

    def m_api_post_individu_info(self, p_json):

        l_json = json.loads(p_json)
        logging.info('m_api_post_individu_info JSON received: ' + str(l_json))

        xAuthToken = l_json['token']
        url = os.getenv('SCORE_API_URL_INDIV_INFO_POST') % l_json['refindividu']
        logging.info('url for events: ' + str(url))

        payload = {
            'date': l_json['date'],
            'message': l_json['message'],
            'creatorName': l_json['creator_name'],
            'createOnDate' : l_json['date'],
            'information' : l_json['information']
        }
        logging.info(str(payload))
        try:
            headers = {'Content-Type': 'application/json', 'X-AUTH-TOKEN': xAuthToken}
            response = requests.post(url, headers=headers, data=json.dumps(payload))
            
            if response.status_code == 200 or response.status_code == 201:
                return response.status_code
            else:
                logging.error(('Status_code: ' + str(response.status_code)))
                logging.error(('Content: ' + str(response.content)))						
                sys.exit(1)
        except:
            logging.error('Cannot call post individu_info API')
            sys.exit(1)			


    def m_api_post_communication_channel(self, p_json):
        l_json = json.loads(p_json)
        logging.info('m_api_post_communication_channel: ' + str(l_json))

        xAuthToken = l_json['token']
        refIndividual = l_json['refIndividual']
    
        url = os.getenv('SCORE_API_URL_COMM_CHANNELS') % refIndividual
        logging.info('url for events: ' + str(url))

        payload = {
            'country': l_json['country'],
            'nbOrEmail': l_json['nbOrEmail'],
            'type': l_json['type'],
            'val': l_json['val'],
            'countryPrefix': l_json['countryPrefix'],
            'mobilePrefix': l_json['mobilePrefix']
        }

        try:
            headers = {'Content-Type': 'application/json', 'X-AUTH-TOKEN': xAuthToken}
            response = requests.post(url, headers=headers, data=json.dumps(payload))
            
            if response.status_code == 200 or response.status_code == 201:
                return response.status_code
            else:
                logging.error(('Status_code: ' + str(response.status_code)))
                logging.error(('Content: ' + str(response.content)))						
                sys.exit(1)
        except:
            logging.error('Cannot call post communication channel API')
            sys.exit(1)				

    def m_api_patch_indivMain(self, p_json):
        
        l_json = json.loads(p_json)
        logging.info('m_api_patch_indivMain JSON received: ' + str(l_json))

        xAuthToken = l_json['token']
        refIndividual = l_json['refIndividual']

        try:
            payload = {}
            url = os.getenv('SCORE_API_URL_LEGAL_CIVIL') % refIndividual
            logging.info('Url Legal_civil: ' + url)
            headers = {'Content-Type': 'application/json', 'X-AUTH-TOKEN': xAuthToken}

            response = requests.get(url, headers=headers, data=json.dumps({}))
            payload['status_code'] = response.status_code
			
            if response.status_code == 200 or response.status_code == 201:
               body = response.json()
 
               # first we copy all values found in the Get into the corresponding json elements used within the Put 
               payload = {}
               payload['legalIndividualStatusModify'] = body['legalIndividualStatusGet']
               payload['legalIndividualInfoModify'] = body['legalIndividualInfoGet']
               payload['legalIndividualBusinessModify'] = body['legalIndividualBusinessGet']	
               payload['legalIndividualAddressModify'] = body['legalIndividualAddressGet']		
               payload['legalIndividualRegistrationModify'] = body['legalIndividualRegistrationGet']		

               # in the for-block below, for all keys find in the params-json, the corresponding key in the Score json will be updated
               for key,val in l_json.items():
                   if key == "legalForm":	
                      payload['legalIndividualStatusModify']['legalForm'] = l_json['legalForm']

                   if key == "nace":
                      payload['legalIndividualBusinessModify']['nace'] = l_json['nace']				   

               url = os.getenv('SCORE_API_URL_LEGAL') % refIndividual
               logging.info('Url Legal: ' + url)
               headers = {'Content-Type': 'application/json', 'X-AUTH-TOKEN': xAuthToken}
               response = requests.post(url, headers=headers, data=json.dumps(payload))
            
               if response.status_code == 204:
                  return response.status_code			   
               else:
                  logging.error(('Status_code: ' + str(response.status_code)))
                  logging.error(('Content: ' + str(response.content)))						
                  sys.exit(1)  
				  
        except:
            logging.error('Error in m_api_patch_indivMain') 
            payload['status_code'] = 500
            payload['error_message'] = 'Error in m_api_patch_indivMain' 				