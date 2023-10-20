WHENEVER sqlerror EXIT failure;

set serveroutput on size 1000000

declare
  sql_output       		UTL_FILE.FILE_TYPE;
  return_code      		NUMBER(5);
  l_count		   		NUMBER(5);	
  l_from           		date;
  prev_caseReference 	varchar(10);
  prev_clientName 		varchar(100);
  prev_clientEmail 		varchar(250);
  prev_clientLanguage 	varchar(2);
  prev_debtorName 		varchar(100);
  prev_collectorName 	varchar(180);
  prev_collectorEmail 	varchar(250);
  prev_freeComment 		varchar(4000);
  prev_labelInfo		varchar(250);
  prev_claimsReference 	varchar(64);
  prev_lblType			varchar(100);
  prev_commType 		varchar(10);
  prev_countryUnit 		varchar(3);  
  
  cursor c_main(p_from in date)
  is
	select distinct e.refdoss as caseReference, 
	       to_char(e.dtsaisie_dt, 'dd/MM/YY'),
	       cit_special_char_remove(trim(iCL.nom)) as clientName,
   	       cit_special_char_remove(nvl(indCL.tel1, nvl(indCL.tel2, indCL.tel3))) as clientPhone,
    	   cit_special_char_remove(indCL.email) as clientEmail,
		   indCl.langue as clientLanguage,
		   cit_special_char_remove(trim(iDB.nom)) as debtorName,
   	       p.login as Collector,
   	       cit_special_char_remove(trim(indCO.prenom || ' ' || indCO.nom)) as collectorName,
  	       cit_special_char_remove(lower(nvl(p.email,indCO.e_mail))) as collectorEmail,
		   translate(inf.libreinfo, CHR(10)||CHR(13), ' ; ') as freeComment,
		   nvl(d.ancrefdoss, ' ') as claimsReference,
		   e.libelle as lblType,
		   case when e.libelle = 'CASE SUMMARY' then 'SUMMARY'
                when e.libelle = 'CALL FROM DB' then 'CALLFROM' 
				when e.libelle = '182 SME first reminder STA' then 'SME_182'
				when e.libelle = '183 SME push vocal1 STA' then 'SME_183'
				when e.libelle = '184 SME video reminder STA' then 'SME_184'
				when e.libelle = '185 SME push vocal2 STA' then 'SME_185'								
				when e.libelle = '186 SME third reminder STA' then 'SME_186'								
				when e.libelle = '187 SME push vocal3 STA' then 'SME_187'								
				when e.libelle = '188 SME final reminder STA' then 'SME_188'								
				when e.libelle = '189 SME push vocal4 STA' then 'SME_189'								
				when e.libelle = '190 SME close in progress STA' then 'SME_190'								
				when e.libelle = '191 SME call debtor STA' then 'SME_191'	
				when e.libelle = '192 SME Advice CL STA' then 'SME_192'
				when e.libelle = '193 SME legal/closure STA' then 'SME_193'
                else 'CALLTO' 
                end as commType,
						
		   case when iBU.refindividu = 'INTBUUSA' then 'USA'
				when iBU.refindividu = 'INTBUCZE' then 'CZE'
				when iBU.refindividu = 'INTBUDEU' then 'DEU'
				when iBU.refindividu = 'INTBUDNK' then 'DNK'
				when iBU.refindividu = 'INTBUFRA' then 'FRA'
				when iBU.refindividu = 'INTBUHUN' then 'HUN'
				when iBU.refindividu = 'INTBUITA' then 'ITA'
				when iBU.refindividu = 'INTBUPOL' then 'POL'
				when iBU.refindividu = 'INTBUGBR' then 'GBR'
				when iBU.refindividu = 'INTBUNLD' then 'NLD'
   			    when iBU.refindividu = 'INTBUBEL' then 'BEL'
   			    when iBU.refindividu = 'INTBUMEX' then 'MEX'
			    when iBU.refindividu = 'INTBUSGP' then 'SGP'
				when iBU.refindividu = 'INTBUIND' then 'IND'
				--when IHMO.refindividu = 'B4219598' then 'ARE'
                when iBU.refindividu = 'INTBUHKG' then 'HKG'				
				--when IHMO.refindividu = 'A5087146' then 'AUS'
				when iBU.refindividu = 'INTBUCAN' then 'CAN'
				when iBU.refindividu = 'INTBUIRL' then 'IRL'
				when iBU.refindividu = 'INTBUTUR' then 'TUR'
				when iBU.refindividu = 'INTBUESP' then 'ESP'	
				when iBU.refindividu = 'INTBUPRT' then 'PRT'				
				end as countryUnit,
			lbl.valeur_trad as labelInfo		

	  from t_elements e, g_dossier d, t_intervenants iCL, g_individu indCL, t_intervenants iDB, g_personnel p, g_individu indCO, t_intervenants iBU, g_information inf, v_tdomaine lbl
	 where 1 = 1
	   and e.typeelem = 'in' 
           and e.libelle in (
		    'CASE SUMMARY',
			'CALL TO DB SUCCESSFUL', 
			'CALL FROM DB', 
			'Tel Debtor:he intends to pay within the 10 working days',
			'Tel Debtor:he intends to propose a payment plan',
			'Tel Debtor:he is disputing the debt. We require more details to be sent within the 5 working days',
			'Tel Debtor:he is in a very bad financial situation, on the verge of insolvency',
			'Tel Debtor:he is using delays tactics and tries to avoid AtradiusCollections',
			'Tel Debtor:he is willing to pay, waiting loan from a bank',
			'182 SME first reminder STA',
			'183 SME push vocal1 STA',
			'184 SME video reminder STA',
			'185 SME push vocal2 STA',
			'186 SME third reminder STA',
			'187 SME push vocal3 STA',
			'188 SME final reminder STA',
			'189 SME push vocal4 STA',
			'190 SME close in progress STA',
			'191 SME call debtor STA',
			'192 SME Advice CL STA',
			'193 SME legal/closure STA'
			)
           --and e.dtsaisie >= to_number(to_char(p_from, 'J'))
           --and e.dtsaisie < to_number(to_char(sysdate, 'J')) 
		   and e.dtsaisie > to_number(to_char(sysdate-100, 'J'))
		   and (indCl.langue in ('AN', 'SV', 'NL', 'DA', 'NO', 'AL', 'TR', 'CS', 'SK', 'PL', 'HU', 'FR', 'FL', 'IT', 'RO', 'ES', 'ZH', 'CH', 'PT', 'FI')
             or (indCl.langue = 'MX' and d.ancrefdoss is null))
	       and d.refdoss = e.refdoss
           and iCL.refdoss = d.refdoss
		   and ((d.categdoss = 'INSURED' and iCL.reftype = 'TC') or
		        (d.categdoss = 'NOT INSURED' and iCL.reftype = 'CL')) 
		   and indCL.refindividu = iCL.refindividu
		   and indCL.str36 in ('4', '9')
		   and iDB.refdoss = e.refdoss
		   and iDB.reftype = 'DB'
		   and iBU.refdoss = e.refdoss
		   --and e.refdoss = '1905310342'
   		   and iBU.refindividu in ('INTBUUSA','INTBUCZE','INTBUDEU','INTBUDNK','INTBUFRA','INTBUHUN','INTBUITA','INTBUPOL','INTBUGBR','INTBUNLD','INTBUBEL','INTBUMEX','INTBUSGP','INTBUIND','INTBUHKG','INTBUCAN','INTBUIRL','INTBUTUR','INTBUESP','INTBUPRT') 		   
		   and indcl.email is not null
           and p.refperso = case when d.monref is null then d.rangmt else d.monref end
		   and indCO.refindividu = p.refindividu
   		   and inf.refinfo = e.refelem
		   and lbl.chemin = e.libelle
		   and lbl.langue = indCl.langue
		   and lbl.type = 'EXTRANET_CHRONO_LIBELLES'
   		   and indCL.refindividu not in
				(select entity_reference 
				   from cit_action_entity ety
				  where ety.action = 'PROACTIVE_COMM'
		            and ety.entity_type = 'REFINDIVIDU'
		            and ety.entity_reference = indCL.refindividu
		            and ety.direction = 'EXCLUDE')
	order by e.refdoss, commType desc	   
  ;
  r_main c_main%rowtype;
  
  cursor c_param
  is
    select effect_from_dat from cit_ksh_param
     where script = 'PROACTIVE_COMM'
  ;
  r_param c_param%rowtype;
   
