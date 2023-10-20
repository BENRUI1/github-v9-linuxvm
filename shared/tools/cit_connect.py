
# Description of class CIT_connect: 
#   - get_connection: function is to be able to have a connection to a DB
#                     possible current values for the parameter v_active_env:
#                       - DBAD
#                       - DBCIT
#                       - DBMI
#                       - DBIMX
#                     Returns: the connection object
# Author: BEVRIG1
# Date: 21/06/2023
# Last modifications:
#  version 1.0: BEVRIG1 - 21/06/2023 - initial version
#

import cx_Oracle
import os
import logging
logging.basicConfig(format='%(asctime)s - %(levelname)s: %(message)s', 
                    level=getattr(logging, os.getenv('LOGGING_LEVEL').upper()))

class CIT_connect:

  def get_connection(self, v_active_env):
    
    logging.info('cit_connect.get_connection for: ' + str(v_active_env).upper())
    
    db_host= os.getenv(str(v_active_env).upper() + '_HOST')
    db_password = os.getenv(str(v_active_env).upper() + '_PASSWORD')
    db_port = os.getenv(str(v_active_env).upper() + '_PORT')
    db_sid = os.getenv(str(v_active_env).upper() + '_SID')
    db_username = os.getenv(str(v_active_env).upper() + '_ORANAME')

    logging.info('cit_connect.get_connection: db_username: ' + str(db_username))
    #logging.debug('  db_password: ' + str(db_password))
    #logging.debug('  db_host: ' + str(db_host))
    #logging.debug('  db_port ' + str(db_port))
    #logging.debug('  db_sid: ' + str(db_sid))

    dsn_tns = cx_Oracle.makedsn(db_host, db_port, db_sid)
    conn = cx_Oracle.connect(
      user=db_username, password=db_password, dsn=dsn_tns, 
      encoding="UTF-8", nencoding="UTF-8")
    return conn


