
{.passl: "-lfbembed".}

import ../firebird3

var status_vector: ISC_STATUS_ARRAY
var db: isc_db_handle
var transaction: isc_tr_handle

block thingdo:
  if isc_dsql_execute_immediate(status_vector, db, transaction, "create database 'ex01.fdb'") != 0:
    echo "Failed to create database."
    break thingdo

  isc_commit_transaction(status_vector, transaction)
  isc_detach_database(status_vector, db)
