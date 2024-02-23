@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view for second use case'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.headerInfo:{
    typeName: 'IDOC',
    typeNamePlural: 'IDOCs',
    title: { value: 'ErrorCategory' },
    description: { value: 'Docnum' }
}
@VDM.viewType: #CONSUMPTION
@OData.publish: true
define view entity ZITC_AO_C_IDOC_LRP as select from ZITC_AO_CO_IDOC_CAT
association to ZITC_AO_TF_IDOC_MSG as _Message on
$projection.Docnum = _Message.docnum
{
    @UI.facet: [{ 
        purpose: #STANDARD,
        type: #IDENTIFICATION_REFERENCE,
        id: 'main',
        position: 10,
        label: 'more info'
     }]
    @UI.selectionField: [{ position: 10 }]
    @UI.lineItem: [{ position: 10 }]
    @UI.identification: [{ position: 10 }]
    key ZITC_AO_CO_IDOC_CAT.Docnum,
    @UI.selectionField: [{ position: 20 }]
    @UI.lineItem: [{ position: 20 }]
    @UI.identification: [{ position: 20 }]
    Status,
    @UI.selectionField: [{ position: 30 }]
    @UI.lineItem: [{ position: 30 }]
    @UI.identification: [{ position: 30 }]
    Credat,
    Cretim,
    @UI.lineItem: [{ position: 40 }]
    @UI.identification: [{ position: 40 }]
    _Message( p_clnt : $session.client ).statxt,
    Stapa1,
    Stapa2,
    Stapa3,
    Stapa4,
    @UI.identification: [{ position: 50 }]
    @UI.lineItem: [{ position: 50 }]
    ErrorCategory
}
