# ABAP 报表开发模板

## 标准报表结构

```abap
*&---------------------------------------------------------------------*
*& Report  ZXXX_XXXX
*& Author  : Your Name
*& Date    : YYYY-MM-DD
*& SAP System: ECC 6.0
*& Description: [功能描述]
*&---------------------------------------------------------------------*

REPORT zxxx_xxxx MESSAGE-ID zxxx.

*------------------- Type Pools --------------------------------------*
TYPE-POOLS: slis.

*------------------- Tables ------------------------------------------*
TABLES: ekko, ekpo.

*------------------- Data Definitions --------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS:
      handle_user_command FOR EVENT user_command OF cl_gui_alv_grid,
      handle_double_click FOR EVENT double_click OF cl_gui_alv_grid.
ENDCLASS.

DATA: go_event_handler TYPE REF TO lcl_event_handler,
      go_grid          TYPE REF TO cl_gui_alv_grid,
      gt_fieldcat      TYPE slis_t_fieldcat_alv,
      gs_layout        TYPE slis_layout_alv.

*------------------- Selection Screen --------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
  SELECT-OPTIONS: s_ebeln FOR ekko-ebeln.
PARAMETERS: p_preview AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b1.

*------------------- Initialization ----------------------------------*
INITIALIZATION.
  " 初始化默认值

*------------------- At Selection Screen ------------------------------*
AT SELECTION-SCREEN.
  " 屏幕验证

*------------------- Start of Selection -------------------------------*
START-OF-SELECTION.
  PERFORM get_data.
  PERFORM display_alv.

*------------------- Forms -------------------------------------------*
FORM get_data.
  SELECT ekko~ebeln, ekko~bukrs, ekko~lifnr, ekpo~ebelp
    FROM ekko
    INNER JOIN ekpo ON ekko~ebeln = ekpo~ebeln
    INTO TABLE @DATA(lt_data)
    WHERE ekko~ebeln IN @s_ebeln.

  IF sy-subrc <> 0.
    MESSAGE 'No data found' TYPE 'I'.
  ENDIF.
ENDFORM.

FORM display_alv.
  gs_layout-colwidth_optimize = 'X'.
  gs_layout-zebra = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = gs_layout
      it_fieldcat        = gt_fieldcat
    TABLES
      t_outtab           = lt_data.
ENDFORM.
```

## ALV 字段目录定义

```abap
FORM build_fieldcat CHANGING ct_fieldcat TYPE slis_t_fieldcat_alv.
  DATA: ls_fcat TYPE slis_fieldcat_alv.

  CLEAR ls_fcat.
  ls_fcat-col_pos   = 1.
  ls_fcat-fieldname = 'EBELN'.
  ls_fcat-seltext_l = '采购凭证'.
  ls_fcat-outputlen = 10.
  APPEND ls_fcat TO ct_fieldcat.
ENDFORM.
```

## 注意事项

- 始终使用 `@DATA` 内联声明 (ABAP 7.4+)
- 使用 `SELECT` 指定字段，避免 `SELECT *`
- 添加适当的错误处理
- 包含用户指令文档注释