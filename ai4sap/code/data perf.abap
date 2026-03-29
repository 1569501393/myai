" 通过参数 table 获取表数据
" http://mysap.goodsap.cn:50400/sap/bc/zzjq?sap-client=400&table=mara

  METHOD if_http_extension~handle_request.
FIELD-SYMBOLS: <dyn_table> TYPE ANY TABLE.

DATA:
    lv_table     TYPE tabname,        " 动态表名
    lv_carrid    TYPE string,         " 查询参数
    lt_data      TYPE REF TO data,    " 动态内表对象
    lv_json      TYPE string.

  " 1. 获取请求参数
  lv_table = server->request->get_form_field( name = `table` ).
  TRANSLATE lv_table TO UPPER CASE. " SAP表名必须大写
  lv_carrid = server->request->get_form_field( name = `carrid` ).

  " 2. 【核心修复】创建动态内表 + 定义标准内表字段符号
  CREATE DATA lt_data TYPE STANDARD TABLE OF (lv_table).
  ASSIGN lt_data->* TO <dyn_table>.

  " 3. 【修复语法】动态SELECT（解决「不是内部表」错误）
  TRY.
      " 严格使用ABAP标准动态查询语法
      SELECT *
        FROM (lv_table)
        UP TO 3 ROWS
*       WHERE carrid = @( to_upper(
*             cl_abap_dyn_prg=>escape_quotes(
*               val = escape( val = lv_carrid
*                             format = cl_abap_format=>e_xss_ml ) ) ) )
       INTO TABLE @<dyn_table>. " 关键：加 @ 符号

    CATCH cx_root INTO DATA(lx_err).
      server->response->set_cdata( `错误：` && lx_err->get_text( ) ).
      RETURN.
  ENDTRY.

  " 4. 返回结果（REST接口推荐JSON格式）
  lv_json = /ui2/cl_json=>serialize( data = <dyn_table> compress = abap_true ).
  server->response->set_content_type( `application/json; charset=utf-8` ).
  server->response->set_cdata( lv_json ).

*    "cl_demo_output=>get converts ABAP data to HTML and is secure
*    server->response->set_cdata(
*      data = cl_demo_output=>get( <dyn_table> ) ).

  ENDMETHOD.