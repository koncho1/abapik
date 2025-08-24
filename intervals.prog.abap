CLASS zlc_9 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    TYPES:
      BEGIN OF dates,
        id     TYPE i,
        begdat TYPE d,
        end    TYPE d,
        desc   TYPE string,
      END OF dates,
      date_a TYPE dates,
      date_t TYPE STANDARD TABLE OF date_a.
    METHODS:
      constructor,
      find_intervals
        IMPORTING
          first_tab  TYPE date_t
          second_tab TYPE date_t
        EXPORTING
          lt_result  TYPE date_t.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zlc_9 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA:
      one_tab      TYPE date_t,
      two_tab      TYPE date_t,
      result_tab   TYPE date_t,
      date_checker TYPE REF TO zlc_9,
      result       TYPE string,
      row          TYPE LINE OF date_t.
    FIELD-SYMBOLS:
        <row> TYPE LINE OF date_t.

    row-begdat = '20220101'.
    row-end = '20220107'.

    APPEND row TO one_tab.

    row-begdat = '20220107'.
    row-end = '20220109'.

    APPEND row TO one_tab.

    row-begdat = '20220103'.
    row-end = '20220109'.

    APPEND row TO two_tab.


    CREATE OBJECT date_checker.
    CALL METHOD date_checker->find_intervals
      EXPORTING
        first_tab  = one_tab
        second_tab = two_tab
      IMPORTING
        lt_result  = result_tab.

    SORT result_tab BY begdat ASCENDING.

    LOOP AT result_tab ASSIGNING <row>.
      result = | { <row>-begdat } ' / ' { <row>-end } |.
      out->write( result ).
    ENDLOOP.


  ENDMETHOD.
  METHOD constructor.
  ENDMETHOD.
  METHOD find_intervals.

    TYPES:BEGIN OF date_bound,
            date TYPE d,
          END OF date_bound.

    TYPES:
        period_t TYPE STANDARD TABLE OF date_bound.

    DATA:
      next_index   TYPE i VALUE 1,
      date_row     TYPE date_bound,
      begin_period TYPE period_t,
      end_period   TYPE period_t,
      bounds       TYPE period_t,
      lt_segments  TYPE date_t,
      work_table   TYPE date_t.

    APPEND LINES OF first_tab TO work_table.
    APPEND LINES OF second_tab TO work_table.

    LOOP AT work_table ASSIGNING FIELD-SYMBOL(<fs_row>).
      date_row-date = <fs_row>-begdat.
      APPEND date_row TO bounds.
      APPEND date_row TO begin_period.
      date_row-date = <fs_row>-end.
      APPEND date_row TO bounds.
      APPEND date_row TO end_period.
    ENDLOOP.

    SORT bounds.
    DELETE ADJACENT DUPLICATES FROM bounds.

    LOOP AT bounds ASSIGNING FIELD-SYMBOL(<fs_bounds>).
      IF line_exists( begin_period[ date = <fs_bounds>-date ] )
          AND line_exists( end_period[ date = <fs_bounds>-date ] ).
        APPEND INITIAL LINE TO lt_segments ASSIGNING FIELD-SYMBOL(<ls_seg>).
        <ls_seg>-begdat = <fs_bounds>-date.
        <ls_seg>-end = <fs_bounds>-date.
      ENDIF.
      next_index = sy-tabix + 1.
      READ TABLE bounds ASSIGNING FIELD-SYMBOL(<fs_next>) INDEX next_index.
      IF sy-subrc = 0.
        APPEND INITIAL LINE TO lt_segments ASSIGNING <ls_seg>.
        <ls_seg>-begdat = <fs_bounds>-date.
        <ls_seg>-end = <fs_next>-date.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_segments ASSIGNING <ls_seg>.
      LOOP AT work_table ASSIGNING FIELD-SYMBOL(<ls_inp>)
           WHERE begdat <= <ls_seg>-begdat
             AND end >= <ls_seg>-end.
        APPEND <ls_seg> TO lt_result.
        EXIT.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.