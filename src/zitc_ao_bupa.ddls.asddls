@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity BIUPA'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZITC_AO_BUPA 
    with parameters p_type: snwd_business_partner_role
 as select from snwd_bpa
{
    key node_key as NodeKey,
//    Data expression language
    case bp_role 
        when '01' then 'Customer'
        when '02' then 'Supplier'
    end as BpRole,
    address_guid as AddressGuid,
    bp_id as BpId,
    company_name as CompanyName
    
} 
