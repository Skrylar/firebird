
{.passc: staticExec("fb_config --cflags").}
{.passl: "-lfbclient".}

assert int.sizeof == pointer.sizeof

const
  ibase_h = "ibase.h"

  FB_API_VER* {.importc, header: ibase_h.} = 30
  isc_version4* {.importc, header: ibase_h.} = 1
  ISC_FAR* {.importc, header: ibase_h.} = 1
  ISC_TRUE* {.importc, header: ibase_h.} = 1
  ISC_FALSE* {.importc, header: ibase_h.} = 0

#* API handles                                                    */
#******************************************************************/

# TODO is this right?
when defined(amd64):
  type
    FB_API_HANDLE* {.importc, header: ibase_h.} = cuint
else:
  type
    FB_API_HANDLE* {.importc, header: ibase_h.} = pointer

#* Sizes of memory blocks                                         */
#******************************************************************/

# TODO should probably tell the user about this?

when defined(fb_use_size_t):
  type
    FB_SIZE_T* {.importc, header: ibase_h.} = csize
    FB_SSIZE_T* {.importc, header: ibase_h.} = int
else:
  type
    FB_SIZE_T* {.importc, header: ibase_h.} = cuint
    FB_SSIZE_T* {.importc, header: ibase_h.} = cint

#* Status vector                                                  */
#******************************************************************/

const
  STATUS_LENGTH* {.importc: "ISC_STATUS_LENGTH", header: ibase_h.} = 20
  FB_SQLSTATE_LENGTH* {.importc, header: ibase_h.} = 5
  FB_SQLSTATE_SIZE* {.importc, header: ibase_h.} = (FB_SQLSTATE_LENGTH + 1)

type
  STATUS* {.importc: "ISC_STATUS", header: ibase_h.} = int # XXX Araq says nim int is always the same size as pointer
  STATUS_ARRAY* = array[0..(STATUS_LENGTH-1), STATUS]
  FB_SQLSTATE_STRING* = array[0..(FB_SQLSTATE_SIZE-1), cchar]

type
  FirebirdException* = object of Exception
    status*: STATUS_ARRAY

proc new_firebird_exception*(status: var STATUS_ARRAY): ref FirebirdException {.inline.} =
  # TODO interrogate error vector for a proper string
  result = newexception(FirebirdException, "Firebird error.")
  for x in low(result.status)..high(result.status):
    result.status[x] = status[x]

#* Define type, export and other stuff based on c/c++ and Windows */
#******************************************************************/

const
  FB_FALSE* {.importc, header: ibase_h.} = 0.cchar
  FB_TRUE* {.importc, header: ibase_h.} = 1.cchar

type
  #ISC_LONG* {.importc, header: ibase_h.} = int32
  #ISC_ULONG* {.importc, header: ibase_h.} = uint32
  #ISC_SHORT* {.importc, header: ibase_h.} = cshort
  #ISC_USHORT* {.importc, header: ibase_h.} = cushort
  #ISC_UCHAR* {.importc, header: ibase_h.} = cuchar
  #ISC_SCHAR* {.importc, header: ibase_h.} = cchar
  FB_BOOLEAN* {.importc, header: ibase_h.} = cuchar

#* 64 bit Integers                                                 */
#*******************************************************************/

#type
#ISC_INT64* {.importc, header: ibase_h.} = int64
#ISC_UINT64* {.importc, header: ibase_h.} = uint64

#* Time & Date support                                             */
#*******************************************************************/

type
  DATE* {.importc: "ISC_DATE", header: ibase_h.} = cint
  TIME* {.importc: "ISC_TIME", header: ibase_h.} = cuint

  TIMESTAMP* {.importc: "ISC_TIMESTAMP", header: ibase_h.} = object
    timestamp_date*: DATE
    timestamp_time*: TIME

#* Blob Id support                                                 */
#*******************************************************************/

type
  QUAD_t* {.importc: "GDS_QUAD", header: ibase_h.} = object
    # NB these were aliased from isc_quad_*, but nim doesn't have #define
    gds_quad_high*: int32
    gds_quad_low*: uint32

  GDS_QUAD* = QUAD_t
  ISC_QUAD* = QUAD_t

  FB_SHUTDOWN_CALLBACK* {.importc, header: ibase_h.} = proc(reason, mask: cint; arg: pointer): cint

#* Firebird Handle Definitions */
#********************************/

type
  att_handle* = FB_API_HANDLE
  blob_handle* = FB_API_HANDLE
  db_handle* = FB_API_HANDLE
  req_handle* = FB_API_HANDLE
  stmt_handle* = FB_API_HANDLE
  svc_handle* = FB_API_HANDLE
  tr_handle* = FB_API_HANDLE
  resv_handle* = int32

  callback* {.importc: "isc_callback", header: ibase_h.} = proc()
  PRINT_CALLBACK* {.importc: "ISC_PRINT_CALLBACK", header: ibase_h.} = proc(a: pointer; b: cshort; c: cstring)
  VERSION_CALLBACK* {.importc: "ISC_VERSION_CALLBACK", header: ibase_h.} = proc(a: pointer; b: cstring)
  EVENT_CALLBACK* {.importc: "ISC_EVENT_CALLBACK", header: ibase_h.} = proc(a: pointer; b: cushort; c: ptr cuchar)

#* Blob id structure                                               */
#*******************************************************************/

type
  ARRAY_BOUND* {.importc: "ISC_ARRAY_BOUND", header: ibase_h.} = object
    array_bound_lower*: cshort
    array_bound_upper*: cshort

  ARRAY_DESC* {.importc: "ISC_ARRAY_DESC", header: ibase_h.} = object
    array_desc_dtype*: cuchar
    array_desc_scale*: cchar
    array_desc_length*: cushort
    array_desc_field_name*: array[0..31, cchar]
    array_desc_relation_name*: array[0..31, cchar]
    array_desc_dimensions*: cshort
    array_desc_flags*: cshort
    array_desc_bounds*: array[0..15, ARRAY_BOUND]

  BLOB_DESC* {.importc: "ISC_BLOB_DESC", header: ibase_h.} = object
    blob_desc_subtype*: cshort
    blob_desc_charset*: cshort
    blob_desc_segment_size*: cshort
    blob_desc_field_name*: array[0..31, cuchar]
    blob_desc_relation_name*: array[0..31, cuchar]

