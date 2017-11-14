
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
  ISC_STATUS_LENGTH* {.importc, header: ibase_h.} = 20
  FB_SQLSTATE_LENGTH* {.importc, header: ibase_h.} = 5
  FB_SQLSTATE_SIZE* {.importc, header: ibase_h.} = (FB_SQLSTATE_LENGTH + 1)

type
  ISC_STATUS* {.importc, header: ibase_h.} = int # XXX Araq says nim int is always the same size as pointer
  ISC_STATUS_ARRAY* = array[0..(ISC_STATUS_LENGTH-1), ISC_STATUS]
  FB_SQLSTATE_STRING* = array[0..(FB_SQLSTATE_SIZE-1), cchar]

#* Define type, export and other stuff based on c/c++ and Windows */
#******************************************************************/

const
  FB_FALSE* {.importc, header: ibase_h.} = 0.cchar
  FB_TRUE* {.importc, header: ibase_h.} = 1.cchar

type
  ISC_LONG* {.importc, header: ibase_h.} = int32
  ISC_ULONG* {.importc, header: ibase_h.} = uint32
  ISC_SHORT* {.importc, header: ibase_h.} = cshort
  ISC_USHORT* {.importc, header: ibase_h.} = cushort
  ISC_UCHAR* {.importc, header: ibase_h.} = cuchar
  ISC_SCHAR* {.importc, header: ibase_h.} = cchar
  FB_BOOLEAN* {.importc, header: ibase_h.} = ISC_UCHAR

#* 64 bit Integers                                                 */
#*******************************************************************/

type
  ISC_INT64* {.importc, header: ibase_h.} = int64
  ISC_UINT64* {.importc, header: ibase_h.} = uint64

#* Time & Date support                                             */
#*******************************************************************/

type
  ISC_DATE* {.importc, header: ibase_h.} = cint
  ISC_TIME* {.importc, header: ibase_h.} = cuint

  ISC_TIMESTAMP* {.importc, header: ibase_h.} = object
    timestamp_date*: ISC_DATE
    timestamp_time*: ISC_TIME

#* Blob Id support                                                 */
#*******************************************************************/

type
  GDS_QUAD_t* {.importc, header: ibase_h.} = object
    # NB these were aliased from isc_quad_*, but nim doesn't have #define
    gds_quad_high*: ISC_LONG
    gds_quad_low*: ISC_ULONG

  GDS_QUAD* = GDS_QUAD_t
  ISC_QUAD* = GDS_QUAD_t

  FB_SHUTDOWN_CALLBACK* {.importc, header: ibase_h.} = proc(reason, mask: cint; arg: pointer): cint

#* Firebird Handle Definitions */
#********************************/

type
  isc_att_handle* = FB_API_HANDLE
  isc_blob_handle* = FB_API_HANDLE
  isc_db_handle* = FB_API_HANDLE
  isc_req_handle* = FB_API_HANDLE
  isc_stmt_handle* = FB_API_HANDLE
  isc_svc_handle* = FB_API_HANDLE
  isc_tr_handle* = FB_API_HANDLE
  isc_resv_handle* = ISC_LONG

  isc_callback* {.importc, header: ibase_h.} = proc()
  ISC_PRINT_CALLBACK* {.importc, header: ibase_h.} = proc(a: pointer; b: ISC_SHORT; c: cstring)
  ISC_VERSION_CALLBACK* {.importc, header: ibase_h.} = proc(a: pointer; b: cstring)
  ISC_EVENT_CALLBACK* {.importc, header: ibase_h.} = proc(a: pointer; b: ISC_USHORT; c: ptr ISC_UCHAR)

#* Blob id structure                                               */
#*******************************************************************/

type
  ISC_ARRAY_BOUND* {.importc, header: ibase_h.} = object
    array_bound_lower*: cshort
    array_bound_upper*: cshort

  ISC_ARRAY_DESC* {.importc, header: ibase_h.} = object
    array_desc_dtype*: ISC_UCHAR
    array_desc_scale*: ISC_SCHAR
    array_desc_length*: cushort
    array_desc_field_name*: array[0..31, ISC_SCHAR]
    array_desc_relation_name*: array[0..31, ISC_SCHAR]
    array_desc_dimensions*: cshort
    array_desc_flags*: cshort
    array_desc_bounds*: array[0..15, ISC_ARRAY_BOUND]

  ISC_BLOB_DESC* {.importc, header: ibase_h.} = object
    blob_desc_subtype*: cshort
    blob_desc_charset*: cshort
    blob_desc_segment_size*: cshort
    blob_desc_field_name*: array[0..31, ISC_UCHAR]
    blob_desc_relation_name*: array[0..31, ISC_UCHAR]

