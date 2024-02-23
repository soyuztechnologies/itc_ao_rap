@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'booking analytics'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZITC_AO_I_BOOKING_ANALYTICS
  as select from zitc_abook as Booking
  association [0..1] to ZITC_AO_I_TRAVEL_ANALYTICS as _Travel     on  $projection.TravelUUID = _Travel.TravelUUID
  association [1..1] to ZITC_AO_I_FE_CONN          as _Connection on  $projection.CarrierID    = _Connection.AirlineID
                                                                  and $projection.ConnectionID = _Connection.ConnectionID
  association [1..1] to ZITC_AO_I_FE_CARR          as _Carrier    on  $projection.CarrierID = _Carrier.AirlineID
  association [0..1] to /DMO/I_Customer            as _Customer   on  $projection.CustomerID = _Customer.CustomerID
  association [0..1] to /DMO/I_Agency              as _Agency     on  $projection.AgencyID = _Agency.AgencyID
{
  key booking_uuid                 as BookingUUID,
      travel_uuid                  as TravelUUID,
      booking_id                   as BookingID,
      booking_date                 as BookingDate,
      substring (booking_date,1,4) as BookingDateYear,
      customer_id                  as CustomerID,
      _Customer.LastName           as CustomerName,
      carrier_id                   as CarrierID,
      _Carrier.Name                as CarrierName,
      connection_id                as ConnectionID,
      flight_date                  as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price                 as FlightPrice,
      currency_code                as CurrencyCode,
      _Travel.AgencyID             as AgencyID,
      _Travel._Agency.Name         as AgencyName,
      @Semantics.user.createdBy: true
      created_by                   as CreatedBy,
      @Semantics.user.lastChangedBy: true
      last_changed_by              as LastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at        as LocalLastChangedAt,
      _Travel,
      _Carrier,
      _Customer,
      _Connection

}
