@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel root entity for unmanaged implementation'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZI_ITC_AO_TRAVEL_U as select from /dmo/travel as Travel
  association [0..1] to ZITC_AO_AGENCY_U   as _Agency   on $projection.AgencyId = _Agency.AgencyID
  association [0..1] to ZITC_AO_CUSTOMER_U as _Customer on $projection.CustomerId = _Customer.CustomerID
  association [0..1] to I_Currency       as _Currency on $projection.CurrencyCode = _Currency.Currency
  association [1..1] to /DMO/I_Travel_Status_VH as _TravelStatus on $projection.Status = _TravelStatus.TravelStatus
{
      key Travel.travel_id as TravelId,
      Travel.agency_id as AgencyId,
      Travel.customer_id as CustomerId,
      Travel.begin_date as BeginDate,
      Travel.end_date as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Travel.booking_fee as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Travel.total_price as TotalPrice,
      Travel.currency_code as CurrencyCode,
      Travel.description as Memo,
      Travel.status as Status,
      Travel.lastchangedat as Lastchangedat,
      /* Associations */
      _Agency,
      _Customer,
      _Currency,
      _TravelStatus
}
