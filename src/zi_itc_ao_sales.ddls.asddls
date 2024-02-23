@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Pure Transactiom Basic Interface'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@VDM.viewType: #BASIC
@Analytics: { dataCategory: #FACT,
              dataExtraction.enabled: true }  
define view entity ZI_ITC_AO_SALES as select from snwd_so_i as items
association[1] to snwd_so as _Header on
$projection.ParentKey = _Header.node_key
{
    key node_key as NodeKey,
    parent_key as ParentKey,
    product_guid as ProductGuid,
    items.currency_code as CurrencyCode,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    items.gross_amount as GrossAmount,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    items.net_amount as NetAmount,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    items.tax_amount as TaxAmount,
    _Header.buyer_guid as BuyerGuid    
}
