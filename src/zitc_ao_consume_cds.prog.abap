*&---------------------------------------------------------------------*
*& Report zitc_ao_consume_cds
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zitc_ao_consume_cds.

data: ls_bp type snwd_bpa.

PARAMETERS p_bp type snwd_business_partner_role.
SELECT-OPTIONS s_bpid for ls_bp-bp_id.

select * from ZITC_AO_BUPA( p_type = @p_bp ) into table @data(itab)
WHERE BpId in @s_bpid.

cl_demo_output=>display_data(
  value   = itab
*  name    =
*  exclude =
*  include =
).
