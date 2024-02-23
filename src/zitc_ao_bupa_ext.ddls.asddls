@AbapCatalog.sqlViewAppendName: 'ZITCAOBUPAEXT'
@EndUserText.label: 'EXTEND'
extend view ZITC_AO_BPA with ZITC_AO_BUPA_EXT
{
    snwd_bpa.email_address as EmailAddress
}
