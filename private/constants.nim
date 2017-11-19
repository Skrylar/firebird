
#* Actions to pass to the blob filter (ctl_source) */
#***************************************************/

const
  blob_filter_open*             = 0
  blob_filter_get_segment*      = 1
  blob_filter_close*            = 2
  blob_filter_create*           = 3
  blob_filter_put_segment*      = 4
  blob_filter_alloc*            = 5
  blob_filter_free*             = 6
  blob_filter_seek*             = 7

#* Blr definitions */
#*******************/

#define BLR_WORD(x)     UCHAR(x), UCHAR((x) >> 8)

const
  blr_text*                = 14.cuchar
  blr_text2*               = 15.cuchar
  blr_short*               = 7.cuchar
  blr_long*                = 8.cuchar
  blr_quad*                = 9.cuchar
  blr_float*               = 10.cuchar
  blr_double*              = 27.cuchar
  blr_d_float*             = 11.cuchar
  blr_timestamp*           = 35.cuchar
  blr_varying*             = 37.cuchar
  blr_varying2*            = 38.cuchar
  blr_blob*                = 261.cshort
  blr_cstring*             = 40.cuchar
  blr_cstring2*            = 41.cuchar
  blr_blob_id*             = 45.cuchar
  blr_sql_date*            = 12.cuchar
  blr_sql_time*            = 13.cuchar
  blr_int64*               = 16.cuchar
  blr_blob2*               = 17.cuchar
  blr_domain_name*         = 18.cuchar
  blr_domain_name2*        = 19.cuchar
  blr_not_nullable*        = 20.cuchar
  blr_column_name*         = 21.cuchar
  blr_column_name2*        = 22.cuchar
  blr_bool*                = 23.cuchar
  # first sub parameter for blr_domain_name[2]
  blr_domain_type_oe*       = 0.cuchar
  blr_domain_full*         = 1.cuchar
  # Historical alias for pre V6 applications */
  blr_date*                = blr_timestamp
  blr_inner*               = 0.cuchar
  blr_left*                = 1.cuchar
  blr_right*               = 2.cuchar
  blr_full*                = 3.cuchar
  blr_gds_code*            = 0.cuchar
  blr_sql_code*            = 1.cuchar
  blr_exception*           = 2.cuchar
  blr_trigger_code*        = 3.cuchar
  blr_default_code*        = 4.cuchar
  blr_raise*               = 5.cuchar
  blr_exception_msg*       = 6.cuchar
  blr_exception_params*    = 7.cuchar
  blr_sql_state*           = 8.cuchar
  blr_version4*            = 4.cuchar
  blr_version5*            = 5.cuchar
  blr_eoc*                 = 76.cuchar
  blr_end*                 = 255.cuchar
  blr_assignment*          = 1.cuchar
  blr_begin*               = 2.cuchar
  blr_dcl_variable*        = 3.cuchar
  blr_message*             = 4.cuchar
  blr_erase*               = 5.cuchar
  blr_fetch*               = 6.cuchar
  blr_for*                 = 7.cuchar
  blr_if*                  = 8.cuchar
  blr_loop*                = 9.cuchar
  blr_modify*              = 10.cuchar
  blr_handler*             = 11.cuchar
  blr_receive*             = 12.cuchar
  blr_select*              = 13.cuchar
  blr_send*                = 14.cuchar
  blr_store*               = 15.cuchar
  blr_label*               = 17.cuchar
  blr_leave*               = 18.cuchar
  blr_store2*              = 19.cuchar
  blr_post*                = 20.cuchar
  blr_literal*             = 21.cuchar
  blr_dbkey*               = 22.cuchar
  blr_field*               = 23.cuchar
  blr_fid*                 = 24.cuchar
  blr_parameter*           = 25.cuchar
  blr_variable*            = 26.cuchar
  blr_average*             = 27.cuchar
  blr_count*               = 28.cuchar
  blr_maximum*             = 29.cuchar
  blr_minimum*             = 30.cuchar
  blr_total*               = 31.cuchar
  # unused codes: 32..33
  blr_add*                 = 34.cuchar
  blr_subtract*            = 35.cuchar
  blr_multiply*            = 36.cuchar
  blr_divide*              = 37.cuchar
  blr_negate*              = 38.cuchar
  blr_concatenate*         = 39.cuchar
  blr_substring*           = 40.cuchar
  blr_parameter2*          = 41.cuchar
  blr_from*                = 42.cuchar
  blr_via*                 = 43.cuchar
  blr_null*                = 45.cuchar
  blr_equiv*               = 46.cuchar
  blr_eql*                 = 47.cuchar
  blr_neq*                 = 48.cuchar
  blr_gtr*                 = 49.cuchar
  blr_geq*                 = 50.cuchar
  blr_lss*                 = 51.cuchar
  blr_leq*                 = 52.cuchar
  blr_containing*          = 53.cuchar
  blr_matching*            = 54.cuchar
  blr_starting*            = 55.cuchar
  blr_between*             = 56.cuchar
  blr_or*                  = 57.cuchar
  blr_and*                 = 58.cuchar
  blr_not*                 = 59.cuchar
  blr_any*                 = 60.cuchar
  blr_missing*             = 61.cuchar
  blr_unique*              = 62.cuchar
  blr_like*                = 63.cuchar
  # unused codes: 64..66
  blr_rse*                 = 67.cuchar
  blr_first*               = 68.cuchar
  blr_project*             = 69.cuchar
  blr_sort*                = 70.cuchar
  blr_boolean*             = 71.cuchar
  blr_ascending*           = 72.cuchar
  blr_descending*          = 73.cuchar
  blr_relation*            = 74.cuchar
  blr_rid*                 = 75.cuchar
  blr_union*               = 76.cuchar
  blr_map*                 = 77.cuchar
  blr_group_by*            = 78.cuchar
  blr_aggregate*           = 79.cuchar
  blr_join_type*           = 80.cuchar
  # unused codes: 81..82
  blr_agg_count*            = 83.cuchar
  blr_agg_max*              = 84.cuchar
  blr_agg_min*              = 85.cuchar
  blr_agg_total*            = 86.cuchar
  blr_agg_average*          = 87.cuchar
  blr_parameter3*           = 88.cuchar
  blr_agg_count2*           = 93.cuchar
  blr_agg_count_distinct*   = 94.cuchar
  blr_agg_total_distinct*   = 95.cuchar
  blr_agg_average_distinct* = 96.cuchar
  # unused codes: 97..99
  blr_function*            = 100.cuchar
  blr_gen_id*              = 101.cuchar
  blr_upcase*              = 103.cuchar
  blr_value_if*            = 105.cuchar
  blr_matching2*           = 106.cuchar
  blr_index*               = 107.cuchar
  blr_ansi_like*           = 108.cuchar
  blr_scrollable*          = 109.cuchar
  # unused codes: 110..117
  blr_rs_stream*           = 119.cuchar
  blr_exec_proc*           = 120.cuchar
  # unused codes: 121..123
  blr_procedure*           = 124.cuchar
  blr_pid*                 = 125.cuchar
  blr_exec_pid*            = 126.cuchar
  blr_singular*            = 127.cuchar
  blr_abort*               = 128.cuchar
  blr_block*               = 129.cuchar
  blr_error_handler*       = 130.cuchar
  blr_cast*                = 131.cuchar
  blr_pid2*                = 132.cuchar
  blr_procedure2*          = 133.cuchar
  blr_start_savepoint*     = 134.cuchar
  blr_end_savepoint*       = 135.cuchar
  # unused codes: 136..138
  blr_plan*                = 139.cuchar
  blr_merge*               = 140.cuchar
  blr_join*                = 141.cuchar
  blr_sequential*          = 142.cuchar
  blr_navigational*        = 143.cuchar
  blr_indices*             = 144.cuchar
  blr_retrieve*            = 145.cuchar
  blr_relation2*           = 146.cuchar
  blr_rid2*                = 147.cuchar
  # unused codes: 148..149
  blr_set_generator*       = 150.cuchar
  blr_ansi_any*            = 151.cuchar
  blr_exists*              = 152.cuchar
  # unused codes: 153
  blr_record_version*      = 154.cuchar
  blr_stall*               = 155.cuchar
  # unused codes: 156..157
  blr_ansi_all*            = 158.cuchar
  blr_extract*             = 159.cuchar
  # sub parameters for blr_extract */
  blr_extract_year*        = 0.cuchar
  blr_extract_month*       = 1.cuchar
  blr_extract_day*         = 2.cuchar
  blr_extract_hour*        = 3.cuchar
  blr_extract_minute*      = 4.cuchar
  blr_extract_second*      = 5.cuchar
  blr_extract_weekday*     = 6.cuchar
  blr_extract_yearday*     = 7.cuchar
  blr_extract_millisecond* = 8.cuchar
  blr_extract_week*        = 9.cuchar
  blr_current_date*        = 160.cuchar
  blr_current_timestamp*   = 161.cuchar
  blr_current_time*        = 162.cuchar
  #* These codes reuse BLR code space */
  blr_post_arg*            = 163.cuchar
  blr_exec_into*           = 164.cuchar
  blr_user_savepoint*      = 165.cuchar
  blr_dcl_cursor*          = 166.cuchar
  blr_cursor_stmt*         = 167.cuchar
  blr_current_timestamp2*  = 168.cuchar
  blr_current_time2*       = 169.cuchar
  blr_agg_list*            = 170.cuchar
  blr_agg_list_distinct*   = 171.cuchar
  blr_modify2*             = 172.cuchar
  #/ unused codes: 173
  #* FB 1.0 specific BLR */
  blr_current_role*        = 174.cuchar
  blr_skip*                = 175.cuchar
  #* FB 1.5 specific BLR */
  blr_exec_sql*            = 176.cuchar
  blr_internal_info*       = 177.cuchar
  blr_nullsfirst*          = 178.cuchar
  blr_writelock*           = 179.cuchar
  blr_nullslast*           = 180.cuchar
  #* FB 2.0 specific BLR */
  blr_lowcase*             = 181.cuchar
  blr_strlen*              = 182.cuchar
  #* sub parameter for blr_strlen */
  blr_strlen_bit*          = 0.cuchar
  blr_strlen_char*         = 1.cuchar
  blr_strlen_octet*        = 2.cuchar
  blr_trim*                = 183.cuchar
  #* first sub parameter for blr_trim */
  blr_trim_both*           = 0.cuchar
  blr_trim_leading*        = 1.cuchar
  blr_trim_trailing*       = 2.cuchar
  #* second sub parameter for blr_trim */
  blr_trim_spaces*         = 0.cuchar
  blr_trim_characters*     = 1.cuchar
  #* These codes are actions for user-defined savepoints */
  blr_savepoint_set*       = 0.cuchar
  blr_savepoint_release*   = 1.cuchar
  blr_savepoint_undo*      = 2.cuchar
  blr_savepoint_release_single*    = 3.cuchar
  #* These codes are actions for cursors */
  blr_cursor_open*                 = 0.cuchar
  blr_cursor_close*                = 1.cuchar
  blr_cursor_fetch*                = 2.cuchar
  blr_cursor_fetch_scroll* = 3.cuchar
  #* scroll options */
  blr_scroll_forward*              = 0.cuchar
  blr_scroll_backward*             = 1.cuchar
  blr_scroll_bof*                  = 2.cuchar
  blr_scroll_eof*                  = 3.cuchar
  blr_scroll_absolute*             = 4.cuchar
  blr_scroll_relative*             = 5.cuchar
  #* FB 2.1 specific BLR */
  blr_init_variable*       = 184.cuchar
  blr_recurse*             = 185.cuchar
  blr_sys_function*        = 186.cuchar
  #/ FB 2.5 specific BLR
  blr_auto_trans*          = 187.cuchar
  blr_similar*             = 188.cuchar
  blr_exec_stmt*           = 189.cuchar
  #/ subcodes of blr_exec_stmt
  blr_exec_stmt_inputs*            = 1.cuchar
  blr_exec_stmt_outputs*           = 2.cuchar
  blr_exec_stmt_sql*               = 3.cuchar
  blr_exec_stmt_proc_block*        = 4.cuchar
  blr_exec_stmt_data_src*          = 5.cuchar
  blr_exec_stmt_user*              = 6.cuchar
  blr_exec_stmt_pwd*               = 7.cuchar
  blr_exec_stmt_tran*              = 8.cuchar
  blr_exec_stmt_tran_clone*        = 9.cuchar
  blr_exec_stmt_privs*             = 10.cuchar
  blr_exec_stmt_in_params*         = 11.cuchar
  blr_exec_stmt_in_params2*        = 12.cuchar
  blr_exec_stmt_out_params*        = 13.cuchar
  blr_exec_stmt_role*              = 14.cuchar
  blr_stmt_expr*                   = 190.cuchar
  blr_derived_expr*                = 191.cuchar
  #/ FB 3.0 specific BLR
  blr_procedure3*                  = 192.cuchar
  blr_exec_proc2*                  = 193.cuchar
  blr_function2*                   = 194.cuchar
  blr_window*                      = 195.cuchar
  blr_partition_by*                = 196.cuchar
  blr_continue_loop*               = 197.cuchar
  blr_procedure4*                  = 198.cuchar
  blr_agg_function*                = 199.cuchar
  blr_substring_similar*           = 200.cuchar
  blr_bool_as_value*               = 201.cuchar
  blr_coalesce*                    = 202.cuchar
  blr_decode*                      = 203.cuchar
  blr_exec_subproc*                = 204.cuchar
  blr_subproc_decl*                = 205.cuchar
  blr_subproc*                     = 206.cuchar
  blr_subfunc_decl*                = 207.cuchar
  blr_subfunc*                     = 208.cuchar
  blr_record_version2*             = 209.cuchar

