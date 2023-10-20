#!/usr/bin/ksh
#################################################################
# sending of an email with file attached 
# author : BEYCNE1
# date : 28/09/2020
#################################################################
appl=score; export appl
scriptName=script_proactive_comm_mail; export scriptName
nbrStep=1; export nbrStep
#
#Logs parameters
caseReference=$1; export caseReference
clientName=$2; export clientName
clientEmail=$3; export clientEmail
clientLanguage=$4; export clientLanguage
debtorName=$5; export debtorName
collectorName=$6; export collectorName
collectorEmail=$7; export collectorEmail
freeComment=$8; export freeComment
claimsReference=$9; export claimsReference
commType=${10}; export commType
countryUnit=${11}; export countryUnit
labelInfo=${12}; export labelInfo

##########################################################

. /home/oracle/bin/scriptBeginning

DTT=`date +%Y%m%d`

##########################################################
#
# Define of all steps
#
#
echo $1
echo $2
echo $3
echo $4
echo $5
echo $6
echo $7
echo $8
echo $9
echo $10
echo $11
#TO=$clientEmail
TO="yvan.decneef@atradius.com"
echo 'date = ' ${DTT}
echo '____________________________________ '
#
#
function step1 {
#
echo ' '
echo 'step 1 : creation of html mail and send it'
echo ' '

# For the full text, please check the documentation on the project sharefolder
# Remark the fact that for some languages, the SUBJECT field needs some additional encoding to deal with special characters
OPTOUT_MAIL="Client_Relations_UK@atradius.com"

case $countryUnit in
	AUS)
		OPTOUT_MAIL="Clientrelations.apac@atradius.com"
		;;
	ARE)
		OPTOUT_MAIL="Clientrelations.apac@atradius.com"
		;;
	CAN)	
		OPTOUT_MAIL="Collections.Canada@atradius.com" 
		;;
	IND)
		OPTOUT_MAIL="Clientrelations.apac@atradius.com"
		;;
	GBR)
		OPTOUT_MAIL="Client_Relations_UK@atradius.com"
		;;
	POL)
		OPTOUT_MAIL="RELATIONS_PL.CLIENT_@atradius.com"		
		;;
	CZE)
		OPTOUT_MAIL="inkaso.cz@atradius.com"		
		;;
	DEU)
		OPTOUT_MAIL="client_relations_de@atradius.com"		
		;;
	DNK)
		if [ "${clientLanguage}" = "SV" ];
		then
			OPTOUT_MAIL="Client_Relations_SE@atradius.com"
		else
			OPTOUT_MAIL="client_relations_dk@atradius.com"
		fi	
		;;
	FRA)
		OPTOUT_MAIL="ClientRelationsFR@atradius.com"
		;;
	ITA)
		OPTOUT_MAIL="Client_Relations_IT@atradius.com"
		;;
	HUN)
		OPTOUT_MAIL="Collectionshun@atradius.com"
		;;
	USA)
		OPTOUT_MAIL="ClientRelations-USA@atradius.com"
		;;
	NLD)
		OPTOUT_MAIL="client_relations_nl@atradius.com"
		;;
	BEL)
		OPTOUT_MAIL="ClientrelationsBE@atradius.com"
		;;
	SGP)
		OPTOUT_MAIL="Clientrelations.apac@atradius.com"
		;;
	HKG)
		OPTOUT_MAIL="clientrelations.apac@atradius.com"
		;;
	TUR)
		OPTOUT_MAIL="gulcan.gursu@atradius.com"
		;;
	ROM)
		OPTOUT_MAIL="RELATIONS_PL.CLIENT_@atradius.com"
		;;
	ESP)
		OPTOUT_MAIL="Customer.SERVICESPAIN@atradius.com"
		;;			
	PRT)
		OPTOUT_MAIL="clientes@atradius.com"
		;;		
esac

BCC="yvan.decneef@atradius.com"

