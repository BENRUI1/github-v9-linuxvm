import datetime as dt

import cx_Oracle
import os
import json
import requests
import configparser
import platform
import sys

# setting path
sys.path.append(os.path.join(os.getcwd(), "shared"))
sys.path.append(os.path.join(os.getcwd(), "python"))

# importing
from cit_shared.cit_connect import CIT_connect

cit_connect = CIT_connect()
conn = cit_connect.get_connection('dbCIT')

def fields(cursor):
    results = {}
    column = 0
    for d in cursor.description:
        results[d[0]] = column
        column = column + 1

    return results

def main():

    dir_tmp_file = os.getenv("CITMAN_TMP_FILE")
    print(dir_tmp_file)
    handle = open(dir_tmp_file + 'cs_portfolio_maintenance.txt', 'w')

    curr_time = dt.datetime.today().strftime('%Y-%m-%d %H:%M:%S')
    print('Starting at: ', curr_time)
    handle.write('Starting at: '+ curr_time + "\n")
    # on_test = 'Y' => NO calls of DB updates and API
    on_test = 'N'

    # to get the authentication
    cs_root_url = os.getenv("CREDITSAFE_URL")
    cs_user = os.getenv("CREDITSAFE_USER")
    cs_pw = os.getenv("CREDITSAFE_PW")	

    #today = date.today()
    today = dt.datetime.today().strftime('%Y-%m-%d')

	#YDC - start comment : putting below delete in comment ; it doesn't make sense to do every day a full sync between CS and cit_cs_portfolio
    #print('Deletion of all records from cit_cs_portfolio')
    #handle.write('Deletion of all records from cit_cs_portfolio' + "\n")
    # 
    #sql0_0 = 'delete from cit_cs_portfolio'
    #cur_0_0 = conn.cursor()
    #cur_0_0.execute(sql0_0)
    #conn.commit()
    #YDC - end comment 

    c1 = conn.cursor()
    c1.execute("select COUNTRY,PORTFOLIO_ID from LOV_CS_PORTFOLIO_MONITORING")

    field_map1 = fields(c1)
    for row in c1:
        l_country = row[field_map1['COUNTRY']]
        l_portfolio = row[field_map1['PORTFOLIO_ID']]
        print('country: ', l_country, ' portfolio: ', l_portfolio)
        handle.write('Country checked: ' + l_country + "\n")

        url = cs_root_url + '/v1/authenticate'
        payload = json.dumps({
                    "username": cs_user,
                    "password": cs_pw})
        headers = {'Content-Type': 'application/json'}
        response = requests.post(url, headers=headers, data=payload)
        data = response.json()

        if response.status_code == 200:
           token = data["token"]
           # authentication received

           #YDC - start comment : putting below delete in comment ; it doesn't make sense to do every day a full sync between CS and cit_cs_portfolio
           #headers = {'Content-Type': 'application/json'}
           #response = requests.post(url, headers=headers, data=payload)
           #data = response.json()
           #headers = {'Content-Type': 'application/json', 'Authorization': token}
           #url = cs_root_url + '/v1/monitoring/portfolios/'+l_portfolio+'/companies'
           #print('url for getting companies: ', url)
           #handle.write('url for getting companies: ' + url + "\n")
           #response = requests.get(url, headers=headers)
           #body = response.json()
           #print('Response:', response)
           #handle.write('Response:' + str(response.status_code) + "\n")
           #print('Total count: ',str(body["totalCount"]))
           #handle.write('Total count to be inserted into cit_cs_portfolio: ' + str(body["totalCount"]) + "\n")

           # looping in the result to save the IMX numbers....
           #page = 0
           #next = body["paging"]["next"]
           #last = body["paging"]["last"]

           #while page <= last:
           #     idc = 0
           #     data = body["data"]
           #     nmb_id = len(data) - 1

           #     while idc <= nmb_id:
           #         imx = data[idc]["personalReference"]
           #         CSNum = data[idc]["id"]
           #         handle.write('Country: ' + l_country + " CS NUM: " + str(CSNum or '(None)') + ' IMX: ' + str(imx or '(None)') + "\n")
           #         idc += 1
           #         #checking if we don't have several IMX for the CS number
           #         imx2 = imx.split(',')
           #         for the_imx in imx2:
           #             imx_to_Add = the_imx
           #             handle.write('To insert: Country: ' + l_country + " CS NUM: " + str(CSNum or '(None)') + ' IMX: ' + imx_to_Add + ' portfolio_id: ' + l_portfolio + "\n")
           #             sql0_1 = 'insert into cit_cs_portfolio (refindividu, pays, refext, portfolio_id, the_date)' \
           #                      ' values(:1, :2, :3, :4, trunc(sysdate))'
           #             cur_0_1 = conn.cursor()
           #             cur_0_1.execute(sql0_1, [imx_to_Add, l_country, CSNum, l_portfolio])

           #         #end for imx.split(',')
           #     #end while

           #    conn.commit()
           #     if next is None:
           #         page += 1
           #     else:
           #         url = cs_root_url + '/v1/monitoring/portfolios/' + l_portfolio + '/companies?page=' + str(next)
           #         print('Next url for getting companies: ', url)
           #         handle.write('Next url for getting companies: ' + url + "\n")
           #         response = requests.get(url, headers=headers)
           #         print(response)
           #         handle.write(str(requests.Response()) + "\n")
           #         try:
           #             body = response.json()
           #             next = body["paging"]["next"]
           #             last = body["paging"]["last"]
           #         except:
           #             print("EXCEPTION for this page" + str(next))
           #             handle.write("EXCEPTION for this page" + str(next) + "\n")
           #             next = next + 1
           #             pass
           #         page += 1
           #     # end loop of getting all data from countries

           #conn.commit()

           #YDC - end comment : putting below delete in comment ; it doesn't make sense to do every day a full sync between CS and cit_cs_portfolio



           # check the cases to REMOVE from the portfolio for this country
           handle.write('check the cases to REMOVE from the portfolio for this country' + "\n")
           l_counter = 0
           sql2 = "select s.REFINDIVIDU, s.PAYS, s.REFEXT from cit_cs_portfolio s " \
                  " where 1 = 1 " \
                  " and s.pays = :1 " \
                  " and not exists (select 1 " \
                  "                   from t_intervenants iDB, g_dossier d, g_individu i " \
                  "                  where iDB.refindividu = s.refindividu " \
                  "                    and iDB.reftype = 'DB'" \
                  "                    and i.refindividu = s.refindividu " \
                  "                    and i.str11 is null " \
                  "                    and d.refdoss = iDB.refdoss " \
                  "                    and (d.categdoss = 'INSURED' or d.categdoss = 'NOT INSURED') " \
                  "                    and d.phase <> '''SLEEP''' " \
                  "                    and nvl(cit_checkClosedCase(d.refdoss), 'N') = 'N' " \
                  "                    )"
           c2 = conn.cursor()
           c2.execute(sql2, [l_country])
           field_map2 = fields(c2)
           for row in c2:
                l_counter = l_counter + 1
                l_refindiv = row[field_map2['REFINDIVIDU']]
                l_refext = row[field_map2['REFEXT']]
                #l_country = row[field_map2['PAYS']]
                print('Deletion: l_refindiv: ', l_refindiv, ' RefExt: ', l_refext, ' Country: ', l_country)
                handle.write('Deletion: l_refindiv: ' + l_refindiv + ' RefExt: ' + (l_refext or '(None)') + ' Country: ' + l_country + "\n")
                l_count = 0
                sql3 = "select count(*) as COUNTER from cit_cs_portfolio s " \
                       " where 1 = 1 " \
                       "   and s.refext = :1 "
                c3 = conn.cursor()
                c3.execute(sql3, [l_refext])
                field_map3 = fields(c3)
                for row in c3:
                    l_count = row[field_map3['COUNTER']]
                c3.close()
                print('Number of records in temp table: ', l_count)
                handle.write('Number of records fot this IMX in temp table: ' + str(l_count) + "\n")
                # anyway to delete the record in the table - set in comment for tests
                sql4 = 'delete from cit_cs_portfolio where refindividu = :1 and refext = :2'
                cur4 = conn.cursor()
                #print('Call delete: ', sql4)
                if on_test == 'N':
                  print('Not in testing phase, calling delete')
                  cur4.execute(sql4, [l_refindiv, l_refext])
                  conn.commit()
                else:
                    print('Testing phase, NOT calling Update')

                if l_count > 1:
                    print('We have to update the case in the portfolio with the remaining values with API')
                    l_countremove = 0
                    l_refremove = ""
                    sql5 = " select distinct s.REFINDIVIDU, s.PAYS, s.REFEXT from cit_cs_portfolio s " \
                           " where 1 = 1 " \
                           "   and s.refext = :1 "
                    c5 = conn.cursor()
                    c5.execute(sql5, [l_refext])
                    field_map5 = fields(c5)
                    for row in c5:
                        l_countremove = l_countremove + 1
                        if l_countremove == 1:
                            l_refremove = row[field_map5['REFINDIVIDU']]
                        else:
                            l_refremove = l_refremove+','+row[field_map5['REFINDIVIDU']]
                    c5.close()
                    print('New ext ref to put: ', l_refremove)
                    handle.write('New ext ref to put: ' + l_refremove + "\n")
                    print('TO CALL: UPDATE in the portfolio ', l_portfolio, 'extref: ', l_refext, ' new reference:', l_refremove)
                    headers = {'Content-Type': 'application/json', 'Authorization': token}
                    handle.write('Deletion: Update in the portfolio ' + l_portfolio + ' extref: ' + l_refext + ' new reference: ' + l_refremove + "\n")
                    url = cs_root_url + '/v1/monitoring/portfolios/' + l_portfolio + '/companies/' + l_refext
                    print('url for update: ', url)
                    payload = json.dumps({
                        "id": l_refext,
                        "personalReference": l_refremove,
                        "freeText": today,
                        "personalLimit": "40"
                    })
                    print('payload = ', payload)
                    if on_test == 'N':
                        print('Not in testing phase, calling API')
                        response = requests.patch(url, headers=headers, data=payload)
                        #data = response.json()
                        print('Response:', response)
                    else:
                        print('Testing phase, NOT calling API')
                # end of if l_count > 1:
                else:
                    print('Just to remove this identity with API')
                    l_refremove = l_refindiv
                    print('Case IMX ref to remove: ', l_refremove)
                    print('TO CALL: DELETE in the portfolio ', l_portfolio, ' reference:', l_refext)
                    handle.write('Deletion in the portfolio ' + l_portfolio + ' extref: ' + (l_refext or '(None)') + "\n")
                    headers = {'Content-Type': 'application/json', 'Authorization': token}
                    url = cs_root_url + '/v1/monitoring/portfolios/'+l_portfolio+'/companies/'+(l_refext or '')
                    print('url for deletion: ', url)
                    if on_test == 'N':
                      print('Not in testing phase, calling update')
                      response = requests.delete(url, headers=headers)
                      #data = response.json()
                      print('Response:', response)
                    else:
                        print('Testing phase, NOT calling API')
                # end of else of if l_count > 1:
           # end of loop in companies to remove
           c2.close()  # fermeture of the removal cursor
           conn.commit()
           print('Counter of deletion: ', l_counter)
           handle.write("Number of company deleted/updated: " + str(l_counter) + "\n")

           # get the case we have to insert
           handle.write('Check the cases to ADD to the portfolio for this country' + "\n")
           l_counter = 0
           sql6 = "select distinct s.refindividu, int.refext, i.pays from ext_scoring_note s, g_individu i, t_individu int " \
                  " where 1 = 1  " \
                  " and not exists( select 1 from cit_cs_portfolio p where p.refindividu = s.refindividu)  " \
                  " and int.refindividu = i.refindividu  " \
                  " and int.societe = 'CREDITSAFE'  " \
                  " and s.refindividu = i.refindividu " \
                  " and i.pays = :1  " \
                  " and exists (select 1  " \
                  "               from t_intervenants iDB, g_dossier d, g_individu i  " \
                  "               where iDB.refindividu = s.refindividu " \
                  "                 and iDB.reftype = 'DB'  " \
                  "                 and i.refindividu = s.refindividu " \
                  "                 and i.str11 is null " \
                  "                 and d.refdoss = iDB.refdoss  " \
                  "                 and (d.categdoss = 'INSURED' or d.categdoss = 'NOT INSURED')  " \
                  "                 and d.phase <> 'SLEEP'  " \
                  "                 and nvl(cit_checkClosedCase(d.refdoss), 'N') = 'N'  " \
                  ")"
           c6 = conn.cursor()
           c6.execute(sql6, [l_country])
           print('Checking result of: if any candidate of add')
           field_map6 = fields(c6)
           for row in c6:
               l_counter = l_counter + 1
               l_refindiv = row[field_map6['REFINDIVIDU']]
               l_refext = row[field_map6['REFEXT']]
               l_country = row[field_map6['PAYS']]
               print('To add: l_refindiv: ', l_refindiv, ' RefExt: ', l_refext, ' Country: ', l_country)
               handle.write('To add: l_refindiv: ' + l_refindiv + ' RefExt: ' + l_refext + ' Country: ' + l_country + "\n")
               l_count = 0
               sql7 = "select count(*) as COUNTER from cit_cs_portfolio s " \
                      " where 1 = 1 " \
                      "   and s.refext = :1 "
               c7 = conn.cursor()
               c7.execute(sql7, [l_refext])
               field_map7 = fields(c7)
               for row in c7:
                   l_count = row[field_map7['COUNTER']]
               c7.close()
               print('Number of records in temp table: ', l_count)
               handle.write('Number of records in temp table: : ' + str(l_count) + "\n")
               # anyway to add the record in the table - in comment for tests
               sql8 = 'insert into cit_cs_portfolio (refindividu, pays, refext, the_date)' \
                   ' values(:1, :2, :3, trunc(sysdate))'
               cur8 = conn.cursor()
               if on_test == 'N':
                 print('Not in testing phase, calling insert')
                 cur8.execute(sql8, [l_refindiv, l_country, l_refext])
                 conn.commit()
               else:
                   print('Testing phase, NOT calling Insert')

               if l_count > 0:
                   print('We have to update the case in the portfolio with the values with API')
                   l_countadd = 0
                   l_refadd = ""
                   sql9 = " select s.REFINDIVIDU, s.PAYS, s.REFEXT from cit_cs_portfolio s " \
                          " where 1 = 1 " \
                          "   and s.refext = :1 "
                   c9 = conn.cursor()
                   c9.execute(sql9, [l_refext])
                   field_map9 = fields(c9)
                   for row in c9:
                       l_countadd = l_countadd + 1
                       if l_countadd == 1:
                           l_refadd= row[field_map9['REFINDIVIDU']]
                       else:
                           l_refadd = l_refadd+','+row[field_map9['REFINDIVIDU']]
                   c9.close()
                   print('New ext ref to put: ', l_refadd)
                   print('TO CALL: UPDATE in the portfolio ', l_portfolio, 'extref: ', l_refext, ' new reference:', l_refadd)
                   headers = {'Content-Type': 'application/json', 'Authorization': token}
                   handle.write('Add. Update in the portfolio ' + l_portfolio + ' extref: ' + l_refext + ' new reference: ' + l_refadd + "\n")
                   url = cs_root_url + '/v1/monitoring/portfolios/' + l_portfolio + '/companies/' + l_refext
                   print('url for update: ', url)
                   payload = json.dumps({
                       "id": l_refext,
                       "personalReference": l_refadd,
                       "freeText": today,
                       "personalLimit": "40"
                   })
                   print('Patch request: ', payload)
                   if on_test == 'N':
                       print('Not in testing phase, calling API')
                       response = requests.patch(url, headers=headers, data=payload)
                       #data = response.json()
                       print('Response:', response)
                   else:
                       print('Testing phase, NOT calling API')
               # end of if l_count > 1:
               else:
                   print('Just to add this identity with API')
                   l_refadd = l_refindiv
                   print('TO CALL: POST in the portfolio ', l_portfolio, ' reference:', l_refext, ' internal ref ', l_refadd)
                   headers = {'Content-Type': 'application/json', 'Authorization': token}
                   handle.write('Add. portfolio ' + l_portfolio + ' extref: ' + l_refext + ' reference: ' + l_refadd + "\n")
                   url = cs_root_url + '/v1/monitoring/portfolios/'+l_portfolio+'/companies'
                   print('url for Add: ', url)
                   payload = json.dumps({
                       "id": l_refext,
                       "personalReference": l_refadd,
                       "freeText": today,
                       "personalLimit": "40"
                   })
                   print('Post request: ', payload)
                   if on_test == 'N':
                       print('Not in testing phase, calling API')
                       response = requests.post(url, headers=headers, data=payload)
                       #data = response.json()
                       print('Response:', response)
                   else:
                       print('Testing phase, NOT calling API')
               # end of else of if l_count > 1:
           # end of loop in companies to add
           c6.close()
           print('Number of new company added: ', l_counter)
           handle.write("Number of new company added: " + str(l_counter) + "\n")

          #end of authorisation OK
        else:
          print(response.status_code)
          print(response.text.encode('utf8'))

      # end of loop of countries to be handled
    c1.close()

    conn.commit()
 
    curr_time = dt.datetime.today().strftime('%Y-%m-%d %H:%M:%S')
    print('Ending at: ', curr_time)

    handle.write('Ending at: ' + curr_time + "\n")
    handle.close()

if __name__ == "__main__":
    main()
    conn.close()
