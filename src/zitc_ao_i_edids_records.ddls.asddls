@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Control and Status Recoprd'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZITC_AO_I_EDIDS_RECORDS as select from edids 
inner join ZITC_AO_I_EDIDS_MAX as _MaxRecord
on edids.docnum = _MaxRecord.docnum
and edids.countr = _MaxRecord.countr
{
    key edids.docnum as Docnum,
    key _MaxRecord.countr as Countr,
    edids.status as Status,
    edids.statxt as Statxt,
    edids.stapa1 as Stapa1,
    edids.stapa2 as Stapa2,
    edids.stapa3 as Stapa3,
    edids.stapa4 as Stapa4,
    edids.stamid as Stamid,
    edids.stamno as Stamno,
    case 
        when(edids.stamid = 'CASH_MSG' and edids.stamno = '095') then 'Not Routed'
        when(edids.stamid = 'V1' and edids.stamno = '384') then 'Missing Part number'
        when(edids.stamid = 'TAX_TXJCD' and edids.stamno = '101') then 'Address Error'
        when(edids.stamid = 'VG' and edids.stamno = '140') then 'Ship-to LOC ID not setup'
        else 'Others' end as ErrorCategory,
    case when (edids.stamid = 'CASH_MSG' and edids.stamno = '095') then cast(1 as abap.int4)  else   0 end as NotRouted,
    case when (edids.stamid = 'V1' and edids.stamno = '095') then cast(1 as abap.int4)  else 0 end as MissingPartNo,
    case when (edids.stamid = 'TAX_TXJCD' and edids.stamno = '101') then cast(1 as abap.int4)  else 0 end as AddressErr,
    case when (edids.stamid = 'VG' and edids.stamno = '140') then cast(1 as abap.int4) else 0 end as ShipLocErr,
    case when ((edids.stamid = 'CASH_MSG' and edids.stamno = '095') or
    (edids.stamid = 'V1' and edids.stamno = '095') or
    (edids.stamid = 'TAX_TXJCD' and edids.stamno = '101') or 
    (edids.stamid = 'VG' and edids.stamno = '140') ) then 0 else cast(1 as abap.int4)  end as Others

}
