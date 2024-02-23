@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View on View concept'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZITC_AO_VOV as select from ZITC_AO_BUPA(p_type:'01') as bpa
inner join snwd_ad as addr on
bpa.AddressGuid = addr.node_key
{
    key bpa.NodeKey,
    bpa.BpRole,
    bpa.AddressGuid,
    bpa.BpId,
    bpa.CompanyName,
    addr.country,
    addr.city,
    addr.building
} 
