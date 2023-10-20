create table ICARE_FACTOR
(
  nationalNumber            varchar2(25),
  accountNumber             number,
  name                      varchar2(200)
)
tablespace DATA;

create table ICARE_AGORA
(
  eventid                   number,
  caed                      varchar2(2 char),
  accounted                 varchar2(2 char),
  optyed                    varchar2(2 char),
  dat_caed                  date,
  dat_accounted             date,
  dat_optyed                date,
  cusaccount                varchar2(10 char),
  cusref                    varchar2(100 char),
  cushmo                    varchar2(100 char),
  cusctry                   varchar2(3 char),
  cusnationalnumber         varchar2(100 char),
  cuslang                   varchar2(2 char),
  accountname               varchar2(100 char),
  accountnumber             varchar2(100 char),
  ownerid                   number,
  contactid                 number,
  accountcreatedby          varchar2(100 char),
  accountcreationdate       timestamp(6),
  accountcountry            varchar2(100 char),
  accountnationalnumber     varchar2(100 char),
  accountnationalnumberkey  varchar2(100 char),
  accountorgid              varchar2(100 char),
  optyid                    varchar2(100 char),
  optynumber                varchar2(100 char),
  caed_count                number,
  caed_error                varchar2(200 char),
  accounted_fault           varchar2(50 char),
  accounted_fault_string    clob,
  optyed_fault              varchar2(200 char),
  optyed_fault_string       clob
)
tablespace  DATA;

create table ICARE_INSURED
(
  caed                    varchar2(2 char),
  accounted               varchar2(2 char),
  optyed                  varchar2(2 char),
  dat_caed                date,
  dat_accounted           date,
  cusaccount              varchar2(10 char),
  cusref                  varchar2(8 char),
  cushmo                  varchar2(100 char),
  cusname                 varchar2(100 char),
  cuscountry              varchar2(3 char),
  cusnationalnumber       varchar2(100 char),
  cusclienttype           varchar2(100 char),
  cussalesmgr             varchar2(8 char),
  cusownerlogin           varchar2(100 char),
  cusadr1                 varchar2(100 char),
  cusadr2                 varchar2(100 char),
  cuscity                 varchar2(100 char),
  cusstate                varchar2(100 char),
  cuspostalcode           varchar2(100 char),
  cuslang                 varchar2(5 char),
  cuscontactname          varchar2(100 char),
  cusphonenumber1         varchar2(100 char),
  cusphonenumber2         varchar2(100 char),
  cusemail                varchar2(100 char),
  concurrency             varchar2(3 char),
  keyaccountnumber        varchar2(100 char),
  keyclearnumber          varchar2(100 char),
  keynationalnumber       varchar2(100 char),
  keydunsnumber           varchar2(100 char),
  ownername               varchar2(100 char),
  ownerid                 number,
  accountid               number,
  accountnumber           varchar2(100 char),
  contactid               number,
  contactnumber           varchar2(100 char),
  optyid                  number,
  optynumber              varchar2(100 char),
  optynotcompliantflag    varchar2(1 char),
  activityid              number,
  activitynumber          varchar2(100 char),
  caed_count              number,
  caed_error              varchar2(100 char),
  caed_fault              varchar2(100 char),
  caed_fault_string       clob,
  accounted_error         varchar2(100 char),
  accounted_fault         varchar2(100 char),
  accounted_fault_string  clob,
  conref                  varchar2(8 char)
)
tablespace DATA;

