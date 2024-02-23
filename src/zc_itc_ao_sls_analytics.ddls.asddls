@AbapCatalog.sqlViewName: 'ZCITCAOSLSANA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Analyticcs'
@VDM.viewType: #CONSUMPTION
@Analytics.query: true
define view ZC_ITC_AO_SLS_ANALYTICS as select from ZI_ITC_AO_SALES_CUBE
{
    key Country,
    key CompanyName,
    key Text,
    key ProductCategory,
    CurrencyCode,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    GrossAmount,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    NetAmount,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TaxAmount
        
}
