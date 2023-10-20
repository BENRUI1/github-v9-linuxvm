
# Description: 
#  Function payment_in: function handling a direct_payment (flow 4) from TBRC tables to SCORE
#    Entry: l_conn: the oracle connection
#           l_json: {'token': 'xxx', 'tbrc_header': {'tbrc_id': XXXXXXXX, 'claim_id': YYYYYYYY, 'score_id': ZZZZZZZZZZ, flowTypeNum: 4}}
# Author: BEVRIG1
# Date: 19/07/2023
# Last modifications:
#  version 1.0: BEVRIG1 - 19/07/2023 - initial version
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
from score_itf_module.m_payment import module_payment

class Payment_in:

    def payment_in(self, l_conn, l_json):

      cit_functions = CIT_functions()

      the_json = json.loads(l_json)
      logging.info('payment_in: JSON received: ' + str(the_json))

      l_token =  the_json['token']
      l_tbrc_id = the_json['tbrc_header']['tbrc_id']
      l_case = the_json['tbrc_header']['score_id']
      
      data_info = {}
      data_info['token'] = l_token
      data_info['caseImxReference'] = l_case
      c_main = cit_functions.sql_select(l_conn, 'one'
                                       , """select r.receipt_id, r.buyer_paid_amt, r.buyer_paid_curr_code, to_char(r.receive_date, 'YYYY-MM-DD') as "receiptDate", r.paym_type_code, r.cancel_flag 
                                              from tbrc_recoveries_out r
                                             where r.tbrc_id = :1
                                         """
                                       , [l_tbrc_id], assoc=1)

      if c_main is not None:
        #if row is not None:
        data_info['payAmount'] = c_main['BUYER_PAID_AMT']
        data_info['payCurrency'] = c_main['BUYER_PAID_CURR_CODE']
        data_info['payTitle'] = 'ACD'
        data_info['payMethod'] = 'VIR'
        data_info['payExtRef'] = c_main['RECEIPT_ID']
        data_info['payReceptionDate'] = c_main['receiptDate']
        l_cancel_flag = c_main['CANCEL_FLAG']
        l_payment_type_code = c_main['PAYM_TYPE_CODE']
      else:
        the_error = {}
        the_error['status_code'] = '901'
        the_error['error_message'] = 'No records in tbrc_observations for the tbrc_id ' + str(l_tbrc_id) 
        return json.dumps(the_error)
          
      m_payment = module_payment()
      if l_cancel_flag == 'Y':
        logging.debug('payment_in: Cancel of paymernt received, search for the payment IMX ref saved during the payment creation')
        c_origine = cit_functions.sql_select(l_conn, 'one'
                                            , """select r.receipt_id, r.paym_type_code, r.scoreRef
                                                   from tbrc_recoveries_out r
                                                  where r.receipt_id = :1
                                                    and nvl(r.cancel_flag, 'N') = 'N'
                                                    and r.scoreRef is not null
                                              """
                                           , [data_info['payExtRef']], assoc=1)
        if c_origine is not None:
            #if row is not None:
            data_cancel = {}
            data_cancel['token'] = l_token
            data_cancel['caseIMXReference'] = l_case
            data_cancel['pmtIMXRef'] = c_origine['SCOREREF']
            l_payment_type_code = c_origine['PAYM_TYPE_CODE']
            if l_payment_type_code == 'N':
               data_cancel['pmtType'] = 'vd'
            else:
               data_cancel['pmtType'] = 'en'
            logging.info('payment_in: call m_payment.m_api_cancel_payment')
            l_result = m_payment.m_api_cancel_payment(json.dumps(data_cancel))
        else:
            the_error = {}
            the_error['status_code'] = '901'
            the_error['error_message'] = 'Cannot find the payment to cancel in tbrc_recoveries_out for the tbrc_id ' + str(l_tbrc_id) 
            return json.dumps(the_error)  
      else:
        if l_payment_type_code == 'N':
           logging.info('payment_in: call m_payment.m_api_create_direct_payment')
           l_result = m_payment.m_api_create_direct_payment(json.dumps(data_info))
        else:
           logging.info('payment_in: call m_payment.m_api_create_payment_to_AC')
           l_result = m_payment.m_api_create_payment_to_AC(json.dumps(data_info))   
        the_return = json.loads(l_result)   
        if str(the_return['status_code']) == '200' or str(the_return['status_code']) == '201':
          l_scoreRef = the_return['pmtIMXRef']
          logging.debug('payment_in: update tbrc_recoveries_out with external reference: ' + l_scoreRef)
          l_sqlupdate = "update tbrc_recoveries_out set scoreRef = :1 where tbrc_id = :2" 
          cur_update = l_conn.cursor()
          cur_update.execute(l_sqlupdate, [l_scoreRef, l_tbrc_id])
          cur_update.close()

      logging.info('payment_in: result: ' + str(l_result))
      return l_result

