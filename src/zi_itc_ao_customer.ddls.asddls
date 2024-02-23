@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Basic, Interface'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@VDM.viewType: #BASIC
@Analytics: {
                dataCategory: #DIMENSION,
                dataExtraction.enabled: true
}
@ObjectModel.representativeKey: 'BpId'

define view entity ZI_ITC_AO_CUSTOMER as select from snwd_bpa as Bpa 
association[1] to snwd_ad as _Address on
$projection.AddressGuid = _Address.node_key
{
    key Bpa.node_key as NodeKey,
    Bpa.bp_role as BpRole,
    Bpa.bp_id as BpId,
    Bpa.company_name as CompanyName, 
    address_guid as AddressGuid,
    _Address.country as Country 
} where bp_role = '01'