#* Blob control structure  */
#***************************/

type
  blob_ctl_obj* {.importc: "struct isc_blob_ctl", header: ibase_h.} = object
    ctl_source*: proc(): STATUS
    ctl_source_handle*: ptr blob_ctl_obj
    ctl_to_sub_type*: cshort
    ctl_from_sub_type*: cshort
    ctl_buffer_length*: cushort
    ctl_segment_length*: cushort
    ctl_bpb_length*: cushort
    ctl_bpb*: cstring
    ctl_buffer*: ptr cuchar
    ctl_max_segment*: int32
    ctl_number_segments*: int32
    ctl_total_length*: int32
    ctl_status*: ptr STATUS
    ctl_data*: array[0..7, clong]

  BLOB_CTL* = ptr blob_ctl_obj

#* Blob stream definitions */
#***************************/

type
  BSTREAM* {.importc: "struct bstream", header: ibase_h.} = object
    bstr_blob*: blob_handle
    bstr_buffer*: cstring
    bstr_ptr*: cstring
    bstr_length*: cshort
    bstr_cnt*: cshort
    bstr_mode*: cchar

  FB_BLOB_STREAM* = ptr BSTREAM

#define getb(p) (--(p)->bstr_cnt >= 0 ? *(p)->bstr_ptr++ & 0377: BLOB_get (p))
#define putb(x, p) (((x) == '\n' || (!(--(p)->bstr_cnt))) ? BLOB_put ((x),p) : ((int) (*(p)->bstr_ptr++ = (unsigned) (x))))
#define putbx(x, p) ((!(--(p)->bstr_cnt)) ? BLOB_put ((x),p) : ((int) (*(p)->bstr_ptr++ = (unsigned) (x))))

type
  blob_lseek_mode* {.importc, header: ibase_h.} = cint
const
  blb_seek_relative* = 1
  blb_seek_from_tail* = 2

type
  blob_get_result* {.importc, header: ibase_h.} = cint
const
  blb_got_fragment* = -1
  blb_got_eof* = 0
  blb_got_full_segment* = 1

type
  blobcallback_obj* {.importc: "struct blobcallback", header: ibase_h.} = object
    blob_get_segment*: proc(hnd: pointer; buffer: ptr cuchar; buf_size: cushort; result_len: ptr cushort): cshort
    blob_handle*: pointer
    blob_number_segments*: int32
    blob_max_segment*: int32
    blob_total_length*: int32
    blob_put_segment*: proc(hnd: pointer; buffer: ptr cuchar; buf_size: cushort)
    blob_lseek*: proc(hnd: pointer; mode: cushort; offset: int32): int32

  BLOBCALLBACK* = ptr blobcallback_obj

  PARAMDSC* {.importc, header: ibase_h.} = object
    dsc_dtype*: cuchar
    dsc_scale*: int8
    dsc_length*: cushort
    dsc_sub_type*: cshort
    dsc_flags*: cushort
    dsc_address*: ptr cuchar

  PARAMVARY* {.importc, header: ibase_h.} = object
    vary_length*: cushort
    vary_string*: array[0..0, cuchar]

const
  DSC_null*        = 1
  DSC_no_subtype*  = 2
  DSC_nullable*    = 4
  dtype_unknown*   = 0
  dtype_text*      = 1
  dtype_cstring*   = 2
  dtype_varying*   = 3
  dtype_packed*    = 6
  dtype_byte*      = 7
  dtype_short*     = 8
  dtype_long*      = 9
  dtype_quad*      = 10
  dtype_real*      = 11
  dtype_double*    = 12
  dtype_d_float*   = 13
  dtype_sql_date*  = 14
  dtype_sql_time*  = 15
  dtype_timestamp* = 16
  dtype_blob*      = 17
  dtype_array*     = 18
  dtype_int64*     = 19
  dtype_dbkey*     = 20
  dtype_boolean*   = 21
  DTYPE_TYPE_MAX*  = 22
  TIME_SECONDS_PRECISION*       = 10000
  TIME_SECONDS_PRECISION_SCALE* = -4

#* Dynamic SQL definitions */
#***************************/

type
  # SK: turned in to an enum for nimization
  StatementFreeType* = enum
    DSQL_close      = 1
    DSQL_drop       = 2
    DSQL_unprepare  = 4

const
  SQLDA_VERSION1*  = 1

type
  XSQLVAR* {.importc, header: ibase_h.} = object
    sqltype*: cshort
    sqlscale*: cshort
    sqlsubtype*: cshort
    sqllen*: cshort
    sqldata*: pointer
    sqlind*: ptr cshort
    sqlname_length*: cshort
    sqlname*: array[0..31, cchar]
    relname_length*: cshort
    relname*: array[0..31, cchar]
    ownname_length*: cshort
    ownname*: array[0..31, cchar]
    aliasname_length*: cshort
    aliasname*: array[0..31, cchar]

  PXSQLVAR* = ptr XSQLVAR

  XSQLDA* {.importc, header: ibase_h.} = object
    version*: cshort
    sqldaid*: array[0..7, cchar]
    sqldabc*: int32
    sqln*: cshort # number of parameters allocated
    sqld*: cshort # number of parameters firebird wants to use
    sqlvar*: array[0..0, XSQLVAR]

  PXSQLDA* = ptr XSQLDA

const
  SQL_TEXT*                       =   452
  SQL_VARYING*                    =   448
  SQL_SHORT*                      =   500
  SQL_LONG*                       =   496
  SQL_FLOAT*                      =   482
  SQL_DOUBLE*                     =   480
  SQL_D_FLOAT*                    =   530
  SQL_TIMESTAMP*                  =   510
  SQL_BLOB*                       =   520
  SQL_ARRAY*                      =   540
  SQL_QUAD*                       =   550
  SQL_TYPE_TIME*                  =   560
  SQL_TYPE_DATE*                  =   570
  SQL_INT64*                      =   580
  SQL_BOOLEAN*                    = 32764
  SQL_NULL*                       = 32766
  SQL_DATE*                       =   SQL_TIMESTAMP

