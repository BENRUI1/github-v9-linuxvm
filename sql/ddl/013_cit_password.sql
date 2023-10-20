
create or replace function cit_get_pass (the_pass VARCHAR2) 
    RETURN VARCHAR2 IS
    --function returning the real scripted password
    lencode number;
    encours number;
    i       number;
    password  varchar2(50);
  begin
    password:='';
    if the_pass is null then return null;end if;
      lencode:=length(the_pass);
      for i in reverse lencode/2+1..lencode LOOP
      if substr(the_pass,i,1)>='a' then
        if substr(the_pass,lencode-i+1,1)>='a' then
          password:=chr(ascii((substr(the_pass,i,1))+10-ascii('a'))*16+ascii(substr(the_pass,lencode-i+1,1))+10-ascii('a'))||password;
        else
          password:=chr(ascii((substr(the_pass,i,1))+10-ascii('a'))*16+substr(the_pass,lencode-i+1,1))||password;
        end if;
      else
        if substr(the_pass,lencode-i+1,1)>='a' then
          password:=chr(substr(the_pass,i,1)*16+ascii(substr(the_pass,lencode-i+1,1))+10-ascii('a'))||password;
        else
          password:=chr(substr(the_pass,i,1)*16+substr(the_pass,lencode-i+1,1))||password;
        end if;
      end if;
    end loop;
    return password;
    exception when others then return null;
end;

grant all on cit_get_pass to public;


create or replace function cit_put_pass (valeur in VARCHAR2)
   --function returning a scripted password
   RETURN VARCHAR2
  IS
    code varchar2(50) := ''; 
    encours number := 0;
    i number ;
    v1 number ;
    tmp varchar2(10) := '';
  BEGIN
      i := 1; 
      WHILE i <= NVL(LENGTH(valeur), 0) 
      LOOP 
         encours := ASCII(SUBSTR(valeur,i,1)); 
         v1 := FLOOR(encours / 16); 
         IF (v1>9) 
         THEN 
            tmp := CHR(ASCII('a') + v1 - 10); 
         ELSE 
            tmp := TO_CHAR(v1); 
         END IF; 
         v1 := encours - 16 * v1;
         IF (v1>9) 
         THEN 
            tmp := tmp||CHR(ASCII('a') + v1 - 10); 
         ELSE 
            tmp := tmp||TO_CHAR(v1); 
         END IF; 
         code := SUBSTR(tmp,2,1)||code||SUBSTR(tmp,1,1); 
         i := i + 1; 
      END LOOP;
     return code;
     exception when others then return null;
END;

grant all on cit_put_pass to public;