#* Database parameter block stuff */
#**********************************/

const
  dpb_version1*                  = 1
  dpb_version2*                  = 2
  dpb_cdd_pathname*              = 1
  dpb_allocation*                = 2
  dpb_journal*                   = 3
  dpb_page_size*                 = 4
  dpb_num_buffers*               = 5
  dpb_buffer_length*             = 6
  dpb_debug*                     = 7
  dpb_garbage_collect*           = 8
  dpb_verify*                    = 9
  dpb_sweep*                     = 10
  dpb_enable_journal*            = 11
  dpb_disable_journal*           = 12
  dpb_dbkey_scope*               = 13
  dpb_number_of_users*           = 14
  dpb_trace*                     = 15
  dpb_no_garbage_collect*        = 16
  dpb_damaged*                   = 17
  dpb_license*                   = 18
  dpb_sys_user_name*             = 19
  dpb_encrypt_key*               = 20
  dpb_activate_shadow*           = 21
  dpb_sweep_interval*            = 22
  dpb_delete_shadow*             = 23
  dpb_force_write*               = 24
  dpb_begin_log*                 = 25
  dpb_quit_log*                  = 26
  dpb_no_reserve*                = 27
  dpb_user_name*                 = 28
  dpb_password*                  = 29
  dpb_password_enc*              = 30
  dpb_sys_user_name_enc*         = 31
  dpb_interp*                    = 32
  dpb_online_dump*               = 33
  dpb_old_file_size*             = 34
  dpb_old_num_files*             = 35
  dpb_old_file*                  = 36
  dpb_old_start_page*            = 37
  dpb_old_start_seqno*           = 38
  dpb_old_start_file*            = 39
  dpb_drop_walfile*              = 40
  dpb_old_dump_id*               = 41
  dpb_wal_backup_dir*            = 42
  dpb_wal_chkptlen*              = 43
  dpb_wal_numbufs*               = 44
  dpb_wal_bufsize*               = 45
  dpb_wal_grp_cmt_wait*          = 46
  dpb_lc_messages*               = 47
  dpb_lc_ctype*                  = 48
  dpb_cache_manager*             = 49
  dpb_shutdown*                  = 50
  dpb_online*                    = 51
  dpb_shutdown_delay*            = 52
  dpb_reserved*                  = 53
  dpb_overwrite*                 = 54
  dpb_sec_attach*                = 55
  dpb_disable_wal*               = 56
  dpb_connect_timeout*           = 57
  dpb_dummy_packet_interval*     = 58
  dpb_gbak_attach*               = 59
  dpb_sql_role_name*             = 60
  dpb_set_page_buffers*          = 61
  dpb_working_directory*         = 62
  dpb_sql_dialect*               = 63
  dpb_set_db_readonly*           = 64
  dpb_set_db_sql_dialect*        = 65
  dpb_gfix_attach*               = 66
  dpb_gstat_attach*              = 67
  dpb_set_db_charset*            = 68
  dpb_address_path*              = 70
  dpb_process_id*                = 71
  dpb_no_db_triggers*            = 72
  dpb_trusted_auth*              = 73
  dpb_process_name*              = 74
  dpb_trusted_role*              = 75
  dpb_org_filename*              = 76
  dpb_utf8_filename*             = 77
  dpb_ext_call_depth*            = 78
  dpb_auth_block*                = 79
  dpb_client_version*            = 80
  dpb_remote_protocol*           = 81
  dpb_host_name*                 = 82
  dpb_os_user*                   = 83
  dpb_specific_auth_data*        = 84
  dpb_auth_plugin_list*          = 85
  dpb_auth_plugin_name*          = 86
  dpb_config*                    = 87
  dpb_nolinger*                  = 88
  dpb_reset_icu*                 = 89
  dpb_map_attach*                = 90
  dpb_address* = 1
  dpb_addr_protocol* = 1
  dpb_addr_endpoint* = 2

