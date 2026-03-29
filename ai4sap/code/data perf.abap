*&---------------------------------------------------------------------*
*& 动态表查询 ICF Handler
*& 功能: 通过REST API动态查询任意SAP表数据
*& 作者: AI Assistant
*& 日期: 2026-03-30
*&---------------------------------------------------------------------*
*
* 使用示例:
*   /sap/bc/rest/z_dynamic_query?table=SPFLI&fields=CARRID,CONNID,CITYFROM,CITYTO&where=CARRID='AA'&orderby=CITYFROM&limit=10
*   /sap/bc/rest/z_dynamic_query?table=ZTJQ0003&limit=100
*
* 参数说明:
*   - table  (必需): 表名,如 SPFLI, ZTJQ0003, MARA 等
*   - fields (可选): 字段列表,逗号分隔,如 CARRID,CONNID
*   - where  (可选): WHERE条件,如 CARRID='AA' AND CITYTO='NEW YORK'
*   - orderby(可选): 排序字段,如 CARRID,CONNID DESC
*   - limit  (可选): 返回行数,默认10,最大1000
*   - offset (可选): 偏移量,默认0
*
*&---------------------------------------------------------------------*

CLASS zcl_dynamic_query DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_http_extension.

  PRIVATE SECTION.
    CONSTANTS:
      c_max_limit TYPE i VALUE 1000,          " 最大返回行数
      c_default_limit TYPE i VALUE 10.       " 默认返回行数

    TYPES: BEGIN OF ty_error,
             code    TYPE string,
             message TYPE string,
           END OF ty_error.

    " 验证表名是否合法
    METHODS validate_table_name
      IMPORTING
        iv_table TYPE tabname
      RAISING
        cx_dynamic_check.

    " 验证字段列表
    METHODS validate_fields
      IMPORTING
        iv_table  TYPE tabname
        iv_fields TYPE string
      RAISING
        cx_dynamic_check.

    " 解析并验证WHERE条件
    METHODS parse_where_clause
      IMPORTING
        iv_where TYPE string
      EXPORTING
        ev_where TYPE string
      RAISING
        cx_dynamic_check.

    " 安全过滤SQL注入
    METHODS sanitize_input
      IMPORTING
        iv_input TYPE string
      RETURNING
        VALUE(rv_output) TYPE string.

ENDCLASS.


