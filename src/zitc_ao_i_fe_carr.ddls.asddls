@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Carrier Interface basic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZITC_AO_I_FE_CARR as select from zitc_acarr as Airline
  association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency
{
  @Search.defaultSearchElement: true
  @ObjectModel.text.element: [ 'Name' ]
  key Airline.carrier_id as AirlineID,
  
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.7 
  @Semantics.text: true
  Airline.name as Name,
  
  @Semantics.imageUrl: true
  Airline.carrier_pic_url as AirlinePicURL,
  
  --@Semantics.currencyCode: true
  Airline.currency_code as CurrencyCode,
  
  _Currency
  }
