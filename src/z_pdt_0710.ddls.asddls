@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reporte PDT 0710 Balance de Comprobacion'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_PDT_0710
  with parameters
    p_companycode : bukrs,
    p_fiscalyear  : gjahr 
as select from Z_PDT_0710_BASE
{
    key CompanyCode,
    key GLAccount, 

    @EndUserText.label: 'Saldo Inicial Debe'
    SaldoInicialDebe,

    @EndUserText.label: 'Saldo Inicial Haber'
    SaldoInicialHaber,

    @EndUserText.label: 'Movimientos Debe'
    MovimientosDebe,

    @EndUserText.label: 'Movimientos Haber'
    MovimientosHaber,

    @EndUserText.label: 'Sumas del Mayor Debe'
    SumasMayorDebe,

    @EndUserText.label: 'Sumas del Mayor Haber'
    SumasMayorHaber,

    @EndUserText.label: 'Saldo al 31/12 Deudor'
    cast(
        case
            when (SumasMayorDebe - SumasMayorHaber ) > 0
            then SumasMayorDebe - SumasMayorHaber
            else 0
        end as abap.dec(17,2)
    ) as SaldoDeudor,

    @EndUserText.label: 'Saldo al 31/12 Acreedor'
    cast(
        case
            when (SumasMayorHaber - SumasMayorDebe ) > 0
            then SumasMayorHaber - SumasMayorDebe
            else 0
        end as abap.dec(17,2)
    ) as SaldoAcreedor
}
where CompanyCode = $parameters.p_companycode
  and FiscalYear = $parameters.p_fiscalyear
group by
    CompanyCode,
    GLAccount,
    SaldoInicialDebe,
    SaldoInicialHaber,
    MovimientosDebe,
    MovimientosHaber,
    SumasMayorDebe,
    SumasMayorHaber
