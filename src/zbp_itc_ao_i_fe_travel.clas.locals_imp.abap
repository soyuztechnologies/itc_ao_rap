CLASS lhc_booking DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calculateTotalFlightPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~calculateTotalFlightPrice.

ENDCLASS.

CLASS lhc_booking IMPLEMENTATION.

  METHOD calculateTotalFlightPrice.

    TYPES: BEGIN OF ty_amount_per_currencycode,
             amount        TYPE /dmo/total_price,
             currency_code TYPE /dmo/currency_code,
           END OF ty_amount_per_currencycode.

    DATA: amount_per_currencycode TYPE STANDARD TABLE OF ty_amount_per_currencycode.


    " Read all relevant travel instances.
    READ ENTITIES OF zitc_ao_i_fe_travel IN LOCAL MODE
         ENTITY Travel
            FIELDS ( bookingfee currencycode )
            WITH CORRESPONDING #( keys )
         RESULT DATA(lt_travel).


    DELETE lt_travel WHERE currencycode IS INITIAL.

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<fs_travel>).
      " Set the start for the calculation by adding the booking fee.
      amount_per_currencycode = VALUE #( ( amount        = <fs_travel>-bookingfee
                                           currency_code = <fs_travel>-currencycode ) ).

      " Read all associated bookings and add them to the total price.
      READ ENTITIES OF zitc_ao_i_fe_travel IN LOCAL MODE
        ENTITY Travel BY \_Booking
          FIELDS ( flightprice currencycode )
        WITH VALUE #( ( %tky = <fs_travel>-%tky ) )
        RESULT DATA(lt_booking).

      LOOP AT lt_booking INTO DATA(booking) WHERE currencycode IS NOT INITIAL.
        COLLECT VALUE ty_amount_per_currencycode( amount        = booking-flightprice
                                                  currency_code = booking-currencycode ) INTO amount_per_currencycode.
      ENDLOOP.



      CLEAR <fs_travel>-totalprice.
      LOOP AT amount_per_currencycode INTO DATA(single_amount_per_currencycode).
        " If needed do a Currency Conversion
        IF single_amount_per_currencycode-currency_code = <fs_travel>-currencycode.
          <fs_travel>-totalprice += single_amount_per_currencycode-amount.
        ELSE.
          TRY  .
              /dmo/cl_flight_amdp=>convert_currency(
                 EXPORTING
                   iv_amount                   =  single_amount_per_currencycode-amount
                   iv_currency_code_source     =  single_amount_per_currencycode-currency_code
                   iv_currency_code_target     =  <fs_travel>-currencycode
                   iv_exchange_rate_date       =  cl_abap_context_info=>get_system_date( )
                 IMPORTING
                   ev_amount                   = DATA(total_booking_price_per_curr)
                ).
            CATCH cx_amdp_execution_failed.

          ENDTRY.
          <fs_travel>-totalprice += total_booking_price_per_curr.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    " write back the modified total_price of travels
    MODIFY ENTITIES OF zitc_ao_i_fe_travel IN LOCAL MODE
      ENTITY travel
        UPDATE FIELDS ( totalprice )
        WITH CORRESPONDING #( lt_travel ).

  ENDMETHOD.

ENDCLASS.

CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
PRIVATE SECTION.

  METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
    IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.
  METHODS validatecustomer FOR VALIDATE ON SAVE
    IMPORTING keys FOR travel~validatecustomer.
  METHODS createtravelbytemplate FOR MODIFY
    IMPORTING keys FOR ACTION travel~createtravelbytemplate.
  METHODS get_instance_features FOR INSTANCE FEATURES
    IMPORTING keys REQUEST requested_features FOR travel RESULT result.


ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

METHOD get_instance_authorizations.

    "you can check your auth object and based on that you can enable / disable features
    DATA ls_result LIKE LINE OF result.

   READ ENTITIES OF zitc_ao_i_fe_travel IN LOCAL MODE
      ENTITY Travel
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travel)
      FAILED DATA(lt_failed).

   LOOP AT lt_travel INTO DATA(ls_travel).

    DATA(lv_authorized) = abap_false.
    "you can check your auth object and based on that you can enable / disable features

*" For US/FR Country User do not have edit authorizations
     ls_result = VALUE #( TravelUUID   = ls_travel-TravelUUID
                          %update
                          = COND #( WHEN lv_authorized EQ abap_false
                                     THEN if_abap_behv=>auth-unauthorized
                                     ELSE if_abap_behv=>auth-allowed  ) ).

     APPEND ls_result TO result.
   ENDLOOP.


