@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Composite view product and sales'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@VDM.viewType: #COMPOSITE
@Analytics: { dataCategory: #FACT, dataExtraction.enabled: true }

define view entity ZI_ITC_AO_SLS_PRD as select from ZI_ITC_AO_SALES as sls 
association[1] to ZI_ITC_AO_PRODUCT as _Product
on $projection.ProductGuid = _Product.NodeKey
{
    key NodeKey,
    ParentKey,
    ProductGuid,
    CurrencyCode,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    GrossAmount,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    NetAmount,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TaxAmount,
    BuyerGuid,
    _Product
}