#* dpb_verify specific flags */
#*********************************/

const
  dpb_pages*                     = 1
  dpb_records*                   = 2
  dpb_indices*                   = 4
  dpb_transactions*              = 8
  dpb_no_update*                 = 16
  dpb_repair*                    = 32
  dpb_ignore*                    = 64

#* dpb_shutdown specific flags */
#***********************************/

const
  dpb_shut_cache*              =  0x1
  dpb_shut_attachment*         =  0x2
  dpb_shut_transaction*        =  0x4
  dpb_shut_force*              =  0x8
  dpb_shut_mode_mask*          = 0x70
  dpb_shut_default*            =  0x0
  dpb_shut_normal*             = 0x10
  dpb_shut_multi*              = 0x20
  dpb_shut_single*             = 0x30
  dpb_shut_full*               = 0x40

#* Bit assignments in RDB$SYSTEM_FLAG */
#**************************************/

const
  RDB_system*                         = 1
  RDB_id_assigned*                    = 2

#* Transaction parameter block stuff */
#*************************************/

const
  tpb_version1*                  = 1
  tpb_version3*                  = 3
  tpb_consistency*               = 1
  tpb_concurrency*               = 2
  tpb_shared*                    = 3
  tpb_protected*                 = 4
  tpb_exclusive*                 = 5
  tpb_wait*                      = 6
  tpb_nowait*                    = 7
  tpb_read*                      = 8
  tpb_write*                     = 9
  tpb_lock_read*                 = 10
  tpb_lock_write*                = 11
  tpb_verb_time*                 = 12
  tpb_commit_time*               = 13
  tpb_ignore_limbo*              = 14
  tpb_read_committed*            = 15
  tpb_autocommit*                = 16
  tpb_rec_version*               = 17
  tpb_no_rec_version*            = 18
  tpb_restart_requests*          = 19
  tpb_no_auto_undo*              = 20
  tpb_lock_timeout*              = 21

