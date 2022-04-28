class YTEST_SH_CL_COMMON_CLASS definition
  public
  final
  create public .

public section.

  class-methods GET_DOMIN_VALUE
    importing
      !I_DOMNAME type DOMNAME
      !I_KEY type ANY
    exporting
      value(E_XFWTEXT) type ANY .
  class-methods ALPHA_INPUT
    importing
      !I_FIELD type ANY
    exporting
      !E_FIELD type ANY .
  class-methods ALPHA_OUTPUT
    importing
      !I_FIELD type ANY
    exporting
      !E_FIELD type ANY .
  class-methods MATNR_INPUT
    importing
      !I_MATNR type MATNR
    returning
      value(R_MATNR) type MATNR .
  class-methods MATNR_OUTPUT
    importing
      !I_MATNR type MATNR
    returning
      value(R_MATNR) type MATNR .
  class-methods GET_SERIAL_NUMBER
    importing
      !IV_OBJECT type NROBJ
      !IV_RANGE type NRNR
    exporting
      !EV_NUMBER type ANY .
protected section.
private section.
ENDCLASS.



CLASS YTEST_SH_CL_COMMON_CLASS IMPLEMENTATION.


  method ALPHA_INPUT.


    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        INPUT         = I_FIELD
      IMPORTING
        OUTPUT        = E_FIELD
                   .

  endmethod.


  method ALPHA_OUTPUT.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        INPUT         = I_FIELD
      IMPORTING
        OUTPUT        = E_FIELD
              .
  endmethod.


  METHOD GET_DOMIN_VALUE.

    DATA GS_DOM TYPE RJBTKL .
    DATA:GT_DOM LIKE TABLE OF GS_DOM.

    CALL FUNCTION 'ISB_DOMANE_READ'
     EXPORTING
       DOMNAME         = I_DOMNAME
      TABLES
        dom_tab         = GT_DOM .
    READ TABLE GT_DOM INTO GS_DOM WITH KEY SFWNUM = I_KEY.
    IF SY-SUBRC = 0.
      E_XFWTEXT = GS_DOM-XFWTEXT.
    ENDIF.
  ENDMETHOD.


  method GET_SERIAL_NUMBER.

  "自动获取编号加锁
  CALL FUNCTION 'NUMBER_RANGE_ENQUEUE'
    EXPORTING
      object           = iv_object
    EXCEPTIONS
      foreign_lock     = 1
      object_not_found = 2
      system_failure   = 3
      OTHERS           = 4.
  IF sy-subrc = 0.
    "获取编号
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = iv_range
        object                  = iv_object
      IMPORTING
        number                  = ev_number
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    "自动获取编号解锁
    CALL FUNCTION 'NUMBER_RANGE_DEQUEUE'
      EXPORTING
        object           = iv_object
      EXCEPTIONS
        object_not_found = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.
  endmethod.


  method MATNR_INPUT.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        INPUT              = I_MATNR
      IMPORTING
        OUTPUT             = R_MATNR
      EXCEPTIONS
        LENGTH_ERROR       = 1
        OTHERS             = 2
              .
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.

  endmethod.


  method MATNR_OUTPUT.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
      EXPORTING
        INPUT         = I_MATNR
     IMPORTING
        OUTPUT        = R_MATNR
              .

  endmethod.
ENDCLASS.
