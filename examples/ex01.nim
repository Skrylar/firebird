
import ../firebird3

var status_vector: STATUS_ARRAY
var db: db_handle
var transaction: tr_handle

block thingdo:
  if dsql_execute_immediate(status_vector, db, transaction, "create database 'ex01.fdb'") != 0:
    echo "Failed to create database."
    break thingdo

  commit_transaction(status_vector, transaction)
  detach_database(status_vector, db)