template XSQLDA_LENGTH*(n: int): int =
  XSQLDA.sizeof + ((n - 1) * XSQLVAR.sizeof)

proc `[]`* (self: PXSQLDA; index: int): PXSQLVAR =
  # bounds checking
  assert index >= 0
  assert index < self.sqln
  # return the thing
  var x = cast[int](unsafeaddr self.sqlvar[0])
  inc x, (XSQLVAR.sizeof) * index
  result = cast[PXSQLVAR](x)

proc make_xsqlda*(vars: int): PXSQLDA =
  result = cast[PXSQLDA](alloc(XSQLDA_LENGTH(vars)))
  result.version = SQLDA_VERSION1
  result.sqln = vars.cshort
  result.sqld = vars.cshort

proc free*(self: PXSQLDA; dealloc_children: bool = true) =
  # free potentially allocated data; if you are doing cheeky things,
  # like using pointers to local value buffers, you will want this to
  # be false.
  if dealloc_children:
    for i in 0..<self.sqln:
      let here = self[i]
      if here.sqldata != nil:
        dealloc(here.sqldata)
      if here.sqlind != nil:
        dealloc(here.sqlind)
  # now ditch the object
  dealloc(self)

template connect*(self: PXSQLDA; index: int; value: ptr clong; ind: ptr cshort) =
  assert index >= 0
  assert index < self.sqln
  let here = self[index]
  here.sqltype = SQL_LONG + 1
  here.sqllen = clong.sizeof.int16
  here.sqldata = cast[pointer](value)
  here.sqlind = ind

template connect_char*(self: PXSQLDA; index: int; value: var string; ind: ptr cshort) =
  assert index >= 0
  assert index < self.sqln
  let here = self[index]
  here.sqltype = SQL_TEXT + 1
  here.sqllen = value.len.int16
  here.sqldata = value[0].addr
  here.sqlind = ind

template connect_varchar*(self: PXSQLDA; index: int; value: var string; ind: ptr cshort) =
  assert index >= 0
  assert index < self.sqln
  let here = self[index]
  here.sqltype = SQL_VARYING + 1
  here.sqllen = value.len.int16 - cshort.sizeof.int16
  here.sqldata = value[0].addr
  here.sqlind = ind

proc `$`*(self: PXSQLVAR): string =
  case (self.sqltype - 1)
  of SQL_VARYING:
    let sl = cast[ptr cshort](self.sqldata)[]
    result = newstring(sl.int)
    for i in 0..<sl:
      # i'm sure this _totally_ won't become a performance issue someday
      result[i] = cast[ptr char](cast[int](self.sqldata)+i+cshort.sizeof)[]
  else:
    result = "<Unknown Firebird type.>"

#define XSQLDA_LENGTH(n)        (sizeof (XSQLDA) + (n - 1) * sizeof (XSQLVAR))


#* SQL Dialects            */
#***************************/

const
  SQL_DIALECT_V5*                = 1
  SQL_DIALECT_V6_TRANSITION*     = 2
  SQL_DIALECT_V6*                = 3
  SQL_DIALECT_CURRENT*           = SQL_DIALECT_V6

#* OSRI database functions */
#***************************/

proc attach_database(status: var STATUS_ARRAY; db_name_length: cshort; db_name: cstring; db: var db_handle; parm_buffer_length: cshort = 0; parm_buffer: cstring = nil): STATUS {.importc: "isc_attach_database", header: ibase_h.}

proc attach_database*(status_vector: var STATUS_ARRAY; db_name: cstring; db: var db_handle; parm_buffer_length: cshort = 0; parm_buffer: cstring = nil) {.inline.} =
  if attach_database(status_vector, 0, db_name, db, parm_buffer_length, parm_buffer) != 0:
    raise new_firebird_exception(status_vector)

# TODO STATUS isc_array_gen_sdl(status: var STATUS_ARRAY, const ARRAY_DESC*, cshort*, cuchar*, cshort*);

proc array_get_slice_inner(status: var STATUS_ARRAY; db: var db_handle; transaction: var tr_handle; array_id: var QUAD_t; desc: var ARRAY_DESC; buf: pointer; buflen: var int32): STATUS {.importc: "isc_array_get_slice", header: ibase_h.}

proc array_get_slice*(status: var STATUS_ARRAY; db: var db_handle; transaction: var tr_handle; array_id: var QUAD_t; desc: var ARRAY_DESC; buf: pointer; buflen: var int32) {.inline.} =
  if array_get_slice_inner(status, db, transaction, array_id, desc, buf, buflen) != 0:
    raise new_firebird_exception(status)

proc array_lookup_bounds_inner(status: var STATUS_ARRAY; db: var db_handle; transaction: var tr_handle; table_name, column_name: cstring; desc: var ARRAY_DESC): STATUS {.importc: "isc_array_lookup_bounds", header: ibase_h.}

proc array_lookup_bounds*(status: var STATUS_ARRAY; db: var db_handle; transaction: var tr_handle; table_name, column_name: cstring; desc: var ARRAY_DESC) {.inline.} =
  if array_lookup_bounds_inner(status, db, transaction, table_name, column_name, desc) != 0:
    raise new_firebird_exception(status)

# TODO STATUS isc_array_lookup_desc(status: var STATUS_ARRAY, db: var db_handle, transaction: var tr_handle, const cstring, const cstring, ARRAY_DESC*);
# TODO STATUS isc_array_set_desc(status: var STATUS_ARRAY, const cstring, const cstring, const short*, const short*, const short*, ARRAY_DESC*);

proc array_put_slice_inner(status: var STATUS_ARRAY; db: var db_handle; transaction: var tr_handle; array_id: var QUAD_t; desc: var ARRAY_DESC; buf: pointer; buflen: var int32): STATUS {.importc: "isc_array_put_slice", header: ibase_h.}

