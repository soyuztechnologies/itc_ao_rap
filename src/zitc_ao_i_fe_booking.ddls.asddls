@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Child node of BO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZITC_ao_I_FE_Booking as select from zitc_abook
  association to parent ZITC_AO_I_FE_TRAVEL as _Travel on $projection.TravelUUID = _Travel.TravelUUID
  association [1..1] to ZITC_AO_I_FE_CONN as _Connection on $projection.CarrierID = _Connection.AirlineID 
                                and $projection.ConnectionID = _Connection.ConnectionID
  association [1..1] to ZITC_AO_I_FE_FLIG as _Flight on $projection.CarrierID = _Flight.AirlineID and $projection.ConnectionID = _Flight.ConnectionID and $projection.FlightDate = _Flight.FlightDate
  association [1..1] to ZITC_AO_I_FE_CARR as _Carrier on $projection.CarrierID = _Carrier.AirlineID
  association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency
  association [1..1] to /DMO/I_Customer as _Customer on $projection.CustomerID = _Customer.CustomerID
{
  key booking_uuid as BookingUUID,
  
  key travel_uuid as TravelUUID,
  
  booking_id as BookingID,
  
  booking_date as BookingDate,
  
  customer_id as CustomerID,
  
  carrier_id as CarrierID,
  
  connection_id as ConnectionID,
  
  flight_date as FlightDate,
  
  @Semantics.amount.currencyCode: 'CurrencyCode'
  flight_price as FlightPrice,
  
  currency_code as CurrencyCode,
  
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  
  @Semantics.user.lastChangedBy: true
  last_changed_by as LastChangedBy,
  
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  
  --@ObjectModel.readOnly: true
  --_Travel.LastChangedAt as LastChangedAt,
  
  _Travel,
  
  _Connection,
  
  _Flight,
  
  _Carrier,
  
  _Currency,
  
  _Customer
}
