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
from cit_itf_module.event_services import events_processing

cit_connect = CIT_connect()
cit_func = CIT_functions()
c_event = events_processing()

conn = cit_connect.get_connection('dbCIT')
c1 = conn.cursor()


def main():
    # events = cit_func.sql_select(conn, 'all', """select * from EVENTS_QUEUE q
    #     where action='CONTRACT_VALIDATION_ICARE' and event_handling_status='NEW'
    #         and not exists (select 1 from ICARE_INSURED where cusAccount=q.refdoss)""", assoc=1)
    params = {}
    params['action'] = 'CONTRACT_VALIDATION_ICARE'
    params['event_handling_status'] = 'NEW'
    params['criteria'] = { 'alreadyExported': False }
    l_return = c_event.m_cit_get_events(json.dumps(params))
    l_return = json.loads(l_return)
    for event in l_return['events']:
        row = cit_func.sql_select(conn, 'one', "select 1 from ICARE_INSURED where cusAccount=:1", [event['refdoss']])
        if row is not None:
            if event['DETAIL_1'] == 'Insured':
                c1.execute("""insert into ICARE_INSURED (cusAccount, conRef, eventid, caed, dat_caed) values (:1, :2, :3, 'N', sysdate)""", 
                        [event['refdoss'], event['refelem'], event['id']])
                event_handling_status = 'IN PROGRESS'
            else:
                event_handling_status = 'N/A'
            # c1.execute("update EVENTS_QUEUE set event_handling_status=:1 where eventId=:2", [event_handling_status, event['id']])
            params = {}
            params['id'] = event['id']
            params['event_status'] = event_handling_status
            l_return = c_event.m_cit_patch_event(json.dumps(params))
    
# ---------------------------------------------------------------------------------------------------------------------
if __name__ == "__main__":
    main()

