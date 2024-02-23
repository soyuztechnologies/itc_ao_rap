@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product text, private'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@VDM.private: true
@VDM.viewType: #BASIC
@ObjectModel.dataCategory: #TEXT
define view entity ZP_ITC_AO_PROD_TXT as select from snwd_texts {
    key node_key as NodeKey,
    parent_key as ParentKey,
    @Semantics.language: true
    language as Language,
    text as Text
}
