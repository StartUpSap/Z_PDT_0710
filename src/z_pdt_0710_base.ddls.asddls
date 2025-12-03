@AbapCatalog.sqlViewName: 'Z_PDT0710_BASE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reporte Tesoreria Base'
@Metadata.ignorePropagatedAnnotations: true
define view Z_PDT_0710_BASE 
as select from I_GLAccountLineItem
{
    key CompanyCode,
    key GLAccount, 
    FiscalYear,

    @EndUserText.label: 'Saldo Inicial Debe'
    cast(
        sum(
          case 
            when FiscalPeriod = '000' and DebitCreditCode = 'S' and AmountInCompanyCodeCurrency > 0
            then cast(AmountInCompanyCodeCurrency as abap.dec(17,2)) 
            else cast(0 as abap.dec(17,2))
          end
        ) as abap.dec(17,2)
    ) as SaldoInicialDebe,

    @EndUserText.label: 'Saldo Inicial Haber'
    cast(
        sum(
            case 
              when FiscalPeriod = '000' and DebitCreditCode = 'H' and AmountInCompanyCodeCurrency < 0
              then cast(AmountInCompanyCodeCurrency as abap.dec(17,2)) 
              else cast(0 as abap.dec(17,2))
            end
        ) as abap.dec(17,2)
    )*(-1) as SaldoInicialHaber,

    @EndUserText.label: 'Movimientos Debe'
    cast(
        sum(
            case 
              when FiscalPeriod <> '000'
              then cast(DebitAmountInCoCodeCrcy as abap.dec(17,2)) 
            else cast(0 as abap.dec(17,2))
            end
        ) as abap.dec(17,2)
    ) as MovimientosDebe,

    @EndUserText.label: 'Movimientos Haber'
    cast(
        sum(
            case 
              when FiscalPeriod <> '000'
              then cast(CreditAmountInCoCodeCrcy as abap.dec(17,2)) 
            else cast(0 as abap.dec(17,2))
            end
        ) as abap.dec(17,2)
    )*(-1) as MovimientosHaber,

    @EndUserText.label: 'Sumas del Mayor Debe'
    cast(
        sum(
          case 
            when FiscalPeriod = '000' and DebitCreditCode = 'S' and AmountInCompanyCodeCurrency > 0
            then cast(AmountInCompanyCodeCurrency as abap.dec(17,2)) 
            else cast(0 as abap.dec(17,2))
          end
        ) as abap.dec(17,2)
    ) +
    cast(
        sum(
            case 
              when FiscalPeriod <> '000'
              then cast(DebitAmountInCoCodeCrcy as abap.dec(17,2)) 
            else cast(0 as abap.dec(17,2))
            end
        ) as abap.dec(17,2)
    ) as SumasMayorDebe,

    @EndUserText.label: 'Sumas del Mayor Haber'
    cast(
        sum(
            case 
              when FiscalPeriod = '000' and DebitCreditCode = 'H' and AmountInCompanyCodeCurrency < 0
              then cast(AmountInCompanyCodeCurrency as abap.dec(17,2)) 
              else cast(0 as abap.dec(17,2))
            end
        ) as abap.dec(17,2)
    )*(-1) + cast(
        sum(
            case 
              when FiscalPeriod <> '000'
              then cast(CreditAmountInCoCodeCrcy as abap.dec(17,2)) 
            else cast(0 as abap.dec(17,2))
            end
        ) as abap.dec(17,2)
    )*(-1) as SumasMayorHaber
 }
 where
  Ledger ='0L'
group by
    CompanyCode,
    GLAccount,
    CompanyCodeCurrency,
    FiscalYear