create table ICARE_NON_INSURED
(
  accounted                 varchar2(2 char),
  created                   varchar2(2 char),
  optyed                    varchar2(2 char),
  dat_accounted             date,
  dat_created               date,
  dat_optyed                date,
  optynumber                varchar2(100 char),
  optyname                  varchar2(100 char),
  optysalesmethod           varchar2(100 char),
  optysalesstage            varchar2(100 char),
  optycreatedby             varchar2(100 char),
  optycreationdate          timestamp(6),
  optycontactname           varchar2(100 char),
  optyownernumber           varchar2(100 char),
  optyownerlogin            varchar2(100 char),
  optyownername             varchar2(100 char),
  accountnumber             varchar2(100 char),
  accountname               varchar2(100 char),
  accountcontactemail       varchar2(100 char),
  accountphone              varchar2(100 char),
  accountdunsnumber         varchar2(100 char),
  accountcreatedby          varchar2(100 char),
  accountcreationdate       timestamp(6),
  accountaddress1           varchar2(200 char),
  accountaddress2           varchar2(200 char),
  accountcity               varchar2(100 char),
  accountcountry            varchar2(100 char),
  accountstate              varchar2(100 char),
  accountpostalcode         varchar2(100 char),
  accounthmo                varchar2(100 char),
  accountclienttype         varchar2(100 char),
  accountorgid              varchar2(100 char),
  accountnationalnumber     varchar2(100 char),
  accountnationalnumberkey  varchar2(100 char),
  accountlanguage           varchar2(100 char),
  accountparentid           number,
  accountparentnumber       varchar2(100 char),
  cusexref                  varchar2(200 char),
  cusctry                   varchar2(100 char),
  cusnationalnumber         varchar2(100 char),
  cusref                    varchar2(100 char),
  cushmo                    varchar2(100 char),
  created_count             number,
  created_fault             varchar2(100 char),
  created_fault_string      clob,
  optyed_fault              varchar2(100 char),
  optyed_fault_string       clob,
  accounted_fault           varchar2(100 char),
  accounted_fault_string    clob
)
tablespace DATA;

create index ICARE_AGORA_IX0 on ICARE_AGORA (cusref) tablespace DATA;

create table ICARE_LOGIN
(
  refindividu               varchar2(10 char),
  login                     varchar2(10 char),
  name                      varchar2(200 char),
  allowed                   varchar2(1 char)
)
tablespace DATA;

grant ALL on ICARE_FACTOR to PUBLIC;
grant ALL on ICARE_AGORA to PUBLIC;
grant ALL on ICARE_NON_INSURED to PUBLIC;
grant ALL on ICARE_INSURED to PUBLIC;
grant ALL on ICARE_LOGIN to PUBLIC;

