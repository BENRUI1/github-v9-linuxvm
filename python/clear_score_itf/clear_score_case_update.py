
# Description: 
#  Function Observation_in: function handling a observations out flow (flow 5) from TBRC tables to SCORE
#    Entry: l_conn: the oracle connection
#           l_json: {'token': 'xxx', 'tbrc_header': {'tbrc_id': XXXXXXXX, 'claim_id': YYYYYYYY, 'score_id': ZZZZZZZZZZ, flowTypeNum: 5}}
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

#logging.basicConfig(format='%(asctime)s - %(levelname)s: %(message)s', level=getattr(logging, os.getenv('LOGGING_LEVEL').upper()))
# setting path
sys.path.append(os.path.join(os.getcwd(), "shared"))
sys.path.append(os.path.join(os.getcwd(), "python"))

# importing
from tools.cit_functions import CIT_functions
from score_itf_module.m_case import module_case
from score_itf_module.m_chrono import module_chrono
from score_itf_module.m_information import module_information

class Case_update:

    def case_update(self, l_conn, l_json):

      cit_functions = CIT_functions()

      the_json = json.loads(l_json)
      logging.info('case_update: JSON received: ' + str(the_json))

      l_token =  the_json['token']
      l_tbrc_id = the_json['tbrc_header']['tbrc_id']
      l_case = the_json['tbrc_header']['score_id']
      l_claim_id = the_json['tbrc_header']['claim_id']
      
      data_info = {}
      data_info['token'] = l_token
      data_info['caseIMXReference'] = l_case
      data_info['caseExternalReference'] = l_claim_id
      c_main = cit_functions.sql_select(l_conn, 'one'
                                       , """select c.COVERAGE_TYPE_CODE, c.CLAIM_HDL_NAME, c.INDEMN_AMT, c.INDEMN_CURR_CODE, c.INDEMN_DAT
                                                  ,c.COVERAGE_AMT, c.COVERAGE_RATE_INTRO_PCT, c.POL_NBR_NUM, c.POL_CURR_CODE
                                                  ,c.CASE_HANDLING_IND, c.CASE_FREQUENCY_IND, c.ASSESSMENT_TYP
                                                  ,c.GN_SHARE_AMT, c.CUST_SHARE_AMT, c.DISP_CODE_IND
                                                  ,decode (nvl(c.GN_SHARE_AMT,0) + nvl(c.CUST_SHARE_AMT,0), 0, null
                                                          ,round(c.GN_SHARE_AMT / (c.GN_SHARE_AMT + c.CUST_SHARE_AMT), 2)
                                                          ) as COVERAGERATE
                                              from TBRC_COLLECTIONS c
                                             where tbrc_id = :1
                                         """
                                       , [l_tbrc_id], assoc=1)

      if c_main is not None:
        #if row is not None:
        data_info['claimType'] = c_main['COVERAGE_TYPE_CODE']
        data_info['claimHandler'] = c_main['CLAIM_HDL_NAME']
        data_info['indemnAmount'] = c_main['INDEMN_AMT']
        data_info['indemnCurr'] = c_main['INDEMN_CURR_CODE']
        data_info['indemnDate'] = c_main['INDEMN_DAT']
        data_info['coverageAmount'] = c_main['COVERAGE_AMT']
        data_info['initialSharingPct'] = c_main['COVERAGE_RATE_INTRO_PCT']
        data_info['policyNumber'] = c_main['POL_NBR_NUM']
        data_info['policyCurr'] = c_main['POL_CURR_CODE']
        data_info['policyType'] = c_main['CASE_HANDLING_IND']
        data_info['productCode'] = c_main['CASE_FREQUENCY_IND']
        data_info['claimNature'] = c_main['ASSESSMENT_TYP']
        data_info['coverageRate'] = c_main['COVERAGERATE']
        l_dispute = c_main['DISP_CODE_IND']
      else:
        the_error = {}
        the_error['status_code'] = '901'
        the_error['error_message'] = 'No records in tbrc_collections for the tbrc_id ' + str(l_tbrc_id) 
        return json.dumps(the_error)
          
      m_update = module_case()
      #logging.error('case_update: call module_case.m_api_patch_initial_piece: ' + str(data_info))
      logging.debug('case_update: CALL m_api_patch_initial_piece')
      l_case_result = m_update.m_api_patch_initial_piece(json.dumps(data_info))
      logging.debug('case_update: module_case.m_api_patch_initial_piece result: ' + str(l_case_result))

      the_return = json.loads(l_case_result)
      # if OK to handle Info Dispute (Chrono)
      if the_return['status_code'] == 200 or the_return['status_code'] == 201:
        logging.debug('case_update: Disputed: ' + str (l_dispute))
        if l_dispute == 'Y':
          m_chrono = module_chrono()
          data_search = {}
          data_search['token'] = l_token
          data_search['caseIMXReference'] = l_case
          data_search['chronoType'] = 'in'
          data_search['chronoLibelle'] = 'Dispute flag received from CLEAR'
          l_search_result = m_chrono.m_api_search_chrono(json.dumps(data_search))
          logging.debug('case_update: module_case.m_api_patch_initial_piece result: ' + str(l_search_result))
          the_json_search = json.loads(l_search_result)
          logging.debug('case_update: Search returned: ' + str(the_json_search['status_code']))
          if the_json_search['status_code'] == 200 or the_json_search['status_code'] == 201:
            l_numberOfElements = the_json_search['case']['numberOfElements']
            if l_numberOfElements == 0:
              logging.debug('case_update: Call add info')
              m_information = module_information()
              data_info = {}
              data_info['token'] = l_token
              data_info['caseRef'] = l_case
              data_info['title'] = 'Dispute flag received from CLEAR'
              l_info_result = m_information.m_api_add_info(json.dumps(data_info))
              logging.debug('observation_in: m_information.m_api_add_info result: ' + str(l_info_result))

      return l_case_result

