
import ../firebird3

var status_vector: STATUS_ARRAY
var db: db_handle
var transaction: tr_handle

try:
  dsql_execute_immediate(status_vector, db, transaction, "create database 'ex02.fdb'")
except FirebirdException:
  echo "Failed to create database.  Perhaps 'ex02.fdb' already exists?"
  raise
assert db != 0

start_transaction(status_vector, transaction, db)
assert transaction != 0

try:
  dsql_execute_immediate(status_vector, db, transaction, "create table birds(wings int, name varchar(30))")
  commit_transaction(status_vector, transaction)
except FirebirdException:
  rollback_transaction(status_vector, transaction)
  echo "Transaction failed."

detach_database(status_vector, db)
