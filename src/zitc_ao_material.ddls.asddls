@AbapCatalog.sqlViewName: 'ZITCAOMATERIAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'My material view'
define view ZITC_AO_MATERIAL as select from mara
{
    key matnr as Matnr,
    ersda as Ersda,
    ernam as Ernam,
    mtart as Mtart,
    mbrsh as Mbrsh,
    matkl as Matkl,
    meins as Meins
}