proc array_put_slice*(status: var STATUS_ARRAY; db: var db_handle; transaction: var tr_handle; array_id: var QUAD_t; desc: var ARRAY_DESC; buf: pointer; buflen: var int32) {.inline.} =
  if array_put_slice_inner(status, db, transaction, array_id, desc, buf, buflen) != 0:
    raise new_firebird_exception(status)

# TODO void isc_blob_default_desc(BLOB_DESC*, const cuchar*, const cuchar*);
# TODO STATUS isc_blob_gen_bpb(status: var STATUS_ARRAY, const BLOB_DESC*, const BLOB_DESC*, unsigned short, cuchar*, unsigned short*);
# TODO STATUS isc_blob_info(status: var STATUS_ARRAY, blob_handle*, short, const cstring, short, cstring);
# TODO STATUS isc_blob_lookup_desc(status: var STATUS_ARRAY, db: var db_handle, transaction: var tr_handle, const cuchar*, const cuchar*, BLOB_DESC*, cuchar*);
# TODO STATUS isc_blob_set_desc(status: var STATUS_ARRAY, const cuchar*, const cuchar*, short, short, short, BLOB_DESC*);
# TODO STATUS isc_cancel_blob(status: var STATUS_ARRAY, blob_handle *);

proc cancel_events_inner(status: var STATUS_ARRAY; db: var db_handle; event_id: var int32): STATUS {.importc: "isc_cancel_events", header: ibase_h.}

proc cancel_events*(status: var STATUS_ARRAY; db: var db_handle; event_id: var int32) {.inline.} =
  if cancel_events_inner(status, db, event_id) != 0:
    raise new_firebird_exception(status)

proc close_blob_inner(status: var STATUS_ARRAY; blob: var blob_handle): STATUS {.importc: "isc_close_blob", header: ibase_h.}

proc close_blob*(status: var STATUS_ARRAY; blob: var blob_handle) {.inline.} =
  if close_blob_inner(status, blob) != 0:
    raise new_firebird_exception(status)

# TODO STATUS isc_commit_retaining(status: var STATUS_ARRAY, tr_handle *);
proc commit_transaction_inner(status: var STATUS_ARRAY; transaction: var tr_handle): STATUS {.importc: "isc_commit_transaction", header: ibase_h, discardable.}

proc commit_transaction*(status: var STATUS_ARRAY; transaction: var tr_handle) {.inline.} =
  if commit_transaction_inner(status, transaction) != 0:
    raise new_firebird_exception(status)

proc create_blob_inner(status: var STATUS_ARRAY; db: var db_handle; transaction: var tr_handle; blob: var blob_handle; blob_id: var QUAD_t): STATUS {.importc: "isc_create_blob", header: ibase_h.}

proc create_blob*(status: var STATUS_ARRAY; db: var db_handle; transaction: var tr_handle; blob: var blob_handle; blob_id: var QUAD_t) {.inline.} =
  if create_blob_inner(status, db, transaction, blob, blob_id) != 0:
    raise new_firebird_exception(status)

proc create_blob_inner(status: var STATUS_ARRAY, db: var db_handle, transaction: var tr_handle; blob: var blob_handle; blob_id: var QUAD_t; bpb_len: cshort; bpb: cstring): STATUS {.importc: "isc_create_blob2", header: ibase_h.}

proc create_blob*(status: var STATUS_ARRAY, db: var db_handle, transaction: var tr_handle; blob: var blob_handle; blob_id: var QUAD_t; bpb_len: cshort; bpb: cstring) {.inline.} =
  if create_blob_inner(status, db, transaction, blob, blob_id, bpb_len, bpb) != 0:
    raise new_firebird_exception(status)

# TODO STATUS isc_create_database(status: var STATUS_ARRAY, short, const cstring, db: var isc_db_handle, short, const cstring, short);
# TODO STATUS isc_database_info(status: var STATUS_ARRAY, db: var db_handle, short, const cstring, short, cstring);
# TODO void isc_decode_date(const QUAD_t*, pointer);
# TODO void isc_decode_sql_date(const DATE*, pointer);
# TODO void isc_decode_sql_time(const TIME*, pointer);
# TODO void isc_decode_timestamp(const TIMESTAMP*, pointer);

proc detach_database_inner(status: var STATUS_ARRAY, db: var db_handle): STATUS {.importc: "isc_detach_database", header: ibase_h, discardable.}

proc detach_database*(status: var STATUS_ARRAY, db: var db_handle) {.inline.} =
  if detach_database_inner(status, db) != 0:
    raise new_firebird_exception(status)

# TODO STATUS isc_drop_database(status: var STATUS_ARRAY_ARRAY, db: var db_handle);

proc dsql_allocate_statement_inner(status: var STATUS_ARRAY; db: var db_handle; statement: var stmt_handle): STATUS {.importc: "isc_dsql_allocate_statement", header: ibase_h.}

proc dsql_alloc_statement2_inner(status: var STATUS_ARRAY; db: var db_handle; statement: var stmt_handle): STATUS {.importc: "isc_dsql_alloc_statement2", header: ibase_h.}

proc dsql_allocate_statement*(status: var STATUS_ARRAY; db: var db_handle; statement: var stmt_handle; autofree: bool = true) {.inline.} =
  var derp: STATUS
  if autofree:
    derp = dsql_allocate_statement_inner(status, db, statement)
  else:
    derp = dsql_alloc_statement2_inner(status, db, statement)
  if derp != 0:
    raise new_firebird_exception(status)

proc dsql_describe_inner(status: var STATUS_ARRAY; statement: var stmt_handle; dialect: cushort = SQL_DIALECT_CURRENT; outx: ptr XSQLDA): STATUS {.importc: "isc_dsql_describe", header: ibase_h.}

proc dsql_describe*(status: var STATUS_ARRAY; statement: var stmt_handle; dialect: cushort = SQL_DIALECT_CURRENT; outx: ptr XSQLDA) {.inline.} =
  if dsql_describe_inner(status, statement, dialect, outx) != 0:
    raise new_firebird_exception(status)

proc dsql_describe_bind_inner(status: var STATUS_ARRAY; statement: var stmt_handle; dialect: cushort = SQL_DIALECT_CURRENT; inx: ptr XSQLDA): STATUS {.importc: "isc_dsql_describe_bind", header: ibase_h.}

