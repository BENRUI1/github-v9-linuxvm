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

cit_fct = CIT_functions()

class module_cit_event:

    def m_cit_get_events(self, p_conn, p_json):
        
        l_json = json.loads(p_json)
        logging.info('m_cit_get_events JSON received: ' + str(l_json))

        interface_code = l_json['interface_code']
        list_action = l_json['list_action']
        event_handling_status = l_json['event_handling_status']
     
        eventList = []
        events = cit_fct.sql_select(p_conn, 'all', """select UN_ID, INTERFACE_CODE, ACTION, IMX_EVENT_ID, REFDOSS, REFINDIVIDU, REFELEM, TYPELEM, CREATION_DATE,
		                                                     DETAIL_1, DETAIL_2, DETAIL_3, DETAIL_4, DETAIL_5, MT_DETAIL_1, MT_DETAIL_2, DT_DETAIL_1, DT_DETAIL_2, 
		                                                     EVENT_HANDLING_STATUS, EVENT_REJECTED_REASON, EVENT_REJECTED_DATE, EVENT_HANDLING_TIMESTAMP
                                               		    from IMX_EVENTS_QUEUE
                                                       where INTERFACE_CODE =:1 
                                                         and EVENT_HANDLING_STATUS =:2
                                                       	 and ACTION in ('""" + "','".join(list_action) + """')""", [interface_code, event_handling_status],assoc=1)
				
        for event in events:
            eventDict = {}
            eventDict['un_id'] = event['UN_ID']
            eventDict['interface_code'] = event['INTERFACE_CODE']			
            eventDict['action'] = event['ACTION']
            eventDict['imx_event_id'] = event['IMX_EVENT_ID']
            eventDict['refdoss'] = event['REFDOSS']
            eventDict['refindividu'] = event['REFINDIVIDU']
            eventDict['refelem'] = event['REFELEM']
            eventDict['typelem'] = event['TYPELEM']
            eventDict['creation_date'] = event['CREATION_DATE'].strftime("%Y-%m-%dT%H:%M:%S")
            eventDict['detail_1'] = event['DETAIL_1']
            eventDict['detail_2'] = event['DETAIL_2']
            eventDict['detail_3'] = event['DETAIL_3']
            eventDict['detail_4'] = event['DETAIL_4']
            eventDict['detail_5'] = event['DETAIL_5']
            eventDict['mt_detail_1'] = event['MT_DETAIL_1']
            eventDict['mt_detail_2'] = event['MT_DETAIL_2']
            eventDict['dt_detail_1'] = event['DT_DETAIL_1']
            eventDict['dt_detail_2'] = event['DT_DETAIL_2']
            eventDict['event_handling_status'] = event['EVENT_HANDLING_STATUS']
            eventDict['event_rejected_reason'] = event['EVENT_REJECTED_REASON']
            eventDict['event_rejected_date'] = event['EVENT_REJECTED_DATE']			
            eventDict['event_handling_timestamp'] = event['EVENT_HANDLING_TIMESTAMP'].strftime("%Y-%m-%dT%H:%M:%S")
            eventList.append(eventDict)
        
        return json.dumps(eventList)
    
    def m_cit_patch_event(self, p_conn, p_json):

        l_json = json.loads(p_json)
        logging.info('m_cit_patch_event JSON received: ' + str(l_json))

        sql = """update IMX_EVENTS_QUEUE
                    set EVENT_HANDLING_STATUS =:1,
					    EVENT_HANDLING_TIMESTAMP = systimestamp
                  where UN_ID = :2"""
        params = [l_json['event_handling_status'], l_json['un_id']]
        cit_fct.sql_exec_ins_upd(p_conn, sql, params) 
            