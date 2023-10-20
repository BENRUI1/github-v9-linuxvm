# 1) program initially written by Olivier Delooz - June 2020
# 2) updated by Yvan De Cneef in the context of SunShade (V9) project - June 2023
#    initial syntax has been left intact as much as possible and does as such not contain all best DEV practices 
#    agreed upon in the SunShade context
 
import platform
import datetime
import cx_Oracle
import os
import configparser
import requests
import json

# setting path
sys.path.append(os.path.join(os.getcwd(), "shared"))
sys.path.append(os.path.join(os.getcwd(), "python"))

# importing
from cit_shared.cit_connect import CIT_connect
from score_itf_module.m_ext_rating import module_ext_rating
from score_itf_module.m_login import module_login

cit_connect = CIT_connect()
conn = cit_connect.get_connection('dbCIT')

cs_root_url = os.getenv('CREDITSAFE_URL')
cs_user = os.getenv('CREDITSAFE_USER')
cs_pw = os.getenv('CREDITSAFE_PW')	

def cs_authenticate(root_url, username, password):
    url = root_url + '/v1/authenticate'
    payload = json.dumps({"username": username, "password": password})
    headers = {'Content-Type': 'application/json'}
    response = requests.post(url, headers=headers, data=payload)
    data = response.json()

    if response.status_code == 200:
        return data["token"]
    else:
        print(response.status_code)
        print(response.text.encode('utf8'))
        return ' '


def select_one(sql, params):
    cur = conn.cursor()
    cur.execute(sql, params)
    while True:
        row = cur.fetchone()
        if row is None:
            return None
            break
        return row
    cur.close()


