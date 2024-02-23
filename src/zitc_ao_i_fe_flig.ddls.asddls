@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight Details for Airline Connections'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZITC_AO_I_FE_FLIG as select from zitc_aflig as Flight
  association [1] to ZITC_AO_I_FE_CARR as _Airline on $projection.AirlineID = _Airline.AirlineID
  association [1] to ZITC_AO_I_FE_CONN as _Connection on $projection.ConnectionID = _Connection.ConnectionID and $projection.AirlineID = _Connection.AirlineID
  association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency
{
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8 
  @ObjectModel.text.association: '_Airline'
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'ZITC_AO_I_FE_CARR', 
      element: 'AirlineID'
    }
  } ]
  key Flight.carrier_id as AirlineID,
  
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8 
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'ZITC_AO_I_FE_CONN', 
      element: 'ConnectionID'
    }, 
    additionalBinding: [ {
      element: 'AirlineID', 
      localElement: 'AirlineID'
    } ]
  } ]
  key Flight.connection_id as ConnectionID,
  
  key Flight.flight_date as FlightDate,
  
  @Semantics.amount.currencyCode: 'CurrencyCode'
  Flight.price as Price,
  
  --@Semantics.currencyCode: true
  Flight.currency_code as CurrencyCode,
  
  Flight.plane_type_id as PlaneType,
  
  Flight.seats_max as MaximumSeats,
  
  Flight.seats_occupied as OccupiedSeats,
  
  _Airline,
  
  _Connection,
  
  _Currency
}