#* Blob control structure  */
#***************************/

type
  isc_blob_ctl_obj* {.importc: "struct isc_blob_ctl", header: ibase_h.} = object
    ctl_source*: proc(): ISC_STATUS
    ctl_source_handle*: ptr isc_blob_ctl_obj
    ctl_to_sub_type*: cshort
    ctl_from_sub_type*: cshort
    ctl_buffer_length*: cushort
    ctl_segment_length*: cushort
    ctl_bpb_length*: cushort
    ctl_bpb*: cstring
    ctl_buffer*: ptr ISC_UCHAR
    ctl_max_segment*: ISC_LONG
    ctl_number_segments*: ISC_LONG
    ctl_total_length*: ISC_LONG
    ctl_status*: ptr ISC_STATUS
    ctl_data*: array[0..7, clong]

  ISC_BLOB_CTL* = ptr isc_blob_ctl_obj

#* Blob stream definitions */
#***************************/

type
  BSTREAM* {.importc: "struct bstream", header: ibase_h.} = object
    bstr_blob*: isc_blob_handle
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
    blob_get_segment*: proc(hnd: pointer; buffer: ptr ISC_UCHAR; buf_size: ISC_USHORT; result_len: ptr ISC_USHORT): cshort
    blob_handle*: pointer
    blob_number_segments*: ISC_LONG
    blob_max_segment*: ISC_LONG
    blob_total_length*: ISC_LONG
    blob_put_segment*: proc(hnd: pointer; buffer: ptr ISC_UCHAR; buf_size: ISC_USHORT)
    blob_lseek*: proc(hnd: pointer; mode: ISC_USHORT; offset: ISC_LONG): ISC_LONG

  BLOBCALLBACK* = ptr blobcallback_obj

  PARAMDSC* {.importc, header: ibase_h.} = object
    dsc_dtype*: ISC_UCHAR
    dsc_scale*: int8
    dsc_length*: ISC_USHORT
    dsc_sub_type*: cshort
    dsc_flags*: ISC_USHORT
    dsc_address*: ptr ISC_UCHAR

  PARAMVARY* {.importc, header: ibase_h.} = object
    vary_length*: ISC_USHORT
    vary_string*: array[0..0, ISC_UCHAR]

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
  ISC_TIME_SECONDS_PRECISION*       = 10000
  ISC_TIME_SECONDS_PRECISION_SCALE* = -4

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
    sqltype*: ISC_SHORT
    sqlscale*: ISC_SHORT
    sqlsubtype*: ISC_SHORT
    sqllen*: ISC_SHORT
    sqldata*: pointer
    sqlind*: ptr ISC_SHORT
    sqlname_length*: ISC_SHORT
    sqlname*: array[0..31, ISC_SCHAR]
    relname_length*: ISC_SHORT
    relname*: array[0..31, ISC_SCHAR]
    ownname_length*: ISC_SHORT
    ownname*: array[0..31, ISC_SCHAR]
    aliasname_length*: ISC_SHORT
    aliasname*: array[0..31, ISC_SCHAR]

  PXSQLVAR* = ptr XSQLVAR

  XSQLDA* {.importc, header: ibase_h.} = object
    version*: ISC_SHORT
    sqldaid*: array[0..7, ISC_SCHAR]
    sqldabc*: ISC_LONG
    sqln*: ISC_SHORT # number of parameters allocated
    sqld*: ISC_SHORT # number of parameters firebird wants to use
    sqlvar*: array[0..0, XSQLVAR]

  PXSQLDA* = ptr XSQLDA

template XSQLDA_LENGTH*(n: int): int =
  XSQLDA.sizeof + ((n - 1) * XSQLVAR.sizeof)

proc make_xsqlda*(vars: int): PXSQLDA =
  result = cast[PXSQLDA](alloc(XSQLDA_LENGTH(vars)))
  result.version = SQLDA_VERSION1
  result.sqln = vars.ISC_SHORT
  result.sqld = vars.ISC_SHORT

proc free_xsqlda*(self: PXSQLDA; dealloc_children: bool = true) =
  # free potentially allocated data; if you are doing cheeky things,
  # like using pointers to local value buffers, you will want this to
  # be false.
  if dealloc_children:
    for i in 0..self.sqln:
      let here = self[i]
      if here.sqldata != nil:
        dealloc(here.sqldata)
      if here.sqlind != nil:
        dealloc(here.sqlind)
  # now ditch the object
  dealloc(self)

