
# Description: class CIT_functions
#  Functions:
#     - fields: BEVRIG1 - Create a dictionary mapping each field name to a column index following a cursor
#     - sql_select: BEODEL1 - Standard function to call a sql statement
#     - subprocess_run: BEODEL1 - Function providing the possibility to call ksh scripts
#     - get_lov_cit_scripts: TEST script - to be rewriten
#
# Author: BEVRIG1/BEODEL1
# Date: 21/06/2023
# Last modifications:
#  version 1.0: BEVRIG1 - 21/06/2023 - initial version
#

from datetime import datetime

import cx_Oracle
import os
import configparser
import platform
import logging
logging.basicConfig(format='%(asctime)s - %(levelname)s: %(message)s', 
                    level=getattr(logging, os.getenv('LOGGING_LEVEL').upper()))
#logging.info('info')
import subprocess
import sys

class CIT_functions:

  def fields(self, cursor):
    results = {}
    column = 0
    for d in cursor.description:
        results[d[0]] = column
        column = column + 1
    return results

  def sql_select(self, conn, fetch_type, sql, params=None, assoc=0):
    params = params or []
    cur = conn.cursor()
    cur.execute(sql, params)
    if assoc == 1:
        columns = [col[0] for col in cur.description]
        cur.rowfactory = lambda *args: dict(zip(columns, args))
    while True:
        if fetch_type == 'one':
            row = cur.fetchone()
        else:
            row = cur.fetchall()
        cur.close()
        if row is None:
            return None
        else:
            return row

  def sql_exec_ins_upd(self, conn, sql, ins_array): 
    try:
        cur=conn.cursor()
        cur.execute(sql,ins_array)

    except cx_Oracle.DatabaseError as exc:
        error, = exc.args
        if error.code == 1:
           logging.warning('Oracle duplicate on sql : ' + sql)
        else:		   
           logging.error('Oracle-Error-Code:' + str(error.code))
           logging.error('Oracle-Error-Message:' + error.message)
           sys.exit(1)		
        
  #Le paramètre wait indique si le script attend la fin du ksh. Par défaut (wait=False), il n’attend pas. La focntion permet de lancer plusieurs ksh’s, séparés par un point-virgule (;).
  def subprocess_run(self, scripts, wait=False):
      for script in scripts.split(';'):
        exc_tuple = ''
        runargs = 'nohup ' + script + ('' if wait else ' &')
        try:
            subprocess.run('nohup ' + runargs + (' &' if wait else ''), shell=True, check=True)
        except subprocess.CalledProcessError:
            exc_tuple = sys.exc_info()
        if len(exc_tuple) == 0:
            print('run', script)
        else:
            print(exc_tuple[0])
            raise Exception('Error when running ' + script)

  def countryISO3_to_ISO2(self, conn, l_iso3):
      l_sql = """select ISO2 from LOV_COUNTRY where ISO3 = :1"""
      
      l_iso2 = self.sql_select(conn, 'one', l_sql, [l_iso3], assoc=0) 
      return l_iso2[0]

  def get_lov_cit_scripts(self
                         ,l_conn
                         ,l_script
                         ,l_type = None
                         ,l_env = None
                         ,l_hd = None
                         ,l_country = None
                         ,l_language = None):
      l_value = None
      #logging.debug('get_lov_cit_scripts called for ' + l_script + ' type: ' + l_type)
      
      l_sql = """
                  select * from LOV_CIT_SCRIPTS
                   where script = :1
                     and type = :2
                     and nvl(env, 'XXX') = nvl(:3, nvl(env, 'XXX'))
                     and nvl(hd, 'XXX') = nvl(:4, nvl(hd, 'XXX'))
                     and nvl(country, 'XXX') = nvl (:5, nvl(country, 'XXX'))
                     and nvl(language, 'XX') = nvl(:6, nvl(language, 'XX'))
              """
      
      #row = self.sql_select(l_conn, 'one', l_sql, [l_script, str(l_type), str(l_env), str(l_hd), str(l_country), str(l_language)], assoc=1)
      cur_select = l_conn.cursor()
      cur_select.execute(l_sql, [l_script, l_type, l_env, l_hd, l_country, l_language])
      field_map = self.fields(cur_select)
      
      row = cur_select.fetchone()
      l_value = row[field_map['VALUE']]
      
      #l_value = row['VALUE']
      logging.debug('get_lov_cit_scripts l_value to return = ' + str(l_value))
      if row is not None: 
        #l_value = row['VALUE']
        logging.debug('rowreturn = ' + str(row))
      #cur_select.close()
      return l_value
  
  def is_closed_case(self, scoreId, stratification):
    if  stratification == 'A':
      return 'N'
    else:
      return 'Y' 

 