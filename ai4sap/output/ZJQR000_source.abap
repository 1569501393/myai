*&---------------------------------------------------------------------*
*& Report ZJQR000
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zjqr000.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
  PARAMETERS p_str(255) TYPE c DEFAULT 'abc'.
*  PARAMETERS p_pos TYPE i DEFAULT 1.
  PARAMETERS p_pos TYPE string DEFAULT 1.
  PARAMETERS p_num1 TYPE num02 DEFAULT 1.
  PARAMETERS p_num2 TYPE num02 DEFAULT 0.
SELECTION-SCREEN END OF BLOCK b1.



*debug
WRITE:/ 'Hello World'.

RETURN.



DATA: gv_cx_root TYPE REF TO cx_root.

TRY .
RAISE EXCEPTION TYPE cx_demo_abs_too_large.

CATCH cx_root INTO gv_cx_root.
  " 01.07.2025 23:18:54 By JieQiang TODO 调试输出
  cl_demo_output=>display( gv_cx_root->get_text( ) ).



ENDTRY.


RETURN.

*CALL FUNCTION 'ZFMM_JQ_TEST0003'
*  EXPORTING
*    iv_num1       =
*    iv_num2       =
** IMPORTING
**   EV_NUM        =
*          .


TRY .
CALL FUNCTION 'ZFMM_JQ_TEST'
  EXPORTING
    iv_num1                = p_num1
    iv_num2                = p_num2
* IMPORTING
*   EV_NUM                 =
* EXCEPTIONS
*   ZDIVIDED_ZERO          = 1
*   ZEXCEPTION_ONE         = 2
*   ZEXCEPTION_THREE       = 3
*   OTHERS                 = 4
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


CATCH cx_sy_arithmetic_error INTO DATA(lv_cx_root3) .
  " 01.07.2025 23:09:22 By JieQiang TODO 调试输出
  cl_demo_output=>display( lv_cx_root3->get_text( ) ).


CATCH cx_root INTO DATA(lv_cx_root2).
  " 01.07.2025 23:00:09 By JieQiang TODO 调试输出
  cl_demo_output=>display( lv_cx_root2->get_text( ) ).



ENDTRY.


RETURN.

TRY .

CALL FUNCTION 'STRING_SPLIT_AT_POSITION'
  EXPORTING
    string                  = p_str
    pos                     = p_pos
*   LANGU                   = SY-LANGU
* IMPORTING
*   STRING1                 =
*   STRING2                 =
*   POS_NEW                 =
 EXCEPTIONS
   string1_too_small       = 1
   string2_too_small       = 2
   pos_not_valid           = 3
   OTHERS                  = 4
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
  " 01.07.2025 22:45:14 By JieQiang TODO 调试输出
  cl_demo_output=>display( |code: { sy-subrc }| ).


ENDIF.

CATCH cx_root INTO DATA(lv_cx_root).
" 01.07.2025 22:38:13 By JieQiang TODO 调试输出
cl_demo_output=>display( lv_cx_root->get_text( ) ).


ENDTRY.



" 01.07.2025 22:35:29 By JieQiang TODO 调试输出
cl_demo_output=>display( p_str ).
cl_demo_output=>display( p_pos ).
