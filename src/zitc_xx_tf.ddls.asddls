@EndUserText.label: 'Table function demo'
define table function ZITC_XX_TF
with parameters 
@Environment.systemField: #CLIENT
p_clnt : abap.clnt
returns {
  client : abap.clnt;
  partner_no : crmt_partner_no;
  title: ad_title;
  namefirst: bu_namep_f;
  nametext: bu_name1tx;  
}
implemented by method zcl_itc_xx_tf=>crmd_partner_but000;
