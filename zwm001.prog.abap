*&---------------------------------------------------------------------*
*& Report  ZWMU001
*&---------------------------------------------------------------------*
REPORT zwm001.

INCLUDE ZWM001TOP.
*INCLUDE zwmu001top .
INCLUDE ZWM001FORM.
*INCLUDE zwmu001form  .

INITIALIZATION .

  PERFORM frm_init .

AT  SELECTION-SCREEN OUTPUT .

  PERFORM modify_screen .


AT SELECTION-SCREEN.

  IF sy-ucomm = 'FC01'.

    PERFORM frm_download_template.

  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  PERFORM frm_select_file.


START-OF-SELECTION .

  PERFORM frm_data_pro .

END-OF-SELECTION.

  PERFORM frm_fieldcat_build .

  PERFORM frm_layout_build .

  PERFORM frm_display_alv .
