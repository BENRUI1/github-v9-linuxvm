import os
import logging

from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail

class Mail_Handling:

   def send_email_sg(self, the_from_mail, the_to_mail, the_subject, the_content):
      api_sendgrid_key = os.getenv('SENDGRID_API_KEY')
      #logging.debug("send_email_sendgrid API KEY: " + str(api_sendgrid_key))
      logging.debug("send_email_sendgrid the_from_mail: " + str(the_from_mail))
      logging.debug("send_email_sendgrid the_to_mail: " + str(the_to_mail))
      #logging.debug("send_email_sendgrid the_subject: " + str(the_subject))
      #logging.debug("send_email_sendgrid the_content: " + str(the_content))
      message = Mail(
                     from_email=the_from_mail,
                     to_emails=the_to_mail,
                     subject=the_subject,
                     html_content=the_content
                    )

      try:
         sg = SendGridAPIClient(api_sendgrid_key)
         response = sg.send(message)
         logging.info("Return of send_email_sendgrid Send Mail status code: " + str(response.status_code))
         logging.debug("Return of send_email_sendgrid: Send Mail body: "  + str(response.body))
         logging.debug("Return of send_email_sendgrid:  Send Mail header: "  + str(response.headers))
        
         return str(response.status_code)
      except:
         logging.error('send_email_sg: cannot call SendGridAPIClient')
         return str(401)




