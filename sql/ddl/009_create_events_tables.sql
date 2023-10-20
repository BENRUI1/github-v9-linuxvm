create table EVENTS_ITF_CONSUMER
(
    id                            number                          not null,
    interface_code                varchar2(20 char)               not null,
    action                        varchar2(20 char)               not null,
    active                        char(1),
    description                   varchar2(200 char)
)
tablespace DATA
;

create table EVENTS_QUEUE
(
    id                            number                          not null,
    interface_code                varchar2(20 char)               not null,
    action                        varchar2(20 char)               not null,
    external_id                   number                          not null,
    refdoss                       varchar2(10 char),
    refindividu                   varchar2(10 char),
    refelem                       varchar2(10 char),
    typeelem                      varchar2(4 char),
    creation_date                 timestamp,
    export_date                   timestamp,
    rejected_reason               varchar2(50 char),
    rejected_date                 timestamp,
    detail_1                      varchar2(200 char),
    detail_2                      varchar2(200 char),
    detail_3                      varchar2(200 char),
    detail_4                      varchar2(200 char),
    detail_5                      varchar2(200 char),
    mt_detail_1                   varchar2(200 char),
    mt_detail_2                   varchar2(200 char),
    dt_detail_1                   date,
    dt_detail_2                   date,
    event_handling_status         varchar2(10),
    event_rejected_reason         varchar2(200 char),
    event_handling_timestamp      timestamp
)
tablespace DATA
;

grant ALL on EVENTS_ITF_CONSUMER to PUBLIC;
grant ALL on EVENTS_QUEUE to PUBLIC;

