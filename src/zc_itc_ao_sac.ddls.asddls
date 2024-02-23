@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'sap Analytics cloud consumption demo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@VDM.viewType: #CONSUMPTION
@Analytics.dataCategory: #CUBE
@OData.publish: true
define view entity ZC_ITC_AO_SAC as select from SEPM_I_SalesOrderItem_E_V2
{
    key SalesOrder,
    key SalesOrderItem,
    _SalesOrder._Customer.CompanyName as CompanyName,
    _SalesOrder._Customer.Country as Country,
    _SalesOrder._Customer.CityName as CityName,
    Product,
    TransactionCurrency as CurrencyCode,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    @DefaultAggregation: #SUM
    @EndUserText.label: 'GrossAmountLocalCurrency'
    GrossAmountInTransacCurrency,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    @DefaultAggregation: #SUM
    NetAmountInTransactionCurrency,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    @DefaultAggregation: #SUM
    TaxAmountInTransactionCurrency,
    ProductAvailabilityStatus,
    @DefaultAggregation: #SUM
    @Semantics.quantity.unitOfMeasure: 'QuantityUnit'
    Quantity,
    QuantityUnit,
    /* Associations */
    _Product._ProductCategory.ProductCategory,
    _Product._Text.ProductDescription,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    @DefaultAggregation: #SUM
    currency_conversion(amount => GrossAmountInTransacCurrency, 
    source_currency => TransactionCurrency, 
    target_currency => cast('EUR' as abap.cuky( 5 )), 
    exchange_rate_date => cast('20220227' as abap.dats)) as FinalGrossAmount
}
