
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
from score_itf_module.m_information import module_information

class Observations_in:

    def observation_in(self, l_conn, l_json):

      cit_functions = CIT_functions()

      the_json = json.loads(l_json)
      logging.info('observation_in: JSON received: ' + str(the_json))

      l_token =  the_json['token']
      l_tbrc_id = the_json['tbrc_header']['tbrc_id']
      l_case = the_json['tbrc_header']['score_id']
      l_externalRef = the_json['tbrc_header']['claim_id']
      
      data_info = {}
      data_info['token'] = l_token
      data_info['caseIMXReference'] = l_case
      data_info['caseExternalReference'] = l_externalRef

      c_main = cit_functions.sql_select(l_conn, 'one'
                                       , """select o.obs_type_code, o.part_stat_code, o.obs_dat, o.obs_text
                                              from tbrc_observations o 
                                             where o.tbrc_id = :1
                                         """
                                       , [l_tbrc_id], assoc=1)

      if c_main is not None:
        #if row is not None:
        data_info['title'] = 'OBSERVATION DE CLEAR'
        data_info['info'] = c_main['OBS_TEXT']
      else:
        the_error = {}
        the_error['status_code'] = '901'
        the_error['error_message'] = 'No records in tbrc_observations for the tbrc_id ' + str(l_tbrc_id) 
        return json.dumps(the_error)
          
      m_information = module_information()
      l_info_result = m_information.m_api_add_info(json.dumps(data_info))
      logging.info('observation_in: m_information.m_api_add_info result: ' + str(l_info_result))
      return l_info_result

