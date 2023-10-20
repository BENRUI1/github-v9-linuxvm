

create or replace function cit_checkclosedcase (p_refdoss in varchar2) 
return varchar2
is
  l_return varchar2(1);
begin
  begin
    select decode(stratif, 'I',  'Y'
                         , 'S',  'Y'
                         , 'P',  'Y'
                         , 'AI', 'Y'
                         , 'AS', 'Y'
                         , 'N')
     into l_return 
     from g_dossier 
     where refdoss = p_refdoss
    ;
  exception when NO_DATA_FOUND THEN 
    l_return := 'N';
  end;
  --dbms_output.put_line ('Result: ' || l_return);
  return l_return;
end;
/

grant all on cit_checkclosedcase to public;

create or replace function cit_date_close(p_refdoss in varchar2)
  return date
is
 l_return date;
begin
 begin
   select max(e.dtassoc_dt)
     into l_return
     from g_dossier d
         ,t_elements e
    where 1= 1
      and d.refdoss = p_refdoss
      and (
           d.stratif    = 'I'
           or d.stratif = 'S'
           or d.stratif = 'P'
           or d.stratif = 'AI'
           or d.stratif = 'AS'
          ) 
      and e.refdoss = d.refdoss
      and e.typeelem='ce'
      and (
           e.nom = 'I'
           or e.nom = 'S'
           or e.nom = 'P'
          )
    ;
 exception when NO_DATA_FOUND THEN 
   l_return := null;
 end;
 return l_return;
end;
/


grant all on cit_date_close to public;