@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer child entity unmanaged'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZITC_AO_CUSTOMER_U as select from /dmo/customer as Customer
  association [0..1] to I_Country as _Country on $projection.CountryCode = _Country.Country
{
  key Customer.customer_id   as CustomerID,
      Customer.first_name    as FirstName,
      Customer.last_name     as LastName,
      Customer.title         as Title,
      Customer.street        as Street,
      Customer.postal_code   as PostalCode,
      Customer.city          as City,
      Customer.country_code  as CountryCode,
      Customer.phone_number  as PhoneNumber,
      Customer.email_address as EmailAddress,
      _Country
}
