@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Sales data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@OData.publish: true
define view entity ZITC_AO_CUST_SLS as select from ZITC_AO_VOV as bpa
association[0..*] to snwd_so as _Orders on
$projection.NodeKey = _Orders.buyer_guid
{
    key bpa.NodeKey,
    bpa.BpRole,
    bpa.AddressGuid,
    bpa.BpId,
    bpa.CompanyName,
    bpa.country,
    bpa.city,
    bpa.building,
    
    //Ad-hoc association - Not good for performance
    //_Orders.so_id
    //Exposed association
    _Orders
    
}