#* Blob Parameter Block */
#************************/

const
  bpb_version1*                  = 1
  bpb_source_type*               = 1
  bpb_target_type*               = 2
  bpb_type*                      = 3
  bpb_source_interp*             = 4
  bpb_target_interp*             = 5
  bpb_filter_parameter*          = 6
  bpb_storage*                   = 7
  bpb_type_segmented*            = 0x0
  bpb_type_stream*               = 0x1
  bpb_storage_main*              = 0x0
  bpb_storage_temp*              = 0x2

#* Service parameter block stuff */
#*********************************/

const
  spb_version1*                = 1
  spb_current_version*         = 2
  spb_version*                 = spb_current_version
  spb_version3*                = 3
  spb_user_name*               = dpb_user_name
  spb_sys_user_name*           = dpb_sys_user_name
  spb_sys_user_name_enc*       = dpb_sys_user_name_enc
  spb_password*                = dpb_password
  spb_password_enc*            = dpb_password_enc
  spb_command_line*            = 105
  spb_dbname*                  = 106
  spb_verbose*                 = 107
  spb_options*                 = 108
  spb_address_path*            = 109
  spb_process_id*              = 110
  spb_trusted_auth*            = 111
  spb_process_name*            = 112
  spb_trusted_role*            = 113
  spb_verbint*                 = 114
  spb_auth_block*              = 115
  spb_auth_plugin_name*        = 116
  spb_auth_plugin_list*        = 117
  spb_utf8_filename*           = 118
  spb_client_version*          = 119
  spb_remote_protocol*         = 120
  spb_host_name*               = 121
  spb_os_user*                 = 122
  spb_config*                  = 123
  spb_expected_db*             = 124
  spb_connect_timeout*         = dpb_connect_timeout
  spb_dummy_packet_interval*   = dpb_dummy_packet_interval
  spb_sql_role_name*           = dpb_sql_role_name
  spb_specific_auth_data*      = spb_trusted_auth

#* Service action items      *
#*****************************/

const
  action_svc_backup*            =  1
  action_svc_restore*           =  2
  action_svc_repair*            =  3
  action_svc_add_user*          =  4
  action_svc_delete_user*       =  5
  action_svc_modify_user*       =  6
  action_svc_display_user*      =  7
  action_svc_properties*        =  8
  action_svc_add_license*       =  9
  action_svc_remove_license*    = 10
  action_svc_db_stats*          = 11
  action_svc_get_ib_log*        = 12
  action_svc_get_fb_log*        = 12
  action_svc_nbak*              = 20
  action_svc_nrest*             = 21
  action_svc_trace_start*       = 22
  action_svc_trace_stop*        = 23
  action_svc_trace_suspend*     = 24
  action_svc_trace_resume*      = 25
  action_svc_trace_list*        = 26
  action_svc_set_mapping*       = 27
  action_svc_drop_mapping*      = 28
  action_svc_display_user_adm*  = 29
  action_svc_validate*          = 30
  action_svc_last*              = 31

#* Service information items *
#*****************************/

