@EndUserText.label: 'Booking Analytics'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZITC_AO_C_BOOKING_ANALYTICS
  as projection on ZITC_AO_I_BOOKING_ANALYTICS
{
  key BookingUUID,
      TravelUUID,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.9
      BookingID,
      BookingDate,
      @EndUserText.label: 'Booking Date (Year)'
      BookingDateYear,
      @EndUserText.label: 'Customer'
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerID,
      CustomerName,
      @EndUserText.label: 'Airline'
      @ObjectModel.text.element: [ 'CarrierName' ]
      CarrierID,
      CarrierName,
      ConnectionID,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @Aggregation.default: #SUM
      FlightPrice,
      CurrencyCode,
      @EndUserText.label: 'Agency'
      @ObjectModel.text.element: [ 'AgencyName' ]
      AgencyID,
      AgencyName,
      CreatedBy,
      LastChangedBy,
      LocalLastChangedAt,
      _Travel,
      _Carrier,
      _Customer,
      _Connection

}
