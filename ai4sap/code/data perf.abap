*"---------------------------------------------------------------------*
*"* 动态表数据查询 HTTP Handler
*"*
*"* 功能: 通过 REST API 动态查询 SAP 表数据
*"* 
*"* 参数说明:
*"*   - table    : 表名 (必需)
*"*   - fields   : 字段列表,逗号分隔 (可选, 默认 *)
*"*   - where    : WHERE 条件 (可选)
*"*   - orderby  : 排序字段 (可选)
*"*   - rows     : 返回行数 (可选, 默认 10)
*"*
*"* 使用示例:
*"*   /sap/bc/zzjq?table=MARA&rows=5
*"*   /sap/bc/zzjq?table=MARA&fields=MATNR,ERSDA&rows=10
*"*   /sap/bc/zzjq?table=KNA1&where=LAND1='CN'&orderby=KUNNR&rows=20
*"*
*"* 作者: OpenCode AI
*"* 日期: 2026-03-30
*"---------------------------------------------------------------------*

*"---------------------------------------------------------------------*
*"* 接口定义
*"---------------------------------------------------------------------*
INTERFACE if_http_extension.
  METHODS handle_request
    IMPORTING
      server TYPE REF TO if_http_server.
ENDINTERFACE.

*"---------------------------------------------------------------------*
"* 类定义
*"---------------------------------------------------------------------*
CLASS zcl_dynamic_table_query DEFINITION.
  PUBLIC SECTION.

    *"---------------------------------------------------------------------*
    *"* 接口实现 - HTTP 请求处理
    *"---------------------------------------------------------------------*
    METHODS if_http_extension~handle_request
      IMPORTING
        server TYPE REF TO if_http_server.

  PRIVATE SECTION.

    *"---------------------------------------------------------------------*
    "* 私有方法 - 参数获取
    *"---------------------------------------------------------------------*
    METHODS get_form_param
      IMPORTING
        iv_name      TYPE string
        iv_default   TYPE string OPTIONAL
      RETURNING
        VALUE(rv_value) TYPE string.

    *"---------------------------------------------------------------------*
    "* 私有方法 - 参数验证
    *"---------------------------------------------------------------------*
    METHODS validate_parameters
      IMPORTING
        iv_table   TYPE string
        iv_fields  TYPE string
        iv_where   TYPE string
        iv_orderby TYPE string
        iv_rows    TYPE string
      RETURNING
        VALUE(rv_valid) TYPE abap_bool
      EXPORTING
        ev_error_msg TYPE string.

    *"---------------------------------------------------------------------*
    "* 私有方法 - 构建动态查询
    *"---------------------------------------------------------------------*
    METHODS build_dynamic_select
      IMPORTING
        iv_table   TYPE string
        iv_fields  TYPE string
        iv_where   TYPE string
        iv_orderby TYPE string
        iv_rows    TYPE i
      EXPORTING
        ev_select  TYPE string
        ev_error   TYPE string.

    *"---------------------------------------------------------------------*
    "* 私有方法 - 执行查询
    *"---------------------------------------------------------------------*
    METHODS execute_query
      IMPORTING
        iv_select TYPE string
      EXPORTING
        et_data   TYPE STANDARD TABLE
        ev_error  TYPE string.

    *"---------------------------------------------------------------------*
    "* 私有方法 - 返回 JSON 响应
    *"---------------------------------------------------------------------*
    METHODS return_json_response
      IMPORTING
        iv_data     TYPE any
        iv_success  TYPE abap_bool
        iv_message  TYPE string OPTIONAL.

ENDCLASS.