const
  info_svc_svr_db_info*              = 50
  info_svc_get_license*              = 51
  info_svc_get_license_mask*         = 52
  info_svc_get_config*               = 53
  info_svc_version*                  = 54
  info_svc_server_version*           = 55
  info_svc_implementation*           = 56
  info_svc_capabilities*             = 57
  info_svc_user_dbpath*              = 58
  info_svc_get_env*                  = 59
  info_svc_get_env_lock*             = 60
  info_svc_get_env_msg*              = 61
  info_svc_line*                     = 62
  info_svc_to_eof*                   = 63
  info_svc_timeout*                  = 64
  info_svc_get_licensed_users*       = 65
  info_svc_limbo_trans*              = 66
  info_svc_running*                  = 67
  info_svc_get_users*                = 68
  info_svc_auth_block*               = 69
  info_svc_stdin*                    = 78

#* Parameters for action_{add|del|mod|disp)_user  *
#******************************************************/

const
  spb_sec_userid*          = 5
  spb_sec_groupid*         = 6
  spb_sec_username*        = 7
  spb_sec_password*        = 8
  spb_sec_groupname*       = 9
  spb_sec_firstname*       = 10
  spb_sec_middlename*      = 11
  spb_sec_lastname*        = 12
  spb_sec_admin*           = 13

#* Parameters for action_svc_(add|remove)_license, *
#* info_svc_get_license                            *
#*******************************************************/

const
  spb_lic_key*             = 5
  spb_lic_id*              = 6
  spb_lic_desc*            = 7

#* Parameters for action_svc_backup  *
#*****************************************/

const
  spb_bkp_file*                 = 5
  spb_bkp_factor*               = 6
  spb_bkp_length*               = 7
  spb_bkp_skip_data*            = 8
  spb_bkp_stat*                 = 15
  spb_bkp_ignore_checksums*     = 0x01
  spb_bkp_ignore_limbo*         = 0x02
  spb_bkp_metadata_only*        = 0x04
  spb_bkp_no_garbage_collect*   = 0x08
  spb_bkp_old_descriptions*     = 0x10
  spb_bkp_non_transportable*    = 0x20
  spb_bkp_convert*              = 0x40
  spb_bkp_expand*               = 0x80
  spb_bkp_no_triggers*          = 0x8000

#* Parameters for action_svc_properties *
#********************************************/

const
  spb_prp_page_buffers*              = 5
  spb_prp_sweep_interval*            = 6
  spb_prp_shutdown_db*               = 7
  spb_prp_deny_new_attachments*      = 9
  spb_prp_deny_new_transactions*     = 10
  spb_prp_reserve_space*             = 11
  spb_prp_write_mode*                = 12
  spb_prp_access_mode*               = 13
  spb_prp_set_sql_dialect*           = 14
  spb_prp_activate*                  = 0x0100
  spb_prp_db_online*                 = 0x0200
  spb_prp_nolinger*                  = 0x0400
  spb_prp_force_shutdown*            = 41
  spb_prp_attachments_shutdown*      = 42
  spb_prp_transactions_shutdown*     = 43
  spb_prp_shutdown_mode*             = 44
  spb_prp_online_mode*               = 45

#* Parameters for spb_prp_shutdown_mode *
#*            and spb_prp_online_mode   *
#********************************************/

const
  spb_prp_sm_normal*         = 0
  spb_prp_sm_multi*          = 1
  spb_prp_sm_single*         = 2
  spb_prp_sm_full*           = 3

#* Parameters for spb_prp_reserve_space *
#********************************************/

const
  spb_prp_res_use_full*      = 35
  spb_prp_res*               = 36

#* Parameters for spb_prp_write_mode  *
#******************************************/

const
  spb_prp_wm_async*          = 37
  spb_prp_wm_sync*           = 38

#* Parameters for spb_prp_access_mode *
#******************************************/

const
  spb_prp_am_readonly*       = 39
  spb_prp_am_readwrite*      = 40

#* Parameters for action_svc_repair  *
#*****************************************/

const
  spb_rpr_commit_trans*              = 15
  spb_rpr_rollback_trans*            = 34
  spb_rpr_recover_two_phase*         = 17
  spb_tra_id*                        = 18
  spb_single_tra_id*                 = 19
  spb_multi_tra_id*                  = 20
  spb_tra_state*                     = 21
  spb_tra_state_limbo*               = 22
  spb_tra_state_commit*              = 23
  spb_tra_state_rollback*            = 24
  spb_tra_state_unknown*             = 25
  spb_tra_host_site*                 = 26
  spb_tra_remote_site*               = 27
  spb_tra_db_path*                   = 28
  spb_tra_advise*                    = 29
  spb_tra_advise_commit*             = 30
  spb_tra_advise_rollback*           = 31
  spb_tra_advise_unknown*            = 33
  spb_tra_id_64*                     = 46
  spb_single_tra_id_64*              = 47
  spb_multi_tra_id_64*               = 48
  spb_rpr_commit_trans_64*           = 49
  spb_rpr_rollback_trans_64*         = 50
  spb_rpr_recover_two_phase_64*      = 51
  spb_rpr_validate_db*               = 0x01
  spb_rpr_sweep_db*                  = 0x02
  spb_rpr_mend_db*                   = 0x04
  spb_rpr_list_limbo_trans*          = 0x08
  spb_rpr_check_db*                  = 0x10
  spb_rpr_ignore_checksum*           = 0x20
  spb_rpr_kill_shadows*              = 0x40
  spb_rpr_full*                      = 0x80
  spb_rpr_icu*                       = 0x0800

#* Parameters for action_svc_restore *
#*****************************************/

const
  spb_res_skip_data*                 = spb_bkp_skip_data
  spb_res_buffers*                   = 9
  spb_res_page_size*                 = 10
  spb_res_length*                    = 11
  spb_res_access_mode*               = 12
  spb_res_fix_fss_data*              = 13
  spb_res_fix_fss_metadata*          = 14
  spb_res_stat*                      = spb_bkp_stat
  spb_res_metadata_only*             = spb_bkp_metadata_only
  spb_res_deactivate_idx*            = 0x0100
  spb_res_no_shadow*                 = 0x0200
  spb_res_no_validity*               = 0x0400
  spb_res_one_at_a_time*             = 0x0800
  spb_res_replace*                   = 0x1000
  spb_res_create*                    = 0x2000
  spb_res_use_all_space*             = 0x4000

