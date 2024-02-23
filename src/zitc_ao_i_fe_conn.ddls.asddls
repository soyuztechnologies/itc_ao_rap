@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Connection Interface CDS Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZITC_AO_I_FE_CONN as select from zitc_aconn as Connection
  association [1..1] to ZITC_AO_I_FE_CARR as _Airline on $projection.AirlineID = _Airline.AirlineID
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
  key Connection.carrier_id as AirlineID,
  
  key Connection.connection_id as ConnectionID,
  
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: '/DMO/I_Airport', 
      element: 'AirportID'
    }
  } ]
  Connection.airport_from_id as DepartureAirport,
  
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: '/DMO/I_Airport', 
      element: 'AirportID'
    }
  } ]
  Connection.airport_to_id as DestinationAirport,
  
  Connection.departure_time as DepartureTime,
  
  Connection.arrival_time as ArrivalTime,
  
  --@Semantics.quantity.unitOfMeasure: 'DistanceUnit'
  Connection.distance as Distance,
  
  --@Semantics.unitOfMeasure: true
  Connection.distance_unit as DistanceUnit,
  
  _Airline
}
