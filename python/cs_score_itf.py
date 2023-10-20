###############################################################################################
# Script Name : cs_score_itf.py
#
# This script handles all Score events for which a debtor rating needs to be find at CreditSafe
# author :BEYCNE1
# date :07/07/2023
###############################################################################################

import platform
import cx_Oracle
import os
import configparser
import requests
import json
import sys
from datetime import datetime, timedelta
import logging
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(message)s')

# setting path
sys.path.append(os.path.join(os.getcwd(), "shared"))
sys.path.append(os.path.join(os.getcwd(), "python"))

# importing
from tools.cit_connect import CIT_connect
from tools.cit_functions import CIT_functions 
from cit_itf_modules.m_cit_event import module_cit_event 
from score_itf_module.m_ext_rating import module_ext_rating
from score_itf_module.m_individual import module_individual 
from score_itf_module.m_login import module_login

cit_connect = CIT_connect()
conn = cit_connect.get_connection('dbCIT')

cs_root_url = os.getenv('CREDITSAFE_URL')
cs_user = os.getenv('CREDITSAFE_USER')
cs_pw = os.getenv('CREDITSAFE_PW')	
	

def authenticate_cs(root_url, username, password):
    url = root_url + '/v1/authenticate'
    payload = json.dumps({"username": username, "password": password})
    headers = {'Content-Type': 'application/json'}
    response = requests.post(url, headers=headers, data=payload)
    data = response.json()

    if response.status_code == 200:
        return data["token"]
    else:
        print(response.status_code)
        print(response.text.encode('utf8'))
        sys.exit(1)


