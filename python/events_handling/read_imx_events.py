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
from tools.cit_connect import CIT_connect 
from tools.cit_functions import CIT_functions 
from score_itf_module.m_login import module_login 
from score_itf_module.m_event import module_event 

cit_connect = CIT_connect()
cit_func = CIT_functions()
m_login = module_login()
m_event = module_event()

conn = cit_connect.get_connection('dbCIT')
c1 = conn.cursor()

def main():
    params = {}
    params['api_login'] = 'SCORE_EVENTS'
    l_return = m_login.m_api_login(json.dumps(params))
    l_return = json.loads(l_return)
    logging.info('read_imx_events login returns: ' + str(l_return))
    if l_return['status_code'] == 200:
        xAuthToken =  l_return['token']
        params = {}
        params['token'] = xAuthToken
        l_return = m_event.m_api_get_events(json.dumps(params))
        l_return = json.loads(l_return)
        if l_return['status_code'] == 200 or l_return['status_code'] == 201:
            imxUnIdList = []
            for event in l_return['events']['content']:
                actions = cit_func.sql_select(conn, 'all', "select * from lov_imx_events_consumers where action=:1", [event['action']], assoc=1)
                for action in actions:
                    c1.execute("""insert into imx_events_queue (
                            un_id, interface_code, action, imx_event_id, refdoss, refindividu, refelem,
                            typelem, creation_date, detail_1, detail_2, detail_3, detail_4, detail_5, mt_detail_1, mt_detail_2,
                            dt_detail_1, dt_detail_2, event_handling_status, event_rejected_reason, event_rejected_date, event_handling_timestamp)
                            values ( 
                            sq_imx_events_queue_un_id.nextval, :1, :2, :3, :4, :5, :6, :7, to_timestamp(:8, 'yyyy-mm-dd"T"hh24:mi:ss'), 
                            :9, :10, :11, :12, :13, :14, :15, to_date(:16, 'yyyy-mm-dd'), to_date(:17, 'yyyy-mm-dd'),
                            'NEW',:18, to_date(:19, 'yyyy-mm-dd'), systimestamp)""", 
                            [action['INTERFACE_CODE'], event['action'], event['imxUnId'], event['refdoss'], event['refindividu'], event['refelem'], 
                            event['typelem'], event['creationDate'], event['detail1'], event['detail2'], event['detail3'], event['detail4'], 
                            event['detail5'], event['mtDetail1'], event['mtDetail2'], event['dtDetail1'], event['dtDetail2'],
                            event['rejectedReason'], event['rejectedDate']])
 
                imxUnIdList.append(event['imxUnId'])

            params['process'] = 'ARCHIVE'
            params['imxUnIdList'] = imxUnIdList
            l_return = m_event.m_api_patch_events(json.dumps(params))
            l_return_json = json.loads(l_return)
            if l_return_json['status_code'] == 200:
               conn.commit()
               logging.info('read_imx_events successfully executed')
            else:
               logging.error('read_imx_events abort - rollback')
               logging.error('Status_code: ' + str(l_return_json['status_code']))
               logging.error('Error: ' + str(l_return_json['error_message']))			

               conn.rollback()
               sys.exit(1)	   
	
    else:
        return json.dumps(l_return)
    
    
# ---------------------------------------------------------------------------------------------------------------------
if __name__ == "__main__":
    main()
    conn.close()
