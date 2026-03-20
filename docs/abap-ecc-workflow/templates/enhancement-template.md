# ABAP 增强开发模板

## BAdI 增强

```abap
*&---------------------------------------------------------------------*
*&  BAdI Enhancement: ZXXX_ENHANCEMENT
*&  Implementation: ZCL_IM_XXX_IMPL
*&---------------------------------------------------------------------*

INTERFACE if_ex_zxxx_enhancement.
  METHODS:
    "! Process before save
    "! @parameter iv_data | Input data
    "! @parameter ev_result | Processing result
    process_before_save
      IMPORTING
        iv_data TYPE any
      EXPORTING
        ev_result TYPE abap_bool,
    "! Process after save  
    process_after_save
      IMPORTING
        iv_data TYPE any.
ENDINTERFACE.

CLASS zcl_im_xxx_impl DEFINITION
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_ex_zxxx_enhancement.

  PRIVATE SECTION.
    CONSTANTS: lc_prefix TYPE string VALUE 'ZXXX_'.
ENDCLASS.

CLASS zcl_im_xxx_impl IMPLEMENTATION.

  METHOD if_ex_zxxx_enhancement~process_before_save.
    " 实现增强逻辑
    ev_result = abap_true.
  ENDMETHOD.

  METHOD if_ex_zxxx_enhancement~process_after_save.
    " 实现增强逻辑
  ENDMETHOD.

ENDCLASS.
```

## User Exit / Customer Exit

```abap
*&---------------------------------------------------------------------*
*&  Include ZXM08U01 - User Exit for PO Save
*&---------------------------------------------------------------------*

FORM userexit_field_modification.
  CASE sy-tcode.
    WHEN 'ME21N' OR 'ME22N' OR 'ME23N'.
      LOOP AT screen.
        IF screen-name CS 'RESWK'.
          screen-input = 0.  " 设置为只读
          MODIFY screen.
        ENDIF.
      ENDLOOP.
  ENDCASE.
ENDFORM.

FORM userexit_save_document.
  " 文档保存前的用户出口
ENDFORM.
```

## BTE 增强

```abap
*&---------------------------------------------------------------------*
*&  BTE: 00001020 - Invoice Verification
*&---------------------------------------------------------------------*

FUNCTION zft_invoice_verify_020.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_INVOICE) TYPE  REF TO CL_INVOICE
*"  EXPORTING
*"     REFERENCE(E_RESULT) TYPE  ABAP_BOOL
*"     REFERENCE(E_MESSAGE) TYPE  STRING
*"----------------------------------------------------------------------

  TRY.
      " 业务逻辑
      e_result = abap_true.
    CATCH cx_root INTO DATA(lo_error).
      e_result = abap_false.
      e_message = lo_error->get_text( ).
  ENDTRY.

ENDFUNCTION.
```

## 注意事项

- 记录增强点位置和激活状态
- 使用事务 `SE18/SE19` 管理 BAdI
- 增强需考虑向后兼容性
- 生产系统修改需通过传输请求