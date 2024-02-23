CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS augment_create FOR MODIFY
      IMPORTING entities FOR CREATE Travel.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD augment_create.

    DATA: travel_create TYPE TABLE FOR CREATE zitc_ao_i_fe_travel.

    travel_create = CORRESPONDING #( entities ).
    LOOP AT travel_create ASSIGNING FIELD-SYMBOL(<travel>).
      <travel>-overallstatus  = 'O'.
      <travel>-%control-overallstatus = if_abap_behv=>mk-on.
    ENDLOOP.

    MODIFY AUGMENTING ENTITIES OF zitc_ao_i_fe_travel
    ENTITY Travel CREATE FROM travel_create.


  ENDMETHOD.

ENDCLASS.
