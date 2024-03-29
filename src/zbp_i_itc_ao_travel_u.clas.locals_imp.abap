CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    TYPES tt_travel_failed    TYPE TABLE FOR FAILED   ZI_ITC_AO_TRAVEL_U.
    TYPES tt_travel_reported  TYPE TABLE FOR REPORTED ZI_ITC_AO_TRAVEL_U.

    METHODS map_messages
      IMPORTING
        cid          TYPE string         OPTIONAL
        travel_id    TYPE /dmo/travel_id OPTIONAL
        messages     TYPE /dmo/t_message
      EXPORTING
        failed_added TYPE abap_bool
      CHANGING
        failed       TYPE tt_travel_failed
        reported     TYPE tt_travel_reported.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Travel.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Travel.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Travel.

    METHODS read FOR READ
      IMPORTING keys FOR READ Travel RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Travel.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.

  DATA: messages   TYPE /dmo/t_message,
          travel_in  TYPE /dmo/travel,
          travel_out TYPE /dmo/travel.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<travel_create>).

      travel_in = CORRESPONDING #( <travel_create> MAPPING FROM ENTITY USING CONTROL ).

*      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_CREATE'
*        EXPORTING
*          is_travel   = CORRESPONDING /dmo/s_travel_in( travel_in )
*        IMPORTING
*          es_travel   = travel_out
*          et_messages = messages.

       /dmo/cl_flight_legacy=>get_instance( )->create_travel( EXPORTING is_travel             = CORRESPONDING /dmo/s_travel_in( travel_in )

                                         IMPORTING es_travel             = travel_out
                                                   et_messages           = DATA(lt_messages) ).

      /dmo/cl_flight_legacy=>get_instance( )->convert_messages( EXPORTING it_messages = lt_messages
                                                                IMPORTING et_messages = messages ).

      map_messages(
          EXPORTING
            cid       = <travel_create>-%cid
            messages  = messages
          IMPORTING
            failed_added = DATA(failed_added)
          CHANGING
            failed    = failed-travel
            reported  = reported-travel
        ).

      IF failed_added = abap_false.
        INSERT VALUE #(
            %cid     = <travel_create>-%cid
            travelid = travel_out-travel_id )
          INTO TABLE mapped-travel.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

   METHOD update.
    DATA: messages TYPE /dmo/t_message,
          travel   TYPE /dmo/travel,
          travelx  TYPE /dmo/s_travel_inx. "refers to x structure (> BAPIs)

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<travel_update>).

      travel = CORRESPONDING #( <travel_update> MAPPING FROM ENTITY ).

      travelx-travel_id = <travel_update>-TravelID.
      travelx-_intx     = CORRESPONDING #( <travel_update> MAPPING FROM ENTITY ).

      /dmo/cl_flight_legacy=>get_instance( )->update_travel(
        EXPORTING
          is_travel              = CORRESPONDING /dmo/s_travel_in( travel )
          is_travelx             = travelx
        IMPORTING
           et_messages            =  data(lt_messages)
      ).

      /dmo/cl_flight_legacy=>get_instance( )->convert_messages( EXPORTING it_messages = lt_messages
                                                        IMPORTING et_messages = messages ).


      map_messages(
          EXPORTING
            cid       = <travel_update>-%cid_ref
            travel_id = <travel_update>-travelid
            messages  = messages
          CHANGING
            failed    = failed-travel
            reported  = reported-travel
        ).

    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA: messages TYPE /dmo/t_message.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<travel_delete>).

      /dmo/cl_flight_legacy=>get_instance( )->delete_travel(
        EXPORTING
          iv_travel_id = <travel_delete>-travelid
        IMPORTING
          et_messages  = data(lt_messages)
      ).

     /dmo/cl_flight_legacy=>get_instance( )->convert_messages( EXPORTING it_messages = lt_messages
                                                        IMPORTING et_messages = messages ).


      map_messages(
          EXPORTING
            cid       = <travel_delete>-%cid_ref
            travel_id = <travel_delete>-travelid
            messages  = messages
          CHANGING
            failed    = failed-travel
            reported  = reported-travel
        ).

    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    DATA: travel_out TYPE /dmo/travel,
          messages   TYPE /dmo/t_message.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<travel_to_read>) GROUP BY <travel_to_read>-%tky.


        /dmo/cl_flight_legacy=>get_instance( )->get_travel( EXPORTING iv_travel_id          = <travel_to_read>-travelid
                                                                      iv_include_buffer     = ABAP_FALSE
                                                      IMPORTING es_travel             = travel_out
                                                                et_messages           = DATA(lt_messages) ).

        /dmo/cl_flight_legacy=>get_instance( )->convert_messages( EXPORTING it_messages = lt_messages
                                                            IMPORTING et_messages = messages ).

      map_messages(
          EXPORTING
            travel_id        = <travel_to_read>-TravelID
            messages         = messages
          IMPORTING
            failed_added = DATA(failed_added)
          CHANGING
            failed           = failed-travel
            reported         = reported-travel
        ).

      IF failed_added = abap_false.
        INSERT CORRESPONDING #( travel_out MAPPING TO ENTITY ) INTO TABLE result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD lock.
   TRY.
        "Instantiate lock object
        DATA(lock) = cl_abap_lock_object_factory=>get_instance( iv_name = '/DMO/ETRAVEL' ).
      CATCH cx_abap_lock_failure INTO DATA(exception).
        RAISE SHORTDUMP exception.
    ENDTRY.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<travel>).
      TRY.
          "enqueue travel instance
          lock->enqueue(
              it_parameter  = VALUE #( (  name = 'TRAVEL_ID' value = REF #( <travel>-travelid ) ) )
          ).
          "if foreign lock exists
        CATCH cx_abap_foreign_lock INTO DATA(foreign_lock).
          map_messages(
           EXPORTING
                travel_id = <travel>-TravelID
                messages  =  VALUE #( (
                                           msgid = '/DMO/CM_FLIGHT_LEGAC'
                                           msgty = 'E'
                                           msgno = '032'
                                           msgv1 = <travel>-travelid
                                           msgv2 = foreign_lock->user_name )
                          )
              CHANGING
                failed    = failed-travel
                reported  = reported-travel
            ).

        CATCH cx_abap_lock_failure INTO exception.
          RAISE SHORTDUMP exception.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.


  METHOD map_messages.
   failed_added = abap_false.
    LOOP AT messages INTO DATA(message).
      IF message-msgty = 'E' OR message-msgty = 'A'.
        APPEND VALUE #( %cid        = cid
                        travelid    = travel_id
                        %fail-cause = /dmo/cl_travel_auxiliary=>get_cause_from_message(
                                        msgid = message-msgid
                                        msgno = message-msgno
                                      ) )
               TO failed.
        failed_added = abap_true.
      ENDIF.

      APPEND VALUE #( %msg          = new_message(
                                        id       = message-msgid
                                        number   = message-msgno
                                        severity = if_abap_behv_message=>severity-error
                                        v1       = message-msgv1
                                        v2       = message-msgv2
                                        v3       = message-msgv3
                                        v4       = message-msgv4 )
                      %cid          = cid
                      TravelID      = travel_id )
             TO reported.
    ENDLOOP.
  ENDMETHOD.


ENDCLASS.

CLASS lsc_ZI_ITC_AO_TRAVEL_U DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_ITC_AO_TRAVEL_U IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  /dmo/cl_flight_legacy=>get_instance( )->save( ).
  ENDMETHOD.

  METHOD cleanup.
  /dmo/cl_flight_legacy=>get_instance( )->initialize( ).
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
