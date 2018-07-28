#!/bin/sh

sqlplus / as sysdba <<EOT

whenever sqlerror exit failure

SELECT PARAMETER, VALUE FROM NLS_DATABASE_PARAMETERS WHERE PARAMETER = 'NLS_CHARACTERS;

exit 0
EOT