proc `[]`* (self: PXSQLDA; index: int): PXSQLVAR =
  # bounds checking
  assert index >= 0
  assert index < self.sqln
  # return the thing
  var x = cast[int](unsafeaddr self.sqlvar[0])
  inc x, (XSQLVAR.sizeof) * index
  result = cast[PXSQLVAR](x)

#define XSQLDA_LENGTH(n)        (sizeof (XSQLDA) + (n - 1) * sizeof (XSQLVAR))

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

#* SQL Dialects            */
#***************************/

const
  SQL_DIALECT_V5*                = 1
  SQL_DIALECT_V6_TRANSITION*     = 2
  SQL_DIALECT_V6*                = 3
  SQL_DIALECT_CURRENT*           = SQL_DIALECT_V6

#* OSRI database functions */
#***************************/

proc isc_attach_database(status: var ISC_STATUS_ARRAY; db_name_length: cshort; db_name: cstring; db: var isc_db_handle; parm_buffer_length: cshort = 0; parm_buffer: cstring = nil): ISC_STATUS {.importc, header: ibase_h.}

proc isc_attach_database*(status_vector: var ISC_STATUS_ARRAY; db_name: cstring; db: var isc_db_handle; parm_buffer_length: cshort = 0; parm_buffer: cstring = nil): ISC_STATUS {.inline.} =
  result = isc_attach_database(status_vector, 0, db_name, db, parm_buffer_length, parm_buffer)

# TODO ISC_STATUS isc_array_gen_sdl(status: ref ISC_STATUS_ARRAY, const ISC_ARRAY_DESC*, ISC_SHORT*, ISC_UCHAR*, ISC_SHORT*);
# TODO ISC_STATUS isc_array_get_slice(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, ISC_QUAD*, const ISC_ARRAY_DESC*, pointer, ISC_LONG*);
# TODO ISC_STATUS isc_array_lookup_bounds(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, const cstring, const cstring, ISC_ARRAY_DESC*);
# TODO ISC_STATUS isc_array_lookup_desc(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, const cstring, const cstring, ISC_ARRAY_DESC*);
# TODO ISC_STATUS isc_array_set_desc(status: ref ISC_STATUS_ARRAY, const cstring, const cstring, const short*, const short*, const short*, ISC_ARRAY_DESC*);
# TODO ISC_STATUS isc_array_put_slice(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, ISC_QUAD*, const ISC_ARRAY_DESC*, pointer, ISC_LONG *);
# TODO void isc_blob_default_desc(ISC_BLOB_DESC*, const ISC_UCHAR*, const ISC_UCHAR*);
# TODO ISC_STATUS isc_blob_gen_bpb(status: ref ISC_STATUS_ARRAY, const ISC_BLOB_DESC*, const ISC_BLOB_DESC*, unsigned short, ISC_UCHAR*, unsigned short*);
# TODO ISC_STATUS isc_blob_info(status: ref ISC_STATUS_ARRAY, isc_blob_handle*, short, const cstring, short, cstring);
# TODO ISC_STATUS isc_blob_lookup_desc(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, const ISC_UCHAR*, const ISC_UCHAR*, ISC_BLOB_DESC*, ISC_UCHAR*);
# TODO ISC_STATUS isc_blob_set_desc(status: ref ISC_STATUS_ARRAY, const ISC_UCHAR*, const ISC_UCHAR*, short, short, short, ISC_BLOB_DESC*);
# TODO ISC_STATUS isc_cancel_blob(status: ref ISC_STATUS_ARRAY, isc_blob_handle *);
# TODO ISC_STATUS isc_cancel_events(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, ISC_LONG *);
# TODO ISC_STATUS isc_close_blob(status: ref ISC_STATUS_ARRAY, isc_blob_handle *);
# TODO ISC_STATUS isc_commit_retaining(status: ref ISC_STATUS_ARRAY, isc_tr_handle *);
proc isc_commit_transaction*(status: var ISC_STATUS_ARRAY; tr: var isc_tr_handle): ISC_STATUS {.importc, header: ibase_h, discardable.}
# TODO ISC_STATUS isc_create_blob(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, isc_blob_handle*, ISC_QUAD*);
# TODO ISC_STATUS isc_create_blob2(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, isc_blob_handle*, ISC_QUAD*, short, const cstring);
# TODO ISC_STATUS isc_create_database(status: ref ISC_STATUS_ARRAY, short, const cstring, db: ref isc_db_handle, short, const cstring, short);
# TODO ISC_STATUS isc_database_info(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, short, const cstring, short, cstring);
# TODO void isc_decode_date(const ISC_QUAD*, pointer);
# TODO void isc_decode_sql_date(const ISC_DATE*, pointer);
# TODO void isc_decode_sql_time(const ISC_TIME*, pointer);
# TODO void isc_decode_timestamp(const ISC_TIMESTAMP*, pointer);
proc isc_detach_database*(status: var ISC_STATUS_ARRAY, db: var isc_db_handle): ISC_STATUS {.importc, header: ibase_h, discardable.}
# TODO ISC_STATUS isc_drop_database(status: ref ISC_STATUS_ARRAY_ARRAY, db: ref isc_db_handle);

