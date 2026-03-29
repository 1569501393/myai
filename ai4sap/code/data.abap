*&---------------------------------------------------------------------*
*& 程序: ZJQR_DATA_QUERY
*& 名称: 动态表查询 ICF Handler (ECC兼容版)
*& 功能: 通过REST API动态查询SAP表数据
*& 作者: AI Assistant
*& 日期: 2026-03-30
*& 版本: 1.2
*& 说明: 兼容SAP ECC 6.0版本 (完全兼容,无7.4+语法)
*&---------------------------------------------------------------------*
*
* 使用示例:
*   /sap/bc/zzjq?table=SPFLI&limit=3
*   /sap/bc/zzjq?table=MARA&limit=10
*
* 参数说明:
*   table (必需): 表名
*   limit (可选): 返回行数,默认10
*
*&---------------------------------------------------------------------*

METHOD if_http_extension~handle_request.

  "----------------------------------------------------------------------"
  " 定义变量 (不使用内联声明,兼容ECC 6.0)
  "----------------------------------------------------------------------"
  DATA: lv_table    TYPE tabname.              " 动态表名
  DATA: lv_limit    TYPE i.                    " 返回行数
  DATA: lv_json     TYPE string.                " JSON响应
  DATA: lv_error    TYPE string.                " 错误信息
  DATA: lo_data     TYPE REF TO data.           " 动态数据引用
  DATA: lx_err      TYPE REF TO cx_dynamic_check. " 异常引用

  FIELD-SYMBOLS: <lt_data> TYPE ANY TABLE.    " 动态内表

  "----------------------------------------------------------------------"
  " 1. 获取请求参数
  "----------------------------------------------------------------------"
  lv_table = server->request->get_form_field( name = `table` ).
  lv_limit = server->request->get_form_field( name = `limit` ).

  " SAP表名必须大写
  TRANSLATE lv_table TO UPPER CASE.

  " 参数验证 - 表名为空
  IF lv_table IS INITIAL.
    lv_json = `{"error":"Table parameter is required"}`.
    server->response->set_content_type( `application/json; charset=utf-8` ).
    server->response->set_status( code = 400 reason = 'Bad Request' ).
    server->response->set_cdata( lv_json ).
    RETURN.
  ENDIF.

  " 参数验证 - 表名格式
  IF lv_table CN 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'.
    lv_json = `{"error":"Invalid table name"}`.
    server->response->set_content_type( `application/json; charset=utf-8` ).
    server->response->set_status( code = 400 reason = 'Bad Request' ).
    server->response->set_cdata( lv_json ).
    RETURN.
  ENDIF.

  " 限制返回行数
  IF lv_limit IS INITIAL OR lv_limit <= 0.
    lv_limit = 10.
  ELSEIF lv_limit > 1000.
    lv_limit = 1000.
  ENDIF.

  "----------------------------------------------------------------------"
  " 2. 创建动态内表
  "----------------------------------------------------------------------"
  TRY.
      CREATE DATA lo_data TYPE STANDARD TABLE OF (lv_table).
      ASSIGN lo_data->* TO <lt_data>.

    " 捕获动态创建错误
    CATCH cx_dynamic_check INTO lx_err.
      lv_error = lx_err->get_text( ).
      CONCATENATE '{"error":"Invalid table name: ' lv_table '"}' INTO lv_json.
      server->response->set_content_type( `application/json; charset=utf-8` ).
      server->response->set_status( code = 400 reason = 'Bad Request' ).
      server->response->set_cdata( lv_json ).
      RETURN.
  ENDTRY.

  "----------------------------------------------------------------------"
  " 3. 执行动态查询 (无@语法,兼容ECC)
  "----------------------------------------------------------------------"
  TRY.
      SELECT *
        FROM (lv_table)
        UP TO lv_limit ROWS
        INTO CORRESPONDING FIELDS OF TABLE <lt_data>.

    CATCH cx_dynamic_check INTO lx_err.
      lv_error = lx_err->get_text( ).
      CONCATENATE '{"error":"Query failed: ' lv_error '"}' INTO lv_json.
      server->response->set_content_type( `application/json; charset=utf-8` ).
      server->response->set_status( code = 500 reason = 'Internal Server Error' ).
      server->response->set_cdata( lv_json ).
      RETURN.
  ENDTRY.

  "----------------------------------------------------------------------"
  " 4. 返回JSON响应 (abap_true改为'X',兼容ECC)
  "----------------------------------------------------------------------"
  lv_json = /ui2/cl_json=>serialize(
    data     = <lt_data>
    compress = 'X' ).                          " 使用'X'替代abap_true

  server->response->set_content_type( `application/json; charset=utf-8` ).
  server->response->set_cdata( lv_json ).

ENDMETHOD.