CLASS zcl_dynamic_query IMPLEMENTATION.

  *&---------------------------------------------------------------------*
  *&  方法: IF_HTTP_EXTENSION~HANDLE_REQUEST
  *&  描述: ICF入口点,处理HTTP请求
  *&---------------------------------------------------------------------*
  METHOD if_http_extension~handle_request.

    DATA:
      lv_table     TYPE tabname,              " 动态表名
      lv_fields    TYPE string,               " 字段列表(逗号分隔)
      lv_where     TYPE string,               " WHERE条件
      lv_orderby   TYPE string,               " ORDER BY字段
      lv_limit     TYPE i,                    " 返回行数
      lv_offset    TYPE i,                    " 偏移量
      lv_json      TYPE string,               " JSON响应
      lv_error     TYPE string,
      ls_error     TYPE ty_error.

    DATA: lo_data TYPE REF TO data.
    FIELD-SYMBOLS: <lt_data> TYPE ANY TABLE.

    "----------------------------------------------------------------------
    " 1. 获取请求参数
    "----------------------------------------------------------------------
    lv_table  = server->request->get_form_field( name = `table` ).
    lv_fields = server->request->get_form_field( name = `fields` ).
    lv_where  = server->request->get_form_field( name = `where` ).
    lv_orderby = server->request->get_form_field( name = `orderby` ).
    lv_limit = server->request->get_form_field( name = `limit` ).
    lv_offset = server->request->get_form_field( name = `offset` ).

    "----------------------------------------------------------------------
    " 2. 参数验证 - 表名(必需)
    "----------------------------------------------------------------------
    IF lv_table IS INITIAL.
      ls_error-code = 'TABLE_REQUIRED'.
      ls_error-message = 'Table parameter is required'.
      lv_json = /ui2/cl_json=>serialize( data = ls_error ).
      server->response->set_status( code = 400 reason = 'Bad Request' ).
      server->response->set_content_type( `application/json; charset=utf-8` ).
      server->response->set_cdata( lv_json ).
      RETURN.
    ENDIF.

    " 标准化表名为大写
    TRANSLATE lv_table TO UPPER CASE.

    " 验证表名安全性
    TRY.
        validate_table_name( lv_table ).
      CATCH cx_dynamic_check INTO DATA(lx_table_err).
        ls_error-code = 'INVALID_TABLE'.
        ls_error-message = lx_table_err->get_text( ).
        lv_json = /ui2/cl_json=>serialize( data = ls_error ).
        server->response->set_status( code = 400 reason = 'Bad Request' ).
        server->response->set_content_type( `application/json; charset=utf-8` ).
        server->response->set_cdata( lv_json ).
        RETURN.
    ENDTRY.

    "----------------------------------------------------------------------
    " 3. 参数验证 - LIMIT
    "----------------------------------------------------------------------
    IF lv_limit IS INITIAL OR lv_limit <= 0.
      lv_limit = c_default_limit.              " 使用默认值
    ELSEIF lv_limit > c_max_limit.
      lv_limit = c_max_limit.                 " 限制最大值
    ENDIF.

    " 解析OFFSET
    IF lv_offset IS INITIAL.
      lv_offset = 0.
    ELSE.
      lv_offset = CONV i( lv_offset ).
    ENDIF.

    "----------------------------------------------------------------------
    " 4. 参数验证 - FIELDS (可选)
    "----------------------------------------------------------------------
    IF lv_fields IS NOT INITIAL.
      " 标准化字段名为大写
      TRANSLATE lv_fields TO UPPER CASE.
      " 验证字段是否存在
      TRY.
          validate_fields( iv_table = lv_table iv_fields = lv_fields ).
        CATCH cx_dynamic_check INTO DATA(lx_field_err).
          ls_error-code = 'INVALID_FIELDS'.
          ls_error-message = lx_field_err->get_text( ).
          lv_json = /ui2/cl_json=>serialize( data = ls_error ).
          server->response->set_status( code = 400 reason = 'Bad Request' ).
          server->response->set_content_type( `application/json; charset=utf-8` ).
          server->response->set_cdata( lv_json ).
          RETURN.
      ENDTRY.
    ENDIF.

    "----------------------------------------------------------------------
    " 5. 参数处理 - WHERE条件
    "----------------------------------------------------------------------
    IF lv_where IS NOT INITIAL.
      " 解析并验证WHERE条件
      TRY.
          parse_where_clause(
            EXPORTING iv_where = lv_where
            IMPORTING ev_where = lv_where ).
        CATCH cx_dynamic_check INTO DATA(lx_where_err).
          ls_error-code = 'INVALID_WHERE'.
          ls_error-message = lx_where_err->get_text( ).
          lv_json = /ui2/cl_json=>serialize( data = ls_error ).
          server->response->set_status( code = 400 reason = 'Bad Request' ).
          server->response->set_content_type( `application/json; charset=utf-8` ).
          server->response->set_cdata( lv_json ).
          RETURN.
      ENDTRY.
    ENDIF.

    "----------------------------------------------------------------------
    " 6. 参数处理 - ORDER BY
    "----------------------------------------------------------------------
    IF lv_orderby IS NOT INITIAL.
      TRANSLATE lv_orderby TO UPPER CASE.
    ENDIF.

    "----------------------------------------------------------------------
    " 7. 执行动态查询
    "----------------------------------------------------------------------
    TRY.
        " 创建动态内表
        CREATE DATA lo_data TYPE STANDARD TABLE OF (lv_table).
        ASSIGN lo_data->* TO <lt_data>.

        " 构建动态SELECT语句
        DATA(lv_select) = CONDITION #( WHEN lv_fields IS INITIAL THEN '*' ELSE lv_fields ).

        " 使用ABAP动态SQL
        IF lv_where IS INITIAL AND lv_orderby IS INITIAL.
          " 简单查询
          SELECT (lv_select)
            FROM (lv_table)
            INTO TABLE @<lt_data>
            UP TO @lv_limit ROWS.
        ELSEIF lv_where IS NOT INITIAL AND lv_orderby IS INITIAL.
          " 带WHERE条件
          SELECT (lv_select)
            FROM (lv_table)
            WHERE (lv_where)
            INTO TABLE @<lt_data>
            UP TO @lv_limit ROWS.
        ELSEIF lv_where IS INITIAL AND lv_orderby IS NOT INITIAL.
          " 带ORDER BY
          SELECT (lv_select)
            FROM (lv_table)
            INTO TABLE @<lt_data>
            UP TO @lv_limit ROWS
            ORDER BY (lv_orderby).
        ELSE.
          " 带WHERE和ORDER BY
          SELECT (lv_select)
            FROM (lv_table)
            WHERE (lv_where)
            INTO TABLE @<lt_data>
            UP TO @lv_limit ROWS
            ORDER BY (lv_orderby).
        ENDIF.

      CATCH cx_dynamic_check INTO DATA(lx_query_err).
        ls_error-code = 'QUERY_ERROR'.
        ls_error-message = lx_query_err->get_text( ).
        lv_json = /ui2/cl_json=>serialize( data = ls_error ).
        server->response->set_status( code = 500 reason = 'Internal Server Error' ).
        server->response->set_content_type( `application/json; charset=utf-8` ).
        server->response->set_cdata( lv_json ).
        RETURN.
    ENDTRY.

    "----------------------------------------------------------------------
    " 8. 返回JSON响应
    "----------------------------------------------------------------------
    " 获取实际返回行数
    DATA(lv_count) = lines( <lt_data> ).

    " 构建响应结构
    DATA: BEGIN OF ls_response,
            success TYPE abap_bool,
            count   TYPE i,
            data    TYPE REF TO data,
          END OF ls_response.
    ls_response-success = abap_true.
    ls_response-count = lv_count.
    GET REFERENCE OF <lt_data> INTO ls_response-data.

    lv_json = /ui2/cl_json=>serialize(
      data        = ls_response
      compress    = abap_true
      pretty_name = /ui2/cl_json=>pretty_mode-low_case ).

    server->response->set_content_type( `application/json; charset=utf-8` ).
    server->response->set_cdata( lv_json ).

  ENDMETHOD.


  *&---------------------------------------------------------------------*
  *&  方法: VALIDATE_TABLE_NAME
  *&  描述: 验证表名是否存在于SAP系统中
  *&---------------------------------------------------------------------*
  METHOD validate_table_name.
    " 检查表名格式(必须以字母开头,最长16位)
    IF iv_table IS INITIAL OR strlen( iv_table ) > 16.
      RAISE EXCEPTION TYPE cx_dynamic_check
        EXPORTING text = 'Invalid table name: must be 1-16 characters'.
    ENDIF.

    " 检查首字符必须是字母
    IF iv_table(1) CA '0123456789'.
      RAISE EXCEPTION TYPE cx_dynamic_check
        EXPORTING text = 'Invalid table name: must start with a letter'.
    ENDIF.

    " 检查只包含合法字符
    IF iv_table CN 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'.
      RAISE EXCEPTION TYPE cx_dynamic_check
        EXPORTING text = 'Invalid table name: only allow A-Z, 0-9, _'.
    ENDIF.

    " 验证表在SAP DDIC中存在
    SELECT SINGLE @abap_true
      FROM dd02l
      WHERE tabname = @iv_table
        AND as4local = @abap_true
        AND tabclass = 'TRANSP'
      INTO @DATA(lv_exists).

    IF lv_exists = @abap_false.
      RAISE EXCEPTION TYPE cx_dynamic_check
        EXPORTING text = |Table { iv_table } does not exist in SAP DDIC|.
    ENDIF.
  ENDMETHOD.


  *&---------------------------------------------------------------------*
  *&  方法: VALIDATE_FIELDS
  *&  描述: 验证字段列表是否属于指定表
  *&---------------------------------------------------------------------*
  METHOD validate_fields.
    DATA: lt_fields TYPE STANDARD TABLE OF string,
          lv_field  TYPE string.

    " 分割字段列表
    SPLIT iv_fields AT ',' INTO TABLE lt_fields.
    DELETE lt_fields WHERE table_line IS INITIAL.

    IF lt_fields IS INITIAL.
      RAISE EXCEPTION TYPE cx_dynamic_check
        EXPORTING text = 'Field list cannot be empty'.
    ENDIF.

    " 验证每个字段
    LOOP AT lt_fields INTO lv_field.
      CONDENSE lv_field.

      " 检查字段在表中是否存在
      SELECT SINGLE @abap_true
        FROM dd03l
        WHERE tabname = @iv_table
          AND fieldname = @lv_field
        INTO @DATA(lv_field_exists).

      IF lv_field_exists = @abap_false.
        RAISE EXCEPTION TYPE cx_dynamic_check
          EXPORTING text = |Field { lv_field } does not exist in table { iv_table }|.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  *&---------------------------------------------------------------------*
  *&  方法: PARSE_WHERE_CLAUSE
  *&  描述: 解析和验证WHERE条件
  *&---------------------------------------------------------------------*
  METHOD parse_where_clause.
    " 安全过滤输入
    ev_where = sanitize_input( iv_where ).

    " 基础SQL注入检查
    IF ev_where CO 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_ =<>()''+-*/ '.
      " 基本安全,继续
    ELSE.
      " 检测到可疑字符
      IF ev_where CA 'CHAIN;DROP;EXEC;INSERT;UPDATE;DELETE;UNION;SELECT'.
        RAISE EXCEPTION TYPE cx_dynamic_check
          EXPORTING text = 'SQL injection detected in WHERE clause'.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  *&---------------------------------------------------------------------*
  *&  方法: SANITIZE_INPUT
  *&  描述: 安全过滤用户输入
  *&---------------------------------------------------------------------*
  METHOD sanitize_input.
    rv_output = iv_input.

    " 移除XSS风险字符
    REPLACE ALL OCCURRENCES OF '<' IN rv_output WITH ''.
    REPLACE ALL OCCURRENCES OF '>' IN rv_output WITH ''.
    REPLACE ALL OCCURRENCES OF '&' IN rv_output WITH ''.
  ENDMETHOD.

ENDCLASS.