case $clientLanguage in
	AN)
		if [ "${claimsReference}" = " " ];
		then
			SUBJECT="Update on Atradius Collections case reference ""$caseReference"" - debtor ""$debtorName"

			case $countryUnit in
				USA)
					PHRASE_LINK="For more information, please log into your account https://atradiuscollections.com/us/login-services."
					;;
				SGP)
					PHRASE_LINK="For more information, please log into your account https://atradiuscollections.com/sg/login-services."
					;;				
				HKG)
					PHRASE_LINK="You can find more information regarding our activity including access to all the collector notes by logging into your account via https://atradiuscollections.com/hk/login-services"
					;;
				AUS)
					PHRASE_LINK="You can find more information regarding our activity including access to all the collector notes by logging into your account via https://atradiuscollections.com/au/login-services"
					;;	
				ARE)
					PHRASE_LINK="You can find more information regarding our activity including access to all the collector notes by logging into your account via https://www.atradius.com/ATRADIUS/login.jsp"
					;;
				IND)
					PHRASE_LINK="You can find more information regarding our activity including access to all the collector notes by logging into your account via https://atradiuscollections.com/in/login"
					;;
				CAN)
					PHRASE_LINK="For more information, please log into your account https://atradiuscollections.com/ca-en/login-services."
					;;	
				IRL)	
					PHRASE_LINK="For more information, please log into your account https://atradiuscollections.com/ie/login-services."
					;;
				*)
					PHRASE_LINK="For more information, please log into your account https://atradiuscollections.com/uk/login-services."
					;;					
			esac			
		else
			SUBJECT="Update on Atradius Collections case reference ""$caseReference"" - claims reference ""$claimsReference"" - debtor ""$debtorName"
			PHRASE_LINK="You can find more information regarding our activity including access to all the collector notes by logging into Atrium via https://atrium.atradius.com"
		fi
		
		GREETINGDEAR="Dear customer," 
		PHRASE_REPLY="This mail is sent automatically ; please do not reply."
		GREETING="Kind regards,"
		PHRASE_DEVELOPMENT="There has been a development on the above mentioned collection case that we would like to make you aware of."
		PHRASE_OPTOUT="If you would like to stop receiving these messages please e-mail ""$OPTOUT_MAIL"
		
		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="We have received a call from your debtor, and details of the conversation are as follows :"
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="We have been in contact with your debtor, and details of this conversation are as follows :"
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="Our collector has made the following summary in your case :"
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="We have had several telephone conversations with your debtor. Details of the conversation are as follows :"		
		else
			PHRASE_COMMTYPE="${labelInfo}." 
		fi
		;;
		
	NO|CE-EN|US)
		if [ "${claimsReference}" = " " ];
		then
			SUBJECT="Update on Atradius Collections case reference ""$caseReference"" - debtor ""$debtorName"
			
			case $clientLanguage in
				
				CE-EN)
					PHRASE_LINK="You can find more information regarding our activity including access to all the collector notes by logging into your account via https://atradiuscollections.com/ca-en/login-services"
					;;

				NO) 
					PHRASE_LINK="For more information, please log into your account https://atradiuscollections.com/uk/login-services."
					;;
					
				US)	
					PHRASE_LINK="You can find more information regarding our activity including access to all the collector notes by logging into your account via https://atradiuscollections.com/us/login-services"
					;;
			esac		
		else
			SUBJECT="Update on Atradius Collections case reference ""$caseReference"" - claims reference ""$claimsReference"" - debtor ""$debtorName"
			PHRASE_LINK="You can find more information regarding our activity including access to all the collector notes by logging into Atrium via https://atrium.atradius.com"
		fi
		
		GREETINGDEAR="Dear customer," 
		PHRASE_REPLY="This mail is sent automatically ; please do not reply."
		GREETING="Kind regards,"
		PHRASE_DEVELOPMENT="There has been a development on the above mentioned collection case that we would like to make you aware of."
		PHRASE_OPTOUT="If you would like to stop receiving these messages please e-mail  ""$OPTOUT_MAIL"
		PHRASE_LINK="You can find more information regarding our activity including access to all the collector notes by logging into Atrium via https://atrium.atradius.com"
		
		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="We have received a call from your debtor, and details of the conversation are as follows :"
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="We have been in contact with your debtor, and details of this conversation are as follows :"
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="Our collector has made the following summary in your case :"
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="We have had several telephone conversations with your debtor. Details of the conversation are as follows :"
		else
			PHRASE_COMMTYPE="${labelInfo}."		
		fi
		;;		

		
	TR)
		SUBJECT="Atradius Collections referanslı dosyada güncelleme ""$caseReference"" - borçlu ""$debtorName"
		GREETINGDEAR="Sayın yetkili," 
		PHRASE_REPLY="Bu bir otomatik email, lütfen cevaplamayınız."
		GREETING="Saygılarımla,"
		PHRASE_DEVELOPMENT="Yukarıda bahsi geçen tahsilat dosyası ile ilgili sizi haberdar etmek istediğimiz bir gelişme oldu."
		PHRASE_OPTOUT="Bu mesajları almak istemiyorsanız lütfen ""$OPTOUT_MAIL"" mail adresi ile bize ulaşın."
		PHRASE_LINK="Collect@Net'a https://www.atradius.com/ATRADIUS/login.jsp ile giriş yaparak, tahsilat uzmanı kayıtları dahil olmak üzere tüm aktivitelere ulaşabilirsiniz."
		
		if [ "${commType}" = "CALLFROM" ];
		then 
			PHRASE_COMMTYPE="Borçludan bir telefon araması aldık ve detayları aşağıdaki gibidir:"
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="Borçlu ile kontak halindeyiz ve görüşme detayları aşağıdaki gibidir:"
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="Tahsilat uzmanı dosyanın özetini paylaştı:"
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="Borçlu ile birkaç kez telefon görüşmesi gerçekleştirdik. Görüşme detaylarını aşağıda bulabilirsiniz:"	
		else
			PHRASE_COMMTYPE="${labelInfo}."		
		fi
		;;		

		
	FI)
		if [ "${claimsReference}" = " " ];
		then
			SUBJECT="Päivitys Atradius-kokoelmien tapausviitteestä ""$caseReference"" - Päivitys velallisesta ""$debtorName"
			PHRASE_LINK="Saadaksenne lisätietoja asiaa koskien pyydämme teitä kirjautumaan tilillenne https://atradiuscollections.com/fi/kirjaudu-sisään"
		else
			SUBJECT="Päivitys Atradius-kokoelmien tapausviitteestä ""$caseReference"" - Päivitys Atradius-kokoelmien vaatimusviitteestä ""$claimsReference"" - Päivitys velallisesta ""$debtorName"
			PHRASE_LINK="Saadaksenne lisätietoja asiaa koskien pyydämme teitä kirjautumaan tilillenne https://atrium.atradius.com/"
		fi
	
		GREETINGDEAR="Hyvä asiakas,"
		PHRASE_REPLY="Tämä sähköpostiviesti on lähetetty automaattisesti; älkää vastatko siihen."
		GREETING="Ystävällisin terveisin,"
		PHRASE_DEVELOPMENT="Yllä mainitussa perintä tapauksessanne on tapahtunut päivitys, josta haluamme ilmoittaa teille."
		PHRASE_OPTOUT="If you would like to stop receiving these messages please e-mail ""$OPTOUT_MAIL"
		
		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="Olemme vastaanottaneet puhelun velalliseltanne ja lisätietoja keskustelusta löydätte meidän asiakasportaalistamme."
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="Olemme olleet yhteydessä velallisenne kanssa ja yksityiskohdat keskustelusta on kirjattu asiakasportaaliimme."
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="Meidä tapauskäsittelijämme on tehnyt yhteenvedon tapauksenne viimeisimmästä statuksesta."
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="Meidä tapauskäsittelijämme on tehnyt yhteenvedon tapauksenne viimeisimmästä statuksesta."
		else
			PHRASE_COMMTYPE="${labelInfo}."		
		fi
		;;		
				
	SV)
		if [ "${claimsReference}" = " " ];
		then
			SUBJECT="Uppdatering i Atradius Collections referensnumret ""$caseReference"" - ""=?UTF-8?B?Z8OkbGRlbsOkcg==?= ""$debtorName"
			PHRASE_LINK="För mer information, vänligen logga in via https://atradiuscollections.com/se/logga-in"
		else
			SUBJECT="Uppdatering i Atradius Collections referensnumret ""$caseReference"" - ""=?UTF-8?B?Z8OkbGRlbsOkcg==?= ""$debtorName"
			PHRASE_LINK="Ni kan hitta mer information om vår aktivitet genom att logga in på Atrium: https://atrium.atradius.com/"
		fi

		GREETINGDEAR="Hej," 
		PHRASE_REPLY="Detta mail skickas per automatik och kan inte besvaras."
		GREETING="Vänliga hälsningar,"
		PHRASE_DEVELOPMENT="Det har kommit en ny uppdatering i ovanstående inkassoärende som vi gärna vill uppmärksamma."
        PHRASE_OPTOUT="Om ni inte är intresserade av att ta emot dessa meddelanden, skicka ett mail till  ""$OPTOUT_MAIL"

		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="Vi har mottagit ett samtal från er gäldenär, vänligen se detaljer från konversationen nedan:"
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="Vi har mottagit ett samtal från er gäldenär, vänligen se detaljer från konversationen nedan:"
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="Vår handläggare har gjort följande summering av ert ärende:"
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="Vi har haft ett flertal telefonsamtal med er gäldenär, vänligen se detaljerna från konversationerna nedan."
		else
			PHRASE_COMMTYPE="${labelInfo}."		
		fi
		;;			

	DA)
		if [ "${claimsReference}" = " " ];
		then
			SUBJECT="Opdatering ""=?UTF-8?B?cMOl?="" Atradius Collection sagen reference nr. ""$caseReference"" - debitor ""$debtorName"
			PHRASE_LINK="For mere information, log venligst ind på https://atradiuscollections.com/dk/login."
		else
			SUBJECT="Opdatering ""=?UTF-8?B?cMOl?="" Atradius Collections reference nr. ""$caseReference"" - Opdatering ""=?UTF-8?B?cMOl?="" skades nr. ""$claimsReference"" - debitor ""$debtorName"
			PHRASE_LINK="Du kan finde flere informationer omkring vores inkassoaktivitet, samt en oversigt over alle de handlinger der er foretaget af sagsbehandleren på jeres sag, ved at logge på vores online kundeportal Atrium https://atrium.atradius.com"
		fi	
	
		GREETINGDEAR="Kære Kunde," 
		PHRASE_REPLY="Denne mail sendes automatisk og kan ikke besvares."
		GREETING="Venlig hilsen,"
		PHRASE_DEVELOPMENT="Der er foretaget en opdatering i ovennævnte inkassosag, som vi gerne vil gøre dig opmærksom på."
		PHRASE_OPTOUT="Ønsker du ikke at modtage disse opdateringer, send da en mail til ""$OPTOUT_MAIL"
		
		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="Vi har modtaget en henvendelse fra jeres debitor. Baseret på denne samtale kan vi berette følgende:"
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="Vi har rettet henvendelse til jeres debitor. Baseret på denne samtale kan vi berette følgende:"
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="Vores sagsbehandler har lavet den følgende opsummering af jeres inkassosag:"
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="Vi har haft flere samtaler med jeres debitor. Baseret på disse samtaler kan vi berette følgende:"	
		else	
			PHRASE_COMMTYPE="${labelInfo}."		
		fi
		;;	
	
	
	NL)
		if [ "${claimsReference}" = " " ];
		then
			SUBJECT="Update over Atradius Collections dossiernummer ""$caseReference"" - debiteur ""$debtorName"
			PHRASE_LINK="U kunt onze incassoactiviteiten volgen en alle notities van de zaakbehandelaar inzien door in te loggen via ons online klantenportaal: https://atradiuscollections.com/nl/login"
		else
			SUBJECT="Update over Atradius Collections dossiernummer ""$caseReference"" - claims referentie ""$claimsReference"" - debiteur ""$debtorName"
			PHRASE_LINK="U kunt onze incassoactiviteiten volgen en alle notities van de zaakbehandelaar inzien door in te loggen via ons online klantenportaal: https://atrium.atradius.com"
		fi	
	
		GREETINGDEAR="Beste klant," 
		PHRASE_REPLY="Deze e-mail is automatisch verstuurd; u kunt deze niet beantwoorden."
		GREETING="Met vriendelijke groet,"
		PHRASE_DEVELOPMENT="Wij stellen u graag op de hoogte dat er een ontwikkeling heeft plaatsgevonden in bovengenoemde incassozaak."
		PHRASE_OPTOUT="Indien u deze berichtgeving niet langer wenst te ontvangen, stuur dan een e-mail naar: ""$OPTOUT_MAIL"
		
		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="Uw debiteur heeft telefonisch contact met ons opgenomen. Van dit gesprek is de volgende aantekening gemaakt in uw dossier: "
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="Wij hebben contact opgenomen met uw debiteur. Van dit gesprek is de volgende aantekening gemaakt in uw dossier: "
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="Onze zaakbehandelaar heeft de volgende korte samenvatting gemaakt van uw incassodossier: "
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="Wij hebben meerdere telefoongesprekken gevoerd met uw debiteur. Van deze gesprekken zijn de volgende aantekeningen gemaakt in uw dossier: " 
		else
			PHRASE_COMMTYPE="${labelInfo}."		
		fi
		;;

	FL)
		if [ "${claimsReference}" = " " ];
		then
			SUBJECT="Update over Atradius Collections dossiernummer ""$caseReference"" - debiteur ""$debtorName"
			PHRASE_LINK="U kunt meer informatie vinden over onze activiteit, inclusief toegang tot alle Collector notities, door in te loggen op https://atradiuscollections.com/be-nl/login"
		else
			SUBJECT="Update over Atradius Collections dossiernummer ""$caseReference"" - claims referentie ""$claimsReference"" - debiteur ""$debtorName"
			PHRASE_LINK="U kunt meer informatie vinden over onze activiteit, inclusief toegang tot alle Collector notities, door in te loggen op Atrium, https://atrium.atradius.com/"
		fi		
	
		GREETINGDEAR="Beste klant," 
		PHRASE_REPLY="Deze e-mail is automatisch verstuurd; u kunt deze niet beantwoorden."
		GREETING="Met vriendelijke groet,"
		PHRASE_DEVELOPMENT="Wij stellen u graag op de hoogte dat er een ontwikkeling heeft plaatsgevonden in bovengenoemde incassozaak."
		PHRASE_OPTOUT="Indien u deze berichten niet meer wenst te ontvangen, kunt u een e-mail sturen naar ""$OPTOUT_MAIL"

		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="Uw debiteur heeft telefonisch contact met ons opgenomen. De details hiervan zijn als volgt: "
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="Wij hebben telefonisch contact gehad met uw debiteur en de details van het gesprek zijn als volgt: " 
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="Onze Collector heeft in uw zaak de volgende samenvatting gemaakt: "
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="We hebben verschillende telefoongesprekken gehad met uw debiteur. De details van het gesprek zijn als volgt: "
		else
			PHRASE_COMMTYPE="${labelInfo}."		
		fi
		;;
		
	MX) 
		SUBJECT="=?UTF-8?B?QWN0dWFsaXphY2nDs24=?="" sobre la referencia de caso de Atradius Collections ""$caseReference"" - deudor ""$debtorName"
		GREETINGDEAR="Estimado Cliente," 
		PHRASE_REPLY="Este correo electrónico es enviado automáticamente; por favor no responda."
		GREETING="Cordiales Saludos,"
		PHRASE_DEVELOPMENT="Ha habido un avance en el caso de cobranza mencionado anteriormente del cual nos gustaría informarle."
		PHRASE_LINK="Para más información, por favor ingrese a su cuenta https://atradiuscollections.com/mx/login."	
		PHRASE_OPTOUT="Si desea dejar de recibir estos mensajes, envíe un correo electrónico a ""$OPTOUT_MAIL"

		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="Hemos recibido una llamada de su deudor, y los detalles de la conversación son los siguientes:"
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="Hemos realizado una llamada a su deudor, y los detalles de la conversación son los siguientes:"
		elif [ "${commType}" = "SUMMARY" ];
		then	
			PHRASE_COMMTYPE="Nuestro administrador del caso ha hecho el siguiente resumen de gestión:"
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="Hemos tenido varias conversaciones telefónicas con su deudor. Los detalles son los siguientes:"
		else	
			PHRASE_COMMTYPE="${labelInfo}."		
		fi
		;;		
		
	FR|CF)
		if [ "${claimsReference}" = " " ];
		then
			SUBJECT="Mise à jour du dossier Atradius Collections référencé ""$caseReference"" - débiteur ""$debtorName"

			case $countryUnit in
				FRA)
					PHRASE_LINK="Pour en savoir plus, connectez-vous à votre compte https://atradiuscollections.com/fr/connexion"
					BCC="ClientRelationsFR@atradius.com,yvan.decneef@atradius.com,valerie.tassin@atradius.com"
					;;

				BEL)
					PHRASE_LINK="Pour en savoir plus, connectez-vous à votre compte https://atradiuscollections.com/be-fr/connexion"
					BCC="yvan.decneef@atradius.com,ClientRelationsBE@atradius.com,vincent.rigaux@atradius.com,stephane.coppois@atradius.com,valerie.tassin@atradius.com"
					;;

				CAN)
					PHRASE_LINK="Pour en savoir plus, connectez-vous à votre compte https://atradiuscollections.com/ca-fr/connexion"
					BCC="yvan.decneef@atradius.com,"
					;;
			esac
		else
			SUBJECT="Mise à jour du dossier Atradius Collections référencé ""$caseReference"" – référence sinistre ""$claimsReference"" – débiteur ""$debtorName"
			PHRASE_LINK="Retrouvez plus d'informations liées à nos actions de recouvrement ainsi que les observations de nos gestionnaires en accédant à votre compte sur Atrium, https://atrium.atradius.com/"			
		fi			
		
		GREETINGDEAR="Cher client," 
		PHRASE_REPLY="Cet e-mail est envoyé automatiquement ; ne pas y répondre."
		GREETING="Cordialement,"
		PHRASE_DEVELOPMENT="Il y a eu une évolution dans le dossier de recouvrement mentionné dont nous aimerions vous informer."
		PHRASE_OPTOUT="Si vous ne voulez plus recevoir ces messages, merci d'envoyer un mail à ""$OPTOUT_MAIL"
		
		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="Nous avons reçu un appel de votre client. Voici un résumé de l'échange: "
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="Nous avons réussi à joindre votre client. Voici un résumé de nos échanges: "
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="Notre gestionnaire de recouvrement a dressé un point sur la situation de votre dossier: "
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="Nous avons eu plusieurs contacts téléphoniques avec votre client. Voici le contenu des échanges:"
		else	
			PHRASE_COMMTYPE="${labelInfo}."		
		fi
		;;		

	AL)	
		if [ "${claimsReference}" = " " ];
		then
			SUBJECT="Update zur Fallreferenz von Atradius Collections ""$caseReference"" - Schuldner ""$debtorName"
			PHRASE_LINK="Für weitere informationen melden Sie sich bitte im Kundenportal an - https://atradiuscollections.com/de/login"
		else
			SUBJECT="Update zur Fallreferenz von Atradius Collections ""$caseReference"" - Schadenfallnummer ""$claimsReference"" - Schuldner ""$debtorName"
			PHRASE_LINK="Weitere Einzelheiten zu diesem Vorgang und unseren Aktivitäten sind in unserem Kundenportal hinterlegt. Hierfür melden Sie sich bitte in Atrium unter https://atrium.atradius.com/ an."
		fi		
	
		GREETINGDEAR="Lieber Kunde," 
		PHRASE_REPLY="Diese Mail wurde automatisch verschickt, bitte antworten Sie nicht auf diese E-Mail."
		GREETING="Mit freundlichen Grüßen,"
		PHRASE_DEVELOPMENT="es gibt eine Entwicklung zu dem o.g. Inkassofall, auf die wir Sie gerne aufmerksam machen möchten."
		PHRASE_OPTOUT="Wenn Sie diese Nachrichten nicht mehr erhalten möchten, senden Sie bitte eine E-Mail an ""$OPTOUT_MAIL"
		
		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="Wir erhielten einen Anruf vom Schuldner. Die Einzelheiten des Gesprächs sind wie folgt: "
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="Wir haben Ihren Schuldner kontaktiert. Die Einzelheiten des Gesprächs sind wie folgt: "
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="Unser Collector hat folgende Zusammenfassung des aktuellen Sachstandes erstellt: "
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="Wir haben mehrere Telefonate mit Ihrem Schuldner geführt. Die Einzelheiten des Gesprächs sind wie folgt:" 
		else
			PHRASE_COMMTYPE="${labelInfo}."					
		fi
		;;	
		
	IT)
		if [ "${claimsReference}" = " " ];
		then
			SUBJECT="Aggiornamento sul caso di recupero Atradius Collections, riferimento ""$caseReference"" - debitore ""$debtorName"
			PHRASE_LINK="Per ulteriori informazioni, Vi preghiamo di accedere alla Vostra pagina : https://atradiuscollections.com/it/servizi-online"
		else
			SUBJECT="Aggiornamento sul caso di recupero Atradius Collections, riferimento ""$caseReference"" – numero sinistro ""$claimsReference"" – debitore ""$debtorName"
			PHRASE_LINK="Ulteriori informazioni sulla nostra attività, incluso l'accesso a tutte le note del collector, sono disponibili accedendo ad Atrium, https://atrium.atradius.com/"      
		fi			
	
		GREETINGDEAR="Gentile Cliente," 
		PHRASE_REPLY="Questa e-mail è stata generata automaticamente dal nostro sistema; si prega di non rispondere."
		GREETING="Distini saluti,"
		PHRASE_DEVELOPMENT="Siamo lieti di informarvi che è disponibile un aggiornamento nel caso di recupero sopra menzionato."
		PHRASE_OPTOUT="Se si desidera interrompere la ricezione di questi messaggi, si prega di inviare un'e-mail a ""$OPTOUT_MAIL"
	
		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="Abbiamo ricevuto una chiamata dal Vostro debitore e i dettagli della conversazione sono i seguenti: "
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="Abbiamo effettuato una chiamata al debitore e i dettagli della conversazione sono i seguenti: "
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="lI nostro collector  ha predisposto il seguente riepilogo del caso: "
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="Abbiamo avuto diverse conversazioni telefoniche con il tuo debitore. I dettagli sono i seguenti: "
		else	
			PHRASE_COMMTYPE="${labelInfo}."		
		fi
		;;
	
	HU)	
		if [ "${claimsReference}" = " " ];
		then
			SUBJECT="=?UTF-8?B?RmVqbGVtw6lueWVr?="" az Atradius Collections ""$caseReference"" - Az ""=?UTF-8?B?YWTDs3M=?="" ""$debtorName"
			PHRASE_LINK="További információért kérjük, jelentkezzen be fiókjába https://atradiuscollections.com/hu/belépés"
		else
			SUBJECT="=?UTF-8?B?RmVqbGVtw6lueWVr?="" az Atradius Collections ""$caseReference"" számú ügyben, ""=?UTF-8?B?QWTDs3M=?="" ""$debtorName"", Károsztályi hivatkozási szám: ""$claimsReference" 
			PHRASE_LINK="További információért kérjük, jelentkezzen be fiókjába https://atradiuscollections.com/hu/belépés"
		fi		
		
		GREETINGDEAR="Kedves Ügyfelünk,"
		PHRASE_REPLY="Ez egy automatikusan küldött üzenet, kérjük, ne válaszoljon."
		GREETING="Üdvözlettel,"
		PHRASE_DEVELOPMENT="Tájékoztatjuk, hogy a fenti számú behajtási ügyben új fejlemények elérhetőek."
		PHRASE_OPTOUT="Amennyiben nem szeretné a továbbiakban ezeket az üzeneteket kapni kérjük, kérjük, jelezze a ""$OPTOUT_MAIL"" email címen."
		BCC="yvan.decneef@atradius.com,beatrix.pianovszky@atradius.com,Andrea.HORTOLANYI-BORUZS@atradius.com,Kata.SEBESTYEN@atradius.com"
		
		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="Az adóstól hívás érkezett. A beszélgetés részletei a következők:"
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="Kapcsolatba léptünk az adóssal, az egyeztetés részletei a következők:"
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="Behajtási szakértőnk összefoglalót készített az ügy legfrissebb fejleményeiről:"
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="Több telefonos kapcsolatfelvételünk történt az adóssal. Az egyeztetések részletei az alábbiak:"
		else	
			PHRASE_COMMTYPE="${labelInfo}."				
		fi
		;;
	
	CS)
		if [ "${claimsReference}" = " " ];
		then
			SUBJECT="Aktualizace případu Atradius Collections číslo ""$caseReference"" – dlužník ""$debtorName" 
			PHRASE_LINK="Zápis z hovoru je uveden v portálu pro zákazníky, do kterého se můžete přihlásit na následujícím odkazu. https://atradiuscollections.com/cz/přihlášení-na-stránky"
		else
			SUBJECT="Aktualizace případu Atradius Collections číslo ""$caseReference"" – číslo škody ""$claimsReference"" - dlužník ""$debtorName" 
			PHRASE_LINK="Více informací o naší činnosti, včetně přístupu k poznámkám inkasních specialistů, naleznete po přihlášení do aplikace Atrium: https://atrium.atradius.com/"
		fi			
	
		GREETINGDEAR="Vážený kliente," 
		PHRASE_REPLY="Tento email je odesílán automaticky. Prosíme, neodpovídejte na něj."
		GREETING="S pozdravem"
		PHRASE_DEVELOPMENT="Ve výše uvedeném případě došlo k vývoji, o kterém bychom Vás rádi informovali."
		PHRASE_OPTOUT="Pokud chcete přestat dostávat tyto zprávy, pošlete, prosíme, e-mail na adresu ""$OPTOUT_MAIL"
		PHRASE_LINK="Více informací o naší činnosti, včetně přístupu k poznámkám inkasních specialistů, naleznete po přihlášení do aplikace Atrium: https://atrium.atradius.com/"
		
		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="Telefonicky nás kontaktoval dlužník. Zápis z hovoru je uveden níže:" 
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="Telefonicky jsme se zkontaktovali s Vaším dlužníkem. Zápis z hovoru je uveden níže:" 
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="Náš inkasní specialista vytvořil následující shrnutí případu:"
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="Několikrát jsme telefonicky hovořili s vaším dlužníkem. Podrobnosti konverzace jsou následující:"
		else	
			PHRASE_COMMTYPE="${labelInfo}."		
		fi
		;;	

	SK)
		if [ "${claimsReference}" = " " ];
		then
			SUBJECT="Aktualizácia prípadu Atradius Collections číslo ""$caseReference"" - dlžník ""$debtorName"
			PHRASE_LINK="Zápis z hovoru je uveden v portálu pro zákazníky, do kterého se můžete přihlásit na následujícím odkazu. https://atradiuscollections.com/cz/přihlášení-na-stránky"
		else
			SUBJECT="Aktualizácia prípadu Atradius Collections číslo ""$caseReference"" - číslo škody ""$claimsReference"" - dlžník ""$debtorName"
			PHRASE_LINK="Viac informácií o našej činnosti, vrátane prístupu k poznámkam inkasných špecialistov, nájdete po prihlásení do aplikácie Atrium: https://atrium.atradius.com/"
		fi			
	
		GREETINGDEAR="Vážený klient," 
		PHRASE_REPLY="Tento email je odosielaný automaticky. Prosíme, neodpovedajte na neho."
		GREETING="S pozdravom"
		PHRASE_DEVELOPMENT="Vo vyššie uvedenom prípade došlo k vývoju, o ktorom by sme Vás radi informovali."
		PHRASE_OPTOUT="Ak chcete prestať dostávať tieto správy, pošlite, prosíme, e-mail na adresu ""$OPTOUT_MAIL"
		
		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="Telefonicky nás kontaktoval dlžník. Zápis hovoru je uvedený nižšie:" 
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="Telefonicky sme sa skontaktovali s Vašim dlžníkom. Zápis hovoru je uvedený nižšie:"
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="Náš inkasný špecialista vytvoril nasledujúce zhrnutie prípadu:" 
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="Niekoľkokrát sme telefonicky hovorili s vaším dlžníkom. Podrobnosti konverzácie sú nasledovné:"
		else	
			PHRASE_COMMTYPE="${labelInfo}."		
		fi
		;;		
		
	PL)	
		if [ "${claimsReference}" = " " ];
		then	
			SUBJECT="Atradius Collections informuje o aktualnym stanie sprawy windykacyjnej ""$caseReference"" - ""=?UTF-8?B?ZMWCdcW8bmlr?="" ""$debtorName"
			PHRASE_LINK="Więcej informacji dotyczących naszych działań, można uzyskać logując się do systemu Collect@Net: https://www.atradius.com/ATRADIUS/login.jsp"		
		else
			SUBJECT="Atradius Collections informuje o aktualnym stanie sprawy windykacyjnej ""$caseReference"" - ""=?UTF-8?B?ZMWCdcW8bmlr?="" ""$debtorName"
			PHRASE_LINK="Więcej informacji dotyczących naszych działań, można uzyskać logując się do systemu Collect@Net: https://www.atradius.com/ATRADIUS/login.jsp"		
		fi		
		
 		GREETINGDEAR="Drogi Kliencie," 
		PHRASE_REPLY="Email jest wysyłany automatycznie. Prosimy na niego nie odpowiadać."
		GREETING="Z wyrazami szacunku,"
		PHRASE_DEVELOPMENT="Pragniemy poinformować, że we wspomnianej sprawie windykacyjnej nastąpił postęp."
		PHRASE_OPTOUT="Jeśli nie chcesz otrzymywać tych wiadomości, wyślij e-mail na adres: ""$OPTOUT_MAIL" 
		
		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="Otrzymaliśmy telefon od dłużnika, szczegóły rozmowy są następujące:"
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="Skontaktowaliśmy się z dłużnikiem, szczegóły rozmowy są następujące:"
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="Nasz windykator sporządził podsumowanie dotyczące aktualnego stanu sprawy:"
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="Przeprowadziliśmy kilka rozmów telefonicznych z dłużnikiem. Szczegóły są następujące:"
		else	
			PHRASE_COMMTYPE="${labelInfo}."		
		fi			
		;;	
		
	RO)	
		if [ "${claimsReference}" = " " ];
		then
			SUBJECT="Actualizare in cazul Atradius Collection cu referinta ""$caseReference"" - debitor ""$debtorName"
			PHRASE_LINK="Puteti gasi mai multe informatii cu privire la activitatea noastra, inclusiv accesul la toate notele colectorului, conectandu-va la Collect@Net: https://atradiuscollections.com/uk/login-services"
		else
			SUBJECT="Actualizare in cazul Atradius Collection cu referinta ""$caseReference"" - debitor ""$debtorName"
			PHRASE_LINK="Puteti gasi mai multe informatii cu privire la activitatea noastra, inclusiv accesul la toate notele colectorului, conectandu-va la Collect@Net: https://atradiuscollections.com/uk/login-services"
		fi		
		
 		GREETINGDEAR="Stimate client,"
		PHRASE_REPLY="Acest mail este trimis automat; va rog sa nu raspundeti."
		GREETING="Cu stima,"
		PHRASE_DEVELOPMENT="S-a facut un progres in cazul de colectare mentionat mai sus, despre care am dori sa va aducem la cunostinta."
		PHRASE_OPTOUT="Daca doriti sa nu mai primiti aceste mesaje, va rugam sa trimiteti un e-mail la ""$OPTOUT_MAIL" 
		
		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="Am primit un apel din partea debitorul dvs., iar detaliile conversatiei sunt urmatoarele: "
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="Am avut un apel cu debitorul dvs., iar detaliile conversatiei sunt urmatoarele: "
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="Colectorul nostru a făcut următorul rezumat al cazului dvs.: "
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="Am avut mai multe conversații telefonice cu debitorul dumneavoastră. Detalii despre conversație sunt următoarele: "
		else	
			PHRASE_COMMTYPE="${labelInfo}."		
		fi			
		;;		

	ES)
		if [ "${claimsReference}" = " " ];
		then
			SUBJECT="=?UTF-8?B?QWN0dWFsaXphY2nDs24=?="" del caso de Atradius Collections con referencia ""$caseReference"" - deudor ""$debtorName"
			PHRASE_LINK="Puede encontrar más información sobre nuestra actividad, accediendo a todas las notas del gestor iniciando sesión en https://atradiuscollections.com/es/login"
		else
			SUBJECT="=?UTF-8?B?QWN0dWFsaXphY2nDs24=?="" del caso de Atradius Collections con referencia ""$caseReference"" - referencia de siniestro ""$claimsReference"" - deudor ""$debtorName"
			PHRASE_LINK="Puede encontrar más información sobre nuestra actividad, accediendo a todas las notas del gestor iniciando sesión en Atrium https://atrium.atradius.com/"
		fi
						
		GREETINGDEAR="Estimado cliente," 
		PHRASE_REPLY="Este correo se envía automáticamente; por favor, no responda."
		GREETING="Saludos cordiales,"
		PHRASE_DEVELOPMENT="Ha habido novedades en el caso de recobro mencionado anteriormente que nos gustaría comunicarle."
        PHRASE_OPTOUT="Si desea dejar de recibir estos mensajes, envíe un correo electrónico a ""$OPTOUT_MAIL" 
		
		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="Hemos recibido una llamada de su deudor, y los detalles de la conversación son los siguientes: "
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="Hemos realizado una llamada a su deudor, y los detalles de la conversación son los siguientes: "
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="Nuestro gestor ha hecho el siguiente resumen de su expediente:"
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="Hemos tenido varias conversaciones telefónicas con su deudor. Los detalles son los siguientes: "
		else	
			PHRASE_COMMTYPE="${labelInfo}."		
		fi
		;;			

	ZH)
		if [ "${claimsReference}" = " " ];
		then
			SUBJECT="安卓賬務案件的最新情況，案件編號為 ""$caseReference"" -債務人為 ""$debtorName"
		else
			SUBJECT="安卓賬務案件的最新情況，案件編號為 ""$caseReference"" -索賠編號為 ""$claimsReference"" -債務人為 ""$debtorName"
		fi				

		GREETINGDEAR="親愛的顾客" 
		GREETING="此致"
		PHRASE_REPLY="此郵件是自動發送的，請不要回覆。"
		PHRASE_LINK="您可以登錄 https://atradiuscollections.com/hk/login-services 找到更多關於我們工作的信息，包括我們運作團隊與債務人溝通的記錄。"
		PHRASE_OPTOUT="如您想停止接收这些信息，请发送电子邮件至 ""$OPTOUT_MAIL"" 我们会尽快为您处理。"
		PHRASE_DEVELOPMENT="關於貴司委託的案件有了新的進展，我們想讓大家了解一下。"
		
		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="我司接到債務人的電話，通話內容如下： "
		elif [ "${commType}" = "CALLTO" ]; 
		then
			PHRASE_COMMTYPE="我司已與債務人通過電話溝通，詳情如下： "
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="我司的運營團隊對貴司委託的案件做了一份案件總結，詳情如下： "
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="我司與債務人進行了幾次電話交談。對話詳情如下： "
		else	
			PHRASE_COMMTYPE="${labelInfo}."		
		fi		
		;;
		
	CH)
		if [ "${claimsReference}" = " " ];
		then
			SUBJECT="安卓账务案件的最新情况，案件编号为 ""$caseReference"" -债务人为 ""$debtorName"
		else
			SUBJECT="安卓账务案件的最新情况，案件编号为 ""$caseReference"" -索赔编号为 ""$claimsReference"" -债务人为 ""$debtorName"			
		fi		
		
		GREETINGDEAR="亲爱的顾客" 
		GREETING="此致"
		PHRASE_REPLY="此邮件是系统发送，请不要回复。"
		PHRASE_LINK="您可以登录 https://atradiuscollections.com/hk/login-services 找到更多关于我们工作的信息，包括我们运作团队与债务人沟通的记录。"
		PHRASE_OPTOUT="如您想停止接收这些信息，请发送电子邮件至：""$OPTOUT_MAIL"" 我们会尽快为您处理。"
		PHRASE_DEVELOPMENT="关于贵司委托的案件有了新的进展，我们想让大家了解一下。"
		
		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="我司接到债务人的电话，通话内容如下： "
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="我司已与债务人通过电话沟通，详情如下： "
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="我司的运营团队对贵司委托的案件做了一份案件总结，详情如下： "
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="我司与债务人进行了几次电话交谈。对话详情如下： "
		else	
			PHRASE_COMMTYPE="${labelInfo}."		
		fi		
		;;
		
	PT)
		if [ "${claimsReference}" = " " ];
		then
			SUBJECT="=?UTF-8?B?QXR1YWxpemHDp8Ojbw==?="" sobre o processo Atradius Collections  ""$caseReference"" - devedor ""$debtorName"
			PHRASE_LINK="Pode encontrar mais informações sobre as nossas ações, incluindo as notas do Gestor de Cobrança, acedendo através do seu login no https://atradiuscollections.com/global/login"
		else
			SUBJECT="=?UTF-8?B?QXR1YWxpemHDp8Ojbw==?="" sobre o processo Atradius Collections  ""$caseReference"" - referência de sinistro ""$claimsReference"" - devedor ""$debtorName"
			PHRASE_LINK="Pode encontrar mais informações sobre as nossas ações, incluindo as notas do Gestor de Cobrança, acedendo através do seu login no Atrium https://atrium.atradius.com/"
		fi

		GREETINGDEAR="Caro Cliente," 
		PHRASE_REPLY="Este e-mail é enviado automaticamente; por favor não responda."
		GREETING="Melhores cumprimentos,"
		PHRASE_DEVELOPMENT="Vimos alertá-lo que houve um desenvolvimento no processo de cobrança acima mencionado."
        PHRASE_OPTOUT="Se pretender parar de receber estas mensagens, envie um e-mail para ""$OPTOUT_MAIL" 

		if [ "${commType}" = "CALLFROM" ];
		then
			PHRASE_COMMTYPE="Recebemos um contato do seu devedor e os detalhes da conversação são os seguintes: "
		elif [ "${commType}" = "CALLTO" ];
		then
			PHRASE_COMMTYPE="Entrámos em contato com o seu devedor e os detalhes da conversação são os seguintes: "
		elif [ "${commType}" = "SUMMARY" ];
		then
			PHRASE_COMMTYPE="O nosso Gestor de Cobrança fez o seguinte resumo no seu processo: "
		elif [ "${commType}" = "MULTIPLE" ];
		then
			PHRASE_COMMTYPE="Fizemos vários contatos telefónicos com o seu devedor. Os detalhes da conversação são os seguintes: "
		else	
			PHRASE_COMMTYPE="${labelInfo}."		
		fi
		;;				
		
