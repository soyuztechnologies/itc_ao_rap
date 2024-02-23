@AbapCatalog.sqlViewName: 'ZITCAOBPA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Get all business parrtner data'
define view ZITC_AO_BPA as select from snwd_bpa
{
    key node_key as NodeKey,
    bp_role as BpRole,
    address_guid as AddressGuid,
    bp_id as BpId,
    company_name as CompanyName
    
}