def main():
    # Script contain two main parts :
    #   1) after some initializations and API authentications (as well on CreditSafe side as on Score side), we first fetch all Score events and
    #      store them in a CIT middleware table, specifically used for this CreditSafe interface
    #   2) in this second part, we will treat all 'non-finalized' records in this middleware table and execute all required actions, from searching  
    #      the corresponding match at CreditSafe to the resulting updates within Score


    # module initializations
    score_login = module_login()
    m_individual = module_individual()
    m_ext_rating = module_ext_rating()
    m_cit_event = module_cit_event()
    cit_fct = CIT_functions()	

    # Get token for Score API's 	
    params = {}
    params['api_login'] = 'SCORE_EVENTS'
    l_return = score_login.m_api_login(json.dumps(params))
    l_return = json.loads(l_return)
        
    if l_return['status_code'] == 200:
       xAuthToken =  l_return['token']
    else:
       sys.exit(1)

    # Authenticate on CS API's
    token_cs = authenticate_cs(cs_root_url, cs_user, cs_pw)
    headers = {'Authorization': token_cs}
	
    # FIRST part : check IMX_EVENTS_QUEUE on new events, and if found, store them in the Creditsafe middleware table and put event on status COMPLETED
    params = {}
    params['interface_code'] = 'CREDITSAFE'
    params['list_action'] = ['DB INIT CALL RATING AGENCY', 'DB UPD CALL RATING AGENCY']
    params['event_handling_status'] = 'NEW'
    #l_return = m_cit_event.m_cit_get_events(conn, json.dumps(params))
    #l_return = json.loads(l_return)

    #logging.info('looping now over all fetched events ...')
    #for event in l_return:
    #    # first create new entry in table CS_MIDDLEWARE
    #    if event['action'] == 'DB INIT CALL RATING AGENCY':		
    #       sql = """insert into CIT_CS_MIDDLEWARE (REFINDIVIDU, REFDOSS, IMX_ACTION, CS_STATUS, FLAG_DEBTORDATA_FOUND, FLAG_CS_COMPANY_SEARCH, FLAG_CS_REPORT_FOUND, FLAG_SCORE_UPDATED, CREATION_DATE) 
    #                values (:1, :2, 'DB_INIT_CALL_RATING_AGENCY', 'NEW', 'N', 'N', 'N', 'N', sysdate)
    #             """
    #    else:
    #       sql = """insert into CIT_CS_MIDDLEWARE (REFINDIVIDU, REFDOSS, IMX_ACTION, CS_STATUS, FLAG_DEBTORDATA_FOUND, FLAG_CS_COMPANY_SEARCH, FLAG_CS_REPORT_FOUND, FLAG_SCORE_UPDATED, CREATION_DATE) 
    #                values (:1, :2, 'DB_UPD_CALL_RATING_AGENCY', 'NEW', 'N', 'N', 'N', 'N', sysdate)
    #             """
    #
    #    params = [event['refindividu'], event['refdoss']]
	#		  
    #    cit_fct.sql_exec_ins_upd(conn,sql, params)
    #
    #    # then update table IMX_EVENTS_QUEUE by using shared function  
    #    params = {}
    #    params['un_id'] = event['un_id']
    #    params['event_handling_status'] = 'SUCCESS'
    #    m_cit_event.m_cit_patch_event(conn, json.dumps(params))

        #commit at the end, to make sure as well insert as update are handled as 1 transaction
    #    conn.commit()
    logging.info('All CS events inserted into CIT_CS_MIDDLEWARE')		

    # ------------------------------------------------------------------------------------------------

    # SECOND part : go through CS_MIDDLEWARE and handle all new events, applying following steps :
    # 	 Step 1) fetch all required debtor data out of Score
	#    Step 2) check if that company can be found in Creditsafe, applying the right search priorities
	#    Step 3) if found in Credisafe, fetch the appropriate CS report
	#    Step 4) perform the required Score updates

    logging.info('Looping now over all new all CS events in CIT_CS_MIDDLEWARE')		
    cs_mdw_rows = cit_fct.sql_select(conn, 'all', """select * from CIT_CS_MIDDLEWARE where CS_STATUS = 'NEW'""", assoc=1) 
    #cs_mdw_rows = {} 

    for row in cs_mdw_rows:
        logging.info('Some initialisations')		
        score_refindividu = row['REFINDIVIDU']
        flag_debtordata_found = row['FLAG_DEBTORDATA_FOUND']
        flag_cs_company_search = row['FLAG_CS_COMPANY_SEARCH']
        flag_cs_report_found = row['FLAG_CS_REPORT_FOUND']
        flag_score_updated = row['FLAG_SCORE_UPDATED']
        cs_company_id = row['CS_COMPANY_ID']
        cs_rating = row['CS_RATING']
        cs_activity = row['ACTIVITY']
        cs_legal_form = row['LEGAL_FORM'] 		
        cs_phone = row['PHONE']
        imx_action = row['IMX_ACTION']

        # Step 1 : fetch all required debtor data by using a shared function		
        if flag_debtordata_found == 'N':
           # fetch first main data via API m_api_get_indivMain		
           params = {}
           params['token'] = xAuthToken
           params['refIndividual'] = score_refindividu
           l_return = m_individual.m_api_get_indivMain(json.dumps(params))
           l_return = json.loads(l_return)
           logging.info(l_return)		   
           if l_return['status_code'] == 200:
              debtor_name = l_return['individual']['nameLegal']
              debtor_vat = l_return['individual']['vatNbLegal']
              debtor_regno = l_return['individual']['rcsNb']
              debtor_country = l_return['mainAddress']['country']

              #some manipulations required on VAT and RegNo for a series of countries (see analysis for overview)
              debtor_regno_frmt = debtor_regno
              debtor_vat_frmt = debtor_vat 			  

              if debtor_country == 'LUX':
                 debtor_regno_frmt = debtor_regno.replace(" ", "")			  
		  
              if debtor_country == 'DNK':
                 debtor_vat_frmt = ''
                 numeric_filter = filter(str.isdigit, debtor_vat)
                 debtor_regno_frmt = ''.join(numeric_filter)				 				 

              if debtor_country == 'FIN':
                 debtor_vat_frmt = ''
                 numeric_filter = filter(str.isdigit, debtor_vat)
                 debtor_regno_frmt = ''.join(numeric_filter)				 
  
              if debtor_country == 'SWE':
                 debtor_vat_frmt = ''
                 numeric_filter = filter(str.isdigit, debtor_vat)
                 debtor_regno_frmt = ''.join(numeric_filter)				 
                 if len(debtor_regno_frmt) > 10:
                    debtor_regno_frmt = debtor_regno_frmt[0:10]

              if debtor_country == 'NOR':
                 debtor_vat_frmt = ''
                 numeric_filter = filter(str.isdigit, debtor_vat)
                 debtor_regno_frmt = ''.join(numeric_filter)				
			  
              if debtor_country == 'ITA':
                 debtor_vat_frmt = debtor_vat.replace("IT", "")
                 debtor_regno_frmt = debtor_regno[0:len(debtor_regno) - 2] + debtor_regno[len(debtor_regno)-2:len(debtor_regno)]				 

              if debtor_country == 'ESP':			  
                 debtor_vat_frmt = debtor_vat.replace("ES", "")			  
			  
              if debtor_country == 'POL':			  
                 debtor_vat_frmt = debtor_vat.replace("PL", "")				  

			  #For testing purposes, TO BE REMOVED later :
              debtor_vat = 'BE0828450670'

              # fetch then all addresses via API m_api_get_indivAddr
              params = {}
              params['token'] = xAuthToken
              params['refIndividual'] = score_refindividu
              l_return = m_individual.m_api_get_indivAddr(json.dumps(params))
              l_return = json.loads(l_return)
              logging.info(l_return)		   
              if l_return['status_code'] == 200:
                 #Putting all addresses in a list, as well the main address as the others
                 json_address_list = []
				 #First the main address
                 address_item = {}
                 address_item['street'] = l_return['mainAddress']['addrLine1']
                 address_item['city'] = l_return['mainAddress']['city']
                 address_item['postalCode'] = l_return['mainAddress']['postCode']
                 address_item['state'] = l_return['mainAddress']['state']
                 address_item['country'] = l_return['mainAddress']['country']		  
                 json_address_list.append(address_item)				 
				 
                 #Then loop for all other addresses
                 for address in l_return['addresses']: 
                     address_item = {}
                     address_item['street'] = address['addrLine1']
                     address_item['city'] = address['city']
                     address_item['postalCode'] = address['postCode']
                     address_item['state'] = address['state']
                     address_item['country'] = address['country']		  
                     json_address_list.append(address_item)
                    
              string_address_list = json.dumps(json_address_list)
              logging.info(string_address_list)
              sql = """update CIT_CS_MIDDLEWARE
                          set FLAG_DEBTORDATA_FOUND = 'Y',
						      VAT_NO = :1,
							  VAT_NO_FRMT = :2,
						      REG_NO = :3,
							  REG_NO_FRMT = :4,
							  DB_NAME = :5,
							  LIST_ADDRESS = :6,
                              LAST_UPDATE = sysdate
                        where REFINDIVIDU = :7
                          and IMX_ACTION = :8
                    """    
              params = [debtor_vat, debtor_vat_frmt, debtor_regno, debtor_regno_frmt, debtor_name, string_address_list, score_refindividu, imx_action]
              cit_fct.sql_exec_ins_upd(conn, sql, params) 
              conn.commit()
              flag_debtordata_found = 'Y'			  
        else:	  
           debtor_name = row['DB_NAME']
           debtor_vat_frmt = row['VAT_NO_FRMT']
           debtor_regno_frmt = row['REG_NO_FRMT']
           json_address_list = json.loads(row['LIST_ADDRESS'])
           address_item = json_address_list[0]
           debtor_country = address_item['country']			   
			 
        # Step 2 : check if that company can be found in Creditsafe, applying the right search priorities       
        if flag_debtordata_found == 'Y' and flag_cs_company_search == 'N':

           # The fact we can have multiple addresses is making the search algorithm a bit complex ; to keep a certain level of simplicity,
		   # we let the search algorithm loop over all addresses, knowing that some of the searches do not contain address items. 
		   # CS searches do not have a cost, so no prob if we have some duplicate searches ...
           for address in json_address_list: 

               debtor_street = address['street']
               debtor_postalcode = address['postalCode']
               debtor_city = address['city']
               debtor_state = address['state']
               debtor_country = address['country']		   

               dict_cell = {
                        'name': debtor_name,
                        'street': debtor_street,
                        'postCode': debtor_postalcode,
                        'city': debtor_city,
                        'province': debtor_state,
                        'vatNo': debtor_vat_frmt,
                        'regNo': debtor_regno_frmt
                       }
		 
               criteria_rows = cit_fct.sql_select(conn, 'all', """select PRIORITY, VALUE from LOV_CS_SEARCH_PRIORITY 
			                                                       where COUNTRY=:1
			                                                       order by PRIORITY""", [debtor_country], assoc=1)					  

               n = 0          # counter for going through criteria_rows     
               totalSize = 0  # totalSize is returned by the CS API, 1 means CS search found one unique value

               while totalSize != 1 and n <= len(criteria_rows) - 1:
                     totalSize = 0
                     criteria_row = criteria_rows[n]
                     cri = criteria_row['VALUE']
                     args = cri.split(';') 
                     country_iso2 = cit_fct.countryISO3_to_ISO2(conn, debtor_country)
                     url = cs_root_url + '/v1/companies?countries=' + country_iso2
                     request_get = True
                     for arg in args:
                         if '=' in arg:  # si je trouve un = dans mon argument
                            url = url + '&' + arg
                         else:
                            if dict_cell[arg] is None or dict_cell[arg] == "":
                               request_get = False
                            else:
                               url = url + '&' + arg + '=' + dict_cell[arg]

                     if request_get:

                        try:
                            response = requests.request('GET', url, headers=headers)
				 
                            if response.status_code == 200:
                               body = response.json()
                               totalSize = body['totalSize']

                               if totalSize == 1:
                                  cs_companies = body['companies'][0]
                                  cs_company_name = cs_companies['name']
                                  cs_company_id = cs_companies['id']
						   
                                  flag_cs_company_search = 'Y'

                                  sql = """update CIT_CS_MIDDLEWARE
                                              set FLAG_CS_COMPANY_SEARCH = 'Y',
                                                  CS_COMPANY_ID = :1,
                                                  LAST_UPDATE = sysdate
                                           where REFINDIVIDU = :2
                                             and IMX_ACTION = :3
                                        """    
                                  params = [cs_company_id, score_refindividu, imx_action]
                                  cit_fct.sql_exec_ins_upd(conn, sql, params) 
                                  conn.commit()

                        except Exception as e:
                            logging.error('Cannot call CreditSafe API')						 
                            name = 'Problem with url'
                            sys.exit(1)

                     n = n + 1

                     if n >= len(criteria_rows):
                        cri = 'None'

                     # Store all failed results in table CIT_CS_RESULT
                     if flag_cs_company_search == 'N':
                        if totalSize == 0:
                           param_result = 'NO'
                        else:
                           param_result = 'MULTIPLE'						
						
                        sql = """insert into CIT_CS_RESULT (REFINDIVIDU, PRIORITY, CRITERIA, RESULT, CREATION_DATE)               
                                 values (:1, :2, :3, :4, sysdate)"""               
                                                  
                        params = [score_refindividu, criteria_row['PRIORITY'], criteria_row['VALUE'], param_result]
                        cit_fct.sql_exec_ins_upd(conn, sql, params) 
                        conn.commit()					 

        #flag_cs_company_search = 'N'
        if flag_debtordata_found == 'Y' and flag_cs_company_search == 'N':
               # If a match, store also that match in table CIT_CS_RESULT ; if no match in the end (nothing found or only multiple), 
               # create for every record a corresponding entry in IMX via API INDIV_INFO and mark the record in CIT_CS_MIDDLEWARE as 'FAILED'					 
               if flag_cs_company_search == 'Y':
                  sql = """insert into CIT_CS_RESULT (REFINDIVIDU, PRIORITY, CRITERIA, RESULT, CS_COMPANY_ID, CREATION_DATE)               
                           values (:1, :2, :3, 'SUCCESS', :4, sysdate)"""               
                                                  
                  params = [score_refindividu, criteria_row['PRIORITY'], criteria_row['VALUE'], cs_company_id]
                  cit_fct.sql_exec_ins_upd(conn, sql, params) 
                  conn.commit()		
               else:					 
                  result_rows = cit_fct.sql_select(conn, 'all', """select PRIORITY, CRITERIA, RESULT from CIT_CS_RESULT 
			                                                         where REFINDIVIDU =:1
			                                                         order by PRIORITY""", [score_refindividu], assoc=1)					  

                  for result_row in result_rows:               
                      params = {}
                      params['token'] = xAuthToken
                      params['refindividu'] = score_refindividu
                      params['date'] = datetime.today().strftime('%Y-%m-%d')
                      params['message'] = 'CREDITSAFE SEARCH FAILED'					  
                      params['creator_name'] = 'cs_score_itf'

                      if result_row['RESULT'] == 'NO':
                         params['information'] = 'No result in creditsafe search; priority: ' + result_row['PRIORITY'] + '; search by: ' + result_row['CRITERIA'] 
                      else:
                         params['information'] = 'Multiple results in creditsafe search; priority: ' + result_row['PRIORITY'] + '; search by: ' + result_row['CRITERIA'] 
                     
                      l_return = m_individual.m_api_post_individu_info(json.dumps(params))

                  sql = """update CIT_CS_MIDDLEWARE
                              set CS_STATUS = 'FAILED',
                            where REFINDIVIDU = :1
                              and IMX_ACTION = :2
                        """    
                  params = [score_refindividu, imx_action]
                  cit_fct.sql_exec_ins_upd(conn, sql, params) 
                  conn.commit()

        # Step 3 : if found in Creditsafe, fetch the appropriate CS report
        if flag_cs_company_search == 'Y' and flag_cs_report_found == 'N':
           if debtor_country != 'DEU':
              url = cs_root_url + '/v1/companies/' + cs_company_id + '?language=en'
           else:	  
              url = cs_root_url + '/v1/companies/' + cs_company_id + '?language=en&customData=de_reason_code::4'

           response = requests.get(url, headers=headers)

           if response.status_code == 200:
              body = response.json()
              cs_rating = body['report']['companySummary']['creditRating']['commonValue']
              cs_activity = body['report']['companySummary']['mainActivity']['code']
              cs_legal_form = body['report']['companyIdentification']['basicInformation']['legalForm']['providerCode']
              cs_phone = body['report']['contactInformation']['mainAddress']['telephone']

              sql = """update CIT_CS_MIDDLEWARE
                          set FLAG_CS_REPORT_FOUND = 'Y',
                              CS_RATING = :1,
							  ACTIVITY = :2,
							  LEGAL_FORM = :3,
							  PHONE = :4,
                              LAST_UPDATE = sysdate
                        where REFINDIVIDU = :5
                          and IMX_ACTION = :6						
                    """    
              params = [cs_rating, cs_activity, cs_legal_form, cs_phone, score_refindividu, imx_action]
              cit_fct.sql_exec_ins_upd(conn, sql, params) 
              conn.commit()

              flag_cs_report_found = 'Y'

        # Step 4 : perform the required Score updates :
        #          a) insert into Score the external reference
        #          b) insert into Score the rating
        #          c) insert into Score the phone nbr
		#          d) update in Score the activity code and also update the legal form (when country = NLD)
		#
		#          when all above steps are executed, record in CIS_CS_MIDDLEWARE can be set as fully completed

        if flag_cs_report_found == 'Y': 
 
           # step 4.a : insert into Score the external reference
           if flag_score_updated  == 'N':
              params = {}
              params['token'] = xAuthToken
              params['refindividu'] = score_refindividu
              params['reftype'] = 'CREDITSAFE'
              params['external_ref'] = cs_company_id

              #l_return = m_individual.m_api_post_external_ref(json.dumps(params))
              l_return = 200 
              if l_return == 200 or l_return == 201:           
                 sql = """update CIT_CS_MIDDLEWARE
                             set FLAG_SCORE_UPDATED = 'E_REF',
                                 LAST_UPDATE = sysdate
                           where REFINDIVIDU = :1
                             and IMX_ACTION = :2						   
                       """    
                 params = [score_refindividu, imx_action]
                 cit_fct.sql_exec_ins_upd(conn, sql, params) 
                 conn.commit()

                 flag_score_updated = 'E_REF'

           # step 4.b : insert into Score the rating
           if flag_score_updated  == 'E_REF':
