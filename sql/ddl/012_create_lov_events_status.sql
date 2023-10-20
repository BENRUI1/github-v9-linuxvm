create table LOV_EVENTS_STATUS
(
  code                      varchar2(3 char),
  abrev                     varchar2(200 char),
  description               varchar2(200 char)
)
tablespace DATA;

grant ALL on LOV_EVENTS_STATUS to PUBLIC;

begin
insert into LOV_EVENTS_STATUS (code, abrev, description) values('1', 'NEW','Event to be processed');
insert into LOV_EVENTS_STATUS (code, abrev, description) values('2', 'IN PROGRESS','Event selected and in process');
insert into LOV_EVENTS_STATUS (code, abrev, description) values('3', 'SUCCESS','Event successfully processed');
insert into LOV_EVENTS_STATUS (code, abrev, description) values('4', 'ERROR','Event not processed because an error occurred');
insert into LOV_EVENTS_STATUS (code, abrev, description) values('5', 'N/A','Event NOT to be processed');
commit;
end;