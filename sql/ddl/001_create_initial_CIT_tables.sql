CREATE TABLE CIT_ACTION_ENTITY
(
  ACTION           VARCHAR2(100 CHAR),
  ENTITY_TYPE      VARCHAR2(100 CHAR),
  DIRECTION        VARCHAR2(100 CHAR),         
  ENTITY_REFERENCE VARCHAR2(100 CHAR),
  EFFECT_FROM_DAT  DATE,
  EFFECT_TO_DAT    DATE)
TABLESPACE DATA;
GRANT SELECT ON CIT_ACTION_ENTITY TO PUBLIC;

CREATE TABLE CIT_CS_PORTFOLIO 
(
  REFINDIVIDU      VARCHAR2(8 CHAR), 
  PAYS             VARCHAR2(3 CHAR), 
  REFEXT           VARCHAR2(200 CHAR), 
  THE_DATE         DATE, 
  PORTFOLIO_ID     VARCHAR2(100 CHAR))
TABLESPACE DATA;
GRANT SELECT ON CIT_CS_PORTFOLIO TO PUBLIC;
CREATE INDEX CS_PORTFOLIO_IDX1 ON CIT_CS_PORTFOLIO ("REFINDIVIDU") TABLESPACE DATA;
CREATE INDEX CS_PORTFOLIO_IDX2 ON CIT_CS_PORTFOLIO ("REFEXT") TABLESPACE DATA;


CREATE TABLE CIT_CS_MIDDLEWARE 
(
  REFINDIVIDU              VARCHAR2(8 CHAR), 
  REFDOSS                  VARCHAR2(10 CHAR), 
  IMX_ACTION               VARCHAR2(50 CHAR), 
  CS_STATUS                VARCHAR2(10), 
  FLAG_DEBTORDATA_FOUND    VARCHAR2(1 CHAR),
  FLAG_CS_COMPANY_SEARCH   VARCHAR2(1 CHAR),
  FLAG_CS_REPORT_FOUND     VARCHAR2(1 CHAR),
  FLAG_SCORE_UPDATED       VARCHAR2(5 CHAR),
  DB_NAME                  VARCHAR2(200 CHAR),
  LIST_ADDRESS             VARCHAR2(2000 CHAR),             
  VAT_NO                   VARCHAR2(50 CHAR),
  VAT_NO_FRMT              VARCHAR2(50 CHAR),
  REG_NO                   VARCHAR2(50 CHAR),
  REG_NO_FRMT              VARCHAR2(50 CHAR),
  CS_COMPANY_ID            VARCHAR2(50 CHAR),
  CS_RATING                VARCHAR2(1 CHAR),
  ACTIVITY                 VARCHAR2(20 CHAR),
  LEGAL_FORM               VARCHAR2(2 CHAR),
  PHONE                    VARCHAR2(20 CHAR),
  CREATION_DATE            DATE,
  LAST_UPDATE              DATE,
  CONSTRAINT unique_cit_cs_middleware UNIQUE (REFINDIVIDU, IMX_ACTION))
TABLESPACE DATA;
GRANT SELECT ON CIT_CS_MIDDLEWARE TO PUBLIC;
CREATE INDEX CS_MIDDLEWARE_IDX1 ON CIT_CS_MIDDLEWARE ("REFINDIVIDU") TABLESPACE DATA;

CREATE TABLE CIT_CS_RESULT 
(
  REFINDIVIDU           VARCHAR2(8 CHAR), 
  PRIORITY              VARCHAR2(2 CHAR), 
  CRITERIA              VARCHAR2(200 CHAR), 
  RESULT                VARCHAR2(10), 
  CS_COMPANY_ID         VARCHAR2(50 CHAR),
  CREATION_DATE         DATE)
TABLESPACE DATA;
GRANT SELECT ON CIT_CS_RESULT TO PUBLIC;
CREATE INDEX CS_RESULT_IDX1 ON CIT_CS_RESULT ("REFINDIVIDU") TABLESPACE DATA;

