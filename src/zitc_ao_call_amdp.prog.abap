*&---------------------------------------------------------------------*
*& Report zitc_ao_call_amdp
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zitc_ao_call_amdp.

"Ctrl+space and Shift+Enter
*zcl_itc_ao_amdp=>add_numbers(
*  EXPORTING
*    a   = 10
*    b   = 20
*  IMPORTING
*    res = data(lv_result)
*).

*zcl_itc_ao_amdp=>even_odd(
*  EXPORTING
*    a   = 5
*  IMPORTING
*    res = data(lv_result)
*).

*zcl_itc_ao_amdp=>loop_process(
*  EXPORTING
*    a   = 5
*  IMPORTING
*    res = data(lv_result)
*).

*zcl_itc_ao_amdp=>read_customer_by_id(
*  EXPORTING
*    i_bp_id     = '0100000003'
*  IMPORTING
*    e_cust_name = data(lv_result)
*    e_cust_role = data(lv_role)
*).

*zcl_itc_ao_amdp=>calc_mrp_products(
*  IMPORTING
*    et_result = data(itab)
*).
*
*cl_demo_output=>display_data(
*  value   = itab
**  name    =
**  exclude =
**  include =
*).

try.
    zcl_itc_ao_amdp=>get_oia(
      IMPORTING
        et_oia = data(itab)
    ).
  catch CX_AMDP_EXECUTION_FAILED into data(lo_ex).
    WRITE : / lo_ex->get_text(  ).
    return.
endtry.


cl_demo_output=>display_data(
  value   = itab
*  name    =
*  exclude =
*  include =
).

*WRITE : / lv_result, lv_role.