proc dsql_describe_bind*(status: var STATUS_ARRAY; statement: var stmt_handle; dialect: cushort = SQL_DIALECT_CURRENT; inx: ptr XSQLDA) {.inline.} =
  if dsql_describe_bind_inner(status, statement, dialect, inx) != 0:
    raise new_firebird_exception(status)

proc dsql_exec_immed2_inner(status: var; db: var; transaction: var; statement_length: cushort; statement: cstring; dialect: cushort = SQL_DIALECT_CURRENT; inx, outx: ptr XSQLDA = nil): STATUS {.importc: "isc_dsql_exec_immed2", header: ibase_h.}

proc dsql_exec_immed2*(status: var; db: var; transaction: var; statement_length: cushort; statement: cstring; dialect: cushort = SQL_DIALECT_CURRENT; inx, outx: ptr XSQLDA = nil): STATUS {.inline.} =
  if dsql_exec_immed2_inner(status, db, transaction, 0, statement, dialect, inx, outx) != 0:
    raise new_firebird_exception(status)

proc dsql_execute_inner(status: var STATUS_ARRAY; transaction: var tr_handle; statement: var stmt_handle; dialect: cushort = SQL_DIALECT_CURRENT; xsql: ptr XSQLDA = nil): STATUS {.importc: "isc_dsql_execute", header: ibase_h.}

proc dsql_execute*(status: var STATUS_ARRAY; transaction: var tr_handle; statement: var stmt_handle; dialect: cushort = SQL_DIALECT_CURRENT; xsql: ptr XSQLDA = nil) {.inline.} =
  if dsql_execute_inner(status, transaction, statement, dialect, xsql) != 0:
    raise new_firebird_exception(status)

proc dsql_execute_inner(status: var STATUS_ARRAY; transaction: var tr_handle; statement: var stmt_handle; dialect: cushort = SQL_DIALECT_CURRENT; inx, outx: ptr XSQLDA = nil): STATUS {.importc: "isc_dsql_execute2", header: ibase_h.}

proc dsql_execute*(status: var STATUS_ARRAY; transaction: var tr_handle; statement: var stmt_handle; dialect: cushort = SQL_DIALECT_CURRENT; inx, outx: ptr XSQLDA = nil) {.inline.} =
  if dsql_execute_inner(status, transaction, statement, dialect, inx, outx) != 0:
    raise new_firebird_exception(status)

proc dsql_execute_immediate(status: var STATUS_ARRAY; db: var db_handle; transaction: var tr_handle; length: cushort; query: cstring; dialect: cushort = SQL_DIALECT_CURRENT; xsql: ptr XSQLDA = nil): STATUS {.importc: "isc_dsql_execute_immediate", header: ibase_h.}

proc dsql_execute_immediate*(status: var STATUS_ARRAY; db: var db_handle; transaction: var tr_handle; query: cstring; dialect: cushort = SQL_DIALECT_CURRENT; xsql: ptr XSQLDA = nil) {.inline.} =
  if dsql_execute_immediate(status, db, transaction, 0, query, dialect, xsql) != 0:
    raise new_firebird_exception(status)

proc dsql_fetch_inner(status: var STATUS_ARRAY; statement: var stmt_handle; dialect: cushort = SQL_DIALECT_CURRENT; outx: ptr XSQLDA): STATUS {.importc: "isc_dsql_fetch", header: ibase_h.}

proc dsql_fetch*(status: var STATUS_ARRAY; statement: var stmt_handle; dialect: cushort = SQL_DIALECT_CURRENT; outx: ptr XSQLDA) {.inline.} =
  if dsql_fetch_inner(status, statement, dialect, outx) != 0:
    raise new_firebird_exception(status)

# TODO STATUS isc_dsql_finish(db: var db_handle);

proc dsql_free_statement_inner(status: var STATUS_ARRAY; statement: var stmt_handle; on_free: cushort): STATUS {.importc: "isc_dsql_free_statement", header: ibase_h.}

proc dsql_free_statement*(status: var STATUS_ARRAY; statement: var stmt_handle; on_free: StatementFreeType) {.inline.} =
  if dsql_free_statement_inner(status, statement, on_free.cushort) != 0:
    raise new_firebird_exception(status)

# TODO STATUS isc_dsql_insert(status: var STATUS_ARRAY, stmt_handle*, unsigned short, XSQLDA*);

proc dsql_prepare_inner(status: var STATUS_ARRAY; transaction: var tr_handle; statement_handle: var stmt_handle; statement_length: cushort; statement: cstring; dialect: cushort = SQL_DIALECT_CURRENT; xsql: var XSQLDA): STATUS {.importc: "isc_dsql_prepare", header: ibase_h.}

proc dsql_prepare*(status: var STATUS_ARRAY; transaction: var tr_handle; statement_handle: var stmt_handle; statement: cstring; dialect: cushort = SQL_DIALECT_CURRENT; xsql: var XSQLDA): STATUS {.inline.} =
  if dsql_prepare_inner(status, transaction, statement_handle, 0, statement, dialect, xsql) != 0:
    raise new_firebird_exception(status)

proc dsql_set_cursor_name_inner(status: var STATUS_ARRAY; statement: var stmt_handle; name: cstring; unused: cushort = 0): STATUS {.importc: "isc_dsql_set_cursor_name", header: ibase_h.}

proc dsql_set_cursor_name*(status: var STATUS_ARRAY; statement: var stmt_handle; name: cstring; unused: cushort = 0) {.inline.} =
  if dsql_set_cursor_name_inner(status, statement, name, unused) != 0:
    raise new_firebird_exception(status)

# TODO STATUS isc_dsql_sql_info(status: var STATUS_ARRAY, stmt_handle*, short, const cstring, short, cstring);
# TODO void isc_encode_date(const pointer, QUAD_t*);
# TODO void isc_encode_sql_date(const pointer, DATE*);
# TODO void isc_encode_sql_time(const pointer, TIME*);
# TODO void isc_encode_timestamp(const pointer, TIMESTAMP*);