#* Parameters for action_svc_validate *
#*****************************************/

const
  spb_val_tab_incl*          = 1
  spb_val_tab_excl*          = 2
  spb_val_idx_incl*          = 3
  spb_val_idx_excl*          = 4
  spb_val_lock_timeout*      = 5

#* Parameters for spb_res_access_mode  *
#******************************************/

const
  spb_res_am_readonly*               = spb_prp_am_readonly
  spb_res_am_readwrite*              = spb_prp_am_readwrite

#* Parameters for info_svc_svr_db_info *
#*******************************************/

const
  spb_num_att*               = 5
  spb_num_db*                = 6

#* Parameters for info_svc_db_stats  *
#*****************************************/

const
  spb_sts_table*             = 64
  spb_sts_data_pages*        = 0x01
  spb_sts_db_log*            = 0x02
  spb_sts_hdr_pages*         = 0x04
  spb_sts_idx_pages*         = 0x08
  spb_sts_sys_relations*     = 0x10
  spb_sts_record_versions*   = 0x20
  spb_sts_nocreation*        = 0x80
  spb_sts_encryption*        = 0x100

#* Server configuration key values */
#***********************************/

#* Not available in Firebird 1.5

#* Parameters for action_svc_nbak  *
#***************************************/

const
  spb_nbk_level*             = 5
  spb_nbk_file*              = 6
  spb_nbk_direct*            = 7
  spb_nbk_no_triggers*       = 0x01

#* Parameters for action_svc_trace *
#***************************************/

const
  spb_trc_id*                    = 1
  spb_trc_name*                  = 2
  spb_trc_cfg*                   = 3

#* Array slice description language (SDL) */
#******************************************/

const
  sdl_version1*                = 1
  sdl_eoc*                     = 255
  sdl_relation*                = 2
  sdl_rid*                     = 3
  sdl_field*                   = 4
  sdl_fid*                     = 5
  sdl_struct*                  = 6
  sdl_variable*                = 7
  sdl_scalar*                  = 8
  sdl_tiny_integer*            = 9
  sdl_short_integer*           = 10
  sdl_long_integer*            = 11
  sdl_add*                     = 13
  sdl_subtract*                = 14
  sdl_multiply*                = 15
  sdl_divide*                  = 16
  sdl_begin*                   = 31
  sdl_end*                     = 32
  sdl_do3*                     = 33
  sdl_do2*                     = 34
  sdl_do1*                     = 35
  sdl_element*                 = 36

#* Blob Subtypes */
#*****************/

const
  #* types less than zero are reserved for customer use */
  blob_untyped*                  = 0
  #* internal subtypes */
  blob_text*                     = 1
  blob_blr*                      = 2
  blob_acl*                      = 3
  blob_ranges*                   = 4
  blob_summary*                  = 5
  blob_format*                   = 6
  blob_tra*                      = 7
  blob_extfile*                  = 8
  blob_debug_info*               = 9
  blob_max_predefined_subtype*   = 10
  #* the range 20-30 is reserved for dBASE and Paradox types */

#* Masks for fb_shutdown_callback  */
#***********************************/

const
  fb_shut_confirmation*         = 1
  fb_shut_preproviders*         = 2
  fb_shut_postproviders*        = 4
  fb_shut_finish*               = 8
  fb_shut_exit*                 = 16

#* Shutdown reasons, used by engine     */
#* Users should provide positive values */
#****************************************/

const
  fb_shutrsn_svc_stopped*                  = -1
  fb_shutrsn_no_connection*                = -2
  fb_shutrsn_app_stopped*                  = -3
  fb_shutrsn_signal*                       = -5
  fb_shutrsn_services*                     = -6
  fb_shutrsn_exit_called*                  = -7

#* Cancel types for fb_cancel_operation */
#****************************************/

const
  fb_cancel_disable*                  = 1
  fb_cancel_enable*                   = 2
  fb_cancel_raise*                    = 3
  fb_cancel_abort*                    = 4

#* Debug information items                  */
#********************************************/

const
  fb_dbg_version*                          = 1
  fb_dbg_end*                              = 255
  fb_dbg_map_src2blr*                      = 2
  fb_dbg_map_varname*                      = 3
  fb_dbg_map_argument*                     = 4
  fb_dbg_subproc*                          = 5
  fb_dbg_subfunc*                          = 6
  fb_dbg_map_curname*                      = 7
  # sub code for fb_dbg_map_argument
  fb_dbg_arg_input*                        = 0
  fb_dbg_arg_output*                       = 1

#* Information call declarations */
#*********************************/

#* Common, structural codes */
#****************************/

const
  info_end*                  = 1
  info_truncated*            = 2
  info_error*                = 3
  info_data_not_ready*       = 4
  info_length*               = 126
  info_flag_end*             = 127

#* Database information items */
#******************************/

type
  db_info_types* = cint
