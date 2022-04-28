*&---------------------------------------------------------------------*
*& Report Y0015
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ytest0015.

DATA: ok_code TYPE sy-ucomm, save_ok LIKE ok_code.

DATA container TYPE REF TO cl_gui_custom_container.
DATA editor TYPE REF TO cl_gui_textedit.

DATA: init,init2,
      m1(256)   TYPE c OCCURS 0,
      line(256) TYPE c.

line = '请输入：'. "默认文字
APPEND line TO m1.
line = '请输入1：'. "默认文字
APPEND line TO m1.



CALL SCREEN 0100.

REFRESH M1.
CALL METHOD EDITOR->GET_TEXT_AS_R3TABLE "获取数据”读取长文本中的数据
      IMPORTING
      TABLE = M1.

LOOP AT M1 INTO LINE.
WRITE / LINE.
ENDLOOP.

MODULE status_0100 OUTPUT.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.
  IF init IS INITIAL.
    init = 'X'.
    IF container IS INITIAL.
      CREATE OBJECT: container EXPORTING container_name = 'PP'. " pp 是自己画的容器名字
    ENDIF.

    CREATE OBJECT editor
      EXPORTING
        parent                     = container
        wordwrap_mode              = cl_gui_textedit=>wordwrap_at_fixed_position "固定位置显示
*       WORDWRAP_MODE              = CL_GUI_TEXTEDIT=>WORDWRAP_AT_WINDOWBORDER
        wordwrap_position          = 10     "控制 每一行 可以书写的长度
        wordwrap_to_linebreak_mode = cl_gui_textedit=>true.  "可以回车换行
    IF init2 IS INITIAL .
      CALL METHOD editor->set_text_as_r3table "写数据
        EXPORTING
          table = m1.
    ELSE .
      CLEAR m1 .
      CALL METHOD editor->set_text_as_r3table "写数据
        EXPORTING
          table = m1.

    ENDIF .
  ENDIF.

  CALL METHOD editor->set_readonly_mode  "将长文本设置为显示模式，不允许填写
   EXPORTING
     readonly_mode = 1.
  "只读也可以不设置 导入参数 ，因为方法的参数默认 是 1 。
  CALL METHOD editor->set_readonly_mode .

  CALL METHOD editor->set_toolbar_mode  "去掉工具栏
    EXPORTING
      toolbar_mode = 0.

  CALL METHOD editor->set_statusbar_mode "去掉状态栏
    EXPORTING
      statusbar_mode = 0.

*    CALL METHOD EDITOR->SET_READONLY_MODE
*      EXPORTING
*        READONLY_MODE          = '1'
*      EXCEPTIONS
*        ERROR_CNTL_CALL_METHOD = 1
*        INVALID_PARAMETER      = 2
*        OTHERS                 = 3.
  IF sy-subrc <> 0.
*     Implement suitable error handling here
  ENDIF.

ENDMODULE. " STATUS_0100 OUTPUT




*
*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE sy-ucomm .

    WHEN 'BACK'  .
      LEAVE TO SCREEN 0 .
    WHEN 'DELETE' .
      IF editor IS NOT INITIAL .
        editor->delete_text( ).
      ENDIF .
    WHEN 'CLEAR' .
*      editor->free( ).
      FREE   editor .
      FREE:  init ,container .
      CALL  SCREEN 200 .
  ENDCASE .

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE sy-ucomm .

    WHEN 'BACK'  .
      LEAVE TO SCREEN 0 .
    WHEN 'DELETE' .
      IF editor IS NOT INITIAL .
        editor->delete_text( ).
      ENDIF .
  ENDCASE .
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  init2 = 'X' .
ENDMODULE.
