     H nomain
     H datedit(*DMY/)
     H option(*noshowcpy:*srcstmt)
      * ************************************************************ *
      * SVPSIN: Programa de Servicio.                                *
      *         Siniestros.                                          *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                     30-Sep-2014             *
      *------------------------------------------------------------- *
      * Compilacion: Debe tener enlazado el SRVPGM - SPVFEC          *
      * CRTSRVPGM SRVPGM(SVPSIN) MODULE(SVPSIN) SRCFILE(QSRVSRC)     *
      * MBR(SVPSIN) BNDSRVPGM(SPVFEC)                                *
      * ************************************************************ *
      * Modificaciones:                                              *
      * SFA 11/03/15 - Agrego nuevo procedimiento SVPSIN_getSumAsComp*
      *                                           SVPSIN_getIndem    *
      * SFA 15/05/15 - Agrego nuevo procedimiento SVPSIN_getEstSin   *
      *                                           SVPSIN_getEstRec   *
      *                                           SVPSIN_getEstJui   *
      * LRG 08/06/15 - Agrego nuevo procedimiento SVPSIN_chkSiniPend *
      *                                           SVPSIN_chkSiniPag  *
      *                                           SVPSIN_chkSiniDen  *
      * LRG 01/07/15 - Agrego nuevo Procedimiento SVPSIN_chkWeb      *
      * SFA 15/05/15 - Agrego nuevo procedimiento SVPSIN_getPagosJui *
      * NWN 25/07/16 - Agrego Control en SVPSIN_chkFinSini.          *
      *                Si HETERM = 'T' es Stro.Terminado.            *
      * LRG 01/06/15 - Agrego nuevo Procedimiento SVPSIN_getSpol     *
      *                                           SVPSIN_getPol      *
      * SFA 08/06/16 - Agrego nuevo Procedimiento SVPSIN_chkCausaReno*
      * JSN 09/01/19 - Agrego nuevos Procedimientos                  *
      *                SVPSIN_getFechaDelDia                         *
      *                SVPSIN_getConfiguracionVoucherRuedasCristales *
      *                SVPSIN_getCantidadSiniestrosRuedasPorVehiculo *
      *                SVPSIN_getCantidadSiniestrosCristalesPorVehiculo
      *                SVPSIN_getNumeroVoucher                       *
      *                SVPSIN_setNumeroVoucher                       *
      * GIO 22/04/19 - Por tarea RM#04725 se detecto error en la app *
      *                original. Se cambia el formato de la fecha de *
      *                entrada en SP0052 por el formato DDMMAAAA     *
      * GIO 26/06/19 - RM#5219 Incluir a las predenuncias en el      *
      *                conteo de siniestros                          *
      * JSN 03/07/19 - Se modifica Longitud de Parametro Rama en los *
      *                procedimientos:                               *
      *                SVPSIN_getCantidadSiniestrosRuedasPorVehiculo *
      *                SVPSIN_getCantidadSiniestrosCristalesPorVehiculo
      * JSN 10/12/19 - Se agrega nuevos procedimientos:              *
      *                SVPSIN_getCaratula                            *
      *                SVPSIN_getVehiculo                            *
      *     17/12/19 - SVPSIN_getBeneficiarios                       *
      *                SVPSIN_Subsiniestros                          *
      *     19/12/19 - SVPSIN_getUltimoSubsiniestro                  *
      *     02/01/20 - SVPSIN_getConductorTercero                    *
      *                SVPSIN_getVehiculoTercero                     *
      *     08/01/20 - SVPSIN_getUltFechaPago                        *
      * NWN 15/03/21 - Se agrega nuevos procedimientos:              *
      *              - SVPSIN_terminarSiniestro                      *
      *              - SVPSIN_terminarReclamo                        *
      *              - SVPSIN_nivelarRvaStro                         *
      *              - SVPSIN_terminarCaratula                       *
      *              - SVPSIN_getSet402                              *
      *              - SVPSIN_getSet456                              *
      *              - SVPSIN_wrtEstSin                              *
      *              - SVPSIN_getRvaStro                             *
      *              - SVPSIN_getFraStro                             *
      *              - SVPSIN_getPagStro                             *
      *              - SVPSIN_getRvaActStro                          *
      *              - SVPSIN_chkStroEnJuicio                        *
      *              - SVPSIN_nivelarRvaStroBenef                    *
      *              - SVPSIN_terminarReclamoStro                    *
      *              - SVPSIN_nivelarFraStro                         *
      *              - SVPSIN_nivelarFraStroBenef                    *
      * NWN 17/06/21 - Se agrega nuevos procedimientos:              *
      *              - SVPSIN_getCaratula2                           *
      *              - SVPSIN_getPahSc1                              *
      *              - SVPSIN_getPahSd1                              *
      *              - SVPSIN_getPahSd2                              *
      * NWN 13/07/21 - Se agrega nuevos procedimientos:              *
      *              - SVPSIN_getPahStc                              *
      *                                                              *
      * NWN 05/08/21 - Se agrega chkstroenjuicio en terminarSiniestro*
      *              - Se agrega chkstroenjuicio en terminarReclamo  *
      *                No se puede terminar un siniestro que tenga   *
      *                Juicio.                                       *
      *                                                              *
      * DOT 05/10/21 - Se agrega chkNroOperStro                      *
      *              Funcion: Validar la existencia de un numero de  *
      *                       operación de siniestro.                *
      *                                                              *
      *              - Se agrega getSiniestroDesdeNops               *
      *              Funcion: Obtener el numero de Siniestro de una  *
      *                       operación de siniestro.                *
      *                                                              *
      * DOT 11/11/21 - Se agrega chkSinModificable                   *
      *              Funcion: Validar que el siniestro tenga un es_  *
      *                       valido para modificar Caratula,Benefic.*
      *                       Reservas Franquicias pagos etc.logica  *
      *                       SAR907.                                *
      *                                                              *
      * NWN 19/11/21 - Se agrega terminarReclamoV1                   *
      *                Se agrega getRvaXReclamo                      *
      *                Se agrega getReclamosXStro                    *
      *                Se agrega terminarBenefXReclamo               *
      *                Se agrega chgEstadosReclamo                   *
      *                Se agrega chkEstadosReclamo                   *
      * JSN 26/11/21 - Se agrega el procedimiento getSaldoActual     *
      *                                                              *
      * FAS 06/12/21 - Se agrega el procedimiento                    *
      *                rehabilitarSiniestro                          *
      *                                                              *
      * VCM 23/12/21 - Se agrega procedimientos para Cnhop2          *
      * VCM 23/12/21 - Se agrega procedimientos para Cnhop3          *
      * FAS 23/12/21 - Se agrega procedimientos para Cnhret          *
      * FAS 23/12/21 - Se agrega procedimientos para Cnhpib          *
      *                                                              *
      * NWN 03/01/22 - Se agrega procedimientos para Cnhopa          *
      *              - Se agrega procedimientos para Cnwnin          *
      *              - Se agrega generarOrdPagStroTotal              *
      *              - Se agrega setPerporProv                       *
      *              - Se agrega setRetporProv                       *
      *              - Se agrega obtSecPib                           *
      *              - Se agrega obtSecRet                           *
      *              - Se agrega obtSecNin                           *
      * JSN 08/03/22 - Se agrega el procedimiento:                   *
      *                _getSiniestroXFecha                           *
      *                                                              *
      * FAS 08/02/22 - Se modifico _getRva                           *
      *                            _getFra                           *
      *                            _getPag                           *
      *                            _getRvaAct                        *
      *                Cambio: Se agergan parametros de llamada      *
      *                        Riesgo y Cobertura                    *
      * SGF 01/09/22 - Mejora control de duplicidad.                 *
      *                                                              *
      * LMB 06/10/22 - Se agrega setPahSb5()                         *
      * LMB 25/10/22 - Se agrega updPahSb5()                         *
      * LMB 06/10/22 - Se agrega dltPahSb5()                         *
      * LMB 04/10/22 - Se agrega getPahsb5()                         *
      * LMB 06/10/22 - Se agrega chkPahsb5()                         *
      * LMB 06/10/22 - Se agrega chkFechaAcuerdo()                   *
      * LMB 11/10/22 - Se agrega chkPorcIncapFisica()                *
      * LMB 06/10/22 - Se agrega chkPorcIncapPsico()                 *
      * LMB 09/11/22 - Se agrega chkAcuerdo()                        *
      * LMB 06/10/22 - Se agrega chkImpoDañoMoral()                  *
      * LMB 06/10/22 - Se agrega chkImpoDanoMaterial()               *
      * LMB 11/10/22 - Se agrega chkImpoPrivUso()                    *
      * LMB 11/10/22 - Se agrega chkImpLucCesa()                     *
      * LMB 11/10/22 - Se agrega chkImpTratFut()                     *
      * LMB 11/10/22 - Se agrega chkImpGasMed()                      *
      * LMB 06/10/22 - Se agrega chkImpOtroRubro()                   *
      * LMB 11/10/22 - Se agrega chkImpIncFisica()                   *
      * LMB 11/10/22 - Se agrega chkImpIncPsico()                    *
      * LMB 11/10/22 - Se agrega chkFecSupHoy()                      *
      * LMB 12/10/22 - Se agrega chkSumaAcuerdo()                    *
      * LMB 11/10/22 - Se agrega chkIncFisica()                      *
      * LMB 13/10/22 - Se agrega chkIncPsico()                       *
      * LMB 13/10/22 - Se agrega chkLucroPri()                       *
      * LMB 13/10/22 - Se agrega chkDanosExc()                       *
      * LMB 01/11/22 - Se agrega ListaPahSb5()                       *
      * LMB 01/11/22 - Se agrega chkBenTercero()                     *
      *                                                              *
      * FAS 25/11/22 - Se agrega chkEstadoTerminal                   *
      *                                                              *
      * LMB 05/01/23 - Se agrega getReservaRV()                      *
      * SGF 10/03/23 - Cuando cuenta predenuncias debe contar las de *
      *                la misma anualidad.                           *
      * FAS 21/03/23 - Se modifica SVPSIN_terminarSiniestro          *
      * SGF 05/04/23 - Acomodo SVPSIN_chgEstadosReclamo().           *
      * LRG 01/02/23 - Se agregan campos a archivo GTI960            *
      *                Se modifica estructura dsGti960_t             *
      *                Se modifica procedimineto:                    *
      *                   - SVPSIN_setGti960                         *
      *                   - SVPSIN_getGti960                         *
      * IMF 30/10/24 - Agrego SVPSIN_getUltTipPago (retorna el tipo  *
      *                de pago del ultimo pago)                      *
      * NWN 21/07/25 - Se arregla SVPSIN_generarOrdPagStroTotal.     *
      *                Se mueve campo peFfac a CNHRET campos rtfafa  *
      *                rtfafm y ftfafd. Fecha de Factura de la O.P.  *
      * SGF 26/07/25 - Cambia PAHJCR. Recompilo.                     *
      * ************************************************************ *
     Fpahscd    uf   e           k disk    usropn
     Fpahjhp    if   e           k disk    usropn
     Fpahjcr    if   e           k disk    usropn
     Fpahjc1    if   e           k disk    usropn
     Fgntmon    if   e           k disk    usropn
     Fset402    if   e           k disk    usropn
     Fset4021   if   e           k disk    usropn
     Fpahsb1    uf a e           k disk    usropn
     Fpahsb102  if   e           k disk    usropn
     Fpahsfr01  if   e           k disk    usropn
     Fpahshe04  if   e           k disk    usropn
     Fpahshe    if   e           k disk    usropn
     Fpahshe01  if a e           k disk    usropn
     Fpahsbe05  if   e           k disk    usropn
     Fpahscd03  if   e           k disk    usropn
     Fpahscd11  if   e           k disk    usropn
     Fpahshp    if   e           k disk    usropn
     Fpahshp04  if   e           k disk    usropn
     Fpahsfr    if a e           k disk    usropn
     Fpahshr    if a e           k disk    usropn
     Fpahet0    if   e           k disk    usropn
     Fpaher0    if   e           k disk    usropn
     Fpahev1    if   e           k disk    usropn
     Fset001    if   e           k disk    usropn
     Fpahshp01  if   e           k disk    usropn rename( p1hshp : p1hshp01 )
     Fset475    if   e           k disk    usropn prefix(t475_)
     Fpahsva06  if   e           k disk    usropn rename( p1hsva : p1hsva06 )
     Fpds00007  if   e           k disk    usropn rename( p1ds00 : p1ds0007 )
     F                                            prefix(s007_)
     Fpds000    uf   e           k disk    usropn
     Fpahsva    if   e           k disk    usropn
     Fpahsbe    if   e           k disk    usropn
     Fpahsb2    if   e           k disk    usropn
     Fpahsb4    if   e           k disk    usropn
     Fset456    if   e           k disk    usropn
     Fpahsc1    if   e           k disk    usropn
     Fpahsd1    if   e           k disk    usropn
     Fpahsd2    if   e           k disk    usropn
     Fpahstc    if   e           k disk    usropn
     Fpahsd0    if   e           k disk    usropn
      * LF Siniestros x Articulos Carátula de denuncias
     Fpahscd01  if   e           k disk    usropn
     Fset412    if   e           k disk    usropn
     Fset406    if   e           k disk    usropn
     Fset407    if   e           k disk    usropn
     Fpahscc    if   e           k disk    usropn
     Fcnhop2    uf a e           k disk    usropn
     Fcnhop3    uf a e           k disk    usropn
     Fcnhpib    uf a e           k disk    usropn
     Fcnhret    uf a e           k disk    usropn
     Fpahshr05  if   e           k disk    usropn
     Fcnhopa    uf a e           k disk    usropn
     Fpahshp12  if a e           k disk    usropn
     Fcnwnin    uf a e           k disk    usropn
     Fset400    if   e           k disk    usropn
     Fcntopa    uf a e           k disk    usropn
     Fgnttge    if   e           k disk    usropn
     Fcntnau01  if   e           k disk    usropn
     Fgntloc02  if   e           k disk    usropn
     Fcnhop1    uf a e           k disk    usropn
     Fcnwopa    uf a e           k disk    usropn
     Fcnhmop    uf a e           k disk    usropn
     Fgti981s   uf a e           k disk    usropn
     Fcnhret01  uf a e           k disk    usropn
     Fgntdim    if   e           k disk    usropn
     Fgti960    uf a e           k disk    usropn
     Fgti965    uf a e           k disk    usropn
     Fpahscd98  if   e           k disk    usropn rename( p1hscd : p1hscd98 )
     Fpahshr03  if   e           k disk    usropn
     Fpahsfr02  if   e           k disk    usropn
     Fpahshp03  if   e           k disk    usropn
     Fpahsbs08  if   e           k disk    usropn
     Fpahsb5    uf a e           k disk    usropn
     Fset47601  if   e           k disk    usropn
     Fpahscd13  if   e           k disk    usropn prefix(c3:2)

      *--- Copy H -------------------------------------------------- *
      * Se cambio a proyecto BPM 13/10/2021 DOT                      *
      /copy hdiile/qcpybooks,svpsin_h
      /copy hdiile/qcpybooks,sinest_h
      /copy hdiile/qcpybooks,svpsi1_h
      /copy hdiile/qcpybooks,svptab_h
      /copy hdiile/qcpybooks,spvfec_h
      /copy hdiile/qcpybooks,svppds_h
      /copy hdiile/qcpybooks,svpdaf_h
      /copy hdiile/qcpybooks,spvfac_h
      /copy hdiile/qcpybooks,svprvs_h

      *- Area Local del Sistema. -------------------------- *
     D                sds
     D  ususer               254    263
     D  ususr2               358    367
     D  nompgm                 1     10
     D  nomjob               244    253
     D  nomusr               254    263
      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

      *--- PR Externos --------------------------------------------- *
     D DBA456R         pr                  extpgm('DBA456R')
     D    a                           4  0
     D    m                           2  0
     D    d                           2  0

     D SP0052          pr                  extpgm('SP0052')
     D   como                         2
     D   fech                         8  0
     D   cotc                        15  6
     D   tipo                         1a
     D   erro                         1n   options(*nopass)

     D SAR902          pr                  extpgm('SAR902')
     D   rama                         2  0
     D   sini                         7  0
     D   nops                         7  0

     D SPT902          pr                  extpgm('SPT902')
     D   tnum                         1a   const
     D   nres                         7  0

     D SP0046          pr                  extpgm('SP0046')
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       6  0 const
     D   peFasa                       4  0 const
     D   peFasm                       2  0 const
     D   peFasd                       2  0 const
     D   peCoi2                       2  0
     D   peCoi1                       1  0
     D   pePoim                       5  2

     D SP0038          pr                  extpgm('SP0038')
     D   $pariv                      55

     D SAR037          pr                  extpgm('SAR037')
     D   hprama                       2  0 const
     D   hpsini                       7  0 const
     D   hpnops                       7  0 const
     D   hppoco                       6  0 const
     D   hppaco                       3  0 const
     D   hpnrdf                       7  0 const
     D   hpsebe                       6  0 const
     D   hpriec                       3    const
     D   hpxcob                       3  0 const
     D   hpfmoa                       4  0 const
     D   hpfmom                       2  0 const
     D   hpfmod                       2  0 const
     D   hppsec                       2  0 const
     D   hpmar3                       3    const
     D                 ds
     D   wpariv                1     55
     D   weciva                1      2  0
     D   wefasa                3      6  0
     D   wefasm                7      8  0
     D   wefasd                9     10  0
     D   wepivi               11     15  2
     D   wepivn               16     20  2
     D   wedisf               21     21
     D   wedisa               22     22
     D   wencil               23     52
     D   wencic               53     55

     D                 ds                  inz
     D  $peffac                1     10
     D  $peffaa                1      4  0
     D  $peffa2                3      4  0
     D  $pegui1                5      5
     D  $peffam                6      7  0
     D  $pegui2                8      8
     D  $peffad                9     10  0


     D                 ds                  inz
     D  xxfpamd                1      8  0
     D  xxfppa                 1      4  0
     D  xxfppm                 5      6  0
     D  xxfppd                 7      8  0

     D                 ds                  inz
     D  $afhc                  1     13  0
     D  $uaÑo                  1      2  0
     D  $umes                  3      4  0
     D  $udia                  5      6  0
     D  $hora                  7     12  0
     D  $abcv                 13     13  0

     * Contenido alfanum,rico 1 inf.ad.                                  SAR035
     D                 ds
     D  $caa1                  1     30
     D  $coma                  1      2
     D  $nrma                  3      9  0
     D  $esma                 10     10  0
     D  $ticp                 11     12  0
     D  $sucp                 13     16  0
     D  $facn                 17     24  0
     D  $fafd                 25     26  0
     D  $fafm                 27     28  0
     D  $fafa                 29     30  0

     * Contenido numérico 1 inf.ad.
     D                 ds
     D  $can1                  1     30  0
     D  $piva                  6     10  2
     D  $ivas                 16     30  2

     D                 ds                  inz
     D  $nrrf                  1      9  0
     D  $nrr1                  2      9  0
     D  $artc                  2      3  0
     D  $pacp                  4      9  0

     * Estructura concepto D.                                            SAR035
     D                 ds
     D  $dcopt                 1     25
     D  $dticp                 1      2  0
     D  $d1                    3      3    inz('-')
     D  $dsucp                 4      7  0
     D  $d2                    8      8    inz('-')
     D  $dfacn                 9     16  0
     D  $d3                   17     17    inz('-')
     D  $ddiaf                18     19  0
     D  $d4                   20     20    inz('/')
     D  $dmesf                21     22  0
     D  $d5                   23     23    inz('/')
     D  $daÑof                24     25  0

     * Clave variable TGE p/acceso ctas.                                 SAR035
     D                 ds                  inz
     D  $gecv                  1     12
     D  $rama                  1      2  0
     D  $inga                  3      3

     D                 ds
     D  $$cmga                 1     11
     D  $$cmgn                 1     11  0

     D                 ds
     D  $$rproa                1      2
     D  $$rpron                1      2  0

     D SP0091          pr                  extpgm('SP0091')
     D   peComa                       2    const
     D   peNrma                       6  0 const
     D   pePibr                       1n

     D SP0047          pr                  extpgm('SP0047')
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       6  0 const
     D   peMact                      15  2 const
     D   peImiv                      15  2 const
     D   peFasa                       4  0 const
     D   peFasm                       2  0 const
     D   peFasd                       2  0 const
     D   peRpro                       2  0 const
     D   peRpr1                       2  0 const
     D   peResn                      13    const
     D   peReto                       3
     D   peRe01                     100
     D   peRe02                     100
     D   peRe03                     100
     D   peRe04                     100
     D   peRe05                     100
     D   peRe06                     100
     D   peRe07                     100
     D   peRe08                     100
     D   peRe09                     100
     D   peRe10                     100
     D   peRe11                     100
     D   peRe12                     100
     D   peRe13                     100

     D spopfech        pr                  extpgm('SPOPFECH')
     D   peFech                       8  0 const
     D   peSign                       1a   const
     D   peTipo                       1a   const
     D   peCant                       5  0 const
     D   peFechRes                    8s 0
     D   peErro                       1a
     D   peFfec                       3a   options(*nopass) const


     D CXP668P         pr                  extpgm('CXP668P')
     D                                1    const
     D                                1    const
     D                                2    const
     D                                2  0 const
     D                                6  0 const
     D CXP526P         pr                  extpgm('CXP526P')
     D                                1    const
     D                                1    const
     D                                2    const
     D                                2  0 const
     D                                6  0 const

     D SAR035A1        pr                  extpgm('SAR035A1')
     D                                2  0 const

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPSIN_chkFinSini(): Valida si siniestro terminado           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkFinSini...
     P                 B                   export
     D SVPSIN_chkFinSini...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1y402          ds                  likerec(s1t402:*key)
     D k1yshe          ds                  likerec(p1hshe04:*key)

      /free

       SVPSIN_inz();

       k1yshe.heempr = peEmpr;
       k1yshe.hesucu = peSucu;
       k1yshe.herama = peRama;
       k1yshe.hesini = peSini;
       k1yshe.henops = peNops;
       setll %kds(k1yshe:5) pahshe04;
       reade %kds(k1yshe:5) pahshe04;

       k1y402.t@empr = peEmpr;
       k1y402.t@sucu = peSucu;
       k1y402.t@rama = peRama;
       k1y402.t@cesi = hecesi;
       chain %kds(k1y402) set402;

       if not %found(set402) or t@cese = 'TR';
         SetError( SVPSIN_SINTE
                 : 'Siniestro Terminado' );
         return *On;
       endif;

       if heterm = 'T';
         SetError( SVPSIN_SINTE
                 : 'Siniestro Terminado' );
         return *On;
       endif;

       return *Off;

      /end-free

     P SVPSIN_chkFinSini...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkSini(): Valida si existe siniestro                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkSini...
     P                 B                   export
     D SVPSIN_chkSini...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1yscd          ds                  likerec(p1hscd:*key)

      /free

       SVPSIN_inz();

       k1yscd.cdempr = peEmpr;
       k1yscd.cdsucu = peSucu;
       k1yscd.cdrama = peRama;
       k1yscd.cdsini = peSini;
       k1yscd.cdnops = peNops;
       setll %kds(k1yscd) pahscd;

       if not %equal(pahscd);
         SetError( SVPSIN_SINNE
                 : 'Siniestro Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSIN_chkSini...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkBeneficiario(): Valida si existe beneficiario en el*
      *                           siniestro                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkBeneficiario...
     P                 B                   export
     D SVPSIN_chkBeneficiario...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const

     D @@cant          s              1  0

     D k1ysbe          ds                  likerec(p1hsbe05:*key)

      /free

       SVPSIN_inz();

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       setll %kds(k1ysbe:6) pahsbe05;

       if not %equal(pahsbe05);
         SetError( SVPSIN_BENES
                 : 'Beneficiario no Existe en Siniestro' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSIN_chkBeneficiario...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkBenefVariasCob(): Valida si existe beneficiario    *
      *                             en varias coberturas             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkBenefVariasCob...
     P                 B                   export
     D SVPSIN_chkBenefVariasCob...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const

     D @@cant          s              1  0

     D k1ysbe          ds                  likerec(p1hsbe05:*key)

      /free

       SVPSIN_inz();

       @@cant = *Zeros;

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       setll %kds(k1ysbe:6) pahsbe05;
       reade %kds(k1ysbe:6) pahsbe05;
       dow not %eof and @@cant <= 1;
         @@cant += 1;
         reade %kds(k1ysbe:6) pahsbe05;
       enddo;

       if @@cant > 1;
         SetError( SVPSIN_BEMCO
                 : 'Beneficiario en Varias Coberturas' );
         return *On;
       endif;

       return *Off;

      /end-free

     P SVPSIN_chkBenefVariasCob...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkBenefJuicio(): Valida si beneficiario en juicio    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkBenefJuicio...
     P                 B                   export
     D SVPSIN_chkBenefJuicio...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const

     D k1yjcr          ds                  likerec(p1hjcr:*key)

      /free

       SVPSIN_inz();

       k1yjcr.jcempr = peEmpr;
       k1yjcr.jcsucu = peSucu;
       k1yjcr.jcrama = peRama;
       k1yjcr.jcsini = peSini;
       k1yjcr.jcnops = peNops;
       k1yjcr.jcnrdf = peNrdf;
       setll %kds(k1yjcr:6) pahjcr;

       if %equal(pahjcr);
         SetError( SVPSIN_BEJUI
                 : 'Beneficiario en Juicio' );
         return *On;
       endif;

       return *Off;

      /end-free

     P SVPSIN_chkBenefJuicio...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkReclamo(): Valida reclamo - hecho generador        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peHecg   (input)   Hecho Generador                       *
      *     peRecl   (input)   Numero de Reclamo                     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkReclamo...
     P                 B                   export
     D SVPSIN_chkReclamo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peHecg                       1    const
     D   peRecl                       3s 0 const

     D k1y4021         ds                  likerec(s1t4021:*key)
     D k1ysb1          ds                  likerec(p1hsb102:*key)

      /free

       SVPSIN_inz();

       k1ysb1.b1empr = peEmpr;
       k1ysb1.b1sucu = peSucu;
       k1ysb1.b1rama = peRama;
       k1ysb1.b1sini = peSini;
       k1ysb1.b1nops = peNops;
       k1ysb1.b1nrdf = peNrdf;
       setll %kds(k1ysb1:6) pahsb102;
       reade %kds(k1ysb1:6) pahsb102;

       if not %eof(pahsb102);
         if b1recl = peRecl and b1hecg = peHecg;
           return *On;
         endif;
       endif;

       if b1recl <> peRecl;
         SetError( SVPSIN_RECIN
                 : 'Reclamo Inexistente' );
       else;
         SetError( SVPSIN_HECIN
                 : 'Hecho Generador Inexistente' );
       endif;

       return *Off;

      /end-free

     P SVPSIN_chkReclamo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getSecShr(): Obtiene secuencia                        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     pePoco   (input)   Componente                            *
      *     pePaco   (input)   Parentesco                            *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peSebe   (input)   Secuencia de Beneficiario             *
      *     peRiec   (input)   Riesgo                                *
      *     peCobl   (input)   Cobertura                             *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Secuencia                                           *
      * ------------------------------------------------------------ *

     P SVPSIN_getSecShr...
     P                 B                   export
     D SVPSIN_getSecShr...
     D                 pi             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peCobl                       3  0 const
     D   peFech                       8  0 options(*nopass:*omit)

     D k1yshr          ds                  likerec(p1hshr:*key)

     D @@secu          s              2  0
     D @@a             s              4  0
     D @@m             s              2  0
     D @@d             s              2  0

      /free

       SVPSIN_inz();

       if %parms >= 12 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return -1;
         endif;
         @@a = SPVFEC_ObtAÑoFecha8 ( peFech );
         @@m = SPVFEC_ObtMesFecha8 ( peFech );
         @@d = SPVFEC_ObtDiaFecha8 ( peFech );
       else;
         DBA456R ( @@a : @@m : @@d );
       endif;

       k1yshr.hrempr = peEmpr;
       k1yshr.hrsucu = peSucu;
       k1yshr.hrrama = peRama;
       k1yshr.hrsini = peSini;
       k1yshr.hrnops = peNops;
       k1yshr.hrpoco = pePoco;
       k1yshr.hrpaco = pePaco;
       k1yshr.hrnrdf = peNrdf;
       k1yshr.hrsebe = peSebe;
       k1yshr.hrriec = peRiec;
       k1yshr.hrxcob = peCobl;
       k1yshr.hrfmoa = @@a;
       k1yshr.hrfmom = @@m;
       k1yshr.hrfmod = @@d;
       setll %kds(k1yshr:14) pahshr;
       reade(n) %kds(k1yshr:14) pahshr;

       @@secu = 1;
       dow not %eof(pahshr);
         @@secu += 1;
         reade(n) %kds(k1yshr:14) pahshr;
       enddo;

       return @@secu;

      /end-free

     P SVPSIN_getSecShr...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_setPahshr(): Graba PAHSHR                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peImau   (input)   Importe                               *
      *     peUser   (input)   Usuario                               *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_setPahshr...
     P                 B                   export
     D SVPSIN_setPahshr...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peImau                      15  2 const
     D   peUser                      10    const
     D   peFech                       8  0 options(*nopass:*omit)

     D k1ysbe          ds                  likerec(p1hsbe05:*key)

     D @@fech          s              8  0
     D @@tipo          s              1

      /free

       SVPSIN_inz();

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       chain %kds(k1ysbe:6) pahsbe05;

       if %parms >= 9 and %addr(peFech) <> *Null;
         hrpsec = SVPSIN_getSecShr ( peEmpr : peSucu : peRama : peSini :
                                     peNops : bepoco : bepaco : benrdf :
                                     besebe : beriec : bexcob : peFech );
         if hrpsec = -1;
           return *Off;
         endif;
         hrfmoa = SPVFEC_ObtAÑoFecha8 ( peFech );
         hrfmom = SPVFEC_ObtMesFecha8 ( peFech );
         hrfmod = SPVFEC_ObtDiaFecha8 ( peFech );
       else;
         hrpsec = SVPSIN_getSecShr ( peEmpr : peSucu : peRama : peSini :
                                     peNops : bepoco : bepaco : benrdf :
                                     besebe : beriec : bexcob );
         DBA456R ( hrfmoa : hrfmom : hrfmod );
       endif;

       hrempr = peEmpr;
       hrsucu = pesucu;
       hrrama = perama;
       hrsini = pesini;
       hrnops = penops;
       hrnrdf = penrdf;
       hrimmr = peImau;
       hruser = peUser;

       hrpoco = bepoco;
       hrpaco = bepaco;
       hrsebe = besebe;
       hrriec = beriec;
       hrxcob = bexcob;
       hrcoma = becoma;
       hrnrma = benrma;
       hresma = beesma;
       hrmonr = bemonr;
       hrmar2 = bemar2;
       hrmar3 = bemar3;
       hrmar4 = bemar4;
       hrmar5 = bemar5;

       chain bemonr gntmon;
       if %found(gntmon);
         hrmoeq = momoeq;
       else;
         hrmoeq = *Blanks;
       endif;

       if momoeq <> 'AU';
         @@fech = (*day*1000000)+(*month*10000)+*year;
         @@tipo = 'V';
         SP0052 ( bemonr : @@fech : hrimco : @@tipo );
         if hrimco = *zeros;
           hrimco = 1;
         endif;
       else;
         hrimco = 1;
       endif;
       hrimau = hrimmr * hrimco;

       hrnupe = *Zeros;
       hrnroc = *Zeros;
       hrimnr = *Zeros;
       hrimna = *Zeros;
       hrmar1 = *Off;
       hrtime = %dec(%time():*iso);
       hrfera = *year;
       hrferm = *month;
       hrferd = *day;
       hrtifa = *Zeros;
       hrnrsf = *Zeros;
       hrnrfa = *Zeros;

       write p1hshr;

       return *On;

      /end-free

     P SVPSIN_setPahshr...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getSecSfr(): Obtiene secuencia                        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     pePoco   (input)   Componente                            *
      *     pePaco   (input)   Parentesco                            *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peSebe   (input)   Secuencia de Beneficiario             *
      *     peRiec   (input)   Riesgo                                *
      *     peCobl   (input)   Cobertura                             *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Secuencia                                           *
      * ------------------------------------------------------------ *

     P SVPSIN_getSecSfr...
     P                 B                   export
     D SVPSIN_getSecSfr...
     D                 pi             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peCobl                       3  0 const
     D   peFech                       8  0 options(*nopass:*omit)

     D k1ysfr          ds                  likerec(p1hsfr:*key)

     D @@secu          s              2  0
     D @@a             s              4  0
     D @@m             s              2  0
     D @@d             s              2  0

      /free

       SVPSIN_inz();

       @@secu = *zeros;

       if %parms >= 12 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return -1;
         endif;
         @@a = SPVFEC_ObtAÑoFecha8 ( peFech );
         @@m = SPVFEC_ObtMesFecha8 ( peFech );
         @@d = SPVFEC_ObtDiaFecha8 ( peFech );
       else;
         DBA456R ( @@a : @@m : @@d );
       endif;

       k1ysfr.frempr = peEmpr;
       k1ysfr.frsucu = peSucu;
       k1ysfr.frrama = peRama;
       k1ysfr.frsini = peSini;
       k1ysfr.frnops = peNops;
       k1ysfr.frpoco = pePoco;
       k1ysfr.frpaco = pePaco;
       k1ysfr.frnrdf = peNrdf;
       k1ysfr.frsebe = peSebe;
       k1ysfr.frriec = peRiec;
       k1ysfr.frxcob = peCobl;
       k1ysfr.frfmoa = @@a;
       k1ysfr.frfmom = @@m;
       k1ysfr.frfmod = @@d;
       setgt %kds(k1ysfr:14) pahsfr;
       readpe(n) %kds(k1ysfr:14) pahsfr;
       if %found(pahsfr);
         @@secu = frpsec;
       endif;
         @@secu += 1;

       return @@secu;

      /end-free

     P SVPSIN_getSecSfr...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_setPahsfr(): Graba PAHSFR                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peImau   (input)   Importe                               *
      *     peUser   (input)   Usuario                               *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_setPahsfr...
     P                 B                   export
     D SVPSIN_setPahsfr...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peImau                      15  2 const
     D   peUser                      10    const
     D   peFech                       8  0 options(*nopass:*omit)

     D k1ysbe          ds                  likerec(p1hsbe05:*key)

     D @@fech          s              8  0
     D @@tipo          s              1

      /free

       SVPSIN_inz();

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       chain %kds(k1ysbe:6) pahsbe05;

       if %parms >= 9 and %addr(peFech) <> *Null;
         frpsec = SVPSIN_getSecSfr ( peEmpr : peSucu : peRama : peSini :
                                     peNops : bepoco : bepaco : benrdf :
                                     besebe : beriec : bexcob : peFech );
         if frpsec = -1;
           return *Off;
         endif;
         hrfmoa = SPVFEC_ObtAÑoFecha8 ( peFech );
         hrfmom = SPVFEC_ObtMesFecha8 ( peFech );
         hrfmod = SPVFEC_ObtDiaFecha8 ( peFech );
       else;
         frpsec = SVPSIN_getSecSfr ( peEmpr : peSucu : peRama : peSini :
                                     peNops : bepoco : bepaco : benrdf :
                                     besebe : beriec : bexcob );
         DBA456R ( hrfmoa : hrfmom : hrfmod );
       endif;

       frempr = peEmpr;
       frsucu = pesucu;
       frrama = perama;
       frsini = pesini;
       frnops = penops;
       frnrdf = penrdf;
       frimmr = peImau;
       fruser = peUser;

       frpoco = bepoco;
       frpaco = bepaco;
       frsebe = besebe;
       frriec = beriec;
       frxcob = bexcob;
       frcoma = becoma;
       frnrma = benrma;
       fresma = beesma;
       frmonr = bemonr;
       frmar2 = bemar2;

       chain bemonr gntmon;
       if %found(gntmon);
         frmoeq = momoeq;
       else;
         frmoeq = *Blanks;
       endif;

       if momoeq <> 'AU';
         @@fech = (*day*1000000)+(*month*10000)+*year;
         @@tipo = 'V';
         SP0052 ( bemonr : @@fech : frimco : @@tipo );
         if frimco = *zeros;
           frimco = 1;
         endif;
       else;
         frimco = 1;
       endif;
       frimau = frimmr * frimco;

       frnupe = *Zeros;
       frnroc = *Zeros;
       frimnr = *Zeros;
       frimna = *Zeros;
       frmar1 = *Off;
       frmar3 = *Off;
       frmar4 = *Off;
       frmar5 = *Off;
       frtime = %dec(%time():*iso);
       frfera = *year;
       frferm = *month;
       frferd = *day;

       write p1hsfr;

       return *On;

      /end-free

     P SVPSIN_setPahsfr...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_updCtaCte(): Actualiza cuenta corriente               *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_updCtaCte...
     P                 B                   export
     D SVPSIN_updCtaCte...
     D                 pi              n
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D @@rama          s              2  0
     D @@sini          s              7  0
     D @@nops          s              7  0

      /free

       SVPSIN_inz();

       @@rama = peRama;
       @@sini = peSini;
       @@nops = peNops;

       SAR902 ( @@rama
              : @@sini
              : @@nops ) ;

       return *On;

      /end-free

     P SVPSIN_updCtaCte...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getRva(): Retorna Rva Sola                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *     peRiec   ( input  ) Código de Riesgo        ( opcional ) *
      *     peXcob   ( input  ) Código de Cobertura     ( opcional ) *
      *                                                              *
      * Retorna: Rva                                                 *
      * ------------------------------------------------------------ *

     P SVPSIN_getRva...
     P                 B                   export
     D SVPSIN_getRva...
     D                 pi            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const

     D k1ysbe          ds                  likerec(p1hsbe05:*key)
     D k1yshr          ds                  likerec(p1hshr:*key)
     D k1yshr03        ds                  likerec(p1hshr03:*key)

     D  @@fech         s              8  0
     D  @@mact         s             25  2
     D  @CantK         s             10i 0

      /free

       SVPSIN_inz();

       if %parms >= 7 and %addr(peFech) <> *Null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ('AMD');
       endif;

       @@mact = *Zeros;

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       chain %kds(k1ysbe:6) Pahsbe05;

       if %parms >= 8 and %addr(peRiec) <> *Null and %addr(peXcob) <> *Null;
          k1yshr03.hrempr = beempr;
          k1yshr03.hrsucu = besucu;
          k1yshr03.hrrama = berama;
          k1yshr03.hrsini = besini;
          k1yshr03.hrnops = benops;
          k1yshr03.hrpoco = bepoco;
          k1yshr03.hrpaco = bepaco;
          k1yshr03.hrRiec = peRiec;
          k1yshr03.hrXcob = peXcob;
          k1yshr03.hrnrdf = benrdf;
          @CantK = 10;

          setll %kds(k1yshr03: @CantK ) pahshr03;
          reade %kds(k1yshr03: @CantK ) pahshr03;
          dow not %eof and
              SPVFEC_ArmarFecha8 (hrfmoa : hrfmom : hrfmod: 'AMD' ) <= @@fech;
            @@mact += hrimau;
          reade %kds(k1yshr03: @CantK ) pahshr03;
          enddo;
       else;
          k1yshr.hrempr = beempr;
          k1yshr.hrsucu = besucu;
          k1yshr.hrrama = berama;
          k1yshr.hrsini = besini;
          k1yshr.hrnops = benops;
          k1yshr.hrpoco = bepoco;
          k1yshr.hrpaco = bepaco;
          k1yshr.hrnrdf = benrdf;
          @CantK = 8;

          setll %kds(k1yshr: @CantK ) pahshr;
          reade %kds(k1yshr: @CantK ) pahshr;
          dow not %eof and
              SPVFEC_ArmarFecha8 (hrfmoa : hrfmom : hrfmod: 'AMD' ) <= @@fech;
            @@mact += hrimau;
          reade %kds(k1yshr: @CantK ) pahshr;
          enddo;
       endif;

       return @@mact;

      /end-free

     P SVPSIN_getRva...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getFra(): Franquicia Sola                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *     peRiec   ( input  ) Código de Riesgo        ( opcional ) *
      *     peXcob   ( input  ) Código de Cobertura     ( opcional ) *
      *                                                              *
      * Retorna: Franquicia                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_getFra...
     P                 B                   export
     D SVPSIN_getFra...
     D                 pi            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const

     D k1ysbe          ds                  likerec(p1hsbe05:*key)
     D k1ysfr          ds                  likerec(p1hsfr:*key)
     D k1ysfr02        ds                  likerec(p1hsfr02:*key)

     D  @@fech         s              8  0
     D  @@mact         s             25  2
     D  @CantK         s             10i 0

      /free

       SVPSIN_inz();

       if %parms >= 7 and %addr(peFech) <> *Null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ('AMD');
       endif;

       @@mact = *Zeros;

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       chain %kds(k1ysbe:6) pahsbe05;

       if %parms >= 8 and %addr(peRiec) <> *Null and %addr(peXcob) <> *Null;
          k1ysfr02.frEmpr = beempr;
          k1ysfr02.frSucu = besucu;
          k1ysfr02.frRama = berama;
          k1ysfr02.frSini = besini;
          k1ysfr02.frNops = benops;
          k1ysfr02.frNrdf = beNrdf;
          k1ysfr02.frRiec = peRiec;
          k1ysfr02.frXcob = peXcob;
          @CantK = 8;
          setll %kds(k1ysfr02: @CantK ) pahsfr02;
          reade %kds(k1ysfr02: @CantK ) pahsfr02;
          dow not %eof and
              SPVFEC_ArmarFecha8 (frfmoa : frfmom : frfmod: 'AMD' ) <= @@fech;
            @@mact += frimau;
          reade %kds(k1ysfr02: @CantK ) pahsfr02;
          enddo;
       else;
          k1ysfr.frempr = beempr;
          k1ysfr.frsucu = besucu;
          k1ysfr.frrama = berama;
          k1ysfr.frsini = besini;
          k1ysfr.frnops = benops;
          k1ysfr.frpoco = bepoco;
          k1ysfr.frpaco = bepaco;
          k1ysfr.frnrdf = benrdf;

          @CantK = 8;
          setll %kds(k1ysfr: @CantK ) pahsfr;
          reade %kds(k1ysfr: @CantK ) pahsfr;
          dow not %eof and
              SPVFEC_ArmarFecha8 (frfmoa : frfmom : frfmod: 'AMD' ) <= @@fech;
            @@mact += frimau;
          reade %kds(k1ysfr: @CantK ) pahsfr;
          enddo;
       endif;


       return @@mact;

      /end-free

     P SVPSIN_getFra...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getPag(): Retorna Pagos solos                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *     peRiec   ( input  ) Código de Riesgo        ( opcional ) *
      *     peXcob   ( input  ) Código de Cobertura     ( opcional ) *
      *                                                              *
      * Retorna: Pagos                                               *
      * ------------------------------------------------------------ *

     P SVPSIN_getPag...
     P                 B                   export
     D SVPSIN_getPag...
     D                 pi            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const

     D k1ysbe          ds                  likerec(p1hsbe05:*key)
     D k1yshp          ds                  likerec(p1hshp:*key)
     D k1yshp03        ds                  likerec(p1hshp03:*key)

     D  @@fech         s              8  0
     D  @@mact         s             25  2
     D  @CantK         s             10i 0

      /free

       SVPSIN_inz();

       if %parms >= 7 and %addr(peFech) <> *Null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ('AMD');
       endif;

       @@mact = *Zeros;

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       chain(n) %kds(k1ysbe:6) pahsbe05;

       if %parms >= 8 and %addr(peRiec) <> *Null and %addr(peXcob) <> *Null;
          k1yshp03.hpempr = beempr;
          k1yshp03.hpsucu = besucu;
          k1yshp03.hprama = berama;
          k1yshp03.hpsini = besini;
          k1yshp03.hpnops = benops;
          k1yshp03.hppoco = bepoco;
          k1yshp03.hppaco = bepaco;
          k1yshp03.hpnrdf = benrdf;
          k1yshp03.hpRiec = peRiec;
          k1yshp03.hpXcob = peXcob;

          @CantK = 10;
          setll %kds(k1yshp03: @CantK ) pahshp03;
          reade %kds(k1yshp03: @CantK ) pahshp03;
          dow not %eof and
              SPVFEC_ArmarFecha8 (hpfmoa : hpfmom : hpfmod: 'AMD' ) <= @@fech;
            @@mact += hpimau;
          reade %kds(k1yshp03: @CantK ) pahshp03;
          enddo;

       else;
          k1yshp.hpempr = beempr;
          k1yshp.hpsucu = besucu;
          k1yshp.hprama = berama;
          k1yshp.hpsini = besini;
          k1yshp.hpnops = benops;
          k1yshp.hppoco = bepoco;
          k1yshp.hppaco = bepaco;
          k1yshp.hpnrdf = benrdf;

          @CantK = 8;
          setll %kds(k1yshp: @CantK ) pahshp;
          reade %kds(k1yshp: @CantK ) pahshp;
          dow not %eof and
              SPVFEC_ArmarFecha8 (hpfmoa : hpfmom : hpfmod: 'AMD' ) <= @@fech;
            @@mact += hpimau;
          reade %kds(k1yshp: @CantK ) pahshp;
          enddo;
       endif;


       return @@mact;

      /end-free

     P SVPSIN_getPag...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getRvaAct(): Retorna Rva Actual                       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *     peRiec   ( input  ) Código de Riesgo        ( opcional ) *
      *     peXcob   ( input  ) Código de Cobertura     ( opcional ) *
      *                                                              *
      * Retorna: Importe de Rva Actual                               *
      * ------------------------------------------------------------ *

     P SVPSIN_getRvaAct...
     P                 B                   export
     D SVPSIN_getRvaAct...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const

     D  @@fech         s              8  0
     D  @@rva          s             15  2
     D  @@fra          s             15  2
     D  @@pag          s             15  2

      /free

       SVPSIN_inz();

       if %parms >= 7 and %addr(peFech) <> *Null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ('AMD');
       endif;

       if %parms >= 8 and %addr(peRiec) <> *Null and %addr(peXcob) <> *Null;
          @@RVA =  SVPSIN_getRva (peEmpr
                                 :peSucu
                                 :peRama
                                 :peSini
                                 :peNops
                                 :peNrdf
                                 :@@fech
                                 :peRiec
                                 :peXcob);

          @@FRA =  SVPSIN_getFra (peEmpr
                                 :peSucu
                                 :peRama
                                 :peSini
                                 :peNops
                                 :peNrdf
                                 :@@fech
                                 :peRiec
                                 :peXcob);

          @@PAG =  SVPSIN_getPag (peEmpr
                                 :peSucu
                                 :peRama
                                 :peSini
                                 :peNops
                                 :peNrdf
                                 :@@fech
                                 :peRiec
                                 :peXcob);
       else;
          @@RVA =  SVPSIN_getRva (peEmpr
                                 :peSucu
                                 :peRama
                                 :peSini
                                 :peNops
                                 :peNrdf
                                 :@@fech);

          @@FRA =  SVPSIN_getFra (peEmpr
                                 :peSucu
                                 :peRama
                                 :peSini
                                 :peNops
                                 :peNrdf
                                 :@@fech);

          @@PAG =  SVPSIN_getPag (peEmpr
                                 :peSucu
                                 :peRama
                                 :peSini
                                 :peNops
                                 :peNrdf
                                 :@@fech);
       endif;

       @@RVA = @@RVA - @@FRA - @@PAG;

       return @@RVA;

      /end-free

     P SVPSIN_getRvaAct...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getCantSin(): Retorna cantidad de sinistros           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Pagos                                               *
      * ------------------------------------------------------------ *

     P SVPSIN_getCantSin...
     P                 B                   export
     D SVPSIN_getCantSin...
     D                 pi             9  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D k1yscd          ds                  likerec(p1hscd03:*key)

     D  @@fech         s              8  0
     D  @@cant         s              9  0

      /free

       SVPSIN_inz();

       @@cant = *Zeros;

       if %parms >= 7 and %addr(peFech) <> *Null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ('AMD');
       endif;

       k1yscd.cdempr = peEmpr;
       k1yscd.cdsucu = pesucu;
       k1yscd.cdrama = perama;
       k1yscd.cdpoli = pepoli;
       setll %kds(k1yscd:4) pahscd03;
       reade %kds(k1yscd:4) pahscd03;
       dow not %eof and
           SPVFEC_ArmarFecha8 (cdfsia : cdfsim : cdfsid: 'AMD' ) <= @@fech;
         if cdsini <> 0;
           @@cant += 1;
         endif;
         reade %kds(k1yscd:4) pahscd03;
       enddo;

       return @@cant;

      /end-free

     P SVPSIN_getCantSin...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPSIN_inz      B                   export
     D SVPSIN_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(pahscd);
         open pahscd;
       endif;

       if not %open(pahjhp);
         open pahjhp;
       endif;

       if not %open(pahjcr);
         open pahjcr;
       endif;

       if not %open(pahjc1);
         open pahjc1;
       endif;

       if not %open(set402);
         open set402;
       endif;

       if not %open(set4021);
         open set4021;
       endif;

       if not %open(pahsb1);
         open pahsb1;
       endif;

       if not %open(pahsb102);
         open pahsb102;
       endif;

       if not %open(pahsfr01);
         open pahsfr01;
       endif;

       if not %open(pahshe04);
         open pahshe04;
       endif;

       if not %open(pahsbe05);
         open pahsbe05;
       endif;

       if not %open(pahshr);
         open pahshr;
       endif;

       if not %open(pahsfr);
         open pahsfr;
       endif;

       if not %open(gntmon);
         open gntmon;
       endif;

       if not %open(pahshp);
         open pahshp;
       endif;

       if not %open(pahscd03);
         open pahscd03;
       endif;

       if not %open(pahet0);
         open pahet0;
       endif;

       if not %open(paher0);
         open paher0;
       endif;

       if not %open(pahev1);
         open pahev1;
       endif;

       if not %open(pahscd11);
         open pahscd11;
       endif;

       if not %open(pahshp04);
         open pahshp04;
       endif;

       if not %open(set001);
         open set001;
       endif;

       if not %open(pahshp01);
         open pahshp01;
       endif;

       if not %open(set475);
         open set475;
       endif;

       if not %open(pahsva06);
         open pahsva06;
       endif;

       if not %open(pds00007);
         open pds00007;
       endif;

       if not %open(pds000);
         open pds000;
       endif;

       if not %open(pahsva);
         open pahsva;
       endif;

       if not %open(pahsbe);
         open pahsbe;
       endif;

       if not %open(pahsb2);
         open pahsb2;
       endif;

       if not %open(pahsb4);
         open pahsb4;
       endif;

       if not %open(pahshe01);
         open pahshe01;
       endif;

       if not %open(set456);
         open set456;
       endif;

       if not %open(pahshe);
         open pahshe;
       endif;

       if not %open(pahsc1);
         open pahsc1;
       endif;

       if not %open(pahsd1);
         open pahsd1;
       endif;

       if not %open(pahsd2);
         open pahsd2;
       endif;

       if not %open(pahstc);
         open pahstc;
       endif;

       if not %open(pahsd0);
         open pahsd0;
       endif;
      * Abre LF Siniestros x Articulos Carátula de denuncias
       if not %open(pahscd01);
         open pahscd01;
       endif;

       if not %open(set412);
         open set412;
       endif;

       if not %open(set406);
         open set406;
       endif;

       if not %open(set407);
         open set407;
       endif;


       if not %open(pahscc);
         open pahscc;
       endif;

       if not %open(cnhop2);
         open cnhop2;
       endif;

       if not %open(cnhop3);
         open cnhop3;
       endif;

       if not %open(cnhpib);
         open cnhpib;
       endif;

       if not %open(cnhret);
         open cnhret;
       endif;

       if not %open(pahshr05);
         open pahshr05;
       endif;

       if not %open(cnhopa);
         open cnhopa;
       endif;

       if not %open(pahshp12);
         open pahshp12;
       endif;

       if not %open(cnwnin);
         open cnwnin;
       endif;


       if not %open(set400);
         open set400;
       endif;

       if not %open(cntopa);
         open cntopa;
       endif;

       if not %open(gnttge);
         open gnttge;
       endif;

       if not %open(cntnau01);
         open cntnau01;
       endif;

       if not %open(gntloc02);
         open gntloc02;
       endif;

       if not %open(cnhop1);
         open cnhop1;
       endif;

       if not %open(cnwopa);
         open cnwopa;
       endif;

       if not %open(cnhmop);
         open cnhmop;
       endif;

       if not %open(gti981s);
         open gti981s;
       endif;

       if not %open(cnhret01);
         open cnhret01;
       endif;

       if not %open(gntdim);
         open gntdim;
       endif;

       if not %open(gti960);
         open gti960;
       endif;

       if not %open(gti965);
         open gti965;
       endif;

       if not %open(pahscd98);
         open pahscd98;
       endif;

       if not %open(pahshr03);
         open pahshr03;
       endif;

       if not %open(pahsfr02);
         open pahsfr02;
       endif;

       if not %open(pahshp03);
         open pahshp03;
       endif;

       if not %open(pahsbs08);
         open pahsbs08;
       endif;

       if not %open(pahsb5);
         open pahsb5;
       endif;

       if not %open(set47601);
         open set47601;
       endif;

       if not %open(pahscd13);
         open pahscd13;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPSIN_inz      E

      * ------------------------------------------------------------ *
      * SVPSIN_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPSIN_End      B                   export
     D SVPSIN_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPSIN_End      E

      * ------------------------------------------------------------ *
      * SVPSIN_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPSIN_Error    B                   export
     D SVPSIN_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPSIN_Error    E

      * ------------------------------------------------------------ *
      * SetError(): Setea último error y mensaje.                    *
      *                                                              *
      *     peErrn   (input)   Número de error a setear.             *
      *     peErrm   (input)   Texto del mensaje.                    *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SetError        B
     D SetError        pi
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

      /free

       ErrN = peErrn;
       ErrM = peErrm;

      /end-free

     P SetError...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getSumAsComp(): Retorna Suma Asegurada de Componente  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     pePoco   (input)   Componente                            *
      *     pePaco   (input)   Parentesco                            *
      *                                                              *
      * Retorna: Suma Asegurada de Componente / -1 Error             *
      * ------------------------------------------------------------ *

     P SVPSIN_getSumAsComp...
     P                 B                   export
     D SVPSIN_getSumAsComp...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 options(*Nopass:*Omit)

     D k1yscd          ds                  likerec(p1hscd:*key)
     D k1yet0          ds                  likerec(p1het0:*key)
     D k1yer0          ds                  likerec(p1her0:*key)
     D k1yev1          ds                  likerec(p1hev1:*key)

      /free

       SVPSIN_inz();

       k1yscd.cdempr = peEmpr;
       k1yscd.cdsucu = peSucu;
       k1yscd.cdrama = peRama;
       k1yscd.cdsini = peSini;
       k1yscd.cdnops = peNops;
       chain %kds ( k1yscd ) pahscd;

       if not %found ( pahscd );
         SetError( SVPSIN_SINNE
                 : 'Siniestro Inexistente' );
         return -1;
       endif;

       if pePoco < 9999;
         k1yet0.t0empr = cdempr;
         k1yet0.t0sucu = cdsucu;
         k1yet0.t0arcd = cdarcd;
         k1yet0.t0spol = cdspol;
         k1yet0.t0sspo = cdsspo;
         k1yet0.t0rama = cdrama;
         k1yet0.t0arse = cdarse;
         k1yet0.t0oper = cdoper;
         k1yet0.t0poco = pePoco;
         setll %kds ( k1yet0 : 9 ) pahet0;
         if %equal ( pahet0 );
           reade %kds ( k1yet0 : 9 ) pahet0;
           return t0vhvu;
         endif;

         k1yer0.r0empr = cdempr;
         k1yer0.r0sucu = cdsucu;
         k1yer0.r0arcd = cdarcd;
         k1yer0.r0spol = cdspol;
         k1yer0.r0sspo = cdsspo;
         k1yer0.r0rama = cdrama;
         k1yer0.r0arse = cdarse;
         k1yer0.r0oper = cdoper;
         k1yer0.r0poco = pePoco;
         setll %kds ( k1yer0 : 9 ) paher0;
         if %equal ( paher0 );
           reade %kds ( k1yer0 : 9 ) paher0;
           return r0sacm;
         endif;

       else;

         if not ( %parms >= 7 and %addr ( pePaco ) <> *Null );
           SetError( SVPSIN_PAREN
                   : 'Debe Informarse Parentesco' );
           return -1;
         endif;
         k1yev1.v1empr = cdempr;
         k1yev1.v1sucu = cdsucu;
         k1yev1.v1arcd = cdarcd;
         k1yev1.v1spol = cdspol;
         k1yev1.v1sspo = cdsspo;
         k1yev1.v1rama = cdrama;
         k1yev1.v1arse = cdarse;
         k1yev1.v1oper = cdoper;
         k1yev1.v1poco = pePoco;
         k1yev1.v1paco = pePaco;
         setll %kds ( k1yev1 : 10) pahev1;
         if %equal ( pahev1 );
           reade %kds ( k1yev1 : 10) pahev1;
           return v1sacm;
         endif;

       endif;

       return -1;

      /end-free

     P SVPSIN_getSumAsComp...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getIndem(): Retorna Pagos de tipo Indemnizacion       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Indemnizaciones                                     *
      * ------------------------------------------------------------ *

     P SVPSIN_getIndem...
     P                 B                   export
     D SVPSIN_getIndem...
     D                 pi            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D k1ysbe          ds                  likerec(p1hsbe05:*key)
     D k1yshp          ds                  likerec(p1hshp:*key)

     D  @@fech         s              8  0
     D  @@mact         s             25  2

      /free

       SVPSIN_inz();

       if %parms >= 7 and %addr(peFech) <> *Null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ('AMD');
       endif;

       @@mact = *Zeros;

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       chain %kds(k1ysbe:6) pahsbe05;

       k1yshp.hpempr = beempr;
       k1yshp.hpsucu = besucu;
       k1yshp.hprama = berama;
       k1yshp.hpsini = besini;
       k1yshp.hpnops = benops;
       k1yshp.hppoco = bepoco;
       k1yshp.hppaco = bepaco;
       k1yshp.hpnrdf = benrdf;

       setll %kds(k1yshp:8) pahshp;
       reade %kds(k1yshp:8) pahshp;
       dow not %eof and
           SPVFEC_ArmarFecha8 (hpfmoa : hpfmom : hpfmod: 'AMD' ) <= @@fech;
         if hpmar1 = 'I';
           @@mact += hpimau;
         endif;
         reade %kds(k1yshp:8) pahshp;
       enddo;

       return @@mact;

      /end-free

     P SVPSIN_getIndem...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getEstSin(): Retorna Estado del Siniestro             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Estado del Siniestro                                *
      * ------------------------------------------------------------ *

     P SVPSIN_getEstSin...
     P                 B                   export
     D SVPSIN_getEstSin...
     D                 pi             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D k1yshe          ds                  likerec(p1hshe04:*key)

      /free

       SVPSIN_inz();

       k1yshe.heempr = peEmpr;
       k1yshe.hesucu = peSucu;
       k1yshe.herama = peRama;
       k1yshe.hesini = peSini;
       k1yshe.henops = peNops;

       if ( ( %parms >= 6 ) and ( %addr( peFech ) <> *Null ) );
         k1yshe.hefema = SPVFEC_ObtAÑoFecha8 ( peFech );
         k1yshe.hefemm = SPVFEC_ObtMesFecha8 ( peFech );
         k1yshe.hefemd = SPVFEC_ObtDiaFecha8 ( peFech );
         setll %kds( k1yshe : 8 ) pahshe04;
       else;
         setll %kds( k1yshe : 5 ) pahshe04;
       endif;

       reade %kds( k1yshe : 5 ) pahshe04;

       if %eof ( pahshe04 );
         return *Zeros;
       endif;

       return hecesi;

      /end-free

     P SVPSIN_getEstSin...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getEstRec(): Retorna Estado del Reclamo               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     pePoco   (input)   Componenete                           *
      *     pePaco   (input)   Parentesco                            *
      *     peRiec   (input)   Riesgo                                *
      *     peXcob   (input)   Cobertura                             *
      *     peNrdf   (input)   Numero de Beneficiario                *
      *     peSebe   (input)   Secuencia de Beneficiario             *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Estado del Reclamo                                  *
      * ------------------------------------------------------------ *

     P SVPSIN_getEstRec...
     P                 B                   export
     D SVPSIN_getEstRec...
     D                 pi             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peSebe                       6  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D k1ysb1          ds                  likerec(p1hsb1:*key)

      /free

       SVPSIN_inz();

       k1ysb1.b1empr = peEmpr;
       k1ysb1.b1sucu = peSucu;
       k1ysb1.b1rama = peRama;
       k1ysb1.b1sini = peSini;
       k1ysb1.b1nops = peNops;
       k1ysb1.b1poco = pePoco;
       k1ysb1.b1paco = pePaco;
       k1ysb1.b1riec = peRiec;
       k1ysb1.b1xcob = peXcob;
       k1ysb1.b1nrdf = peNrdf;
       k1ysb1.b1sebe = peSebe;

       if ( ( %parms >= 12 ) and ( %addr( peFech ) <> *Null ) );
         k1ysb1.b1fema = SPVFEC_ObtAÑoFecha8 ( peFech );
         k1ysb1.b1femm = SPVFEC_ObtMesFecha8 ( peFech );
         k1ysb1.b1femd = SPVFEC_ObtDiaFecha8 ( peFech );
         setll %kds( k1ysb1 : 14 ) pahsb1;
       else;
         setll %kds( k1ysb1 : 11 ) pahsb1;
       endif;

       reade %kds( k1ysb1 : 11 ) pahsb1;

       if %eof( pahsb1 );
         return *Zeros;
       endif;

       return b1cesi;

      /end-free

     P SVPSIN_getEstRec...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getEstJui(): Retorna Estado del Juicio                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Numero de Beneficiario                *
      *     peSebe   (input)   Secuencia de Beneficiario             *
      *     peNrcj   (input)   Carpeta de Juicio                     *
      *     peJuin   (input)   Numero de Juicio                      *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Estado del Juicio                                   *
      * ------------------------------------------------------------ *

     P SVPSIN_getEstJui...
     P                 B                   export
     D SVPSIN_getEstJui...
     D                 pi             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peNrcj                       6  0 const
     D   peJuin                       6  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D k1yjc1          ds                  likerec(p1hjc1:*key)

      /free

       SVPSIN_inz();

       k1yjc1.j1empr = peEmpr;
       k1yjc1.j1sucu = peSucu;
       k1yjc1.j1rama = peRama;
       k1yjc1.j1sini = peSini;
       k1yjc1.j1nops = peNops;
       k1yjc1.j1nrdf = peNrdf;
       k1yjc1.j1sebe = peSebe;
       k1yjc1.j1nrcj = peNrcj;
       k1yjc1.j1juin = peJuin;

       if ( ( %parms >= 10 ) and ( %addr( peFech ) <> *Null ) );
         k1yjc1.j1fema = SPVFEC_ObtAÑoFecha8 ( peFech );
         k1yjc1.j1femm = SPVFEC_ObtMesFecha8 ( peFech );
         k1yjc1.j1femd = SPVFEC_ObtDiaFecha8 ( peFech );
         setll %kds( k1yjc1 : 12 ) pahjc1;
       else;
         setll %kds( k1yjc1 : 9 ) pahjc1;
       endif;

       reade %kds( k1yjc1 : 9 ) pahjc1;

       if %eof( pahjc1 );
         return *Zeros;
       endif;

       return j1cesi;

      /end-free

     P SVPSIN_getEstJui...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkSiniPend(): Retorna si siniestro esta pendiente    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkSiniPend...
     P                 B                   export
     D SVPSIN_chkSiniPend...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1y402          ds                  likerec(s1t402:*key)

      /free

       SVPSIN_inz();

       k1y402.t@empr = peEmpr;
       k1y402.t@sucu = peSucu;
       k1y402.t@rama = peRama;
       k1y402.t@cesi = SVPSIN_getEstSin ( peEmpr : peSucu :
                                          peRama : peSini : peNops );

       chain %kds ( k1y402 ) set402;

       if t@cese = 'TR' or t@cese = 'RC';
         setError(SVPSIN_NOTER:'El Siniestro ya esta terminado');
         return *Off;
       else;
         return *On;
       endif;

      /end-free

     P SVPSIN_chkSiniPend...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkSiniPag(): Retorna si siniestro tiene un pagos e/  *
      *                      determiandas fechas                     *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFdes   (input)   Fecha Desde                           *
      *     peFhas   (input)   Fecha Hasta                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkSiniPag...
     P                 B                   export
     D SVPSIN_chkSiniPag...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0 options (*Omit:*Nopass)

     D @@fdes          s              8  0
     D @@fhas          s              8  0

     D k1yh04          ds                  likerec(p1hshp04:*key)

      /free

       SVPSIN_inz();

       if %parms >= 7 and %addr ( peFhas ) <> *Null;
         @@fhas = peFhas;
       else;
         @@fhas = SPVFEC_FecDeHoy8 ( 'AMD' );
       endif;

       @@fdes = peFdes;

       k1yh04.hpempr = peEmpr;
       k1yh04.hpsucu = peSucu;
       k1yh04.hprama = peRama;
       k1yh04.hpsini = peSini;
       k1yh04.hpnops = peNops;
       k1yh04.hpfmoa = SPVFEC_ObtAÑoFecha8 ( @@fdes );
       k1yh04.hpfmom = SPVFEC_ObtMesFecha8 ( @@fdes );
       k1yh04.hpfmod = SPVFEC_ObtDiaFecha8 ( @@fdes );

       setll %kds( k1yh04 : 8 ) p1hshp04;
       reade %kds( k1yh04 : 5 ) p1hshp04;

       select;
         when %eof ( pahshp04 );
           return *Off;
         when SPVFEC_ArmarFecha8 ( hpfmoa : hpfmom : hpfmod : 'AMD' )
                                 <= @@fhas;
           return *On;
         other;
           return *Off;
       endsl;

      /end-free

     P SVPSIN_chkSiniPag...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkSiniDen(): Retorna si siniestro tiene denuncia e/  *
      *                      determinadas fechas                     *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Super Póliza                          *
      *     peFdes   (input)   Fecha Desde                           *
      *     peFhas   (input)   Fecha Hasta                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkSiniDen...
     P                 B                   export
     D SVPSIN_chkSiniDen...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0 options (*Omit:*Nopass)

     D @@fdes          s              8  0
     D @@fhas          s              8  0

     D k1yd11          ds                  likerec(p1hscd11:*key)

      /free

       SVPSIN_inz();

       if %parms >= 6 and %addr ( peFhas ) <> *Null;
         @@fhas = peFhas;
       else;
         @@fhas = SPVFEC_FecDeHoy8 ( 'AMD' );
       endif;

       @@fdes = peFdes;

       k1yd11.cdempr = peEmpr;
       k1yd11.cdsucu = peSucu;
       k1yd11.cdarcd = peArcd;
       k1yd11.cdspol = peSpol;

       setll %kds( k1yd11 : 4 ) p1hscd11;
       reade %kds( k1yd11 : 4 ) p1hscd11;

       dow not %eof ( pahscd11 );
         if SPVFEC_ArmarFecha8 (cdfdea : cdfdem : cdfded: 'AMD' ) >= @@fdes
         and SPVFEC_ArmarFecha8 (cdfdea : cdfdem : cdfded: 'AMD' ) <= @@fhas;
           return *On;
         endif;
         reade %kds( k1yd11 : 4 ) p1hscd11;
       enddo;

       return *Off;

      /end-free

     P SVPSIN_chkSiniDen...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getSini(): Retorna si tiene siniestros                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Super Póliza                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_getSini...
     P                 B                   export
     D SVPSIN_getSini...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1yd11          ds                  likerec(p1hscd11:*key)

      /free

       SVPSIN_inz();

       k1yd11.cdempr = peEmpr;
       k1yd11.cdsucu = peSucu;
       k1yd11.cdarcd = peArcd;
       k1yd11.cdspol = peSpol;

       setll %kds( k1yd11 : 4 ) p1hscd11;

       if %equal;
         SetError( SVPSIN_GETSI
                 : 'Poliza con Siniestros' );
         return *On;
       endif;

       return *Off;

      /end-free

     P SVPSIN_getSini...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkWeb(): Devuelve si viaja a Web                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Nro de Operacion                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkWeb...
     P                 B                   export
     D SVPSIN_chkWeb...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      /free

       SVPSIN_inz();

      * Existencia de Rama
       setll peRama set001;

       if not %equal (set001);
          SetError( SVPSIN_RAMAI
                  : 'Rama Inexistente' );
          return *Off;
       endif;

      * Existencia de Siniestro
       if not SVPSIN_chksini ( peEmpr : peSucu : peRama : peSini
                             : peNops);
          return *Off;
       endif;

       return *on;
      /end-free

     P SVPSIN_chkWeb...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getPagosJui(): Retorna Pagos de Juicio                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Indemnizaciones                                     *
      * ------------------------------------------------------------ *

     P SVPSIN_getPagosJui...
     P                 B                   export
     D SVPSIN_getPagosJui...
     D                 pi            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D k1yjhp          ds                  likerec(p1hjhp:*key)

     D  @@fech         s              8  0
     D  @@mact         s             25  2

      /free

       SVPSIN_inz();

       if %parms >= 6 and %addr(peFech) <> *Null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ('AMD');
       endif;

       @@mact = *Zeros;

       k1yjhp.jpempr = peEmpr;
       k1yjhp.jpsucu = peSucu;
       k1yjhp.jprama = peRama;
       k1yjhp.jpsini = peSini;
       k1yjhp.jpnops = peNops;
       setll %kds( k1yjhp : 5 ) pahjhp;
       reade %kds( k1yjhp : 5 ) pahjhp;

       dow not %eof and
           SPVFEC_ArmarFecha8 (hpfmoa : hpfmom : hpfmod: 'AMD' ) <= @@fech;
         if jpmar1 = 'I';
           @@mact += jpimmr;
         endif;
         reade %kds( k1yjhp : 5 ) pahjhp;
       enddo;

       return @@mact;

      /end-free

     P SVPSIN_getPagosJui...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getSpol(): Retorna  Superpoliza/Suplemento/Articulo   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peArcd   (output)  Articulo                              *
      *     peSpol   (output)  Super Poliza                          *
      *     peSspo   (output)  Suplemento                            *
      *                                                              *
      * Retorna: 0 / -1                                              *
      * ------------------------------------------------------------ *

     P SVPSIN_getSpol...
     P                 B                   export
     D SVPSIN_getSpol...
     D                 pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 options( *omit : *nopass )
     D   peArcd                       6  0 options( *omit : *nopass )
     D   peSpol                       9  0 options( *omit : *nopass )
     D   peSspo                       3  0 options( *omit : *nopass )

     D k1yscd          ds                  likerec( p1hscd : *key )

      /free

       SVPSIN_inz();

       k1yscd.cdempr = peEmpr;
       k1yscd.cdsucu = peSucu;
       k1yscd.cdrama = peRama;
       k1yscd.cdsini = peSini;

       if %parms >= 5 and %addr(peNops) <> *Null;
         k1yscd.cdnops = peNops;
         chain(n) %kds( k1yscd : 5 ) pahscd;
           if not %found( pahscd );
             return -1;
           endif;
       else;
         setgt     %kds( k1yscd : 4 ) pahscd;
         readpe(n) %kds( k1yscd : 4 ) pahscd;
            if not %eof( pahscd );
              return -1;
            endif;
       endif;

       if %parms >= 6 and %addr(peArcd) <> *Null;
         peArcd = cdarcd;
       endif;

       if %parms >= 7 and %addr(peSpol) <> *Null;
         peSpol = cdspol;
       endif;
       if %parms >= 8 and %addr(peSspo) <> *Null;
         peSspo = cdsspo;
       endif;

       return 0;

     P SVPSIN_getSpol...
     P                 E
      * ------------------------------------------------------------ *
      * SVPSIN_getPol(): Retorna  Poliza                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: Poliza / -1                                         *
      * ------------------------------------------------------------ *

     P SVPSIN_getPol...
     P                 B                   export
     D SVPSIN_getPol...
     D                 pi             9  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 options( *omit : *nopass )

     D k1yscd          ds                  likerec( p1hscd : *key )

      /free

       SVPSIN_inz();

       k1yscd.cdempr = peEmpr;
       k1yscd.cdsucu = peSucu;
       k1yscd.cdrama = peRama;
       k1yscd.cdsini = peSini;

       if %parms >= 5 and %addr(peNops) <> *Null;
         k1yscd.cdnops = peNops;
         chain(n) %kds( k1yscd : 5 ) pahscd;
           if not %found( pahscd );
             return -1;
           endif;
       else;
         setgt     %kds( k1yscd : 4 ) pahscd;
         readpe(n) %kds( k1yscd : 4 ) pahscd;
            if not %eof( pahscd );
              return -1;
            endif;
       endif;

       return cdpoli;

     P SVPSIN_getPol...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkCausaReno(): Verifica si tiene Siniestros con      *
      * causa: 5-Rono Unidad / 7-Incendio Total / 9-Destrucción Total*
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_chkCausaReno...
     P                 B                   export
     D SVPSIN_chkCausaReno...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const

     D k1yscd          ds                  likerec( p1hscd03 : *key )

       SVPSIN_inz();

       k1yscd.cdempr = peEmpr;
       k1yscd.cdsucu = peSucu;
       k1yscd.cdrama = peRama;
       k1yscd.cdpoli = pePoli;
       setll %kds( k1yscd : 4 ) pahscd03;
       reade %kds( k1yscd : 4 ) pahscd03;

       dow not %eof ( pahscd03 );

         if cdcauc = 5 or cdcauc = 7 or cdcauc = 9;
           SetError( SVPSIN_POLSI
                   : 'Polizas con Siniestros' );
           return *Off;
         endif;

         reade %kds( k1yscd : 4 ) pahscd03;

       enddo;

       return *On;

     P SVPSIN_chkCausaReno...
     P                 E
      * ------------------------------------------------------------ *
      * SVPSIN_getPagos:Retorna Pagos Historicos de una poliza por   *
      *                 Codigo de Area Tecnica y Nro de Comprobante  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Codigo Area Tecnica                  *
      *     pePacp   ( input  ) Nro. de Comprobante de Pago          *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDsSi   ( output ) Estructura de Pagos                  *
      *     peDsSiC  ( output ) Cantidad de Pagos                    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     P SVPSIN_getPagos...
     P                 B                   export
     D SVPSIN_getPagos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peDsSi                            likeds ( DsPahshp01_t ) dim(999)
     D   peDsSiC                     10i 0

     D   k1ish1        ds                  likerec( p1hshp01 : *key   )
     D   @@DsISi       ds                  likerec( p1hshp01 : *input )

      /free

       SVPSIN_inz();

       clear peDsSi;
       clear peDsSiC;
       k1ish1.hpempr = peEmpr;
       k1ish1.hpsucu = peSucu;
       k1ish1.hpartc = peArtc;
       k1ish1.hppacp = pePacp;
       k1ish1.hprama = peRama;
       k1ish1.hpsini = peSini;
       setll %kds( k1ish1 : 6 ) pahshp01;
       if not %equal;
         return *off;
       endif;
       reade %kds( k1ish1 : 6 ) pahshp01 @@DsISi;
       dow not %eof( pahshp01 );
         peDsSiC += 1;
         eval-corr peDsSi( peDsSiC ) = @@DsISi;
        reade %kds( k1ish1 : 6 ) pahshp01 @@DsISi;
       enddo;

       return *on;

      /end-free

     P SVPSIN_getPagos...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getFechaDelDia: Retorna fecha de día de hoy           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *                                                              *
      * Retorna: Fecha                                               *
      * ------------------------------------------------------------ *

     P SVPSIN_getFechaDelDia...
     P                 B                   export
     D SVPSIN_getFechaDelDia...
     D                 pi             8  0
     D   peEmpr                       1    const
     D   peSucu                       2    const

     D @@a             s              4  0
     D @@m             s              2  0
     D @@d             s              2  0
     D @@Fech          s              8  0

      /free

       SVPSIN_inz();

       DBA456R ( @@a : @@m : @@d );

       @@Fech = ( @@a * 10000 + @@m * 100 + @@d );

       return @@Fech;

      /end-free

     P SVPSIN_getFechaDelDia...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getConfiguracionVoucherRuedasCristales: Retorna Con-  *
      *                                    fiuracion de Voucher de   *
      *                                    Ruedas y Cristales        *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peQrev   ( output ) Cantidad de Ruedas por Evento        *
      *     peFrue   ( output ) Frecuencia de Ruedas                 *
      *     peFcri   ( output ) Frecuencia de Cristales              *
      *     peFech   ( input  ) Fecha                                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_getConfiguracionVoucherRuedasCristales...
     P                 B                   export
     D SVPSIN_getConfiguracionVoucherRuedasCristales...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peQrev                       1  0
     D   peFrue                       3  0
     D   peFcri                       3  0
     D   peFech                       8  0 options( *omit : *nopass ) const

     D @@Fech          s              8  0
     D k1y475          ds                  likerec( s1t475 : *key )

      /free

       SVPSIN_inz();

       if %parms >= 3 and %addr(peFech) = *Null;

         @@Fech = SVPSIN_getFechaDelDia( peEmpr
                                       : peSucu );
       else;
         @@Fech = peFech;
       endif;

       k1y475.t475_t@Empr = peEmpr;
       k1y475.t475_t@Sucu = peSucu;
       k1y475.t475_t@Fech = @@Fech;
       setll    %kds( k1y475 : 3 ) set475;
       reade(n) %kds( k1y475 : 2 ) set475;
       if not %eof( set475 );
         peQrev = t475_t@Qrev;
         peFrue = t475_t@Frue;
         peFcri = t475_t@Fcri;
         return *on;
       else;
         return *off;
       endif;

      /end-free

     P SVPSIN_getConfiguracionVoucherRuedasCristales...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getCantidadSiniestrosRuedasPorVehiculo: Retorna Can-  *
      *                                    tidad de Siniestros de    *
      *                                    Ruedas por Vehiculo       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peNmat   ( input  ) Matricula/Patente                    *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Póliza                               *
      *                                                              *
      * Retorna: Cantidad de Siniestros                              *
      * ------------------------------------------------------------ *

     P SVPSIN_getCantidadSiniestrosRuedasPorVehiculo...
     P                 B                   export
     D SVPSIN_getCantidadSiniestrosRuedasPorVehiculo...
     D                 pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNmat                      25    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const

     D @@Cant          s             10i 0
     D k1yscd          ds                  likerec( p1hscd03 : *key )
     D k1ysva          ds                  likerec( p1hsva06 : *key )
     D k1s007          ds                  likerec( p1ds0007 : *key )

      /free

       SVPSIN_inz();

       clear @@Cant;

       k1yscd.cdEmpr = peEmpr;
       k1yscd.cdSucu = peSucu;
       k1yscd.cdRama = peRama;
       k1yscd.cdPoli = pePoli;
       setll %kds( k1yscd:4 ) pahscd03;
       reade %kds( k1yscd:4 ) pahscd03;
       dow not %eof( pahscd03 );
         if cdsini <> 0 and cdCauc = 12;

           k1ysva.vaEmpr = peEmpr;
           k1ysva.vaSucu = peSucu;
           k1ysva.vaNmat = peNmat;
           k1ysva.vaRama = peRama;
           k1ysva.vaSini = cdSini;
           chain %kds( k1ysva : 5 ) pahsva06;
           if %found( pahsva06 );
             @@cant += 1;
           endif;

         endif;
         reade %kds( k1yscd:4 ) pahscd03;
       enddo;

       k1s007.s007_p0empr = peEmpr;
       k1s007.s007_p0sucu = peSucu;
       k1s007.s007_p0pate = peNmat;
       setll %kds( k1s007 : 3 ) pds00007;
       dou %eof(pds00007);
         reade %kds( k1s007 : 3 ) pds00007;
         if not %eof(pds00007);
           if s007_p0caus = 12;
             if s007_p0sini = *zeros;
                if s007_p0rama = peRama and s007_p0poli = pePoli;
                   @@cant += 1;
                endif;
             endif;
           endif;
         endif;
       enddo;

       return @@cant;

      /end-free

     P SVPSIN_getCantidadSiniestrosRuedasPorVehiculo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getCantidadSiniestrosCristalesPorVehiculo: Retorna    *
      *                                    Cantidad de Siniestros de *
      *                                    Ruedas por Vehiculo       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peNmat   ( input  ) Matricula/Patente                    *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Póliza                               *
      *                                                              *
      * Retorna: Cantidad de Siniestros                              *
      * ------------------------------------------------------------ *

     P SVPSIN_getCantidadSiniestrosCristalesPorVehiculo...
     P                 B                   export
     D SVPSIN_getCantidadSiniestrosCristalesPorVehiculo...
     D                 pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNmat                      25    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const

     D @@Cant          s             10i 0
     D k1yscd          ds                  likerec( p1hscd03 : *key )
     D k1ysva          ds                  likerec( p1hsva06 : *key )
     D k1s007          ds                  likerec( p1ds0007 : *key )

      /free

       SVPSIN_inz();

       clear @@Cant;

       k1yscd.cdEmpr = peEmpr;
       k1yscd.cdSucu = peSucu;
       k1yscd.cdRama = peRama;
       k1yscd.cdPoli = pePoli;
       setll %kds( k1yscd:4 ) pahscd03;
       reade %kds( k1yscd:4 ) pahscd03;
       dow not %eof( pahscd03 );
         if cdsini <> 0 and cdCauc = 15;

           k1ysva.vaEmpr = peEmpr;
           k1ysva.vaSucu = peSucu;
           k1ysva.vaNmat = peNmat;
           k1ysva.vaRama = peRama;
           k1ysva.vaSini = cdSini;
           chain %kds( k1ysva : 5 ) pahsva06;
           if %found( pahsva06 );
             @@cant += 1;
           endif;

         endif;
         reade %kds( k1yscd:4 ) pahscd03;
       enddo;

       k1s007.s007_p0empr = peEmpr;
       k1s007.s007_p0sucu = peSucu;
       k1s007.s007_p0pate = peNmat;
       setll %kds( k1s007 : 3 ) pds00007;
       dou %eof(pds00007);
         reade %kds( k1s007 : 3 ) pds00007;
         if not %eof(pds00007);
           if s007_p0caus = 15;
             if s007_p0sini = *zeros;
                if s007_p0rama = peRama and s007_p0poli = pePoli;
                   @@cant += 1;
                endif;
             endif;
           endif;
         endif;
       enddo;

       return @@cant;

      /end-free

     P SVPSIN_getCantidadSiniestrosCristalesPorVehiculo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getNumeroVoucher: Retorna Número de Voucher           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *                                                              *
      * Retorna: Número                                              *
      * ------------------------------------------------------------ *

     P SVPSIN_getNumeroVoucher...
     P                 B                   export
     D SVPSIN_getNumeroVoucher...
     D                 pi             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const

     D @@Nres          s              7  0

      /free

       SVPSIN_inz();

       SPT902 ('!': @@Nres );

       return @@Nres;

      /end-free

     P SVPSIN_getNumeroVoucher...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_setNumeroVoucher: Retorna Número de Voucher           *
      *                                                              *
      *     peBase   ( input  ) Parametros Base                      *
      *     peNpds   ( input  ) Número de Pre-Denuncia               *
      *     peNore   ( input  ) Número de Voucher ó Orden Reposición *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_setNumeroVoucher...
     P                 B                   export
     D SVPSIN_setNumeroVoucher...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNpds                       7  0 const
     D   peNore                       7  0 const

     D k1s000          ds                  likerec(p1ds00:*key)
     D peMsgs          ds                  likeds(paramMsgs)
     D @repl           s          65535a

      /free

       SVPSIN_inz();

       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;
         return *off;
       endif;

       k1s000.p0empr = peBase.peEmpr;
       k1s000.p0sucu = peBase.peSucu;
       k1s000.p0nivt = peBase.peNivt;
       k1s000.p0nivc = peBase.peNivc;
       k1s000.p0npds = peNpds;
       chain %kds( k1s000:5 ) pds000;
       if %found( pds000 );
         p0User = ususr2;
         p0Date = (*year * 10000)
                + (*month *  100)
                +  *day;
         p0Time = %dec(%time():*iso);
         p0Nore = peNore;
         update p1ds00;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSIN_setNumeroVoucher...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getCaratula(): Retorna Carátula de Denuncia de        *
      *                       Siniestro.-                            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     peDsCd   ( output ) Estructura de Carátula de Siniestro  *
      *     peDsCdC  ( output ) Cantidad de Carátula de Siniestro    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     P SVPSIN_getCaratula...
     P                 B                   export
     D SVPSIN_getCaratula...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peDsCd                            likeds ( DsPahscd_t )

     D   k1yscd        ds                  likerec( p1hscd : *key   )
     D   @@DsIcd       ds                  likerec( p1hscd : *input )

      /free

       SVPSIN_inz();

       clear peDsCd;
       clear @@DsIcd;

       k1yscd.cdEmpr = peEmpr;
       k1yscd.cdSucu = peSucu;
       k1yscd.cdRama = peRama;
       k1yscd.cdSini = peSini;
       k1yscd.cdNops = peNops;
       chain %kds( k1yscd : 5 ) pahscd @@DsIcd;
       if not %found( pahscd );
         return *off;
       endif;

       unlock pahscd;
       eval-corr peDsCd = @@DsIcd;

       return *on;

      /end-free

     P SVPSIN_getCaratula...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getVehiculo(): Retorna Siniestro de Vehículo del      *
      *                       Asegurado.-                            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peVhmc   ( input  ) Marca de Vehículo                    *
      *     peVhmo   ( input  ) Código de Modelo                     *
      *     peVhcs   ( input  ) Código de Submodelo                  *
      *     pePsec   ( input  ) Nro de Secuencia                     *
      *     peDsCd   ( output ) Estructura de Siniestro de Vehículo  *
      *     peDsCdC  ( output ) Cantidad de Siniestro de Vehículo    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     P SVPSIN_getVehiculo...
     P                 B                   export
     D SVPSIN_getVehiculo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peVhmc                       3    options(*nopass:*omit) const
     D   peVhmo                       3    options(*nopass:*omit) const
     D   peVhcs                       3    options(*nopass:*omit) const
     D   pePsec                       2  0 options(*nopass:*omit) const
     D   peDsVa                            likeds ( DsPahsva_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsVaC                     10i 0 options(*nopass:*omit)

     D   k1ysva        ds                  likerec( p1hsva : *key   )
     D   @@DsIva       ds                  likerec( p1hsva : *input )
     D   @@DsVa        ds                  likeds ( DsPahsva_t ) dim(999)
     D   @@DsVaC       s             10i 0

      /free

       SVPSIN_inz();

       clear @@DsVa;
       clear @@DsVaC;

       k1ysva.vaEmpr = peEmpr;
       k1ysva.vaSucu = peSucu;
       k1ysva.vaRama = peRama;
       k1ysva.vaSini = peSini;
       k1ysva.vaNops = peNops;

       select;
         when %parms >= 11 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peVhmc ) <> *null
                           and %addr( peVhmo ) <> *null
                           and %addr( peVhcs ) <> *null
                           and %addr( pePsec ) <> *null;

           k1ysva.vaPoco =  pePoco;
           k1ysva.vaPaco =  pePaco;
           k1ysva.vaVhmc =  peVhmc;
           k1ysva.vaVhmo =  peVhmo;
           k1ysva.vaVhcs =  peVhcs;
           k1ysva.vaPsec =  pePsec;
           setll %kds( k1ysva : 11 ) pahsva;
           if not %equal( pahsva );
             return *off;
           endif;

           reade(n) %kds( k1ysva : 11 ) pahsva @@DsIva;
           dow not %eof( pahsva );
             @@DsVaC += 1;
             eval-corr @@DsVa ( @@DsVaC ) = @@DsIva;
             reade(n) %kds( k1ysva : 11 ) pahsva @@DsIva;
           enddo;

         when %parms >= 10 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peVhmc ) <> *null
                           and %addr( peVhmo ) <> *null
                           and %addr( peVhcs ) <> *null
                           and %addr( pePsec ) =  *null;

           k1ysva.vaPoco =  pePoco;
           k1ysva.vaPaco =  pePaco;
           k1ysva.vaVhmc =  peVhmc;
           k1ysva.vaVhmo =  peVhmo;
           k1ysva.vaVhcs =  peVhcs;
           setll %kds( k1ysva : 10 ) pahsva;
           if not %equal( pahsva );
             return *off;
           endif;

           reade(n) %kds( k1ysva : 10 ) pahsva @@DsIva;
           dow not %eof( pahsva );
             @@DsVaC += 1;
             eval-corr @@DsVa ( @@DsVaC ) = @@DsIva;
             reade(n) %kds( k1ysva : 10 ) pahsva @@DsIva;
           enddo;

         when %parms >= 9 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peVhmc ) <> *null
                          and %addr( peVhmo ) <> *null
                          and %addr( peVhcs ) =  *null
                          and %addr( pePsec ) =  *null;

           k1ysva.vaPoco =  pePoco;
           k1ysva.vaPaco =  pePaco;
           k1ysva.vaVhmc =  peVhmc;
           k1ysva.vaVhmo =  peVhmo;
           setll %kds( k1ysva : 9 ) pahsva;
           if not %equal( pahsva );
             return *off;
           endif;

           reade(n) %kds( k1ysva : 9 ) pahsva @@DsIva;
           dow not %eof( pahsva );
             @@DsVaC += 1;
             eval-corr @@DsVa ( @@DsVaC ) = @@DsIva;
             reade(n) %kds( k1ysva : 9 ) pahsva @@DsIva;
           enddo;

         when %parms >= 8 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peVhmc ) <> *null
                          and %addr( peVhmo ) =  *null
                          and %addr( peVhcs ) =  *null
                          and %addr( pePsec ) =  *null;

           k1ysva.vaPoco =  pePoco;
           k1ysva.vaPaco =  pePaco;
           k1ysva.vaVhmc =  peVhmc;
           setll %kds( k1ysva : 8 ) pahsva;
           if not %equal( pahsva );
             return *off;
           endif;

           reade(n) %kds( k1ysva : 8 ) pahsva @@DsIva;
           dow not %eof( pahsva );
             @@DsVaC += 1;
             eval-corr @@DsVa ( @@DsVaC ) = @@DsIva;
             reade(n) %kds( k1ysva : 8 ) pahsva @@DsIva;
           enddo;

         when %parms >= 7 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peVhmc ) =  *null
                          and %addr( peVhmo ) =  *null
                          and %addr( peVhcs ) =  *null
                          and %addr( pePsec ) =  *null;

           k1ysva.vaPoco =  pePoco;
           k1ysva.vaPaco =  pePaco;
           setll %kds( k1ysva : 7 ) pahsva;
           if not %equal( pahsva );
             return *off;
           endif;

           reade(n) %kds( k1ysva : 7 ) pahsva @@DsIva;
           dow not %eof( pahsva );
             @@DsVaC += 1;
             eval-corr @@DsVa ( @@DsVaC ) = @@DsIva;
             reade(n) %kds( k1ysva : 7 ) pahsva @@DsIva;
           enddo;

         when %parms >= 6 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) =  *null
                          and %addr( peVhmc ) =  *null
                          and %addr( peVhmo ) =  *null
                          and %addr( peVhcs ) =  *null
                          and %addr( pePsec ) =  *null;

           k1ysva.vaPoco =  pePoco;
           setll %kds( k1ysva : 6 ) pahsva;
           if not %equal( pahsva );
             return *off;
           endif;

           reade(n) %kds( k1ysva : 6 ) pahsva @@DsIva;
           dow not %eof( pahsva );
             @@DsVaC += 1;
             eval-corr @@DsVa ( @@DsVaC ) = @@DsIva;
             reade(n) %kds( k1ysva : 6 ) pahsva @@DsIva;
           enddo;

         other;

           setll %kds( k1ysva : 5 ) pahsva;
           if not %equal( pahsva );
             return *off;
           endif;

           reade(n) %kds( k1ysva : 5 ) pahsva @@DsIva;
           dow not %eof( pahsva );
             @@DsVaC += 1;
             eval-corr @@DsVa ( @@DsVaC ) = @@DsIva;
             reade(n) %kds( k1ysva : 5 ) pahsva @@DsIva;
           enddo;

       endsl;

       if %addr( peDsVa ) <> *null;
         eval-corr peDsVa = @@DsVa;
       endif;

       if %addr( peDsVaC ) <> *null;
         peDsVaC = @@DsVaC;
       endif;

       return *on;

      /end-free

     P SVPSIN_getVehiculo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getBeneficiarios(): Retorna Beneficiarios del         *
      *                            Siniestro.-                       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peRiec   ( input  ) Código de Riesgo                     *
      *     peXcob   ( input  ) Código de Cobertura                  *
      *     peNrdf   ( input  ) Número de Persona                    *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *     peDsBe   ( output ) Estructura de Beneficiarios de Sini. *
      *     peDsBeC  ( output ) Cantidad de Beneficiario de Sini.    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     P SVPSIN_getBeneficiarios...
     P                 B                   export
     D SVPSIN_getBeneficiarios...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peDsBe                            likeds ( DsPahsbe_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsBeC                     10i 0 options(*nopass:*omit)

     D   k1ysbe        ds                  likerec( p1hsbe : *key   )
     D   @@DsIbe       ds                  likerec( p1hsbe : *input )
     D   @@DsBe        ds                  likeds ( DsPahsbe_t ) dim(999)
     D   @@DsBeC       s             10i 0

      /free

       SVPSIN_inz();

       clear @@DsBe;
       clear @@DsBeC;

       k1ysbe.beEmpr = peEmpr;
       k1ysbe.beSucu = peSucu;
       k1ysbe.beRama = peRama;
       k1ysbe.beSini = peSini;
       k1ysbe.beNops = peNops;

       select;
         when %parms >= 11 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null;

           k1ysbe.bePoco =  pePoco;
           k1ysbe.bePaco =  pePaco;
           k1ysbe.beRiec =  peRiec;
           k1ysbe.beXcob =  peXcob;
           k1ysbe.beNrdf =  peNrdf;
           k1ysbe.beSebe =  peSebe;
           setll %kds( k1ysbe : 11 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 11 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 11 ) pahsbe @@DsIbe;
           enddo;

         when %parms >= 10 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) =  *null;

           k1ysbe.bePoco =  pePoco;
           k1ysbe.bePaco =  pePaco;
           k1ysbe.beRiec =  peRiec;
           k1ysbe.beXcob =  peXcob;
           k1ysbe.beNrdf =  peNrdf;
           setll %kds( k1ysbe : 10 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 10 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 10 ) pahsbe @@DsIbe;
           enddo;

         when %parms >= 9 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) <> *null
                          and %addr( peXcob ) <> *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysbe.bePoco =  pePoco;
           k1ysbe.bePaco =  pePaco;
           k1ysbe.beRiec =  peRiec;
           k1ysbe.beXcob =  peXcob;
           setll %kds( k1ysbe : 9 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 9 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 9 ) pahsbe @@DsIbe;
           enddo;

         when %parms >= 8 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) <> *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysbe.bePoco =  pePoco;
           k1ysbe.bePaco =  pePaco;
           k1ysbe.beRiec =  peRiec;
           setll %kds( k1ysbe : 8 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 8 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 8 ) pahsbe @@DsIbe;
           enddo;

         when %parms >= 7 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysbe.bePoco =  pePoco;
           k1ysbe.bePaco =  pePaco;
           setll %kds( k1ysbe : 7 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 7 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 7 ) pahsbe @@DsIbe;
           enddo;

         when %parms >= 6 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) =  *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysbe.bePoco =  pePoco;
           setll %kds( k1ysbe : 6 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 6 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 6 ) pahsbe @@DsIbe;
           enddo;

         other;

           setll %kds( k1ysbe : 5 ) pahsbe;
           if not %equal( pahsbe );
             return *off;
           endif;

           reade(n) %kds( k1ysbe : 5 ) pahsbe @@DsIbe;
           dow not %eof( pahsbe );
             @@DsBeC += 1;
             eval-corr @@DsBe ( @@DsBeC ) = @@DsIbe;
             reade(n) %kds( k1ysbe : 5 ) pahsbe @@DsIbe;
           enddo;

       endsl;

       if %addr( peDsBe ) <> *null;
         eval-corr peDsBe = @@DsBe;
       endif;

       if %addr( peDsBeC ) <> *null;
         peDsBeC = @@DsBeC;
       endif;

       return *on;

      /end-free

     P SVPSIN_getBeneficiarios...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getSubsiniestros(): Retorna Subsiniestros del         *
      *                            Siniestro.-                       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peRiec   ( input  ) Código de Riesgo                     *
      *     peXcob   ( input  ) Código de Cobertura                  *
      *     peNrdf   ( input  ) Número de Persona                    *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *     peFema   ( input  ) Fecha de Emisión Año                 *
      *     peFemm   ( input  ) Fecha de Emisión Mes                 *
      *     peFemd   ( input  ) Fecha de Emisión Día                 *
      *     peDsBe   ( output ) Estructura de Subsiniestros de Sini. *
      *     peDsBeC  ( output ) Cantidad de Subsiniestro de Sini.    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     P SVPSIN_getSubsiniestros...
     P                 B                   export
     D SVPSIN_getSubsiniestros...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peFema                       4  0 options(*nopass:*omit) const
     D   peFemm                       2  0 options(*nopass:*omit) const
     D   peFemd                       2  0 options(*nopass:*omit) const
     D   peDsB1                            likeds ( DsPahsb1_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsB1C                     10i 0 options(*nopass:*omit)

     D   k1ysb1        ds                  likerec( p1hsb1 : *key   )
     D   @@DsIb1       ds                  likerec( p1hsb1 : *input )
     D   @@DsB1        ds                  likeds ( DsPahsb1_t ) dim(999)
     D   @@DsB1C       s             10i 0

      /free

       SVPSIN_inz();

       clear @@DsB1;
       clear @@DsB1C;

       k1ysb1.b1Empr = peEmpr;
       k1ysb1.b1Sucu = peSucu;
       k1ysb1.b1Rama = peRama;
       k1ysb1.b1Sini = peSini;
       k1ysb1.b1Nops = peNops;

       select;
         when %parms >= 14 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null
                           and %addr( peFema ) <> *null
                           and %addr( peFemm ) <> *null
                           and %addr( peFemd ) <> *null;

           k1ysb1.b1Poco =  pePoco;
           k1ysb1.b1Paco =  pePaco;
           k1ysb1.b1Riec =  peRiec;
           k1ysb1.b1Xcob =  peXcob;
           k1ysb1.b1Nrdf =  peNrdf;
           k1ysb1.b1Sebe =  peSebe;
           k1ysb1.b1Fema =  peFema;
           k1ysb1.b1Femm =  peFemm;
           k1ysb1.b1Femd =  peFemd;
           setll %kds( k1ysb1 : 14 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 14 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 14 ) pahsb1 @@DsIb1;
           enddo;

         when %parms >= 13 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null
                           and %addr( peFema ) <> *null
                           and %addr( peFemm ) <> *null
                           and %addr( peFemd ) =  *null;

           k1ysb1.b1Poco =  pePoco;
           k1ysb1.b1Paco =  pePaco;
           k1ysb1.b1Riec =  peRiec;
           k1ysb1.b1Xcob =  peXcob;
           k1ysb1.b1Nrdf =  peNrdf;
           k1ysb1.b1Sebe =  peSebe;
           k1ysb1.b1Fema =  peFema;
           k1ysb1.b1Femm =  peFemm;
           setll %kds( k1ysb1 : 13 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 13 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 13 ) pahsb1 @@DsIb1;
           enddo;

         when %parms >= 12 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null
                           and %addr( peFema ) <> *null
                           and %addr( peFemm ) =  *null
                           and %addr( peFemd ) =  *null;

           k1ysb1.b1Poco =  pePoco;
           k1ysb1.b1Paco =  pePaco;
           k1ysb1.b1Riec =  peRiec;
           k1ysb1.b1Xcob =  peXcob;
           k1ysb1.b1Nrdf =  peNrdf;
           k1ysb1.b1Sebe =  peSebe;
           k1ysb1.b1Fema =  peFema;
           setll %kds( k1ysb1 : 12 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 12 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 12 ) pahsb1 @@DsIb1;
           enddo;

         when %parms >= 11 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null
                           and %addr( peFema ) =  *null
                           and %addr( peFemm ) =  *null
                           and %addr( peFemd ) =  *null;

           k1ysb1.b1Poco =  pePoco;
           k1ysb1.b1Paco =  pePaco;
           k1ysb1.b1Riec =  peRiec;
           k1ysb1.b1Xcob =  peXcob;
           k1ysb1.b1Nrdf =  peNrdf;
           k1ysb1.b1Sebe =  peSebe;
           setll %kds( k1ysb1 : 11 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 11 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 11 ) pahsb1 @@DsIb1;
           enddo;

         when %parms >= 10 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) =  *null
                           and %addr( peFema ) =  *null
                           and %addr( peFemm ) =  *null
                           and %addr( peFemd ) =  *null;

           k1ysb1.b1Poco =  pePoco;
           k1ysb1.b1Paco =  pePaco;
           k1ysb1.b1Riec =  peRiec;
           k1ysb1.b1Xcob =  peXcob;
           k1ysb1.b1Nrdf =  peNrdf;
           setll %kds( k1ysb1 : 10 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 10 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 10 ) pahsb1 @@DsIb1;
           enddo;

         when %parms >= 9 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) <> *null
                          and %addr( peXcob ) <> *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null
                          and %addr( peFema ) =  *null
                          and %addr( peFemm ) =  *null
                          and %addr( peFemd ) =  *null;

           k1ysb1.b1Poco =  pePoco;
           k1ysb1.b1Paco =  pePaco;
           k1ysb1.b1Riec =  peRiec;
           k1ysb1.b1Xcob =  peXcob;
           setll %kds( k1ysb1 : 9 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 9 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 9 ) pahsb1 @@DsIb1;
           enddo;

         when %parms >= 8 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) <> *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null
                          and %addr( peFema ) =  *null
                          and %addr( peFemm ) =  *null
                          and %addr( peFemd ) =  *null;

           k1ysb1.b1Poco =  pePoco;
           k1ysb1.b1Paco =  pePaco;
           k1ysb1.b1Riec =  peRiec;
           setll %kds( k1ysb1 : 8 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 8 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 8 ) pahsb1 @@DsIb1;
           enddo;

         when %parms >= 7 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null
                          and %addr( peFema ) =  *null
                          and %addr( peFemm ) =  *null
                          and %addr( peFemd ) =  *null;

           k1ysb1.b1Poco =  pePoco;
           k1ysb1.b1Paco =  pePaco;
           setll %kds( k1ysb1 : 7 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 7 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 7 ) pahsb1 @@DsIb1;
           enddo;

         when %parms >= 6 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) =  *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null
                          and %addr( peFema ) =  *null
                          and %addr( peFemm ) =  *null
                          and %addr( peFemd ) =  *null;

           k1ysb1.b1Poco =  pePoco;
           setll %kds( k1ysb1 : 6 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 6 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 6 ) pahsb1 @@DsIb1;
           enddo;

         other;

           setll %kds( k1ysb1 : 5 ) pahsb1;
           if not %equal( pahsb1 );
             return *off;
           endif;

           reade(n) %kds( k1ysb1 : 5 ) pahsb1 @@DsIb1;
           dow not %eof( pahsb1 );
             @@DsB1C += 1;
             eval-corr @@DsB1 ( @@DsB1C ) = @@DsIb1;
             reade(n) %kds( k1ysb1 : 5 ) pahsb1 @@DsIb1;
           enddo;

       endsl;

       if %addr( peDsB1 ) <> *null;
         eval-corr peDsB1 = @@DsB1;
       endif;

       if %addr( peDsB1C ) <> *null;
         peDsB1C = @@DsB1C;
       endif;

       return *on;

      /end-free

     P SVPSIN_getSubsiniestros...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getUltimoSubsiniestro(): Retorna Ultimo estado del    *
      *                                 Subsiniestro.-               *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peRiec   ( input  ) Código de Riesgo                     *
      *     peXcob   ( input  ) Código de Cobertura                  *
      *     peNrdf   ( input  ) Número de Persona                    *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *     peDsb1   ( output ) Estructura de Subsiniestro           *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     P SVPSIN_getUltimoSubsiniestro...
     P                 B                   export
     D SVPSIN_getUltimoSubsiniestro...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peDsb1                            likeds( DsPahsb1_t )

     D   @@DsB1        ds                  likeds( DsPahsb1_t ) dim(999)
     D   @@DsB1C       s             10i 0

      /free

       SVPSIN_inz();

       clear @@DsB1;
       clear @@DsB1C;

       if SVPSIN_getSubsiniestros( peEmpr
                                 : peSucu
                                 : peRama
                                 : peSini
                                 : peNops
                                 : pePoco
                                 : pePaco
                                 : peRiec
                                 : peXcob
                                 : peNrdf
                                 : peSebe
                                 : *omit
                                 : *omit
                                 : *omit
                                 : @@DsB1
                                 : @@DsB1C );

         eval-corr peDsB1 = @@DsB1(1);
         return *on;

       endif;

       return *off;

       /end-free

     P SVPSIN_getUltimoSubsiniestro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getConductorTercero(): Retorna Datos del Conductor    *
      *                               Tercero del Siniestros.-       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peRiec   ( input  ) Código de Riesgo                     *
      *     peXcob   ( input  ) Código de Cobertura                  *
      *     peNrdf   ( input  ) Número de Persona                    *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *     peDsB2   ( output ) Estructura de Conductor Tercero      *
      *     peDsB2C  ( output ) Cantidad de Conductor Tercero        *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     P SVPSIN_getConductorTercero...
     P                 B                   export
     D SVPSIN_getConductorTercero...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peDsB2                            likeds ( DsPahsb2_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsB2C                     10i 0 options(*nopass:*omit)

     D   k1ysb2        ds                  likerec( p1hsb2 : *key   )
     D   @@DsIb2       ds                  likerec( p1hsb2 : *input )
     D   @@DsB2        ds                  likeds ( DsPahsb2_t ) dim(999)
     D   @@DsB2C       s             10i 0

      /free

       SVPSIN_inz();

       clear @@DsB2;
       clear @@DsB2C;

       k1ysb2.b2Empr = peEmpr;
       k1ysb2.b2Sucu = peSucu;
       k1ysb2.b2Rama = peRama;
       k1ysb2.b2Sini = peSini;
       k1ysb2.b2Nops = peNops;

       select;
         when %parms >= 11 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null;

           k1ysb2.b2Poco =  pePoco;
           k1ysb2.b2Paco =  pePaco;
           k1ysb2.b2Riec =  peRiec;
           k1ysb2.b2Xcob =  peXcob;
           k1ysb2.b2Nrdf =  peNrdf;
           k1ysb2.b2Sebe =  peSebe;
           setll %kds( k1ysb2 : 11 ) pahsb2;
           if not %equal( pahsb2 );
             return *off;
           endif;

           reade(n) %kds( k1ysb2 : 11 ) pahsb2 @@DsIb2;
           dow not %eof( pahsb2 );
             @@DsB2C += 1;
             eval-corr @@DsB2 ( @@DsB2C ) = @@DsIb2;
             reade(n) %kds( k1ysb2 : 11 ) pahsb2 @@DsIb2;
           enddo;

         when %parms >= 10 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) =  *null;

           k1ysb2.b2Poco =  pePoco;
           k1ysb2.b2Paco =  pePaco;
           k1ysb2.b2Riec =  peRiec;
           k1ysb2.b2Xcob =  peXcob;
           k1ysb2.b2Nrdf =  peNrdf;
           setll %kds( k1ysb2 : 10 ) pahsb2;
           if not %equal( pahsb2 );
             return *off;
           endif;

           reade(n) %kds( k1ysb2 : 10 ) pahsb2 @@DsIb2;
           dow not %eof( pahsb2 );
             @@DsB2C += 1;
             eval-corr @@DsB2 ( @@DsB2C ) = @@DsIb2;
             reade(n) %kds( k1ysb2 : 10 ) pahsb2 @@DsIb2;
           enddo;

         when %parms >= 9 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) <> *null
                          and %addr( peXcob ) <> *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysb2.b2Poco =  pePoco;
           k1ysb2.b2Paco =  pePaco;
           k1ysb2.b2Riec =  peRiec;
           k1ysb2.b2Xcob =  peXcob;
           setll %kds( k1ysb2 : 9 ) pahsb2;
           if not %equal( pahsb2 );
             return *off;
           endif;

           reade(n) %kds( k1ysb2 : 9 ) pahsb2 @@DsIb2;
           dow not %eof( pahsb2 );
             @@DsB2C += 1;
             eval-corr @@DsB2 ( @@DsB2C ) = @@DsIb2;
             reade(n) %kds( k1ysb2 : 9 ) pahsb2 @@DsIb2;
           enddo;

         when %parms >= 8 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) <> *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysb2.b2Poco =  pePoco;
           k1ysb2.b2Paco =  pePaco;
           k1ysb2.b2Riec =  peRiec;
           setll %kds( k1ysb2 : 8 ) pahsb2;
           if not %equal( pahsb2 );
             return *off;
           endif;

           reade(n) %kds( k1ysb2 : 8 ) pahsb2 @@DsIb2;
           dow not %eof( pahsb2 );
             @@DsB2C += 1;
             eval-corr @@DsB2 ( @@DsB2C ) = @@DsIb2;
             reade(n) %kds( k1ysb2 : 8 ) pahsb2 @@DsIb2;
           enddo;

         when %parms >= 7 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysb2.b2Poco =  pePoco;
           k1ysb2.b2Paco =  pePaco;
           setll %kds( k1ysb2 : 7 ) pahsb2;
           if not %equal( pahsb2 );
             return *off;
           endif;

           reade(n) %kds( k1ysb2 : 7 ) pahsb2 @@DsIb2;
           dow not %eof( pahsb2 );
             @@DsB2C += 1;
             eval-corr @@DsB2 ( @@DsB2C ) = @@DsIb2;
             reade(n) %kds( k1ysb2 : 7 ) pahsb2 @@DsIb2;
           enddo;

         when %parms >= 6 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) =  *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysb2.b2Poco =  pePoco;
           setll %kds( k1ysb2 : 6 ) pahsb2;
           if not %equal( pahsb2 );
             return *off;
           endif;

           reade(n) %kds( k1ysb2 : 6 ) pahsb2 @@DsIb2;
           dow not %eof( pahsb2 );
             @@DsB2C += 1;
             eval-corr @@DsB2 ( @@DsB2C ) = @@DsIb2;
             reade(n) %kds( k1ysb2 : 6 ) pahsb2 @@DsIb2;
           enddo;

         other;

           setll %kds( k1ysb2 : 5 ) pahsb2;
           if not %equal( pahsb2 );
             return *off;
           endif;

           reade(n) %kds( k1ysb2 : 5 ) pahsb2 @@DsIb2;
           dow not %eof( pahsb2 );
             @@DsB2C += 1;
             eval-corr @@DsB2 ( @@DsB2C ) = @@DsIb2;
             reade(n) %kds( k1ysb2 : 5 ) pahsb2 @@DsIb2;
           enddo;

       endsl;

       if %addr( peDsB2 ) <> *null;
         eval-corr peDsB2 = @@DsB2;
       endif;

       if %addr( peDsB2C ) <> *null;
         peDsB2C = @@DsB2C;
       endif;

       return *on;

      /end-free

     P SVPSIN_getConductorTercero...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getVehiculoTercero(): Retorna Datos del Vehiculo del  *
      *                              Tercero del Siniestro.-         *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peRiec   ( input  ) Código de Riesgo                     *
      *     peXcob   ( input  ) Código de Cobertura                  *
      *     peNrdf   ( input  ) Número de Persona                    *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *     peDsB4   ( output ) Estructura de Conductor Tercero      *
      *     peDsB4C  ( output ) Cantidad de Conductor Tercero        *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     P SVPSIN_getVehiculoTercero...
     P                 B                   export
     D SVPSIN_getVehiculoTercero...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peDsB4                            likeds ( DsPahsb4_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsB4C                     10i 0 options(*nopass:*omit)

     D   k1ysb4        ds                  likerec( p1hsb4 : *key   )
     D   @@DsIb4       ds                  likerec( p1hsb4 : *input )
     D   @@DsB4        ds                  likeds ( DsPahsb4_t ) dim(999)
     D   @@DsB4C       s             10i 0

      /free

       SVPSIN_inz();

       clear @@DsB4;
       clear @@DsB4C;

       k1ysb4.b4Empr = peEmpr;
       k1ysb4.b4Sucu = peSucu;
       k1ysb4.b4Rama = peRama;
       k1ysb4.b4Sini = peSini;
       k1ysb4.b4Nops = peNops;

       select;
         when %parms >= 11 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null;

           k1ysb4.b4Poco =  pePoco;
           k1ysb4.b4Paco =  pePaco;
           k1ysb4.b4Riec =  peRiec;
           k1ysb4.b4Xcob =  peXcob;
           k1ysb4.b4Nrdf =  peNrdf;
           k1ysb4.b4Sebe =  peSebe;
           setll %kds( k1ysb4 : 11 ) pahsb4;
           if not %equal( pahsb4 );
             return *off;
           endif;

           reade(n) %kds( k1ysb4 : 11 ) pahsb4 @@DsIb4;
           dow not %eof( pahsb4 );
             @@DsB4C += 1;
             eval-corr @@DsB4 ( @@DsB4C ) = @@DsIb4;
             reade(n) %kds( k1ysb4 : 11 ) pahsb4 @@DsIb4;
           enddo;

         when %parms >= 10 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) =  *null;

           k1ysb4.b4Poco =  pePoco;
           k1ysb4.b4Paco =  pePaco;
           k1ysb4.b4Riec =  peRiec;
           k1ysb4.b4Xcob =  peXcob;
           k1ysb4.b4Nrdf =  peNrdf;
           setll %kds( k1ysb4 : 10 ) pahsb4;
           if not %equal( pahsb4 );
             return *off;
           endif;

           reade(n) %kds( k1ysb4 : 10 ) pahsb4 @@DsIb4;
           dow not %eof( pahsb4 );
             @@DsB4C += 1;
             eval-corr @@DsB4 ( @@DsB4C ) = @@DsIb4;
             reade(n) %kds( k1ysb4 : 10 ) pahsb4 @@DsIb4;
           enddo;

         when %parms >= 9 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) <> *null
                          and %addr( peXcob ) <> *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysb4.b4Poco =  pePoco;
           k1ysb4.b4Paco =  pePaco;
           k1ysb4.b4Riec =  peRiec;
           k1ysb4.b4Xcob =  peXcob;
           setll %kds( k1ysb4 : 9 ) pahsb4;
           if not %equal( pahsb4 );
             return *off;
           endif;

           reade(n) %kds( k1ysb4 : 9 ) pahsb4 @@DsIb4;
           dow not %eof( pahsb4 );
             @@DsB4C += 1;
             eval-corr @@DsB4 ( @@DsB4C ) = @@DsIb4;
             reade(n) %kds( k1ysb4 : 9 ) pahsb4 @@DsIb4;
           enddo;

         when %parms >= 8 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) <> *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysb4.b4Poco =  pePoco;
           k1ysb4.b4Paco =  pePaco;
           k1ysb4.b4Riec =  peRiec;
           setll %kds( k1ysb4 : 8 ) pahsb4;
           if not %equal( pahsb4 );
             return *off;
           endif;

           reade(n) %kds( k1ysb4 : 8 ) pahsb4 @@DsIb4;
           dow not %eof( pahsb4 );
             @@DsB4C += 1;
             eval-corr @@DsB4 ( @@DsB4C ) = @@DsIb4;
             reade(n) %kds( k1ysb4 : 8 ) pahsb4 @@DsIb4;
           enddo;

         when %parms >= 7 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysb4.b4Poco =  pePoco;
           k1ysb4.b4Paco =  pePaco;
           setll %kds( k1ysb4 : 7 ) pahsb4;
           if not %equal( pahsb4 );
             return *off;
           endif;

           reade(n) %kds( k1ysb4 : 7 ) pahsb4 @@DsIb4;
           dow not %eof( pahsb4 );
             @@DsB4C += 1;
             eval-corr @@DsB4 ( @@DsB4C ) = @@DsIb4;
             reade(n) %kds( k1ysb4 : 7 ) pahsb4 @@DsIb4;
           enddo;

         when %parms >= 6 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) =  *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null;

           k1ysb4.b4Poco =  pePoco;
           setll %kds( k1ysb4 : 6 ) pahsb4;
           if not %equal( pahsb4 );
             return *off;
           endif;

           reade(n) %kds( k1ysb4 : 6 ) pahsb4 @@DsIb4;
           dow not %eof( pahsb4 );
             @@DsB4C += 1;
             eval-corr @@DsB4 ( @@DsB4C ) = @@DsIb4;
             reade(n) %kds( k1ysb4 : 6 ) pahsb4 @@DsIb4;
           enddo;

         other;

           setll %kds( k1ysb4 : 5 ) pahsb4;
           if not %equal( pahsb4 );
             return *off;
           endif;

           reade(n) %kds( k1ysb4 : 5 ) pahsb4 @@DsIb4;
           dow not %eof( pahsb4 );
             @@DsB4C += 1;
             eval-corr @@DsB4 ( @@DsB4C ) = @@DsIb4;
             reade(n) %kds( k1ysb4 : 5 ) pahsb4 @@DsIb4;
           enddo;

       endsl;

       if %addr( peDsB4 ) <> *null;
         eval-corr peDsB4 = @@DsB4;
       endif;

       if %addr( peDsB4C ) <> *null;
         peDsB4C = @@DsB4C;
       endif;

       return *on;

      /end-free

     P SVPSIN_getVehiculoTercero...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getUltFechaPago(): Retorna Ultima Fecha de Pago       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peNrdf   ( input  ) Filiatorio de Beneficiario           *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *     peRiec   ( input  ) Código de Riesgo                     *
      *     peXcob   ( input  ) Código de Cobertura                  *
      *     peFech   ( output ) Fecha de Pago                        *
      *     peMone   ( output ) Moneda                               *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_getUltFechaPago...
     P                 B                   export
     D SVPSIN_getUltFechaPago...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peFech                       8  0 options(*omit:*nopass)
     D   peMone                       2    options(*omit:*nopass)

     D k1yshp          ds                  likerec(p1hshp:*key)

      /free

       SVPSIN_inz();

       k1yshp.hpEmpr = peEmpr;
       k1yshp.hpSucu = peSucu;
       k1yshp.hpRama = peRama;
       k1yshp.hpSini = peSini;
       k1yshp.hpNops = peNops;

       select;
         when %parms >= 11 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) <> *null;

           k1yshp.hpPoco =  pePoco;
           k1yshp.hpPaco =  pePaco;
           k1yshp.hpNrdf =  peNrdf;
           k1yshp.hpSebe =  peSebe;
           k1yshp.hpRiec =  peRiec;
           k1yshp.hpXcob =  peXcob;
           setgt %kds( k1yshp : 11 ) pahshp;
           readpe(n) %kds( k1yshp : 11 ) pahshp;
           dow %eof( pahshp );
             return *off;
           enddo;

         when %parms >= 10 and %addr( pePoco ) <> *null
                           and %addr( pePaco ) <> *null
                           and %addr( peNrdf ) <> *null
                           and %addr( peSebe ) <> *null
                           and %addr( peRiec ) <> *null
                           and %addr( peXcob ) =  *null;

           k1yshp.hpPoco =  pePoco;
           k1yshp.hpPaco =  pePaco;
           k1yshp.hpNrdf =  peNrdf;
           k1yshp.hpSebe =  peSebe;
           k1yshp.hpRiec =  peRiec;
           setgt %kds( k1yshp : 10 ) pahshp;
           readpe(n) %kds( k1yshp : 10 ) pahshp;
           dow %eof( pahshp );
             return *off;
           enddo;

         when %parms >= 9 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peNrdf ) <> *null
                          and %addr( peSebe ) <> *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null;

           k1yshp.hpPoco =  pePoco;
           k1yshp.hpPaco =  pePaco;
           k1yshp.hpNrdf =  peNrdf;
           k1yshp.hpSebe =  peSebe;
           setgt %kds( k1yshp : 9 ) pahshp;
           readpe(n) %kds( k1yshp : 9 ) pahshp;
           dow %eof( pahshp );
             return *off;
           enddo;

         when %parms >= 8 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peNrdf ) <> *null
                          and %addr( peSebe ) =  *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null;

           k1yshp.hpPoco =  pePoco;
           k1yshp.hpPaco =  pePaco;
           k1yshp.hpNrdf =  peNrdf;
           setgt %kds( k1yshp : 8 ) pahshp;
           readpe(n) %kds( k1yshp : 8 ) pahshp;
           dow %eof( pahshp );
             return *off;
           enddo;

         when %parms >= 7 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) <> *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null;

           k1yshp.hpPoco =  pePoco;
           k1yshp.hpPaco =  pePaco;
           setgt %kds( k1yshp : 7 ) pahshp;
           readpe(n) %kds( k1yshp : 7 ) pahshp;
           dow %eof( pahshp );
             return *off;
           enddo;

         when %parms >= 6 and %addr( pePoco ) <> *null
                          and %addr( pePaco ) =  *null
                          and %addr( peNrdf ) =  *null
                          and %addr( peSebe ) =  *null
                          and %addr( peRiec ) =  *null
                          and %addr( peXcob ) =  *null;

           k1yshp.hpPoco =  pePoco;
           setgt %kds( k1yshp : 6 ) pahshp;
           readpe(n) %kds( k1yshp : 6 ) pahshp;
           dow %eof( pahshp );
             return *off;
           enddo;

         other;

           setgt %kds( k1yshp : 5 ) pahshp;
           readpe(n) %kds( k1yshp : 5 ) pahshp;
           dow %eof( pahshp );
             return *off;
           enddo;

       endsl;

       if %addr( peFech ) <> *null;
         peFech = ( hpFasa * 10000 )
                + ( hpFasm * 100   )
                +   hpFasd;
       endif;

       if %addr( peMone ) <> *null;
         peMone = hpMonr;
       endif;

       return *on;

      /end-free

     P SVPSIN_getUltFechaPago...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_terminarSiniestro(): Finaliza Siniestro               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_terminarSiniestro...
     P                 B                   export
     D SVPSIN_terminarSiniestro...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D @@ds456         ds                  likeds( DsSet456_t )
     D @@Ds402         ds                  likeds( DsSet402_t )

     D @@chks          s                   like(*in50)
     D rc              s               n
     D rc1             s               n
     D rc2             s               n
     D rc3             s               n

     D peDsRe          ds                  likeds( DsReclamos_t ) dim(999)
     D peDsReC         s             10i 0
     D @x              s             10i 0
     D @CantEstRech    s             10i 0

      /free

       SVPSIN_inz();

       if SVPSIN_chkStroEnJuicio( peEmpr
                                : peSucu
                                : peRama
                                : peSini
                                : peNops) = *on;
          return *off;
       endif;

       if SVPSIN_chkSiniPend(peEmpr
                            :peSucu
                            :peRama
                            :peSini
                            :peNops) = *off ;
          return *off;
       endif;

       if SVPSIN_getSet456( peEmpr
                          : peSucu
                          : @@Ds456) = *off;
          return *off;
       endif;

       if SVPSIN_getSet402( peEmpr
                          : peSucu
                          : peRama
                          : 2
                          : @@Ds402) = *off;
         return *off;
       endif;

       // --------------------------------------------------------------
       // FAS: Si la Rama es Autos, busco al menos que uno de los Estados
       // del Reclamos sea Rechazado
       if SVPRVS_chkRamaAuto( peRama ) = *on ;
         SVPSIN_getReclamosXStro( peEmpr
                                : peSucu
                                : peRama
                                : peSini
                                : peNops
                                : peDsRe
                                : peDsReC );
         @CantEstRech = *zeros;
         for @x = 1 to peDsReC;
           if peDsRe(@x).reCesi = 5;
             // Al encontrar al menos un Reclamo en Estado "Terminado"
             // El Estado final del Siniestro sera "Terminado"
             leave;
           elseif peDsRe(@x).reCesi = 2;
             // Si TODOS los Reclamo del Siniestro son Estado "Rechazado"
             // El Estado final del Siniestro sera "Rechazado"
             @CantEstRech += 1;
           endif;
         endfor;
         if peDsReC = @CantEstRech;
           if SVPSIN_getSet402( peEmpr
                              : peSucu
                              : peRama
                              : 96
                              : @@Ds402) = *off;
             return *off;
           endif;
         endif;
       endif;


       if SVPSIN_wrtEstSin( peEmpr
                           : peSucu
                           : peRama
                           : peSini
                           : peNops
                           : @@Ds456.t@fema
                           : @@Ds456.t@femm
                           : @@Ds456.t@femd
                           : @@Ds402.t@cesi
                           : @@Ds402.t@cese
                           : @@Ds402.t@mar1) = *off;
         return *off;
       endif;

       if SVPSIN_terminarCaratula( peEmpr
                                 : peSucu
                                 : peRama
                                 : peSini
                                 : peNops
                                 : @@Ds402.t@cesi
                                 : @@Ds402.t@cese
                                 : @@Ds402.t@mar1) = *off;
         return *off;
       endif;

       return *on;

      /end-free

     P SVPSIN_terminarSiniestro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_terminarReclamo(): Finaliza los Reclamos de un        *
      *                            Siniestro                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_terminarReclamo...
     P                 B                   export
     D SVPSIN_terminarReclamo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1ysbe          ds                  likerec(p1hsbe:*key)
     D k1ysb1          ds                  likerec(p1hsb102:*key)
     D k1y456          ds                  likerec(s1t456:*key)
     D @@ds456         ds                  likeds( DsSet456_t )


      /free

       SVPSIN_inz();

         if SVPSIN_chkStroEnJuicio( peEmpr
                                  : peSucu
                                  : peRama
                                  : peSini
                                  : peNops) = *on;
            return *off;
         endif;

        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *off;
          return *off;
        endif;

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       setll %kds(k1ysbe:5) pahsbe;
       reade %kds(k1ysbe:5) pahsbe;
       dow not %eof;

          k1ysb1.b1empr = beEmpr;
          k1ysb1.b1sucu = beSucu;
          k1ysb1.b1rama = beRama;
          k1ysb1.b1sini = beSini;
          k1ysb1.b1nops = beNops;
          k1ysb1.b1nrdf = beNrdf;
          setll %kds(k1ysb1:6) pahsb102;
          reade %kds(k1ysb1:6) pahsb102;
          if not %eof(pahsb102);
           if SVPSIN_terminarReclamoStro( peEmpr
                                        : peSucu
                                        : peRama
                                        : peSini
                                        : peNops
                                        : bePoco
                                        : bePaco
                                        : beRiec
                                        : beXcob
                                        : beNrdf
                                        : beSebe
                                        : b1Cesi
                                        : b1Recl
                                        : b1Ctle
                                        : b1Hecg
                                        : @@Ds456.t@fema
                                        : @@Ds456.t@femm
                                        : @@Ds456.t@femd ) = *on;
           endif;
          endif;
       reade %kds(k1ysbe:5) pahsbe;
       enddo;

       return *on;

      /end-free

     P SVPSIN_terminarReclamo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_nivelarRvaStro() : Nivelar las Reservas de un         *
      *                           Siniestro.                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_nivelarRvaStro...
     P                 B                   export
     D SVPSIN_nivelarRvaStro...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 const options(*omit:*nopass)

     D @@DsBe          ds                  likeds(DsPahsbe_t) dim(999)
     D @@DsBeC         s             10i 0
     D @@ds456         ds                  likeds( DsSet456_t )
     D @@mact          s             25  2
     D @1mact          s             25  2
     D @@fech          s              8  0
     D X               s             10i 0

      /free

       SVPSIN_inz();

       if %parms >= 6 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return *off;
         endif;
          @@fech = pefech ;
         else;
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *on;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
         else;
          return *off;
        endif;
       endif;

         if SVPSIN_chkStroEnJuicio( peEmpr
                                  : peSucu
                                  : peRama
                                  : peSini
                                  : peNops) = *off;



            if SVPSIN_getBeneficiarios( peEmpr
                                      : peSucu
                                      : peRama
                                      : peSini
                                      : peNops
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : @@DsBe
                                      : @@DsBeC ) = *on;

              for x = 1 to @@DsBeC;

                  if SVPSIN_nivelarRvaStroBenef( peEmpr
                                               : peSucu
                                               : peRama
                                               : peSini
                                               : peNops
                                               : @@DsBe(x).beNrdf
                                               : @@Fech ) = *on;
                  endif;

              endfor;

            endif;

         endif;

       return *on;

      /end-free

     P SVPSIN_nivelarRvaStro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_terminarCaratula(): Finaliza Carátula                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peCesi   (input)   Estado Siniestro                      *
      *     peCese   (input)   Estado Siniestro Equivalente          *
      *     peTerm   (input)   Codigo Terminado                      *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_terminarCaratula...
     P                 B                   export
     D SVPSIN_terminarCaratula...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peCesi                       2  0 const
     D   peCese                       2    const
     D   peTerm                       1    const

     D k1yscd          ds                  likerec( p1hscd : *key )

      /free

       SVPSIN_inz();

       k1yscd.cdempr = peEmpr;
       k1yscd.cdsucu = peSucu;
       k1yscd.cdrama = peRama;
       k1yscd.cdsini = peSini;
       k1yscd.cdnops = peNops;
       chain %kds(k1yscd) pahscd;
         if %found;
           cdcesi = peCesi;
           cdcese = peCese;
           cdterm = peTerm;
          update p1hscd;
         else;
         SetError( SVPSIN_CARNE
                 : 'Caratula no encontrada' );
          return *off;
         endif;

       return *on;

      /end-free

     P SVPSIN_terminarCaratula...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getSet402() : Obtiene Set402                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peCesi   (input)   Estado Siniestro                      *
      *     peDs402  (output)  Estructura SET402                     *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_getSet402...
     P                 B                   export
     D SVPSIN_getSet402...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peCesi                       2  0 const
     D   peDs402                           likeds ( DsSET402_t )

     D k1y402          ds                  likerec( s1t402 : *key )
     D @@Ds402         ds                  likerec( s1t402 : *input )

      /free

       SVPSIN_inz();

       clear peDs402;
       k1y402.t@empr = peEmpr;
       k1y402.t@sucu = peSucu;
       k1y402.t@rama = peRama;
       k1y402.t@cesi = peCesi;
       chain %kds(k1y402) set402 @@Ds402;
       if %found(set402);
         eval-corr peDs402 = @@Ds402;
        else;
         SetError( SVPSIN_402NE
                 : 'SET402 no encontrado' );
         return *off;
       endif;

       return *on;

      /end-free

     P SVPSIN_getSet402...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getSet456() : Obtiene SET456                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peDs456  (output)  Estructura SET456                     *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_getSet456...
     P                 B                   export
     D SVPSIN_getSet456...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDs456                           likeds ( DsSET456_t )

     D k1y456          ds                  likerec( s1t456 : *key )
     D @@Ds456         ds                  likerec( s1t456 : *input )

      /free

       SVPSIN_inz();

       clear peDs456;
       k1y456.t@empr = peEmpr;
       k1y456.t@sucu = peSucu;
       chain %kds(k1y456) set456 @@Ds456;
       if %found(set456);
         eval-corr peDs456 = @@Ds456;
        else;
         SetError( SVPSIN_456NE
                 : 'SET456 no encontrado' );
         return *off;
       endif;

       return *on;

      /end-free

     P SVPSIN_getSet456...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_wrtEstSin() : Grabo Estado Siniestro                  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFema   (input)   Fecha Año Movimiento                  *
      *     peFemm   (input)   Fecha Mes Movimiento                  *
      *     peFemd   (input)   Fecha Día Movimiento                  *
      *     peCesi   (input)   Estado Siniestro                      *
      *     peCese   (input)   Estado Siniestro Equivalente          *
      *     peTerm   (input)   Codigo Terminado                      *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_wrtEstSin...
     P                 B                   export
     D SVPSIN_wrtEstSin...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peFemd                       2  0 const
     D   peCesi                       2  0 const
     D   peCese                       2    const
     D   peTerm                       1    const

     D k1yshe          ds                  likerec(p1hshe01:*key)
     D @@ds456         ds                  likeds( DsSet456_t )

     D wwpsec          s                   like(hepsec)

      /free
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *off;
          return *off;
        endif;

       SVPSIN_inz();

       k1yshe.heEmpr = peEmpr;
       k1yshe.heSucu = peSucu;
       k1yshe.heRama = peRama;
       k1yshe.heNops = peNops;
       k1yshe.heSini = peSini;
       setgt %kds( k1yshe : 5 ) pahshe01;
       readpe(n) %kds( k1yshe : 5 ) pahshe01;
         if %eof;
           wwpsec = 1 ;
            else;
           wwpsec = hepsec + 1 ;
         endif;
          heempr = peempr;
          hesucu = pesucu;
          herama = perama;
          hesini = pesini;
          henops = penops;
          hefema = @@Ds456.t@fema;
          hefemm = @@Ds456.t@femm;
          hefemd = @@Ds456.t@femd;
          hepsec = wwpsec;
          hecesi = pecesi;
          hecese = pecese;
          heterm = peterm;
          hemar1 = *off  ;
          hemar2 = *off  ;
          hemar3 = *off  ;
          hemar4 = *off  ;
          hemar5 = *off  ;
          heuser = ususr2;
          hetime = %dec(%time():*iso);
          hefera = *year ;
          heferm = umonth;
          heferd = uday  ;

         write p1hshe01 ;

       return *on;

      /end-free

     P SVPSIN_wrtEstSin...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getRvaStro() : Obtengo Reserva del Siniestro          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Importe de Reserva                                  *
      * ------------------------------------------------------------ *

     P SVPSIN_getRvaStro...
     P                 B                   export
     D SVPSIN_getRvaStro...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D @@DsBe          ds                  likeds(DsPahsbe_t) dim(999)
     D @@DsBeC         s             10i 0
     D @@ds456         ds                  likeds( DsSet456_t )
     D @@mact          s             25  2
     D @1mact          s             25  2
     D @@fech          s              8  0
     D X               s             10i 0

      /free


       SVPSIN_inz();

       if %parms >= 6 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return 0;
         endif;
          @@fech = pefech ;
         else;
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *on;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
         else;
          return 0;
        endif;
       endif;

            clear @@DsBe;
            clear @@DsBeC;
            @@mact = *Zeros;
            @1mact = *Zeros;

            if SVPSIN_getBeneficiarios( peEmpr
                                      : peSucu
                                      : peRama
                                      : peSini
                                      : peNops
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : @@DsBe
                                      : @@DsBeC ) = *on;

              for x = 1 to @@DsBeC;

                 @@mact = SVPSIN_getRva( peEmpr
                                       : peSucu
                                       : peRama
                                       : peSini
                                       : peNops
                                       : @@DsBe(x).beNrdf
                                       : @@Fech
                                       : @@DsBe(x).beRiec
                                       : @@DsBe(x).beXcob );
                 @1mact += @@mact;
              endfor;
            endif;

        return @1mact;

      /end-free

     P SVPSIN_getRvaStro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getFraStro() : Obtengo Franquicia del Siniestro       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Importe de Franquicia                               *
      * ------------------------------------------------------------ *

     P SVPSIN_getFraStro...
     P                 B                   export
     D SVPSIN_getFraStro...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D @@DsBe          ds                  likeds(DsPahsbe_t) dim(999)
     D @@ds456         ds                  likeds( DsSet456_t )
     D @@DsBeC         s             10i 0
     D @@mact          s             25  2
     D @1mact          s             25  2
     D @@fech          s              8  0
     D X               s             10i 0

      /free


       SVPSIN_inz();

       if %parms >= 6 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return 0;
         endif;
          @@fech = pefech ;
         else;
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *on;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
         else;
          return 0;
        endif;
       endif;

            clear @@DsBe;
            clear @@DsBeC;
            @@mact = *Zeros;
            @1mact = *Zeros;

            if SVPSIN_getBeneficiarios( peEmpr
                                      : peSucu
                                      : peRama
                                      : peSini
                                      : peNops
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : @@DsBe
                                      : @@DsBeC ) = *on;

              for x = 1 to @@DsBeC;

                 @@mact = SVPSIN_getFra( peEmpr
                                       : peSucu
                                       : peRama
                                       : peSini
                                       : peNops
                                       : @@DsBe(x).beNrdf
                                       : @@Fech );
                 @1mact += @@mact;

              endfor;

            endif;

        return @1mact;

      /end-free

     P SVPSIN_getFraStro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getPagStro() : Obtengo Pagos del Siniestro            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Importe de Pagos                                    *
      * ------------------------------------------------------------ *

     P SVPSIN_getPagStro...
     P                 B                   export
     D SVPSIN_getPagStro...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D @@DsBe          ds                  likeds(DsPahsbe_t) dim(999)
     D @@DsBeC         s             10i 0
     D @@ds456         ds                  likeds( DsSet456_t )
     D @@mact          s             25  2
     D @1mact          s             25  2
     D @@fech          s              8  0
     D X               s             10i 0

      /free


       SVPSIN_inz();

       if %parms >= 6 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return 0;
         endif;
          @@fech = pefech ;
         else;
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *on;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
         else;
          return 0;
        endif;
       endif;

            clear @@DsBe;
            clear @@DsBeC;
            @@mact = *Zeros;
            @1mact = *Zeros;

            if SVPSIN_getBeneficiarios( peEmpr
                                      : peSucu
                                      : peRama
                                      : peSini
                                      : peNops
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : @@DsBe
                                      : @@DsBeC ) = *on;

              for x = 1 to @@DsBeC;

                 @@mact = SVPSIN_getPag( peEmpr
                                       : peSucu
                                       : peRama
                                       : peSini
                                       : peNops
                                       : @@DsBe(x).beNrdf
                                       : @@Fech );
                 @1mact += @@mact;
              endfor;
            endif;

        return @1mact;

      /end-free

     P SVPSIN_getPagStro...
     P                 E


      * ------------------------------------------------------------ *
      * SVPSIN_getRvaActStro() : Obtengo Reserva Actual del          *
      *                          Siniestro                           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Importe Reserva Neta de Franquicias y Pagos.(SAP)   *
      * ------------------------------------------------------------ *

     P SVPSIN_getRvaActStro...
     P                 B                   export
     D SVPSIN_getRvaActStro...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 const options(*omit:*nopass)

     D @@DsBe          ds                  likeds(DsPahsbe_t) dim(999)
     D @@DsBeC         s             10i 0
     D @@mact          s             25  2
     D @1mact          s             25  2
     D @@ds456         ds                  likeds( DsSet456_t )
     D @@fech          s              8  0

     D @@Rva           s             15  2
     D @@Fra           s             15  2
     D @@Pag           s             15  2

      /free


       SVPSIN_inz();

       if %parms >= 6 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return 0;
         endif;
          @@fech = pefech ;
         else;
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *on;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
         else;
          return 0;
        endif;
       endif;

        @@Rva = SVPSIN_getRvaStro( peEmpr
                                 : peSucu
                                 : peRama
                                 : peSini
                                 : peNops
                                 : @@Fech );
        @@Fra = SVPSIN_getFraStro( peEmpr
                                 : peSucu
                                 : peRama
                                 : peSini
                                 : peNops
                                 : @@Fech );
        @@Pag = SVPSIN_getPagStro( peEmpr
                                 : peSucu
                                 : peRama
                                 : peSini
                                 : peNops
                                 : @@Fech );

        @@Rva = @@Rva - @@Fra - @@Pag;
        Return @@Rva;

      /end-free

     P SVPSIN_getRvaActStro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkStroEnJuicio() : Chequeo si el Siniestro esta en   *
      *                          Juicio                              *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_chkStroEnJuicio...
     P                 B                   export
     D SVPSIN_chkStroEnJuicio...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 const options(*omit:*nopass)

     D @@DsBe          ds                  likeds(DsPahsbe_t) dim(999)
     D @@DsBeC         s             10i 0
     D @@ds456         ds                  likeds( DsSet456_t )
     D @@fech          s              8  0
     D X               s             10i 0

      /free


       SVPSIN_inz();

       if %parms >= 6 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return *off;
         endif;
          @@fech = pefech ;
         else;
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *on;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
         else;
          return *off;
        endif;
       endif;

            if SVPSIN_getBeneficiarios( peEmpr
                                      : peSucu
                                      : peRama
                                      : peSini
                                      : peNops
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : @@DsBe
                                      : @@DsBeC ) = *on;

              for x = 1 to @@DsBeC;

                 if SVPSIN_chkbenefJuicio( peEmpr
                                         : peSucu
                                         : peRama
                                         : peSini
                                         : peNops
                                         : @@DsBe(x).beNrdf) = *on;
                        SetError( SVPSIN_BEJUI
                                : 'Beneficiario en Juicio' );
                        return *on;
                 endif;

              endfor;
            endif;

       return *off;
      /end-free

     P SVPSIN_chkStroEnJuicio...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_nivelarRvaStroBenef() :  Nivelar las reservas de un   *
      *                                 Beneficiario.                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *on / *off  *on = Nivelo Ok / *off = No nivelo      *
      * ------------------------------------------------------------ *

     P SVPSIN_nivelarRvaStroBenef...
     P                 B                   export
     D SVPSIN_nivelarRvaStroBenef...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D @@ds456         ds                  likeds( DsSet456_t )
     D  @@fech         s              8  0
     D  @@mact         s             25  2

      /free

       SVPSIN_inz();

       if %parms >= 7 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return *off;
         endif;
          @@fech = pefech ;
         else;
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *on;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
         else;
          return *off;
        endif;
       endif;

          @@mact = SVPSIN_getRvaAct( peEmpr
                                   : peSucu
                                   : peRama
                                   : peSini
                                   : peNops
                                   : peNrdf
                                   : @@Fech );
         if @@mact <> *zeros;

          @@mact = @@mact * -1;

           if SVPSIN_setPahshr( peEmpr : peSucu : peRama : peSini :
                                peNops : peNrdf : @@mact : ususr2 :
                                peFech ) = *on;
            return *on;
           endif;

         endif;

       return *off;

      /end-free

     P SVPSIN_nivelarRvaStroBenef...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_terminarReclamoStro(): Finaliza un Reclamo de         *
      *                               Siniestro                      *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     pePoco   (input)   Nro de Componente                     *
      *     pePaco   (input)   Código de Parentesco                  *
      *     periec   (input)   Código de Riesgo                      *
      *     pexcob   (input)   Código de Cobertura                   *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peSebe   (input)   Sec. Benef. Siniestros                *
      *     peCesi   (input)   Estado del Siniestro                  *
      *     peRecl   (input)   Número de Reclamo                     *
      *     peCtle   (input)   Tipo de Lesiones                      *
      *     peHecg   (input)   Hecho Generador                       *
      *     peFema   (input)   Fecha Año Movimiento                  *
      *     peFemm   (input)   Fecha Mes Movimiento                  *
      *     peFemd   (input)   Fecha Día Movimiento                  *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_terminarReclamoStro...
     P                 B                   export
     D SVPSIN_terminarReclamoStro...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peCesi                       2  0 const
     D   peRecl                       3  0 const
     D   peCtle                       2    const
     D   peHecg                       1    const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peFemd                       2  0 const

     D k1ysb1          ds                  likerec(p1hsb1:*key)
     D k1y456          ds                  likerec(s1t456:*key)
     D @@ds456         ds                  likeds( DsSet456_t )


      /free

       SVPSIN_inz();


       k1ysb1.b1empr = peEmpr;
       k1ysb1.b1sucu = peSucu;
       k1ysb1.b1rama = peRama;
       k1ysb1.b1sini = peSini;
       k1ysb1.b1nops = peNops;
       k1ysb1.b1poco = pePoco;
       k1ysb1.b1paco = pePaco;
       k1ysb1.b1riec = peRiec;
       k1ysb1.b1xcob = peXcob;
       k1ysb1.b1nrdf = peNrdf;
       k1ysb1.b1sebe = peSebe;
       k1ysb1.b1fema = peFema;
       k1ysb1.b1femm = peFemm;
       k1ysb1.b1femd = peFemd;
       chain %kds(k1ysb1) pahsb1;

           b1empr = peEmpr;
           b1sucu = peSucu;
           b1rama = peRama;
           b1sini = peSini;
           b1nops = peNops;
           b1poco = pePoco;
           b1paco = pePaco;
           b1riec = peRiec;
           b1xcob = peXcob;
           b1nrdf = peNrdf;
           b1sebe = peSebe;
           b1fema = pefema;
           b1femm = pefemm;
           b1femd = pefemd;
           b1cesi = peCesi;
           if peCesi = 01;
           b1cesi = 05;
           endif;
           b1user = ususr2;
           b1fera = pefema;
           b1ferm = pefemm;
           b1ferd = pefemd;
           b1recl = peRecl;
           b1ctle = peCtle;
           b1hecg = peHecg;

         if not %found(pahsb1);
          write p1hsb1;
           else;
          update p1hsb1;
         endif;

       return *on;

      /end-free

     P SVPSIN_TerminarReclamoStro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_nivelarFraStro() : Nivelar las Franquicias de un      *
      *                           Siniestro.                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_nivelarFraStro...
     P                 B                   export
     D SVPSIN_nivelarFraStro...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 const options(*omit:*nopass)

     D @@DsBe          ds                  likeds(DsPahsbe_t) dim(999)
     D @@DsBeC         s             10i 0
     D @@ds456         ds                  likeds( DsSet456_t )
     D @@mact          s             25  2
     D @1mact          s             25  2
     D @@fech          s              8  0
     D X               s             10i 0

      /free

       SVPSIN_inz();

       if %parms >= 6 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return *off;
         endif;
          @@fech = pefech ;
         else;
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *on;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
         else;
          return *off;
        endif;
       endif;

         if SVPSIN_chkStroEnJuicio( peEmpr
                                  : peSucu
                                  : peRama
                                  : peSini
                                  : peNops) = *off;



            if SVPSIN_getBeneficiarios( peEmpr
                                      : peSucu
                                      : peRama
                                      : peSini
                                      : peNops
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : @@DsBe
                                      : @@DsBeC ) = *on;

              for x = 1 to @@DsBeC;

                  if SVPSIN_nivelarFraStroBenef( peEmpr
                                               : peSucu
                                               : peRama
                                               : peSini
                                               : peNops
                                               : @@DsBe(x).beNrdf
                                               : @@Fech ) = *on;
                  endif;

              endfor;

            endif;

         endif;

       return *on;

      /end-free

     P SVPSIN_nivelarFraStro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_nivelarFraStroBenef() :  Nivelar las Franquicias de   *
      *                                 un Beneficiario.             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *on / *off  *on = Nivelo Ok / *off = No nivelo      *
      * ------------------------------------------------------------ *

     P SVPSIN_nivelarFraStroBenef...
     P                 B                   export
     D SVPSIN_nivelarFraStroBenef...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D @@ds456         ds                  likeds( DsSet456_t )
     D  @@fech         s              8  0
     D  @@mact         s             25  2

      /free

       SVPSIN_inz();

       if %parms >= 7 and %addr(peFech) <> *Null;
         if not SPVFEC_FechaValida8 ( peFech );
           return *off;
         endif;
          @@fech = pefech ;
         else;
        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *on;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
         else;
          return *off;
        endif;
       endif;

          @@mact = SVPSIN_getFra( peEmpr
                                : peSucu
                                : peRama
                                : peSini
                                : peNops
                                : peNrdf
                                : @@Fech );
         if @@mact <> *zeros;

          @@mact = @@mact * -1;

           if SVPSIN_setPahsfr( peEmpr : peSucu : peRama : peSini :
                                peNops : peNrdf : @@mact : ususr2 ) = *on;
            return *on;
           endif;

         endif;

       return *off;

      /end-free

     P SVPSIN_nivelarFraStroBenef...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getCaratula2():Retorna Carátula de Denuncia de        *
      *                       Siniestro (sin NOPS).                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDsCd   ( output ) Estructura de Carátula de Siniestro  *
      *     peDsCdC  ( output ) Cantidad de Carátula de Siniestro    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getCaratula2...
     P                 B                   export
     D SVPSIN_getCaratula2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peDsCd                            likeds ( DsPahscd_t )

     D k1hscd          ds                  likerec( p1hscd : *key   )

      /free

       SVPSIN_inz();

       k1hscd.cdEmpr = peEmpr;
       k1hscd.cdSucu = peSucu;
       k1hscd.cdRama = peRama;
       k1hscd.cdSini = peSini;
       chain %kds( k1hscd : 4 ) pahscd;
       if not %found( pahscd );
          return *off;
       endif;
       unlock pahscd;
       return SVPSIN_getCaratula( peEmpr
                                : peSucu
                                : peRama
                                : peSini
                                : cdnops
                                : peDscd );

      /end-free

     P SVPSIN_getCaratula2...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getPahSc1():   Retorna registro de PAHSC1.            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDsC1   ( output ) Estructura de PAHSC1                 *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getPahSc1...
     P                 B                   export
     D SVPSIN_getPahSc1...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peDsC1                            likeds ( DsPahsc1_t )

     D k1hsc1          ds                  likerec( p1hsc1 : *key   )
     D inSc1           ds                  likerec( p1hsc1 : *input )

      /free

       SVPSIN_inz();

       clear peDsC1;

       k1hsc1.cd1Empr = peEmpr;
       k1hsc1.cd1Sucu = peSucu;
       k1hsc1.cd1Rama = peRama;
       k1hsc1.cd1Sini = peSini;
       chain %kds( k1hsc1 : 4 ) pahsc1 inSc1;
       if not %found( pahsc1 );
          return *off;
       endif;

       eval-corr peDsC1 = inSc1;

       return *on;

      /end-free

     P SVPSIN_getPahSc1...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getPahSd1():   Retorna registro de PAHSD1.            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDsC1   ( output ) Estructura de PAHSD1                 *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getPahSd1...
     P                 B                   export
     D SVPSIN_getPahSd1...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peDsD1                            likeds ( DsPahsd1_t )

     D k1hsd1          ds                  likerec( p1hsd1 : *key   )
     D inSd1           ds                  likerec( p1hsd1 : *input )

      /free

       SVPSIN_inz();

       clear peDsD1;

       k1hsd1.d1Empr = peEmpr;
       k1hsd1.d1Sucu = peSucu;
       k1hsd1.d1Rama = peRama;
       k1hsd1.d1Sini = peSini;
       chain %kds( k1hsd1 : 4 ) pahsd1 inSd1;
       if not %found( pahsd1 );
          return *off;
       endif;

       eval-corr peDsD1 = inSd1;

       return *on;

      /end-free

     P SVPSIN_getPahSd1...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getPahSd2():   Retorna registro de PAHSD2.            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDsC1   ( output ) Estructura de PAHSD2                 *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getPahSd2...
     P                 B                   export
     D SVPSIN_getPahSd2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peDsD2                            likeds ( DsPahsd2_t )

     D k1hsd2          ds                  likerec( p1hsd2 : *key   )
     D inSd2           ds                  likerec( p1hsd2 : *input )

      /free

       SVPSIN_inz();

       clear peDsD2;

       k1hsd2.d2Empr = peEmpr;
       k1hsd2.d2Sucu = peSucu;
       k1hsd2.d2Rama = peRama;
       k1hsd2.d2Sini = peSini;
       chain %kds( k1hsd2 : 4 ) pahsd2 inSd2;
       if not %found( pahsd2 );
          return *off;
       endif;

       eval-corr peDsD2 = inSd2;

       return *on;

      /end-free

     P SVPSIN_getPahSd2...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getPahStc():   Retorna registro de PAHSTC.            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDsT1   ( output ) Estructura de PAHSTC                 *
      *     peDsT1c  ( output ) Contador de PAHSTC                   *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getPahStc...
     P                 B                   export
     D SVPSIN_getPahStc...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peDsTc                            likeds ( DsPahstc_t ) dim(999)
     D   peDsTcC                     10i 0

     D k1hstc          ds                  likerec( p1hstc : *key   )
     D inStc           ds                  likerec( p1hstc : *input )

      /free

       SVPSIN_inz();

       clear peDsTc;
       pedstcc = *zeros ;

       k1hstc.stEmpr = peEmpr;
       k1hstc.stSucu = peSucu;
       k1hstc.stRama = peRama;
       k1hstc.stSini = peSini;
        setll %kds( k1hstc : 4 ) pahstc;
        reade %kds( k1hstc : 4 ) pahstc inStc;
        dow not %eof( pahstc );
          pedstcc = peDsTcC + 1;
          eval-corr peDsTc ( peDsTcC ) = inStc;
        reade %kds( k1hstc : 4 ) pahstc inStc;
        enddo;

       if pedstcc =*zeros;
          return *off;
       endif;

       return *on;

      /end-free

     P SVPSIN_getPahStc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getPahSD0():   Retorna registro de PAHSD0.            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDss0   ( output ) Estructura de PAHSD0                 *
      *     peDss0c  ( output ) Contador de PAHSD0                   *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getPahSd0...
     P                 B                   export
     D SVPSIN_getPahSd0...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peDsD0                            likeds ( DsPahsd0_t ) dim(999)
     D   peDsD0C                     10i 0

     D k1hsd0          ds                  likerec( p1hsd0 : *key   )
     D inSd0           ds                  likerec( p1hsd0 : *input )

      /free

       SVPSIN_inz();

       clear peDsd0;
       clear inSd0;
       pedsd0c = *zeros ;

       k1hsd0.d0empr = peEmpr;
       k1hsd0.d0sucu = peSucu;
       k1hsd0.d0rama = peRama;
       k1hsd0.d0sini = peSini;
       setll %kds( k1hsd0 : 4 ) pahsd0;
       reade %kds( k1hsd0 : 4 ) pahsd0 inSd0;
       dow not %eof( pahsd0 );
           peDsD0c += 1;
           eval-corr peDsD0(peDsD0C) = inSd0;
       reade %kds( k1hsd0 : 4 ) pahsd0 inSd0;
       enddo;

       if peDsd0C = *zeros;
          return *off;
       endif;

       return *on;

      /end-free

     P SVPSIN_getPahSd0...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkNroOperStro(): Valida exixtencia de nro.de opera_  *
      *                          cion de siniestro.                  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *on =Encontrado   / *off= Inexistente               *
      * ------------------------------------------------------------ *

     P SVPSIN_chkNroOperStro...
     P                 B                   export
     D SVPSIN_chkNroOperStro...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peNops                       7  0 const
      * Define Clave
     D k1yscd01        ds                  likerec(p1hscd01:*key)

      /free

       SVPSIN_inz();

       // Uso imput para armar claves
       k1yscd01.cdempr = peEmpr;
       k1yscd01.cdsucu = peSucu;
       k1yscd01.cdrama = peRama;
       k1yscd01.cdnops = peNops;

       // Posiciono
       setll %kds(k1yscd01:4) pahscd01;

       // Existe Devuelve on all llamador
       if %equal(pahscd01);
         return *On;
       endif;

       // InExistente Devuelve off al llamador
       return *off;

      /end-free

     P SVPSIN_chkNroOperStro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getSiniestroDesdeNops(): Devuelve numero de Siniestro *
      *                                 de una operacion de siniestro*
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peSini   (output)  Numero de Siniestro                   *
      *                                                              *
      * Retorna: Numero de Siniestro  o 0 si no encontro con la clave*
      * ------------------------------------------------------------ *

     P SVPSIN_getSiniestroDesdeNops...
     P                 B                   export
     D SVPSIN_getSiniestroDesdeNops...
     D                 pi             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peNops                       7  0 const
      * Define Clave
     D   @@Sini        s              7  0
      * Define Clave
     D k1yscd01        ds                  likerec(p1hscd01:*key)

      /free

       SVPSIN_inz();

       clear @@Sini;
       // Uso imput para armar claves
       k1yscd01.cdempr = peEmpr;
       k1yscd01.cdsucu = peSucu;
       k1yscd01.cdrama = peRama;
       k1yscd01.cdnops = peNops;

       // Leo Caratula
         chain %kds( k1yscd01: 4 ) pahscd01;
       // Inexistente Devuelve -1 all llamador
           if %found( pahscd01 );
        // Existe Devuelve numero de siniestro
           eval @@Sini=cdSini;
           endif;

       return @@Sini;

      /end-free
     P SVPSIN_getSiniestroDesdeNops...
     P                 E

      * ------------------------------------------------------------ *
      * DOT 11/11/2021                                               *
      * SVPSIN_chkSinModificable(): Valida por operacion, que el si_ *
      *              niestro tenga un estado valido para ser modifi_ *
      *              cado (saca la logia del sar907). Usa t@mar3 ='I'*
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On=Modificable / *Off= NO MODIFICABLE              *
      * ------------------------------------------------------------ *

     P SVPSIN_chkSinModificable...
     P                 B                   export
     D SVPSIN_chkSinModificable...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peNops                       7  0 const
      * Define Claves
     D k1yscd01        ds                  likerec(p1hscd01:*key)
     D k1y402          ds                  likerec(s1t402:*key)

      /free

       SVPSIN_inz();

       // Uso imput para armar claves caratula
       k1yscd01.cdempr = peEmpr;
       k1yscd01.cdsucu = peSucu;
       k1yscd01.cdrama = peRama;
       k1yscd01.cdnops = peNops;

       // Leo Caratula por numero de operacion
         chain %kds( k1yscd01: 4 ) pahscd01;

         // Caratula Inexistente devuelvo *off al llamador
         if not %found( pahscd01 );
           SetError( SVPSIN_SINNE
                   : 'Siniestro Inexistente' );
           return *Off;
         endif;

         // Existe armo clave para set402 con la con el ultimo status
         k1y402.t@empr = peEmpr;
         k1y402.t@sucu = peSucu;
         k1y402.t@rama = peRama;
         k1y402.t@cesi = SVPSIN_getEstSin ( peEmpr : peSucu :
                                            peRama : cdSini : peNops );        //ult.Status pahshe04
         chain %kds(k1y402) set402;

         // Devuelve *off = no modificable
         if not %found(set402) or t@mar3 = 'I';
           SetError( SVPSIN_SINNM
                   : 'Siniestro no modificable' );
           return *Off;
         endif;

         // Devuelve *on = La caratula de siniesto esxiste y es modificable
         return *On;

      /end-free

     P SVPSIN_chkSinModificable...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_terminarReclamoV1(): Finaliza los Reclamos de un      *
      *                             Siniestro  Version 1             *
      *                             Agregado de Reclamo.             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peRecl   (input)   Número de Reclamo (Opcional)          *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_terminarReclamoV1...
     P                 B                   export
     D SVPSIN_terminarReclamoV1...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peRecl                       3  0 const options(*nopass:*omit)

     D k1ysbe          ds                  likerec(p1hsbe:*key)
     D k1ysb1          ds                  likerec(p1hsb102:*key)
     D k1y456          ds                  likerec(s1t456:*key)
     D @@ds456         ds                  likeds( DsSet456_t )


      /free

       SVPSIN_inz();

         if SVPSIN_chkStroEnJuicio( peEmpr
                                  : peSucu
                                  : peRama
                                  : peSini
                                  : peNops) = *on;
            return *off;
         endif;

        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *off;
          return *off;
        endif;

       if %parms >= 6  and %addr(peRecl) <> *Null;

        k1ysbe.beempr = peEmpr;
        k1ysbe.besucu = peSucu;
        k1ysbe.berama = peRama;
        k1ysbe.besini = peSini;
        k1ysbe.benops = peNops;
        setll %kds(k1ysbe:5) pahsbe;
        reade %kds(k1ysbe:5) pahsbe;
        dow not %eof;

          k1ysb1.b1empr = beEmpr;
          k1ysb1.b1sucu = beSucu;
          k1ysb1.b1rama = beRama;
          k1ysb1.b1sini = beSini;
          k1ysb1.b1nops = beNops;
          k1ysb1.b1nrdf = beNrdf;
          setll %kds(k1ysb1:6) pahsb102;
          reade %kds(k1ysb1:6) pahsb102;
          if not %eof(pahsb102);
           if b1recl = peRecl;
            if SVPSIN_terminarReclamoStro( peEmpr
                                         : peSucu
                                         : peRama
                                         : peSini
                                         : peNops
                                         : bePoco
                                         : bePaco
                                         : beRiec
                                         : beXcob
                                         : beNrdf
                                         : beSebe
                                         : b1Cesi
                                         : b1Recl
                                         : b1Ctle
                                         : b1Hecg
                                         : @@Ds456.t@fema
                                         : @@Ds456.t@femm
                                         : @@Ds456.t@femd ) = *on;
            endif;
           endif;
          endif;
        reade %kds(k1ysbe:5) pahsbe;
        enddo;

        else;

          SVPSIN_terminarReclamo( peEmpr
                                : peSucu
                                : peRama
                                : peSini
                                : peNops ) ;

       endif;

       return *on;

      /end-free

     P SVPSIN_terminarReclamoV1...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getRvaXReclamo(): Obtengo la Reserva por Reclamo      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peRecl   (input)   Número de Reclamo                     *
      *                                                              *
      * Retorna: Importe de Reserva x Reclamo / *zeros               *
      * ------------------------------------------------------------ *
     P SVPSIN_getRvaXReclamo...
     P                 B                   export
     D SVPSIN_getRvaXReclamo...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peRecl                       3  0 const

     D k1ysbe          ds                  likerec(p1hsbe:*key)
     D k1ysb1          ds                  likerec(p1hsb102:*key)
     D k1y456          ds                  likerec(s1t456:*key)
     D @@ds456         ds                  likeds( DsSet456_t )
     D @@rva           s             15  2
     D @@fra           s             15  2
     D @@pag           s             15  2
     D @@rvatot        s             15  2
     D @@fratot        s             15  2
     D @@pagtot        s             15  2

     D @@rvatotal      s             15  2


      /free

       SVPSIN_inz();

        clear @@rvatot ;
        clear @@fratot ;
        clear @@pagtot ;

        k1ysbe.beempr = peEmpr;
        k1ysbe.besucu = peSucu;
        k1ysbe.berama = peRama;
        k1ysbe.besini = peSini;
        k1ysbe.benops = peNops;
        setll %kds(k1ysbe:5) pahsbe;
        reade %kds(k1ysbe:5) pahsbe;
        dow not %eof;

          k1ysb1.b1empr = beEmpr;
          k1ysb1.b1sucu = beSucu;
          k1ysb1.b1rama = beRama;
          k1ysb1.b1sini = beSini;
          k1ysb1.b1nops = beNops;
          k1ysb1.b1nrdf = beNrdf;
          setll %kds(k1ysb1:6) pahsb102;
          reade %kds(k1ysb1:6) pahsb102;
          if not %eof(pahsb102);
           clear @@rva ;
           clear @@fra ;
           clear @@pag ;
           if b1recl = peRecl;
            @@rva = SVPSIN_getRva( peEmpr
                                 : peSucu
                                 : peRama
                                 : peSini
                                 : peNops
                                 : beNrdf ) ;
            @@fra = SVPSIN_getfra( peEmpr
                                 : peSucu
                                 : peRama
                                 : peSini
                                 : peNops
                                 : beNrdf ) ;
            @@pag = SVPSIN_getpag( peEmpr
                                 : peSucu
                                 : peRama
                                 : peSini
                                 : peNops
                                 : beNrdf ) ;
            @@rvatot += @@rva ;
            @@fratot += @@fra ;
            @@pagtot += @@pag ;
           endif;
          endif;
        reade %kds(k1ysbe:5) pahsbe;
        enddo;

         @@rvatotal = @@rvatot - @@fratot - @@pagtot ;
         Return @@rvatotal ;

      /end-free

     P SVPSIN_getRvaXReclamo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getReclamosXStro() : Obtengo los Reclamos por         *
      *                             Siniestros                       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Devuelve:Estructura con Reclamos x Siniestros                *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_getReclamosXStro...
     P                 B                   export
     D SVPSIN_getReclamosXStro...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peDsRe                            likeds ( DsReclamos_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsReC                     10i 0 options(*nopass:*omit)

     D k1ysbe          ds                  likerec(p1hsbe:*key)
     D k1ysb1          ds                  likerec(p1hsb1:*key)
     D X               s             10i 0



      /free

       SVPSIN_inz();

        if %parms >= 6 and %addr(peDsRe) <> *null;
           clear peDsRe;
        endif;

        if %parms >= 7 and %addr(peDsReC) <> *null;
           peDsReC = 0;
        endif;

        x = 0 ;
        k1ysbe.beempr = peEmpr;
        k1ysbe.besucu = peSucu;
        k1ysbe.berama = peRama;
        k1ysbe.besini = peSini;
        k1ysbe.benops = peNops;
        setll %kds(k1ysbe:5) pahsbe;
        reade %kds(k1ysbe:5) pahsbe;
        dow not %eof;

          k1ysb1.b1empr = beEmpr;
          k1ysb1.b1sucu = beSucu;
          k1ysb1.b1rama = beRama;
          k1ysb1.b1sini = beSini;
          k1ysb1.b1nops = beNops;
          k1ysb1.b1poco = bePoco;
          k1ysb1.b1paco = bePaco;
          k1ysb1.b1riec = beRiec;
          k1ysb1.b1xcob = beXcob;
          k1ysb1.b1nrdf = beNrdf;
          k1ysb1.b1sebe = beSebe;
          chain %kds(k1ysb1:11) pahsb1;
          if %found(pahsb1);
           x += 1 ;
           peDsReC += 1;
           peDsRe(x).reempr = beEmpr;
           peDsRe(x).resucu = beSucu;
           peDsRe(x).rerama = beRama;
           peDsRe(x).resini = beSini;
           peDsRe(x).renops = beNops;
           peDsRe(x).repoco = bePoco;
           peDsRe(x).repaco = bePaco;
           peDsRe(x).reriec = beRiec;
           peDsRe(x).rexcob = beXcob;
           peDsRe(x).renrdf = beNrdf;
           peDsRe(x).resebe = beSebe;
           peDsRe(x).recesi = b1Cesi;
           peDsRe(x).rerecl = b1Recl;
           peDsRe(x).rectle = b1Ctle;
           peDsRe(x).rehecg = b1Hecg;

          endif;

        reade %kds(k1ysbe:5) pahsbe;
        enddo;
        unlock pahsb1;
         if x <> *zeros;
           Return *on ;
          else;
           Return *off;
         endif;

      /end-free

     P SVPSIN_getReclamosXStro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_terminarBenefXReclamo : Termina el reclamo x          *
      *                                beneficiario y nivela las     *
      *                                reservas del mismo            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peRecl   (input)   Número de Reclamo                     *
      *                                                              *
      * Devuelve:Estructura con Beneficiarios x Reclamos             *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_terminarBenefXReclamo...
     P                 B                   export
     D SVPSIN_terminarBenefXReclamo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peRecl                       3  0 const

     D k1ysb1          ds                  likerec(p1hsb1:*key)
     D @@fech          s              8  0
     D @@ds456         ds                  likeds( DsSet456_t )
     D X               s             10i 0
     D peDsRe          ds                  likeds( DsReclamos_t ) dim(999)
     D peDsReC         s             10i 0
     D @@mact          s             25  2

      /free

       SVPSIN_inz();

        if SVPSIN_getSet456( peEmpr
                           : peSucu
                           : @@Ds456) = *off;
          return *off;
         else;
          @@fech = (@@ds456.t@fema*10000) + (@@ds456.t@femm*100) +
                   @@ds456.t@femd;
        endif;

        SVPSIN_getReclamosXStro( peEmpr
                               : peSucu
                               : peRama
                               : peSini
                               : peNops
                               : peDsRe
                               : peDsReC );


        For x = 1 to peDsReC;

          k1ysb1.b1Empr = peDsRe(x).reempr;
          k1ysb1.b1Sucu = peDsRe(x).resucu;
          k1ysb1.b1Rama = peDsRe(x).rerama;
          k1ysb1.b1Sini = peDsRe(x).resini;
          k1ysb1.b1Nops = peDsRe(x).renops;
          k1ysb1.b1Poco = peDsRe(x).repoco;
          k1ysb1.b1Paco = peDsRe(x).repaco;
          k1ysb1.b1Riec = peDsRe(x).reriec;
          k1ysb1.b1Xcob = peDsRe(x).rexcob;
          k1ysb1.b1Nrdf = peDsRe(x).renrdf;
          chain %kds(k1ysb1:10) pahsb1;
          if %found(pahsb1);
           if b1recl = peRecl;

           @@mact = *zeros ;

         // Acá tengo que ver si tengo reservas activas por reclamo

           @@mact = SVPSIN_getRvaAct( b1Empr
                                    : b1Sucu
                                    : b1Rama
                                    : b1Sini
                                    : b1Nops
                                    : b1Nrdf
                                    : @@Fech );
            if @@mact <> *zeros;

         // Acá Termino los reclamos para todos los beneficiarios
         // de ese Reclamo
             if SVPSIN_terminarReclamoStro( b1Empr
                                          : b1Sucu
                                          : b1Rama
                                          : b1Sini
                                          : b1Nops
                                          : b1Poco
                                          : b1Paco
                                          : b1Riec
                                          : b1Xcob
                                          : b1Nrdf
                                          : b1Sebe
                                          : b1Cesi
                                          : b1Recl
                                          : b1Ctle
                                          : b1Hecg
                                          : @@Ds456.t@fema
                                          : @@Ds456.t@femm
                                          : @@Ds456.t@femd ) = *on;

         // Acá Nivelo los reclamos para todos los beneficiarios
         // de ese Reclamo

              if SVPSIN_nivelarFraStroBenef( b1Empr
                                           : b1Sucu
                                           : b1Rama
                                           : b1Sini
                                           : b1Nops
                                           : peDsRe(x).renrdf
                                           : @@Fech ) = *on;
              endif;
              if SVPSIN_nivelarRvaStroBenef( b1Empr
                                           : b1Sucu
                                           : b1Rama
                                           : b1Sini
                                           : b1Nops
                                           : peDsRe(x).renrdf
                                           : @@Fech ) = *on;
              endif;
             endif;
            endif;
           endif;
          endif;

        endfor;

        return *on;

      /end-free

     P SVPSIN_terminarBenefXReclamo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chgEstadosReclamo : Cambia Estados del Reclamo        *
      *                            Hecho Generador                   *
      *                            Tipo de Lesiones                  *
      *                            Estado del Reclamo                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peRecl   (input)   Número de Reclamo                     *
      *     peHecg   (input)   Hecho Generador                       *
      *     peCtle   (input)   Tipo de Lesiones                      *
      *     peCesi   (input)   Estado del Reclamo                    *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_chgEstadosReclamo...
     P                 B                   export
     D SVPSIN_chgEstadosReclamo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peRecl                       3  0 const
     D   peCesi                       2  0 const
     D   peCtle                       2    const
     D   peHecg                       1    const

     D k1ysb1          ds                  likerec(p1hsb1:*key)
     D k2hsb1          ds                  likerec(p1hsb1:*key)
     D k1t456          ds                  likerec(s1t456:*key)
     D @@fech          s              8  0
     D @@ds456         ds                  likeds( DsSet456_t )
     D X               s             10i 0
     D peDsRe          ds                  likeds( DsReclamos_t ) dim(999)
     D peDsReC         s             10i 0
     D hay_TerReclV1   s                   like(*in50)

      /free

       SVPSIN_inz();

       k1t456.t@empr = peEmpr;
       k1t456.t@sucu = peSucu;
       chain %kds(k1t456) set456;
       if not %found;
          t@fema = *year;
          t@femm = *month;
          t@femd = *day;
       endif;

       hay_TerReclV1 = (peCesi = 05);

        SVPSIN_getReclamosXStro( peEmpr
                               : peSucu
                               : peRama
                               : peSini
                               : peNops
                               : peDsRe
                               : peDsReC );


        For x = 1 to peDsReC;
          k1ysb1.b1Empr = peDsRe(x).reempr;
          k1ysb1.b1Sucu = peDsRe(x).resucu;
          k1ysb1.b1Rama = peDsRe(x).rerama;
          k1ysb1.b1Sini = peDsRe(x).resini;
          k1ysb1.b1Nops = peDsRe(x).renops;
          k1ysb1.b1Poco = peDsRe(x).repoco;
          k1ysb1.b1Paco = peDsRe(x).repaco;
          k1ysb1.b1Riec = peDsRe(x).reriec;
          k1ysb1.b1Xcob = peDsRe(x).rexcob;
          k1ysb1.b1Nrdf = peDsRe(x).renrdf;
          chain(n) %kds(k1ysb1:10) pahsb1;
          if %found(pahsb1);
             if b1recl = peRecl and
                b1hecg = peHecg ;
                eval-corr k2hsb1 = k1ysb1;
                k2hsb1.b1fema = t@fema;
                k2hsb1.b1femm = t@femm;
                k2hsb1.b1femd = t@femd;
                k2hsb1.b1sebe = peDsRe(x).resebe;
                chain %kds(k2hsb1) pahsb1;
                if %found;
                   b1cesi = peCesi;
                   b1ctle = peCtle;
                   b1user = ususr2;
                   b1fera = *year;
                   b1ferm = *month;
                   b1ferd = *day;
                   update p1hsb1;
                 else;
                   b1empr = peDsRe(x).reempr;
                   b1sucu = peDsRe(x).resucu;
                   b1rama = peDsRe(x).rerama;
                   b1sini = peDsRe(x).resini;
                   b1nops = peDsRe(x).renops;
                   b1poco = peDsRe(x).repoco;
                   b1paco = peDsRe(x).repaco;
                   b1riec = peDsRe(x).reriec;
                   b1xcob = peDsRe(x).rexcob;
                   b1nrdf = peDsRe(x).renrdf;
                   b1sebe = peDsRe(x).resebe;
                   b1cesi = peCesi;
                   b1ctle = peCtle;
                   b1user = ususr2;
                   b1fera = *year;
                   b1ferm = *month;
                   b1ferd = *day;
                   b1fema = t@fema;
                   b1femm = t@femm;
                   b1femd = t@femd;
                   write  p1hsb1;
                endif;
             endif;
          endif;
        endfor;

         // Si Hay bandera Termino Reclamo
         if hay_TerReclV1;
            SVPSIN_terminarBenefXReclamo( peEmpr
                                        : peSucu
                                        : peRama
                                        : peSini
                                        : peNops
                                        : peRecl ) ;
         endif;

        return *on;

      /end-free

     P SVPSIN_chgEstadosReclamo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkEstadosReclamo : chequea Estados del Reclamo       *
      *                            Hecho Generador                   *
      *                            Tipo de Lesiones                  *
      *                            Estado del Reclamo                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peRecl   (input)   Número de Reclamo                     *
      *     peHecg   (input)   Hecho Generador                       *
      *     peCtle   (input)   Tipo de Lesiones                      *
      *     peCesi   (input)   Estado del Reclamo                    *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_chkEstadosReclamo...
     P                 B                   export
     D SVPSIN_chkEstadosReclamo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peRecl                       3  0 const
     D   peCesi                       2  0 const
     D   peCtle                       2    const
     D   peHecg                       1    const
     d   peIdms                       7a
     d   peIdm1                       7a
     d   peIdm2                       7a

     D k1ysb1          ds                  likerec(p1hsb1:*key)
     D k1y412          ds                  likerec(s1t412:*key)
     D k1y406          ds                  likerec(s1t406:*key)
     D k1y407          ds                  likerec(s1t407:*key)
     D peDsRe          ds                  likeds( DsReclamos_t ) dim(999)
     D peDsReC         s             10i 0
     D X               s             10i 0


      /free

       SVPSIN_inz();

        SVPSIN_getReclamosXStro( peEmpr
                               : peSucu
                               : peRama
                               : peSini
                               : peNops
                               : peDsRe
                               : peDsReC );


         For x = 1 to peDsReC;

          k1ysb1.b1Empr = peDsRe(x).reempr;
          k1ysb1.b1Sucu = peDsRe(x).resucu;
          k1ysb1.b1Rama = peDsRe(x).rerama;
          k1ysb1.b1Sini = peDsRe(x).resini;
          k1ysb1.b1Nops = peDsRe(x).renops;
          k1ysb1.b1Poco = peDsRe(x).repoco;
          k1ysb1.b1Paco = peDsRe(x).repaco;
          k1ysb1.b1Riec = peDsRe(x).reriec;
          k1ysb1.b1Xcob = peDsRe(x).rexcob;
          k1ysb1.b1Nrdf = peDsRe(x).renrdf;
          chain %kds(k1ysb1:10) pahsb1;
          if %found(pahsb1);
           if b1recl = peRecl;

         // Validamos Hecho Generador

          chain peHecg set407;
          if not %found(set407);
            peIdm2 = 'SIN1000' ;
            return *on;
          endif;

          k1y412.t@cobl = b1riec;
          k1y412.t@xcob = b1xcob;
          k1y412.t@hecg = peHecg;
          chain %kds(k1y412:3) set412;
          if not %found(set412);
            peIdm2 = 'SIN0050' ;
            return *on;
          endif;

         // Validamos Tipo de Lesiones

          if peCtle <> *blanks;
           chain peCtle set406;
           if not %found(set406);
            peIdm1 = 'SIN5003' ;
            return *on;
           endif;
          endif;

         // Validamos Estado del Reclamo

           endif;
          endif;

         endfor;

        return *off;

      /end-free

     P SVPSIN_chkEstadosReclamo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getSaldoActual(): Retorna el saldo actual de la       *
      *                          cuenta corriente del siniestro.     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: Saldo                                               *
      * ------------------------------------------------------------ *
     P SVPSIN_getSaldoActual...
     P                 B                   export
     D SVPSIN_getSaldoActual...
     D                 pi            11  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1yscc          ds                  likerec( p1hscc : *key )

     D saldo           s             11  2

      /free

       SVPSIN_inz();

       saldo = 0;

       k1yscc.ccEmpr = peEmpr;
       k1yscc.ccSucu = peSucu;
       k1yscc.ccRama = peRama;
       k1yscc.ccSini = peSini;
       k1yscc.ccNops = peNops;
       setll %kds( k1yscc : 5 ) pahscc;
       reade %kds( k1yscc : 5 ) pahscc;
       dow not %eof( pahscc );
         if ccDeha = 1;
           saldo += ccImmr;
         else;
           saldo -= ccImmr;
         endif;
         reade %kds( k1yscc : 5 ) pahscc;
       enddo;

       return saldo;

      /end-free

     P SVPSIN_getSaldoActual...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_rehabilitarSiniestro(): Rehabilita el Siniestro       *
      *                                para poder modificarlo.       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_rehabilitarSiniestro...
     P                 B                   export
     D SVPSIN_rehabilitarSiniestro...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D @@DS456         ds                  likeds (DsSet456_t)
     D @@DS402         ds                  likeds (DsSet402_t)

      /free

       SVPSIN_inz();

       SVPSIN_getSet456( peEmpr
                       : peSucu
                       : @@Ds456);
       if SVPSIN_getSet402( peEmpr
                          : peSucu
                          : peRama
                          : 1
                          : @@Ds402) = *off;
          return *off;
       endif;
       if SVPSIN_wrtEstSin( peEmpr
                          : peSucu
                          : peRama
                          : peSini
                          : peNops
                          : @@Ds456.t@fema
                          : @@Ds456.t@femm
                          : @@Ds456.t@femd
                          : @@Ds402.t@cesi
                          : @@Ds402.t@cese
                          : @@Ds402.t@mar1) = *off;
           return *off;
        endif;
        if SVPSIN_terminarCaratula( peEmpr
                                  : peSucu
                                  : peRama
                                  : peSini
                                  : peNops
                                  : @@Ds402.t@cesi
                                  : @@Ds402.t@cese
                                  : @@Ds402.t@mar1) = *off;
           return *off;
        endif;

        return *on;
      /end-free

     P SVPSIN_rehabilitarSiniestro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getCnhop2(): Retorna datos de Ordenes de Pago:        *
      *                     Aprobaciones.-                           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod Area Tecnica                     *
      *     pePacp   ( input  ) Num Cbate de pago                    *
      *     peIvse   ( input  ) Secuencia                            *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getCnhop2...
     P                 B                   export
     D SVPSIN_getCnhop2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peIvse                       5  0 const
     D   peDsp2                            likeds ( DsCnhop2_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsp2C                     10i 0 options(*nopass:*omit)

     D   k1yop2        ds                  likerec( c1hop2 : *key   )
     D   @@DsIp2       ds                  likerec( c1hop2 : *input )
     D   @@Dsp2        ds                  likeds ( DsCnhop2_t ) dim(9999)
     D   @@Dsp2C       s             10i 0

      /free

       SVPSIN_inz();

       clear @@Dsp2;
       clear @@Dsp2C;

       k1yop2.p2Empr = peEmpr;
       k1yop2.p2Sucu = peSucu;
       k1yop2.p2Artc = peArtc;
       k1yop2.p2Pacp = pePacp;
       k1yop2.p2Ivse = peIvse;
       setll %kds( k1yop2 : 5 ) cnhop2;
       if not %equal( cnhop2 );
          return *off;
       endif;

       reade(n) %kds( k1yop2 : 5 ) cnhop2 @@DsIp2;
       dow not %eof( cnhop2 );
           @@Dsp2C += 1;
           eval-corr @@Dsp2 ( @@Dsp2C ) = @@DsIp2;
           reade(n) %kds( k1yop2 : 5 ) cnhop2 @@DsIp2;
       enddo;


       if %addr( peDsp2 ) <> *null;
         eval-corr peDsp2 = @@Dsp2;
       endif;

       if %addr( peDsp2C ) <> *null;
         peDsp2C = @@Dsp2C;
       endif;

       return *on;

      /end-free

     P SVPSIN_getCnhop2...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkCnhop2(): Valida si existe Ordenes de Pago:        *
      *                     Aprobaciones.-                           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod Area Tecnica                     *
      *     pePacp   ( input  ) Num Cbate de pago                    *
      *     peIvse   ( input  ) Secuencia                            *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_chkCnhop2...
     P                 B                   export
     D SVPSIN_chkCnhop2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peIvse                       5  0 const

     D   k1yop2        ds                  likerec( c1hop2 : *key   )

      /free

       SVPSIN_inz();

       k1yop2.p2Empr = peEmpr;
       k1yop2.p2Sucu = peSucu;
       k1yop2.p2Artc = peArtc;
       k1yop2.p2Pacp = pePacp;
       k1yop2.p2Ivse = peIvse;
       setll %kds( k1yop2 : 5 ) cnhop2;

       if not %equal(cnhop2);
         SetError( SVPSIN_OPANE
                 : 'Orden Pago Aprob. Inexistente.' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSIN_chkCnhop2...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_setCnhop2(): Graba datos en el archivo Cnhop2              *
      *                                                                   *
      *          peDsp2   ( input  ) Estrutura de Cnhop2                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_setCnhop2...
     P                 B                   export
     D SVPSIN_setCnhop2...
     D                 pi              n
     D   peDsp2                            likeds( dsCnhop2_t ) const

     D  k1yop2         ds                  likerec( c1hop2 : *key    )
     D  dsOsp2         ds                  likerec( c1hop2 : *output )

      /free

       SVPSIN_inz();

       if SVPSIN_chkCnhop2( peDsp2.p2Empr
                          : peDsp2.p2Sucu
                          : peDsp2.p2Artc
                          : peDsp2.p2Pacp
                          : peDsp2.p2Ivse);

         return *off;
       endif;

       eval-corr DsOsp2 = peDsp2;
       monitor;
         write c1hop2 DsOsp2;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSIN_setCnhop2...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_updCnhop2(): Actualiza datos en el archivo Cnhop2          *
      *                                                                   *
      *          peDsp2   ( input  ) Estrutura de Cnhop2                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_updCnhop2...
     P                 B                   export
     D SVPSIN_updCnhop2...
     D                 pi              n
     D   peDsp2                            likeds( dsCnhop2_t ) const

     D  k1yop2         ds                  likerec( c1hop2 : *key    )
     D  dsOsp2         ds                  likerec( c1hop2 : *output )

      /free

       SVPSIN_inz();

       k1yop2.p2Empr = peDsp2.p2Empr;
       k1yop2.p2Sucu = peDsp2.p2Sucu;
       k1yop2.p2Artc = peDsp2.p2Artc;
       k1yop2.p2Pacp = peDsp2.p2Pacp;
       k1yop2.p2Ivse = peDsp2.p2Ivse;
       chain %kds( k1yop2 : 5 ) cnhop2;
       if %found( cnhop2 );
         eval-corr dsOsp2 = peDsp2;
         update c1hop2 dsOsp2;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSIN_updCnhop2...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_dltCnhop2(): Elimina datos en el archivo Cnhop2            *
      *                                                                   *
      *          peDsp2   ( input  ) Estrutura de Cnhop2                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_dltCnhop2...
     P                 B                   export
     D SVPSIN_dltCnhop2...
     D                 pi              n
     D   peDsp2                            likeds( dsCnhop2_t ) const

     D  k1yop2         ds                  likerec( c1hop2 : *key    )

      /free

       SVPSIN_inz();

       k1yop2.p2Empr = peDsp2.p2Empr;
       k1yop2.p2Sucu = peDsp2.p2Sucu;
       k1yop2.p2Artc = peDsp2.p2Artc;
       k1yop2.p2Pacp = peDsp2.p2Pacp;
       k1yop2.p2Ivse = peDsp2.p2Ivse;
       chain %kds( k1yop2 : 5 ) cnhop2;
       if %found( cnhop2 );
         delete c1hop2;
       endif;

       return *on;

      /end-free

     P SVPSIN_dltCnhop2...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getCnhop3(): Retorna datos de Ordenes de Pago:        *
      *                     Con forma de pago distinto al default.-  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod Area Tecnica                     *
      *     pePacp   ( input  ) Num Cbate de pago                    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getCnhop3...
     P                 B                   export
     D SVPSIN_getCnhop3...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peDsp3                            likeds ( DsCnhop3_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsp3C                     10i 0 options(*nopass:*omit)

     D   k1yop3        ds                  likerec( c1hop3 : *key   )
     D   @@DsIp3       ds                  likerec( c1hop3 : *input )
     D   @@Dsp3        ds                  likeds ( DsCnhop3_t ) dim(9999)
     D   @@Dsp3C       s             10i 0

      /free

       SVPSIN_inz();

       clear @@Dsp3;
       clear @@Dsp3C;

       k1yop3.p3Empr = peEmpr;
       k1yop3.p3Sucu = peSucu;
       k1yop3.p3Artc = peArtc;
       k1yop3.p3Pacp = pePacp;
       setll %kds( k1yop3 : 4 ) cnhop3;
       if not %equal( cnhop3 );
          return *off;
       endif;

       reade(n) %kds( k1yop3 : 4 ) cnhop3 @@DsIp3;
       dow not %eof( cnhop3 );
           @@Dsp3C += 1;
           eval-corr @@Dsp3 ( @@Dsp3C ) = @@DsIp3;
           reade(n) %kds( k1yop3 : 4 ) cnhop3 @@DsIp3;
       enddo;


       if %addr( peDsp3 ) <> *null;
         eval-corr peDsp3 = @@Dsp3;
       endif;

       if %addr( peDsp3C ) <> *null;
         peDsp3C = @@Dsp3C;
       endif;

       return *on;

      /end-free

     P SVPSIN_getCnhop3...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkCnhop3(): Valida si existe Ordenes de Pago:        *
      *                     Con forma de pago distinto al default.-  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod Area Tecnica                     *
      *     pePacp   ( input  ) Num Cbate de pago                    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_chkCnhop3...
     P                 B                   export
     D SVPSIN_chkCnhop3...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const

     D   k1yop3        ds                  likerec( c1hop3 : *key   )

      /free

       SVPSIN_inz();

       k1yop3.p3Empr = peEmpr;
       k1yop3.p3Sucu = peSucu;
       k1yop3.p3Artc = peArtc;
       k1yop3.p3Pacp = pePacp;
       setll %kds( k1yop3 : 4 ) cnhop3;

       if not %equal(cnhop3);
         SetError( SVPSIN_OPANE
                 : 'Orden Pago Aprob. Inexistente.' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSIN_chkCnhop3...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_setCnhop3(): Graba datos en el archivo Cnhop3              *
      *                                                                   *
      *          peDsp3   ( input  ) Estrutura de Cnhop3                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_setCnhop3...
     P                 B                   export
     D SVPSIN_setCnhop3...
     D                 pi              n
     D   peDsp3                            likeds( dsCnhop3_t ) const

     D  k1yop3         ds                  likerec( c1hop3 : *key    )
     D  dsOsp3         ds                  likerec( c1hop3 : *output )

      /free

       SVPSIN_inz();

       if SVPSIN_chkCnhop3( peDsp3.p3Empr
                          : peDsp3.p3Sucu
                          : peDsp3.p3Artc
                          : peDsp3.p3Pacp);

         return *off;
       endif;

       eval-corr DsOsp3 = peDsp3;
       monitor;
         write c1hop3 DsOsp3;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSIN_setCnhop3...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_updCnhop3(): Actualiza datos en el archivo Cnhop3          *
      *                                                                   *
      *          peDsp3   ( input  ) Estrutura de Cnhop3                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_updCnhop3...
     P                 B                   export
     D SVPSIN_updCnhop3...
     D                 pi              n
     D   peDsp3                            likeds( dsCnhop3_t ) const

     D  k1yop3         ds                  likerec( c1hop3 : *key    )
     D  dsOsp3         ds                  likerec( c1hop3 : *output )

      /free

       SVPSIN_inz();

       k1yop3.p3Empr = peDsp3.p3Empr;
       k1yop3.p3Sucu = peDsp3.p3Sucu;
       k1yop3.p3Artc = peDsp3.p3Artc;
       k1yop3.p3Pacp = peDsp3.p3Pacp;
       chain %kds( k1yop3 : 4 ) cnhop3;
       if %found( cnhop3 );
         eval-corr dsOsp3 = peDsp3;
         update c1hop3 dsOsp3;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSIN_updCnhop3...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_dltCnhop3(): Elimina datos en el archivo Cnhop3            *
      *                                                                   *
      *          peDsp3   ( input  ) Estrutura de Cnhop3                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_dltCnhop3...
     P                 B                   export
     D SVPSIN_dltCnhop3...
     D                 pi              n
     D   peDsp3                            likeds( dsCnhop3_t ) const

     D  k1yop3         ds                  likerec( c1hop3 : *key    )

      /free

       SVPSIN_inz();

       k1yop3.p3Empr = peDsp3.p3Empr;
       k1yop3.p3Sucu = peDsp3.p3Sucu;
       k1yop3.p3Artc = peDsp3.p3Artc;
       k1yop3.p3Pacp = peDsp3.p3Pacp;
       chain %kds( k1yop3 : 4 ) cnhop3;
       if %found( cnhop3 );
         delete c1hop3;
       endif;

       return *on;

      /end-free

     P SVPSIN_dltCnhop3...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getCnhpib(): Retorna datos de detalles de             *
      *                     Percepciones s/Pagos-Ingresos Brutos.-   *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peTiic   ( input  ) Tipo Impuesto                        *
      *     peFepa   ( input  ) Anio                                 *
      *     peFepm   ( input  ) Mes                                  *
      *     peComa   ( input  ) Cod may.                             *
      *     peNrma   ( input  ) Nro may.                             *
      *     peRpro   ( input  ) Provincia                            *
      *     peIvse   ( input  ) Secuencia                            *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getCnhpib...
     P                 B                   export
     D SVPSIN_getCnhpib...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTiic                       3    const
     D   peFepa                       4  0 const
     D   peFepm                       2  0 const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peRpro                       2  0 const
     D   peIvse                       5  0 const
     D   peDsIb                            likeds ( DsCnhpib_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsIbC                     10i 0 options(*nopass:*omit)

     D   k1ypib        ds                  likerec( c1hpib : *key   )
     D   @@DsIib       ds                  likerec( c1hpib : *input )
     D   @@DsIb        ds                  likeds ( DsCnhpib_t ) dim(9999)
     D   @@DsIbC       s             10i 0

      /free

       SVPSIN_inz();

       clear @@DsIb;
       clear @@DsIbC;

       k1ypib.piEmpr = peEmpr;
       k1ypib.piSucu = peSucu;
       k1ypib.piTiic = peTiic;
       k1ypib.piFepa = peFepa;
       k1ypib.piFepm = peFepm;
       k1ypib.piComa = peComa;
       k1ypib.piNrma = peNrma;
       k1ypib.piRpro = peRpro;
       k1ypib.piIvse = peIvse;
       setll %kds( k1ypib : 9 ) cnhpib;
       if not %equal( cnhpib );
          return *off;
       endif;

       reade(n) %kds( k1ypib : 9 ) cnhpib @@DsIib;
       dow not %eof( cnhpib );
           @@DsIbC += 1;
           eval-corr @@DsIb ( @@DsIbC ) = @@DsIib;
           reade(n) %kds( k1ypib : 9 ) cnhpib @@DsIib;
       enddo;


       if %addr( peDsIb ) <> *null;
         eval-corr peDsIb = @@DsIb;
       endif;

       if %addr( peDsIbC ) <> *null;
         peDsIbC = @@DsIbC;
       endif;

       return *on;

      /end-free

     P SVPSIN_getCnhpib...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkCnhpib(): Valida si existe datos de detalle de     *
      *                     Percepciones s/Pagos-Ingresos Brutos.-   *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peTiic   ( input  ) Tipo Impuesto                        *
      *     peFepa   ( input  ) Anio                                 *
      *     peFepm   ( input  ) Mes                                  *
      *     peComa   ( input  ) Cod may.                             *
      *     peNrma   ( input  ) Nro may.                             *
      *     peRpro   ( input  ) Provincia                            *
      *     peIvse   ( input  ) Secuencia                            *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_chkCnhpib...
     P                 B                   export
     D SVPSIN_chkCnhpib...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTiic                       3    const
     D   peFepa                       4  0 const
     D   peFepm                       2  0 const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peRpro                       2  0 const
     D   peIvse                       5  0 const

     D   k1ypib        ds                  likerec( c1hpib : *key   )

      /free

       SVPSIN_inz();

       k1ypib.piEmpr = peEmpr;
       k1ypib.piSucu = peSucu;
       k1ypib.piTiic = peTiic;
       k1ypib.piFepa = peFepa;
       k1ypib.piFepm = peFepm;
       k1ypib.piComa = peComa;
       k1ypib.piNrma = peNrma;
       k1ypib.piRpro = peRpro;
       k1ypib.piIvse = peIvse;
       setll %kds( k1ypib : 9 ) cnhpib;
       if not %equal(cnhpib);
         SetError( SVPSIN_PIINE
                 : 'Percepciones s/Pagos-Ingresos Bruto Inexistente');
       endif;

       return %equal ;

      /end-free

     P SVPSIN_chkCnhpib...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_setCnhpib(): Graba datos en el archivo Cnhpib              *
      *                                                                   *
      *          peDsIb   ( input  ) Estrutura de Cnhpib                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_setCnhpib...
     P                 B                   export
     D SVPSIN_setCnhpib...
     D                 pi              n
     D   peDsIb                            likeds( dsCnhpib_t ) const

     D  k1ypib         ds                  likerec( c1hpib : *key    )
     D  dsOsIb         ds                  likerec( c1hpib : *output )

      /free

       SVPSIN_inz();

       if SVPSIN_chkCnhpib( peDsIb.piEmpr
                          : peDsIb.piSucu
                          : peDsIb.piTiic
                          : peDsIb.piFepa
                          : peDsIb.piFepm
                          : peDsIb.piComa
                          : peDsIb.piNrma
                          : peDsIb.piRpro
                          : peDsIb.piIvse);

         return *off;
       endif;

       eval-corr DsOsIb = peDsIb;
       monitor;
         write c1hpib DsOsIb;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSIN_setCnhpib...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_updCnhpib(): Actualiza datos en el archivo Cnhpib          *
      *                                                                   *
      *          peDsIb   ( input  ) Estrutura de Cnhpib                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_updCnhpib...
     P                 B                   export
     D SVPSIN_updCnhpib...
     D                 pi              n
     D   peDsIb                            likeds( dsCnhpib_t ) const

     D  k1ypib         ds                  likerec( c1hpib : *key    )
     D  dsOsIb         ds                  likerec( c1hpib : *output )

      /free

       SVPSIN_inz();

       k1ypib.piEmpr = peDsIb.piEmpr;
       k1ypib.piSucu = peDsIb.piSucu;
       k1ypib.piTiic = peDsIb.piTiic;
       k1ypib.piFepa = peDsIb.piFepa;
       k1ypib.piFepm = peDsIb.piFepm;
       k1ypib.piComa = peDsIb.piComa;
       k1ypib.piNrma = peDsIb.piNrma;
       k1ypib.piRpro = peDsIb.piRpro;
       k1ypib.piIvse = peDsIb.piIvse;
       chain %kds( k1ypib : 9 ) cnhpib;
       if %found( cnhpib );
         eval-corr dsOsIb = peDsIb;
         update c1hpib dsOsIb;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSIN_updCnhpib...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_dltCnhpib(): Elimina datos en el archivo Cnhpib            *
      *                                                                   *
      *          peDsIb   ( input  ) Estrutura de Cnhpib                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_dltCnhpib...
     P                 B                   export
     D SVPSIN_dltCnhpib...
     D                 pi              n
     D   peDsIb                            likeds( dsCnhpib_t ) const

     D  k1ypib         ds                  likerec( c1hpib : *key    )

      /free

       SVPSIN_inz();

       k1ypib.piEmpr = peDsIb.piEmpr;
       k1ypib.piSucu = peDsIb.piSucu;
       k1ypib.piTiic = peDsIb.piTiic;
       k1ypib.piFepa = peDsIb.piFepa;
       k1ypib.piFepm = peDsIb.piFepm;
       k1ypib.piComa = peDsIb.piComa;
       k1ypib.piNrma = peDsIb.piNrma;
       k1ypib.piRpro = peDsIb.piRpro;
       k1ypib.piIvse = peDsIb.piIvse;
       chain %kds( k1ypib : 9 ) cnhpib;
       if %found( cnhpib );
         delete c1hpib;
       endif;

       return *on;

      /end-free

     P SVPSIN_dltCnhpib...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_getCnhret(): Retorna datos Detalle de Retenciones          *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peTiic   ( input  ) Codigo de Tipo de Impuesto            *
      *         peFepa   ( input  ) Fecha de Pago Anio                    *
      *         peFepm   ( input  ) Fecha de Pago Mes                     *
      *         peComa   ( input  ) codigo de Mayor Auxiliar              *
      *         peNrma   ( input  ) Numero Mayor Auxiliar                 *
      *         peRpro   ( input  ) Codigo Pcia. del Inder                *
      *         peIvse   ( input  ) Secuencia                             *
      *         peLret   ( output ) Lista de Retenciones     ( opcional ) *
      *         peLretC  ( output ) Cantidad Retenciones     ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_getCnhret...
     P                 B                   export
     D SVPSIN_getCnhret...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTiic                       3    const
     D   peFepa                       4  0 const
     D   peFepm                       2  0 const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peRpro                       2  0 const
     D   peIvse                       5  0 const
     D   peLret                            likeds(dsCnhret_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLretC                     10i 0 options( *Nopass : *Omit )

     D   k1yret        ds                  likerec( c1hret : *key    )
     D   @@DsIret      ds                  likerec( c1hret : *input  )
     D   @@Dret        ds                  likeds ( dsCnhret_t ) dim( 9999 )
     D   @@DretC       s             10i 0

      /free

       SVPSIN_inz();

       clear @@Dret;
       @@DretC = 0;

       if not SVPSIN_chkCnhret( peEmpr
                              : peSucu
                              : peTiic
                              : peFepa
                              : peFepm
                              : peComa
                              : peNrma
                              : peRpro
                              : peIvse);
          return *off;
       endif;

       k1yret.rtEmpr = peEmpr;
       k1yret.rtSucu = peSucu;
       k1yret.rtTiic = peTiic;
       k1yret.rtFepa = peFepa;
       k1yret.rtFepm = peFepm;
       k1yret.rtComa = peComa;
       k1yret.rtNrma = peNrma;
       k1yret.rtRpro = peRpro;
       k1yret.rtIvse = peIvse;

       reade(n) %kds( k1yret : 9 ) Cnhret @@DsIret;
       dow not %eof( Cnhret );
          @@DretC += 1;
          eval-corr @@Dret ( @@DretC ) = @@DsIret;
       reade(n) %kds( k1yret : 9 ) Cnhret @@DsIret;
       enddo;

       if %addr( peLret ) <> *null;
         eval-corr peLret = @@Dret;
       endif;

       if %addr( peLretC ) <> *null;
         peLretC = @@DretC;
       endif;

       return *on;

      /end-free

     P SVPSIN_getCnhret...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkCnhret(): Valida si existe Detalle de Retenciones  *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peTiic   ( input  ) Codigo de Tipo de Impuesto       *
      *         peFepa   ( input  ) Fecha de Pago Anio               *
      *         peFepm   ( input  ) Fecha de Pago Mes                *
      *         peComa   ( input  ) codigo de Mayor Auxiliar         *
      *         peNrma   ( input  ) Numero Mayor Auxiliar            *
      *         peRpro   ( input  ) Codigo Pcia. del Inder           *
      *         peIvse   ( input  ) Secuencia                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_chkCnhret...
     P                 B                   export
     D SVPSIN_chkCnhret...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTiic                       3    const
     D   peFepa                       4  0 const
     D   peFepm                       2  0 const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peRpro                       2  0 const
     D   peIvse                       5  0 const

     D k1yret          ds                  likerec( c1hret : *key )

      /free

       SVPSIN_inz();

       k1yret.rtEmpr = peEmpr;
       k1yret.rtSucu = peSucu;
       k1yret.rtTiic = peTiic;
       k1yret.rtFepa = peFepa;
       k1yret.rtFepm = peFepm;
       k1yret.rtComa = peComa;
       k1yret.rtNrma = peNrma;
       k1yret.rtRpro = peRpro;
       k1yret.rtIvse = peIvse;
       setll %kds( k1yret : 9 ) Cnhret;

       if not %equal(Cnhret);
         SetError( SVPSIN_DTREI
                 : 'Detalle Retencion Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSIN_chkCnhret...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_setCnhret(): Graba datos en el archivo Cnhret              *
      *                                                                   *
      *          peDret   ( input  ) Estrutura de Cnhret                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_setCnhret...
     P                 B                   export
     D SVPSIN_setCnhret...
     D                 pi              n
     D   peDret                            likeds( dsCnhret_t ) const

     D  k1yret         ds                  likerec( c1hret : *key    )
     D  dsOret         ds                  likerec( c1hret : *output )

      /free

       SVPSIN_inz();

       if SVPSIN_chkCnhret( peDret.rtEmpr
                          : peDret.rtSucu
                          : peDret.rtTiic
                          : peDret.rtFepa
                          : peDret.rtFepm
                          : peDret.rtComa
                          : peDret.rtNrma
                          : peDret.rtRpro
                          : peDret.rtIvse );
         SetError( SVPSIN_DTREE
                 : 'Detalle Retencion Existente' );
         return *off;
       endif;

       eval-corr DsOret = peDret;
       monitor;
         write c1hret DsOret;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSIN_setCnhret...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_updCnhret(): Actualiza datos en el archivo Cnhret          *
      *                                                                   *
      *          peDret   ( input  ) Estrutura de Cnhret                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_updCnhret...
     P                 B                   export
     D SVPSIN_updCnhret...
     D                 pi              n
     D   peDret                            likeds( dsCnhret_t ) const

     D  k1yret         ds                  likerec( c1hret : *key    )
     D  dsOret         ds                  likerec( c1hret : *output )

      /free

       SVPSIN_inz();

       k1yret.rtEmpr = peDret.rtEmpr;
       k1yret.rtSucu = peDret.rtSucu;
       k1yret.rtTiic = peDret.rtTiic;
       k1yret.rtFepa = peDret.rtFepa;
       k1yret.rtFepm = peDret.rtFepm;
       k1yret.rtComa = peDret.rtComa;
       k1yret.rtNrma = peDret.rtNrma;
       k1yret.rtRpro = peDret.rtRpro;
       k1yret.rtIvse = peDret.rtIvse;
       chain %kds( k1yret : 9 ) Cnhret;
       if not %found( Cnhret );
         SetError( SVPSIN_DTREI
                 : 'Detalle Retencion Inexistente' );
         return *off;
       endif;

       eval-corr dsOret = peDret;
       update c1hret dsOret;
       return *on;

      /end-free

     P SVPSIN_updCnhret...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_dltCnhret(): Elimina datos en el archivo Cnhret            *
      *                                                                   *
      *          peDret   ( input  ) Estrutura de Cnhret                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_dltCnhret...
     P                 B                   export
     D SVPSIN_dltCnhret...
     D                 pi              n
     D   peDret                            likeds( dsCnhret_t ) const

     D  k1yret         ds                  likerec( c1hret : *key    )
     D  dsOret         ds                  likerec( c1hret : *output )

      /free

       SVPSIN_inz();

       k1yret.rtEmpr = peDret.rtEmpr;
       k1yret.rtSucu = peDret.rtSucu;
       k1yret.rtTiic = peDret.rtTiic;
       k1yret.rtFepa = peDret.rtFepa;
       k1yret.rtFepm = peDret.rtFepm;
       k1yret.rtComa = peDret.rtComa;
       k1yret.rtNrma = peDret.rtNrma;
       k1yret.rtRpro = peDret.rtRpro;
       k1yret.rtIvse = peDret.rtIvse;
       chain %kds( k1yret : 9 ) Cnhret;
       if not %found( Cnhret );
         SetError( SVPSIN_DTREI
                 : 'Detalle Retencion Inexistente' );
         return *off;
       endif;

       delete c1hret;
       return *on;

      /end-free

     P SVPSIN_dltCnhret...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getFechaDeReserva(): Retorna Fecha de reserva.        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peSebe   (input)   Secuencia de Beneficiario             *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPSIN_getFechaDeReserva...
     P                 B                   export
     D SVPSIN_getFechaDeReserva...
     D                 pi             8  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const

     D k1yshr5         ds                  likerec( p1hshr05 : *key )

     D @@Frva          s              8  0

      /free

       SVPSIN_inz();

        clear @@Frva;

        k1yshr5.hrEmpr = peEmpr;
        k1yshr5.hrSucu = peSucu;
        k1yshr5.hrRama = peRama;
        k1yshr5.hrSini = peSini;
        k1yshr5.hrNops = peNops;
        k1yshr5.hrNrdf = peNrdf;
        k1yshr5.hrSebe = peSebe;
        setll    %kds( k1yshr5 : 7 ) pahshr05;
        reade(n) %kds( k1yshr5 : 7 ) pahshr05;
        dow not %eof( pahshr05 );
          @@Frva = ( hrfmoa * 10000 )
                 + ( hrfmom *   100 )
                 +   hrfmod;

          reade(n) %kds( k1yshr5 : 7 ) pahshr05;
        enddo;

        return @@Frva;


      /end-free

     P SVPSIN_getFechaDeReserva...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_setCnhopa() : Graba datos en el Archivo CNHOPA        *
      *                                                              *
      *                                                              *
      *     peDsop   ( input  ) Estrutura de CNHOPA                  *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_setCnhopa...
     P                 B                   export
     D SVPSIN_setCnhopa...
     D                 pi              n
     D   peDsop                            likeds( dsCnhopa_t ) const


     D  k1yopa         ds                  likerec( c1hopa : *key    )
     D  dsOopa         ds                  likerec( c1hopa : *output )

      /free

       SVPSIN_inz();

       if SVPSIN_chkCnhopa( peDsop.paEmpr
                          : peDsop.paSucu
                          : peDsop.paArtc
                          : peDsop.paPacp ) = *off;

         return *off;
       endif;

       eval-corr DsOopa = peDsop;

       monitor;
         write c1hopa DsOopa;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSIN_setCnhopa...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_getCnhopa(): Retorna datos de Ordenes de Pago              *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peArtc   ( input  ) Area Técnica                          *
      *         pePacp   ( input  ) Número de Orden de Pago               *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_getCnhopa...
     P                 B                   export
     D SVPSIN_getCnhopa...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peDsOp                            likeds(dsCnhopa_t)
     D                                     options( *Nopass : *Omit )

     D   k1yopa        ds                  likerec( c1hopa : *key    )
     D   @@Dsop        ds                  likerec( c1hopa : *input )


      /free

       SVPSIN_inz();

       clear peDsop;
       clear @@Dsop;

       k1yopa.paEmpr = peEmpr;
       k1yopa.paSucu = peSucu;
       k1yopa.paArtc = peArtc;
       k1yopa.paPacp = pePacp;
       chain %kds( k1yopa : 4 ) cnhopa @@dsop ;
        if not %found( cnhopa ) ;
          return *off ;
        endif;

        eval-corr peDsop  = @@Dsop ;

       return *on;

      /end-free

     P SVPSIN_getCnhopa...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkCnhopa() : Cheque datos en el Archivo CNHOPA       *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peArtc   ( input  ) Area Técnica                     *
      *         pePacp   ( input  ) Número de Orden de Pago          *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_chkCnhopa...
     P                 B                   export
     D SVPSIN_chkCnhopa...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const


     D  k1yopa         ds                  likerec( c1hopa : *key    )

      /free

       SVPSIN_inz();

       k1yopa.paEmpr = peEmpr;
       k1yopa.paSucu = peSucu;
       k1yopa.paArtc = peArtc;
       k1yopa.paPacp = pePacp;
       chain %kds( k1yopa : 4 ) cnhopa ;
        if not %found( cnhopa );
          return *on;
         else ;
          return *off ;
        endif;


      /end-free

     P SVPSIN_chkCnhopa...
     P                 E


      * ------------------------------------------------------------ *
      * SVPSIN_setCnwnin() : Graba datos en el Archivo CNWNIN        *
      *                                                              *
      *                                                              *
      *     peDsni   ( input  ) Estrutura de CNWNIN                  *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_setCnwnin...
     P                 B                   export
     D SVPSIN_setCnwnin...
     D                 pi              n
     D   peDsni                            likeds( dsCnwnin_t ) const


     D  k1ynin         ds                  likerec( c1wnin : *key    )
     D  dsOnin         ds                  likerec( c1wnin : *output )

      /free

       SVPSIN_inz();

       if SVPSIN_chkCnwnin( peDsni.niEmpr
                          : peDsni.niSuc2
                          : peDsni.niFasa
                          : peDsni.niFasm
                          : peDsni.niFasd
                          : peDsni.niLibr
                          : peDsni.niTic2
                          : peDsni.niNras
                          : peDsni.niComo
                          : peDsni.niSeas ) ;

         return *off;
       endif;

       eval-corr DsOnin = peDsni;

       monitor;
         write c1wnin DsOnin;
         unlock cnwnin;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSIN_setCnwnin...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_getCnwnin(): Retorna datos de Ordenes de Pago              *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peFasa   ( input  ) Año de Asiento                        *
      *         peFasm   ( input  ) Mes de Asiento                        *
      *         peFasd   ( input  ) Día de Asiento                        *
      *         peLibr   ( input  ) Libro                                 *
      *         peTic2   ( input  ) Tipo de Comprobante                   *
      *         peNras   ( input  ) Número de Asiento                     *
      *         peComo   ( input  ) Moneda                                *
      *         peSeas   ( input  ) Secuencia de Asiento                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_getCnwnin...
     P                 B                   export
     D SVPSIN_getCnwnin...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peFasa                       4  0 const
     D   peFasm                       2  0 const
     D   peFasd                       2  0 const
     D   peLibr                       1  0 const
     D   peTic2                       2  0 const
     D   peNras                       6  0 const
     D   peComo                       2    const
     D   peSeas                       4  0 const
     D   peDsNi                            likeds(dsCnwnin_t)
     D                                     options( *Nopass : *Omit )

     D   k1ynin        ds                  likerec( c1wnin : *key    )
     D   @@Dsni        ds                  likerec( c1wnin : *input  )


      /free

       SVPSIN_inz();

       clear peDsni;
       clear @@Dsni;

       k1ynin.niEmpr = peEmpr;
       k1ynin.niSuc2 = peSucu;
       k1ynin.niFasa = peFasa;
       k1ynin.niFasm = peFasm;
       k1ynin.niFasm = peFasd;
       k1ynin.niLibr = peLibr;
       k1ynin.niTic2 = peTic2;
       k1ynin.niNras = peNras;
       k1ynin.niComo = peComo;
       k1ynin.niSeas = peSeas;
       chain %kds( k1ynin : 4 ) cnwnin @@Dsni ;
        if not %found( cnwnin );
          return *off ;
        endif;

        eval-corr peDsni  = @@Dsni ;

       return *on;

      /end-free

     P SVPSIN_getCnwnin...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkCnwnin() : Cheque datos en el Archivo CNWNIN       *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peFasa   ( input  ) Año de Asiento                   *
      *         peFasm   ( input  ) Mes de Asiento                   *
      *         peFasd   ( input  ) Día de Asiento                   *
      *         peLibr   ( input  ) Libro                            *
      *         peTic2   ( input  ) Tipo de Comprobante              *
      *         peNras   ( input  ) Número de Asiento                *
      *         peComo   ( input  ) Moneda                           *
      *         peSeas   ( input  ) Secuencia de Asiento             *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_chkCnwnin...
     P                 B                   export
     D SVPSIN_chkCnwnin...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peFasa                       4  0 const
     D   peFasm                       2  0 const
     D   peFasd                       2  0 const
     D   peLibr                       1  0 const
     D   peTic2                       2  0 const
     D   peNras                       6  0 const
     D   peComo                       2    const
     D   peSeas                       4  0 const


     D  k1ynin         ds                  likerec( c1wnin : *key    )

      /free

       SVPSIN_inz();

       k1ynin.niEmpr = peEmpr;
       k1ynin.niSuc2 = peSucu;
       k1ynin.niFasa = peFasa;
       k1ynin.niFasm = peFasm;
       k1ynin.niFasd = peFasd;
       k1ynin.niLibr = peLibr;
       k1ynin.niTic2 = peTic2;
       k1ynin.niNras = peNras;
       k1ynin.niComo = peComo;
       K1ynin.niSeas = peSeas;
       chain %kds( k1ynin : 10 ) cnwnin ;
        return %found ;


      /end-free

     P SVPSIN_chkCnwnin...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_generarOrdPagStroTotal(): Generar Orden De Pago de    *
      *                                  Siniestro Total.            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Estructura de Siniestro               *
      *     peCant   (input)   Cantidad de Siniestros                *
      *     peMar1   (input)   Tipo de Beneficiario de Pago          *
      *     peComa   (input)   Código Mayor Auxiliar                 *
      *     peNrma   (input)   Número Mayor Auxiliar                 *
      *     peTipa   (input)   Tipo de Pago                          *
      *     peImpo   (input)   Importe de Factura                    *
      *     peMar2   (input)   Gastos/Indemnización                  *
      *     peFeop   (input)   Fecha Orden de Pago                   *
      *     peFvdv   (input)   Forma de Pago                         *
      *     peTifa   (input)   Tipo de Factura                       *
      *     peSufa   (input)   Sucursal de Factura                   *
      *     peNrfa   (input)   Número de Factura                     *
      *     peFfac   (input)   Fecha de Factura                      *
      *     peRpro   (input)   Provincia de Percepción               *
      *     peImpe   (input)   Importe de Percepción                 *
      *     peCopt   (input)   Concepto de Pago                      *
      *     peApol   (input)   Aplica a Póliza                       *
      *     peNomb   (input)   Cheque a la Orden de                  *
      *     peDeJu   (input)   Deposito Judicial                     *
      *     peUser   (input)   Usuario                               *
      *     peValo   (output)  Valores calculados                    *
      *                                                              *
      * Retorna: Área Técnica y Número de Orden de Pago              *
      * ------------------------------------------------------------ *
      * NWN - OJO agregar ajuste sobre los devolucines de las        *
      *       grabaciones de los archivos para que se entere alguien *
      *       que no se pudo grabar un registro...         i         *
      *       EJEMPLO 1 ;                                            *
      *                rc =  SVPSI1_setPahshp( peDshp ) ;            *
      *                if RC = '0'                                   *
      *                  grabo mensaje de error                      *
      *                endif                                         *
      *       EJEMPLO 2 ;                                            *
      *                   Dentro del monitor del SVPSI1_setPahshp    *
      *                   grabar el mensaje por on-error;            *
      * ------------------------------------------------------------ *
     P SVPSIN_generarOrdPagStroTotal...
     P                 B                   export
     D SVPSIN_generarOrdPagStroTotal...
     D                 pi             8  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                            likeds ( siniestroNum_t ) const
     D                                     dim(999)
     D   peCant                      10  0 const
     D   peMar1                       1    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peTipa                       1    const
     D   peImpo                      15  2 const
     D   peMar2                       1    const
     D   peFeop                      10    const
     D   peFvdv                       2  0 const
     D   peTifa                       2  0 const
     D   peSufa                       4  0 const
     D   peNrfa                       8  0 const
     D   peFfac                      10    const
     D   peRpro                       2  0 const dim(25)
     D   peImpe                      15  2 const dim(25)
     D   peCopt                      75    const
     D   peApol                       1    const
     D   peNomb                      40    const
     D   peDeJu                       1    const
     D   peUser                      10    const
     D   peValo                            likeds(valoresOp_t)

     D CXP572S         pr                  extpgm('CXP572S')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peMoas                        1a   const
     D  peNrrf                        9  0

     D k1yshp          ds                  likerec(p1hshp12:*key)
     D k1yscd          ds                  likerec(p1hscd:*key)
     D k1ytge          ds                  likerec(g1ttge:*key)
     D k1ysbe          ds                  likerec(p1hsbe:*key)
     D peDsWbe         ds                  likeds ( DsPawsbe_t )
     D peDshp          ds                  likeds ( DsPahshp_t )
     D peDslp          ds                  likeds ( DsPahslp_t )
     D k1ytopa         ds                  likerec(c1topa:*key)
     D k1ynau          ds                  likerec(c1tnau01:*key)
     D k1yloc          ds                  likerec(g1tloc02:*key)
     D peDs047         ds                  likeds ( DsSp0047_t )

     D resSini         ds                  qualified dim(999)
     D importe                       15  2

     D  @@mact         s             25  2
     D  @2mact         s             25  2
     D  @@mactn        s             25  2
     D  @1mact         s             15  2
     D  rc             s              1n
     D  x3fasa         s              4  0
     D  x3fasm         s              2  0
     D  x3fasd         s              2  0
     D  p@artc         s              6  0
     D  x3fppa         s              4  0
     D  x3fppm         s              2  0
     D  x3fppd         s              2  0
     D  wwpsec         s                    like(hppsec)
     D  wwmoas         s                    like(hppsec)
     D  p@pacp         s              6  0
     D  x3Coi2         s              2  0
     D  x3Coi1         s              1  0
     D  x3Poim         s              5  2
     D  wwgecv         s                    like(tggecv)
     D  wwgens         s                    like(tggens)
     D  wwgess         s                    like(tggess)
     D  xnrcmi         s             11  0
     D  wwx309         s             30  9
     D  wximiv         s             15  2
     D  wxsubt         s             15  2
     D  wxnetc         s             15  2
     D  wzresn         s             13     inz('SSSSSSSSSSSSS')
     D  wwa003         s              3
     D  wwa100         s            100
     D  wzre01         s                    like(wwa100)
     D  wzre02         s                    like(wwa100)
     D  wzre03         s                    like(wwa100)
     D  wzre04         s                    like(wwa100)
     D  wzre05         s                    like(wwa100)
     D  wzre06         s                    like(wwa100)
     D  wzre07         s                    like(wwa100)
     D  wzre08         s                    like(wwa100)
     D  wzre09         s                    like(wwa100)
     D  wzre10         s                    like(wwa100)
     D  wzre11         s                    like(wwa100)
     D  wzre12         s                    like(wwa100)
     D  wzre13         s                    like(wwa100)
     D  wzretor        s                    like(wwa003)
     D  pePibr         s              1n
     D  p1nrdo         s              8  0
     D  wapoc          s              3
     D  wapoi          s             15  2
     D  @erro          s              1
     D  peCmga         s             11  0
     D  $1Cmga         s             11
     D  x              s              2  0
     D  y              s              3  0
     D  @J             s              2  0
     D  z              s              2  0
     D  @eFfac         s              8  0
         // campos de Retenciones. -----------------------------
     D  xnrcm1         s             11  0
     D  xpoim1         s              5  2
     D  xsure1         s             10  2
     D  ximre1         s             10  2
     D  xbmis1         s             15  2
     D  xcoi11         s              1  0
     D  xcoi21         s              2  0
     D  xacum1         s             15  2
     D  xapoi1         s             15  2
     D  xapoc1         s              3

     D  xnrcm2         s             11  0
     D  xpoim2         s              5  2
     D  xsure2         s             10  2
     D  ximre2         s             10  2
     D  xbmis2         s             15  2
     D  xcoi12         s              1  0
     D  xcoi22         s              2  0
     D  xacum2         s             15  2
     D  xapoi2         s             15  2
     D  xapoc2         s              3

     D  xnrcm3         s             11  0
     D  xpoim3         s              5  2
     D  xsure3         s             10  2
     D  ximre3         s             10  2
     D  xbmis3         s             15  2
     D  xcoi13         s              1  0
     D  xcoi23         s              2  0
     D  xacum3         s             15  2
     D  xapoi3         s             15  2
     D  xapoc3         s              3

     D  xnrcm4         s             11  0
     D  xpoim4         s              5  2
     D  xsure4         s             10  2
     D  ximre4         s             10  2
     D  xbmis4         s             15  2
     D  xcoi14         s              1  0
     D  xcoi24         s              2  0
     D  xacum4         s             15  2
     D  xapoi4         s             15  2
     D  xapoc4         s              3

     D  xnrcm5         s             11  0
     D  xpoim5         s              5  2
     D  xsure5         s             10  2
     D  ximre5         s             10  2
     D  xbmis5         s             15  2
     D  xcoi15         s              1  0
     D  xcoi25         s              2  0
     D  xacum5         s             15  2
     D  xapoi5         s             15  2
     D  xapoc5         s              3

     D  xnrcm6         s             11  0
     D  xpoim6         s              5  2
     D  xsure6         s             10  2
     D  ximre6         s             10  2
     D  xbmis6         s             15  2
     D  xcoi16         s              1  0
     D  xcoi26         s              2  0
     D  xacum6         s             15  2
     D  xapoi6         s             15  2
     D  xapoc6         s              3

     D  xnrcm7         s             11  0
     D  xpoim7         s              5  2
     D  xsure7         s             10  2
     D  ximre7         s             10  2
     D  xbmis7         s             15  2
     D  xcoi17         s              1  0
     D  xcoi27         s              2  0
     D  xacum7         s             15  2
     D  xapoi7         s             15  2
     D  xapoc7         s              3

     D  xnrcm8         s             11  0
     D  xpoim8         s              5  2
     D  xsure8         s             10  2
     D  ximre8         s             10  2
     D  xbmis8         s             15  2
     D  xcoi18         s              1  0
     D  xcoi28         s              2  0
     D  xacum8         s             15  2
     D  xapoi8         s             15  2
     D  xapoc8         s              3

     D  xnrcm9         s             11  0
     D  xpoim9         s              5  2
     D  xsure9         s             10  2
     D  ximre9         s             10  2
     D  xbmis9         s             15  2
     D  xcoi19         s              1  0
     D  xcoi29         s              2  0
     D  xacum9         s             15  2
     D  xapoi9         s             15  2
     D  xapoc9         s              3

     D  xnrcm0         s             11  0
     D  xpoim0         s              5  2
     D  xsure0         s             10  2
     D  ximre0         s             10  2
     D  xbmis0         s             15  2
     D  xcoi10         s              1  0
     D  xcoi20         s              2  0
     D  xacum0         s             15  2
     D  xapoi0         s             15  2
     D  xapoc0         s              3
     D  hoy            s              8  0


     D @@ds456         ds                  likeds( DsSet456_t )
     D peDsBe          ds                  likeds( DsPahsbe_t ) dim(999)
     D peDsBeC         s             10i 0
     D @@DsBe          ds                  likeds( DsPahsbe_t ) dim(999)
     D @@DsBeC         s             10i 0

         // ----------------------------------------------------

      /free

       SVPSIN_inz();

         // Fecha de Orden de Pago. -----------------------------

       x3fasa = *year ;
       x3fasm = *month;
       x3fasd = *day  ;
       clear x        ;
       clear y        ;
       clear z        ;
       clear @@mact   ;
       clear @2mact   ;

       if SVPSIN_getSet456( peEmpr
                          : peSucu
                          : @@Ds456);
          hoy = ( @@Ds456.t@fema * 10000)
              + ( @@Ds456.t@femm *   100)
              +   @@Ds456.t@femd;
       else;
          hoy = ( *year * 10000 )
              + ( *month *  100)
              +  *day;
       endif;

       for x = 1 to peCant;

          // Recupero del PAHSBE todo lo referente al Beneficiario
          if SVPSIN_getBeneficiarios( peEmpr
                                    : peSucu
                                    : peRama
                                    : peSini(x).nroStro
                                    : peSini(x).nroOperStro
                                    : *omit
                                    : *omit
                                    : *omit
                                    : *omit
                                    : *omit
                                    : *omit
                                    : peDsBe
                                    : peDsBeC ) = *off;
             return *zeros;
          endif;

          for y = 1 to peDsBeC;
             Select ;
                when peTipa = 'T' ;
                   if  peDsBe(y).becoma = peComa
                   and peDsBe(y).beNrma = peNrma ;
                       @@DsBe(x) = peDsBe(y);
                       leave ;
                   endif;
                when peTipa = 'P' or peTipa = 'C';
                   if  peDsBe(y).becoma = pecoma
                   and peDsBe(y).benrma = penrma
                   and peDsBe(y).beriec = peSini(x).codigoriesgo
                   and peDsBe(y).bexcob = peSini(x).codigocobertu;
                       @@DsBe(x) = peDsBe(y);
                       leave ;
                   endif ;
             endsl ;
          endfor;
       endfor;

       read set400 ;
       if %eof(set400);
          return *zeros;
       endif;

       p@artc = t@artc ;

       // Ver como recuperar la reserva por Riesgo Cobertura...
       // Si viene T en peTipa = Orden de Pago Total      -----
       // Si viene P en peTipa = Orden de Pago Parcial    -----
       // Si viene C en peTipa = Orden de Pago Calculo    -----

       Select ;

          // Obtengo Importe total a Pagar .----------------------
          When peTipa = 'T' ;
           for x = 1 to peCant;
             @2mact = SVPSIN_getRvaAct( peEmpr
                                      : peSucu
                                      : peRama
                                      : peSini(x).nroStro
                                      : peSini(x).nroOperStro
                                      : @@DsBe(1).benrdf
                                      : hoy   );

             //Guardamos la reserva total del siniestro
             resSini(x).importe = @2mact;

             //Acumulamos las reservas de los siniestros
             @@mact += @2mact;
           endfor;

          // Sumo los importes de los Riesgos/Cob. a Pagar .------
          // Cambio peimau por importe de factura
          When peTipa = 'P' or peTipa = 'C' ;
             @@mact = peImpo;
       endsl;

       if @@mact = 0;
          return 0;
       endif;

       // Fecha problabe de Pago...Si no viene informada de campo
       // peFeop , se debe calcular...

       // -----------------------------------------------------
       // Acá calculo todo antes de Grabar los archivos  ------
       // -----------------------------------------------------

       // Primero Determino si es asegurado/Tercero/proveedor
       // y busco posición frente al IVA.
       if pecoma = '**' ;
          wxnetc = @@mact ;
       else ;
          svpsin_getIvaProveedor( peEmpr
                                : peSucu
                                : peComa
                                : peNrma
                                : x3Fasa
                                : x3Fasm
                                : x3Fasd
                                : peTifa
                                : x3coi2
                                : x3coi1
                                : x3poim );

          // Busco Percepcion Ingresos Brutos.
          pePibr = svpsin_getPerIbrProveedor( peComa
                                            : peNrma );

          // Busco Cuenta de Iva.
          wwGens = 15 ;
          wwGess = 2  ;
          wwGecv = *blanks ;
          xnrcmi = 0       ;

          k1ytge.tgempr = peEmpr;
          k1ytge.tgsuc2 = peSucu;
          k1ytge.tggens = wwGens;
          k1ytge.tggess = wwGess;
          k1ytge.tggecv = wwGecv;
          chain %kds(k1ytge) gnttge;
          if %found(gnttge);
             xnrcmi  = %dec(tggcmg:11:0) ;
          endif;

          // Calculo Iva y Subtotal.
          wwx309 = @@mact * x3poim ;
          wximiv = wwx309 / 100    ;
          wxsubt = @@mact + wximiv ;

          // Busco y cálculo Retenciones via SP0047.
          k1ynau.naEmpr = peEmpr;
          k1ynau.naSucu = peSucu;
          k1ynau.naComa = peComa;
          k1ynau.naNrma = peNrma;
          chain %kds(k1ynau) cntnau01;

          k1yloc.locopo = dfcopo;
          k1yloc.locops = dfcops;
          chain %kds(k1yloc) gntloc02;
          @1mact = @@mact ;

          sp0047 ( peEmpr
                 : peSucu
                 : peComa
                 : peNrma
                 : @1mact
                 : wximiv
                 : x3fasa
                 : x3fasm
                 : x3fasd
                 : prrpro
                 : prrpro
                 : wzresn
                 : wzretor
                 : wzre01
                 : wzre02
                 : wzre03
                 : wzre04
                 : wzre05
                 : wzre06
                 : wzre07
                 : wzre08
                 : wzre09
                 : wzre10
                 : wzre11
                 : wzre12
                 : wzre13 );

          //  Si tengo retenciones cargo variables según retención
          if wzre01 <> *blanks ;
             peDs047 = wzre01        ;
             xnrcm1 = peDs047.peNrcm ;
             xpoim1 = peDs047.pePoim ;
             xsure1 = peDs047.peSure ;
             ximre1 = peDs047.peImre ;
             xbmis1 = peDs047.peBmis ;
             xcoi11 = peDs047.peCoi1 ;
             xcoi21 = peDs047.peCoi2 ;
             xacum1 = peDs047.peAcum ;
             xapoi1 = peDs047.peApoi ;
             xapoc1 = peDs047.peApoc ;
          endif;

         if wzre02 <> *blanks ;
            peDs047 = wzre02        ;
            xnrcm2 = peDs047.peNrcm ;
            xpoim2 = peDs047.pePoim ;
            xsure2 = peDs047.peSure ;
            ximre2 = peDs047.peImre ;
            xbmis2 = peDs047.peBmis ;
            xcoi12 = peDs047.peCoi1 ;
            xcoi22 = peDs047.peCoi2 ;
            xacum2 = peDs047.peAcum ;
            xapoi2 = peDs047.peApoi ;
            xapoc2 = peDs047.peApoc ;
         endif;

         if wzre03 <> *blanks ;
            peDs047 = wzre03        ;
            xnrcm3 = peDs047.peNrcm ;
            xpoim3 = peDs047.pePoim ;
            xsure3 = peDs047.peSure ;
            ximre3 = peDs047.peImre ;
            xbmis3 = peDs047.peBmis ;
            xcoi13 = peDs047.peCoi1 ;
            xcoi23 = peDs047.peCoi2 ;
            xacum3 = peDs047.peAcum ;
            xapoi3 = peDs047.peApoi ;
            xapoc3 = peDs047.peApoc ;
         endif;

         if wzre04 <> *blanks ;
            peDs047 = wzre04        ;
            xnrcm4 = peDs047.peNrcm ;
            xpoim4 = peDs047.pePoim ;
            xsure4 = peDs047.peSure ;
            ximre4 = peDs047.peImre ;
            xbmis4 = peDs047.peBmis ;
            xcoi14 = peDs047.peCoi1 ;
            xcoi24 = peDs047.peCoi2 ;
            xacum4 = peDs047.peAcum ;
            xapoi4 = peDs047.peApoi ;
            xapoc4 = peDs047.peApoc ;
         endif;

         if wzre05 <> *blanks ;
            peDs047 = wzre05        ;
            xnrcm5 = peDs047.peNrcm ;
            xpoim5 = peDs047.pePoim ;
            xsure5 = peDs047.peSure ;
            ximre5 = peDs047.peImre ;
            xbmis5 = peDs047.peBmis ;
            xcoi15 = peDs047.peCoi1 ;
            xcoi25 = peDs047.peCoi2 ;
            xacum5 = peDs047.peAcum ;
            xapoi5 = peDs047.peApoi ;
            xapoc5 = peDs047.peApoc ;
         endif;

         if wzre06 <> *blanks ;
            peDs047 = wzre06        ;
            xnrcm6 = peDs047.peNrcm ;
            xpoim6 = peDs047.pePoim ;
            xsure6 = peDs047.peSure ;
            ximre6 = peDs047.peImre ;
            xbmis6 = peDs047.peBmis ;
            xcoi16 = peDs047.peCoi1 ;
            xcoi26 = peDs047.peCoi2 ;
            xacum6 = peDs047.peAcum ;
            xapoi6 = peDs047.peApoi ;
            xapoc6 = peDs047.peApoc ;
         endif;

         if wzre07 <> *blanks ;
            peDs047 = wzre07        ;
            xnrcm7 = peDs047.peNrcm ;
            xpoim7 = peDs047.pePoim ;
            xsure7 = peDs047.peSure ;
            ximre7 = peDs047.peImre ;
            xbmis7 = peDs047.peBmis ;
            xcoi17 = peDs047.peCoi1 ;
            xcoi27 = peDs047.peCoi2 ;
            xacum7 = peDs047.peAcum ;
            xapoi7 = peDs047.peApoi ;
            xapoc7 = peDs047.peApoc ;
         endif;

         if wzre08 <> *blanks ;
            peDs047 = wzre08        ;
            xnrcm8 = peDs047.peNrcm ;
            xpoim8 = peDs047.pePoim ;
            xsure8 = peDs047.peSure ;
            ximre8 = peDs047.peImre ;
            xbmis8 = peDs047.peBmis ;
            xcoi18 = peDs047.peCoi1 ;
            xcoi28 = peDs047.peCoi2 ;
            xacum8 = peDs047.peAcum ;
            xapoi8 = peDs047.peApoi ;
            xapoc8 = peDs047.peApoc ;
         endif;

         if wzre09 <> *blanks ;
            peDs047 = wzre09        ;
            xnrcm9 = peDs047.peNrcm ;
            xpoim9 = peDs047.pePoim ;
            xsure9 = peDs047.peSure ;
            ximre9 = peDs047.peImre ;
            xbmis9 = peDs047.peBmis ;
            xcoi19 = peDs047.peCoi1 ;
            xcoi29 = peDs047.peCoi2 ;
            xacum9 = peDs047.peAcum ;
            xapoi9 = peDs047.peApoi ;
            xapoc9 = peDs047.peApoc ;
         endif;

          // En este punto remacho el CME sobre RI3
         if wzre11 <> *blanks ;
            peDs047 = wzre11        ;
            xnrcm2 = peDs047.peNrcm ;
            xpoim2 = peDs047.pePoim ;
            xsure2 = peDs047.peSure ;
            ximre2 = peDs047.peImre ;
            xbmis2 = peDs047.peBmis ;
            xcoi12 = peDs047.peCoi1 ;
            xcoi22 = peDs047.peCoi2 ;
            xacum2 = peDs047.peAcum ;
            xapoi2 = peDs047.peApoi ;
            xapoc2 = peDs047.peApoc ;
         endif;

         // En este punto armo Empleadores EMP Linea 10
         if wzre13 <> *blanks ;
            peDs047 = wzre13        ;
            xnrcm0 = peDs047.peNrcm ;
            xpoim0 = peDs047.pePoim ;
            xsure0 = peDs047.peSure ;
            ximre0 = peDs047.peImre ;
            xbmis0 = peDs047.peBmis ;
            xcoi10 = peDs047.peCoi1 ;
            xcoi20 = peDs047.peCoi2 ;
            xacum0 = peDs047.peAcum ;
            xapoi0 = peDs047.peApoi ;
            xapoc0 = peDs047.peApoc ;
         endif;

         // Acá estoy llegando con la base Imponible mas IVA mas
         // Retenciones Calculadas...
         // tengo que calcular el neto a pagar.
         wxnetc  = wxsubt - ximre1 ;
         wxnetc -= ximre2 ;
         wxnetc -= ximre3 ;
         wxnetc -= ximre4 ;
         wxnetc -= ximre5 ;
         wxnetc -= ximre6 ;
         wxnetc -= ximre7 ;
         wxnetc -= ximre8 ;
         wxnetc -= ximre9 ;
         wxnetc -= ximre0 ;
       endif;

       // Me falta resolver el tema de si la reserva es en moneda
       // extranjera.

       // obtengo Nro.Orden de Pago

       p@pacp = 0;
       t@pacp = 0;
       if peTipa <>'C'; //no grabar en calculo
          k1ytopa.t@Empr = peEmpr;
          k1ytopa.t@Sucu = peSucu;
          k1ytopa.t@artc = p@artc;
          chain %kds(k1ytopa) cntopa;
          if %found(cntopa);
             t@pacp += 1;
             update c1topa;
          endif;
       endif;

       p@pacp = t@pacp;

       // Fecha Probable de Pago ------------------------------
       if peFeop <> *blanks ;
          x3fppa = %dec(%subst(peFeop:1:4):4:0);
          x3fppm = %dec(%subst(peFeop:6:2):2:0);
          x3fppd = %dec(%subst(peFeop:9:2):2:0);
       else ;
          xxfppa = t@fasa ;
          xxfppm = t@fasm ;
          xxfppd = t@fasd ;
          spopfech( xxfpamd
                  : '+'
                  : 'D'
                  : t@xdia
                  : xxfpamd
                  : @erro );
          x3fppa = xxFppa ;
          x3fppm = xxFppm ;
          x3fppd = xxFppd ;
       endif ;

       // Sumo las perceociones al neto total.
       for x = 1 to 25 ;
          if peimpe(x) <> *zeros ;
             wxnetc += peImpe(x) ;
          endif;
       endfor;

       $artc  = paArtc ;
       $pacp  = t@Pacp ;
       // $piva = x3poim   ;    QQQ - Controlar
       // $ivas = wximiv   ;    QQQ - Controlar
       $coma  = prcoma  ;
       $nrma  = prnrma  ;
       $esma  = presma  ;
       $ticp  = peTifa  ;
       $sucp  = peSufa  ;
       $facn  = peNrfa  ;
       $peffac = peffac ;
       $fafd  = $peffad ;
       $fafm  = $peffam ;
       $fafa  = $peffa2 ;
       @effac = ($peffaa*10000)+($peffam*100)+$peffad;

       // -----------------------------------------------------
       // Write del CNHOPA ------------------------------------
       // -----------------------------------------------------

       paEmpr = peEmpr ;
       paSucu = peSucu ;
       paArtc = p@artc ;
       paPacp = p@pacp ;
       paMoas = '9'    ;
       prComa = peComa ;
       if prComa = '*1';
          prNrma = papacp;
       else;
          prNrma = peNrma;
       endif;
       prdvna = '*'    ;
       presma = *zeros ;
       palibr = t@libr ;
       pafasa = t@fasa ;
       pafasm = t@fasm ;
       pafasd = t@fasd ;
       pacomo = @@DsBe(1).bemonr;
       patico = t@tico ;
       panras = papacp ;
       paimco = *zeros ;
       paimme = *zeros ;
       paimau = wxnetc ;
       if peComa = '*1'  or
          peComa = '**'  or
          peComa <> '*1' and
          peComa <> '**' and
          t@kimp = '0' ;
          panrcm = t@nrcm ;
          padvcm = t@dvcm ;
          pacoma = t@coma ;
          panrma = t@nrma ;
          padvna = t@dvna ;
          paesma = t@esma ;
       else ;
          panrcm = *zeros ;
          padvcm = *blanks;
          pacoma = peComa ;
          panrma = peNrma ;
          padvna = '*'    ;
          paesma = *zeros ;
       endif ;
       // Fecha Probable de Pago ------------------------------
       pafera = x3fppa  ;
       paferm = x3fppm  ;
       paferd = x3fppd  ;
       //
       pbfera = x3fppa  ;
       pbferm = x3fppm  ;
       pbferd = x3fppd  ;
       pacopt = peCopt  ;
       pbcopt = *blanks ;
       pccopt = *blanks ;
       //copt = svpsin_arcopd ;
       $dticp = peTifa  ;
       $dsucp = peSufa  ;
       $dfacn = peNrfa  ;
       $peffac = peffac ;
       $ddiaf = $peffad ;
       $dmesf = $peffam ;
       $daÑof = $peffa2 ;
       pdCopt = $dcopt  ;
       pacode = *zeros  ;
       pbdvcm = ' '     ;
       pacfre = t@cfre  ;
       pauser = peUser  ;
       $uaÑo = uyear    ;
       $umes = umonth   ;
       $udia = uday     ;
       $hora = %dec(%time():*iso) ;
       $abcv = 1 ;
       paafhc = $afhc  ;
       pastop = t@stop ;
       parama = peRama ;
       paliqn = peSini(1).nroStro ;  // QQQ Guardo primer Siniestro
       pamovt = 'S'    ;
       if peNomb <> *blank ;
          panomb = peNomb ;
       else ;
          if peComa <> '**' and peComa <> '*1' ;
            panomb = SVPDAF_getNombre( nanrdf );
          endif;
       endif;

       if peComa = '**' ;
          panomb = SVPDAF_getNombre( penrma );
       endif ;

       if peComa = '*1' ;
          panomb = peNomb ;
       endif ;

       paivcv = peFvdv ;
       painta = t@inta ;
       painna = t@inna ;

       // campo PAMARP sirve solo para Deposito Judicial
       // Ver si se agrega a Post ???
       pamarp = peDeJu ;
       pamp01 = peApol ;
       pamp02 = '0'    ;
       pamp03 = '0'    ;
       pamp04 = '0'    ;
       pamp05 = '0'    ;
       pamp06 = '0'    ;
       pamp07 = '0'    ;
       pamp08 = '0'    ;
       pamp09 = '0'    ;

       if peComa = '*1' or pecoma = '**' ;
          pacofa = '*1' ;
       else ;
          pacofa = nacofa ;
       endif ;

       panrve = *zeros ;
       if peTipa <>'C'; //no grabar en calculo
          write c1hopa ;
       endif;
       unlock cnhopa;

       // -----------------------------------------------------
       // Write del CNHOP1 ------------------------------------
       // -----------------------------------------------------
       // Historico de Pagos Variables.

       if peComa = '*1'  ;
          p1empr = paEmpr ;
          p1sucu = paSucu ;
          p1artc = paArtc ;
          p1pacp = paPacp ;
          p1nomb = SVPDAF_getNombre( peNrma );
          p1domi = SVPDAF_getDomicilio( peNrma
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit );
          rc = SVPDAF_getLocalidad( peNrma
                                  : p1Copo
                                  : p1Cops
                                  : *omit
                                  : *omit
                                  : *omit
                                  : *omit );
          rc = SVPDAF_getDocumento( peNrma
                                  : p1Tido
                                  : p1Nrdo
                                  : *omit
                                  : *omit
                                  : *omit         );
          if peTipa <>'C'; //no grabar en calculo
             write c1hop1 ;
          endif;
          unlock cnhop1;
       endif ;

       // -----------------------------------------------------
       // Write del CNWNIN ------------------------------------
       // -----------------------------------------------------
       // Datos comunes

       niempr = paEmpr ;
       nifasa = paFasa ;
       nifasm = paFasm ;
       nifasd = paFasd ;
       nilibr = paLibr ;
       ninras = paNras ;
       nicomo = paComo ;
       niscor = *zeros ;
       ninrlo = *zeros ;
       nifata = *zeros ;
       nifatm = *zeros ;
       nifatd = *zeros ;
       $artc  = paArtc ;
       $pacp  = paPacp ;
       ninrrf = $nrrf  ;
       nifera = pafera ;
       niferm = paferm ;
       niferd = paferd ;
       nisuc2 = paSucu ;
       nitic2 = patico ;
       nistas = *on    ;
       nimoas = pamoas ;
       niuser = pauser ;

       // Primero se graba la cuenta del gasto.
       wwgens = 120     ;
       wwgess = 1       ;
       $rama = peRama   ;
       if peMar2 = 'I'  ;
          $inga = '1'   ;
       else             ;
          $inga = '2'   ;
       endif            ;
       wwgecv = $gecv   ;
       ninrcm = *zeros  ;
       nicopt = *blanks ;
       k1ytge.tgempr = peEmpr;
       k1ytge.tgsuc2 = peSucu;
       k1ytge.tggens = wwGens;
       k1ytge.tggess = wwGess;
       k1ytge.tggecv = wwGecv;
       chain %kds(k1ytge) gnttge;
       if %found(gnttge);
          ninrcm  = %dec(tggcmg:11:0) ;
       endif;
       nidvcm = '*'     ;
       nicoma = *blanks ;
       ninrma = *zeros  ;
       nidvna = '*'     ;
       niesma = *zeros  ;
       nicopt = pacopt  ;
       chain nicomo gntmon;
       if %found;
          if momoeq = 'AU';
             niimme = 0;
          else;
             niimme = @@mact;
          endif;
       endif;
       nideha = 1       ;
       niuaut = peUser  ;
       nifaut = %dec(%date():*ymd);
       nihaut = %dec(%time():*iso) ;
       niwaut = nomjob  ;
       nipaut = nompgm  ;
       nieaut = *blanks ;

       // Colita del NIN
       niinad = 11      ;
       $piva = x3poim   ;
       $ivas = wximiv   ;
       //propiv         ;
       nican1 = $can1   ;
       nican2 = *zeros  ;
       $coma  = prcoma  ;
       $nrma  = prnrma  ;
       $esma  = presma  ;
       $ticp  = peTifa  ;
       $sucp  = peSufa  ;
       $facn  = peNrfa  ;
       $peffac = peffac ;
       $fafd  = $peffad ;
       $fafm  = $peffam ;
       $fafa  = $peffa2 ;
       @effac = ($peffaa*10000)+($peffam*100)+$peffad;
       nicaa1 = $caa1   ;
       niCaa2 = *all'0' ;

       $piva = x3poim   ;
       for x = 1 to peCant;
          niseas += 1;
          nicopt = 'Stro. Nro. : ' +  %char( peSini(x).nroStro );

          if peTipa = 'T';
             niimau = resSini(x).importe;
          else;
             niimau = peSini(x).importe;
          endif;

          $ivas = niimau * ($piva / 100);
          nican1 = $can1;

          if peTipa <>'C'; //no grabar en calculo
             write c1wnin;
          endif;
          unlock cnwnin;
       endfor;

       nican1 = 0;
       nican2 = 0;
       nicaa1 = *blanks;
       niCaa2 = *blanks;
       niinad = 0;

       // IVA en el NIN

       if wximiv <> *zeros ;
        nicopt = paNomb ;
        ninrcm = xnrcmi ;
        niimau = wximiv ;
        niimco = *zeros ;
        niimme = *zeros ;
        nideha = 1      ;
        niseas += 1      ;
        niuaut = peUser  ;
        nifaut = %dec(%date():*ymd);
        nihaut = %dec(%time():*iso) ;
        niwaut = nomjob  ;
        nipaut = nompgm  ;
        nieaut = *blanks ;
        if peTipa <>'C'; //no grabar en calculo
           write c1wnin;
        endif;
        unlock cnwnin;
       endif;

       // Retenciones
       // 1ra Linea de Retencion...RIV

       if ximre1 <> *zeros ;
        nicopt = peNomb ;
        ninrcm = xnrcm1 ;
        niimau = ximre1 ;
        wapoi  = xapoi1 ;
        wapoc  = xapoc1 ;
        nideha = 2      ;

        if ximre1 < *zeros ;
           nideha = 1    ;
        endif;
        niseas += 1      ;
        niuaut = peUser  ;
        nifaut = %dec(%date():*ymd);
        nihaut = %dec(%time():*iso) ;
        niwaut = nomjob  ;
        nipaut = nompgm  ;
        nieaut = *blanks ;
        if peTipa <>'C'; //no grabar en calculo
           write c1wnin     ;
        endif;
        unlock cnwnin;
        // grania
       endif;

       if ximre2 <> *zeros ;
        nicopt = peNomb ;
        ninrcm = xnrcm2 ;
        niimau = ximre2 ;
        wapoi  = xapoi2 ;
        wapoc  = xapoc2 ;
        nideha = 2      ;

        if ximre2 < *zeros ;
          nideha = 2      ;
        endif;
        niseas += 1      ;
        niuaut = peUser  ;
        nifaut = %dec(%date():*ymd);
        nihaut = %dec(%time():*iso) ;
        niwaut = nomjob  ;
        nipaut = nompgm  ;
        nieaut = *blanks ;
        if peTipa <>'C'; //no grabar en calculo
           write c1wnin     ;
        endif;
        unlock cnwnin;
       // grania
       endif;

       if ximre3 <> *zeros ;
        nicopt = peNomb ;
        ninrcm = xnrcm3 ;
        niimau = ximre3 ;
        wapoi  = xapoi3 ;
        wapoc  = xapoc3 ;
        nideha = 2      ;

        if ximre3 < *zeros ;
          nideha = 1      ;
        endif;
        niseas += 1      ;
        niuaut = peUser  ;
        nifaut = %dec(%date():*ymd);
        nihaut = %dec(%time():*iso) ;
        niwaut = nomjob  ;
        nipaut = nompgm  ;
        nieaut = *blanks ;
        if peTipa <>'C'; //no grabar en calculo
           write c1wnin     ;
        endif;
        unlock cnwnin;
       // grania
       endif;

       if ximre4 <> *zeros ;
        nicopt = peNomb ;
        ninrcm = xnrcm4 ;
        niimau = ximre4 ;
        wapoi  = xapoi4 ;
        wapoc  = xapoc4 ;
        nideha = 2      ;

        if ximre4 < *zeros ;
          nideha = 1      ;
        endif;
        niseas += 1      ;
        niuaut = peUser  ;
        nifaut = %dec(%date():*ymd);
        nihaut = %dec(%time():*iso) ;
        niwaut = nomjob  ;
        nipaut = nompgm  ;
        nieaut = *blanks ;
        if peTipa <>'C'; //no grabar en calculo
           write c1wnin     ;
        endif;
        unlock cnwnin;
       // grania
       endif;

       if ximre5 <> *zeros ;
        nicopt = peNomb ;
        ninrcm = xnrcm5 ;
        niimau = ximre5 ;
        wapoi  = xapoi5 ;
        wapoc  = xapoc5 ;
        nideha = 2      ;

        if ximre5 < *zeros ;
          nideha = 1      ;
        endif;
        niseas += 1      ;
        niuaut = peUser  ;
        nifaut = %dec(%date():*ymd);
        nihaut = %dec(%time():*iso) ;
        niwaut = nomjob  ;
        nipaut = nompgm  ;
        nieaut = *blanks ;
        if peTipa <>'C'; //no grabar en calculo
           write c1wnin     ;
        endif;
        unlock cnwnin;
       // grania
       endif;

       if ximre6 <> *zeros ;
        nicopt = peNomb ;
        ninrcm = xnrcm6 ;
        niimau = ximre6 ;
        wapoi  = xapoi6 ;
        wapoc  = xapoc6 ;
        nideha = 2      ;

        if ximre6 < *zeros ;
          nideha = 1      ;
        endif;
        niseas += 1      ;
        niuaut = peUser  ;
        nifaut = %dec(%date():*ymd);
        nihaut = %dec(%time():*iso) ;
        niwaut = nomjob  ;
        nipaut = nompgm  ;
        nieaut = *blanks ;
        if peTipa <>'C'; //no grabar en calculo
           write c1wnin     ;
        endif;
        unlock cnwnin;
       // grania
       endif;

       if ximre7 <> *zeros ;
        nicopt = peNomb ;
        ninrcm = xnrcm7 ;
        niimau = ximre7 ;
        wapoi  = xapoi7 ;
        wapoc  = xapoc7 ;
        nideha = 2      ;

        if ximre7 < *zeros ;
           nideha = 1      ;
        endif;
        niseas += 1      ;
        niuaut = peUser  ;
        nifaut = %dec(%date():*ymd);
        nihaut = %dec(%time():*iso) ;
        niwaut = nomjob  ;
        nipaut = nompgm  ;
        nieaut = *blanks ;
        if peTipa <>'C'; //no grabar en calculo
           write c1wnin     ;
        endif;
        unlock cnwnin;
       // grania
       endif;

       if ximre8 <> *zeros ;
        nicopt = peNomb ;
        ninrcm = xnrcm8 ;
        niimau = ximre8 ;
        wapoi  = xapoi8 ;
        wapoc  = xapoc8 ;
        nideha = 2      ;

        if ximre8 < *zeros ;
          nideha = 1      ;
        endif;
        niseas += 1      ;
        niuaut = peUser  ;
        nifaut = %dec(%date():*ymd);
        nihaut = %dec(%time():*iso) ;
        niwaut = nomjob  ;
        nipaut = nompgm  ;
        nieaut = *blanks ;
        if peTipa <>'C'; //no grabar en calculo
           write c1wnin     ;
        endif;
        unlock cnwnin;
       // grania
       endif;

       if ximre9 <> *zeros ;
        nicopt = peNomb ;
        ninrcm = xnrcm9 ;
        niimau = ximre9 ;
        wapoi  = xapoi9 ;
        wapoc  = xapoc9 ;
        nideha = 2      ;

        if ximre9 < *zeros ;
          nideha = 1      ;
        endif;
        niseas += 1      ;
        niuaut = peUser  ;
        nifaut = %dec(%date():*ymd);
        nihaut = %dec(%time():*iso) ;
        niwaut = nomjob  ;
        nipaut = nompgm  ;
        nieaut = *blanks ;
        if peTipa <>'C'; //no grabar en calculo
           write c1wnin     ;
        endif;
        unlock cnwnin;
       // grania
       endif;

       if ximre0 <> *zeros ;
        nicopt = peNomb ;
        ninrcm = xnrcm0 ;
        niimau = ximre0 ;
        wapoi  = xapoi0 ;
        wapoc  = xapoc0 ;
        nideha = 2      ;

        if ximre0 < *zeros ;
          nideha = 1      ;
        endif;
        niseas += 1      ;
        niuaut = peUser  ;
        nifaut = %dec(%date():*ymd);
        nihaut = %dec(%time():*iso) ;
        niwaut = nomjob  ;
        nipaut = nompgm  ;
        nieaut = *blanks ;
        if peTipa <>'C'; //no grabar en calculo
           write c1wnin     ;
        endif;
        unlock cnwnin;
       // grania
       endif;

       // A Proveedor...
       ninrcm = *zeros  ;
       nidvcm = '*'     ;
       nicoma = pacoma  ;
       ninrma = panrma  ;
       nidvna = padvna  ;
       niesma = paesma  ;
       nicopt = pacopt  ;
       niimco = paimco  ;
       niimme = paimme  ;
       niimau = paimau  ;
       nideha = 2       ;
       niseas += 1      ;
       niuaut = peUser  ;
       nifaut = %dec(%date():*ymd);
       nihaut = %dec(%time():*iso) ;
       niwaut = nomjob  ;
       nipaut = nompgm  ;
       nieaut = *blanks ;
       if peTipa <>'C'; //no grabar en calculo
          write c1wnin     ;
       endif;
       unlock cnwnin;

       // Retenciones en CNHRET...
       // Datos Comunes

       rtempr = paempr ;
       rtsucu = pasucu ;
       rtfepa = pafasa ;
       rtfepm = pafasm ;
       rtfepd = pafasd ;
       rtcoma = pacoma ;
       rtnrma = panrma ;
       rtlibr = palibr ;
       rtnras = panras ;
       rtcomo = pacomo ;
       rtcome = *zeros ;
       //rtmonp = *zeros ;
       rtiimp = *zeros ;
       rtirmp = *zeros ;
       rtnrrf = ninrrf ;
       rtmoas = pamoas ;
       rttico = patico ;
       rtsucp = pesufa ;
       rtfacn = penrfa ;
       rtfafa = $peFfaa;
       rtfafm = $peFfam;
       rtfafd = $peFfad;
       rtpacp = *zeros ;
       rtmarp = ' ';
       rxnras = *zeros ;
       r1marp = *blanks;

       // -------------           R I V           -------------
       clear @J;

       if ximre1 <> *zeros ;
         rttiic = 'RIV'  ;
         rtrpro = 0 ;
         rtivse = SVPSIN_obtSecRet( rtempr : rtsucu : rttiic :
                                    rtfepa : rtfepm : rtcoma :
                                    rtnrma : rtrpro ) ;
         rtiiau = xsure1 ;
         rtirau = ximre1 ;
         wapoi  = xapoi1 ;
         wapoc  = xapoc1 ;
         rtpoim = xpoim1 ;
         rtbmis = xbmis1 ;
         rtcoi1 = xcoi11 ;
         rtcoi2 = xcoi21 ;
         rtrbau = @@mact ;
         r2marp = *blanks;
         rtiime = rtiiau ;
         rtirme = rtirau ;
         rtcome = *zeros ;

         if rtirau <> 0;
            rtmarp = '1';
         endif;
         if peTipa <>'C'; //no grabar en calculo
            write c1hret     ;
         endif;
         unlock cnhret;

         //Valores output Orden de Pago
         @J += 1;
         peValo.retenciones.retencion(@J).tiic = rttiic;
         chain(n) rttiic gntdim;
         if %found (gntdim);
           peValo.retenciones.retencion(@J).tiid = ditiid;
         else;
           peValo.retenciones.retencion(@J).tiid = *zeros;
         endif;
         peValo.retenciones.retencion(@J).prod =
                   SVPDES_provinciaInder(rtrpro);
         peValo.retenciones.retencion(@J).poim = rtpoim;
         peValo.retenciones.retencion(@J).iiau = rtiiau;
         peValo.retenciones.retencion(@J).irau = rtirau;
         peValo.retenciones.retencion(@J).pacp = rtpacp;

       endif ;

       // -------------           C M E           -------------
       if ximre2 <> *zeros ;
         rttiic = 'CME'  ;
         rtrpro = *zeros ;
         rtivse = SVPSIN_obtSecRet( rtempr : rtsucu : rttiic :
                                    rtfepa : rtfepm : rtcoma :
                                    rtnrma : rtrpro ) ;
         rtiiau = xsure2 ;
         rtirau = ximre2 ;
         wapoi  = xapoi2 ;
         wapoc  = xapoc2 ;
         rtpoim = xpoim2 ;
         rtbmis = xbmis2 ;
         rtcoi1 = xcoi12 ;
         rtcoi2 = xcoi22 ;
         rtrbau = *zeros ;
         r2marp = *blanks;
         rtiime = rtiiau ;
         rtirme = rtirau ;
         rtcome = *zeros ;

         if rtirau <> 0;
            rtmarp = '1';
         endif;
         if peTipa <>'C'; //no grabar en calculo
            write c1hret     ;
         endif;
         unlock cnhret;

         //Valores output Orden de Pago
         @J += 1;
         peValo.retenciones.retencion(@J).tiic = rttiic;
         chain(n) rttiic gntdim;
         if %found (gntdim);
           peValo.retenciones.retencion(@J).tiid = ditiid;
         else;
           peValo.retenciones.retencion(@J).tiid = *zeros;
         endif;
         peValo.retenciones.retencion(@J).prod =
                   SVPDES_provinciaInder(rtrpro);
         peValo.retenciones.retencion(@J).poim = rtpoim;
         peValo.retenciones.retencion(@J).iiau = rtiiau;
         peValo.retenciones.retencion(@J).irau = rtirau;
         peValo.retenciones.retencion(@J).pacp = rtpacp;
       endif ;

       // -------------           I G A           -------------
       rttiic = 'IGA'  ;
       rtrpro = *zeros ;
       rtivse = SVPSIN_obtSecRet( rtempr : rtsucu : rttiic :
                                  rtfepa : rtfepm : rtcoma :
                                  rtnrma : rtrpro ) ;
       rtiiau = xsure3 ;
       rtirau = ximre3 ;
       wapoi  = xapoi3 ;
       wapoc  = xapoc3 ;
       rtpoim = xpoim3 ;
       rtbmis = xbmis3 ;
       rtcoi1 = xcoi13 ;
       rtcoi2 = xcoi23 ;
       rtrbau = @@mact ;
       r2marp = *blanks;
       rtiime = rtiiau ;
       rtirme = rtirau ;
       rtcome = *zeros ;
       if rtirau <> 0;
          rtmarp = '1';
       endif;
       if peTipa <>'C'; //no grabar en calculo
          write c1hret     ;
       endif;
       unlock cnhret;

       //Valores output Orden de Pago
       @J += 1;
       peValo.retenciones.retencion(@J).tiic = rttiic;
       chain(n) rttiic gntdim;
       if %found (gntdim);
         peValo.retenciones.retencion(@J).tiid = ditiid;
       else;
         peValo.retenciones.retencion(@J).tiid = *zeros;
       endif;
       peValo.retenciones.retencion(@J).prod =
                 SVPDES_provinciaInder(rtrpro);
       peValo.retenciones.retencion(@J).poim = rtpoim;
       peValo.retenciones.retencion(@J).iiau = rtiiau;
       peValo.retenciones.retencion(@J).irau = rtirau;
       peValo.retenciones.retencion(@J).pacp = rtpacp;

       // -------------           I B B           -------------
       if ximre4 <> *zeros ;
         rttiic = 'IBR'  ;
         rtrpro = prrpro ;
         rtivse = SVPSIN_obtSecRet( rtempr : rtsucu : rttiic :
                                    rtfepa : rtfepm : rtcoma :
                                    rtnrma : rtrpro ) ;
         rtiiau = xsure4 ;
         rtirau = ximre4 ;
         wapoi  = xapoi4 ;
         wapoc  = xapoc4 ;
         rtpoim = xpoim4 ;
         rtbmis = xbmis4 ;
         rtcoi1 = xcoi14 ;
         rtcoi2 = xcoi24 ;
         rtrbau = *zeros ;
         r2marp = *blanks;
         rtiime = rtiiau ;
         rtirme = rtirau ;
         rtcome = *zeros ;
         if rtirau <> 0;
            rtmarp = '1';
         endif;
         if peTipa <>'C'; //no grabar en calculo
            write c1hret     ;
         endif;
         unlock cnhret;

         //Valores output Orden de Pago
         @J += 1;
         peValo.retenciones.retencion(@J).tiic = rttiic;
         chain(n) rttiic gntdim;
         if %found (gntdim);
           peValo.retenciones.retencion(@J).tiid = ditiid;
         else;
           peValo.retenciones.retencion(@J).tiid = *zeros;
         endif;
         peValo.retenciones.retencion(@J).prod =
                  SVPDES_provinciaInder(rtrpro);
         peValo.retenciones.retencion(@J).poim = rtpoim;
         peValo.retenciones.retencion(@J).iiau = rtiiau;
         peValo.retenciones.retencion(@J).irau = rtirau;
         peValo.retenciones.retencion(@J).pacp = rtpacp;
       endif ;

       // -------------           I B I           -------------
       if ximre5 <> *zeros ;
         rttiic = 'IBR'  ;
         rtrpro = prrpro ;
         rtivse = SVPSIN_obtSecRet( rtempr : rtsucu : rttiic :
                                    rtfepa : rtfepm : rtcoma :
                                    rtnrma : rtrpro ) ;
         rtiiau = xsure5 ;
         rtirau = ximre5 ;
         wapoi  = xapoi5 ;
         wapoc  = xapoc5 ;
         rtpoim = xpoim5 ;
         rtbmis = xbmis5 ;
         rtcoi1 = xcoi15 ;
         rtcoi2 = xcoi25 ;
         rtrbau = *zeros ;
         r2marp = *blanks;
         rtiime = rtiiau ;
         rtirme = rtirau ;
         rtcome = *zeros ;
         if rtirau <> 0;
            rtmarp = '1';
         endif;
         if peTipa <>'C'; //no grabar en calculo
            write c1hret     ;
         endif;
         unlock cnhret;

         //Valores output Orden de Pago
         @J += 1;
         peValo.retenciones.retencion(@J).tiic = rttiic;
         chain(n) rttiic gntdim;
         if %found (gntdim);
           peValo.retenciones.retencion(@J).tiid = ditiid;
         else;
           peValo.retenciones.retencion(@J).tiid = *zeros;
         endif;
         peValo.retenciones.retencion(@J).prod =
                   SVPDES_provinciaInder(rtrpro);
         peValo.retenciones.retencion(@J).poim = rtpoim;
         peValo.retenciones.retencion(@J).iiau = rtiiau;
         peValo.retenciones.retencion(@J).irau = rtirau;
         peValo.retenciones.retencion(@J).pacp = rtpacp;
       endif ;

       // -------------           J U B           -------------
       if ximre6 <> *zeros ;
         rttiic = 'JUB'  ;
         rtrpro = *zeros ;
         rtivse = SVPSIN_obtSecRet( rtempr : rtsucu : rttiic :
                                    rtfepa : rtfepm : rtcoma :
                                    rtnrma : rtrpro ) ;
         rtiiau = xsure6 ;
         rtirau = ximre6 ;
         wapoi  = xapoi6 ;
         wapoc  = xapoc6 ;
         rtpoim = xpoim6 ;
         rtbmis = xbmis6 ;
         rtcoi1 = xcoi16 ;
         rtcoi2 = xcoi26 ;
         rtrbau = *zeros ;
         r2marp = *blanks;
         rtiime = rtiiau ;
         rtirme = rtirau ;
         rtcome = *zeros ;
         if rtirau <> 0;
            rtmarp = '1';
         endif;
         if peTipa <>'C'; //no grabar en calculo
            write c1hret     ;
         endif;
         unlock cnhret;

         //Valores output Orden de Pago
         @J += 1;
         peValo.retenciones.retencion(@J).tiic = rttiic;
         chain(n) rttiic gntdim;
         if %found (gntdim);
           peValo.retenciones.retencion(@J).tiid = ditiid;
         else;
           peValo.retenciones.retencion(@J).tiid = *zeros;
         endif;
         peValo.retenciones.retencion(@J).prod =
                   SVPDES_provinciaInder(rtrpro);
         peValo.retenciones.retencion(@J).poim = rtpoim;
         peValo.retenciones.retencion(@J).iiau = rtiiau;
         peValo.retenciones.retencion(@J).irau = rtirau;
         peValo.retenciones.retencion(@J).pacp = rtpacp;

       endif ;

       // -------------           S S S           -------------
       if ximre7 <> *zeros ;
         rttiic = 'SSS'  ;
         rtrpro = *zeros ;
         rtivse = SVPSIN_obtSecRet( rtempr : rtsucu : rttiic :
                                    rtfepa : rtfepm : rtcoma :
                                    rtnrma : rtrpro ) ;
         rtiiau = xsure7 ;
         rtirau = ximre7 ;
         wapoi  = xapoi7 ;
         wapoc  = xapoc7 ;
         rtpoim = xpoim7 ;
         rtbmis = xbmis7 ;
         rtcoi1 = xcoi17 ;
         rtcoi2 = xcoi27 ;
         rtrbau = *zeros ;
         r2marp = *blanks;
         rtiime = rtiiau ;
         rtirme = rtirau ;
         rtcome = *zeros ;
         if rtirau <> 0;
            rtmarp = '1';
         endif;
         if peTipa <>'C'; //no grabar en calculo
            write c1hret     ;
         endif;
         unlock cnhret;

         //Valores output Orden de Pago
         @J += 1;
         peValo.retenciones.retencion(@J).tiic = rttiic;
         chain(n) rttiic gntdim;
         if %found (gntdim);
           peValo.retenciones.retencion(@J).tiid = ditiid;
         else;
           peValo.retenciones.retencion(@J).tiid = *zeros;
        endif;
         peValo.retenciones.retencion(@J).prod =
                   SVPDES_provinciaInder(rtrpro);
         peValo.retenciones.retencion(@J).poim = rtpoim;
         peValo.retenciones.retencion(@J).iiau = rtiiau;
         peValo.retenciones.retencion(@J).irau = rtirau;
         peValo.retenciones.retencion(@J).pacp = rtpacp;
       endif ;

       // -------------           O T 1           -------------
       if ximre8 <> *zeros ;
         rttiic = 'OT1'  ;
         rtrpro = *zeros ;
         rtivse = SVPSIN_obtSecRet( rtempr : rtsucu : rttiic :
                                    rtfepa : rtfepm : rtcoma :
                                    rtnrma : rtrpro ) ;
         rtiiau = xsure8 ;
         rtirau = ximre8 ;
         wapoi  = xapoi8 ;
         wapoc  = xapoc8 ;
         rtpoim = xpoim8 ;
         rtbmis = xbmis8 ;
         rtcoi1 = xcoi18 ;
         rtcoi2 = xcoi28 ;
         rtrbau = *zeros ;
         r2marp = *blanks;
         rtiime = rtiiau ;
         rtirme = rtirau ;
         rtcome = *zeros ;
         if rtirau <> 0;
            rtmarp = '1';
         endif;
         if peTipa <>'C'; //no grabar en calculo
           write c1hret     ;
         endif;
         unlock cnhret;

         //Valores output Orden de Pago
         @J += 1;
         peValo.retenciones.retencion(@J).tiic = rttiic;
         chain(n) rttiic gntdim;
         if %found (gntdim);
           peValo.retenciones.retencion(@J).tiid = ditiid;
         else;
           peValo.retenciones.retencion(@J).tiid = *zeros;
         endif;
         peValo.retenciones.retencion(@J).prod =
                   SVPDES_provinciaInder(rtrpro);
         peValo.retenciones.retencion(@J).poim = rtpoim;
         peValo.retenciones.retencion(@J).iiau = rtiiau;
         peValo.retenciones.retencion(@J).irau = rtirau;
         peValo.retenciones.retencion(@J).pacp = rtpacp;
       endif ;

       // -------------           O T 2           -------------
       if ximre9 <> *zeros ;
         rttiic = 'OT2'  ;
         rtrpro = *zeros ;
         rtivse = SVPSIN_obtSecRet( rtempr : rtsucu : rttiic :
                                    rtfepa : rtfepm : rtcoma :
                                    rtnrma : rtrpro ) ;
         rtiiau = xsure9 ;
         rtirau = ximre9 ;
         wapoi  = xapoi9 ;
         wapoc  = xapoc9 ;
         rtpoim = xpoim9 ;
         rtbmis = xbmis9 ;
         rtcoi1 = xcoi19 ;
         rtcoi2 = xcoi29 ;
         rtrbau = *zeros ;
         r2marp = *blanks;
         rtiime = rtiiau ;
         rtirme = rtirau ;
         rtcome = *zeros ;
         if rtirau <> 0;
            rtmarp = '1';
         endif;
         if peTipa <>'C'; //no grabar en calculo
            write c1hret     ;
         endif;
         unlock cnhret;

         //Valores output Orden de Pago
         @J += 1;
         peValo.retenciones.retencion(@J).tiic = rttiic;
         chain(n) rttiic gntdim;
         if %found (gntdim);
           peValo.retenciones.retencion(@J).tiid = ditiid;
         else;
           peValo.retenciones.retencion(@J).tiid = *zeros;
         endif;
         peValo.retenciones.retencion(@J).prod =
                   SVPDES_provinciaInder(rtrpro);
         peValo.retenciones.retencion(@J).poim = rtpoim;
         peValo.retenciones.retencion(@J).iiau = rtiiau;
         peValo.retenciones.retencion(@J).irau = rtirau;
         peValo.retenciones.retencion(@J).pacp = rtpacp;
       endif ;

       // -------------           E M P           -------------
       if ximre0 <> *zeros ;
         rttiic = 'EMP'  ;
         rtrpro = *zeros ;
         rtivse = SVPSIN_obtSecRet( rtempr : rtsucu : rttiic :
                                    rtfepa : rtfepm : rtcoma :
                                    rtnrma : rtrpro ) ;
         rtiiau = xsure0 ;
         rtirau = ximre0 ;
         wapoi  = xapoi0 ;
         wapoc  = xapoc0 ;
         rtpoim = xpoim0 ;
         rtbmis = xbmis0 ;
         rtcoi1 = xcoi10 ;
         rtcoi2 = xcoi20 ;
         rtrbau = *zeros ;
         r2marp = *blanks;
         rtiime = rtiiau ;
         rtirme = rtirau ;
         rtcome = *zeros ;
         if rtirau <> 0;
            rtmarp = '1';
         endif;
         if peTipa <>'C'; //no grabar en calculo
            write c1hret     ;
         endif;
         unlock cnhret;

         //Valores output Orden de Pago
         @J += 1;
         peValo.retenciones.retencion(@J).tiic = rttiic;
         chain(n) rttiic gntdim;
         if %found (gntdim);
           peValo.retenciones.retencion(@J).tiid = ditiid;
         else;
           peValo.retenciones.retencion(@J).tiid = *zeros;
         endif;
         peValo.retenciones.retencion(@J).prod =
                   SVPDES_provinciaInder(rtrpro);
         peValo.retenciones.retencion(@J).poim = rtpoim;
         peValo.retenciones.retencion(@J).iiau = rtiiau;
         peValo.retenciones.retencion(@J).irau = rtirau;
         peValo.retenciones.retencion(@J).pacp = rtpacp;
       endif ;

       // ------------------------------------------
       // Percepciones en CNHPER
       // ------------------------------------------
       // Aca debo leer la DIM y loopear programa de fachus
       // hay que sumar las percepciones a los totales por proveedor
       // y algo mas.

       k1ytge.tgempr = peEmpr;
       k1ytge.tgsuc2 = peSucu;
       k1ytge.tggens = 107   ;
       k1ytge.tggess = 04    ;
       k1ytge.tggecv = *blanks;
       chain %kds(k1ytge) gnttge;
       if %found(gnttge);
         $$Cmga = tggcmg ;
       endif;

       x = *zeros ;
       for x = 1 to 25 ;
         if peimpe(x) <> *zeros ;

           //Valores output Orden de Pago
           peValo.percep += peImpe(x);

           $ivas = wximiv;
           $$rpron = peRpro(x) ;
           $$Cmga = tggcmg ;
           $$Cmga = %scanrpl( 'PP' : $$rproa : $$Cmga );
           if peTipa <>'C'; //no grabar en calculo
             if SVPSIN_setPerporProv( peEmpr    : peSucu    : p@Artc
                                    : p@Pacp    : $$Cmgn    : $nrrf
                                    : 'CIP'     : peTifa    : peSufa
                                    : peNrfa    : peRpro(x)
                                    : @@DsBe(1).bemonr
                                    : peImpe(x) : $can1     : *zeros
                                    : $caa1     : *blanks   : peUser )= *on;
             endif;
           endif;
         endif;
       endfor;

       CXP572S( paEmpr : paSucu : pamoas : rtNrrf );

       // -----------------------------------------------------
       // Write del PAHSHP ------------------------------------
       // -----------------------------------------------------

       for x = 1 to peCant;
          k1yshp.hpempr = peEmpr;
          k1yshp.hpsucu = peSucu;
          k1yshp.hprama = peRama;
          k1yshp.hpsini = peSini(x).nroStro;
          k1yshp.hpnops = peSini(x).nroOperStro;
          k1yshp.hppoco = @@dsBe(x).bePoco;
          k1yshp.hppaco = @@dsBe(x).bePaco;
          k1yshp.hpnrdf = @@dsBe(x).beNrdf;
          k1yshp.hpsebe = @@dsBe(x).beSebe;

          if peTipa = 'T';
             k1yshp.hpriec = @@dsBe(x).beriec;
             k1yshp.hpxcob = @@dsBe(x).bexcob;
          else;
             k1yshp.hpriec = peSini(x).codigoRiesgo;
             k1yshp.hpxcob = peSini(x).codigoCobertu;
          endif;

          k1yshp.hpfmoa = x3fasa;
          k1yshp.hpfmom = x3fasm;
          k1yshp.hpfmod = x3fasd;

          setgt %kds(k1yshp:14) pahshp12;
          readpe(n) %kds(k1yshp:14) pahshp12;
          if %eof(pahshp12);
             wwpsec = 0;
          else;
             wwpsec = hppsec ;
          endif;
          wwpsec += 1 ;

          clear peDshp ;
          peDshp.hpempr = peempr ;
          peDshp.hpsucu = pesucu ;
          peDshp.hprama = perama ;
          peDshp.hpsini = peSini(x).nroStro;
          peDshp.hpnops = peSini(x).nroOperStro;
          peDshp.hppoco = @@dsBe(x).bePoco;
          peDshp.hppaco = @@dsBe(x).bePaco;

          if peTipa = 'T';
             peDshp.hpriec = @@dsBe(x).beriec;
             peDshp.hpxcob = @@dsBe(x).bexcob;
             peDshp.hpimmr = resSini(x).importe;
             peDshp.hpimau = resSini(x).importe;
          else;
             peDshp.hpriec = peSini(x).codigoRiesgo;
             peDshp.hpxcob = peSini(x).codigoCobertu;
             peDshp.hpimmr = peSini(x).importe;
             peDshp.hpimau = peSini(x).importe;
          endif;

          peDshp.hpnrdf = @@dsBe(x).beNrdf;
          peDshp.hpsebe = @@dsBe(x).beSebe;
          peDshp.hpfasa = x3fasa ;
          peDshp.hpfasm = x3fasm ;
          peDshp.hpfasd = x3fasd ;
          peDshp.hpfmoa = x3fasa ;
          peDshp.hpfmom = x3fasm ;
          peDshp.hpfmod = x3fasd ;
          peDshp.hppsec = wwpsec ;
          peDshp.hpmonr = @@dsBe(x).bemonr;
          peDshp.hpmoeq = @@dsBe(x).bemoeq;
          peDshp.hpimco = *zeros ;
          peDshp.hpartc = p@artc ;
          peDshp.hppacp = p@pacp ;
          peDshp.hpmar1 = pemar2 ;
          peDshp.hpmar2 = pemar1 ;
          peDshp.hpmar3 = '9'    ;
          peDshp.hpmar4 = '9'    ;
          peDshp.hpmar5 = *off   ;
          peDshp.hpuser = peUser ;
          peDshp.hptime = %dec(%time():*iso);
          peDshp.hpfera = *year  ;
          peDshp.hpferm = umonth ;
          peDshp.hpferd = uday   ;

          if peTipa <>'C'; //no grabar en calculo
             rc =  SVPSI1_setPahshp( peDshp ) ;
          endif;
       endfor;

       // No grabar en calculo resto de proceso
       if peTipa <>'C';

         // Graba CNHOP3 si correspondía pago por transferencia y se
         // está pagando con cheque.

         // Write del CNHOP3 - Actualiza CNHOPM n50
         CXP668P ('G':peEmpr:peSucu:p@artc:p@pacp) ;
         CXP526P ('G':peEmpr:peSucu:p@artc:p@pacp) ;

         // Graba Factura en Archivo de Facturas
         if SPVFAC_setFac ( dfCuit
                          : petifa
                          : pesufa
                          : penrfa
                          : @effac
                          : peempr
                          : pesucu
                          : p@artc
                          : p@pacp
                          : peComa
                          : peNrma
                          : *Blanks
                          : peUser );
         endif;

         // Actualizar Cuenta Corriente
         for x = 1 to peCant;
            rc = SVPSIN_updCtaCte ( peRama
                                  : peSini(x).nroStro
                                  : peSini(x).nroOperStro );
         endfor;
       endif;

       //Valores output Orden de Pago
       peValo.total    = @@mact;
       peValo.valorIva = wximiv;
       peValo.subTotal = peValo.total + peValo.valorIva;
       peValo.neto     = wxnetc;

       return $nrr1;

      /end-free

     P SVPSIN_generarOrdPagStroTotal...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getIvaProveedor : Recupera Iva de los proveedores     *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peComa   ( input  ) Código Mayor Auxiliar            *
      *         peNrma   ( input  ) Número Mayor Auxiliar            *
      *         peFasa   ( input  ) Fecha Año                        *
      *         peFasm   ( input  ) Fecha Mes                        *
      *         peFasd   ( input  ) Fecha Día                        *
      *         peTifa   ( input  ) Tipo de Factura                  *
      *         peCoi2   ( output ) Cod.Categ.Ret/Imp-COI2           *
      *         peCoi1   ( output ) Cod.Inscripción-COI1             *
      *         pePoim   ( output ) Porcentaje del Impuesto          *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_getIvaProveedor...
     P                 B                   export
     D SVPSIN_getIvaProveedor...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       6  0 const
     D   peFasa                       4  0 const
     D   peFasm                       2  0 const
     D   peFasd                       2  0 const
     D   peTifa                       2  0 const
     D   peCoi2                       2  0
     D   peCoi1                       1  0
     D   pePoim                       5  2

     D   peCiva        s              2  0
     D   pePivi        s              5  2
     D   pePivn        s              5  2
     D   peDisf        s              1
     D   peDisa        s              1
     D   peNcil        s             30
     D   peNcic        s              3

      /free

       SVPSIN_inz();

               SP0046 ( peEmpr
                      : peSucu
                      : peComa
                      : peNrma
                      : peFasa
                      : peFasm
                      : peFasd
                      : peCoi2
                      : peCoi1
                      : pePoim ) ;

         if peCoi1 = 1 ;
            if pePoim <> *zeros;
              else ;
                peCiva = 1 ;
                pePivi = *zeros ;
                pePivn = *zeros ;

                weCiva = peCiva ;
                weFasa = peFasa ;
                weFasm = peFasm ;
                weFasd = peFasd ;
                wePivi = *zeros ;
                wePivn = *zeros ;
                weDisf = *blanks;
                weDisa = *blanks;
                weNcil = *blanks;
                weNcic = *blanks;
                  SP0038 ( wpariv) ;
                pePoim = wePivi ;
            endif;
           else;
            if peTifa =  01  or
               peTifa =  02  or
               peTifa =  03  or
               peTifa =  04  or
               peTifa =  05  ;
                peCiva = 1 ;
                pePivi = *zeros ;
                pePivn = *zeros ;
                weCiva = peCiva ;
                weFasa = peFasa ;
                weFasm = peFasm ;
                weFasd = peFasd ;
                wePivi = *zeros ;
                wePivn = *zeros ;
                weDisf = *blanks;
                weDisa = *blanks;
                weNcil = *blanks;
                weNcic = *blanks;
                  SP0038 ( wpariv) ;
               pePoim = wePivi ;
            endif;
         endif;

       return  *on;

      /end-free

     P SVPSIN_getIvaProveedor...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getPerIbrProveedor : Recupera Percepción IBR          *
      *                             Proveedores.                     *
      *                                                              *
      *         peComa   ( input  ) Código Mayor Auxiliar            *
      *         peNrma   ( input  ) Número Mayor Auxiliar            *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPSIN_getPerIbrProveedor...
     P                 B                   export
     D SVPSIN_getPerIbrProveedor...
     D                 pi             1n
     D   peComa                       2    const
     D   peNrma                       6  0 const

     D   pePibr        s              1n

      /free

       SVPSIN_inz();

        SP0091 ( peComa
               : peNrma
               : pePibr );

        return pePibr ;

      /end-free

     P SVPSIN_getPerIbrProveedor...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_setPerporProv(): Graba Percepciones por Provincia          *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          pePacp   ( input  ) Nro Comprobante de Pago              *
      *          peCmga   ( input  ) Gen. Asi. May. Auxiliar              *
      *          peNrrf   ( input  ) Numero Referencia Reg. Asi.          *
      *          peTiic   ( input  ) Codigo de Tipo de Impuesto           *
      *          PeTifa   ( input  ) Tipo de Factura                      *
      *          PeSucp   ( input  ) Sucursal Proveedor                   *
      *          peFacn   ( input  ) Numero de Factura                    *
      *          peRpro   ( input  ) Codigo Pcia. del Inder               *
      *          peComo   ( input  ) Codigo Moneda                        *
      *          peImau   ( input  ) Importe Moneda Cte.                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_setPerporProv...
     P                 B                   export
     D SVPSIN_setPerporProv...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peCmga                      11  0 const
     D   peNrrf                       9  0 const
     D   peTiic                       3    const
     D   peTifa                       2  0 const
     D   peSucp                       4  0 const
     D   peFacn                       8  0 const
     D   peRpro                       2  0 const
     D   peComo                       2    const
     D   peImau                      15  2 const
     D   peCan1                      30  0 const
     D   peCan2                      30  0 const
     D   peCaa1                      30    const
     D   peCaa2                      30    const
     D   peUser                      10a   const options(*nopass:*omit)


     D  @@DsOnin       ds                  likeds(DsCnwnin_t)
     D  @@DsPib        ds                  likeds(Dscnhpib_t)
     D  @@DsMon        ds                  likeds(Dsgntmon_t)
     D  @@DsOpa        ds                  likeds(dsCnhopa_t)
     D  @@Ds456        ds                  likeds(DsSet456_t)
     D  @@ivse         s              5  0
     D  fchsys         s               d   inz(*sys) datfmt(*ymd)
     D  @@Fech         s              8  0

     D  @@Deha         s              1  0
     D  @@Imco         s             15  6
     D  @@Imau         s             15  2
     D  @@Imme         s             15  2
     D  @@user         s             10a


      /free

       SVPSIN_inz();

       @@user = ususr2;
       if %parms >= 18 and %addr(peUser) <> *null;
          @@user = peUser;
       endif;

       clear @@DsOnin ;
       clear @@DsPib  ;
       clear @@DsMon  ;
       clear @@DsOpa  ;
       clear @@Ds456  ;

       if peImau = *zeros;
          return *off;
       endif;

       if SVPTAB_getProvincia(peRpro) = '0';
          return *off;
       endif;

       if SVPVAL_moneda( peComo ) = *off;
          return *off;
       endif;

       @@DsOnin.niimau = peImau;


       if SVPSIN_getCnhopa( peEmpr
                          : peSucu
                          : peArtc
                          : pePacp
                          : @@DsOpa ) = *off;
          return *off;
       endif;

       // Graba NIN por Retenciones
       // busco cotizacion y calculo importes
       SVPTAB_getGntmon( @@DSMon
                       : peComo
                       : *omit  );

       if @@DSMon.moMoeq = 'AU';
          @@imco = *zeros;
          @@imme = *zeros;
       else;
          SVPSIN_getSet456( peEmpr
                          : peSucu
                          : @@Ds456);
          @@Fech = (@@Ds456.t@fema * 10000)
                 + (@@Ds456.t@femm *   100)
                 +  @@Ds456.t@femd;
          @@imco = SVPTAB_cotizaMoneda( peComo : @@Fech );
          eval(h) @@imme = peimau / @@imco;
       endif;

       // DEBE / HABER
       if peImau > *zeros;
          @@deha = 1;
       else;
          @@deha = 2;
       endif;

       @@DsOnin.niEmpr = peEmpr;
       @@DsOnin.niFasa = @@DsOpa.pafasa;
       @@DsOnin.niFasm = @@DsOpa.pafasm;
       @@DsOnin.niFasd = @@DsOpa.pafasd;
       @@DsOnin.niLibr = @@DsOpa.palibr;
       @@DsOnin.niNras = @@DsOpa.panras;
       @@DsOnin.niComo = @@DsOpa.pacomo;
       @@DsOnin.niSeas = SVPSIN_obtSecNin( peEmpr
                                         : @@DsOpa.pasucu
                                         : @@DsOpa.pafasa
                                         : @@DsOpa.pafasm
                                         : @@DsOpa.pafasd
                                         : @@DsOpa.palibr
                                         : @@DsOpa.patico
                                         : @@DsOpa.panras
                                         : @@DsOpa.pacomo );
       @@DsOnin.niScor = *zeros;
       @@DsOnin.niNrlo = *zeros;
       @@DsOnin.niFata = *zeros;
       @@DsOnin.niFatm = *zeros;
       @@DsOnin.niFatd = *zeros;
       @@DsOnin.niNrcm = %int( %char(%scanrpl( 'PP'
                                             : %char(peRpro)
                                             : %char(peCmga))));

       @@DsOnin.niDvcm = '*'           ;
       @@DsOnin.niComa = *blanks       ;
       @@DsOnin.niNrma = *zeros        ;
       @@DsOnin.niDvna = @@DsOpa.paDvna;
       @@DsOnin.niEsma = @@DsOpa.paEsma;
       @@DsOnin.niCopt = @@DsOpa.paNomb;
       @@DsOnin.niNrrf = peNrrf;
       @@DsOnin.niFera = @@DsOpa.paFera;
       @@DsOnin.niFerm = @@DsOpa.paFerm;
       @@DsOnin.niFerd = @@DsOpa.paFerd;
       @@DsOnin.niImco = @@Imco;
       @@DsOnin.niImme = %abs(@@Imme);
       @@DsOnin.niImau = %abs(peImau);
       @@DsOnin.niDeha = @@Deha;
       @@DsOnin.niSuc2 = @@DsOpa.pasucu;
       @@DsOnin.niTic2 = @@DsOpa.patico;
       @@DsOnin.niStas = '1';
       @@DsOnin.niMoas = @@DsOpa.pamoas;
       @@DsOnin.niInad = *zeros;
       @@DsOnin.niCan1 = *zeros;
       @@DsOnin.niCan2 = *zeros;
       @@DsOnin.niCaa1 = *blanks;
       @@DsOnin.niCaa2 = *blanks;
       @@DsOnin.niUser = @@DsOpa.pauser;
       @@DsOnin.niUaut = @@user;
       @@DsOnin.niFaut = %dec(%date():*ymd);
       @@DsOnin.niHaut = %dec(%time():*iso);
       @@DsOnin.niWaut = nomjob;
       @@DsOnin.niPaut = nompgm;
       @@DsOnin.niEaut = *blanks;

       if SVPSIN_setCnwnin(@@DsOnin) = *off;
          return *off;
       endif;
             //      exsr      grania


       // graba PIB por Percepciones
       @@ivse = SVPSIN_obtSecPib( peEmpr
                                : peSucu
                                : peTiic
                                : @@DsOpa.pafasa
                                : @@DsOpa.pafasm
                                : @@DsOpa.paComa
                                : @@DsOpa.paNrma
                                : peRpro );
       @@DSPib.piempr = peEmpr;
       @@DSPib.pisucu = peSucu;
       @@DSPib.pitiic = peTiic;
       @@DSPib.pifepa = @@DsOpa.pafasa;
       @@DSPib.pifepm = @@DsOpa.pafasm;
       @@DSPib.pifepd = @@DsOpa.pafasd;
       @@DSPib.picoma = @@DsOpa.paComa;
       @@DSPib.pinrma = @@DsOpa.paNrma;
       @@DSPib.pirpro = peRpro;
       @@DSPib.piivse = @@Ivse;
       @@DSPib.pilibr = @@DsOpa.palibr;
       @@DSPib.pinras = @@DsOpa.panras;
       @@DSPib.picomo = @@DsOpa.pacomo;
       @@DSPib.picome = @@imco;
       @@DSPib.piiime = *zeros;
       @@DSPib.piirme = *zeros;
       @@DSPib.pimonp = *blanks;
       @@DSPib.picomp = *zeros;
       @@DSPib.piiimp = *zeros;
       @@DSPib.piirmp = *zeros;
       @@DSPib.piiiau = *zeros;
       @@DSPib.piirau = peImau;
       @@DSPib.pipoim = *zeros;
       @@DSPib.pibmis = *zeros;
       @@DSPib.pinrrf = peNrrf;
       @@DSPib.picoi2 = *zeros;
       @@DSPib.picoi1 = *zeros;
       @@DSPib.pimoas = @@DsOpa.pamoas;
       @@DSPib.pitico = @@DsOpa.patico;
       @@DSPib.pitifa = peTifa;
       @@DSPib.pisucp = peSucp;
       @@DSPib.pifacn = pefacn;
       @@DSPib.pifafa = @@DsOpa.pafasa;
       @@DSPib.pifafm = @@DsOpa.pafasm;
       @@DSPib.pifafd = @@DsOpa.pafasd;
       @@DSPib.pipacp = *zeros;
       @@DSPib.pimarp = *blanks;
       @@DSPib.pxnras = *zeros;
       @@DSPib.pirbau = *zeros;
       @@DSPib.pimar1 = *blanks;
       @@DSPib.pimar2 = *blanks;
       if SVPSIN_setCnhpib(@@DSPib) = *off;
          return *off;
       endif;
       //        exsr      grarta

       return *on;

      /end-free

     P SVPSIN_setPerporProv...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_obtSecPib():     Obtiene secuencia del CIP.                *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peTiic   ( input  ) Codigo de Tipo de Impuesto           *
      *          peFepa   ( input  ) Fecha de Pago Anio                   *
      *          peFepm   ( input  ) Fecha de Pago Mes                    *
      *          peComa   ( input  ) codigo de Mayor Auxiliar             *
      *          peNrma   ( input  ) Numero Mayor Auxiliar                *
      *          peRpro   ( input  ) Codigo Pcia. del Inder               *
      *                                                                   *
      * Retorna: Secuencia                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_obtSecPib...
     P                 B                   export
     D SVPSIN_obtSecPib...
     D                 pi             5  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTiic                       3    const
     D   peFepa                       4  0 const
     D   peFepm                       2  0 const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peRpro                       2  0 const

     D   k1ypib        ds                  likerec( c1hpib : *key   )
     D   @@ivse        s                   like(piivse)

      /free

       SVPSIN_inz();

       @@ivse = *zeros ;

       k1ypib.piEmpr = peEmpr;
       k1ypib.piSucu = peSucu;
       k1ypib.piTiic = peTiic;
       k1ypib.piFepa = peFepa;
       k1ypib.piFepm = peFepm;
       k1ypib.piComa = peComa;
       k1ypib.piNrma = peNrma;
       k1ypib.piRpro = peRpro;
       setgt %kds( k1ypib : 8 ) cnhpib;
       readpe %kds( k1ypib : 8 ) cnhpib;
       if not %eof(cnhpib);
          @@ivse = piivse;
       endif;

       @@ivse += 1;

       return @@ivse;

      /end-free

     P SVPSIN_obtSecPib...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_obtSecRet():     Obtiene secuencia del CNHRET              *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peTiic   ( input  ) Codigo de Tipo de Impuesto           *
      *          peFepa   ( input  ) Fecha de Pago Anio                   *
      *          peFepm   ( input  ) Fecha de Pago Mes                    *
      *          peComa   ( input  ) codigo de Mayor Auxiliar             *
      *          peNrma   ( input  ) Numero Mayor Auxiliar                *
      *          peRpro   ( input  ) Codigo Pcia. del Inder               *
      *                                                                   *
      * Retorna: Secuencia                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_obtSecRet...
     P                 B                   export
     D SVPSIN_obtSecRet...
     D                 pi             5  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTiic                       3    const
     D   peFepa                       4  0 const
     D   peFepm                       2  0 const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peRpro                       2  0 const

     D   k1yret        ds                  likerec( c1hret : *key   )
     D   inRet         ds                  likerec( c1hret : *input )
     D   @@ivse        s                   like(rtivse)

      /free

       @@ivse = *zeros ;

       SVPSIN_inz();

       k1yret.rtEmpr = peEmpr;
       k1yret.rtSucu = peSucu;
       k1yret.rtTiic = peTiic;
       k1yret.rtFepa = peFepa;
       k1yret.rtFepm = peFepm;
       k1yret.rtComa = peComa;
       k1yret.rtNrma = peNrma;
       k1yret.rtRpro = peRpro;
       setgt %kds( k1yret : 8 ) cnhret;
       readpe %kds( k1yret : 8 ) cnhret inRet;
       if not %eof(cnhret);
          @@ivse = inRet.rtivse ;
       endif;

       @@ivse += 1;

       return @@ivse;

      /end-free

     P SVPSIN_obtSecRet...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_obtSecNin(): Obtiene secuencia del NIN.                    *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSuc2   ( input  ) Sucursal                             *
      *          pefasa   ( input  ) Codigo de Tipo de Impuesto           *
      *          pefasm   ( input  ) Fecha de Pago Anio                   *
      *          pefasd   ( input  ) Fecha de Pago Mes                    *
      *          peLibr   ( input  ) Codigo de Libro                      *
      *          petic2   ( input  ) Tipo CPTE. SEC.                      *
      *          penras   ( input  ) Numero Asiento                       *
      *          pecomo   ( input  ) Codigo Moneda                        *

      * Retorna: Secuencia Asiento                                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_obtSecNin...
     P                 B                   export
     D SVPSIN_obtSecNin...
     D                 pi             4  0
     D   peEmpr                       1    const
     D   peSuc2                       2    const
     D   pefasa                       4  0 const
     D   pefasm                       2  0 const
     D   pefasd                       2  0 const
     D   peLibr                       1  0 const
     D   petic2                       2  0 const
     D   penras                       7  0 const
     D   pecomo                       2    const

     D   k1ynin        ds                  likerec( c1wnin : *key   )
     D   @@seas        s                   like(niseas)

      /free

       SVPSIN_inz();

       @@seas = *zeros ;

       k1ynin.niEmpr = peEmpr;
       k1ynin.niSuc2 = peSuc2;
       k1ynin.nifasa = pefasa;
       k1ynin.nifasm = pefasm;
       k1ynin.nifasd = pefasd;
       k1ynin.niLibr = peLibr;
       k1ynin.nitic2 = petic2;
       k1ynin.ninras = penras;
       k1ynin.nicomo = pecomo;
       setgt %kds( k1ynin : 9 ) cnwnin;
       readpe(n) %kds( k1ynin : 9 ) cnwnin;
       if not %eof(cnwnin);
          @@seas = niseas;
       endif;

       @@seas +=1;

       return @@seas;

      /end-free

     P SVPSIN_obtSecNin...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_setRetporProv(): Graba Retenciones por Provincia           *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peTiic   ( input  ) Codigo de Tipo de Impuesto           *
      *          peFepa   ( input  ) Fecha Año                            *
      *          peFepm   ( input  ) Fecha Mes                            *
      *          peComa   ( input  ) Código Mayor Auxiliar                *
      *          PeNrma   ( input  ) Número Mayor Auxiliar                *
      *          PeRpro   ( input  ) Provincia                            *
      *          peIvse   ( input  ) Secuencia                            *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_setRetporProv...
     P                 B                   export
     D SVPSIN_setRetporProv...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTiic                       3    const
     D   peFepa                       4  0 const
     D   peFepm                       2  0 const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peRpro                       2  0 const
     D   peIvse                       5  0 const
     D   peDsRet                           likeds(Dscnhret_t)

     D  @@DSRet        ds                  likeds(Dscnhret_t)
     D  @@ivse         s              5  0
     D  fchsys         s               d   inz(*sys) datfmt(*ymd)
     D  @@Fech         s              8  0

     D  @@Deha         s              1  0
     D  @@Imco         s             15  6
     D  @@Imau         s             15  2
     D  @@Imme         s             15  2


      /free

       SVPSIN_inz();

       if SVPTAB_getProvincia(peRpro) = '0';
          return *off;
       endif;

       @@DSRet.rtempr = peDsret.rtempr;
       @@DSRet.rtsucu = peDsret.rtsucu;
       @@DSRet.rttiic = peDsret.rttiic;
       @@DSRet.rtfepa = peDsret.rtfepa;
       @@DSRet.rtfepm = peDsret.rtfepm;
       @@DSRet.rtcoma = peDsret.rtcoma;
       @@DSRet.rtnrma = peDsret.rtnrma;
       @@DSRet.rtrpro = peDsret.rtrpro;
       @@DSRet.rtivse = peDsret.rtivse;
       @@DSRet.rtfepd = peDsret.rtfepd;
       @@DSRet.rtlibr = peDsret.rtlibr;
       @@DSRet.rtnras = peDsret.rtnras;
       @@DSRet.rtcomo = peDsret.rtcomo;
       @@DSRet.rtcome = peDsret.rtcome;
       @@DSRet.rtiime = peDsret.rtiime;
       @@DSRet.rtirme = peDsret.rtirme;
       @@DSRet.rtmonp = peDsret.rtmonp;
       @@DSRet.rtcomp = peDsret.rtcomp;
       @@DSRet.rtiimp = peDsret.rtiimp;
       @@DSRet.rtirmp = peDsret.rtirmp;
       @@DSRet.rtiiau = peDsret.rtiiau;
       @@DSRet.rtirau = peDsret.rtirau;
       @@DSRet.rtpoim = peDsret.rtpoim;
       @@DSRet.rtbmis = peDsret.rtbmis;
       @@DSRet.rtnrrf = peDsret.rtnrrf;
       @@DSRet.rtcoi2 = peDsret.rtcoi2;
       @@DSRet.rtcoi1 = peDsret.rtcoi1;
       @@DSRet.rtmoas = peDsret.rtmoas;
       @@DSRet.rttico = peDsret.rttico;
       @@DSRet.rtsucp = peDsret.rtsucp;
       @@DSRet.rtfacn = peDsret.rtfacn;
       @@DSRet.rtfafa = peDsret.rtfafa;
       @@DSRet.rtfafm = peDsret.rtfafm;
       @@DSRet.rtfafd = peDsret.rtfafd;
       @@DSRet.rtpacp = peDsret.rtpacp;
       @@DSRet.rtmarp = peDsret.rtmarp;
       @@DSRet.rxnras = peDsret.rxnras;
       @@DSRet.rtrbau = peDsret.rtrbau;
       @@DSRet.r1marp = peDsret.r1marp;
       @@DSRet.r2marp = peDsret.r2marp;

       if SVPSIN_setCnhret(@@Dsret) = *off;
          return *off;
       endif;


       return *on;

      /end-free

     P SVPSIN_setRetporProv...
     P                 E


      * ------------------------------------------------------------ *
      * SVPSIN_getRvaXCob(): Retorna Rva Sola por Cobertura          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peRiec   (input)   Código de Riesgo                      *
      *     peXcob   (input)   Código de Cobertura                   *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Rva                                                 *
      * ------------------------------------------------------------ *

     P SVPSIN_getRvaXCob...
     P                 B                   export
     D SVPSIN_getRvaXCob...
     D                 pi            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D k1ysbe          ds                  likerec(p1hsbe05:*key)
     D k1yshr          ds                  likerec(p1hshr:*key)

     D  @@fech         s              8  0
     D  @@mact         s             25  2

      /free

       SVPSIN_inz();

       if %parms >= 9 and %addr(peFech) <> *Null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ('AMD');
       endif;

       @@mact = *Zeros;

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       setll %kds(k1ysbe:6) pahsbe05;
       reade %kds(k1ysbe:6) pahsbe05;
       dow not %eof ;
        if beriec = periec and bexcob = pexcob ;
         leave ;
        endif ;
       reade %kds(k1ysbe:6) pahsbe05;
       enddo;

       k1yshr.hrempr = beempr;
       k1yshr.hrsucu = besucu;
       k1yshr.hrrama = berama;
       k1yshr.hrsini = besini;
       k1yshr.hrnops = benops;
       k1yshr.hrpoco = bepoco;
       k1yshr.hrpaco = bepaco;
       k1yshr.hrnrdf = benrdf;
       k1yshr.hrsebe = besebe;
       k1yshr.hrriec = beriec;
       k1yshr.hrxcob = bexcob;

       setll %kds(k1yshr:11) pahshr;
       reade %kds(k1yshr:11) pahshr;
       dow not %eof and
           SPVFEC_ArmarFecha8 (hrfmoa : hrfmom : hrfmod: 'AMD' ) <= @@fech;
         @@mact += hrimau;
         reade %kds(k1yshr:11) pahshr;
       enddo;

       return @@mact;

      /end-free

     P SVPSIN_getRvaXCob...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getFraXCob(): Retorna Fra Sola por Cobertura          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peRiec   (input)   Código de Riesgo                      *
      *     peXcob   (input)   Código de Cobertura                   *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Rva                                                 *
      * ------------------------------------------------------------ *

     P SVPSIN_getFraXCob...
     P                 B                   export
     D SVPSIN_getFraXCob...
     D                 pi            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D k1ysbe          ds                  likerec(p1hsbe05:*key)
     D k1ysfr          ds                  likerec(p1hsfr:*key)

     D  @@fech         s              8  0
     D  @@mact         s             25  2

      /free

       SVPSIN_inz();

       if %parms >= 9 and %addr(peFech) <> *Null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ('AMD');
       endif;

       @@mact = *Zeros;

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       setll %kds(k1ysbe:6) pahsbe05;
       reade %kds(k1ysbe:6) pahsbe05;
       dow not %eof ;
        if beriec = periec and bexcob = pexcob ;
         leave ;
        endif ;
       reade %kds(k1ysbe:6) pahsbe05;
       enddo;

       k1ysfr.frempr = beempr;
       k1ysfr.frsucu = besucu;
       k1ysfr.frrama = berama;
       k1ysfr.frsini = besini;
       k1ysfr.frnops = benops;
       k1ysfr.frpoco = bepoco;
       k1ysfr.frpaco = bepaco;
       k1ysfr.frnrdf = benrdf;
       k1ysfr.frsebe = besebe;
       k1ysfr.frriec = beriec;
       k1ysfr.frxcob = bexcob;

       setll %kds(k1ysfr:11) pahsfr;
       reade %kds(k1ysfr:11) pahsfr;
       dow not %eof and
           SPVFEC_ArmarFecha8 (frfmoa : frfmom : frfmod: 'AMD' ) <= @@fech;
         @@mact += frimau;
         reade %kds(k1ysfr:11) pahsfr;
       enddo;

       return @@mact;

      /end-free

     P SVPSIN_getFraXCob...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getPagXCob(): Retorna Pag Solo por Cobertura          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peRiec   (input)   Código de Riesgo                      *
      *     peXcob   (input)   Código de Cobertura                   *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Rva                                                 *
      * ------------------------------------------------------------ *

     P SVPSIN_getPagXCob...
     P                 B                   export
     D SVPSIN_getPagXCob...
     D                 pi            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFech                       8  0 options(*omit:*nopass)

     D k1ysbe          ds                  likerec(p1hsbe05:*key)
     D k1yshp          ds                  likerec(p1hshp:*key)

     D  @@fech         s              8  0
     D  @@mact         s             25  2

      /free

       SVPSIN_inz();

       if %parms >= 9 and %addr(peFech) <> *Null;
         @@fech = peFech;
       else;
         @@fech = SPVFEC_FecDeHoy8 ('AMD');
       endif;

       @@mact = *Zeros;

       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;
       setll %kds(k1ysbe:6) pahsbe05;
       reade %kds(k1ysbe:6) pahsbe05;
       dow not %eof ;
        if beriec = periec and bexcob = pexcob ;
         leave ;
        endif ;
       reade %kds(k1ysbe:6) pahsbe05;
       enddo;

       k1yshp.hpempr = beempr;
       k1yshp.hpsucu = besucu;
       k1yshp.hprama = berama;
       k1yshp.hpsini = besini;
       k1yshp.hpnops = benops;
       k1yshp.hppoco = bepoco;
       k1yshp.hppaco = bepaco;
       k1yshp.hpnrdf = benrdf;
       k1yshp.hpsebe = besebe;
       k1yshp.hpriec = beriec;
       k1yshp.hpxcob = bexcob;

       setll %kds(k1yshp:11) pahshp;
       reade %kds(k1yshp:11) pahshp;
       dow not %eof and
           SPVFEC_ArmarFecha8 (hpfmoa : hpfmom : hpfmod: 'AMD' ) <= @@fech;
         @@mact += hpimau;
         reade %kds(k1yshp:11) pahshp;
       enddo;

       return @@mact;

      /end-free

     P SVPSIN_getPagXCob...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSIN_updCnhopa(): Actualiza datos en el archivo Cnhopa          *
      *                                                                   *
      *          peDspa   ( input  ) Estrutura de Cnhopa                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_updCnhopa...
     P                 B                   export
     D SVPSIN_updCnhopa...
     D                 pi              n
     D   peDspa                            likeds( dsCnhopa_t ) const

     D  k1yopa         ds                  likerec( c1hopa : *key    )
     D  dsOspa         ds                  likerec( c1hopa : *output )

      /free

       SVPSIN_inz();

       k1yopa.paEmpr = peDspa.paEmpr;
       k1yopa.paSucu = peDspa.paSucu;
       k1yopa.paArtc = peDspa.paArtc;
       k1yopa.paPacp = peDspa.paPacp;
       chain %kds( k1yopa : 4 ) cnhopa;
       if %found( cnhopa );
         eval-corr dsOspa = peDspa;
         update c1hopa dsOspa;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSIN_updCnhopa...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getCnhmop(): Retorna datos de Ordenes de Pago:        *
      *                     Devengadas.-                             *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod Area Tecnica                     *
      *     pePacp   ( input  ) Num Cbate de pago                    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getCnhmop...
     P                 B                   export
     D SVPSIN_getCnhmop...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peDsop                            likeds ( DsCnhmop_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsopC                     10i 0 options(*nopass:*omit)

     D   k1ymop        ds                  likerec( c1hmop : *key   )
     D   @@DsIop       ds                  likerec( c1hmop : *input )
     D   @@Dsop        ds                  likeds ( DsCnhmop_t ) dim(9999)
     D   @@DsopC       s             10i 0

      /free

       SVPSIN_inz();

       clear @@Dsop;
       clear @@DsopC;

       k1ymop.maEmpr = peEmpr;
       k1ymop.maSucu = peSucu;
       k1ymop.maArtc = peArtc;
       k1ymop.maPacp = pePacp;
       setll %kds( k1ymop : 4 ) cnhmop;
       if not %equal( cnhmop );
          return *off;
       endif;

       reade(n) %kds( k1ymop : 4 ) cnhmop @@DsIop;
       dow not %eof( cnhmop );
           @@DsopC += 1;
           eval-corr @@Dsop ( @@DsopC ) = @@DsIop;
           reade(n) %kds( k1ymop : 4 ) cnhmop @@DsIop;
       enddo;


       if %addr( peDsop ) <> *null;
         eval-corr peDsop = @@Dsop;
       endif;

       if %addr( peDsopC ) <> *null;
         peDsopC = @@DsopC;
       endif;

       return *on;

      /end-free

     P SVPSIN_getCnhmop...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkCnhmop(): Valida si existe Ordenes de Pago:        *
      *                     Devengadas.-                             *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod Area Tecnica                     *
      *     pePacp   ( input  ) Num Cbate de pago                    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_chkCnhmop...
     P                 B                   export
     D SVPSIN_chkCnhmop...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const

     D   k1ymop        ds                  likerec( c1hmop : *key   )

      /free

       SVPSIN_inz();

       k1ymop.maEmpr = peEmpr;
       k1ymop.maSucu = peSucu;
       k1ymop.maArtc = peArtc;
       k1ymop.maPacp = pePacp;
       setll %kds( k1ymop : 4 ) cnhmop;

       if not %equal(cnhmop);
         SetError( SVPSIN_OPDNE
                 : 'Orden Pago Deveng. Inexistente.' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSIN_chkCnhmop...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_setCnhmop(): Graba datos en el archivo Cnhmop              *
      *                                                                   *
      *          peDsop   ( input  ) Estrutura de Cnhmop                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_setCnhmop...
     P                 B                   export
     D SVPSIN_setCnhmop...
     D                 pi              n
     D   peDsop                            likeds( dsCnhmop_t ) const

     D  k1ymop         ds                  likerec( c1hmop : *key    )
     D  dsOsop         ds                  likerec( c1hmop : *output )

      /free

       SVPSIN_inz();

       if SVPSIN_chkCnhmop( peDsop.maEmpr
                          : peDsop.maSucu
                          : peDsop.maArtc
                          : peDsop.maPacp);

         return *off;
       endif;

       eval-corr DsOsop = peDsop;
       monitor;
         write c1hmop DsOsop;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSIN_setCnhmop...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_updCnhmop(): Actualiza datos en el archivo Cnhmop          *
      *                                                                   *
      *          peDsop   ( input  ) Estrutura de Cnhmop                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_updCnhmop...
     P                 B                   export
     D SVPSIN_updCnhmop...
     D                 pi              n
     D   peDsop                            likeds( dsCnhmop_t ) const

     D  k1ymop         ds                  likerec( c1hmop : *key    )
     D  dsOsop         ds                  likerec( c1hmop : *output )

      /free

       SVPSIN_inz();

       k1ymop.maEmpr = peDsop.maEmpr;
       k1ymop.maSucu = peDsop.maSucu;
       k1ymop.maArtc = peDsop.maArtc;
       k1ymop.maPacp = peDsop.maPacp;
       chain %kds( k1ymop : 4 ) cnhmop;
       if %found( cnhmop );
         eval-corr dsOsop = peDsop;
         update c1hmop dsOsop;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSIN_updCnhmop...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_dltCnhmop(): Elimina datos en el archivo Cnhmop            *
      *                                                                   *
      *          peDsop   ( input  ) Estrutura de Cnhmop                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_dltCnhmop...
     P                 B                   export
     D SVPSIN_dltCnhmop...
     D                 pi              n
     D   peDsop                            likeds( dsCnhmop_t ) const

     D  k1ymop         ds                  likerec( c1hmop : *key    )

      /free

       SVPSIN_inz();

       k1ymop.maEmpr = peDsop.maEmpr;
       k1ymop.maSucu = peDsop.maSucu;
       k1ymop.maArtc = peDsop.maArtc;
       k1ymop.maPacp = peDsop.maPacp;
       chain %kds( k1ymop : 4 ) cnhmop;
       if %found( cnhmop );
         delete c1hmop;
       endif;

       return *on;

      /end-free

     P SVPSIN_dltCnhmop...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getGti981s(): Retorna datos de SPEEDWAY SINIESTROS:   *
      *                      Facturas.-                              *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peComa   ( input  ) Cod. May. Auxiliar                   *
      *     peNrma   ( input  ) Nro. May. Auxiliar                   *
      *     peTifa   ( input  ) Tipo Factura                         *
      *     peSufa   ( input  ) Sucursal Factura                     *
      *     peNrfa   ( input  ) Nro. Factura                         *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getGti981s...
     P                 B                   export
     D SVPSIN_getGti981s...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peTifa                       2  0 const
     D   peSufa                       4  0 const
     D   peNrfa                       8  0 const
     D   peDs1s                            likeds ( DsGti981s_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDs1sC                     10i 0 options(*nopass:*omit)

     D   k1y81s        ds                  likerec( g1i981s : *key   )
     D   @@DsI1s       ds                  likerec( g1i981s : *input )
     D   @@Ds1s        ds                  likeds ( DsGti981s_t ) dim(9999)
     D   @@Ds1sC       s             10i 0

      /free

       SVPSIN_inz();

       clear @@Ds1s;
       clear @@Ds1sC;

       k1y81s.g1sEmpr = peEmpr;
       k1y81s.g1sSucu = peSucu;
       k1y81s.g1sComa = peComa;
       k1y81s.g1sNrma = peNrma;
       k1y81s.g1sTifa = peTifa;
       k1y81s.g1sSufa = peSufa;
       k1y81s.g1sNrfa = peNrfa;
       setll %kds( k1y81s : 7 ) gti981s;
       if not %equal( gti981s );
          return *off;
       endif;

       reade(n) %kds( k1y81s : 7 ) gti981s @@DsI1s;
       dow not %eof( gti981s );
           @@Ds1sC += 1;
           eval-corr @@Ds1s ( @@Ds1sC ) = @@DsI1s;
           reade(n) %kds( k1y81s : 7 ) gti981s @@DsI1s;
       enddo;


       if %addr( peDs1s ) <> *null;
         eval-corr peDs1s = @@Ds1s;
       endif;

       if %addr( peDs1sC ) <> *null;
         peDs1sC = @@Ds1sC;
       endif;

       return *on;

      /end-free

     P SVPSIN_getGti981s...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkGti981s(): Valida si existe datos de SPEEDWAY      *
      *                      SINIESTROS: Facturas.-                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peComa   ( input  ) Cod. May. Auxiliar                   *
      *     peNrma   ( input  ) Nro. May. Auxiliar                   *
      *     peTifa   ( input  ) Tipo Factura                         *
      *     peSufa   ( input  ) Sucursal Factura                     *
      *     peNrfa   ( input  ) Nro. Factura                         *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_chkGti981s...
     P                 B                   export
     D SVPSIN_chkGti981s...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peTifa                       2  0 const
     D   peSufa                       4  0 const
     D   peNrfa                       8  0 const

     D   k1y81s        ds                  likerec( g1i981s : *key   )

      /free

       SVPSIN_inz();

       k1y81s.g1sEmpr = peEmpr;
       k1y81s.g1sSucu = peSucu;
       k1y81s.g1sComa = peComa;
       k1y81s.g1sNrma = peNrma;
       k1y81s.g1sTifa = peTifa;
       k1y81s.g1sSufa = peSufa;
       k1y81s.g1sNrfa = peNrfa;
       setll %kds( k1y81s : 7 ) gti981s;

       if not %equal(gti981s);
         SetError( SVPSIN_SSFNE
                 : 'Speedway Siniestros Factura Inexistente.' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSIN_chkGti981s...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_setGti981s(): Graba datos en el archivo Gti981s            *
      *                                                                   *
      *          peDs1s   ( input  ) Estrutura de Gti981s                 *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_setGti981s...
     P                 B                   export
     D SVPSIN_setGti981s...
     D                 pi              n
     D   peDs1s                            likeds( dsGti981s_t ) const

     D  k1y81s         ds                  likerec( g1i981s : *key    )
     D  dsOs1s         ds                  likerec( g1i981s : *output )

      /free

       SVPSIN_inz();

       if SVPSIN_chkGti981s( peDs1s.g1sEmpr
                           : peDs1s.g1sSucu
                           : peDs1s.g1sComa
                           : peDs1s.g1sNrma
                           : peDs1s.g1sTifa
                           : peDs1s.g1sSufa
                           : peDs1s.g1sNrfa);

         return *off;
       endif;

       eval-corr DsOs1s = peDs1s;
       monitor;
         write g1i981s DsOs1s;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSIN_setGti981s...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_updGti981s(): Actualiza datos en el archivo Gti981s        *
      *                                                                   *
      *          peDs1s   ( input  ) Estrutura de Gti981s                 *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_updGti981s...
     P                 B                   export
     D SVPSIN_updGti981s...
     D                 pi              n
     D   peDs1s                            likeds( dsGti981s_t ) const

     D  k1y81s         ds                  likerec( g1i981s : *key    )
     D  dsOs1s         ds                  likerec( g1i981s : *output )

      /free

       SVPSIN_inz();

       k1y81s.g1sEmpr = peDs1s.g1sEmpr;
       k1y81s.g1sSucu = peDs1s.g1sSucu;
       k1y81s.g1sComa = peDs1s.g1sComa;
       k1y81s.g1sNrma = peDs1s.g1sNrma;
       k1y81s.g1sTifa = peDs1s.g1sTifa;
       k1y81s.g1sSufa = peDs1s.g1sSufa;
       k1y81s.g1sNrfa = peDs1s.g1sNrfa;
       chain %kds( k1y81s : 7 ) gti981s;
       if %found( gti981s );
         eval-corr dsOs1s = peDs1s;
         update g1i981s dsOs1s;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSIN_updGti981s...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_dltGti981s(): Elimina datos en el archivo Gti981s          *
      *                                                                   *
      *          peDs1s   ( input  ) Estrutura de Gti981s                 *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_dltGti981s...
     P                 B                   export
     D SVPSIN_dltGti981s...
     D                 pi              n
     D   peDs1s                            likeds( dsGti981s_t ) const

     D  k1y81s         ds                  likerec( g1i981s : *key    )

      /free

       SVPSIN_inz();

       k1y81s.g1sEmpr = peDs1s.g1sEmpr;
       k1y81s.g1sSucu = peDs1s.g1sSucu;
       k1y81s.g1sComa = peDs1s.g1sComa;
       k1y81s.g1sNrma = peDs1s.g1sNrma;
       k1y81s.g1sTifa = peDs1s.g1sTifa;
       k1y81s.g1sSufa = peDs1s.g1sSufa;
       k1y81s.g1sNrfa = peDs1s.g1sNrfa;
       chain %kds( k1y81s : 7 ) gti981s;
       if %found( gti981s );
         delete g1i981s;
       endif;

       return *on;

      /end-free

     P SVPSIN_dltGti981s...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_updIGAant(): Actualiza IGA del RET anterior.-         *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peMoas   ( input  ) Modulo que genera el asiento         *
      *     peNrrf   ( input  ) Nro.ref.acceso retenciones anteriores*
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_updIGAant...
     P                 B                   export
     D SVPSIN_updIGAant...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peMoas                       1    const
     D   peNrrf                       9  0 const

     D   k1yret        ds                  likerec( c1hret01 : *key   )

      /free

       SVPSIN_inz();

       k1yret.rtEmpr = peEmpr;
       k1yret.rtSucu = peSucu;
       k1yret.rtMoas = peMoas;
       k1yret.rtNrrf = peNrrf;
       setll %kds( k1yret : 4 ) cnhret01;
       reade %kds( k1yret : 4 ) cnhret01;
       dow not %eof( cnhret01 );
         if rtTiic = 'IGA';
            r2Marp = 'R';
            update c1hret01;
         endif;
         reade %kds( k1yret : 4 ) cnhret01;
       enddo;

       return *On;

      /end-free

     P SVPSIN_updIGAant...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getImportMonRes(): Retorna Importe de moneda reserva  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Numero de Beneficiario                *
      *     peSebe   (input)   Secuencia de Beneficiario             *
      *                                                              *
      * Retorna: Estado del Reclamo                                  *
      * ------------------------------------------------------------ *

     P SVPSIN_getImportMonRes...
     P                 B                   export
     D SVPSIN_getImportMonRes...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const

     D k1yshr5         ds                  likerec(p1hshr05:*key)
     D k1yshp12        ds                  likerec(p1hshp12:*key)
     D k1ysfr01        ds                  likerec(p1hsfr01:*key)

     D x3Sald          s             15  2

      /free

       SVPSIN_inz();

        clear x3Sald;

        k1yshr5.hrEmpr = peEmpr;
        k1yshr5.hrSucu = peSucu;
        k1yshr5.hrRama = peRama;
        k1yshr5.hrSini = peSini;
        k1yshr5.hrNops = peNops;
        k1yshr5.hrNrdf = peNrdf;
        k1yshr5.hrSebe = peSebe;
        setll    %kds( k1yshr5 : 7 ) pahshr05;
        reade(n) %kds( k1yshr5 : 7 ) pahshr05;
        dow not %eof( pahshr05 );
          x3sald += hrImmr;
          reade(n) %kds( k1yshr5 : 7 ) pahshr05;
        enddo;

        k1yshp12.hpEmpr = peEmpr;
        k1yshp12.hpSucu = peSucu;
        k1yshp12.hpRama = peRama;
        k1yshp12.hpSini = peSini;
        k1yshp12.hpNops = peNops;
        k1yshp12.hpNrdf = peNrdf;
        k1yshp12.hpSebe = peSebe;
        setll    %kds( k1yshp12 : 7 ) pahshp12;
        reade(n) %kds( k1yshp12 : 7 ) pahshp12;
        dow not %eof( pahshp12 );
          x3sald -= hpimmr;
          reade(n) %kds( k1yshp12 : 7 ) pahshp12;
        enddo;

        k1ysfr01.frEmpr = peEmpr;
        k1ysfr01.frSucu = peSucu;
        k1ysfr01.frRama = peRama;
        k1ysfr01.frSini = peSini;
        k1ysfr01.frNops = peNops;
        k1ysfr01.frNrdf = peNrdf;
        k1ysfr01.frSebe = peSebe;
        setll    %kds( k1ysfr01 : 7 ) pahsfr01;
        reade(n) %kds( k1ysfr01 : 7 ) pahsfr01;
        dow not %eof( pahsfr01 );
          x3sald -= frimmr;
          reade(n) %kds( k1ysfr01 : 7 ) pahsfr01;
        enddo;

        return x3Sald;

      /end-free

     P SVPSIN_getImportMonRes...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getCntopa(): Retorna datos de Ordenes de Pago:        *
      *                     Devengadas.-                             *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod. Area Tecnica                    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getCntopa...
     P                 B                   export
     D SVPSIN_getCntopa...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   peDsCn                            likeds ( DsCntopa_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsCnC                     10i 0 options(*nopass:*omit)

     D   k1ycnt        ds                  likerec( c1topa : *key   )
     D   @@DsICn       ds                  likerec( c1topa : *input )
     D   @@DsCn        ds                  likeds ( DsCntopa_t ) dim(9999)
     D   @@DsCnC       s             10i 0

      /free

       SVPSIN_inz();

       clear @@DsCn;
       clear @@DsCnC;

       k1ycnt.t@Empr = peEmpr;
       k1ycnt.t@Sucu = peSucu;
       k1ycnt.t@Artc = peArtc;
       setll %kds( k1ycnt : 3 ) Cntopa;
       if not %equal( Cntopa );
          return *off;
       endif;

       reade(n) %kds( k1ycnt : 3 ) Cntopa @@DsICn;
       dow not %eof( Cntopa );
           @@DsCnC += 1;
           eval-corr @@DsCn ( @@DsCnC ) = @@DsICn;
           reade(n) %kds( k1ycnt : 3 ) Cntopa @@DsICn;
       enddo;


       if %addr( peDsCn ) <> *null;
         eval-corr peDsCn = @@DsCn;
       endif;

       if %addr( peDsCnC ) <> *null;
         peDsCnC = @@DsCnC;
       endif;

       return *on;

      /end-free

     P SVPSIN_getCntopa...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkCntopa(): Valida si existe datos de Ordenes de     *
      *                     Pago: Devengadas.-                       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod. Area Tecnica                    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_chkCntopa...
     P                 B                   export
     D SVPSIN_chkCntopa...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const

     D   k1ycnt        ds                  likerec( c1topa : *key   )

      /free

       SVPSIN_inz();

       k1ycnt.t@Empr = peEmpr;
       k1ycnt.t@Sucu = peSucu;
       k1ycnt.t@Artc = peArtc;
       setll %kds( k1ycnt : 3 ) Cntopa;

       if not %equal(Cntopa);
         SetError( SVPSIN_OPDNE
                 : 'Ordenes Pago Devengadas Inexistente.' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSIN_chkCntopa...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_setCntopa(): Graba datos en el archivo Cntopa              *
      *                                                                   *
      *          peDsPa   ( input  ) Estrutura de Cntopa                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_setCntopa...
     P                 B                   export
     D SVPSIN_setCntopa...
     D                 pi              n
     D   peDsCn                            likeds( dsCntopa_t ) const

     D  k1ycnt         ds                  likerec( c1topa : *key    )
     D  dsOsCn         ds                  likerec( c1topa : *output )

      /free

       SVPSIN_inz();

       if SVPSIN_chkCntopa( peDsCn.t@Empr
                          : peDsCn.t@Sucu
                          : peDsCn.t@Artc);

         return *off;
       endif;

       eval-corr DsOsCn = peDsCn;
       monitor;
         write c1topa DsOsCn;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPSIN_setCntopa...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_updCntopa(): Actualiza datos en el archivo Cntopa          *
      *                                                                   *
      *          peDsCn   ( input  ) Estrutura de Cntopa                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_updCntopa...
     P                 B                   export
     D SVPSIN_updCntopa...
     D                 pi              n
     D   peDsCn                            likeds( dsCntopa_t ) const

     D  k1ycnt         ds                  likerec( c1topa : *key    )
     D  dsOsCn         ds                  likerec( c1topa : *output )

      /free

       SVPSIN_inz();

       k1ycnt.t@Empr = peDsCn.t@Empr;
       k1ycnt.t@Sucu = peDsCn.t@Sucu;
       k1ycnt.t@Artc = peDsCn.t@Artc;
       chain %kds( k1ycnt : 3 ) Cntopa;
       if %found( Cntopa );
         eval-corr dsOsCn = peDsCn;
         update c1topa dsOsCn;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSIN_updCntopa...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_dltCntopa(): Elimina datos en el archivo Cntopa            *
      *                                                                   *
      *          peDsCn   ( input  ) Estrutura de Cntopa                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_dltCntopa...
     P                 B                   export
     D SVPSIN_dltCntopa...
     D                 pi              n
     D   peDsCn                            likeds( dsCntopa_t ) const

     D  k1ycnt         ds                  likerec( c1topa : *key    )

      /free

       SVPSIN_inz();

       k1ycnt.t@Empr = peDsCn.t@Empr;
       k1ycnt.t@Sucu = peDsCn.t@Sucu;
       k1ycnt.t@Artc = peDsCn.t@Artc;
       chain %kds( k1ycnt : 3 ) Cntopa;
       if %found( Cntopa );
         delete c1topa;
       endif;

       return *on;

      /end-free

     P SVPSIN_dltCntopa...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getGti960(): Retorna datos de Siniestros BPM.-        *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peNops   ( input  ) Nro. Op. Siniestro                   *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getGti960...
     P                 B                   export
     D SVPSIN_getGti960...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peNops                       7  0 const
     D   peDs60                            likeds ( DsGti960_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDs60C                     10i 0 options(*nopass:*omit)

     D   k1y960        ds                  likerec( g1i960 : *key   )
     D   @@DsI60       ds                  likerec( g1i960 : *input )
     D   @@Ds60        ds                  likeds ( DsGti960_t ) dim(9999)
     D   @@Ds60C       s             10i 0

      /free

       SVPSIN_inz();

       clear @@Ds60;
       clear @@Ds60C;

       k1y960.g0Empr = peEmpr;
       k1y960.g0Sucu = peSucu;
       k1y960.g0Rama = peRama;
       k1y960.g0Nops = peNops;
       setll %kds( k1y960 : 4 ) Gti960;
       if not %equal( Gti960 );
          return *off;
       endif;

       reade(n) %kds( k1y960 : 4 ) Gti960 @@DsI60;
       dow not %eof( Gti960 );
           @@Ds60C += 1;
           eval-corr @@Ds60 ( @@Ds60C ) = @@DsI60;
           reade(n) %kds( k1y960 : 4 ) Gti960 @@DsI60;
       enddo;


       if %addr( peDs60 ) <> *null;
         eval-corr peDs60 = @@Ds60;
       endif;

       if %addr( peDs60C ) <> *null;
         peDs60C = @@Ds60C;
       endif;

       return *on;

      /end-free

     P SVPSIN_getGti960...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkGti960(): Valida si existe datos de Siniestros BPM *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peNops   ( input  ) Nro. Op. Siniestro                   *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_chkGti960...
     P                 B                   export
     D SVPSIN_chkGti960...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peNops                       7  0 const

     D   k1y960        ds                  likerec( g1i960 : *key   )

      /free

       SVPSIN_inz();

       k1y960.g0Empr = peEmpr;
       k1y960.g0Sucu = peSucu;
       k1y960.g0Rama = peRama;
       k1y960.g0Nops = peNops;
       setll %kds( k1y960 : 4 ) Gti960;

       if not %equal(Gti960);
         SetError( SVPSIN_SINNE
                 : 'Siniestro Inexistente.' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSIN_chkGti960...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_setGti960: Graba datos en el archivo Gti960           *
      *                                                              *
      *     peDs60   ( input  ) Estructura Ds60                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_setGti960...
     P                 B                   export
     D SVPSIN_setGti960...
     D                 pi              n
     D   peDs60                            likeds( dsGti960_t ) const

     D  k1y960         ds                  likerec( g1i960 : *key    )
     D  dsOs60         ds                  likerec( g1i960 : *output )

      /free

       SVPSIN_inz();

       if SVPSIN_chkGti960( peDs60.g0Empr
                          : peDs60.g0Sucu
                          : peDs60.g0Rama
                          : peDs60.g0Nops);

         return *off;
       endif;

       eval-corr DsOs60 = peDs60;
       monitor;
         write g1i960 DsOs60;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free

     P SVPSIN_setGti960...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_updGti960(): Actualiza datos en el archivo Gti960          *
      *                                                                   *
      *          peDs60   ( input  ) Estrutura de Gti960                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_updGti960...
     P                 B                   export
     D SVPSIN_updGti960...
     D                 pi              n
     D   peDs60                            likeds( dsGti960_t ) const

     D  k1y960         ds                  likerec( g1i960 : *key    )
     D  dsOs60         ds                  likerec( g1i960 : *output )

      /free

       SVPSIN_inz();

       k1y960.g0Empr = peDs60.g0Empr;
       k1y960.g0Sucu = peDs60.g0Sucu;
       k1y960.g0Rama = peDs60.g0Rama;
       k1y960.g0Nops = peDs60.g0Nops;
       chain %kds( k1y960 : 4 ) Gti960;
       if %found( Gti960 );
         eval-corr dsOs60 = peDs60;
         update g1i960 dsOs60;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSIN_updGti960...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_dltGti960(): Elimina datos en el archivo Gti960            *
      *                                                                   *
      *          peDs60   ( input  ) Estrutura de Gti960                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_dltGti960...
     P                 B                   export
     D SVPSIN_dltGti960...
     D                 pi              n
     D   peDs60                            likeds( dsGti960_t ) const

     D  k1y960         ds                  likerec( g1i960 : *key    )

      /free

       SVPSIN_inz();

       k1y960.g0Empr = peDs60.g0Empr;
       k1y960.g0Sucu = peDs60.g0Sucu;
       k1y960.g0Rama = peDs60.g0Rama;
       k1y960.g0Nops = peDs60.g0Nops;
       chain %kds( k1y960 : 4 ) Gti960;
       if %found( Gti960 );
         delete g1i960;
       endif;

       return *on;

      /end-free

     P SVPSIN_dltGti960...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getGti965(): Retorna datos de Siniestros BPM.-        *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Siniestro                            *
      *     peNops   ( input  ) Nro. Op. Siniestro                   *
      *     peArtc   ( input  ) Area Tecnica                         *
      *     pePacp   ( input  ) Nro. Orden Pago                      *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getGti965...
     P                 B                   export
     D SVPSIN_getGti965...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peDs65                            likeds ( DsGti965_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDs65C                     10i 0 options(*nopass:*omit)

     D   k1y965        ds                  likerec( g1i965 : *key   )
     D   @@DsI65       ds                  likerec( g1i965 : *input )
     D   @@Ds65        ds                  likeds ( DsGti965_t ) dim(9999)
     D   @@Ds65C       s             10i 0

      /free

       SVPSIN_inz();

       clear @@Ds65;
       clear @@Ds65C;

       k1y965.g5Empr = peEmpr;
       k1y965.g5Sucu = peSucu;
       k1y965.g5Rama = peRama;
       k1y965.g5Sini = peSini;
       k1y965.g5Nops = peNops;
       k1y965.g5Artc = peArtc;
       k1y965.g5Pacp = pePacp;
       setll %kds( k1y965 : 7 ) Gti965;
       if not %equal( Gti965 );
          return *off;
       endif;

       reade(n) %kds( k1y965 : 7 ) Gti965 @@DsI65;
       dow not %eof( Gti965 );
           @@Ds65C += 1;
           eval-corr @@Ds65 ( @@Ds65C ) = @@DsI65;
           reade(n) %kds( k1y965 : 7 ) Gti965 @@DsI65;
       enddo;


       if %addr( peDs65 ) <> *null;
         eval-corr peDs65 = @@Ds65;
       endif;

       if %addr( peDs65C ) <> *null;
         peDs65C = @@Ds65C;
       endif;

       return *on;

      /end-free

     P SVPSIN_getGti965...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkGti965(): Valida si existe datos de Ordenes de     *
      *                     Pago BPM.-                               *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Siniestro                            *
      *     peNops   ( input  ) Nro. Op. Siniestro                   *
      *     peArtc   ( input  ) Area Tecnica                         *
      *     pePacp   ( input  ) Nro. Orden Pago                      *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_chkGti965...
     P                 B                   export
     D SVPSIN_chkGti965...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const

     D   k1y965        ds                  likerec( g1i965 : *key   )

      /free

       SVPSIN_inz();

       k1y965.g5Empr = peEmpr;
       k1y965.g5Sucu = peSucu;
       k1y965.g5Rama = peRama;
       k1y965.g5Sini = peSini;
       k1y965.g5Nops = peNops;
       k1y965.g5Artc = peArtc;
       k1y965.g5Pacp = pePacp;
       setll %kds( k1y965 : 7 ) Gti965;

       if not %equal(Gti965);
         SetError( SVPSIN_OPANE
                 : 'Orden de Pago Inexistente.' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPSIN_chkGti965...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_setGti965: Graba datos en el archivo Gti965           *
      *                                                              *
      *     peDs65   ( input  ) Estructura Ds65                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPSIN_setGti965...
     P                 B                   export
     D SVPSIN_setGti965...
     D                 pi              n
     D   peDs65                            likeds( dsGti965_t ) const

     D  k1y965         ds                  likerec( g1i965 : *key    )
     D  dsOs65         ds                  likerec( g1i965 : *output )

      /free

       SVPSIN_inz();

       if SVPSIN_chkGti965( peDs65.g5Empr
                          : peDs65.g5Sucu
                          : peDs65.g5Rama
                          : peDs65.g5Sini
                          : peDs65.g5Nops
                          : peDs65.g5Artc
                          : peDs65.g5Pacp);

         return *off;
       endif;

       eval-corr DsOs65 = peDs65;
       monitor;
         write g1i965 DsOs65;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free

     P SVPSIN_setGti965...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_updGti965(): Actualiza datos en el archivo Gti965          *
      *                                                                   *
      *          peDs65   ( input  ) Estrutura de Gti965                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_updGti965...
     P                 B                   export
     D SVPSIN_updGti965...
     D                 pi              n
     D   peDs65                            likeds( dsGti965_t ) const

     D  k1y965         ds                  likerec( g1i965 : *key    )
     D  dsOs65         ds                  likerec( g1i965 : *output )

      /free

       SVPSIN_inz();

       k1y965.g5Empr = peDs65.g5Empr;
       k1y965.g5Sucu = peDs65.g5Sucu;
       k1y965.g5Rama = peDs65.g5Rama;
       k1y965.g5Sini = peDs65.g5Sini;
       k1y965.g5Nops = peDs65.g5Nops;
       k1y965.g5Artc = peDs65.g5Artc;
       k1y965.g5Pacp = peDs65.g5Pacp;
       chain %kds( k1y965 : 7 ) Gti965;
       if %found( Gti965 );
         eval-corr dsOs65 = peDs65;
         update g1i965 dsOs65;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPSIN_updGti965...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_dltGti965(): Elimina datos en el archivo Gti965            *
      *                                                                   *
      *          peDs65   ( input  ) Estrutura de Gti965                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_dltGti965...
     P                 B                   export
     D SVPSIN_dltGti965...
     D                 pi              n
     D   peDs65                            likeds( dsGti965_t ) const

     D  k1y965         ds                  likerec( g1i965 : *key    )

      /free

       SVPSIN_inz();

       k1y965.g5Empr = peDs65.g5Empr;
       k1y965.g5Sucu = peDs65.g5Sucu;
       k1y965.g5Rama = peDs65.g5Rama;
       k1y965.g5Sini = peDs65.g5Sini;
       k1y965.g5Nops = peDs65.g5Nops;
       k1y965.g5Artc = peDs65.g5Artc;
       k1y965.g5Pacp = peDs65.g5Pacp;
       chain %kds( k1y965 : 7 ) Gti965;
       if %found( Gti965 );
         delete g1i965;
       endif;

       return *on;

      /end-free

     P SVPSIN_dltGti965...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_getSiniestroXFecha(): Retorna Siniestros por fecha de *
      *                              ocurrencia.                     *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Póliza                               *
      *     peFocu   ( input  ) Fecha de Ocurrencia del Siniestro    *
      *     peDsCd   ( output ) Estructura de Caratula de siniestro  *
      *     peDsCdC  ( output ) Cantidad de Registros                *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPSIN_getSiniestroXFecha...
     P                 B                   export
     D SVPSIN_getSiniestroXFecha...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peFocu                       8  0 const
     D   peDsCd                            likeds ( DsPahscd_t ) dim(999)
     D   peDsCdC                     10i 0

     D   k1yd98        ds                  likerec( p1hscd98 : *key   )
     D   @@DsI98       ds                  likerec( p1hscd98 : *input )

     D   @@Dia         s              2  0
     D   @@Mes         s              2  0
     D   @@AÑo         s              4  0

      /free

       SVPSIN_inz();

       clear @@Dia;
       clear @@Mes;
       clear @@AÑo;
       clear peDsCd;
       peDsCdC = 0;

       @@AÑo = %dec(%subst(%char(peFocu):1:4):4:0);
       @@Mes = %dec(%subst(%char(peFocu):5:2):2:0);
       @@Dia = %dec(%subst(%char(peFocu):7:2):2:0);

       k1yd98.cdEmpr = peEmpr;
       k1yd98.cdSucu = peSucu;
       k1yd98.cdRama = peRama;
       k1yd98.cdPoli = pePoli;
       k1yd98.cdFsia = @@AÑo;
       k1yd98.cdFsim = @@Mes;
       k1yd98.cdFsid = @@Dia;
       setll %kds( k1yd98 : 7 ) pahscd98;
       if not %equal( pahscd98 );
         return *off;
       endif;

       reade %kds( k1yd98 : 7 ) pahscd98 @@DsI98;
       dow not %eof( pahscd98 );
         peDsCdC += 1;
         eval-corr peDsCd( peDsCdC ) = @@DsI98;
         reade %kds( k1yd98 : 7 ) pahscd98 @@DsI98;
       enddo;

       return *on;

      /end-free

     P SVPSIN_getSiniestroXFecha...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkSiniDuplicado(): Verifica que no haya siniestro    *
      *                            duplicado.                        *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Póliza                               *
      *     pePoco   ( input  ) Componente                           *
      *     peFocu   ( input  ) Fecha de Ocurrencia del Siniestro    *
      *     peHocu   ( input  ) Hora  de Ocurrencia del Siniestro    *
      *     peDsCd   ( output ) Estructura de Caratula de siniestro  *
      *     peDsCdC  ( output ) Cantidad de Registros                *
      *                                                              *
      * Retorna: *on = Es duplicado / *off = no es duplicado         *
      * ------------------------------------------------------------ *
     P SVPSIN_chkSiniDuplicado...
     P                 b                   export
     D SVPSIN_chkSiniDuplicado...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePoco                       4  0 const
     D   peFocu                       8  0 const
     D   peHocu                       4  0 const
     D   peDsCd                            likeds ( DsPahscd_t ) dim(999)
     D   peDsCdC                     10i 0

     D k1hsbs          ds                  likerec(p1hsbs08:*key)
     D @@DsCd          ds                  likeds(DsPahscd_t)

     D ret             s              1n
     D @focu           s              8  0

      /free

       SVPSIN_inz();

       clear peDsCd;
       clear @@dscd;
       peDsCdC = 0;
       ret = *off;

       k1hsbs.bsempr = peEmpr;
       k1hsbs.bssucu = peSucu;
       k1hsbs.bsrama = peRama;
       k1hsbs.bspoli = pePoli;
       k1hsbs.bspoco = pePoco;
       setll %kds(k1hsbs:5) pahsbs08;
       reade %kds(k1hsbs:5) pahsbs08;
       dow not %eof;
           if SVPSIN_getCaratula( bsempr
                                : bssucu
                                : bsrama
                                : bssini
                                : bsnops
                                : @@DsCd );
              @focu = (@@DsCd.cdfsia * 10000)
                    + (@@DsCd.cdfsim *   100)
                    +  @@DsCd.cdfsid;
              if (@focu = peFocu and @@DsCd.cdhsin = peHocu and
                  SVPSIN_validarHora() )
                  or
                 (@focu = peFocu and not SVPSIN_validarHora() );
                 ret = *on;
                 peDsCdC += 1;
                 peDsCd(peDsCdC) = @@DsCd;
              endif;
           endif;
        reade %kds(k1hsbs:5) pahsbs08;
       enddo;

       return ret;

      /end-free

     P SVPSIN_chkSiniDuplicado...
     P                 e

      * ------------------------------------------------------------ *
      * SVPSIN_validarHora(): Validar hora duplicada?                *
      *                                                              *
      * Retorna: *on = Se valida / *off no se valida                 *
      * ------------------------------------------------------------ *
     P SVPSIN_validarHora...
     P                 B                   export
     D SVPSIN_validarHora...
     D                 pi              n

     D @@vsys          s            512a

      /free

       SVPSIN_inz();

       if SVPVLS_getValSys( 'HSINVALHOR'
                          : *omit
                          : @@vsys       ) = *off;
          @@vsys = 'N';
       endif;

       return (@@vsys = 'S');

      /end-free

     P                 e

      * ----------------------------------------------------------------- *
      * SVPSIN_setPahSb5(): Graba datos en el archivo PAHSB5              *
      *                                                                   *
      *          peDsb5   ( input  ) Estrutura de Pahsb5                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_setPahsb5...
     P                 b                   export
     D SVPSIN_setPahsb5...
     D                 pi              n
     D   peDsb5                            likeds( dsPahsb5_t ) const

     D  dsSb5          ds                  likerec( p1hsb5 : *output )

      /free

       SVPSIN_inz();

       eval-corr dsSb5 = peDsb5;

       write p1hsb5 dsSb5;

       return *on;

      /end-free

     P                 e

      * ----------------------------------------------------------------- *
      * SVPSIN_updPahSb5(): Actualiza datos en el archivo PAHSB5          *
      *                                                                   *
      *          peDsb5   ( input  ) Estrutura de Pahsb5                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_updPahsb5...
     P                 b                   export
     D SVPSIN_updPahsb5...
     D                 pi              n
     D   peDsb5                            likeds( dsPahsb5_t ) const

     D  k1hsb5         ds                  likerec( p1hsb5 : *key )
     D  dsSb5          ds                  likerec( p1hsb5 : *output )

      /free

       SVPSIN_inz();
       k1hsb5.b5empr = peDsb5.b5Empr;
       k1hsb5.b5sucu = peDsb5.b5Sucu;
       k1hsb5.b5rama = peDsb5.b5Rama;
       k1hsb5.b5sini = peDsb5.b5Sini;
       k1hsb5.b5nops = peDsb5.b5Nops;
       k1hsb5.b5nrdf = peDsb5.b5Nrdf;
       k1hsb5.b5sebe = peDsb5.b5Sebe;
       k1hsb5.b5sebe = peDsb5.b5Fech;
       k1hsb5.b5secu = peDsb5.b5Secu;

       chain %kds(k1hsb5:9) pahsb5;
       if %found( pahsb5 );
         eval-corr dsSb5 = peDsb5;
         update p1hsb5 dsSb5;
         return *on;
       endif;

       return *off;

      /end-free

     P                 e
      * ----------------------------------------------------------------- *
      * SVPSIN_dltPahSb5(): borra datos en el archivo PAHSB5              *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peRama   ( input  ) Rama                                 *
      *          peSini   ( input  ) Siniestro                            *
      *          peNops   ( input  ) Numero de Operacion                  *
      *          peNrdf   ( input  ) Numero de Beneficiario               *
      *          peSebe   ( input  ) Secuecnia de Beneficiario            *
      *          peFech   ( input  ) Fecha de Acuerdo                     *
      *          peSecu   ( input  ) Secuencia de Fecha de Acuerdo        *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_dltPahsb5...
     P                 b                   export
     D SVPSIN_dltPahsb5...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peFech                       8  0 const
     D   peSecu                       6  0 const

     D k1hsb5          ds                  likerec(p1hsb5:*key)

      /free

       SVPSIN_inz();

       k1hsb5.b5empr = peEmpr;
       k1hsb5.b5sucu = peSucu;
       k1hsb5.b5rama = peRama;
       k1hsb5.b5sini = peSini;
       k1hsb5.b5nops = peNops;
       k1hsb5.b5nrdf = peNrdf;
       k1hsb5.b5sebe = peSebe;
       k1hsb5.b5sebe = peFech;
       k1hsb5.b5secu = peSecu;

       setll %kds(k1hsb5:9) pahsb5;
       reade %kds(k1hsb5:9) pahsb5;
       dow not %eof;
           delete p1hsb5;
        reade %kds(k1hsb5:9) pahsb5;
       enddo;

       return *on;

      /end-free

     P                 e

      * ----------------------------------------------------------------- *
      * SVPSIN_getPahSb5(): Recupera datos del archivo PAHSB5             *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peRama   ( input  ) Rama                                 *
      *          peSini   ( input  ) Siniestro                            *
      *          peNops   ( input  ) Numero de Operacion                  *
      *          peNrdf   ( input  ) Numero de Beneficiario               *
      *          peSebe   ( input  ) Secuecnia de Beneficiario            *
      *          peFech   ( input  ) Fecha de Acuerdo                     *
      *          peSecu   ( input  ) Secuencia de Fecha de Acuerdo        *
      *          peDsPa   ( output ) Estructura archivo PAHSB5            *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_getPahsb5...
     P                 b                   export
     D SVPSIN_getPahsb5...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peFech                       8  0 const
     D   peSecu                       6  0 const
     D   peDsPa                            likeds( dsPahsb5_t )

     D k2hsb5          ds                  likerec(p1hsb5:*key)
     D dseni2          ds                  likerec(p1hsb5:*input)

      /free

       SVPSIN_inz();

       clear peDsPa;
       k2hsb5.b5empr = peEmpr;
       k2hsb5.b5sucu = peSucu;
       k2hsb5.b5rama = peRama;
       k2hsb5.b5sini = peSini;
       k2hsb5.b5nops = peNops;
       k2hsb5.b5nrdf = peNrdf;
       k2hsb5.b5sebe = peSebe;
       k2hsb5.b5fech = peFech;
       k2hsb5.b5secu = peSecu;

       chain(n) %kds(k2hsb5:9) pahsb5 dseni2;

          if %found( pahsb5 );
             eval-corr PeDsPa = dseni2 ;
          else;
             return *off;
          endif;

          return *on;
         // if not %found( pahsb5 );
         // return *off;
         // endif;

      /end-free

     P                 e

      * ----------------------------------------------------------------- *
      * SVPSIN_chkPahSb5(): Valida   datos del archivo PAHSB5             *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peRama   ( input  ) Rama                                 *
      *          peSini   ( input  ) Siniestro                            *
      *          peNops   ( input  ) Numero de Operacion                  *
      *          peNrdf   ( input  ) Numero de Beneficiario               *
      *          peSebe   ( input  ) Secuecnia de Beneficiario            *
      *          peFech   ( input  ) Fecha de Acuerdo                     *
      *          peSecu   ( input  ) Secuencia de Fecha de Acuerdo        *
      *                                                                   *
      * retorna *on / *off   on existe / off no existe                    *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkPahsb5...
     P                 b                   export
     D SVPSIN_chkPahsb5...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peFech                       8  0 const
     D   peSecu                       6  0 const

     D k2hsb5          ds                  likerec(p1hsb5:*key)

      /free

       SVPSIN_inz();

       k2hsb5.b5empr = peEmpr;
       k2hsb5.b5sucu = peSucu;
       k2hsb5.b5rama = peRama;
       k2hsb5.b5sini = peSini;
       k2hsb5.b5nops = peNops;
       k2hsb5.b5nrdf = peNrdf;
       k2hsb5.b5sebe = peSebe;
       k2hsb5.b5fech = peFech;
       k2hsb5.b5secu = peSecu;

       setll %kds(k2hsb5) pahsb5;

       if not %equal(pahsb5);
         SetError( SVPSIN_SINNE
                 : 'Siniestro Inexistente' );
         return *Off;
       endif;

         return *On;
      /end-free

     P SVPSIN_chkPahsb5...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_chkFechaAcuerdo()                                          *
      *                                                                   *
      *          peFech   ( input  ) Fecha de acuerdo (aaaammdd)          *
      *                                                                   *
      * retorna *on / *off      on ok / off error                         *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkFechaAcuerdo...
     P                 b                   export
     D SVPSIN_chkFechaAcuerdo...
     D                 pi              n
     D   peFech                       8  0 const

      /free

       SVPSIN_inz();

       return SPVFEC_FechaValida8( peFech );

      /end-free

     P SVPSIN_chkFechaAcuerdo...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_chkPorcIncapFisica()                                       *
      *                                                                   *
      *          peXifi   ( input  ) % Incapacidad Fisica                 *
      *                                                                   *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkPorcIncapFisica...
     P                 b                   export
     D SVPSIN_chkPorcIncapFisica...
     D                 pi              n
     D   peXifi                       5  2 const

      /free

       SVPSIN_inz();

       if (peXifi >= 0 and peXifi <= 100);
            return *on;
         Else;
            return *off;
         Endif;
      /end-free

     P SVPSIN_chkPorcIncapFisica...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_chkPorcIncapPsico()                                        *
      *                                                                   *
      *          peXips   ( input  ) % Incapacidad Psicologica            *
      *                                                                   *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkPorcIncapPsico...
     P                 b                   export
     D SVPSIN_chkPorcIncapPsico...
     D                 pi              n
     D   peXips                       5  2 const

      /free

       SVPSIN_inz();

       if (peXips >= 0 and peXips <= 100);
            return *on;
          Else;
            return *off;
          Endif;
      /end-free

     P SVPSIN_chkPorcIncapPsico...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_chkAcuerdo()                                               *
      *                                                                   *
      *                                                                   *
      *          peFech   ( input  ) Fecha de acuerdo (aaaammdd)          *
      *          peXifi   ( input  ) % Incapacidad Fisica                 *
      *          peXips   ( input  ) % Incapacidad Psicologica            *
      *          peDmor   ( input  ) Importe Daño Moral                   *
      *          peDmat   ( input  ) Importe Daño Material                *
      *          pePuso   ( input  ) Importe Priv. Uso                    *
      *          peLces   ( input  ) Importe Lucro Cesante                *
      *          peTfut   ( input  ) Importe Tratamiento Futuro           *
      *          peGmed   ( input  ) Importe Gastos Medicos               *
      *          peIpsi   ( input  ) Importe Incapacidad Psicologica      *
      *          peOtro   ( input  ) Importe Otros Rubros                 *
      *          peIfis   ( input  ) Importe Incapacidad Fisica           *
      *          @@Msgs   ( output ) Mensaje                              *
      *                                                                   *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkAcuerdo...
     P                 b                   export
     D SVPSIN_chkAcuerdo...
     D                 pi             1n
     D   peFech                       8  0 const
     D   peXifi                       5  2 const
     D   peXips                       5  2 const
     D   peDmor                      15  2 const
     D   peDmat                      15  2 const
     D   pePuso                      15  2 const
     D   peLces                      15  2 const
     D   peTfut                      15  2 const
     D   peGmed                      15  2 const
     D   peIpsi                      15  2 const
     D   peOtro                      15  2 const
     D   peIfis                      15  2 const
     D  peMsgs                             likeds(paramMsgs)
     D  @@repl         s             20a

      /free

       SVPSIN_inz();

       clear peMsgs;

         if not SVPSIN_chkFechaAcuerdo( peFech );
                 SVPWS_getMsgs( '*LIBL'
                              : 'SINMSG'
                              : 'SIN0008'
                              : peMsgs  );
          return *off;
         endif;

         if not SVPSIN_chkFecSupHoy ( peFech );
                 SVPWS_getMsgs( '*LIBL'
                              : 'SINMSG'
                              : 'SIN0183'
                              : peMsgs  );
          return *off;
         endif;

       if not SVPSIN_chkPorcIncapFisica( peXifi );
                @@repl = 'Fisica';
                SVPWS_getMsgs( '*LIBL'
                             : 'SINMSG'
                             : 'SIN0178'
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          return *off;
       endif;

       if not SVPSIN_chkPorcIncapPsico( peXips );
                @@repl = 'Psicologica';
                SVPWS_getMsgs( '*LIBL'
                             : 'SINMSG'          //archivo mensajes
                             : 'SIN0178'         // cod mensaje
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          return *off;
       endif;

       if not SVPSIN_chkImpoDanoMoral( peDmor );
                SVPWS_getMsgs( '*LIBL'
                             : 'SINMSG'
                             : 'SIN0179'
                             : peMsgs        );
          return *off;
       endif;

         if not SVPSIN_chkImpoDanoMaterial(peDmat );
                  SVPWS_getMsgs( '*LIBL'
                               : 'SINMSG'
                               : 'SIN0179'
                               : peMsgs        );
          return *off;
         endif;

         if not SVPSIN_chkImpoPrivUso( pePuso );
                  SVPWS_getMsgs( '*LIBL'
                               : 'SINMSG'
                               : 'SIN0179'
                               : peMsgs        );
          return *off;
         endif;

         if not SVPSIN_chkImpLucCesa( peLces );
                SVPWS_getMsgs( '*LIBL'
                             : 'SINMSG'
                             : 'SIN0179'
                             : peMsgs        );
          return *off;
         endif;

       if not SVPSIN_chkImpTratFut( peTfut );
                SVPWS_getMsgs( '*LIBL'
                             : 'SINMSG'
                             : 'SIN0179'
                             : peMsgs        );
          return *off;
       endif;

       if not SVPSIN_chkImpGasMed( peGmed );
                SVPWS_getMsgs( '*LIBL'
                             : 'SINMSG'
                             : 'SIN0179'
                             : peMsgs        );
          return *off;
       endif;

       if not SVPSIN_chkImpOtroRubro( peOtro );
                SVPWS_getMsgs( '*LIBL'
                             : 'SINMSG'
                             : 'SIN0179'
                             : peMsgs        );
          return *off;
       endif;

       if not SVPSIN_chkImpIncFisica( peIfis );
                SVPWS_getMsgs( '*LIBL'
                             : 'SINMSG'
                             : 'SIN0179'
                             : peMsgs        );
          return *off;
       endif;

       if not SVPSIN_chkImpIncPsico( peIpsi );
                SVPWS_getMsgs( '*LIBL'
                             : 'SINMSG'
                             : 'SIN0179'
                             : peMsgs        );
          return *off;
       endif;

       if not SVPSIN_chkIncFisica( peXifi : peIfis);
                SVPWS_getMsgs( '*LIBL'
                             : 'SINMSG'
                             : 'SIN0180'
                             : peMsgs        );
          return *off;
       endif;

       if not SVPSIN_chkIncPsico( peXips : peIpsi);
                SVPWS_getMsgs( '*LIBL'
                             : 'SINMSG'
                             : 'SIN0180'
                             : peMsgs        );
          return *off;
       endif;

       if not SVPSIN_chkLucroPri( pePuso : peLces);
                SVPWS_getMsgs( '*LIBL'
                             : 'SINMSG'
                             : 'SIN0182'
                             : peMsgs        );
          return *off;
       endif;

       if not SVPSIN_chkDanosExc( peDmor : pedMat :
                                  pePuso : peLces :
                                  peTfut : peGmed :
                                  peIpsi : peOtro :
                                  peIfis : peXifi :
                                  peXips);
                SVPWS_getMsgs( '*LIBL'
                             : 'SINMSG'
                             : 'SIN0181'
                             : peMsgs        );
          return *off;
       endif;
        return *on;
      /end-free

     P SVPSIN_chkAcuerdo...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_chkImpoDañoMoral()                                         *
      *                                                                   *
      *          peDmor   ( input  ) Importe Daño Moral (no negativo)     *
      *                                                                   *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkImpoDanoMoral...
     P                 b                   export
     D SVPSIN_chkImpoDanoMoral...
     D                 pi              n
     D   peDmor                      15  2 const

      /free

       SVPSIN_inz();

       if (peDmor < 0);
            return *off;
          Else;
            return *on;
          Endif;
      /end-free

     P SVPSIN_chkImpoDanoMoral...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSIN_chkImpoDanoMaterial()                                      *
      *                                                                   *
      *          peDmat   ( input  ) Importe Daño Material (no negativo)  *
      *                                                                   *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkImpoDanoMaterial...
     P                 b                   export
     D SVPSIN_chkImpoDanoMaterial...
     D                 pi              n
     D   peDmat                      15  2 const

      /free

       SVPSIN_inz();

       if (peDmat < 0);
            return *off;
          Else;
            return *on;
          Endif;
      /end-free

     P SVPSIN_chkImpoDanoMaterial...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSIN_chkImpoPrivUso()                                           *
      *                                                                   *
      *          pePuso   ( input  ) Importe Priv. Uso     (no negativo)  *
      *                                                                   *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkImpoPrivUso...
     P                 b                   export
     D SVPSIN_chkImpoPrivUso...
     D                 pi              n
     D   pePuso                      15  2 const

      /free

       SVPSIN_inz();

       if (pePuso < 0);
            return *off;
          Else;
            return *on;
          Endif;
      /end-free

     P SVPSIN_chkImpoPrivUso...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSIN_chkImpLucCesa()                                            *
      *                                                                   *
      *          peLces   ( input  ) Importe Lucro Cesante (no negativo)  *
      *                                                                   *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkImpLucCesa...
     P                 b                   export
     D SVPSIN_chkImpLucCesa...
     D                 pi              n
     D   peLces                      15  2 const

      /free

       SVPSIN_inz();

       if (peLces < 0);
            return *off;
          Else;
            return *on;
          Endif;
      /end-free

     P SVPSIN_chkImpLucCesa...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSIN_chkImpTratFut()                                            *
      *                                                                   *
      *          peTfut   ( input  ) Importe Tratamiento Futuro           *
      *                                                                   *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkImpTratFut...
     P                 b                   export
     D SVPSIN_chkImpTratFut...
     D                 pi              n
     D   peTfut                      15  2 const

      /free

       SVPSIN_inz();

       if (peTfut < 0);
            return *off;
          Else;
            return *on;
          Endif;
      /end-free

     P SVPSIN_chkImpTratFut...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSIN_chkImpGasMed()                                             *
      *                                                                   *
      *          peGmed   ( input  ) Importe Gastos Medicos               *
      *                                                                   *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkImpGasMed...
     P                 b                   export
     D SVPSIN_chkImpGasMed...
     D                 pi              n
     D   peGmed                      15  2 const

      /free

       SVPSIN_inz();

       if (peGmed < 0);
            return *off;
          Else;
            return *on;
          Endif;
      /end-free

     P SVPSIN_chkImpGasMed...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSIN_chkImpOtroRubro()                                          *
      *                                                                   *
      *          peOtro   ( input  ) Importe Otros Rubros                 *
      *                                                                   *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkImpOtroRubro...
     P                 b                   export
     D SVPSIN_chkImpOtroRubro...
     D                 pi              n
     D   peOtro                      15  2 const

      /free

       SVPSIN_inz();

       if (peOtro < 0);
            return *off;
          Else;
            return *on;
          Endif;
      /end-free

     P SVPSIN_chkImpOtroRubro...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSIN_chkImpIncFisica()                                          *
      *                                                                   *
      *          peIfis   ( input  ) Importe Incapacidad Fisica           *
      *                                                                   *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkImpIncFisica...
     P                 b                   export
     D SVPSIN_chkImpIncFisica...
     D                 pi              n
     D   peIfis                      15  2 const

      /free

       SVPSIN_inz();

       if (peIfis < 0);
            return *off;
          Else;
            return *on;
          Endif;
      /end-free

     P SVPSIN_chkImpIncFisica...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSIN_chkImpIncPsico()                                           *
      *                                                                   *
      *          peIpsi   ( input  ) Importe Incapacidad Psicologica      *
      *                                                                   *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkImpIncPsico...
     P                 b                   export
     D SVPSIN_chkImpIncPsico...
     D                 pi              n
     D   peIpsi                      15  2 const

      /free

       SVPSIN_inz();

       if (peIpsi < 0);
            return *off;
          Else;
            return *on;
          Endif;
      /end-free

     P SVPSIN_chkImpIncPsico...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSIN_chkFecSupHoy()                                             *
      *                                                                   *
      *          FecIng   ( input  ) Valida Fecha no sea superior a hoy   *
      *                              Valida Fecha no sea 0                *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkFecSupHoy...
     P                 b                   export
     D SVPSIN_chkFecSupHoy...
     D                 pi              n
     D   FecIng                       8  0 const
     D  hoy            s              8  0
     D  FecIzq         s              8  0
     D  peEmpr         s              1a
     D  peSucu         s              2a

      /free

       SVPSIN_inz();

       peEmpr = 'A';
       peSucu = 'CA';

      // if (FecIng <= 0);
      //      return *off;
      //    Else;
      //      return *on;
      //    Endif;
       fecIzq = SPVFEC_GiroFecha8  ( FecIng
                                   : 'AMD' );


       hoy = SVPSIN_getFechaDelDia( peEmpr
                                  : peSucu );

       if (FecIzq > hoy);
            return *off;
          Else;
            return *on;
          Endif;
      /end-free

     P SVPSIN_chkFecSupHoy...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSIN_chkSumaAcuerdo()                                           *
      *          peDmor   ( input  ) Importe Daño Moral                   *
      *          peDmat   ( input  ) Importe Daño Material                *
      *          pePuso   ( input  ) Importe Priv. Uso                    *
      *          peLces   ( input  ) Importe Lucro Cesante                *
      *          peTfut   ( input  ) Importe Tratamiento Futuro           *
      *          peGmed   ( input  ) Importe Gastos Medicos               *
      *          peIpsi   ( input  ) Importe Incapacidad Psicologica      *
      *          peOtro   ( input  ) Importe Otros Rubros                 *
      *          peIfis   ( input  ) Importe Incapacidad Fisica           *
      *                                                                   *
      *          SumAcu   ( output ) Suma Campos Acuerdo                  *
      *                                                                   *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkSumaAcuerdo...
     P                 b                   export
     D SVPSIN_chkSumaAcuerdo...
     D                 pi              n
     D   peDmor                      15  2 const
     D   peDmat                      15  2 const
     D   pePuso                      15  2 const
     D   peLces                      15  2 const
     D   peTfut                      15  2 const
     D   peGmed                      15  2 const
     D   peIpsi                      15  2 const
     D   peOtro                      15  2 const
     D   peIfis                      15  2 const
     D  SumAcu                       15  2 options( *omit : *nopass )

      /free

       SVPSIN_inz();

       sumAcu = *zeros;


       SumAcu = (peDmor +
                 peDmat +
                 pePuso +
                 peLces +
                 peTfut +
                 peGmed +
                 peIpsi +
                 peOtro +
                 peIfis );
       return *on;

      /end-free

     P SVPSIN_chkSumaAcuerdo...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSIN_chkIncFisica()                                             *
      *          peXifi   ( input  ) % Incapacidad Fisica                 *
      *          peIfis   ( input  ) Importe Incapacidad Fisica           *
      *                                                                   *
      * Valido que ambos campos peXinc y PeImIf no tengan datos           *
      * Son campos excluyentes entre si                                   *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkIncFisica...
     P                 b                   export
     D SVPSIN_chkIncFisica...
     D                 pi              n
     D   peXifi                      15  2 const
     D   peIfis                      15  2 const

      /free

       SVPSIN_inz();

       if (peXifi > 0) and (peIfis > 0);
            return *off;
          Else;
            return *on;
          Endif;
      /end-free

     P SVPSIN_chkIncFisica...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSIN_chkIncPsico()                                              *
      *          peXips   ( input  ) % Incapacidad Psicologica            *
      *          peIpsi   ( input  ) Importe Incapacidad Psicologica      *
      *                                                                   *
      * Valido que ambos campos peXpsi y PeImIp no tengan datos           *
      * Son campos excluyentes entre si                                   *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkIncPsico...
     P                 b                   export
     D SVPSIN_chkIncPsico...
     D                 pi              n
     D   peXips                      15  2 const
     D   peIpsi                      15  2 const

      /free

       SVPSIN_inz();

       if (peXips > 0) and (peIpsi > 0);
            return *off;
          Else;
            return *on;
          Endif;
      /end-free

     P SVPSIN_chkIncPsico...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSIN_chkLucroPri()                                              *
      *          pePuso   ( input  ) Importe Priv. Uso                    *
      *          peLces   ( input  ) Importe Lucro Cesante                *
      *                                                                   *
      * Valido que ambos campos pePuso y PeLces no tengan datos           *
      * Son campos excluyentes entre si                                   *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkLucroPri...
     P                 b                   export
     D SVPSIN_chkLucroPri...
     D                 pi              n
     D   pePuso                      15  2 const
     D   peLces                      15  2 const

      /free

       SVPSIN_inz();

       if (pePuso > 0) and (peLces > 0);
            return *off;
          Else;
            return *on;
          Endif;
      /end-free

     P SVPSIN_chkLucroPri...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSIN_chkDanosExc()                                              *
      *          peXifi   ( input  ) % Incapacidad Fisica                 *
      *          peXips   ( input  ) % Incapacidad Psicologica            *
      *          peDmor   ( input  ) Importe Daño Moral                   *
      *          peDmat   ( input  ) Importe Daño Material                *
      *          pePuso   ( input  ) Importe Priv. Uso                    *
      *          peLces   ( input  ) Importe Lucro Cesante                *
      *          peTfut   ( input  ) Importe Tratamiento Futuro           *
      *          peGmed   ( input  ) Importe Gastos Medicos               *
      *          peIpsi   ( input  ) Importe Incapacidad Psicologica      *
      *          peOtro   ( input  ) Importe Otros Rubros                 *
      *          peIfis   ( input  ) Importe Incapacidad Fisica           *
      *                                                                   *
      * Valido que si campos peDmat, PePuso y PeLces tienen datos         *
      * los demas campos no, son campos excluyentes entre si              *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkDanosExc...
     P                 b                   export
     D SVPSIN_chkDanosExc...
     D                 pi              n
     D   peDmor                      15  2 const
     D   peDmat                      15  2 const
     D   pePuso                      15  2 const
     D   peLces                      15  2 const
     D   peTfut                      15  2 const
     D   peGmed                      15  2 const
     D   peIpsi                      15  2 const
     D   peOtro                      15  2 const
     D   peIfis                      15  2 const
     D   peXifi                       5  2 const
     D   peXips                       5  2 const
     D   sumA          s             15  2
     D   sumB          s             15  2

      /free

       SVPSIN_inz();

       SumA = *zeros;
       SumB = *zeros;

       SumA = (peLces +
               peDmat +
               pePuso );

       SumB = (peDmor +
               peTfut +
               peGmed +
               peIpsi +
               peOtro +
               peXifi +
               peXips +
               peIfis );
       if (sumA > 0) and (sumB > 0);
            return *off;
          Else;
            return *on;
          Endif;
      /end-free

     P SVPSIN_chkDanosExc...
     P                 E
      * ----------------------------------------------------------------- *
      * SVPSIN_ListaPahSb5(): Lista    datos del archivo PAHSB5           *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peRama   ( input  ) Rama                                 *
      *          peSini   ( input  ) Siniestro                            *
      *          peNops   ( input  ) Numero de Operacion                  *
      *          peNrdf   ( input  ) Numero de Beneficiario               *
      *          peSebe   ( input  ) Secuecnia de Beneficiario            *
      *          peFech   ( input  ) Fecha de Acuerdo                     *
      *          peSecu   ( input  ) Secuencia de Fecha de Acuerdo        *
      *          peDsPa   ( output ) Estructura archivo PAHSB5            *
      *          peDsPaC  ( output ) Cantidad                             *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_ListaPahSb5...
     P                 b                   export
     D SVPSIN_ListaPahSb5...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peDsPa                            likeds( dsPahsb5_t ) dim (99)
     D   peDsPac                     10i 0

     D k2hsb5          ds                  likerec(p1hsb5:*key)
     D @@Ds001         ds                  likerec(p1hsb5:*input)

      /free

       SVPSIN_inz();

       clear peDsPa;
       clear peDsPaC;
       k2hsb5.b5empr = peEmpr;
       k2hsb5.b5sucu = peSucu;
       k2hsb5.b5rama = peRama;
       k2hsb5.b5sini = peSini;
       k2hsb5.b5nops = peNops;
       k2hsb5.b5nrdf = peNrdf;
       k2hsb5.b5sebe = peSebe;

       setll %kds ( k2hsb5 : 7 ) Pahsb5;
       reade %kds ( k2hsb5 : 7 ) Pahsb5 @@Ds001;
       dow not %eof;
         PeDsPac += 1;
         eval-corr peDsPa(peDsPaC) = @@Ds001;
         reade %kds ( k2hsb5 : 7 ) Pahsb5 @@Ds001;
       enddo;

       return *on;

      /end-free

     P                 e

      * ----------------------------------------------------------------- *
      * SVPSIN_chkBenTercero ()                                           *
      *          peempr   ( input )                                       *
      *          pesucu   ( input )                                       *
      *          perama   ( input )                                       *
      *          pesini   ( input )                                       *
      *          penops   ( input )                                       *
      *          penrdf   ( input )                                       *
      *                                                                   *
      * Valido que el beneficiario sea un tercero                         *
      * retorna *on / *off   on ok     / off error                        *
      * ----------------------------------------------------------------- *
     P SVPSIN_chkBenTercero...
     P                 b                   export
     D SVPSIN_chkBenTercero...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D k1ysbe          ds                  likerec(p1hsbe05:*key)
      /free

       SVPSIN_inz();
       k1ysbe.beempr = peEmpr;
       k1ysbe.besucu = peSucu;
       k1ysbe.berama = peRama;
       k1ysbe.besini = peSini;
       k1ysbe.benops = peNops;
       k1ysbe.benrdf = peNrdf;

       chain %kds(k1ysbe:6) pahsbe05;
       if bemar2 = '2';
         return *On;
       else;
         return *Off;
       endif;
      /end-free

     P SVPSIN_chkBenTercero...
     P                 E

      * ------------------------------------------------------------ *
      * SVPSIN_chkEstadoTerminal(): Verifica que el estado           *
      *                             sea Terminal.                    *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peCesi   ( input  ) Codigo estado Siniestro              *
      *                                                              *
      * Retorna: *on = Es Terminal / *off = no es Terminal           *
      * ------------------------------------------------------------ *
     P SVPSIN_chkEstadoTerminal...
     P                 b                   export
     D SVPSIN_chkEstadoTerminal...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peCesi                       2  0 const

     D peDsErC         s             10i 0
     D peDsEr          ds                  likeds(dsSet4021_t) dim(9999)
     D @@Rama          s              2  0
     D @@Cesi          s              2  0

      /free

       SVPSIN_inz();

       clear peDsEr;
       clear peDsErC;
       @@Rama = peRama;
       @@Cesi = peCesi;
       if SVPTAB_listaEdoReclamo( peEmpr
                                : peSucu
                                : peDsEr
                                : peDsErC
                                : @@Rama
                                : @@Cesi ) = *off;
         return *off;
       endif;

       if peDsEr(1).t@cese = 'TR';
         return *on;
       else;
         return *off;
       endif;

      /end-free

     P SVPSIN_chkEstadoTerminal...
     P                 e

      * ----------------------------------------------------------------- *
      * SVPSIN_getReservaRv Recupera valor por defecto importe riesgos Var*
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peRama   ( input  ) Rama                                 *
      *          peXcob   ( input  ) Cobertura                            *
      *          peCauc   ( input  ) Causa                                *
      *          peFron   ( input  ) Fronting (1) / No Fronting (0)       *
      *          peFech   ( input  ) Fecha de Vigencia                    *
      *          peDsPa   ( output ) Estructura archivo SET476            *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_getReservaRV...
     P                 b                   export
     D SVPSIN_getReservaRV...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peXcob                       3  0 const
     D   peCauc                       4  0 const
     D   peFron                       1  0 const
     D   peFech                       8  0 options(*omit:*nopass)
     D   peDsPa                            likeds( dsSet476_t )
     D                                     options(*nopass:*omit)

     D k1y476          ds                  likerec( s1t476 :*key )
     D dseni2          ds                  likerec( s1t476 :*input)
     D @@Ds456         ds                  likerec( s1t456 : *input )
     D @@fech          s              8  0

      /free

       SVPSIN_inz();

       clear peDsPa;

       if %parms >= 7 and %addr(peFech) <> *Null;
          if not SPVFEC_FechaValida8 ( peFech );
             return *off;
          endif;
          @@fech = pefech ;
        else;
          if SVPSIN_getSet456( peEmpr
                             : peSucu
                             : @@Ds456 );
             @@fech = (@@ds456.t@fema*10000)
                    + (@@ds456.t@femm*100)
                    + @@ds456.t@femd;
           else;
             return *off;
          endif;
       endif;

       k1y476.t@empr = peEmpr;
       k1y476.t@sucu = peSucu;
       k1y476.t@rama = peRama;
       k1y476.t@cobe = peXcob;
       k1y476.t@cauc = peCauc;
       k1y476.t@fron = peFron;
       k1y476.t@fdes = @@fech;

       setll %kds(k1y476:7) set47601;
       reade(n) %kds(k1y476:6) set47601 dseni2;
       if not %eof (set47601);
          eval-corr PeDsPa = dseni2 ;
          return *On;
       endif;

       return *Off;

      /end-free

     P SVPSIN_getReservaRV...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPSIN_getReclamo: Obtiene datos de un reclamo a una fecha        *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peRama   ( input  ) Rama                                 *
      *          peSini   ( input  ) Siniestro                            *
      *          peNops   ( input  ) Operacion de Siniestro               *
      *          pePoco   ( input  ) Componente                           *
      *          pePaco   ( input  ) Parentesco                           *
      *          peRiec   ( input  ) Riesgo                               *
      *          peXcob   ( input  ) Cobertura                            *
      *          peNrdf   ( input  ) Dato Filiatorio                      *
      *          peSebe   ( input  ) Secuencia                            *
      *          peFech   ( input  ) Fecha a la cual obtener              *
      *          peRecl   ( output ) Numero de Reclamo                    *
      *          peCesi   ( output ) Estado                               *
      *          peHecg   ( output ) Hecho Generador                      *
      *          peCtle   ( output ) Lesiones                             *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPSIN_getReclamo...
     P                 b                   export
     D SVPSIN_getReclamo...
     D                 pi              n
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peRama                        2  0 const
     D  peSini                        7  0 const
     D  peNops                        7  0 const
     D  pePoco                        7  0 const
     D  pePaco                        6  0 const
     D  peRiec                        3a   const
     D  peXcob                        3  0 const
     D  peNrdf                        7  0 const
     D  peSebe                        6  0 const
     D  peFech                        8  0 const
     D  peRecl                        3  0
     D  peCesi                        2  0
     D  peHecg                        1a
     D  peCtle                        2a

     D k1hsb1          ds                  likerec(p1hsb1:*key)
     D fecsb1          s              8  0

      /free

       SVPSIN_inz();

       peRecl = 0;
       peCesi = 0;
       peHecg = *blanks;
       peCtle = *blanks;

       k1hsb1.b1Empr = peEmpr;
       k1hsb1.b1Sucu = peSucu;
       k1hsb1.b1Rama = peRama;
       k1hsb1.b1Sini = peSini;
       k1hsb1.b1Nops = peNops;
       k1hsb1.b1Poco = pePoco;
       k1hsb1.b1Paco = pePaco;
       k1hsb1.b1Riec = peRiec;
       k1hsb1.b1Xcob = peXcob;
       k1hsb1.b1Nrdf = peNrdf;
       k1hsb1.b1Sebe = peSebe;
       setll %kds(k1hsb1:11) pahsb1;
       reade(n) %kds(k1hsb1:11) pahsb1;
       dow not %eof;
           fecsb1 = (b1fema * 10000)
                  + (b1femm *   100)
                  +  b1femd;
           if fecsb1 <= peFech;
              peRecl = b1recl;
              peCesi = b1cesi;
              peHecg = b1hecg;
              peCtle = b1ctle;
              return *on;
           endif;
        reade(n) %kds(k1hsb1:11) pahsb1;
       enddo;

       return *off;

      /end-free

     P                 e

      * ----------------------------------------------------------------- *
      * SVPSIN_getSiniestralidadAsegurado: Cuenta cantidad de siniestros  *
      *                                    de un asegurado.               *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peAsen   ( input  ) Código de Asegurado                  *
      *          peRama   ( input  ) Rama                                 *
      *                                                                   *
      * retorna Cantidad de siniestros.                                   *
      * ----------------------------------------------------------------- *
     P SVPSIN_getSiniestralidadAsegurado...
     P                 b                   export
     D SVPSIN_getSiniestralidadAsegurado...
     D                 pi             7  0
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peAsen                        7  0 const
     D  peRama                        2  0 const

     D k1hscd          ds                  likerec(p1hscd13:*key)
     D cant            s              7  0

      /free

       SVPSIN_inz();

       cant = 0;

       k1hscd.c3empr = peEmpr;
       k1hscd.c3sucu = peSucu;
       k1hscd.c3asen = peAsen;
       k1hscd.c3rama = peRama;
       setll %kds(k1hscd:4) pahscd13;
       reade %kds(k1hscd:4) pahscd13;
       dow not %eof;
           if c3sini > 0;
              cant += 1;
           endif;
        reade %kds(k1hscd:4) pahscd13;
       enddo;

       return cant;

      /end-free

     P                 e
      * ------------------------------------------------------------ *
      * SVPSIN_getUltTipPago() : Obtengo Ultimo Tipo de pago         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peTipP   (output)  Ultimo tipo de pago                   *
      *                                                              *
      * Retorna: *On *Off                                            *
      * ------------------------------------------------------------ *

     P SVPSIN_getUltTipPago...
     P                 B                   export
     D SVPSIN_getUltTipPago...
     D                 pi             1a
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

     D k1yshp          ds                  likerec(p1hshp:*key)
     D retorno         S              1a   inz('N')
      /free

       SVPSIN_inz();

       k1yshp.hpempr = peEmpr;
       k1yshp.hpsucu = peSucu;
       k1yshp.hprama = peRama;
       k1yshp.hpsini = peSini;
       k1yshp.hpnops = peNops;

       setgt %kds(k1yshp:5) pahshp;
       readpe %kds(k1yshp:5) pahshp;
       dow not %eof;
         retorno = hpmar1;
         leave;
       enddo;
       SVPSIN_End();
       return retorno;

      /end-free
     P                 e

