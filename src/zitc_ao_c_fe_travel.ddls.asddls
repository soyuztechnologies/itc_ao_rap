@EndUserText.label: 'Travel Projection, Consumption View, Fiori Elements'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: [ 'TravelID' ]
define root view entity ZITC_AO_C_FE_TRAVEL as projection on ZITC_AO_I_FE_TRAVEL
{
  key TravelUUID,
  
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.90 
  @EndUserText.label: 'Travel'
  @ObjectModel.text.element:  [ 'Description' ]
  TravelID,
  
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: '/DMO/I_Agency', 
      element: 'AgencyID'
    }
  } ]
  @Search.defaultSearchElement: true
  @EndUserText.label: 'Agency'
  @ObjectModel.text.element: ['AgencyName']
  AgencyID,
    
  _Agency.Name as AgencyName,
  
  @Search.defaultSearchElement: true
  @EndUserText.label: 'Customer'
  @ObjectModel.text.element: ['LastName']
  @Consumption.valueHelpDefinition: [{ entity : 
        {name: '/DMO/I_Customer', element: 'CustomerID'  
  } }]
  CustomerID,
  
  _Customer.LastName as LastName,
  
  BeginDate,
  
  EndDate,
  
  @Semantics.amount.currencyCode: 'CurrencyCode'
  BookingFee,
  
  @Semantics.amount.currencyCode: 'CurrencyCode'
  TotalPrice,
  
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_Currency', 
      element: 'Currency'
    }
  } ]
  CurrencyCode,
  
  Description,
  
  @EndUserText.label: 'Status'
  @Consumption.valueHelpDefinition: [{ entity : {name: 'ZITC_AO_I_FE_STAT', element: 'TravelStatusId'  } }]
  @UI.textArrangement: #TEXT_ONLY
  @ObjectModel.text.element: ['TravelStatusText']
  OverallStatus,
  
  OverallStatusCriticality,
  
  _TravelStatus.TravelStatusText as TravelStatusText,
  
  CreatedBy,
  
  CreatedAt,
  
  LastChangedBy,
  
  
  LastChangedAt,
  
  @EndUserText.label: 'Last Changed At'
  LocalLastChangedAt,
  
  _Booking : redirected to composition child ZITC_AO_C_FE_BOOKING,
  
  _Agency,
  
  _Currency,
  
  _Customer,
  
  _TravelStatus
}
