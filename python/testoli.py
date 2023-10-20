# Module module_case
# Functions:
#  - m_api_get_staff (BEODEL1)
#  - m_api_search_staff (BEODEL1)
#
import datetime
import os
import requests
import json
import logging
import sys

xAuthToken='f7a4a868-2cdd-4d01-bef3-81a42a745bed'
url='https://acp-release-intra.codix-imx.solutions:8122/imx_be/svc/staff/searches'
criteria = { 'filterRefUser': 92 }
headers = {'Content-Type': 'application/json', 'x-auth-token': xAuthToken}
print(headers)
response = requests.put(url, headers=headers, data=json.dumps(criteria))
print(response.text)
# response = requests.put(url, headers=headers)

logging.info('Response: ' + str(response))
logging.info(('Status_code: ' + str(response.status_code )))
        