
import ../firebird3

var status_vector: STATUS_ARRAY
var db: db_handle
var transaction: tr_handle

try:
  dsql_execute_immediate(status_vector, db, transaction, "create database 'ex01.fdb'")
except FirebirdException:
  echo "Failed to create database.  Perhaps 'ex01.fdb' already exists?"
  raise

detach_database(status_vector, db)
