
CREATE TABLE CIT_DEBUG_MESSAGES
(
  USERNAME   VARCHAR2(30 CHAR)                  NOT NULL,
  TEXT       VARCHAR2(200 CHAR),
  TIMESTAMP  DATE                               NOT NULL,
  SEQ        NUMBER(8)                          NOT NULL
)
TABLESPACE DATA
;

grant all on CIT_DEBUG_MESSAGES to public;

CREATE OR REPLACE package cit_debug as
  cursor get_seq is
     select nvl(max(seq),0)
     from cit_debug_messages
     where username = user;
  global_seq number;
  procedure write (p_message in varchar2);
  procedure pop_seq;
end;
/

CREATE OR REPLACE package body cit_debug as
  procedure pop_seq is
  begin
     if global_seq is null then
        open get_seq;
        fetch get_seq into global_seq;
        close get_seq;
     end if;

     global_seq := global_seq+1;
  end;

  procedure write (p_message in varchar2) is
      PRAGMA AUTONOMOUS_TRANSACTION;

   begin
      pop_seq;
      insert into cit_debug_messages(
         username,
         text,
         timestamp,
         seq
         )
      values (
         user,
         SUBSTR(p_message,1,200),
         sysdate,
         global_seq);
      commit;
   end;
end;
/

grant all on cit_debug to public;
