CLASS zlc_node DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA:
        value TYPE i,
        left_child TYPE REF TO zlc_node,
        right_child TYPE REF TO zlc_node.
    METHODS:
        constructor
            IMPORTING
                val TYPE i
                l_child TYPE REF TO zlc_node OPTIONAL
                r_child TYPE REF TO zlc_node OPTIONAL,
        biggest_sum
            IMPORTING
                current_node TYPE REF TO zlc_node
            EXPORTING
                sum TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zlc_node IMPLEMENTATION.
    METHOD constructor.
        value = val.
        left_child = l_child.
        right_child = r_child.
    ENDMETHOD.
    METHOD biggest_sum.
        DATA:
            l_sum TYPE i,
            r_sum TYPE i.
        IF current_node->left_child IS INITIAL AND current_node->right_child IS INITIAL.
            sum = current_node->value.
        ELSE.
            IF current_node->left_child IS NOT INITIAL.
            CALL METHOD current_node->biggest_sum
                EXPORTING
                    current_node = current_node->left_child
                IMPORTING
                    sum = l_sum.
            ENDIF.
            IF current_node->right_child IS NOT INITIAL.
             CALL METHOD current_node->biggest_sum
                EXPORTING
                    current_node = current_node->right_child
                IMPORTING
                    sum = r_sum.
            ENDIF.

             sum = nmax( val1 = l_sum val2 = r_sum ) + current_node->value.
        ENDIF.

        ENDMETHOD.
ENDCLASS.