ENDMETHOD.

METHOD validateCustomer.
  READ ENTITIES OF zitc_ao_i_fe_travel IN LOCAL MODE
    ENTITY Travel
      FIELDS ( customerid )
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel)
    FAILED DATA(lt_failed).

  failed =  CORRESPONDING #( DEEP lt_failed  ).

  DATA lt_customer TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

  " Optimization of DB select: extract distinct non-initial customer IDs
  lt_customer = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING customer_id = customerid EXCEPT * ).
  DELETE lt_customer WHERE customer_id IS INITIAL.

  IF  lt_customer IS NOT INITIAL.
    " Check if customer ID exists
    SELECT FROM /dmo/customer FIELDS customer_id
                              FOR ALL ENTRIES IN @lt_customer
                              WHERE customer_id = @lt_customer-customer_id
    INTO TABLE @DATA(lt_customer_db).
    ENDIF.

    " Raise message for non existing customer id
    LOOP AT lt_travel INTO DATA(ls_travel).

      APPEND VALUE #(  %tky                 = ls_travel-%tky
                       %state_area          = 'VALIDATE_CUSTOMER' ) TO reported-travel.

      IF ls_travel-customerid IS  INITIAL.
        APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-travel.

        APPEND VALUE #( %tky                = ls_travel-%tky
                        %state_area         = 'VALIDATE_CUSTOMER'
                        %msg                = NEW /dmo/cm_flight_messages(
                                                                textid = /dmo/cm_flight_messages=>enter_customer_id
                                                                severity = if_abap_behv_message=>severity-error )
                        %element-customerid = if_abap_behv=>mk-on ) TO reported-travel.

      ELSEIF ls_travel-customerid IS NOT INITIAL AND NOT line_exists( lt_customer_db[ customer_id = ls_travel-customerid ] ).
        APPEND VALUE #(  %tky = ls_travel-%tky ) TO failed-travel.

        APPEND VALUE #(  %tky                = ls_travel-%tky
                         %state_area         = 'VALIDATE_CUSTOMER'
                         %msg                = NEW /dmo/cm_flight_messages(
                                                                customer_id = ls_travel-customerid
                                                                textid = /dmo/cm_flight_messages=>customer_unkown
                                                                severity = if_abap_behv_message=>severity-error )
                         %element-customerid = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD createTravelByTemplate.

    DATA : lt_travel_create TYPE TABLE FOR CREATE zitc_ao_i_fe_travel.

    READ ENTITIES OF zitc_ao_i_fe_travel IN LOCAL MODE
      ENTITY Travel
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travel)
      FAILED DATA(lt_failed).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<fs_existing>).

      DATA(ls_key)  = keys[ KEY entity %key = <fs_existing>-%key ].

      APPEND VALUE #( %cid = ls_key-%cid
                      %is_draft = ls_key-%param-%is_draft
                      %data = CORRESPONDING #( <fs_existing> EXCEPT TravelUUID travelid )
      ) TO lt_travel_create ASSIGNING FIELD-SYMBOL(<fs_create>).

      SELECT SINGLE MAX( travel_id ) INTO @<fs_create>-TravelID FROM zitc_atrav.
        <fs_create>-TravelID = <fs_create>-TravelID + 1.


      ENDLOOP.

      MODIFY ENTITIES OF zitc_ao_i_fe_travel IN LOCAL MODE
        ENTITY Travel
          CREATE FIELDS ( TravelID BeginDate EndDate CustomerID AgencyID BookingFee TotalPrice CurrencyCode )
              WITH lt_travel_create
          MAPPED mapped
        FAILED lt_failed.

    ENDMETHOD.

    METHOD get_instance_features.

      READ ENTITIES OF zitc_ao_i_fe_travel IN LOCAL MODE
      ENTITY Travel
      FIELDS ( AgencyID )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travel_result)
      FAILED failed.

      result = VALUE #( FOR ls_travel IN lt_travel_result
                         (         %tky                   = ls_travel-%tky
                           %field-BookingFee               = COND #( WHEN ls_travel-AgencyID = 70041
                                                                      THEN if_abap_behv=>fc-f-read_only
                                                                       ELSE if_abap_behv=>fc-f-unrestricted  )


                        ) ).


    ENDMETHOD.

ENDCLASS.