begin
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B0070106','PLWSZY1','SZYMCZAK WŁODZIMIERZ','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4124856','CZDJON1','JONAS DAVID','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B3046736','DEMBRO1','BROMBACH MARCUS','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B3046735','DEMBRO1','BROMBACH MARCUS','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4619291','DKSLAN1','LANDGREVE STEFAN','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4480474','USCHAC1','HACKING CHRIS','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4435019','NLBHEM1','OLTHOF BERTHA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B1055044','DEFPAW1','VON PAWELSZ FLORIAN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B2025493','USSSAM1','SAMARAS STEPHANIE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5215885','PLEPRZ1','PRZYBYLSKA EWA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B1054948','USRMIL1','MILLER RHONDA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4579610','AESATM1','ATMARAMANI SANGEETA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4730260','AUANOW1','NOWAK- -ANNA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B0014905','BEADEG1','DEGEMBE ANDRE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A0002101','BEADEN1','DENIS ANNICK','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4801742','BEDFAD1','FADEUR DAVID','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A4010613','BEHTRO1','TROMME HELENA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('98001305','BEJDIS1','DISY JEAN-LOUIS','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B1004240','BEJDIS1','DISY JEAN-LOUIS','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A1034050','BEMBUR1','BURY MARJORIE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4680115','BEPDIN1','DINGENEN PAUL','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A0011089','BERDEG1','DE GREVE RUDI','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A6037376','BESCOP2','COPPOIS STEPHANE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B1004235','BESGIE1','GIESBERGEN SONJA','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B0014895','BEVRIG1','RIGAUX VINCENT','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5000568','CNWZHO1','ZHONG WAYNE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4081397','CZDJON1','JONAS DAVID','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('99011622','BEVTAS1','TASSIN VALERIE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5055147','BRLAQU1','AQUINO LAYLA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4043684','BRPSAW1','SAWOS PAULO','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5146319','CNGZHA1','ZHANG GRACE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4814017','CNICHE1','CHEN IVY','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5065959','CNKAHU1','HU KATHERINE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4997692','CNWZHO1','ZHONG WAYNE','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A9000889','CZPVIC1','VICH PAVEL','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A4001130','DEDMAY1','MAYNE DANIEL','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4901911','DEFDRE1','EXNET FRANK DRESCHER','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A9001075','DEFPAW1','VON PAWELSZ FLORIAN','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A6029683','DEJREI1','REINSBACH JOACHIM','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4176391','DEKHEI1','PETERSEN KATRIN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5023174','DEMASC2','SCHULZE MARCUS','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4257159','DEMBRO1','BROMBACH MARCUS','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B0068197','DEMOLM1','OLMOS MARTINA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4206455','DESMAZ1','MAZLOUM SARAH','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A8036665','DESNUY1','NUYKEN SABINE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4787419','DESSTO1','STOBBE SILVIA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A9001240','DKCNIE2','NIELSEN CAMILLA BERNDORF','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4318791','DKEPEL1','PELTOLA ELISA PAULIINA','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A3007398','DKKULS1','ROLF LARSSEN KATJA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B3066607','dkmnor2','METTE MARIE NORGAARD','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4067802','DKPKON1','SCHOU KONGSTAD PERNILLE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4599385','DKSLAN1','LANDGREVE STEFAN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A9071781','ESBIBA1','LASCARAY BEATRIZ','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4181071','ESESAN1','SANTOS ELISA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A7026520','ESNAGU1','AGUILAR NOEL','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B3118028','FRCNIC1','NICOLAS CELINE','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('99008046','FRCSPA1','SPAULT CHRISTOPHE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B3048232','FREDER1','DERIAZ','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4603925','FRHELO1','HARIDY ELODIE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A6049857','FRIHAR1','LERAMBERT INGRID','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4668270','FRLBOU2','BOUCHKARA LEILA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4974650','FRMCOL1','COLPIN MARIE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4044324','FRNAME1','AMEZZIANE NOREDDINE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4675783','FRPCHA2','CHANTHANANH PHAIMANY','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4893363','GBAHUG2','HUGHES ABBYGAIL','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4901970','GBBWAR2','WARWICK BETH','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4929010','GBCMOR4','ROBERTSON CHLOE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A7005032','GBGJON1','JONES GIDEON','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5117778','GBJFRO1','FROST JESSICA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A3040094','GBLGRI1','GRIFFITHS LUCILA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A5006173','GBMCOA1','COATES MATTHEW','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5149935','GBOCOL1','OLIVIER COLLIS','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4018270','GBRGRI2','WILLIAMS REBECCA','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A3041470','GBSMUR1','MURPHY SARAH','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4725796','GBSRAD1','RADU SORIN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4723272','GBVRUS1','RUSU VICTOR','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A7042383','GBYRAY1','GRAY YVETTE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4776531','HKOCHA1','CHAN ONYX','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B1086942','HKPENG1','NG PEONY','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B3011047','HKPTAN1','TANG PEONY','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A8018333','HKTOAU1','AU TONY','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4100887','HUBPIA1','PIANOVSZKY BEATRIX','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4825751','IEMWEI1','WEIR MICHAEL','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A3050638','ITACAS1','CASTOLDI ALESSIA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A3050641','ITDFOR1','FORTE DANILO','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B0026152','ITFLUC1','LUCENTE FRANCESCA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A3044564','ITLPRO1','PROVERA LAURA','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A7013152','ITMMAU1','MAURI MELISSA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4914934','ITRTON1','TONIUTTI ROBERTO','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A3050645','ITSZER1','ZERBINI SARA','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4616650','MXRJUA1','JUAREZ RAYMUNDO','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B2005531','NLAHES1','HESSELS ARMAND','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A7025292','NLAMAR1','MARSKAMP DHR. A.','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4337477','USCHAC1','HACKING CHRIS','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A9092953','NLAPOT1','SCHOT ANGELIQUE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B1022418','NLBHEM1','OLTHOF BERTHA','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A3036493','NLCLEU1','LEUSHUIS C.','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A3041465','NLELAM2','PULLEN E.','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4487677','NLELEM1','LEMMENS EDWARD','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4163273','NLJHuy1','HUIJSER JOHAN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4435031','nljmil1','KOBES JEANNETTE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B0056696','NLMBEE2','VAN BEEK MAURICE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A7078285','NLMBEE2','VAN BEEK M.','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A6052490','NLMBRU3','BRUGGELING MICHEL','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4717047','NLMMAA2','MAATHUIS MICHIEL','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A3041471','NLMNAG1','WIJERING M.','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A7065343','NLPVOR1','VAN DE VORSTENBOSCH PETRA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A7078261','NLSBRA1','DEN BRABER SJACCO','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5000725','NLSFER1','DA CONCEICAO FERREIRA STEPHANIE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4927905','NLWHAA1','DE HAAN WENDY','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5662840','PLASKA1','SKALSKI ARTUR','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4727180','PLAZOL1','ZOLTOWSKA AGNIESZKA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4553537','PLBKUL1','KULA ORLOWSKA BEATA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4977633','PLGTOM1','TOMKIEWICZ GABRIELA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4599930','PLKGOD1','KAROLINA GODLEWSKA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A8042814','PLWSZY1','SZYMCZAK WŁODZIMIERZ','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4599810','SECKAY1','KAYHAN CAHIT','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4373058','SGIMIR1','MIRIC IVOR','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4541611','SGMLIM1','LIM MONICA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5131058','SGPWON1','WONG PEI YI','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4875829','SGQDEK1','DEKEN QUINTUS','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5159531','USCGRI1','GRIMALDO CLAUDIA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4879473','USDBAR1','BARRETT DAVID','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4072747','USKPAR1','PARSONS KIMBERLY','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B1078468','USRMIL1','MILLER RHONDA','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A7081086','USSSAM1','SAMARAS STEPHANIE','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4407152','SGIMIR1','MIRIC IVOR','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4587774','MXMAMA1','MIRIAM AMADOR','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B1054787','HKPENG1','NG PEONY','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5313242','SGSLIE1','LIEW SHERMIN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4989515','GBMLES1','LESNIEWSKA MAGDALENA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4912341','DEMKAL3','KALUBI MARIE THERESA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4552759','GBGDEL1','DELO GEORGINA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4698553','ITACAS1','CASTOLDI ALESSIA','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4806980','FRPCHA2','CHANTHANANH PHAIMANY','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B1055227','HKTOAU1','AU TONY','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4871710','USDBAR1','BARRETT DAVID','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B2005537','NLMBRO4','BROUWER MARTIJN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4704610','CAJCLA1','CLARKE JENNIFER','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B1058171','FREDER1','DERIAZ ERIC','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4802756','DEFDRE1','DRESCHER FRANK','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4876734','GBMCOA1','COATES','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5118456','GBOCOL1','COLLIS OLIVER','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5162910','DEDMAY1','DANIEL MAYNE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4883613','NLMEDD1','EDDAOUDI MOHAMED','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4041670','BEAGRU1','GRUTERING ALEXANDRE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4641752','SECKAY1','KAYHAN CAHIT','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4686574','USSGAU1','GAUDIO SANDRO','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B2070466','BESGIE1','GIESBERGEN SONJA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B2004359','GBYGRA1','GRAY YVETTE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4420174','NLELEM1','LEMMENS EDWARD','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4522218','DKEPEL1','PELTOLA ELISA PAULIINA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4884080','ITLPRO1','PROVERA LAURA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4105817','NLAMAR1','MARSKAMP ANDRES','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4929251','GBCMOR4','MORGAN CHLOE','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B3100257','FRCNIC1','NICOLAS CELINE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B1072721','ESCSAN1','SANTIAGO CARLOTA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B1058173','FRCSPA1','SPAULT CHRISTOPHE','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4215036','NLPVOR1','VAN DE VORSTENBOSCH PETRA','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4554811','BRPSAW1','SAWOS PAULO','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4522220','DKPKON1','SCHOU KONGSTAD PERNILLE','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B1073309','AUMSHE1','SHEHADIE MARK','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5217509','GBNVEY1','VEJAYAKUMAR NATALIE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4741636','NLDVOE1','VOETEN DOUGLAS','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4915313','GBBWAR2','WARWICK BETH','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5227215','DKARAU1','RAUFF ALEXANDER','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4007512','GBRGRI2','WILLIAMS REBECCA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B3034569','ITSZER1','ZERBINI SARA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5769842','NLTSMI2','SMITS TOM','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5708826','GBFROD1','RODRIGUES FABIENNE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5709521','HKOCHA1','ONYX CHAN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5709524','HKPTAN1','PEONY TANG','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5209374','GBNVEY1','VEJAYAKUMAR NATALIE','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5585231','INSSIN7','SINGH SANJAY','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5606333','SGKLEE1','LEE KE WEI','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5552711','USJBER1','BERRY JAMES','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5580633','FRGLEF2','LEFEVRE GAVRILA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5580571','FRLFON1','DA FONSECA LUCIE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5580711','SGDPRA1','PRABOWO DIYAN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5523289','NLSDYB1','DYBAAL BLOM SHARON','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5527312','CNSZHA5','ZHANG STEVE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5499133','NLKBOU1','BOUWMEESTER KAI','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5499931','CZKKAD1','KADLECOVA KAROLINA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5486905','PTPFIG1','FIGUEIREDO PAULA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5486915','PTSSIL1','SILVA SOFIA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5482874','PTIMAG1','MAGALHAES ISABEL','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5701735','FRMFRO2','FROMENTIN MARION','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5714830','USDFOR1','FORTMAN DANA','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5735435','GBGWEE3','WEEKES GEORGIA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5814589','SGVLIU1','LIUS VIONI','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5739256','MXECRU1','DE LA CRUZ ELSA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5741466','GBRMEE1','MEEK ROSIE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5860775','GBMBLA1','BLACK MONICA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5799403','GBGGRI3','GRIFFITHS GEMMA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5151135','INKANS1','ANSARI KALIM','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5762499','USJKAP1','KAPLAN% JULIE%','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5762541','DETMAN3','MANNIELLO TIZIANA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5763507','BEAAHM1','AHMED ARAFAT','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5800195','NLSMAR2','MARSMAN S.','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5794181','GBOLUS1','LUCSCOMBE OLIVER','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5670324','MXHMON1','HEINZ BAZAN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5679568','NLMSOE2','SOETEN MICK','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A9081563','FRCBEL1','BELLOT CATHERINE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5314067','NLXPAL1','PALMERO XAVIER','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5763053','USPHUG1','%HUGHES PATRICK','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5095864','IETBOL1','BOLWELL TEGAN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5276210','BECLAU2','LAURENT CHARLOTTE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5849773','ESCMAC1','MACHADO CLARICE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5281766','HUAHOR1','HORTOLANYI-BORUZS ANDREA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5325050','USRGRE1','GREEN ROBERT','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5313050','AUSHAR1','HARRISON STEWART','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4175631','CASGAU1','GAUDIO SANDRO','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5406077','AUTJIA1','JIAO THOMAS','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5391535','NLRWAA1','DE WAAL ROBBIN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5386779','CZJTVR1','TVRDIK JOSEF','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5362752','CZKRIC1','RICHTARCIKOVA KATARINA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5407310','FRLROB1','ROBERT LEA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5416038','DKACAL1','GALVIT ANDERS','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5120154','GBLKIH1','KIHLBERG LUCY','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4847198','TRGGUR1','GUERSU GUELCAN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5235514','TRMBES1','BESIRYAN MELISA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5471345','NLKBOE1','DE BOER KEVIN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5488054','PLMKOS1','KOSCIJANSKI MACIEJ','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5430920','NLLVEE2','VEENEMANS LAURENS','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5443750','ESMGAR3','GARRIDO MARTA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4740465','GBJARA2','ARANDJELOVIC JUSTIN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5486898','PTBINA1','INACIO BELINA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5846471','PLMGAR1','GARNIER MATEUSZE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5639529','USNKAR1','KAREL NANCY','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5634482','GBMHAR5','HARRIES MARK','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5555833','DEMOLM1','MARTINA OLMOS','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B3046735','DEMBRO1','MARCUS BROMBACH','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5732657','NLADER6','ALEXANDER DERKSEN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5677545','PTACAL1','CALADO ANDRE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5141776','BEDGIL1','GILLARD DELPHINE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5744441','BEOPOC1','POCHET OCEANE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5747514','HUAPOP1','POPOVICS ATTILA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5732924','ESMROD3','RODADO MARIA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5676189','DEFJUN1','JUNGE FALKO','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5691846','USEROS1','ROSOL EVA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5700158','TUCPEK1','PEKKOCAK CAN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5120002','ESEFUN1','FUNES GARRIDO ELENA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5727756','BEFFLO1','FERRAILLE FLORENTINE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5732962','FRCBAY1','BAY CAMILLE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5696198','NLPNOO2','NOORTWIJK PETER','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5701146','PLJKIS1','KISIELINSKI JAKUB','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5771943','USDFOR1','FORTMAN DANA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5716952','PLPLEW1','LEWANDOWSKA PAULINA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5068045','SEWSTA1','STACKELBERG WENDELA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5479715','PTSANT1','ANTUNES SERGIO','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5179690','GBNSZE1','SZEKELY NICKY','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5533692','INNDHO1','DHOBLE NISHA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A3006135','NLRKAA1','KAASJAGER ROBIN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('A7013039','BEHMOL1','MOLLE HENRY','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5685922','NLSDER1','VAN DER AA SHARON','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B4924553','NLVWES1','WESTERVELD VERA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5690814','CNCHMA1','MA CHRIS','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5203100','GBNSZE1','SZEKELY-SZUCS NICKY','');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5570651','DKJHOR1','HORNUM - JULIE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5684459','DKCBIR1','BIRO CRISTIAN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5817164','DEJGAJ1','GAJIC JULIANE','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5558279','GBALEW1','LEWIS ADAM','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5655940','HUVHOR2','HORVATH VIKTORIA','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5655981','CNAZHA3','ZHANG ALVIN','O');
insert into ICARE_LOGIN (refindividu, login, name, allowed) values ('B5627455','PTMPER1','PEREIRA MARIANA','O');
end;

begin
insert into ICARE_FACTOR (nationalnumber, accountnumber, name) values ('NL814069861B01',9527,'Trfi B.V.');
insert into ICARE_FACTOR (nationalnumber, accountnumber, name) values ('DE276499897',987126,'ETRIS BANK GMBH');
insert into ICARE_FACTOR (nationalnumber, accountnumber, name) values ('BE0629721921',953433,'Koalafin');
insert into ICARE_FACTOR (nationalnumber, accountnumber, name) values ('DE226046877',1680997,'FLATEXDEGIRO BANK AG C/O');
insert into ICARE_FACTOR (nationalnumber, accountnumber, name) values ('FR26063802466',1679020,'FACTOFRANCE');
insert into ICARE_FACTOR (nationalnumber, accountnumber, name) values ('FR06410750863',1545797,'ABN AMRO COMMERCIAL FINANCE');
insert into ICARE_FACTOR (nationalnumber, accountnumber, name) values ('DE258787337',1722822,'BIBBY FINANCIAL SERVICES GMBH');
end;