def main():

    # Get token for Score API's 
    score_login = module_login()
 
    m_ext_rating = module_ext_rating()

    params = {}
    params['api_login'] = 'CS_DAILY'
    l_return = score_login.m_api_login(json.dumps(params))
    l_return = json.loads(l_return)
        
    if l_return['status_code'] == 200:
       IMX_AuthToken =  l_return['token']
    else:
       sys.exit()

    cs_token = cs_authenticate(cs_root_url, cs_user, cs_pw)

    handle = open(env_data + 'cs_daily.txt', 'w')

    event = []

    row = select_one("""select to_char(effect_from_dat,'yyyy-mm-dd"T"hh24:mi:ss"Z"') from cit_ksh_param where script='CS_DAILY'""", [])
    startDate = row[0]
    print('startDate =', startDate)

    url = cs_root_url + '/v1/monitoring/notificationEvents?startDate=' + startDate + '&sortBy=eventDate'
    headers = {'Content-Type': 'application/json', 'Authorization': token}
    response = requests.get(url, headers=headers)
    body = response.json()

    if body["totalCount"] > 0:

        page = 0
        next = body["paging"]["next"]
        last = body["paging"]["last"]

        while page <= last:
            idc = 0
            data = body["data"]
            nmb_id = len(data) - 1

            while idc <= nmb_id:
                company = data[idc]["company"]
                eventDate = data[idc]["eventDate"]
                portfolioId = company["portfolioId"]
                companyId = company["id"]

                event.append((portfolioId, companyId))

                idc += 1
                # end loop

            if next is None:
                page += 1
            else:
                url = cs_root_url + '/v1/monitoring/notificationEvents?startDate=' + startDate + '&sortBy=eventDate&page=' + str(next)
                headers = {'Content-Type': 'application/json', 'Authorization': token}
                response = requests.get(url, headers=headers)
                body = response.json()
                page += 1
                next = body["paging"]["next"]
                last = body["paging"]["last"]
                # end if

            # end loop

        print('Before =', len(event))
        temp = []
        for a, b in event:
            if (a, b) not in temp:  # to check for the duplicate tuples
                temp.append((a, b))
        event = temp * 1
        print('After =', len(event))

        v_count = 0
        v_limit = 200
        for portfolioId, companyId in event:

            url = cs_root_url + '/v1/monitoring/portfolios/' + str(portfolioId) + '/companies/' + str(companyId)
            headers = {'Content-Type': 'application/json', 'Authorization': token}
            response = requests.get(url, headers=headers)
            if response.status_code == 200:
                body = response.json()
                personalReferences = body["personalReference"]
                rating = body["ratingCommon"]

                if rating is None or len(rating) == 0:
                    handle.write(str(portfolioId) + '|' +
                        str(companyId) + '|' + personalReferences + " - No update (rating empty)\n")
                else:
                    personalReferences = personalReferences.split(',')
                    for personalReference in personalReferences:
                        #Because of V9, all refindividu of V8 are replaced ; those old refindividu have been saved as external references, type 'A IMX')
                        #So, first check in T_INDIVIDU if we have a match on type 'A IMX' for personalReference ; 
                        row = select_one("select refindividu from t_individu where societe = 'A IMX' and refext = :1",[personalReference])                     
                        if row is None:
                           score_refindividu = personalReference 						
                        else:						
                           score_refindividu = row[0]
	
                        row = select_one("select refindividu from g_individu where refindividu=:1", [score_refindividu])
                        if row is None:
                            handle.write(str(portfolioId) + '|' +
                                str(companyId) + '|' + score_refindividu + '|Unknown individual' + "\n")
                        else:
                            row = select_one("select imx_un_id, rating from ext_scoring_note where refindividu=:1 and dt_validity is null", [score_refindividu])
                            if row is None:
                                #Because of V9, below insert needs to be replaced by an API call       

                                #val1 = 'CREDITSAFE'
                                #val2 = datetime.datetime.today().strftime('%Y%m%d%H%M%S')
	                            #sql = "insert into ext_scoring_note (issuer, dt_rating, rating, refindividu,createur) values (:1, to_date(:2, 'yyyymmddhh24miss'), :3, :4, :5)"
                                #c1 = conn.cursor()
                                #c1.execute(sql, [val1, val2, rating, personalReference, 'CS_DAILY'])
                                #handle.write(str(portfolioId) + '|' + str(companyId) + '|' + personalReference + '|' + rating + " - Insert\n")
                                #c1.close()
								
                                params = {}
                                params['token'] = IMX_AuthToken
                                params['refIndividual'] = score_refindividu
                                params['rating'] = rating
                                params['rating_issuer'] = 'CS'		   
                                params['rating_date'] = datetime.datetime.today().strftime('%Y-%m-%d')
                                l_return = m_ext_rating.m_api_post_ext_rating(json.dumps(params))
                                print(l_return)	
                            else:
                                old_rating = row[1]
                                if rating != old_rating:

                                    #Because of V9, below update needs to be replaced by an API call for updating the old record and inserting the new one                    

                                    #val = (datetime.datetime.today() - datetime.timedelta(days=1)).strftime('%Y%m%d')
                                    #sql = "update ext_scoring_note set dt_validity = to_date(:1, 'yyyymmdd') where refindividu='" + personalReference + "' and dt_validity is null"
                                    #c1 = conn.cursor()
                                    #c1.execute(sql, [val])
                                    #handle.write(str(portfolioId) + '|' + str(companyId) + '|' + personalReference + '|' + old_rating + ' -> ' + rating + " - Update\n")
                                    #c1.close()
 
                                    params = {}
                                    params['token'] = IMX_AuthToken
                                    params['refIndividual'] = score_refindividu
									params['extScoreId'] = row[0]
                                    params['rating'] = rating
                                    params['rating_issuer'] = 'CS'		   
                                    params['rating_date'] = row[2].strftime('%Y-%m-%d')
									params['val_date'] = (datetime.datetime.today() - datetime.timedelta(days=1)).strftime('%Y-%m-%d')
                                    l_return = m_ext_rating.m_api_put_ext_rating(json.dumps(params))
                                    print(l_return)	

                                    #val1 = 'CREDITSAFE'
                                    #val2 = datetime.datetime.today().strftime('%Y%m%d%H%M%S')
                                    #sql = "insert into ext_scoring_note (issuer, dt_rating, rating, refindividu, createur) values (:1, to_date(:2, 'yyyymmddhh24miss'), :3, :4, :5)"
                                    #c1 = conn.cursor()
                                    #c1.execute(sql, [val1, val2, rating, personalReference, 'CS_DAILY'])
                                    #c1.close()

                                    params = {}
                                    params['token'] = IMX_AuthToken
                                    params['refIndividual'] = score_refindividu
                                    params['rating'] = rating
                                    params['rating_issuer'] = 'CS'		   
                                    params['rating_date'] = datetime.today().strftime('%Y-%m-%d')
                                    l_return = m_ext_rating.m_api_post_ext_rating(json.dumps(params))
																		
                                    handle.write(str(portfolioId) + '|' + str(companyId) + '|' + score_refindividu + '|' + rating + " - Insert\n")

                                else:
                                    handle.write(str(portfolioId) + '|' + str(companyId) + '|' + score_refindividu + '|' + old_rating + " - No update\n")

            else:
                handle.write(str(portfolioId) + '|' + str(companyId) + '|' + str(response.status_code) + "\n")

            v_count += 1
            if v_count > v_limit:
                #token = authenticate(username, password)
                conn.commit()
                v_count = 0

            # end loop

        sql = """update cit_ksh_param set effect_from_dat = to_timestamp(:1, 'yyyy-mm-dd"T"hh24:mi:ss"Z"') + INTERVAL '1' SECOND where script = 'CS_DAILY'"""
        c1 = conn.cursor()
        c1.execute(sql, [eventDate])
        print(c1.rowcount, 'row(s) updated (cit_ksh_param)')
        conn.commit()
        c1.close()

    handle.close()

# ----------------------------------------------------------------------------------------------------------------------


if __name__ == "__main__":
    main()
    conn.close()