*"---------------------------------------------------------------------*
"* 类实现
*"---------------------------------------------------------------------*
CLASS zcl_dynamic_table_query IMPLEMENTATION.

  *"---------------------------------------------------------------------*
  "* 方法: if_http_extension~handle_request
  "* 说明: HTTP 请求入口点
  *"---------------------------------------------------------------------*
  METHOD if_http_extension~handle_request.
    
    DATA:
      lv_table    TYPE string,          " 表名
      lv_fields   TYPE string,          " 字段列表
      lv_where    TYPE string,          " WHERE 条件
      lv_orderby  TYPE string,          " ORDER BY 条件
      lv_rows     TYPE string,          " 行数限制
      lv_rows_int TYPE i,               " 行数 (整型)
      lv_select   TYPE string,          " SELECT 语句
      lv_error    TYPE string,          " 错误信息
      lt_data     TYPE STANDARD TABLE,  " 查询结果
      lv_json     TYPE string.          " JSON 响应

    " 1. 获取请求参数
    lv_table   = me->get_form_param( iv_name = 'table' ).
    lv_fields  = me->get_form_param( iv_name = 'fields' ).
    lv_where   = me->get_form_param( iv_name = 'where' ).
    lv_orderby = me->get_form_param( iv_name = 'orderby' ).
    lv_rows    = me->get_form_param( iv_name = 'rows' iv_default = '10' ).

    " 2. 参数验证 - 表名必须大写
    TRANSLATE lv_table TO UPPER CASE.

    " 3. 验证参数
    IF me->validate_parameters(
        iv_table   = lv_table
        iv_fields  = lv_fields
        iv_where   = lv_where
        iv_orderby = lv_orderby
        iv_rows    = lv_rows
      ) = abap_false.
      
      " 返回验证错误
      me->return_json_response(
        iv_data    = lt_data
        iv_success = abap_false
        iv_message = lv_error
      ).
      RETURN.
    ENDIF.

    " 4. 转换行数为整数
    lv_rows_int = CONV i( lv_rows ).
    IF lv_rows_int <= 0 OR lv_rows_int > 1000.
      lv_rows_int = 10.  " 默认值
    ENDIF.

    " 5. 构建动态 SELECT 语句
    me->build_dynamic_select(
      EXPORTING
        iv_table   = lv_table
        iv_fields  = lv_fields
        iv_where   = lv_where
        iv_orderby = lv_orderby
        iv_rows    = lv_rows_int
      IMPORTING
        ev_select  = lv_select
        ev_error   = lv_error
    ).

    IF lv_error IS NOT INITIAL.
      me->return_json_response(
        iv_data    = lt_data
        iv_success = abap_false
        iv_message = lv_error
      ).
      RETURN.
    ENDIF.

    " 6. 执行查询
    me->execute_query(
      EXPORTING
        iv_select = lv_select
      IMPORTING
        et_data   = lt_data
        ev_error  = lv_error
    ).

    IF lv_error IS NOT INITIAL.
      me->return_json_response(
        iv_data    = lt_data
        iv_success = abap_false
        iv_message = lv_error
      ).
      RETURN.
    ENDIF.

    " 7. 返回成功响应 (JSON)
    me->return_json_response(
      iv_data    = lt_data
      iv_success = abap_true
      iv_message = |查询成功，返回 { lines( lt_data ) } 条记录|
    ).

  ENDMETHOD.

  *"---------------------------------------------------------------------*
  "* 方法: get_form_param
  "* 说明: 获取表单参数
  *"---------------------------------------------------------------------*
  METHOD get_form_param.
    
    DATA: lv_value TYPE string.
    
    lv_value = server->request->get_form_field( name = iv_name ).
    
    IF lv_value IS INITIAL AND iv_default IS SUPPLIED.
      rv_value = iv_default.
    ELSE.
      rv_value = lv_value.
    ENDIF.
    
    " 去除前后空格
    SHIFT rv_value LEFT DELETING LEADING space.
    SHIFT rv_value RIGHT DELETING TRAILING space.
    
  ENDMETHOD.

  *"---------------------------------------------------------------------*
  "* 方法: validate_parameters
  "* 说明: 验证输入参数
  *"---------------------------------------------------------------------*
  METHOD validate_parameters.
    
    rv_valid = abap_true.
    ev_error_msg = ''.

    " 1. 验证表名 (必需)
    IF iv_table IS INITIAL.
      rv_valid = abap_false.
      ev_error_msg = '错误: 表名 (table) 参数不能为空'.
      RETURN.
    ENDIF.

    " 2. 验证表名格式 (只能是字母和数字)
    IF iv_table CN 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'.
      rv_valid = abap_false.
      ev_error_msg = '错误: 表名格式不正确，只允许字母、数字和下划线'.
      RETURN.
    ENDIF.

    " 3. 验证字段列表 (如果提供)
    IF iv_fields IS NOT INITIAL.
      IF iv_fields CN 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_,'.
        rv_valid = abap_false.
        ev_error_msg = '错误: 字段列表格式不正确'.
        RETURN.
      ENDIF.
    ENDIF.

    " 4. 验证 WHERE 条件 (基础检查)
    IF iv_where IS NOT INITIAL.
      " 防止 SQL 注入 - 简单检查
      IF iv_where CO 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_=''<>.' OR
         iv_where CA '; DROP' OR
         iv_where CA 'DELETE' OR
         iv_where CA 'UPDATE' OR
         iv_where CA 'INSERT'.
        rv_valid = abap_false.
        ev_error_msg = '错误: WHERE 条件包含非法字符或关键词'.
        RETURN.
      ENDIF.
    ENDIF.

    " 5. 验证 ORDER BY (基础检查)
    IF iv_orderby IS NOT INITIAL.
      IF iv_orderby CN 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_ ,'.
        rv_valid = abap_false.
        ev_error_msg = '错误: ORDER BY 字段格式不正确'.
        RETURN.
      ENDIF.
    ENDIF.

    " 6. 验证行数
    IF iv_rows IS NOT INITIAL.
      DATA lv_rows TYPE i.
      TRY.
          lv_rows = CONV i( iv_rows ).
          IF lv_rows < 1 OR lv_rows > 1000.
            rv_valid = abap_false.
            ev_error_msg = '错误: 行数 (rows) 必须在 1-1000 之间'.
            RETURN.
          ENDIF.
        CATCH cx_sy_conversion_error.
          rv_valid = abap_false.
          ev_error_msg = '错误: 行数 (rows) 必须是数字'.
          RETURN.
      ENDTRY.
    ENDIF.

  ENDMETHOD.

  *"---------------------------------------------------------------------*
  "* 方法: build_dynamic_select
  "* 说明: 构建动态 SELECT 语句
  "*---------------------------------------------------------------------*
  METHOD build_dynamic_select.
    
    DATA: lv_fields TYPE string.
    ev_select = ''.
    ev_error = ''.

    " 1. 处理字段列表
    IF iv_fields IS INITIAL.
      lv_fields = '*'.
    ELSE.
      " 去除空格
      REPLACE ALL OCCURRENCES OF ' ' IN iv_fields WITH ''.
      lv_fields = iv_fields.
    ENDIF.

    " 2. 构建 SELECT 语句
    ev_select = |SELECT { lv_fields } FROM { iv_table }|.

    " 3. 添加 WHERE 条件
    IF iv_where IS NOT INITIAL.
      ev_select = ev_select && | WHERE { iv_where }|.
    ENDIF.

    " 4. 添加 ORDER BY
    IF iv_orderby IS NOT INITIAL.
      ev_select = ev_select && | ORDER BY { iv_orderby }|.
    ENDIF.

    " 5. 添加行数限制
    IF iv_rows > 0.
      ev_select = ev_select && | UP TO { iv_rows } ROWS |.
    ENDIF.

    " 添加 INTO TABLE (动态内表)
    ev_select = ev_select && | INTO TABLE @DATA(lt_result)|.

  ENDMETHOD.

  *"---------------------------------------------------------------------*
  "* 方法: execute_query
  "* 说明: 执行动态 SELECT 查询
  *"---------------------------------------------------------------------*
  METHOD execute_query.
    
    FIELD-SYMBOLS <lt_data> TYPE STANDARD TABLE.
    
    et_data = VALUE #( ).  " 初始化
    ev_error = ''.

    " 执行动态查询
    TRY.
        CREATE DATA et_data TYPE STANDARD TABLE OF (space).
        ASSIGN et_data->* TO <lt_data>.

        " 使用动态 SQL
        EXECUTE IMMEDIATE iv_select INTO TABLE <lt_data>.

      CATCH cx_root INTO DATA(lx_error).
        ev_error = |查询错误: { lx_error->get_text( ) }|.
    ENDTRY.

  ENDMETHOD.

  *"---------------------------------------------------------------------*
  "* 方法: return_json_response
  "* 说明: 返回 JSON 格式响应
  *"---------------------------------------------------------------------*
  METHOD return_json_response.
    
    DATA: lv_json TYPE string.
    DATA: ls_response TYPE ty_response.  " 需要定义响应结构

    " 构建响应结构
    IF iv_success = abap_true.
      " 成功响应
      /ui2/cl_json=>serialize(
        EXPORTING
          data             = iv_data
          compress         = abap_true
          pretty_print     = abap_true
        RECEIVING
          r_json           = lv_json
      ).

      " 添加元信息
      lv_json = |{{\n  \"success\": true,\n  \"message\": \"{ iv_message }\",\n  \"data\": { lv_json }\n}}|.
    ELSE.
      " 错误响应
      lv_json = |{{\n  \"success\": false,\n  \"message\": \"{ iv_message }\",\n  \"data\": []\n}}|.
    ENDIF.

    " 设置响应头
    server->response->set_content_type( 'application/json; charset=utf-8' ).
    server->response->set_header_field(
      name  = 'Access-Control-Allow-Origin'
      value = '*'
    ).
    server->response->set_cdata( lv_json ).

  ENDMETHOD.

ENDCLASS.

*"---------------------------------------------------------------------*
"* 请求/响应结构定义
*"---------------------------------------------------------------------*
TYPES: BEGIN OF ty_response,
         success TYPE abap_bool,
         message TYPE string,
         data    TYPE STANDARD TABLE,
       END OF ty_response.
