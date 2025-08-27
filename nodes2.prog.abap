CLASS zlc_alt7 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zlc_alt7 IMPLEMENTATION.
    METHOD if_oo_adt_classrun~main.
    DATA:
        node_tab TYPE STANDARD TABLE OF i,
        lv_value TYPE i,
      result   TYPE i,
      rows     TYPE i,
      idx_row  TYPE i,
      idx_col  TYPE i,
      pos      TYPE i,
      child_l  TYPE i,
      child_r  TYPE i.

        APPEND 75 TO node_tab.
        APPEND 95 TO node_tab.
        APPEND 64 TO node_tab.
        APPEND 17 TO node_tab.
        APPEND 47 TO node_tab.
        APPEND 82 TO node_tab.
        APPEND 18 TO node_tab.
        APPEND 35 TO node_tab.
        APPEND 87 TO node_tab.
        APPEND 10 TO node_tab.
        APPEND 20 TO node_tab.
        APPEND 4 TO node_tab.
        APPEND 82 TO node_tab.
        APPEND 47 TO node_tab.
        APPEND 65 TO node_tab.
        APPEND 19 TO node_tab.
        APPEND 1 TO node_tab.
        APPEND 23 TO node_tab.
        APPEND 75 TO node_tab.
        APPEND 3 TO node_tab.
        APPEND 34 TO node_tab.
        APPEND 88 TO node_tab.
        APPEND 2 TO node_tab.
        APPEND 77 TO node_tab.
        APPEND 73 TO node_tab.
        APPEND 7 TO node_tab.
        APPEND 63 TO node_tab.
        APPEND 67 TO node_tab.
        APPEND 99 TO node_tab.
        APPEND 65 TO node_tab.
        APPEND 4 TO node_tab.
        APPEND 28 TO node_tab.
        APPEND 6 TO node_tab.
        APPEND 16 TO node_tab.
        APPEND 70 TO node_tab.
        APPEND 92 TO node_tab.

        DATA(lv_count) = lines( node_tab ).
rows = 0.
WHILE rows * ( rows + 1 ) / 2 < lv_count.
  rows = rows + 1.
ENDWHILE.

" === Bottom-up DP directly on node_tab ===
DO rows - 1 TIMES.
  idx_row = rows - sy-index. " start from 2nd last row
  pos = idx_row * ( idx_row - 1 ) / 2 + 1. " start index of this row

  DO idx_row TIMES.
    " read current value
    READ TABLE node_tab INTO lv_value INDEX pos.

    " read children
    READ TABLE node_tab INTO child_l INDEX ( pos + idx_row ).
    READ TABLE node_tab INTO child_r INDEX ( pos + idx_row + 1 ).

    " update with max path sum
    lv_value = lv_value + nmax( val1 = child_l val2 = child_r ).
    MODIFY node_tab FROM lv_value INDEX pos.

        pos = pos + 1.
    ENDDO.
    ENDDO.

    " Top element holds result
    READ TABLE node_tab INTO result INDEX 1.
    out->write( result ).

    ENDMETHOD.

ENDCLASS.