CREATE TABLE CIT_KSH_PARAM 
(
  SCRIPT			    VARCHAR2(100 CHAR), 
  EFFECT_FROM_DAT	TIMESTAMP (6), 
  EFFECT_TO_DAT		TIMESTAMP (6), 
  NUM_VALUE			  NUMBER(23,8), 
  NUM_VALUE2		  NUMBER(23,8), 
  NUM_VALUE3		  NUMBER(23,8), 
  TEXT_VALUE		  VARCHAR2(1000 CHAR), 
  COMMENTS			  VARCHAR2(1000 CHAR), 
  TEXT_VALUE2		  VARCHAR2(1000 CHAR))
TABLESPACE DATA;
GRANT SELECT ON CIT_KSH_PARAM TO PUBLIC;


CREATE TABLE IMX_EVENTS_QUEUE 
(
  UN_ID        	            NUMBER,
  INTERFACE_CODE	          VARCHAR2(20),
  ACTION	                  VARCHAR2(50),
  IMX_EVENT_ID              NUMBER,
  REFDOSS	                  VARCHAR2(10),
  REFINDIVIDU	              VARCHAR2(8),
  REFELEM	                  VARCHAR2(8),
  TYPELEM	                  VARCHAR2(4),
  CREATION_DATE	            TIMESTAMP,
  DETAIL_1	                VARCHAR2(80),
  DETAIL_2	                VARCHAR2(80),
  DETAIL_3	                VARCHAR2(80),
  DETAIL_4	                VARCHAR2(80),
  DETAIL_5	                VARCHAR2(80),
  MT_DETAIL_1	              NUMBER,
  MT_DETAIL_2	              NUMBER,
  DT_DETAIL_1	              DATE,
  DT_DETAIL_2	              DATE,
  EVENT_HANDLING_STATUS	    VARCHAR2(20),
  EVENT_REJECTED_REASON	    VARCHAR2(50),
  EVENT_REJECTED_DATE	      DATE,
  EVENT_HANDLING_TIMESTAMP	TIMESTAMP)
TABLESPACE DATA;
GRANT SELECT ON IMX_EVENTS_QUEUE TO PUBLIC;

CREATE SEQUENCE SQ_IMX_EVENTS_QUEUE_UN_ID
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  ORDER
  NOKEEP
  NOSCALE
  GLOBAL;
GRANT all ON SQ_IMX_EVENTS_QUEUE_UN_ID TO public;

CREATE TABLE LOV_CS_LEGAL_FORM 
(
  CS_PROVIDER_CODE	 NUMBER, 
  CS_DESCRIPTION	   VARCHAR2(250),
  IMX_LEGAL_FORM     VARCHAR2(20))
TABLESPACE DATA;
GRANT SELECT ON LOV_CS_LEGAL_FORM TO PUBLIC;


CREATE TABLE LOV_CS_PORTFOLIO_MONITORING 
(
  COUNTRY		 	    VARCHAR2(3), 
  PORTFOLIO_ID	  VARCHAR2(100),
  PORTFOLIO_NAME  VARCHAR2(100),
  PORTFOLIO_RULES VARCHAR2(100)) 
TABLESPACE DATA;
GRANT SELECT ON LOV_CS_PORTFOLIO_MONITORING TO PUBLIC;


CREATE TABLE LOV_CS_SEARCH_PRIORITY
(
  COUNTRY         VARCHAR2(3),
  PRIORITY        VARCHAR2(2),
  VALUE           VARCHAR2(200))
TABLESPACE DATA;
GRANT SELECT ON LOV_CS_SEARCH_PRIORITY TO PUBLIC;


CREATE TABLE LOV_IMX_EVENTS_CONSUMERS
(
  ACTION          VARCHAR2(50),
  INTERFACE_CODE  VARCHAR2(20),
  COMMENTS        VARCHAR2(2000), 
  ACTIVE          VARCHAR2(1))  
TABLESPACE DATA;
GRANT SELECT ON LOV_IMX_EVENTS_CONSUMERS TO PUBLIC;