proc isc_dsql_allocate_statement_inner(status: ref ISC_STATUS_ARRAY; db: ref isc_db_handle; statement: var isc_stmt_handle): ISC_STATUS {.importc: "isc_dsql_allocate_statement", header: ibase_h.}

proc isc_dsql_alloc_statement2_inner(status: ref ISC_STATUS_ARRAY; db: ref isc_db_handle; statement: var isc_stmt_handle): ISC_STATUS {.importc: "isc_dsql_alloc_statement2", header: ibase_h.}

proc isc_dsql_allocate_statement*(status: ref ISC_STATUS_ARRAY; db: ref isc_db_handle; statement: var isc_stmt_handle; autofree: bool = true): ISC_STATUS {.inline.} =
  if autofree:
    result = isc_dsql_allocate_statement_inner(status, db, statement)
  else:
    result = isc_dsql_alloc_statement2_inner(status, db, statement)

# TODO ISC_STATUS isc_dsql_describe(status: ref ISC_STATUS_ARRAY, isc_stmt_handle *, unsigned short, XSQLDA *);
# TODO ISC_STATUS isc_dsql_describe_bind(status: ref ISC_STATUS_ARRAY, isc_stmt_handle *, unsigned short, XSQLDA *);

proc isc_dsql_exec_immed2_inner(status: var; db: var; transaction: var; statement_length: cushort; statement: cstring; dialect: cushort = SQL_DIALECT_CURRENT; inx, outx: ptr XSQLDA = nil): ISC_STATUS {.importc: "isc_dsql_exec_immed2", header: ibase_h.}

proc isc_dsql_exec_immed2*(status: var; db: var; transaction: var; statement_length: cushort; statement: cstring; dialect: cushort = SQL_DIALECT_CURRENT; inx, outx: ptr XSQLDA = nil): ISC_STATUS {.inline, discardable.} =
  result = isc_dsql_exec_immed2_inner(status, db, transaction, 0, statement, dialect, inx, outx)

proc isc_dsql_execute*(status: ref ISC_STATUS_ARRAY; transaction: ref isc_tr_handle; statement: var isc_stmt_handle; dialect: cushort = SQL_DIALECT_CURRENT; xsql: ptr XSQLDA = nil): ISC_STATUS {.importc, header: ibase_h.}

proc isc_dsql_execute*(status: ref ISC_STATUS_ARRAY; transaction: ref isc_tr_handle; statement: var isc_stmt_handle; dialect: cushort = SQL_DIALECT_CURRENT; inx, outx: ptr XSQLDA = nil): ISC_STATUS {.importc: "isc_dsql_execute2", header: ibase_h.}

proc isc_dsql_execute_immediate(status: var ISC_STATUS_ARRAY; db: var isc_db_handle; transaction: var isc_tr_handle; length: cushort; query: cstring; dialect: cushort = SQL_DIALECT_CURRENT; xsql: ptr XSQLDA = nil): ISC_STATUS {.importc, header: ibase_h.}

proc isc_dsql_execute_immediate*(status: var ISC_STATUS_ARRAY; db: var isc_db_handle; transaction: var isc_tr_handle; query: cstring; dialect: cushort = SQL_DIALECT_CURRENT; xsql: ptr XSQLDA = nil): ISC_STATUS {.inline, discardable.} =
  result = isc_dsql_execute_immediate(status, db, transaction, 0, query, dialect, xsql)

# TODO ISC_STATUS isc_dsql_fetch(status: ref ISC_STATUS_ARRAY, isc_stmt_handle *, unsigned short, const XSQLDA *);
# TODO ISC_STATUS isc_dsql_finish(db: ref isc_db_handle);

proc isc_dsql_free_statement_inner(status: ref ISC_STATUS_ARRAY; statement: var isc_stmt_handle; on_free: cushort): ISC_STATUS {.importc: "isc_dsql_free_statement", header: ibase_h.}

proc isc_dsql_free_statement*(status: ref ISC_STATUS_ARRAY; statement: var isc_stmt_handle; on_free: StatementFreeType): ISC_STATUS {.inline.} =
  result = isc_dsql_free_statement_inner(status, statement, on_free.cushort)

# TODO ISC_STATUS isc_dsql_insert(status: ref ISC_STATUS_ARRAY, isc_stmt_handle*, unsigned short, XSQLDA*);

