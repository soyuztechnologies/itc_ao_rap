@AbapCatalog.sqlViewName: 'ZCATSXXFLIGHT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight CDS BOPF scenario'
@VDM.viewType: #CONSUMPTION
@OData.publish: true

@UI.headerInfo:{
    typeName: 'Flight',
    typeNamePlural: 'Flights',
    title: { value: 'Carrid' },
    description: { value: 'Connid' },
    imageUrl: 'https://img-c.udemycdn.com/user/200_H/232449918_f665_2.jpg'
}

@ObjectModel:{
    modelCategory: #BUSINESS_OBJECT,
    compositionRoot: true,
    writeActivePersistence: 'ZOFT_MEALS',
    transactionalProcessingEnabled: true,
    createEnabled: true,
    updateEnabled: true,
    deleteEnabled: true,
    draftEnabled: true,
    writeDraftPersistence: 'ZITC_AO_MEAL'
}
define view ZC_ATS_XX_FLIGHT as select from zoft_meals
association[1] to scarr as _Airline on
$projection.Carrid = _Airline.carrid
association[1] to spfli as _Connection on
$projection.Carrid = _Connection.carrid and
$projection.Connid = _Connection.connid
association[1] to smeal as _Meals on
$projection.Meal = _Meals.mealnumber
{
    @UI.facet: [{ 
        id: 'facet1',
        purpose: #STANDARD,
        type: #IDENTIFICATION_REFERENCE,
        label: 'More Info',
        position: 1
     }]
    key meal_id as Meal_Id,
    @UI.selectionField: [{ position: 10 }]
    @UI.lineItem: [{ position: 10 }]
    @UI.identification: [{ position: 10 }]
    @ObjectModel.foreignKey.association: '_Airline'
    carrid as Carrid,
    @UI.selectionField: [{ position: 20 }]
    @UI.lineItem: [{ position: 20 }]
    @UI.identification: [{ position: 20 }]
    @ObjectModel.foreignKey.association: '_Connection'
    connid as Connid,
    @UI.lineItem: [{ position: 30 }]
    @UI.identification: [{ position: 30 }]
    @ObjectModel.foreignKey.association: '_Meals'
    meal as Meal,
    @UI.lineItem: [{ position: 40 }]
    @UI.identification: [{ position: 40 }]
    total_seats as Total_Seats,
    @UI.selectionField: [{ position: 30 }]
    @UI.lineItem: [{ position: 50, label: 'Approval' },
    { type: #FOR_ACTION, label: 'Approve', dataAction: 'BOPF:AO_APPROVE' }]
    @UI.identification: [{ position: 50 }]
    status as Status,
    _Airline,
    _Connection,
    _Meals
}