proc event_block*(event_buf, result_buf: var cstring; name_count: cushort): int32 {.importc: "isc_event_block", header: ibase_h, varargs.}

# TODO cushort isc_event_block_a(cstring*, cstring*, cushort, cstring*);
# TODO void isc_event_block_s(cstring*, cstring*, cushort, cstring*, cushort*);
# TODO void isc_event_counts(uint32*, short, cuchar*, const cuchar *);
# TODO int isc_modify_dpb(cstring*, short*, unsigned short, const cstring, short); int32 isc_free(cchar *);

proc get_segment_inner(status: var STATUS_ARRAY; blob: var blob_handle; read_len: var cushort; blen: cushort; buf: ptr int8): STATUS {.importc: "isc_get_segment", header: ibase_h.}

proc get_segment*(status: var STATUS_ARRAY; blob: var blob_handle; read_len: var cushort; blen: cushort; buf: ptr int8) {.inline.} =
  if get_segment_inner(status, blob, read_len, blen, buf) != 0:
    raise new_firebird_exception(status)

# TODO STATUS isc_get_slice(status: var STATUS_ARRAY, db: var db_handle, transaction: var tr_handle, QUAD_t*, short, const cstring, short, const int32*, int32, pointer, int32*);
# TODO int32 fb_interpret(cstring, unsigned int, const status: var STATUS_ARRAY*);

proc open_blob_inner(status: var STATUS_ARRAY; db: var db_handle; transaction: var tr_handle; blob: var blob_handle; blob_id: var QUAD_t): STATUS {.importc: "isc_open_blob", header: ibase_h.}

proc open_blob*(status: var STATUS_ARRAY; db: var db_handle; transaction: var tr_handle; blob: var blob_handle; blob_id: var QUAD_t) {.inline.} =
  if open_blob_inner(status, db, transaction, blob, blob_id) != 0:
    raise new_firebird_exception(status)

# TODO STATUS isc_open_blob2(status: var STATUS_ARRAY, db: var db_handle, transaction: var tr_handle, blob_handle*, QUAD_t*, cushort, const cuchar*);

# TODO STATUS isc_prepare_transaction2(status: var STATUS_ARRAY, transaction: var tr_handle, cushort, const cuchar*);
# TODO void isc_print_sqlerror(cshort, const status: var STATUS_ARRAY);
# TODO STATUS isc_print_status(const status: var STATUS_ARRAY);

proc put_segment_inner(status: var STATUS_ARRAY; blob: var blob_handle; blen: cushort; buf: ptr int8): STATUS {.importc: "isc_put_segment", header: ibase_h.}

proc put_segment*(status: var STATUS_ARRAY; blob: var blob_handle; blen: cushort; buf: ptr int8) {.inline.} =
  if put_segment_inner(status, blob, blen, buf) != 0:
    raise new_firebird_exception(status)

# TODO STATUS isc_put_slice(status: var STATUS_ARRAY, db: var db_handle, transaction: var tr_handle, QUAD_t*, short, const cstring, short, const int32*, int32, pointer);

proc que_events_inner(status: var STATUS_ARRAY; db: var db_handle; event_id: var int32; eblen: cshort; eb: cstring; cb: EVENT_CALLBACK; userdata: pointer): STATUS {.importc: "isc_que_events", header: ibase_h.}

proc que_events*(status: var STATUS_ARRAY; db: var db_handle; event_id: var int32; eblen: cshort; eb: cstring; cb: EVENT_CALLBACK; userdata: pointer) {.inline.} =
  if que_events_inner(status, db, event_id, eblen, eb, cb, userdata) != 0:
    raise new_firebird_exception(status)

# TODO STATUS isc_rollback_retaining(status: var STATUS_ARRAY, transaction: var tr_handle);

proc rollback_transaction_inner(status: var STATUS_ARRAY; transaction: var tr_handle): STATUS {.importc: "isc_rollback_transaction", header: ibase_h, discardable.}

proc rollback_transaction*(status: var STATUS_ARRAY; transaction: var tr_handle) {.inline.} =
  if rollback_transaction_inner(status, transaction) != 0:
    raise new_firebird_exception(status)

# TODO STATUS isc_start_multiple(status: var STATUS_ARRAY, transaction: var tr_handle, short, void *);

proc start_transaction_inner(status: var STATUS_ARRAY; transaction: var tr_handle; handle_count: cshort; db: var db_handle; tpb_length: cushort; tpb: cstring): STATUS {.importc: "isc_start_transaction", header: ibase_h,}

proc start_transaction*(status: var STATUS_ARRAY; transaction: var tr_handle; db: var db_handle; tpb_length: cushort = 0; tpb: cstring = nil) {.inline.} =
  if start_transaction_inner(status, transaction, 1.cshort, db, tpb_length, tpb) != 0:
    raise new_firebird_exception(status)

# TODO STATUS fb_disconnect_transaction(status: var STATUS_ARRAY, transaction: var tr_handle);

proc sqlcode*(status: var STATUS_ARRAY): int32 {.importc: "isc_sqlcode", header: ibase_h.}

# TODO void isc_sqlcode_s(const status: var STATUS_ARRAY, uint32*);
# TODO void fb_sqlstate(char*, const status: var STATUS_ARRAY);
# TODO void isc_sql_interprete(short, cstring, short);
# TODO STATUS isc_transaction_info(status: var STATUS_ARRAY, transaction: var tr_handle, short, const cstring, short, cstring);
# TODO STATUS isc_transact_request(status: var STATUS_ARRAY, db: var db_handle, transaction: var tr_handle, unsigned short, cstring, unsigned short, cstring, unsigned short, cstring);

proc vax_integer*(buf: pointer; size: cshort): int32 {.importc: "isc_vax_integer", header: ibase_h.}
proc portable_integer*(buf: pointer; size: cshort): int64 {.importc: "isc_portable_integer", header: ibase_h.}

#* Security Functions and structures */
#*************************************/