const
  info_db_id*                  = 4
  info_reads*                  = 5
  info_writes*                 = 6
  info_fetches*                = 7
  info_marks*                  = 8
  info_implementation*         = 11
  info_isc_version*            = 12
  info_base_level*             = 13
  info_page_size*              = 14
  info_num_buffers*            = 15
  info_limbo*                  = 16
  info_current_memory*         = 17
  info_max_memory*             = 18
  info_window_turns*           = 19
  info_license*                = 20
  info_allocation*             = 21
  info_attachment_id*          = 22
  info_read_seq_count*         = 23
  info_read_idx_count*         = 24
  info_insert_count*           = 25
  info_update_count*           = 26
  info_delete_count*           = 27
  info_backout_count*          = 28
  info_purge_count*            = 29
  info_expunge_count*          = 30
  info_sweep_interval*         = 31
  info_ods_version*            = 32
  info_ods_minor_version*      = 33
  info_no_reserve*             = 34
  info_forced_writes*          = 52
  info_user_names*             = 53
  info_page_errors*            = 54
  info_record_errors*          = 55
  info_bpage_errors*           = 56
  info_dpage_errors*           = 57
  info_ipage_errors*           = 58
  info_ppage_errors*           = 59
  info_tpage_errors*           = 60
  info_set_page_buffers*       = 61
  info_db_sql_dialect*         = 62
  info_db_read_only*           = 63
  info_db_size_in_pages*       = 64
  #* Values 65 -100 unused to avoid conflict with InterBase */
  frb_info_att_charset*         = 101
  info_db_class*            = 102
  info_firebird_version*    = 103
  info_oldest_transaction*  = 104
  info_oldest_active*       = 105
  info_oldest_snapshot*     = 106
  info_next_transaction*    = 107
  info_db_provider*         = 108
  info_active_transactions* = 109
  info_active_tran_count*   = 110
  info_creation_date*       = 111
  info_db_file_size*        = 112
  fb_info_page_contents*        = 113
  fb_info_implementation*       = 114
  fb_info_page_warns*           = 115
  fb_info_record_warns*         = 116
  fb_info_bpage_warns*          = 117
  fb_info_dpage_warns*          = 118
  fb_info_ipage_warns*          = 119
  fb_info_ppage_warns*          = 120
  fb_info_tpage_warns*          = 121
  fb_info_pip_errors*           = 122
  fb_info_pip_warns*            = 123
  fb_info_pages_used*           = 124
  fb_info_pages_free*           = 125
  fb_info_crypt_state*          = 126
  info_db_last_value*       = 127  #* Leave this LAST! */

type
  db_info_crypt* = cint
const
  fb_info_crypt_encrypted* = 0x01
  fb_info_crypt_process* = 0x02

const
  info_version* = info_isc_version

#* Database information return values */
#**************************************/

type
  info_db_implementations* = cint
const
  info_db_impl_rdb_vms* = 1
  info_db_impl_rdb_eln* = 2
  info_db_impl_rdb_eln_dev* = 3
  info_db_impl_rdb_vms_y* = 4
  info_db_impl_rdb_eln_y* = 5
  info_db_impl_jri* = 6
  info_db_impl_jsv* = 7
  info_db_impl_isc_apl_68K* = 25
  info_db_impl_isc_vax_ultr* = 26
  info_db_impl_isc_vms* = 27
  info_db_impl_isc_sun_68k* = 28
  info_db_impl_isc_os2* = 29
  info_db_impl_isc_sun4* = 30
  info_db_impl_isc_hp_ux* = 31
  info_db_impl_isc_sun_386i* = 32
  info_db_impl_isc_vms_orcl* = 33
  info_db_impl_isc_mac_aux* = 34
  info_db_impl_isc_rt_aix* = 35
  info_db_impl_isc_mips_ult* = 36
  info_db_impl_isc_xenix* = 37
  info_db_impl_isc_dg* = 38
  info_db_impl_isc_hp_mpexl* = 39
  info_db_impl_isc_hp_ux68K* = 40
  info_db_impl_isc_sgi* = 41
  info_db_impl_isc_sco_unix* = 42
  info_db_impl_isc_cray* = 43
  info_db_impl_isc_imp* = 44
  info_db_impl_isc_delta* = 45
  info_db_impl_isc_next* = 46
  info_db_impl_isc_dos* = 47
  info_db_impl_m88K* = 48
  info_db_impl_unixware* = 49
  info_db_impl_isc_winnt_x86* = 50
  info_db_impl_isc_epson* = 51
  info_db_impl_alpha_osf* = 52
  info_db_impl_alpha_vms* = 53
  info_db_impl_netware_386* = 54
  info_db_impl_win_only* = 55
  info_db_impl_ncr_3000* = 56
  info_db_impl_winnt_ppc* = 57
  info_db_impl_dg_x86* = 58
  info_db_impl_sco_ev* = 59
  info_db_impl_i386* = 60
  info_db_impl_freebsd* = 61
  info_db_impl_netbsd* = 62
  info_db_impl_darwin_ppc* = 63
  info_db_impl_sinixz* = 64
  info_db_impl_linux_sparc* = 65
  info_db_impl_linux_amd64* = 66
  info_db_impl_freebsd_amd64* = 67
  info_db_impl_winnt_amd64* = 68
  info_db_impl_linux_ppc* = 69
  info_db_impl_darwin_x86* = 70
  info_db_impl_linux_mipsel* = 71
  info_db_impl_linux_mips* = 72
  info_db_impl_darwin_x64* = 73
  info_db_impl_sun_amd64* = 74
  info_db_impl_linux_arm* = 75
  info_db_impl_linux_ia64* = 76
  info_db_impl_darwin_ppc64* = 77
  info_db_impl_linux_s390x* = 78
  info_db_impl_linux_s390* = 79
  info_db_impl_linux_sh* = 80
  info_db_impl_linux_sheb* = 81
  info_db_impl_linux_hppa* = 82
  info_db_impl_linux_alpha* = 83
  info_db_impl_linux_arm64* = 84
  info_db_impl_linux_ppc64el* = 85
  info_db_impl_linux_ppc64* = 86
  info_db_impl_linux_m68k* = 87
  info_db_impl_last_value* = 88  # Leave this LAST!

