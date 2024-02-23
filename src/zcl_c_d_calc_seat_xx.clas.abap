class ZCL_C_D_CALC_SEAT_XX definition
  public
  inheriting from /BOBF/CL_LIB_D_SUPERCL_SIMPLE
  final
  create public .

public section.

  methods /BOBF/IF_FRW_DETERMINATION~EXECUTE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_C_D_CALC_SEAT_XX IMPLEMENTATION.


  method /BOBF/IF_FRW_DETERMINATION~EXECUTE.
    data : lt_data type ZTCATS_XX_FLIGHT.
    "Step 1: Read the data coming from UI
    io_read->retrieve(
      EXPORTING
        iv_node                 = is_ctx-node_key
        it_key                  = it_key
      IMPORTING
        et_data                 =  lt_data
    ).

    "Reading data record of a table as a OBJECT
    read table lt_data REFERENCE INTO data(lo_line) INDEX 1.

    "Step 2: Based on Carrier and connection : get the seat count
    select SINGLE ( seatsmax_f + seatsmax_b ) into @lo_line->total_seats from sflight
    where carrid = @lo_line->carrid and
    connid = @lo_line->connid.

    "Step 3: Update data back to BOPF
    io_modify->update(
      iv_node           = is_ctx-node_key
      iv_key            = lo_line->key
      iv_root_key       = lo_line->key
      is_data           = lo_line
      it_changed_fields = value #( ( ZIF_C_ATS_XX_FLIGHT_C=>sc_node_attribute-zc_ats_xx_flight-total_seats ) )
    ).
*    CATCH /bobf/cx_frw_contrct_violation.



  endmethod.
ENDCLASS.
