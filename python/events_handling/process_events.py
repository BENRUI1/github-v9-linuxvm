from datetime import datetime

import cx_Oracle
import os
import configparser
import platform
import sys
import requests
import json
import logging
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(message)s')

# setting path
sys.path.append(os.path.join(os.getcwd(), "python"))
sys.path.append(os.path.join(os.getcwd(), "shared"))

# importing
from tools.cit_functions import CIT_functions
from tools.cit_connect import CIT_connect
from score_itf_module.m_login import module_login as m_login
from score_itf_module.m_event import module_event as m_event

cit_connect = CIT_connect()
cit_func = CIT_functions()
conn = cit_connect.get_connection('dbCIT')
cur = conn.cursor()

def main():
    params = {}
    params['api_login'] = 'SCORE_EVENTS'
    l_return = m_login.m_api_login(json.dumps(params))
    l_return = json.loads(l_return)
    logging.info('clear_score_observations login returns: ' + str(l_return))
    if l_return['status_code'] == 200:
        xAuthToken =  l_return['token']
        params = {}
        params['token'] = xAuthToken
        l_return = m_event.m_api_get_events(json.dumps(params))
        l_return = json.loads(l_return)
        if l_return['status_code'] == 200:
            for event in l_return['events']['content'][0]:
                actions = cit_func.sql_select(conn, 'all', "select * from events_itf_consumer where action=:1", [event['action']])
                for action in actions:
                    cur.execute("""insert into events_queue (
                            id, interface_id, action, external_id, refdoss, refindividu, refelem,
                            typeelem, creation_date, export_date, rejected_reason, rejected_date,
                            detail_1, detail_2, detail_3, detail_4, detail_5, mt_detail_1, mt_detail_2,
                            dt_detail_1, dt_detail_2
                        ) values ( 
                            seq_events_queue.nextval, :1, :2, :3, :4, :5, :6, :7, to_timestamp(:8, 'yyyy-mm-ddThh:mi:ss.fffZ'), to_timestamp(:9),
                            :10, to_timestamp(:11), :12, :13, :14, :15, :16, :17, :18, to_date(:19, 'yyyy-mm-dd'), to_date(:20, 'yyyy-mm-dd')
                            
                        )""", [
                            action['imxUnId'], event['action'], event['external_id'], event['refdoss'], event['refindividu'], event['refelem'], 
                            event['typeelem'], event['creation_date'], event['export_date'], event['rejected_reason'], event['rejected_date'],
                            event['detail_1'], event['detail_2'], event['detail_3'], event['detail_4'], event['detail_5'], event['mt_detail_1'], event['mt_detail_2'],
                            event['dt_detail_1'], event['dt_detail_2']
                        ])
        else:
            return json.dumps(l_return)
    else:
        return json.dumps(l_return)
    
# ---------------------------------------------------------------------------------------------------------------------
if __name__ == "__main__":
    main()
