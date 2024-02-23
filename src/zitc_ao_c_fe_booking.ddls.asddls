@EndUserText.label: 'Booking projection on BO Child'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZITC_AO_C_FE_BOOKING as projection on ZITC_ao_I_FE_Booking
{
  key BookingUUID,
  key TravelUUID,
  
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.9 
  BookingID,
  BookingDate,
  @EndUserText.label: 'Customer'
  @ObjectModel.text.element: ['LastName']
  CustomerID,
    
    _Customer.LastName as LastName,
  
    @EndUserText.label: 'Airline'
    @ObjectModel.text.element: ['CarrierName']
    CarrierID,
    _Carrier.Name as CarrierName,
  
  ConnectionID,
  FlightDate,
  FlightPrice,
  CurrencyCode,
  CreatedBy,
  LastChangedBy,
  LocalLastChangedAt,
  /* Associations */
  _Carrier,
  _Connection,
  _Currency,
  _Customer,
  _Flight,
  _Travel : redirected to parent ZITC_AO_C_FE_TRAVEL

}