const
  sec_uid_spec* =                0x01
  sec_gid_spec* =                0x02
  sec_server_spec* =             0x04
  sec_password_spec* =           0x08
  sec_group_name_spec* =         0x10
  sec_first_name_spec* =         0x20
  sec_middle_name_spec* =        0x40
  sec_last_name_spec* =          0x80
  sec_dba_user_name_spec* =      0x100
  sec_dba_password_spec* =       0x200

  sec_protocol_tcpip* =          1
  sec_protocol_netbeui* =        2
  sec_protocol_spx* =            3
  sec_protocol_local* =          4

type
  USER_SEC_DATA* {.importc, header: ibase_h.} = object
    sec_flags*: cshort
    uid*: cint
    gid*: cint
    protocol*: cint
    server*: cstring
    user_name*: cstring
    password*: cstring
    group_name*: cstring
    first_name*: cstring
    middle_name*: cstring
    last_name*: cstring
    dba_user_name*: cstring
    dba_password*: cstring

proc add_user*(status: var STATUS_ARRAY; data: var USER_SEC_DATA): STATUS {.importc: "isc_add_user", header: ibase_h.}
proc delete_user*(status: var STATUS_ARRAY; data: var USER_SEC_DATA): STATUS {.importc: "isc_delete_user", header: ibase_h.}
proc modify_user*(status: var STATUS_ARRAY; data: var USER_SEC_DATA): STATUS {.importc: "isc_modify_user", header: ibase_h.}

#*  Other OSRI functions          */
#**********************************/

# TODO STATUS isc_compile_request(status: var STATUS_ARRAY, db: var db_handle, req_handle*, short, const cstring);
# TODO STATUS isc_compile_request2(status: var STATUS_ARRAY, db: var db_handle, req_handle*, short, const cstring);
# TODO STATUS isc_prepare_transaction(status: var STATUS_ARRAY, transaction: var tr_handle);
# TODO STATUS isc_receive(status: var STATUS_ARRAY, req_handle*, short, short, pointer, short);
# TODO STATUS isc_reconnect_transaction(status: var STATUS_ARRAY, db: var db_handle, transaction: var tr_handle, short, const cstring);
# TODO STATUS isc_release_request(status: var STATUS_ARRAY, req_handle*);
# TODO STATUS isc_request_info(status: var STATUS_ARRAY, req_handle*, short, short, const cstring, short, cstring);
# TODO STATUS isc_seek_blob(status: var STATUS_ARRAY, blob_handle*, short, int32, int32*);
# TODO STATUS isc_send(status: var STATUS_ARRAY, req_handle*, short, short, const pointer, short);
# TODO STATUS isc_start_and_send(status: var STATUS_ARRAY, req_handle*, transaction: var tr_handle, short, short, const pointer, short);
# TODO STATUS isc_start_request(status: var STATUS_ARRAY, req_handle *, tr_handle *, short);
# TODO STATUS isc_unwind_request(status: var STATUS_ARRAY, tr_handle *, short);

proc wait_for_event*(status: var STATUS_ARRAY; db: var db_handle; eb_len: cshort; event_buf, result_buf: cstring): STATUS {.importc: "isc_wait_for_event", header: ibase_h.}

#* Other Sql functions       */
#*****************************/

# TODO STATUS isc_close(status: var STATUS_ARRAY, const cstring);
# TODO STATUS isc_declare(status: var STATUS_ARRAY, const cstring, const cstring);
# TODO STATUS isc_describe(status: var STATUS_ARRAY, const cstring, XSQLDA *);
# TODO STATUS isc_describe_bind(status: var STATUS_ARRAY, const cstring, XSQLDA*);
# TODO STATUS isc_execute(status: var STATUS_ARRAY, transaction: var tr_handle, const cstring, XSQLDA*);
# TODO STATUS isc_execute_immediate(status: var STATUS_ARRAY, db: var db_handle, transaction: var tr_handle, short*, const cstring);
# TODO STATUS isc_fetch(status: var STATUS_ARRAY, const cstring, XSQLDA*);
# TODO STATUS isc_open(status: var STATUS_ARRAY, transaction: var tr_handle, const cstring, XSQLDA*);
# TODO STATUS isc_prepare(status: var STATUS_ARRAY, db: var db_handle, transaction: var tr_handle, const cstring, const short*, const cstring, XSQLDA*);

#* Other Dynamic sql functions       */
#*************************************/