create table S_CUSTOMER
(
  ID	    Number
 ,score_id	Varchar2(10)
 ,NAME	Varchar2(100)	
 ,firstName	Varchar2(80)
 ,vat	Varchar2(80)
 ,LANGUAGE	Varchar2(2)
 ,paymentTerms	Varchar2(3)
 ,mainCountry	Varchar2(3)
 ,mainAdr1	Varchar2(100)
 ,mainAdr2	Varchar2(100)	
 ,mainState	Varchar2(30)	
 ,mainPostCode	Varchar2(15)	
 ,mainCity	Varchar2(60)	
 ,invName	Varchar2(100) --G_ADDRESSE.str17   for which str5 = ‘I’
 ,invCountry	Varchar2(3)	
 ,invAdr1	Varchar2(100)	
 ,invAdr2	Varchar2(100)	
 ,invState	Varchar2(30)	
 ,invPostCode	Varchar2(15)	
 ,invCity	Varchar2(60)	
 ,SIRET	Varchar2(100) --G_INDIVIDU.SIRET of scoreId
 ,regNum	Varchar2(100) --G_INDIVIDU.REGCOMM of scoreId
 ,interfaceDate	Date
 ,status_exp varchar2(3)
 ,error_txt varchar2(1000)	
)
TABLESPACE DATA;

CREATE UNIQUE INDEX S_CUSTOMER_PK ON s_customer
(ID)
TABLESPACE DATA
;

--create public synonym S_CUSTOMER for S_CUSTOMER;
grant all on S_CUSTOMER to public;

CREATE SEQUENCE SQ_S_CUSTOMER_ID
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  ORDER
  NOKEEP
  NOSCALE
  GLOBAL;

GRANT all ON SQ_S_CUSTOMER_ID TO public;

create table S_CUST_CONTACTS
(
  CUST_ID	number	--ID from table S_CUSTOMER
 ,contType	Varchar2(10)	
 ,contName	Varchar2(100)	
 ,contPhoneNum	Varchar2(40)	
 ,contFaxNum	Varchar2(40)	
 ,contMobileNum	Varchar2(40)	
 ,contEmail	Varchar2(40)	
 ,interfaceDate	Date	
)
TABLESPACE DATA;

--create public synonym S_CUST_CONTACTS for S_CUST_CONTACTS;
grant all on S_CUST_CONTACTS to public;

create table S_CUST_BANKS
(
  CUST_ID	number	--ID from table S_CUSTOMER
 ,bankName	Varchar2(100)	
 ,bankName2	Varchar2(80)	
 ,bankScoreId	Varchar2(8)	
 ,bankCode	Varchar2(10)	
 ,bankBranchCode	Varchar2(6)	
 ,bankABA	Varchar2(25)	
 ,bankBIC	Varchar2(11)	
 ,bankCity	Varchar2(60)	
 ,bankAdr1	Varchar2(100)	
 ,bankAdr2	Varchar2(100)	
 ,bankCedexCity	Varchar2(60)	
 ,bankPostCode	Varchar2(15)	
 ,bankCountry	Varchar2(3)	
 ,bankAccountNb	Varchar2(50)	
 ,bankIBAN	Varchar2(34)	
 ,bankCurrency	Varchar2(3)	
 ,bankPrimaryFlag	Varchar2(1)	
 ,bankStatus	Varchar2(1)	
 ,bankUpdDate	Date	
 ,interfaceDate	Date	
)
TABLESPACE DATA;

--create public synonym S_CUST_BANKS for S_CUST_BANKS;
grant all on S_CUST_BANKS to public;

create table S_CUST_EMAILS
(
  CUST_ID	number --ID from table S_CUSTOMER
 ,Type	Varchar2(10) --	From G_TELEPHONE for the scoreId, take only the TYPETEL INVMAILTO INVMAILCC
 ,Email	Varchar2(250)	
 ,interfaceDate	Date	
)
TABLESPACE DATA;

--create public synonym S_CUST_EMAILS for S_CUST_EMAILS;
grant all on S_CUST_EMAILS to public;

create table S_CUST_ACCOMPANY
(
  CUST_ID	number --ID from table S_CUSTOMER
 ,seq	number
 ,valeur Varchar2(10)	
 ,interfaceDate	Date	
)
TABLESPACE DATA;

--create public synonym S_CUST_ACCOMPANY for S_CUST_ACCOMPANY;
grant all on S_CUST_ACCOMPANY to public;


