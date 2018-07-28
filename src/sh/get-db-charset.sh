#!/bin/sh

sqlplus -S / as sysdba <<EOT

whenever sqlerror exit failure

column parameter format a20
column value     format a20

SELECT PARAMETER, VALUE FROM NLS_DATABASE_PARAMETERS WHERE PARAMETER = 'NLS_CHARACTERSET';

exit 0
EOT