#type
#info_db_class* = cint
const
  info_db_class_access* = 1
  info_db_class_y_valve* = 2
  info_db_class_rem_int* = 3
  info_db_class_rem_srvr* = 4
  info_db_class_pipe_int* = 7
  info_db_class_pipe_srvr* = 8
  info_db_class_sam_int* = 9
  info_db_class_sam_srvr* = 10
  info_db_class_gateway* = 11
  info_db_class_cache* = 12
  info_db_class_classic_access* = 13
  info_db_class_server_access* = 14
  info_db_class_last_value* = 15  # Leave this LAST!

#type
#info_db_provider* = cint
const
  info_db_code_rdb_eln* = 1
  info_db_code_rdb_vms* = 2
  info_db_code_interbase* = 3
  info_db_code_firebird* = 4
  info_db_code_last_value* = 5 # Leave this LAST!

#* Request information items */
#*****************************/

const
  info_number_messages*      = 4
  info_max_message*          = 5
  info_max_send*             = 6
  info_max_receive*          = 7
  info_state*                = 8
  info_message_number*       = 9
  info_message_size*         = 10
  info_request_cost*         = 11
  info_access_path*          = 12
  info_req_select_count*     = 13
  info_req_insert_count*     = 14
  info_req_update_count*     = 15
  info_req_delete_count*     = 16

#* Access path items */
#*********************/

const
  info_rsb_end*              = 0
  info_rsb_begin*            = 1
  info_rsb_type*             = 2
  info_rsb_relation*         = 3
  info_rsb_plan*             = 4

#* RecordSource (RSB) types */
#*************/

const
  info_rsb_unknown*          = 1
  info_rsb_indexed*          = 2
  info_rsb_navigate*         = 3
  info_rsb_sequential*       = 4
  info_rsb_cross*            = 5
  info_rsb_sort*             = 6
  info_rsb_first*            = 7
  info_rsb_boolean*          = 8
  info_rsb_union*            = 9
  info_rsb_aggregate*        = 10
  info_rsb_merge*            = 11
  info_rsb_ext_sequential*   = 12
  info_rsb_ext_indexed*      = 13
  info_rsb_ext_dbkey*        = 14
  info_rsb_left_cross*       = 15
  info_rsb_select*           = 16
  info_rsb_sql_join*         = 17
  info_rsb_simulate*         = 18
  info_rsb_sim_cross*        = 19
  info_rsb_once*             = 20
  info_rsb_procedure*        = 21
  info_rsb_skip*             = 22
  info_rsb_virt_sequential*  = 23
  info_rsb_recursive*        = 24
  info_rsb_window*           = 25
  info_rsb_singular*         = 26
  info_rsb_writelock*        = 27
  info_rsb_buffer*           = 28
  info_rsb_hash*             = 29

#* Bitmap expressions */
#**********************/

const
  info_rsb_and*              = 1
  info_rsb_or*               = 2
  info_rsb_dbkey*            = 3
  info_rsb_index*            = 4
  info_req_active*           = 2
  info_req_inactive*         = 3
  info_req_send*             = 4
  info_req_receive*          = 5
  info_req_select*           = 6
  info_req_sql_stall*        = 7

#* Blob information items */
#**************************/

const
  info_blob_num_segments*    = 4
  info_blob_max_segment*     = 5
  info_blob_total_length*    = 6
  info_blob_type*            = 7

#* Transaction information items */
#*********************************/

const
  info_tra_id*                       = 4
  info_tra_oldest_interesting*       = 5
  info_tra_oldest_snapshot*          = 6
  info_tra_oldest_active*            = 7
  info_tra_isolation*                = 8
  info_tra_access*                   = 9
  info_tra_lock_timeout*             = 10
  fb_info_tra_dbpath*                    = 11

# info_tra_isolation responses
const
  info_tra_consistency*              = 1
  info_tra_concurrency*              = 2
  info_tra_read_committed*           = 3

# info_tra_read_committed options
const
  info_tra_no_rec_version*           = 0
  info_tra_rec_version*              = 1

# info_tra_access responses
const
  info_tra_readonly*   = 0
  info_tra_readwrite*  = 1

#* SQL information items */
#*************************/

const
  info_sql_select*            = 4
  info_sql_bind*              = 5
  info_sql_num_variables*     = 6
  info_sql_describe_vars*     = 7
  info_sql_describe_end*      = 8
  info_sql_sqlda_seq*         = 9
  info_sql_message_seq*       = 10
  info_sql_type*              = 11
  info_sql_sub_type*          = 12
  info_sql_scale*             = 13
  info_sql_length*            = 14
  info_sql_null_ind*          = 15
  info_sql_field*             = 16
  info_sql_relation*          = 17
  info_sql_owner*             = 18
  info_sql_alias*             = 19
  info_sql_sqlda_start*       = 20
  info_sql_stmt_type*         = 21
  info_sql_get_plan*          = 22
  info_sql_records*           = 23
  info_sql_batch_fetch*       = 24
  info_sql_relation_alias*    = 25
  info_sql_explain_plan*      = 26
  info_sql_stmt_flags*        = 27

#* SQL information return values */
#*********************************/

const
  info_sql_stmt_select*          = 1
  info_sql_stmt_insert*          = 2
  info_sql_stmt_update*          = 3
  info_sql_stmt_delete*          = 4
  info_sql_stmt_ddl*             = 5
  info_sql_stmt_get_segment*     = 6
  info_sql_stmt_put_segment*     = 7
  info_sql_stmt_exec_procedure*  = 8
  info_sql_stmt_start_trans*     = 9
  info_sql_stmt_commit*          = 10
  info_sql_stmt_rollback*        = 11
  info_sql_stmt_select_for_upd*  = 12
  info_sql_stmt_set_generator*   = 13
  info_sql_stmt_savepoint*       = 14
