# Description: main script handling the flows to handle from TBRC tables to SCORE
#              handling flows 
#                0: case creation - to be written
#                1: case modification - to be written
#                2: partner modification - to be written
#                3: posting modification - to be written
#                4: recoverie out of CLEAR - to be written
#                5: observation out of CLEAR - to be tested
# Author: BEVRIG1
# Date: 21/06/2023
# Last modifications:
#  version 1.0: BEVRIG1 - 21/06/2023 - initial version
#

from datetime import datetime

import cx_Oracle
import os
import configparser
import platform
import sys
import json
import logging

logging.basicConfig(format='%(asctime)s - %(levelname)s: %(message)s', 
                    level=getattr(logging, os.getenv('LOGGING_LEVEL').upper()))

# setting path()
sys.path.append(os.path.join(os.getcwd(), "python"))
sys.path.append(os.path.join(os.getcwd(), "shared"))

# importing
from clear_score_itf.clear_score_observations import Observations_in
from clear_score_itf.clear_score_case_update import Case_update
from clear_score_itf.clear_score_payment import Payment_in
from tools.cit_functions import CIT_functions
from tools.cit_connect import CIT_connect
from score_itf_module.m_login import module_login
from score_itf_module.m_case import module_case
from mails.mail_handling import Mail_Handling

observations_in = Observations_in()
case_update = Case_update()
payment_in = Payment_in()
cit_connect = CIT_connect()
cit_functions = CIT_functions()

def check_on_hold(l_conn, p_claim_id):
   l_sql = """
              select 1 from tbrc_headers
                where claim_id = :1
                and flow_type_num = 0
                and status_ind = 'H'
           """
   row = cit_functions.sql_select(l_conn, 'one', l_sql, [p_claim_id])
   if row is None:
        return 'N'
   else:
        return 'Y'

