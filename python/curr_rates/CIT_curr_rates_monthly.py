
import os
import sys
import platform
import requests
#import xmltodict
import cx_Oracle
#import oracledb
import configparser
import datetime
import json
import logging

# setting path()
sys.path.append(os.path.join(os.getcwd(), "python"))
sys.path.append(os.path.join(os.getcwd(), "shared"))

from tools.cit_connect import CIT_connect
from tools.cit_functions import CIT_functions

cit_connect = CIT_connect()
cit_functions = CIT_functions()

logging.basicConfig(format='%(asctime)s - %(levelname)s: %(message)s', 
                    level=getattr(logging, os.getenv('LOGGING_LEVEL').upper()))

def check_present_curr(datas, value):
    for data in datas:
        if value == data["curr"] :
            return True
    return False

def main():

    l_conn = cit_connect.get_connection('dbCIT')

    the_path_in = os.getenv('CITMAN_DATA') + '/template/in'

    url_dms_montly_rates = os.getenv('ECB_DAILY_RATES_URL')

    url_dms = os.getenv('DMS_URL')
    url_dms_doc = os.getenv('DMS_URL_DOC')
    dms_scope = os.getenv('DMS_SCOPE')
    dms_auth = os.getenv('DMS_AUTH')


    # check if we have Monthly rates to upload:
    c_month = cit_functions.sql_select(l_conn, 'all', """
                                                    select *
                                                      from t_devise 
                                                     where type = 'M'
                                                      and dtdebut_dt = to_date('01' | | to_char(sysdate, 'MMYYYY') + 1, 'DDMMYYYY')
                                                     """, assoc=1)

    if c_month is None or str(c_month) == '[]':
        logging.debug('MONTHLY RATES TO UPLOAD')

        logging.debug('dms_scope: ' + dms_scope)
        logging.debug('url_dms: ' + url_dms)
        payload = 'grant_type=CLIENT_CREDENTIALS&scope=' + dms_scope
        headers = {
            'Authorization': dms_auth,
            'Content-Type': 'application/x-www-form-urlencoded'
        }

        response = requests.request("POST", url_dms, headers=headers, data=payload,
                                    verify=False)

        logging.debug('Token: response.status_code = ' + str(response.status_code))
        if response.status_code == 200:
            body = response.json()
            the_token = body['access_token']
            logging.debug('token: ' + str(the_token))

            l_date = datetime.datetime.now().strftime("%a, %d %b %Y %H:%M:%S CET")
            url_dms_montly_rates = os.getenv('DMS_URL_MONTLHY_RATES')
            # url = "https://api.sit.atradiusnet.com:443/sc/ref-data/ref-data-api/v2/ref-data/currency-fX/"

            url2 = "EUR/GBP/VAR?language_code=EN&suppress_count_flag=Y&limit=2&from_date=2023-10-01T00:00:01Z"

            logging.debug('url called: ' + str(url_dms_montly_rates) + str(url2))
            payload = {}
            headers = {
                  'Authorization': 'Bearer ' + the_token,
                  'Atradius-Origin-User-Id': 'INYALI1',
                  'Atradius-Origin-Application': 'SCORE',
                  'Atradius-Origin-Service': 'SC',
                  'Atradius-Invocation-Service': 'SC',
                  'Atradius-Message-Timestamp': l_date
            }


            response = requests.request("GET", url_dms_montly_rates + url2, headers=headers, data=payload, verify=False)

            #print(response.content)

            body = json.loads(response.content)
            logging.debug("body: " + str(body))
            logging.debug('  ')
            logging.debug("body: " +  str(body["response"]["data"]["currencies_fx"][0]))


    else:
        logging.debug('MONTHLY RATES ALREADY UPLOADED')

    l_conn.close()

if __name__ == "__main__":
    main()