#              params = {}
#              params['token'] = xAuthToken
#              params['refindividu'] = score_refindividu
#              params['rating'] = cs_rating
#              params['rating_issuer'] = 'CS'		   
#              params['rating_date'] = datetime.today().strftime('%Y-%m-%d')
#
#              l_return = m_ext_rating.m_api_post_ext_rating(json.dumps(params))
#			  
#              if l_return == 200 or l_return == 201:           
#                 sql = """update CIT_CS_MIDDLEWARE
#                             set FLAG_SCORE_UPDATED = 'E_RAT',
#                                 LAST_UPDATE = sysdate
#                           where REFINDIVIDU = :1
#                             and IMX_ACTION = :2
#                       """    
#                 params = [score_refindividu, imx_action]
#                 cit_fct.sql_exec_ins_upd(conn, sql, params) 
#                 conn.commit()	


               row = cit_fct.sql_select(conn, 'one',"""select imx_un_id, rating, dt_rating from ext_scoring_note where refindividu=:1 and dt_validity is null""", [score_refindividu])
               if row is None:
                   params = {}
                   params['token'] = xAuthToken
                   params['refindividu'] = score_refindividu
                   params['rating'] = cs_rating
                   params['rating_issuer'] = 'CS'		   
                   params['rating_date'] = datetime.today().strftime('%Y-%m-%d')
                   l_return = m_ext_rating.m_api_post_ext_rating(json.dumps(params))
               else: 
                   old_rating = row[1]
                   if cs_rating != old_rating:
                       params = {}
                       params['token'] = xAuthToken
                       params['refindividu'] = score_refindividu
                       params['ext_rating_id'] = row[0]
                       params['rating'] = old_rating
                       params['rating_issuer'] = 'CS'		   
                       params['rating_date'] = row[2].strftime('%Y-%m-%d')
                       params['val_date'] = (datetime.today() - timedelta(days=1)).strftime('%Y-%m-%d')
                       l_return = m_ext_rating.m_api_put_ext_rating(json.dumps(params))
   
                       params = {}
                       params['token'] = xAuthToken
                       params['refindividu'] = score_refindividu
                       params['rating'] = cs_rating
                       params['rating_issuer'] = 'CS'		   
                       params['rating_date'] = datetime.today().strftime('%Y-%m-%d')
                       l_return = m_ext_rating.m_api_post_ext_rating(json.dumps(params))

               flag_score_updated = 'E_RAT'				 

           # step 4.c : insert into Score the phone number  NOG ALGORITME OP LOS LATEN !!!!         
           if flag_score_updated  == 'E_RAT':
              params = {}
              params['token'] = xAuthToken
              params['refIndividual'] = score_refindividu  
              params['country'] = debtor_country  
              params['countryPrefix'] = 32
              params['mobilePrefix'] = ""		   
              params['nbOrEmail'] = cs_phone  
              params['type'] = 'BUR'
              params['val'] = True

              l_return = m_individual.m_api_post_communication_channel(json.dumps(params))

              if l_return == 200 or l_return == 201:           
                 sql = """update CIT_CS_MIDDLEWARE
                             set FLAG_SCORE_UPDATED = 'PHONE',
                                 LAST_UPDATE = sysdate
                           where REFINDIVIDU = :1
                             and IMX_ACTION = :2						   
                       """    
                 params = [score_refindividu, imx_action]
                 cit_fct.sql_exec_ins_upd(conn, sql, params) 
                 conn.commit()	

                 flag_score_updated = 'PHONE'				 

           # step 4.d : update in Score the activity code and the legal form (for NLD)
           #            legal form : cs_legal_form first needs to be mapped into the corresponding Score value	
		   #            activity code : international standard, can be taken right away from cs_activity		   
           if flag_score_updated  == 'PHONE':
              legal_form_row = cit_fct.sql_select(conn, 'one', """select IMX_LEGAL_FORM
                                                                    from LOV_CS_LEGAL_FORM
                                                                   where CS_PROVIDER_CODE =:1""", [cs_legal_form], assoc=1)					  

              params = {}
              params['token'] = xAuthToken
              params['refIndividual'] = score_refindividu  
              params['nace'] = cs_activity
              params['legalForm'] = legal_form_row['IMX_LEGAL_FORM']

              l_return = m_individual.m_api_patch_indivMain(json.dumps(params))

              if l_return == 204: 
                 sql = """update CIT_CS_MIDDLEWARE
                             set FLAG_SCORE_UPDATED = 'Y',
                                 CS_STATUS = 'COMPLETED' 							 
                           where REFINDIVIDU = :1
                             and IMX_ACTION = :2 
                       """    
                 params = [score_refindividu, imx_action]
                 cit_fct.sql_exec_ins_upd(conn, sql, params) 
                 conn.commit() 

# ----------------------------------------------------------------------------------------------------------------------

if __name__ == "__main__":
    main()
    conn.close()
