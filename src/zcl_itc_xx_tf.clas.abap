CLASS zcl_itc_xx_tf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS crmd_partner_but000 for table FUNCTION ZITC_XX_TF.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_itc_xx_tf IMPLEMENTATION.
  METHOD crmd_partner_but000 by DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
  USING crmd_partner but000
  .

    return select sc.client as client,
                  sc.partner_no as partner_no,
                  sp.title as title,
                  sp.name_first as namefirst,
                  sp.name1_text as nametext
                  from crmd_partner as sc
                  inner join but000 as sp on
                  sc.client = sp.client and
                  sc.partner_no = sp.partner_guid
                  where sc.client = :p_clnt;

  ENDMETHOD.

ENDCLASS.
