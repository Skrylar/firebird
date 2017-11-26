
import ../firebird3

var status_vector: STATUS_ARRAY
var db: db_handle
var transaction: tr_handle

try:
  dsql_execute_immediate(status_vector, db, transaction, "create database 'ex03.fdb'")
except FirebirdException:
  let e = (ref FirebirdException)(getCurrentException())
  echo "Failed to create database:"
  e.status.print
  raise
assert db != 0

# deal with the database schema
start_transaction(status_vector, transaction, db)
assert transaction != 0

try:
  dsql_execute_immediate(status_vector, db, transaction, "create table birds(wings int, name varchar(30))")
  commit_transaction(status_vector, transaction)
except FirebirdException:
  rollback_transaction(status_vector, transaction)
  let e = (ref FirebirdException)(getCurrentException())
  echo "Writing test schema failed; Firebird error:"
  e.status.print()
  raise

start_transaction(status_vector, transaction, db)
assert transaction != 0

try:
  # insert some data
  dsql_execute_immediate(status_vector, db, transaction, "insert into birds values (2, 'pigeon')")
  dsql_execute_immediate(status_vector, db, transaction, "insert into birds values (2, 'seagull')")
  dsql_execute_immediate(status_vector, db, transaction, "insert into birds values (7, 'hot')")
  commit_transaction(status_vector, transaction)
except FirebirdException:
  let e = (ref FirebirdException)(getCurrentException())
  rollback_transaction(status_vector, transaction)
  echo "Writing test data failed; Firebird error:"
  e.status.print()
  raise

var outx = make_xsqlda(5)
var stmt: stmt_handle
start_transaction status_vector, transaction, db
dsql_allocate_statement status_vector, db, stmt
assert stmt != 0

# now lets ask for the data back
try:
  dsql_prepare status_vector, transaction, stmt, "select wings, name from birds", SQL_DIALECT_CURRENT, outx
  assert stmt != 0
  assert outx.sqld == 2

  var nameind, wingsind: cshort # checks if the values are NULL
  var wings: int32
  outx.connect 0, addr wings, addr wingsind

  var name = newstring(30)
  outx.connect_varchar 1, name, addr nameind

  dsql_execute status_vector, transaction, stmt

  try:
    while true:
      dsql_fetch(status_vector, stmt, SQL_DIALECT_CURRENT, outx)
      assert outx.sqld == 2
      echo wings, ": ", $outx[1]
  except FirebirdException:
    discard                     # we've run out of records, probably

  commit_transaction status_vector, transaction
except FirebirdException:
  let e = (ref FirebirdException)(getCurrentException())
  echo "Reading test data failed; Firebird error:"
  e.status.print()
  raise
finally:
  outx.free false
  dsql_free_statement(status_vector, stmt, DSQL_DROP)

detach_database(status_vector, db)
