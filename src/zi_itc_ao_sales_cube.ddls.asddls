@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Composite View, Interface, Cube'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
define view entity ZI_ITC_AO_SALES_CUBE as select from ZI_ITC_AO_SLS_PRD as sales
association[1] to ZI_ITC_AO_CUSTOMER as _Customer on
$projection.BuyerGuid = _Customer.NodeKey
{
    key NodeKey,
    ParentKey,
    ProductGuid,
    CurrencyCode,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    @DefaultAggregation: #SUM
    GrossAmount,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    @DefaultAggregation: #MAX
    NetAmount,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    @DefaultAggregation: #SUM
    TaxAmount,
    BuyerGuid,
    /* Associations */
    _Product.Category as ProductCategory,
    _Product._ProductText[Language='E'].Text,
    _Customer.CompanyName,
    _Customer.Country
} 
