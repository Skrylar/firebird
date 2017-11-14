
{.passl: "-lfbembed".}

import ../firebird3

var status_vector: ISC_STATUS_ARRAY
var db: isc_db_handle
var transaction: isc_tr_handle

block thingdo:
  # create test database
  if isc_dsql_execute_immediate(status_vector, db, transaction, "create database 'ex02.fdb'") != 0:
    echo "Failed to create database."
    break thingdo
  isc_commit_transaction(status_vector, transaction)
  isc_detach_database(status_vector, db)

  if isc_attach_database(status_vector, "ex02.fdb", db) != 0:
    echo "Failed to attach database."
    break thingdo

  isc_start_transaction(status_vector, transaction, db)
  isc_dsql_execute_immediate(status_vector, db, transaction, "CREATE TABLE things(when: DATE)")
  isc_commit_transaction(status_vector, db)

  isc_detach_database(status_vector, db)
