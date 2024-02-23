@AbapCatalog.sqlViewName: 'ZITC_AOCIDOCDSHB'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'IDOC Dashboard consumption view'
@VDM.viewType: #CONSUMPTION
@OData.publish: true
@UI.chart: [{ 
    chartType: #DONUT,
    title: 'Total Issues',
    description: 'Error Category by Total',
    dimensions: ['ErrorCategory'],
    measures: ['TotalIssues'],
    dimensionAttributes: [{dimension: 'ErrorCategory', role: #CATEGORY }],
    measureAttributes: [{measure: 'TotalIssues', asDataPoint: true,role: #AXIS_1 }]
},{
    qualifier: 'spiderman',
    chartType: #COLUMN,
    title: 'Total Issues',
    description: 'Error Category by Total',
    dimensions: ['ErrorCategory'],
    measures: ['TotalIssues'],
    dimensionAttributes: [{dimension: 'ErrorCategory', role: #CATEGORY }],
    measureAttributes: [{measure: 'TotalIssues', asDataPoint: true,role: #AXIS_1 }]
}]

define view ZITC_AO_C_IDOC_DSHB as select from ZITC_AO_CO_IDOC_CAT {
    @UI.lineItem: [{position: 10 }]
    key ErrorCategory,
    @DefaultAggregation: #SUM
    @UI.lineItem: [{position: 20, type: #AS_DATAPOINT }]
    @UI.dataPoint:{
        criticalityCalculation:{
            improvementDirection: #MINIMIZE,
            deviationRangeHighValue: 1500,
            deviationRangeLowValue: 1500,
            toleranceRangeLowValue: 50,
            toleranceRangeHighValue: 50
        }
    }
    sum( case ErrorCategory
            when 'Not Routed' then NotRouted
            when 'Missing Part number' then MissingPartNo 
            when 'Address Error' then  AddressErr
            when 'Ship-to LOC ID not setup' then ShipLocErr 
            else Others end 
     ) as TotalIssues
    
    
} group by ErrorCategory
