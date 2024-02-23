@EndUserText.label: 'iDOC message variables'
define table function ZITC_AO_TF_IDOC_MSG
with parameters 
@Environment.systemField: #CLIENT
p_clnt : abap.clnt
returns {
  client : abap.clnt;
  docnum : edi_docnum;
  statxt : edi_statx_;
}
implemented by method zcl_ITC_AO_idoc=>get_message_Text;