proc isc_dsql_prepare_inner(status: var ISC_STATUS_ARRAY; transaction: var isc_tr_handle; statement_handle: var isc_stmt_handle; statement_length: cushort; statement: cstring; dialect: cushort = SQL_DIALECT_CURRENT; xsql: var XSQLDA): ISC_STATUS {.importc: "isc_dsql_prepare", header: ibase_h.}

proc isc_dsql_prepare*(status: var ISC_STATUS_ARRAY; transaction: var isc_tr_handle; statement_handle: var isc_stmt_handle; statement: cstring; dialect: cushort = SQL_DIALECT_CURRENT; xsql: var XSQLDA): ISC_STATUS {.inline.} =
  result = isc_dsql_prepare_inner(status, transaction, statement_handle, 0, statement, dialect, xsql)

# TODO ISC_STATUS isc_dsql_set_cursor_name(status: ref ISC_STATUS_ARRAY, isc_stmt_handle*, const cstring, unsigned short);
# TODO ISC_STATUS isc_dsql_sql_info(status: ref ISC_STATUS_ARRAY, isc_stmt_handle*, short, const cstring, short, cstring);
# TODO void isc_encode_date(const pointer, ISC_QUAD*);
# TODO void isc_encode_sql_date(const pointer, ISC_DATE*);
# TODO void isc_encode_sql_time(const pointer, ISC_TIME*);
# TODO void isc_encode_timestamp(const pointer, ISC_TIMESTAMP*);
# TODO ISC_LONG ISC_EXPORT_VARARG isc_event_block(ISC_UCHAR**, ISC_UCHAR**, ISC_USHORT, ...);
# TODO ISC_USHORT isc_event_block_a(cstring*, cstring*, ISC_USHORT, cstring*);
# TODO void isc_event_block_s(cstring*, cstring*, ISC_USHORT, cstring*, ISC_USHORT*);
# TODO void isc_event_counts(ISC_ULONG*, short, ISC_UCHAR*, const ISC_UCHAR *);
# TODO int isc_modify_dpb(cstring*, short*, unsigned short, const cstring, short); ISC_LONG isc_free(ISC_SCHAR *);
# TODO ISC_STATUS isc_get_segment(status: ref ISC_STATUS_ARRAY, isc_blob_handle *, unsigned short *, unsigned short, ISC_SCHAR *);
# TODO ISC_STATUS isc_get_slice(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, ISC_QUAD*, short, const cstring, short, const ISC_LONG*, ISC_LONG, pointer, ISC_LONG*);
# TODO ISC_LONG fb_interpret(cstring, unsigned int, const status: ref ISC_STATUS_ARRAY*);
# TODO ISC_STATUS isc_open_blob(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, isc_blob_handle*, ISC_QUAD*);
# TODO ISC_STATUS isc_open_blob2(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, isc_blob_handle*, ISC_QUAD*, ISC_USHORT, const ISC_UCHAR*);
# TODO ISC_STATUS isc_prepare_transaction2(status: ref ISC_STATUS_ARRAY, transaction: ref isc_tr_handle, ISC_USHORT, const ISC_UCHAR*);
# TODO void isc_print_sqlerror(ISC_SHORT, const status: ref ISC_STATUS_ARRAY);
# TODO ISC_STATUS isc_print_status(const status: ref ISC_STATUS_ARRAY);
# TODO ISC_STATUS isc_put_segment(status: ref ISC_STATUS_ARRAY, isc_blob_handle*, unsigned short, const cstring);
# TODO ISC_STATUS isc_put_slice(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, ISC_QUAD*, short, const cstring, short, const ISC_LONG*, ISC_LONG, pointer);
# TODO ISC_STATUS isc_que_events(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, ISC_LONG*, short, const ISC_UCHAR*, ISC_EVENT_CALLBACK, pointer);
# TODO ISC_STATUS isc_rollback_retaining(status: ref ISC_STATUS_ARRAY, transaction: ref isc_tr_handle);
proc isc_rollback_transaction*(status: ref ISC_STATUS_ARRAY; transaction: ref isc_tr_handle): ISC_STATUS {.importc, header: ibase_h, discardable.}
# TODO ISC_STATUS isc_start_multiple(status: ref ISC_STATUS_ARRAY, transaction: ref isc_tr_handle, short, void *);

proc isc_start_transaction_inner(status: var ISC_STATUS_ARRAY; transaction: var isc_tr_handle; handle_count: cshort; db: var isc_db_handle; tpb_length: cushort; tpb: cstring): ISC_STATUS {.importc: "isc_start_transaction", header: ibase_h,}

