
{.passl: "-lfbembed".}

import ../firebird3

var status_vector: STATUS_ARRAY
var db: db_handle
var transaction: tr_handle

block thingdo:
  # create test database
  if dsql_execute_immediate(status_vector, db, transaction, "create database 'ex02.fdb'") != 0:
    echo "Failed to create database."
    break thingdo
  commit_transaction(status_vector, transaction)
  detach_database(status_vector, db)

  if attach_database(status_vector, "ex02.fdb", db) != 0:
    echo "Failed to attach database."
    break thingdo

  start_transaction(status_vector, transaction, db)
  dsql_execute_immediate(status_vector, db, transaction, "CREATE TABLE things(when: DATE)")
  commit_transaction(status_vector, db)

  detach_database(status_vector, db)
