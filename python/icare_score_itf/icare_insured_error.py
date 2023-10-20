import re

import cx_Oracle
import os
import configparser
import platform
import sys
import requests
import json
import logging
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(message)s')

# import email
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
if platform.system() == 'Windows':
    import win32com.client as win32
else:
    from subprocess import Popen, PIPE

# setting path
sys.path.append(os.path.join(os.getcwd(), "python"))
sys.path.append(os.path.join(os.getcwd(), "shared"))

# importing
from tools.cit_connect import CIT_connect as cit_connect
from tools.cit_functions import CIT_functions as cit_func

conn = cit_connect.get_connection('dbCIT')
c1 = conn.cursor()


def clob_to_str(clob):
    if clob is None:
        return ''
    else:
        return ''.join(clob.read())


def main():
    cuss = cit_func.sql_select(conn, 'all', """select
            cit.*,
            regexp_replace(cit.cusHmo,'HMO_(.*)','HD\\1') as "cusHMO_ed",
            nvl(pays.abrev,cit.cusCountry) as "cusCountry_ed",
            trim(sales.nom || ' ' || sales.prenom) as "salesMgr"
        from
            cit_intg_insured cit,
            v_domaine pays,
            g_individu       sales
        where 
            (nvl(cit.caed,'N') like 'E%' or nvl(cit.accounted,'N') like 'E%')
            and pays.type(+) = 'pays' and pays.abrev3(+) = cit.cusCountry
            and sales.refindividu(+) = cit.cusSalesMgr
        order by cit.cushmo""", assoc=1)

    idc = 0
    sw_eof = 0
    nmb_cus = len(cuss)
    print(nmb_cus)
    if nmb_cus > 0:
        cus = cuss[idc]
    else:
        sw_eof = 1
    c1 = conn.cursor()

    while sw_eof == 0:
        cusHmo = cus['cusHMO_ed']
        sw_envoi = 0

        msg = MIMEMultipart("alternative")
        msg["From"] = "noreply@atradiuscollections.com"
        msg["Subject"] = 'Icare-Score interface (Insured) | Errors (' + environment + ')'
        rows = cit_func.sql_select(conn, 'all',
                          "select ecran, valeur from v_domaine where type='CIT_EMAIL_ADDRESSEES' and abrev='ICARE' and champ=:1",
                          [cusHmo])
        for row in rows:
            msg[row[0]] = row[1]
        html = """<html>
    <head>
        <meta charset=utf-8" />
        <title>Atradius Collections</title>
        <style>
        body {font: 12px Arial}
        h2 {font: bold}
        table {margin-left: 30px; border-collapse: collapse; font: Calibri; background-colour: #c0c0c0}
        caption {background-color: white; border: 0; caption-side: bottom; font: bold 10px}
        th {background-color: #c0c0c0; color: white; padding: 6px 4px; text-align: center}
        td {border: 1px solid #95b3d7;vertical-align: top; padding: 4px }
        </style>
    </head>
    <body>
        <p>Hello, </p>
        <p>Please find below list of errors detected during Icare-Score Integration process for Insured Customers:</p>
        <table>
        <tr><th>CLEAR #</th><th>Cust #</th><th>Name</th><th>Country</th><th>HMO</th><th>Sales Mgr</th><th style="width: 768px;">Issue</th></tr>"""
        while sw_eof == 0 and cus['cusHMO_ed'] == cusHmo:
            if (cus['CAED'] or 'N').startswith('E') and (cus['CAED_COUNT'] or 0) < 2:
                if cus['CAED_ERROR'] is None:
                    sw_envoi = 1
                    html += '<tr><td>' + cus['KEYCLEARNUMBER'] + '</td><td>' + cus['CUSREF'] + '</td>' + \
                            '<td>' + cus['CUSNAME'] + '</td><td>' + cus['cusCountry_ed'] + '</td>' + \
                            '<td>' + cus['cusHMO_ed'] + '</td><td>' + (cus['salesMgr'] or '&nbsp;') + '</td>' + \
                            '<td>Problem at selection: ' + (cus['CAED_FAULT'] or '') + '</td></tr>'
                elif cus['CAED_ERROR'] != 'CON':
                    sw_envoi = 1
                    caedFaultString = clob_to_str(cus['CAED_FAULT_STRING'])
                    if caedFaultString is not None:
                        caedFaultString = caedFaultString.replace(', Owner not found, Missing Sales Mgr', ', Missing Sales Mgr')
                    html += '<tr><td>' + (cus['KEYCLEARNUMBER'] or '&nbsp;') + '</td><td>' + cus['CUSREF'] + '</td>' + \
                            '<td>' + cus['CUSNAME'] + '</td><td>' + cus['cusCountry_ed'] + '</td>' + \
                            '<td>' + cus['cusHMO_ed'] + '</td><td>' + (cus['salesMgr'] or '&nbsp;') + '</td>' + \
                            '<td>Problem at selection: ' + (caedFaultString or cus['CAED_ERROR']) + '</td></tr>'
            elif (cus['ACCOUNTED'] or 'N').startswith('E'):
                sw_envoi = 1
                accountedFaultString = clob_to_str(cus['ACCOUNTED_FAULT_STRING'])
                if cus['ACCOUNTED_ERROR'] is None:
                    html += '<tr><td>' + cus['KEYCLEARNUMBER'] + '</td><td>' + cus['CUSREF'] + '</td>' + \
                            '<td>' + cus['CUSNAME'] + '</td><td>' + cus['cusCountry_ed'] + '</td>' + \
                            '<td>' + cus['cusHMO_ed'] + '</td><td>' + (cus['salesMgr'] or '&nbsp;') + '</td>' + \
                            '<td>Problem during process: ' + accountedFaultString + ' (' + (cus['ACCOUNTED_FAULT'] or '') + ')</td></tr>'
                else:
                    html += '<tr><td>' + cus['KEYCLEARNUMBER'] + '</td><td>' + cus['CUSREF'] + '</td>' + \
                            '<td>' + cus['CUSNAME'] + '</td><td>' + cus['cusCountry_ed'] + '</td>' + \
                            '<td>' + cus['cusHMO_ed'] + '</td><td>' + (cus['salesMgr'] or '&nbsp;') + '</td>' + \
                            '<td>Problem during process: ' + accountedFaultString + '</td></tr>'

            c1.execute("""update cit_intg_insured set 
                    caed = decode(caed, 'E', 'F', 'E2', 'N', caed),
                    accounted = decode(accounted, 'E', 'F', accounted)
                where cusAccount = :1""", [cus['CUSACCOUNT']])

            idc += 1
            if idc <= nmb_cus - 1:
                cus = cuss[idc]
            else:
                sw_eof = 1

        html += """</table>
        <p>This mail is sent automatically.</p>
        <p>Please do not answer to this mail. However do not hesitate to contact <a href="mailto:support.collections@atradius.com">Collections Support</a> for any question.</p>
        <p>Regards</p>
        </font><br><br><img src="https://www.atradius.com/ATRADIUS/help/gif/Atradius_Collections.gif" /></body></html>"""
        msg.attach(MIMEText(html, "html"))
        if sw_envoi == 0:
            print(cusHmo + ':', 'No new error => no mail')
        else:
            print(cusHmo + ':', 'Mail sent to', msg['To'])
            if platform.system() == 'Windows':
                outlook = win32.Dispatch('outlook.application')
                mailTo = outlook.GetNamespace("MAPI").GetDefaultFolder("6").FolderPath
                mailTo = (re.findall('\\\\\\\\(.*)\\\\', mailTo))[0]
                mail = outlook.CreateItem(0)
                mail.To = mailTo
                mail.Subject = msg['Subject']
                mail.HTMLBody = html
                mail.Send()
            else:
                p = Popen(["/usr/sbin/sendmail", "-t"], stdin=PIPE)
                p.communicate(msg.as_string().encode())
                print('Mail Icare-Score Interface sent to', msg['To'])

    conn.commit()


# ----------------------------------------------------------------------------------------------------------------------
if __name__ == "__main__":
    main()
    conn.close()