proc isc_start_transaction*(status: var ISC_STATUS_ARRAY; transaction: var isc_tr_handle; db: var isc_db_handle; tpb_length: cushort = 0; tpb: cstring = nil): ISC_STATUS {.inline, discardable.} =
  result = isc_start_transaction_inner(status, transaction, 1.cshort, db, tpb_length, tpb)

# TODO ISC_STATUS fb_disconnect_transaction(status: ref ISC_STATUS_ARRAY, transaction: ref isc_tr_handle);
# TODO ISC_LONG isc_sqlcode(const status: ref ISC_STATUS_ARRAY);
# TODO void isc_sqlcode_s(const status: ref ISC_STATUS_ARRAY, ISC_ULONG*);
# TODO void fb_sqlstate(char*, const status: ref ISC_STATUS_ARRAY);
# TODO void isc_sql_interprete(short, cstring, short);
# TODO ISC_STATUS isc_transaction_info(status: ref ISC_STATUS_ARRAY, transaction: ref isc_tr_handle, short, const cstring, short, cstring);
# TODO ISC_STATUS isc_transact_request(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, unsigned short, cstring, unsigned short, cstring, unsigned short, cstring);
# TODO ISC_LONG isc_vax_integer(const cstring, short);
# TODO ISC_INT64 isc_portable_integer(const ISC_UCHAR*, short);

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

proc isc_add_user*(status: ref ISC_STATUS_ARRAY; data: ref USER_SEC_DATA): ISC_STATUS {.importc, header: ibase_h.}
proc isc_delete_user*(status: ref ISC_STATUS_ARRAY; data: ref USER_SEC_DATA): ISC_STATUS {.importc, header: ibase_h.}
proc isc_modify_user*(status: ref ISC_STATUS_ARRAY; data: ref USER_SEC_DATA): ISC_STATUS {.importc, header: ibase_h.}

#*  Other OSRI functions          */
#**********************************/

# TODO ISC_STATUS isc_compile_request(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, isc_req_handle*, short, const cstring);
# TODO ISC_STATUS isc_compile_request2(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, isc_req_handle*, short, const cstring);
# TODO ISC_STATUS isc_prepare_transaction(status: ref ISC_STATUS_ARRAY, transaction: ref isc_tr_handle);
# TODO ISC_STATUS isc_receive(status: ref ISC_STATUS_ARRAY, isc_req_handle*, short, short, pointer, short);
# TODO ISC_STATUS isc_reconnect_transaction(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, short, const cstring);
# TODO ISC_STATUS isc_release_request(status: ref ISC_STATUS_ARRAY, isc_req_handle*);
# TODO ISC_STATUS isc_request_info(status: ref ISC_STATUS_ARRAY, isc_req_handle*, short, short, const cstring, short, cstring);
# TODO ISC_STATUS isc_seek_blob(status: ref ISC_STATUS_ARRAY, isc_blob_handle*, short, ISC_LONG, ISC_LONG*);
# TODO ISC_STATUS isc_send(status: ref ISC_STATUS_ARRAY, isc_req_handle*, short, short, const pointer, short);
# TODO ISC_STATUS isc_start_and_send(status: ref ISC_STATUS_ARRAY, isc_req_handle*, transaction: ref isc_tr_handle, short, short, const pointer, short);
# TODO ISC_STATUS isc_start_request(status: ref ISC_STATUS_ARRAY, isc_req_handle *, isc_tr_handle *, short);
# TODO ISC_STATUS isc_unwind_request(status: ref ISC_STATUS_ARRAY, isc_tr_handle *, short);
# TODO ISC_STATUS isc_wait_for_event(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, short, const ISC_UCHAR*, ISC_UCHAR*);

#* Other Sql functions       */
#*****************************/

# TODO ISC_STATUS isc_close(status: ref ISC_STATUS_ARRAY, const cstring);
# TODO ISC_STATUS isc_declare(status: ref ISC_STATUS_ARRAY, const cstring, const cstring);
# TODO ISC_STATUS isc_describe(status: ref ISC_STATUS_ARRAY, const cstring, XSQLDA *);
# TODO ISC_STATUS isc_describe_bind(status: ref ISC_STATUS_ARRAY, const cstring, XSQLDA*);
# TODO ISC_STATUS isc_execute(status: ref ISC_STATUS_ARRAY, transaction: ref isc_tr_handle, const cstring, XSQLDA*);
# TODO ISC_STATUS isc_execute_immediate(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, short*, const cstring);
# TODO ISC_STATUS isc_fetch(status: ref ISC_STATUS_ARRAY, const cstring, XSQLDA*);
# TODO ISC_STATUS isc_open(status: ref ISC_STATUS_ARRAY, transaction: ref isc_tr_handle, const cstring, XSQLDA*);
# TODO ISC_STATUS isc_prepare(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, const cstring, const short*, const cstring, XSQLDA*);