# TODO STATUS isc_dsql_execute_m(status: var STATUS_ARRAY, transaction: var tr_handle, stmt_handle*, unsigned short, const cstring, unsigned short, unsigned short, cstring);
# TODO STATUS isc_dsql_execute2_m(status: var STATUS_ARRAY, transaction: var tr_handle, stmt_handle*, unsigned short, const cstring, unsigned short, unsigned short, cstring, unsigned short, cstring, unsigned short, unsigned short, cstring);
# TODO STATUS isc_dsql_execute_immediate_m(status: var STATUS_ARRAY, db: var db_handle, transaction: var tr_handle, unsigned short, const cstring, unsigned short, unsigned short, cstring, unsigned short, unsigned short, cstring);
# TODO STATUS isc_dsql_exec_immed3_m(status: var STATUS_ARRAY, db: var db_handle, transaction: var tr_handle, unsigned short, const cstring, unsigned short, unsigned short, cstring, unsigned short, unsigned short, const cstring, unsigned short, cstring, unsigned short, unsigned short, cstring);
# TODO STATUS isc_dsql_fetch_m(status: var STATUS_ARRAY, stmt_handle*, unsigned short, cstring, unsigned short, unsigned short, cstring);
# TODO STATUS isc_dsql_insert_m(status: var STATUS_ARRAY, stmt_handle*, unsigned short, const cstring, unsigned short, unsigned short, const cstring);
# TODO STATUS isc_dsql_prepare_m(status: var STATUS_ARRAY, transaction: var tr_handle, stmt_handle*, unsigned short, const cstring, unsigned short, unsigned short, const cstring, unsigned short, cstring);
# TODO STATUS isc_dsql_release(status: var STATUS_ARRAY, const cstring);
# TODO STATUS isc_embed_dsql_close(status: var STATUS_ARRAY, const cstring);
# TODO STATUS isc_embed_dsql_declare(status: var STATUS_ARRAY, const cstring, const cstring);
# TODO STATUS isc_embed_dsql_describe(status: var STATUS_ARRAY, const cstring, unsigned short, XSQLDA*);
# TODO STATUS isc_embed_dsql_describe_bind(status: var STATUS_ARRAY, const cstring, unsigned short, XSQLDA*);
# TODO STATUS isc_embed_dsql_execute(status: var STATUS_ARRAY, transaction: var tr_handle, const cstring, unsigned short, XSQLDA*);
# TODO STATUS isc_embed_dsql_execute2(status: var STATUS_ARRAY, transaction: var tr_handle, const cstring, unsigned short, XSQLDA*, XSQLDA*);
# TODO STATUS isc_embed_dsql_execute_immed(status: var STATUS_ARRAY, db: var db_handle, transaction: var tr_handle, unsigned short, const cstring, unsigned short, XSQLDA*);
# TODO STATUS isc_embed_dsql_fetch(status: var STATUS_ARRAY, const cstring, unsigned short, XSQLDA*);
# TODO STATUS isc_embed_dsql_fetch_a(status: var STATUS_ARRAY, int*, const cstring, cushort, XSQLDA*);
# TODO void isc_embed_dsql_length(const cuchar*, cushort*);
# TODO STATUS isc_embed_dsql_open(status: var STATUS_ARRAY, transaction: var tr_handle, const cstring, unsigned short, XSQLDA*);
# TODO STATUS isc_embed_dsql_open2(status: var STATUS_ARRAY, transaction: var tr_handle, const cstring, unsigned short, XSQLDA*, XSQLDA*);
# TODO STATUS isc_embed_dsql_insert(status: var STATUS_ARRAY, const cstring, unsigned short, XSQLDA*);
# TODO STATUS isc_embed_dsql_prepare(status: var STATUS_ARRAY, db: var db_handle, transaction: var tr_handle, const cstring, unsigned short, const cstring, unsigned short, XSQLDA*);
# TODO STATUS isc_embed_dsql_release(status: var STATUS_ARRAY, const cstring);

#* Other Blob functions       */
#******************************/

# TODO FB_BLOB_STREAM BLOB_open(blob_handle, cstring, int);
# TODO int BLOB_put(cchar, FB_BLOB_STREAM);
# TODO int BLOB_close(FB_BLOB_STREAM);
# TODO int BLOB_get(FB_BLOB_STREAM);
# TODO int BLOB_display(QUAD_t*, db_handle, tr_handle, const cstring);
# TODO int BLOB_dump(QUAD_t*, db_handle, tr_handle, const cstring);
# TODO int BLOB_edit(QUAD_t*, db_handle, tr_handle, const cstring);
# TODO int BLOB_load(QUAD_t*, db_handle, tr_handle, const cstring);
# TODO int BLOB_text_dump(QUAD_t*, db_handle, tr_handle, const cstring);
# TODO int BLOB_text_load(QUAD_t*, db_handle, tr_handle, const cstring);
# TODO FB_BLOB_STREAM Bopen(QUAD_t*, db_handle, tr_handle, const cstring);

#* Other Misc functions       */
#******************************/

# TODO int32 isc_ftof(const cstring, const unsigned short, cstring, const unsigned short);
# TODO STATUS isc_print_blr(const cstring, PRINT_CALLBACK, pointer, short);
# TODO int fb_print_blr(const cuchar*, uint32, PRINT_CALLBACK, pointer, short);
# TODO void isc_set_debug(int);
# TODO void isc_qtoq(const QUAD_t*, QUAD_t*);
# TODO void isc_vtof(const cstring, cstring, unsigned short);
# TODO void isc_vtov(const cstring, cstring, short);
# TODO int isc_version(db: var db_handle, VERSION_CALLBACK, pointer);
# TODO uintptr_t       isc_baddress(cstring);
# TODO void            isc_baddress_s(const cstring, uintptr_t*);

#* Service manager functions             */
#*****************************************/

#define ADD_SPB_LENGTH(p, length)       {*(p)++ = (length); \ *(p)++ = (length) >> 8;}

#define ADD_SPB_NUMERIC(p, data)        {*(p)++ = (cchar) (cuchar) (data); \ *(p)++ = (cchar) (cuchar) ((data) >> 8); \ *(p)++ = (cchar) (cuchar) ((data) >> 16); \ *(p)++ = (cchar) (cuchar) ((data) >> 24);}

# TODO STATUS isc_service_attach(status: var STATUS_ARRAY, unsigned short, const cstring, isc_svc_handle*, unsigned short, const cstring);
# TODO STATUS isc_service_detach(status: var STATUS_ARRAY, svc_handle *);
# TODO STATUS isc_service_query(status: var STATUS_ARRAY, svc_handle*, resv_handle*, unsigned short, const cstring, unsigned short, const cstring, unsigned short, cstring);
# TODO STATUS isc_service_start(status: var STATUS_ARRAY, svc_handle*, resv_handle*, unsigned short, const cstring);

#* Shutdown and cancel */
#***********************/

# TODO int fb_shutdown(unsigned int, const int);
# TODO STATUS fb_shutdown_callback(status: var STATUS_ARRAY, FB_SHUTDOWN_CALLBACK, const int, pointer);
# TODO STATUS fb_cancel_operation(status: var STATUS_ARRAY, db: var db_handle, cushort);

#* Ping the connection */
#***********************/

# TODO STATUS fb_ping(status: var STATUS_ARRAY, db: var db_handle);

#* Object interface */
#********************/

# TODO STATUS fb_get_database_handle(status: var STATUS_ARRAY, db: var db_handle, pointer);
# TODO STATUS fb_get_transaction_handle(status: var STATUS_ARRAY, transaction: var tr_handle, pointer);

#* Client information functions */
#********************************/

# TODO void isc_get_client_version ( cchar  *);
# TODO int  isc_get_client_major_version ();
# TODO int  isc_get_client_minor_version ();

#* Set callback for database crypt plugins */
#*******************************************/

# TODO STATUS fb_database_crypt_callback(status: var STATUS_ARRAY, pointer);

include private/constants
include private/status
#include private/errors
