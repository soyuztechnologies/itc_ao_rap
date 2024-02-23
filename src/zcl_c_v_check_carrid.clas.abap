class ZCL_C_V_CHECK_CARRID definition
  public
  inheriting from /BOBF/CL_LIB_V_SUPERCL_SIMPLE
  final
  create public .

public section.

  methods /BOBF/IF_FRW_VALIDATION~EXECUTE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_C_V_CHECK_CARRID IMPLEMENTATION.


  method /BOBF/IF_FRW_VALIDATION~EXECUTE.

    "Even its a single record operation BOPF will give
    "Data in a internal table type
    data: itab type ZTCATS_PK_FLY.
    "Step 1: Read the data coming from Fiori UI in BOPF
    io_read->retrieve(
      EXPORTING
        iv_node                 = is_ctx-node_key
        it_key                  = it_key
      IMPORTING
        et_data                 = itab
    ).

    READ TABLE itab into data(ls_record) INDEX 1.

    "Step 2: Use the data to validate our CARRID
    select single 'X' into @data(lv_exist) from scarr
    where carrid = @ls_record-carrid.

    "Step 3: If its invalidated, we will inform BOPF
    if ( lv_exist = '' ).
       eo_message = /bobf/cl_frw_factory=>get_message(  ).
       eo_message->add_message(
         is_msg       = value #( msgid = 'SY' msgno = 499
                                 msgty = 'E'
                                 msgv1 = 'Dude the Carrid '
                                 msgv2 = ls_record-carrid
                                 msgv3 = ' is invalid'
                                )
         iv_node      = is_ctx-node_key
         iv_key       = ls_record-key
         iv_attribute = ZIF_C_ATS_PK_FLY_C=>sc_node_attribute-ZC_ATS_PK_FLY-carrid
         iv_lifetime  = /bobf/cm_frw=>co_lifetime_transition
       ).

       append value #( key = is_ctx-node_key ) to et_failed_key.

    ENDIF.

  endmethod.
ENDCLASS.