def main():
    
    #logging.debug('main_clear_score: Test debug')
    #logging.info('main_clear_score: Test Info')
    #logging.warning('main_clear_score: Test Warning')
    #logging.critical('main_clear_score: Test Critical')
    #logging.error('main_clear_score: Test Error')

    l_conn = cit_connect.get_connection('dbCIT')

    logging.info('main_clear_score: Checking if we have movemements to handle')

    c_main = cit_functions.sql_select(l_conn, 'all', """select h.tbrc_id as "tbrcId", h.claim_id as "claimId", h.flow_type_num as "flowTypeNum"
                                                          from tbrc_headers h 
                                                         where h.status_ind = 'T'
                                                           and h.flow_type_num in (0, 1, 2, 3, 4, 5)
                                                         order by h.tbrc_id
                                                     """, assoc=1)
    
    m_login = module_login()
    l_count = 0

    if c_main is not None:
      # to loop in tbrc_headers all flows to be send to SCORE
      # and call the appropriate functions

      for row in c_main:
        
        l_count = l_count + 1

        l_claim_id = row['claimId']
        l_tbrc_id = row['tbrcId']
        l_flow_type_num = row['flowTypeNum']
        l_error_message = None
        l_status = 'T'
        l_error_code = None
        l_token = None

        if l_claim_id != 0:
          # check if case On Hold
          if check_on_hold(l_conn, l_claim_id) == 'Y':
            l_status = 'H'

        if l_status == 'T': 
          # get a token 
          data = {}
          data['api_login']= 'SCORE_INTERFACE_CLEAR'
          logging.debug('main_clear_score: call login with ' + str(data))
          data_login = m_login.m_api_login(json.dumps(data))
          the_json_login = json.loads(data_login)
          logging.debug('main_clear_score: login returns: ' + str(the_json_login))
          if the_json_login['status_code'] == 200:
            l_token =  the_json_login['token']
            logging.debug('main_clear_score: main_clear_score token received: ' + str(l_token))
          else:
            l_status = 'E'
            l_error_code = the_json_login['status_code']
            l_error_message = the_json_login['error_message']

        if l_status == 'T' and l_claim_id != 0: 
          # search the SCORE_ID
          m_search = module_case()
          data_search = {}
          data_search['token'] = l_token
          data_search['extCaseRef'] = l_claim_id
          l_search_result = m_search.m_api_search_case(json.dumps(data_search))
          the_json_search = json.loads(l_search_result)
          logging.debug('main_clear_score: Search returned: ' + str(the_json_search['status_code']))
          if the_json_search['status_code'] == 200 or the_json_search['status_code'] == 201:
            l_numberOfElements = the_json_search['case']['numberOfElements']
            if l_numberOfElements == 0:
              l_status = 'E'
              l_error_code =  901
              l_error_message = 'No case found for caseRef ' + str(l_claim_id)
            elif l_numberOfElements > 1:
              l_status = 'E'
              l_error_code =  902
              l_error_message = 'More than one case found for caseRef ' + str(l_claim_id)
            else:
              l_case = the_json_search['case']['content'][0]['caseRef']
              logging.debug("main_clear_score: Case: " + l_case)
              #logging.debug("main_clear_score:  Number of elements: " + str(l_numberOfElements))
          else:
            l_status = 'E'
            l_error_code = the_json_search['status_code']
            l_error_message = the_json_search['error_message']    

        if l_status == 'T': 
          tbrc_header = {}
          tbrc_header['tbrc_id'] = l_tbrc_id
          tbrc_header['claim_id'] = l_claim_id
          tbrc_header['score_id'] = l_case
          tbrc_header['flowTypeNum'] = l_flow_type_num
          
          if l_flow_type_num in (0, 2, 3):
            logging.error('main_clear_score: Flow type ' + str(l_flow_type_num) + ' not yet developped')
            l_status = 'E'
            l_error_code = '404'
            l_error_message = 'Flow not yet developped' 
          
          if l_status == 'T': 
            data_func = {}
            data_func['token'] = l_token 
            data_func['tbrc_header'] = tbrc_header

            # handling of a movement, check the type
            if l_flow_type_num == 1:
              logging.debug('main_clear_score: CALL case_update.case_update for claims ' + str(l_claim_id))
              l_return = case_update.case_update(l_conn, json.dumps(data_func))
              logging.debug('main_clear_score: Returns of case_update: ' + str(l_return))
              the_return = json.loads(l_return)
              logging.debug('main_clear_score: Status Code: ' + str(the_return['status_code']))
              if str(the_return['status_code']) == '200' or str(the_return['status_code']) == '201':
                l_status = 'S'
                l_error_code = None
                l_error_message = None
              else:
                l_status = 'E'
                l_error_code = the_return['status_code']
                l_error_message = the_return['error_message']
            elif l_flow_type_num == 4:
              logging.debug('main_clear_score: CALL payment_in.payment_in for claims ' + str(l_claim_id))
              l_return = payment_in.payment_in(l_conn, json.dumps(data_func))
              logging.debug('main_clear_score: Returns of payment_in: ' + str(l_return))
              the_return = json.loads(l_return)
              logging.debug('main_clear_score: Status Code: ' + str(the_return['status_code']))
              if str(the_return['status_code']) == '200' or str(the_return['status_code']) == '201' or str(the_return['status_code']) == '204':
                l_status = 'S'
                l_error_code = None
                l_error_message = None
              else:
                l_status = 'E'
                l_error_code = the_return['status_code']
                l_error_message = the_return['error_message']
            elif l_flow_type_num == 5:
              logging.debug('main_clear_score: CALL observations_in.observation_in for claims ' + str(l_claim_id))
              l_return = observations_in.observation_in(l_conn, json.dumps(data_func))
              logging.debug('main_clear_score: Returns of observations_in: ' + str(l_return))
              the_return = json.loads(l_return)
              logging.debug('main_clear_score: Status Code: ' + str(the_return['status_code']))
              if str(the_return['status_code']) == '200' or str(the_return['status_code']) == '201':
                l_status = 'S'
                l_error_code = None
                l_error_message = None
              else:
                l_status = 'E'
                l_error_code = the_return['status_code']
                l_error_message = the_return['error_message']

        # development phase
        #if l_error_code == 999:
        #      l_status = 'T'
        logging.debug('main_clear_score: Update tbrc_headers tbrc_id ' + str(l_tbrc_id) + ' whith status ' + str(l_status) + ' error_message: ' + str(l_error_message))
        l_sqlupdate = "update tbrc_headers set status_ind = :1 " \
                      ",error_message_text  = :2, error_code = :3 where tbrc_id = :4" 
        cur_update = l_conn.cursor()
        cur_update.execute(l_sqlupdate, [l_status, l_error_message, l_error_code, l_tbrc_id])
        cur_update.close()
        l_conn.commit()
        
        if l_error_code == 500:
          logging.error('Code 500 received -> Exit') 
          m_mail = Mail_Handling()
          m_mail.send_email_sg('vincent.rigaux@atradius.com', 'vincent.rigaux@atradius.com'
                              ,'CLEAR_SCORE ERROR', 'The interfaces receives an error 500')
          l_conn.close()
          exit()

      logging.info('main_clear_score: End of cursor Checking if we have movements to handle')
     
    #end if if c_main is not none
    logging.info('Number of items handled: ' + str(l_count))
    l_conn.close()

# ----------------------------------------------------------------------------------------------------------------
if __name__ == "__main__":
    main()
