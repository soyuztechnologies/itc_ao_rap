CLASS zcl_ITC_AO_idoc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_message_Text for table FUNCTION ZITC_AO_TF_IDOC_MSG.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ITC_AO_idoc IMPLEMENTATION.
  METHOD get_message_text by DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
  USING edids.

    /*Step 1: get the message and doc from status table with max counter record*/
    lt_unprocessed = select mandt as client, docnum, countr, statxt, stapa1,
    stapa2, stapa3, stapa4 from edids where
    ( docnum, countr ) in ( select docnum, max( countr ) from edids group by docnum );

    /*Step 2: start replacing the occurreneces of & with each variable*/
    lt_msg1 = select client, docnum,
                case when statxt like '%&%'
                    then concat(concat(substr_before(statxt, '&'), stapa1),substr_after(statxt, '&'))
                    else statxt end as statxt,
                    stapa2, stapa3, stapa4 from :lt_unprocessed;

    lt_msg2 = select client, docnum,
                case when statxt like '%&%'
                    then concat(concat(substr_before(statxt, '&'), stapa2),substr_after(statxt, '&'))
                    else statxt end as statxt,
                    stapa3, stapa4 from :lt_msg1;
    lt_msg3 = select client, docnum,
                case when statxt like '%&%'
                    then concat(concat(substr_before(statxt, '&'), stapa3),substr_after(statxt, '&'))
                    else statxt end as statxt,
                     stapa4 from :lt_msg2;

    return select client, docnum,
                case when statxt like '%&%'
                    then concat(concat(substr_before(statxt, '&'), stapa4),substr_after(statxt, '&'))
                    else statxt end as statxt
                     from :lt_msg3;

  ENDMETHOD.

ENDCLASS.
