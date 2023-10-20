

--LANGUAGE	Varchar2(2)	N
--VALUE	Varchar2(2000)	Y

CREATE TABLE LOV_CIT_SCRIPTS
(
  SCRIPT                VARCHAR2(100 CHAR)              NOT NULL,
  TYPE                  VARCHAR2(100 CHAR)              NOT NULL,
  ENV                   VARCHAR2(10 CHAR),
  HD                    VARCHAR2(10 CHAR),
  COUNTRY               VARCHAR2(3 CHAR),
  LANGUAGE              VARCHAR2(2 CHAR),
  VALUE                 VARCHAR2(2000 CHAR)              NOT NULL
)
TABLESPACE DATA
;

GRANT all ON LOV_CIT_SCRIPTS to public;