#* Other Dynamic sql functions       */
#*************************************/

# TODO ISC_STATUS isc_dsql_execute_m(status: ref ISC_STATUS_ARRAY, transaction: ref isc_tr_handle, isc_stmt_handle*, unsigned short, const cstring, unsigned short, unsigned short, cstring);
# TODO ISC_STATUS isc_dsql_execute2_m(status: ref ISC_STATUS_ARRAY, transaction: ref isc_tr_handle, isc_stmt_handle*, unsigned short, const cstring, unsigned short, unsigned short, cstring, unsigned short, cstring, unsigned short, unsigned short, cstring);
# TODO ISC_STATUS isc_dsql_execute_immediate_m(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, unsigned short, const cstring, unsigned short, unsigned short, cstring, unsigned short, unsigned short, cstring);
# TODO ISC_STATUS isc_dsql_exec_immed3_m(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, unsigned short, const cstring, unsigned short, unsigned short, cstring, unsigned short, unsigned short, const cstring, unsigned short, cstring, unsigned short, unsigned short, cstring);
# TODO ISC_STATUS isc_dsql_fetch_m(status: ref ISC_STATUS_ARRAY, isc_stmt_handle*, unsigned short, cstring, unsigned short, unsigned short, cstring);
# TODO ISC_STATUS isc_dsql_insert_m(status: ref ISC_STATUS_ARRAY, isc_stmt_handle*, unsigned short, const cstring, unsigned short, unsigned short, const cstring);
# TODO ISC_STATUS isc_dsql_prepare_m(status: ref ISC_STATUS_ARRAY, transaction: ref isc_tr_handle, isc_stmt_handle*, unsigned short, const cstring, unsigned short, unsigned short, const cstring, unsigned short, cstring);
# TODO ISC_STATUS isc_dsql_release(status: ref ISC_STATUS_ARRAY, const cstring);
# TODO ISC_STATUS isc_embed_dsql_close(status: ref ISC_STATUS_ARRAY, const cstring);
# TODO ISC_STATUS isc_embed_dsql_declare(status: ref ISC_STATUS_ARRAY, const cstring, const cstring);
# TODO ISC_STATUS isc_embed_dsql_describe(status: ref ISC_STATUS_ARRAY, const cstring, unsigned short, XSQLDA*);
# TODO ISC_STATUS isc_embed_dsql_describe_bind(status: ref ISC_STATUS_ARRAY, const cstring, unsigned short, XSQLDA*);
# TODO ISC_STATUS isc_embed_dsql_execute(status: ref ISC_STATUS_ARRAY, transaction: ref isc_tr_handle, const cstring, unsigned short, XSQLDA*);
# TODO ISC_STATUS isc_embed_dsql_execute2(status: ref ISC_STATUS_ARRAY, transaction: ref isc_tr_handle, const cstring, unsigned short, XSQLDA*, XSQLDA*);
# TODO ISC_STATUS isc_embed_dsql_execute_immed(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, unsigned short, const cstring, unsigned short, XSQLDA*);
# TODO ISC_STATUS isc_embed_dsql_fetch(status: ref ISC_STATUS_ARRAY, const cstring, unsigned short, XSQLDA*);
# TODO ISC_STATUS isc_embed_dsql_fetch_a(status: ref ISC_STATUS_ARRAY, int*, const cstring, ISC_USHORT, XSQLDA*);
# TODO void isc_embed_dsql_length(const ISC_UCHAR*, ISC_USHORT*);
# TODO ISC_STATUS isc_embed_dsql_open(status: ref ISC_STATUS_ARRAY, transaction: ref isc_tr_handle, const cstring, unsigned short, XSQLDA*);
# TODO ISC_STATUS isc_embed_dsql_open2(status: ref ISC_STATUS_ARRAY, transaction: ref isc_tr_handle, const cstring, unsigned short, XSQLDA*, XSQLDA*);
# TODO ISC_STATUS isc_embed_dsql_insert(status: ref ISC_STATUS_ARRAY, const cstring, unsigned short, XSQLDA*);
# TODO ISC_STATUS isc_embed_dsql_prepare(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, transaction: ref isc_tr_handle, const cstring, unsigned short, const cstring, unsigned short, XSQLDA*);
# TODO ISC_STATUS isc_embed_dsql_release(status: ref ISC_STATUS_ARRAY, const cstring);

#* Other Blob functions       */
#******************************/

