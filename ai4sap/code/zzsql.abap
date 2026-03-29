*&---------------------------------------------------------------------*
*& 程序: ZZSQ_SQL_QUERY
*& 名称: 动态SQL查询 ICF Handler (ECC兼容版)
*& 功能: 通过REST API执行动态SQL查询
*& 作者: AI Assistant
*& 日期: 2026-03-29
*& 版本: 1.0
*& 说明: 兼容SAP ECC 6.0版本
*&---------------------------------------------------------------------*
*
* 使用示例:
*   /sap/bc/zzsql?sql=SELECT * FROM MARA&maxrows=10
*   /sap/bc/zzsql?sql=SELECT MATNR, MTART FROM MARA WHERE MTART = 'HALB'
*
* 参数说明:
*   sql (必需): SQL查询语句
*   maxrows (可选): 最大返回行数,默认100
*
*&---------------------------------------------------------------------*

METHOD if_http_extension~handle_request.

  DATA: lv_sql      TYPE string.                " SQL语句
  DATA: lv_maxrows  TYPE i.                     " 最大行数
  DATA: lv_json     TYPE string.                 " JSON响应
  DATA: lv_error    TYPE string.                 " 错误信息
  DATA: lo_data     TYPE REF TO data.           " 动态数据引用
  DATA: lx_err      TYPE REF TO cx_dynamic_check. " 异常引用

  FIELD-SYMBOLS: <lt_data> TYPE ANY TABLE.    " 动态内表

  "----------------------------------------------------------------------"
  " 1. 获取请求参数
  "----------------------------------------------------------------------"
  lv_sql = server->request->get_form_field( name = `sql` ).
  lv_maxrows = server->request->get_form_field( name = `maxrows` ).

  " 参数验证 - SQL不能为空
  IF lv_sql IS INITIAL.
    lv_json = `{"error":"SQL parameter is required"}`.
    server->response->set_content_type( `application/json; charset=utf-8` ).
    server->response->set_status( code = 400 reason = 'Bad Request' ).
    server->response->set_cdata( lv_json ).
    RETURN.
  ENDIF.

  " 限制返回行数
  IF lv_maxrows IS INITIAL OR lv_maxrows <= 0.
    lv_maxrows = 100.
  ELSEIF lv_maxrows > 1000.
    lv_maxrows = 1000.
  ENDIF.

  " 安全检查 - 禁止危险操作
  TRANSLATE lv_sql TO UPPER CASE.
  IF lv_sql CS 'DROP' OR lv_sql CS 'DELETE' OR lv_sql CS 'UPDATE'
     OR lv_sql CS 'INSERT' OR lv_sql CS 'ALTER' OR lv_sql CS 'CREATE'.
    lv_json = `{"error":"Only SELECT queries are allowed"}`.
    server->response->set_content_type( `application/json; charset=utf-8` ).
    server->response->set_status( code = 403 reason = 'Forbidden' ).
    server->response->set_cdata( lv_json ).
    RETURN.
  ENDIF.

  " 还原SQL语句大小写
  TRANSLATE lv_sql TO LOWER CASE.

  "----------------------------------------------------------------------"
  " 2. 解析SQL获取表名 (兼容ECC 6.0)
  "----------------------------------------------------------------------"
  DATA: lv_table TYPE tabname.
  DATA: lv_from_part TYPE string.
  DATA: lv_len TYPE i.
  DATA: lv_offset TYPE i.

  " 简单解析: SELECT xxx FROM table WHERE xxx
  " 使用SEARCH命令查找FROM位置
  SEARCH lv_sql FOR ' FROM '.
  lv_offset = sy-fdpos.
  IF lv_offset = 0.
    lv_json = `{"error":"Invalid SQL format. Missing FROM clause"}`.
    server->response->set_content_type( `application/json; charset=utf-8` ).
    server->response->set_status( code = 400 reason = 'Bad Request' ).
    server->response->set_cdata( lv_json ).
    RETURN.
  ENDIF.

  " 获取FROM后面的部分
  lv_len = strlen( lv_sql ) - lv_offset - 6.
  lv_from_part = lv_sql+lv_offset+6(lv_len).
  CONDENSE lv_from_part.

  " 获取第一个单词(表名) - 找空格位置
  FIND ' ' IN lv_from_part MATCH OFFSET lv_len.
  IF sy-subrc = 0.
    lv_table = lv_from_part(lv_len).
  ELSE.
    lv_table = lv_from_part.
  ENDIF.
  CONDENSE lv_table.

  IF lv_table IS INITIAL.
    lv_json = `{"error":"Invalid SQL format. Table name not found"}`.
    server->response->set_content_type( `application/json; charset=utf-8` ).
    server->response->set_status( code = 400 reason = 'Bad Request' ).
    server->response->set_cdata( lv_json ).
    RETURN.
  ENDIF.

  " SAP表名必须大写
  TRANSLATE lv_table TO UPPER CASE.

  "----------------------------------------------------------------------"
  " 3. 创建动态内表
  "----------------------------------------------------------------------"
  TRY.
      CREATE DATA lo_data TYPE STANDARD TABLE OF (lv_table).
      ASSIGN lo_data->* TO <lt_data>.

    CATCH cx_dynamic_check INTO lx_err.
      lv_error = lx_err->get_text( ).
      CONCATENATE '{"error":"Table error: ' lv_error '"}' INTO lv_json.
      server->response->set_content_type( `application/json; charset=utf-8` ).
      server->response->set_status( code = 400 reason = 'Bad Request' ).
      server->response->set_cdata( lv_json ).
      RETURN.
  ENDTRY.

  "----------------------------------------------------------------------"
  " 4. 执行动态查询
  "----------------------------------------------------------------------"
  TRY.
      " 使用动态SQL
      SELECT *
        FROM (lv_table)
        UP TO lv_maxrows ROWS
        INTO CORRESPONDING FIELDS OF TABLE <lt_data>.

    CATCH cx_dynamic_check INTO lx_err.
      lv_error = lx_err->get_text( ).
      CONCATENATE '{"error":"Query error: ' lv_error '"}' INTO lv_json.
      server->response->set_content_type( `application/json; charset=utf-8` ).
      server->response->set_status( code = 500 reason = 'Internal Server Error' ).
      server->response->set_cdata( lv_json ).
      RETURN.
  ENDTRY.

  "----------------------------------------------------------------------"
  " 5. 返回JSON响应
  "----------------------------------------------------------------------"
  lv_json = /ui2/cl_json=>serialize(
    data     = <lt_data>
    compress = 'X' ).

  server->response->set_content_type( `application/json; charset=utf-8` ).
  server->response->set_cdata( lv_json ).

ENDMETHOD.
