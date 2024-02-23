@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Composite View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZITC_AO_CO_IDOC_CAT as select from edidc 
association[1] to ZITC_AO_I_EDIDS_RECORDS as _Status on
$projection.Docnum = _Status.Docnum
{
    key edidc.docnum as Docnum,
    edidc.status as Status,
    edidc.credat as Credat,
    edidc.cretim as Cretim,
    _Status.Countr,
    _Status.Statxt,
    _Status.Stapa1,
    _Status.Stapa2,
    _Status.Stapa3,
    _Status.Stapa4,
    _Status.Stamid,
    _Status.Stamno,
    _Status.ErrorCategory,
    _Status.NotRouted,
    _Status.MissingPartNo,
    _Status.AddressErr,
    _Status.ShipLocErr,
    _Status.Others
}