create table S_LINKHEAD
(
  linkcode number -- sequence
 ,caseRef	Varchar2(10)	
 ,accComp	Varchar2(8)	
 ,accCompName	Varchar2(100)	
 ,accCompCountry	Varchar2(3)	
 ,indRef	Varchar2(8)	
 ,indName	Varchar2(100)	
 ,indCountry	Varchar2(3)	
 ,operationCode	Varchar2(6)	
 ,transactionDt	Date	
 ,invoiceNum	Varchar2(20)	
 ,origInvoiceNum	Varchar2(20)	
 ,invAddresseeType	Varchar2(2)	
 ,invAddresseeCountry	Varchar2(3)	
 ,Compenstated	Varchar2(2)	
 ,custRef	Varchar2(50)	
 ,entryDate	Date	
 ,servDeliveryDt	Date	
 ,PONumber Varchar2(50) --G_PIECE.ST10 of the valid contract using caseRef as refdoss  Filled only for operationCode (INVCU, CRDCU)
 ,deliveryMethod Varchar2(10) --G_PIECE.LIBELLE_20_2 of the valid contract using caseRef as refdoss Filled only for operationCode (INVCU, CRDCU)
 ,eInvPlatform Varchar2(50) --G.PIECE.To be defined after Codix delivers the code using caseRef as refdoss Filled only for operationCode (INVCU, CRDCU)
 ,eInvKey Varchar2(140)	--T_INDIVIDU.REFEXT with SOCIETE = ‘EINV’ Of ‘CL’ partner of caseRef Filled only for operationCode (INVCU, CRDCU)
 ,invSentTo Varchar2(8)	-- Ancrefdoss of caseRef like ‘INSURED’ Null Using debtorCase of LINKLINE (first if several), check if TC, if no Null Else take TC refindividu, compare FAC_ENV and ADD_FAC, if different ? refindividu of the partner in FAC_ENV Filled only for operationCode (INVCU, CRDCU)
 ,printOption Varchar2(3) --Null except if ...
 ,date_export	Date	
 ,status_exp varchar2(3)
 ,error_txt varchar2(1000)
)
TABLESPACE DATA;

--create public synonym S_LINKHEAD for S_LINKHEAD;
grant all on S_LINKHEAD to public;

CREATE INDEX PK_S_LINKHEAD ON S_LINKHEAD
(LINKCODE)
TABLESPACE DATA;


ALTER TABLE S_LINKHEAD ADD (
  CONSTRAINT PK_S_LINKHEAD
  PRIMARY KEY
  (LINKCODE)
  DEFERRABLE INITIALLY IMMEDIATE
  USING INDEX PK_S_LINKHEAD
  ENABLE VALIDATE);


CREATE INDEX IDX_S_LINKHEADS_DTEXP ON S_LINKHEAD
(DATE_EXPORT)
TABLESPACE DATA;

-- drop table S_LINKLINE;

create table S_LINKLINE
(
  linkcode number
 ,lineType	Varchar2(10)	
 ,docCode   varchar2(100)
 ,docLineNum number(10)
 ,Amount	Number(16,3)	
 ,Dc	Varchar2(1)	
 ,amountType	Varchar2(3)	
 ,Currency	Varchar2(3)	
 ,currencyRate	Number(10,5)	
 ,currencyRateDt	Date	
 ,functionalCurr	Varchar2(3)	
 ,paymentCurr	Varchar2(3)	
 ,domExp	Varchar2(1)	
 ,amountPmtCurr	Number(16,3)
 ,debtorCase	Varchar2(10)	
 ,caseExtRef	Varchar2(60)	
 ,caseCategory	Varchar2(30)	
 ,paymentId	Varchar2(100)	
 ,paymentStampNr	Varchar2(100)	
 ,statementNumber	Varchar2(10)	
 ,debtorName	Varchar2(50)	
 ,lineTypeText	Varchar2(200) --upper translated using V_DOMAINE.TYPE (‘FACTURE’) ABBREV = lineType Take VALEUR_xx (language of the ‘CL’ partner of caseRef) Filled only for operationCode (INVCU, CRDCU)
 ,DATE_EXPORT date
 ,status_exp varchar2(10)  
)
TABLESPACE DATA;

--create public synonym S_LINKLINE for S_LINKLINE;
grant all on S_LINKLINE to public;

CREATE INDEX IDX_S_LINKLINE ON S_LINKLINE
(LINKCODE)
TABLESPACE DATA;