esac

chmod 777 $CITMAN_TMP_FILE
rm -f $CITMAN_TMP_FILE/tmp_html_proactive_comm.eml

echo 'The result is:' > $CITMAN_TMP_FILE/sending_mail.log
echo >> $CITMAN_TMP_FILE/sending_mail.log
echo 'net voor mail'	
################# SOV MIME HEADER ###################
cat >> $CITMAN_TMP_FILE/tmp_html_proactive_comm.eml <<EOF
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html lang="en-US">
<head>
<style>
html {
  Background-Color: White;
  Color: Black;
  Margin: 0px;
  border: 0px;
  padding: 0px;
}
body {
  Font: 12px Arial;
  Margin: 1px;
  border: 0px;
  padding: 0px;
}
</style>
  <meta http-equiv="content-type"   content="text/html; charset=UTF-8" />
</head>
<body><p>
$GREETINGDEAR
<p>$PHRASE_DEVELOPMENT</p>
$PHRASE_COMMTYPE<br>
<p><b><i>$freeComment</i></b></p>
$PHRASE_LINK
<p>$PHRASE_OPTOUT</p>
<p>$PHRASE_REPLY</p>
<p></p>
<p>$GREETING</p>
<p></p>
$collectorName<br>
$collectorEmail
<p></p>
</font><br><br><img src="https://www.atradius.com/ATRADIUS/help/gif/Atradius_Collections.gif" />
</body>
</html>
EOF


(echo "From: atradiuscollections_comm@atradius.com"
 echo "To: $TO"
 echo "Subject: $SUBJECT"
 echo "MIME-Version: 1.0"
 echo "Content-Type: text/html charset=iso-8859-1"
 echo "Content-Disposition: inline"
 cat $CITMAN_TMP_FILE/tmp_html_proactive_comm.eml;
)| /usr/sbin/sendmail $TO $BCC

}
#
# Execution of all steps
#

##########################################################
scriptEnding
##########################################################