begin
  dbms_output.put_line('Startprocess at ' || to_char(sysdate, 'DD/MM/YYYY HH24:MI:SS'));
  
  sql_output := UTL_FILE.FOPEN('CIT_TMP_FILE','proactive_comm.txt','w',32767);
  
  open c_param;
  fetch c_param into r_param;
  if c_param%found then
    l_from := r_param.effect_from_dat;
  else
    l_from := trunc(sysdate);
  end if;
  close c_param;
  
  dbms_output.put_line('  From date: ' || to_char(l_from, 'DD/MM/YYYY'));
  
  l_count := 0;
  prev_caseReference := NULL;
  prev_clientName := '';
  prev_clientEmail := '';
  prev_clientLanguage := '';
  prev_debtorName := '';
  prev_collectorName := '';
  prev_collectorEmail := '';
  prev_freeComment := '';
  prev_labelInfo := '';
  prev_claimsReference := '';
  prev_lblType := '';
  prev_commType := '';
  prev_countryUnit := '';
  
  for r_main in c_main(l_from)
  loop
    l_count := l_count + 1;

	if prev_caseReference is NULL
	then
		prev_caseReference := r_main.caseReference; 
		prev_clientName := r_main.clientName;
		prev_clientEmail := r_main.clientEmail;
		prev_clientLanguage := r_main.clientLanguage;
		prev_debtorName := r_main.debtorName;
		prev_collectorName := r_main.collectorName;
		prev_collectorEmail := r_main.collectorEmail;
		prev_freeComment := r_main.freeComment;
		prev_labelInfo := r_main.labelInfo;
		prev_claimsReference := r_main.claimsReference;
		prev_lblType := r_main.lblType;
		prev_commType := r_main.commType;
		prev_countryUnit := r_main.countryUnit;
	elsif r_main.caseReference = prev_caseReference 
		then
			if prev_commType <> 'SUMMARY'
			then
				prev_commType := 'MULTIPLE';
				
				if length(prev_freeComment) + length(r_main.freeComment) < 986
				then
					prev_freeComment := concat(prev_freeComment, '<br>---<br>');
					prev_freeComment := concat(prev_freeComment, r_main.freeComment);
				end if;	
			end	if;
	else
		dbms_output.put_line(prev_caseReference || '|' || prev_clientName || '|' || prev_clientEmail || '|' || prev_clientLanguage || '|' || prev_debtorName || '|' || prev_collectorName || '|' || prev_collectorEmail || '|' || prev_freeComment || '|' || prev_claimsReference || '|' || prev_commType || '|' || prev_countryUnit || '|' || prev_labelInfo || '|' );
	
		if prev_clientLanguage <> 'MX' or prev_claimsReference = ''
		then
			if substr(prev_lblType, 1, 3) = 'Tel'
			then
				utl_file.put_line(sql_output, prev_caseReference || '|' || prev_clientName || '|' || prev_clientEmail || '|' || prev_clientLanguage || '|' || prev_debtorName || '|' || prev_collectorName || '|' || prev_collectorEmail || '|' || prev_lblType || '|' || prev_claimsReference || '|' || prev_commType || '|' || prev_countryUnit || '|' || prev_labelInfo || '|');
			else
				utl_file.put_line(sql_output, prev_caseReference || '|' || prev_clientName || '|' || prev_clientEmail || '|' || prev_clientLanguage || '|' || prev_debtorName || '|' || prev_collectorName || '|' || prev_collectorEmail || '|' || prev_freeComment || '|' || prev_claimsReference || '|' || prev_commType || '|' || prev_countryUnit || '|' || prev_labelInfo || '|');
			end if;
		end if;
		
		prev_caseReference := r_main.caseReference; 
		prev_clientName := r_main.clientName;
		prev_clientEmail := r_main.clientEmail;
		prev_clientLanguage := r_main.clientLanguage;
		prev_debtorName := r_main.debtorName;
		prev_collectorName := r_main.collectorName;
		prev_collectorEmail := r_main.collectorEmail;
		prev_freeComment := r_main.freeComment;
		prev_labelInfo := r_main.labelInfo;
		prev_claimsReference := r_main.claimsReference;
		prev_lblType := r_main.lblType;
		prev_commType := r_main.commType;
		prev_countryUnit := r_main.countryUnit;
	end if;   
	
  end loop;
  
  if prev_caseReference is not NULL
  then
	if prev_clientLanguage <> 'MX' or prev_claimsReference = ''
	then
		if substr(prev_lblType, 1, 3) = 'Tel'
		then
			utl_file.put_line(sql_output, prev_caseReference || '|' || prev_clientName || '|' || prev_clientEmail || '|' || prev_clientLanguage || '|' || prev_debtorName || '|' || prev_collectorName || '|' || prev_collectorEmail || '|' || prev_lblType || '|' || prev_claimsReference || '|' || prev_commType || '|' || prev_countryUnit || '|' || prev_labelInfo || '|');		
		else
			utl_file.put_line(sql_output, prev_caseReference || '|' || prev_clientName || '|' || prev_clientEmail || '|' || prev_clientLanguage || '|' || prev_debtorName || '|' || prev_collectorName || '|' || prev_collectorEmail || '|' || prev_freeComment || '|' || prev_claimsReference || '|' || prev_commType || '|' || prev_countryUnit || '|' || prev_labelInfo || '|');		
		end if;
	end if;	
  end if;	
	
  UTL_FILE.FCLOSE(sql_output);

  dbms_output.put_line('Number found: ' || l_count); 
  dbms_output.put_line('End process at ' || to_char(sysdate, 'DD/MM/YYYY HH24:MI:SS'));

  update cit_ksh_param
    set effect_from_dat = trunc(sysdate) 
  where script = 'PROACTIVE_COMM';
  commit;

  return_code := 1;

-- Gestion des erreurs pour UTL_FILE---------------------

EXCEPTION
  WHEN UTL_FILE.INVALID_PATH THEN
    return_code := -10;
   DBMS_OUTPUT.PUT_LINE('error: ' || return_code || ' - ' || sqlerrm);
  WHEN UTL_FILE.INVALID_MODE THEN
    return_code := -11;
    DBMS_OUTPUT.PUT_LINE('error: ' || return_code );
  WHEN UTL_FILE.INVALID_OPERATION THEN
    return_code := -12;
   DBMS_OUTPUT.PUT_LINE('error: ' || return_code );
  WHEN UTL_FILE.WRITE_ERROR THEN
    return_code := -13;
    DBMS_OUTPUT.PUT_LINE('error: ' || return_code );
  WHEN UTL_FILE.INVALID_FILEHANDLE THEN
    DBMS_OUTPUT.PUT_LINE('error: ' || return_code );
   RETURN;
/*  WHEN OTHERS THEN
    IF UTL_FILE.IS_OPEN(filehandle) THEN
      UTL_FILE.FCLOSE(filehandle);
    END IF;
    return_code := -1;
    DBMS_OUTPUT.PUT_LINE('error: ' || return_code );
*/
end;
/

exit; 