# TODO FB_BLOB_STREAM BLOB_open(isc_blob_handle, cstring, int);
# TODO int BLOB_put(ISC_SCHAR, FB_BLOB_STREAM);
# TODO int BLOB_close(FB_BLOB_STREAM);
# TODO int BLOB_get(FB_BLOB_STREAM);
# TODO int BLOB_display(ISC_QUAD*, isc_db_handle, isc_tr_handle, const cstring);
# TODO int BLOB_dump(ISC_QUAD*, isc_db_handle, isc_tr_handle, const cstring);
# TODO int BLOB_edit(ISC_QUAD*, isc_db_handle, isc_tr_handle, const cstring);
# TODO int BLOB_load(ISC_QUAD*, isc_db_handle, isc_tr_handle, const cstring);
# TODO int BLOB_text_dump(ISC_QUAD*, isc_db_handle, isc_tr_handle, const cstring);
# TODO int BLOB_text_load(ISC_QUAD*, isc_db_handle, isc_tr_handle, const cstring);
# TODO FB_BLOB_STREAM Bopen(ISC_QUAD*, isc_db_handle, isc_tr_handle, const cstring);

#* Other Misc functions       */
#******************************/

# TODO ISC_LONG isc_ftof(const cstring, const unsigned short, cstring, const unsigned short);
# TODO ISC_STATUS isc_print_blr(const cstring, ISC_PRINT_CALLBACK, pointer, short);
# TODO int fb_print_blr(const ISC_UCHAR*, ISC_ULONG, ISC_PRINT_CALLBACK, pointer, short);
# TODO void isc_set_debug(int);
# TODO void isc_qtoq(const ISC_QUAD*, ISC_QUAD*);
# TODO void isc_vtof(const cstring, cstring, unsigned short);
# TODO void isc_vtov(const cstring, cstring, short);
# TODO int isc_version(db: ref isc_db_handle, ISC_VERSION_CALLBACK, pointer);
# TODO uintptr_t       isc_baddress(cstring);
# TODO void            isc_baddress_s(const cstring, uintptr_t*);

#* Service manager functions             */
#*****************************************/

#define ADD_SPB_LENGTH(p, length)       {*(p)++ = (length); \ *(p)++ = (length) >> 8;}

#define ADD_SPB_NUMERIC(p, data)        {*(p)++ = (ISC_SCHAR) (ISC_UCHAR) (data); \ *(p)++ = (ISC_SCHAR) (ISC_UCHAR) ((data) >> 8); \ *(p)++ = (ISC_SCHAR) (ISC_UCHAR) ((data) >> 16); \ *(p)++ = (ISC_SCHAR) (ISC_UCHAR) ((data) >> 24);}

# TODO ISC_STATUS isc_service_attach(status: ref ISC_STATUS_ARRAY, unsigned short, const cstring, isc_svc_handle*, unsigned short, const cstring);
# TODO ISC_STATUS isc_service_detach(status: ref ISC_STATUS_ARRAY, isc_svc_handle *);
# TODO ISC_STATUS isc_service_query(status: ref ISC_STATUS_ARRAY, isc_svc_handle*, isc_resv_handle*, unsigned short, const cstring, unsigned short, const cstring, unsigned short, cstring);
# TODO ISC_STATUS isc_service_start(status: ref ISC_STATUS_ARRAY, isc_svc_handle*, isc_resv_handle*, unsigned short, const cstring);

#* Shutdown and cancel */
#***********************/

# TODO int fb_shutdown(unsigned int, const int);
# TODO ISC_STATUS fb_shutdown_callback(status: ref ISC_STATUS_ARRAY, FB_SHUTDOWN_CALLBACK, const int, pointer);
# TODO ISC_STATUS fb_cancel_operation(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, ISC_USHORT);

#* Ping the connection */
#***********************/

# TODO ISC_STATUS fb_ping(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle);

#* Object interface */
#********************/

# TODO ISC_STATUS fb_get_database_handle(status: ref ISC_STATUS_ARRAY, db: ref isc_db_handle, pointer);
# TODO ISC_STATUS fb_get_transaction_handle(status: ref ISC_STATUS_ARRAY, transaction: ref isc_tr_handle, pointer);

#* Client information functions */
#********************************/

# TODO void isc_get_client_version ( ISC_SCHAR  *);
# TODO int  isc_get_client_major_version ();
# TODO int  isc_get_client_minor_version ();

#* Set callback for database crypt plugins */
#*******************************************/

# TODO ISC_STATUS fb_database_crypt_callback(status: ref ISC_STATUS_ARRAY, pointer);

include private/constants
include private/status
#include private/errors
