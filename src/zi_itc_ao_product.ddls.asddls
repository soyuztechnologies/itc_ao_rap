@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product, Basic, Interface'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@VDM.viewType: #BASIC --The view type VDM
@Analytics: { dataCategory: #DIMENSION, --Analytical purpose
              dataExtraction.enabled: true } --The usage is allowed
@ObjectModel.representativeKey: 'ProductId' --Analytic tool to know what is the key of dimension              

define view entity ZI_ITC_AO_PRODUCT as select from snwd_pd 
association[1] to ZP_ITC_AO_PROD_TXT as _ProductText
on $projection.DescGuid = _ProductText.ParentKey
{
   key snwd_pd.node_key as NodeKey,
   snwd_pd.product_id as ProductId,
   snwd_pd.category as Category,
   snwd_pd.desc_guid as DescGuid,
   _ProductText
}
