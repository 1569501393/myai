# ABAP 批处理开发模板

## 标准批处理程序结构

```abap
*&---------------------------------------------------------------------*
*& Report  ZXXX_BATCH_XXXX
*& Author  : Your Name
*& Date    : YYYY-MM-DD
*& SAP System: ECC 6.0
*& Job     : Z_XXX_BATCH
*& Description: [批处理功能描述]
*&---------------------------------------------------------------------*

REPORT zxxx_batch_xxxx
       NO STANDARD PAGE HEADING
       MESSAGE-ID zxxx.

*------------------- Type Pools --------------------------------------*
TYPE-POOLS: slis, truxs.

*------------------- Tables ------------------------------------------*
TABLES: marc, mard.

*------------------- Types --------------------------------------------*
TYPES:
  BEGIN OF ty_input,
    matnr TYPE matnr,
    werks TYPE werks_d,
    lgort TYPE lgort,
    menge TYPE menge_d,
  END OF ty_input,

  BEGIN OF ty_result,
    matnr   TYPE matnr,
    message TYPE bapi_msg,
    status  TYPE icon_d,
  END OF ty_result.

*------------------- Data Definitions --------------------------------*
DATA: gt_input   TYPE TABLE OF ty_input,
      gt_result  TYPE TABLE OF ty_result,
      gs_input   TYPE ty_input,
      gs_result  TYPE ty_result.

DATA: gv_jobname TYPE tbtcm-jobname,
      gv_jobcount TYPE tbtcm-jobcount.

*------------------- Selection Screen --------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
  PARAMETERS: p_test   TYPE c RADIOBUTTON GROUP rbt DEFAULT 'X',
              p_prod   TYPE c RADIOBUTTON GROUP rbt.

  SELECT-OPTIONS: s_matnr FOR marc-matnr.
  PARAMETERS: p_verid TYPE verid DEFAULT '0001'.
SELECTION-SCREEN END OF BLOCK b1.

*------------------- Initialization ----------------------------------*
INITIALIZATION.
  gv_jobname = 'Z_XXX_BATCH'.

*------------------- At Selection Screen ------------------------------*
AT SELECTION-SCREEN OUTPUT.
  " 屏幕权限控制

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_verid.
  " F4 帮助

*------------------- Start of Selection -------------------------------*
START-OF-SELECTION.
  IF p_test = abap_true.
    PERFORM process_test_mode.
  ELSE.
    PERFORM submit_batch_job.
  ENDIF.

*------------------- Forms -------------------------------------------*
FORM get_input_data.
  SELECT matnr, werks, lgort, menge
    FROM mard
    INTO TABLE gt_input
    WHERE matnr IN s_matnr
      AND werks = p_werks.

  IF gt_input IS INITIAL.
    MESSAGE 'No data found' TYPE 'E'.
  ENDIF.
ENDFORM.

FORM process_records.
  DATA: lv_index TYPE sy-tabix.

  LOOP AT gt_input INTO gs_input.
    lv_index = sy-tabix.
    CLEAR gs_result.

    TRY.
      " 业务处理逻辑
      gs_result-matnr = gs_input-matnr.
      gs_result-status = icon_green_light.
      gs_result-message = 'Success'.

    CATCH cx_root INTO DATA(lo_error).
      gs_result-status = icon_red_light.
      gs_result-message = lo_error->get_text( ).
    ENDTRY.

    MODIFY gt_input FROM gs_input INDEX lv_index.
  ENDLOOP.
ENDFORM.

FORM display_results.
  DATA: lo_alv TYPE REF TO cl_salv_table.

  TRY.
    cl_salv_table=>factory(
      IMPORTING r_salv_table = DATA(lo_alv)
      CHANGING  t_table      = gt_result ).

    lo_alv->display( ).
  CATCH cx_salv_msg INTO DATA(lo_msg).
    MESSAGE lo_msg TYPE 'E'.
  ENDTRY.
ENDFORM.

FORM submit_batch_job.
  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname  = gv_jobname
    IMPORTING
      jobcount = gv_jobcount
    EXCEPTIONS
      OTHERS   = 1.

  IF sy-subrc = 0.
    SUBMIT zxxx_batch_xxxx
           WITH s_matnr IN s_matnr
           WITH p_verid = p_verid
           WITH p_test = space
           USER sy-uname
           VIA JOB gv_jobname NUMBER gv_jobcount
           TO SAP SPOOL.

    CALL FUNCTION 'JOB_CLOSE'
      EXPORTING
        jobname  = gv_jobname
        jobcount = gv_jobcount
      EXCEPTIONS
        OTHERS   = 1.
  ENDIF.
ENDFORM.
```

## 批处理最佳实践

1. **测试/生产模式切换**: 使用参数区分
2. **错误处理**: 单条错误不影响整批
3. **日志记录**: 写入数据库表或文件
4. **进度显示**: 使用 `SAP GUI PROGRESS INDICATOR`
5. **作业调度**: 通过 `SM36/SM37` 管理

## 注意事项

- 大数据量使用 `SCMS_ARRAY_TO_XSTRING` 批量处理
- 避免长时间运行的 COMMIT WORK
- 使用 `GET RUN TIME FIELD` 监控性能