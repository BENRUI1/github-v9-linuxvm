
import os
import sys
import platform
import requests
import xmltodict
import cx_Oracle
import logging
#import oracledb
#import configparser
from datetime import datetime
import paramiko
import shutil

# setting path()
sys.path.append(os.path.join(os.getcwd(), "python"))
sys.path.append(os.path.join(os.getcwd(), "shared"))

from tools.cit_connect import CIT_connect
from tools.cit_functions import CIT_functions

cit_connect = CIT_connect()
cit_functions = CIT_functions()

logging.basicConfig(format='%(asctime)s - %(levelname)s: %(message)s', 
                    level=getattr(logging, os.getenv('LOGGING_LEVEL').upper()))

# BEVRIG1: to be updated for unix
# to connect to score database%
# dsn_tns = cx_Oracle.makedsn(db_host, db_port, service_name=db_service_name)
# l_conn = cx_Oracle.connect(user=db_username, password=db_password, dsn=dsn_tns)

# Python 3.11 Enabling python-oracledb Thick mode
# oracledb.init_oracle_client()
# dsn_tns = oracledb.makedsn(db_host, db_port, service_name=db_service_name)
# l_conn = oracledb.connect(user=db_username, password=db_password, dsn=dsn_tns)

def check_present_curr(datas, value):
    for data in datas:
        if value == data["curr"] :
            return True
    return False

def main():

    l_conn = cit_connect.get_connection('dbCIT')
    
    # url = "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
    url = os.getenv('ECB_DAILY_RATES_URL')

    logging.debug('url to get rates: ' + str(url))

    response = requests.get(url)
    logging.debug('response: ' + str(response.content))

    with open(os.getenv('CITMAN_DATA') + '/ecb_daily_rates.xml', 'wb') as file:
        file.write(response.content)
    file.close()

    with open(os.getenv('CITMAN_DATA') + '/ecb_daily_rates.xml', 'r', encoding='utf-8') as file:
        my_xml = file.read()
    file.close()

    os.remove(os.getenv('CITMAN_DATA') + '/ecb_daily_rates.xml')

    my_dict = xmltodict.parse(my_xml)
    logging.debug('dict: ' + str(my_dict))

    the_date = my_dict["gesmes:Envelope"]["Cube"]["Cube"]["@time"]
    logging.debug('date: ' + str(the_date))

    # date received: date: 2023-10-06
    date_obj = datetime.strptime(the_date, '%Y-%m-%d')
    l_date = date_obj.strftime("%Y%m%d")
    logging.debug('l_date_title: ' + str(l_date))
    # 25/03/2010
    l_date_file = date_obj.strftime("%d/%m/%Y")
    logging.debug('l_date_file: ' + str(l_date_file))

    dict_currencies = my_dict["gesmes:Envelope"]["Cube"]["Cube"]["Cube"]

    all_curr = []
    for curr in dict_currencies:
        all_curr.append({'curr' : curr["@currency"], 'rate' : curr["@rate"], 'origin' : 'www.ecb.europa.eu'})

    c_main = cit_functions.sql_select(l_conn, 'all', """
                                                select dtdebut_dt, origine, taux from t_devise where type = 'M' 
                                                   and dtdebut_dt is not null 
                                                   and dtdebut_dt = (select max(dtdebut_dt) from t_devise 
                                                                       where type = 'M' 
                                                                         and dtdebut_dt is not null)
                                                  order by 2
                                                 """, assoc=1)
    if c_main is not None and str(c_main) != '[]':

        for row in c_main:
            l_curr = row['ORIGINE']
            l_rate = str(row['TAUX'])

            if check_present_curr(all_curr, l_curr) is False:
               # print('taux curr ' + str(l_curr) + ' NOT present, taux to put: '+ str(l_rate))
               all_curr.append({'curr': l_curr, 'rate': l_rate, 'origin': 'monthly rates'})

    # creation of the file to send to Codix
    # example:  CURRATE-GERMANY-20100214.txt
    file_name = 'CURRATE-EUR-' + l_date + '-J.txt'
    logging.debug('file_name: ' + str(file_name))
    the_file = open(file_name, "w")

    for curr2 in all_curr:

         l_line = (l_date_file + chr(9) + 'EUR' + chr(9) + curr2['rate'] + chr(9) + curr2['curr']
                   + chr(9) + 'J' + chr(9) + 'I')
         logging.debug('Write line in file: ' + l_line + chr(9) +' Origin: ' + curr2['origin'])
         the_file.write(l_line + '\n')

    #the_file.write(chr(10))
    the_file.close()

    print('file name: ' + str(file_name))

    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect('192.168.249.70', username='sftpuser', password='Sofphia@2023')

    scp = ssh.open_sftp()
    scp.put(file_name, '/home/sftpuser/upload/' + file_name)
    scp.close()

    shutil.move(file_name, os.getenv('CITMAN_DATA') + '/curr_rates/' + file_name)

    print('Process completed')

    l_conn.close()

if __name__ == "__main__":
    main()
