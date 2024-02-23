CLASS zcl_itc_ao_classpool DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    data: itab type table of string.
    INTERFACES if_oo_adt_classrun.
    METHODS reachtomars.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_itc_ao_classpool IMPLEMENTATION.
  METHOD reachtomars.
        data: lv_str type string.
        data(lo_earth) = new zcl_earth( ).
        data(lo_planet1) = new zcl_planet1( ).
        data(lo_mars) = new zcl_mars( ).
        "leave earth orbit
        lo_earth->leave_orbit( IMPORTING r_value = lv_str ).
        append lv_str to itab.
        "enter in planet 1
        lo_planet1->enter_orbit( IMPORTING r_value = lv_str ).
        append lv_str to itab.
        "leave plant1
        lo_planet1->leave_orbit( IMPORTING r_value = lv_str ).
        append lv_str to itab.
        "enter mars orbit
        lo_mars->enter_orbit( IMPORTING r_value = lv_str ).
        append lv_str to itab.
        "land on mars
        lo_mars->land( IMPORTING r_value = lv_str ).
        append lv_str to itab.
    ENDMETHOD.


    METHOD if_oo_adt_classrun~main.
        me->reachtomars( ).
        loop at itab into data(wa).
        out->write(
          EXPORTING
            data   = wa
*            name   =
*          RECEIVING
*            output =
        ).
        endloop.
    ENDMETHOD.

ENDCLASS.
