     H debug option(*nodebugio:*srcstmt:*nounref:*noshowcpy)
     H actgrp(*caller) dftactgrp(*no) datfmt(*iso)
     H bnddir('HDIILE/HDIBDIR') DECEDIT('0,')
     h COPYRIGHT('HDI Seguros S.A.')
      *****************************************************************
      *
      * Envío de mail ODP TALL/REP/TERC. GRABA CNHOPM.
      *
      * INF1MARC 30/06/2014
      *
      * Pedido de desarrollo 3386
      *
      *****************************************************************
      * MLA 27/10/2014 - Cambio en GNHDA7 y llamada a SVPMAIL              *
      *
      * SMA 01/12/2014   Pedido de desarrollo 3275
      *  Se extiende la cantidad de casos en las que se envía mail de
      * aviso de pago.
      *
      *  SMA 30/01/2015 Se quita toda posibilidad de que procese pagos
      * de área técnica 32 ya que se están filtrando por alguna condición
      * no prevista.
      *
      *  SMA 06/02/2015 Se agrega busqueda de la descripción de forma
      * de pago para los pagos de siniestros a Terceros. Pedido 3965
      *  Se quita también el reemplazo del valor de @@Madd(1).nomb por
      * nombres del destinatario final del pago ya que no corresponde
      * más.
      *
      * SMA 20/04/2015 Pedido de desarrollo 4052
      *  Se modifica para que mande a todas las direcciones de mail
      *  Se quita el envío de mail de Aviso de Emisión de OP cuando
      * el productor no es del interior.
      * de tipo ADMINISTRACION (20)
      *  Se incorporan pagos de Siniestros a:
      *                            Inspectores y Liquidadores (82),
      *                            Clinicas y Sanatorios (83),
      *                            Porveedores de Bienes y Servicios (84),
      *                            Honorarios Profesionales (85),
      *                            Alquileres (86),
      *                            Médicos (87),
      *                            Otros proveedores (88),
      *                            Proveedores Varios (89)
      * SMA 25/05/2018 Pedido de desarrollo 4168
      *  Se solicita modificar el texto del mail que se envía con las ODP
      *  para el caso de importes negativos por Nota de Crédito.
      *
      * SMA 12/06/2018 Pedido de desarrollo 4193
      *   Se omiten los casos en los que PDCOPT viene en blanco para el
      *  caso de la generación del excel ya que sin los datos de ese campo
      *  no se puede armar el excel.
      * SMA 31/07/2015  Pedido de desarrollo 4237
      *     Se agrega pago a Asegurado solo cuando es cancelación de pago.
      * NWN 22/10/2015  Pedido de desarrollo 4316
      *     Se agrega archivo GNTMSG y se graban registros para la WEB.
      * NWN 11/12/2015  Mal grabado campo SGNIVC por Organizador.
      * JSN 22/05/2017 Pedido de desarrollo 4973
      *                Modificación mail de Emisión de Orden de Pago  y
      *                Liberación de Fondos enviados a travez del mail
      *                se cambio el campo PMIMAU por @@Mto
      * JSN 01/06/2020 Si OP de juicios, agrega leyenda.
      * ERC 25/01/2022 Mail a los productores cuando se paga a un proveedor
      *                DESDE SINIESTROS. Ped.11411.
      * SGF 21/07/2022 No sé qué pasó pero hubo una pisada de fuentes de
      *                este programa.
      *                La versión de producción está incorrecta.
      *                Hago este cambio para no grabar GNTMSG.
      * SGF 23/07/2022 Envío mail a tercero (ver redmine 12219).
      * SGF 27/09/2022 Desconecto ERC 25012022.
      *                Este programa no soporta enviar a productores
      *                de manera separada por OP ya que al momento de
      *                la cancelación de las OPs Caja las junta todas
      *                en un solo comprobante de pago.
      *                Redmine #12338.
      * SGF 04/01/2023 Cuando se manda mail a proveedor de siniestro
      *                no mandar al PAS por la misma razón que la ptf
      *                SGF 27092022.
      * IMF 02/07/2024 Agrego write_cntrdi.
      *****************************************************************
     Fcnhopm    Up   e           k disk
     Fcntnau    if   e           k disk
     Fgnhdaf    if   e           k disk
     Fcntcfp    if   e           k disk
     Fpahscd    if   e           k disk
     Fpahec1    if   e           k disk
     Fsahint    if   e           k disk
     Fset400    if   e           k disk    usropn
     fqsysprt   o    f   80        printer usropn
     fcnhopa31  if   e           k disk    usropn rename(c1hopa:c1hopa31)
     fcnhret99  if   e           k disk    usropn
     fgnttfc    if   e           k disk    usropn
     fcnhasi    if   e           k disk    usropn
     fcntcge    if   e           k disk    usropn
     fcnwnin05  if   e           k disk    usropn
     fcnhopa    if   e           k disk    usropn
     fpahshp01  if   e           k disk
     fset001    if   e           k disk
     fpahsb1    if   e           k disk
     Fgnttbe    if   e           k disk    usropn
     Fgntmsg    if a e           k disk
     Fgntmon    if   e           k disk
     Fpahjhp04  if   e           k disk
erc  Fset407    if   e           k disk
erc  Fpahsva    if   e           k disk
erc  Fcntcau    if   e           k disk
     Fcntrdi    uf a e           k disk
      * Prototipe *--------------------------------------------------------*
     Dspfedih          pr                  extpgm('SPFEDIH')
     D  @fasa                         4  0
     D  @fasm                         2  0
     D  @fasd                         2  0
     D  dias1                         3  0
     D  @@@@@                         1    const
     D  xfasa                         4  0
     D  xfasm                         2  0
     D  xfasd                         2  0
     D  xlaps                         5  0

     D random          pr                  extproc('CEERAN0')
     D   seed                        10u 0
     D   floater                      8f
     D   feedback                    12    options(*omit)

     D es_proveedor    pr                  like(*in01)
     D es_tercero      pr                  like(*in01)
     D es_asegurado    pr                  like(*in01)
     D Obtiene_productor...
     D                 pr
     D P_EMPR                              like(PMEMPR) const
     D P_SUCU                              like(PMSUCU) const
     D P_RAMA                              like(PMRAMA) const
     D P_SINI                              like(PMSINI) const
     D P_NOPS                              like(PMNOPS) const
     D P_NIVT                              like(C1NIVT)
     D P_NIVC                              like(C1NIVC)
     D zona_productor...
     D                 pr                  like(INTIPD)
     D P_EMPR                              like(C1EMPR) const
     D P_SUCU                              like(C1SUCU) const
     D P_NIVT                              like(C1NIVT)
     D P_NIVC                              like(C1NIVC)

     D fun_es_zona_excluida...
     D                 pr                  like(*in01)

     D Body_emision_odp_Prov_Sinie...
     D                 pr          5000a
     D Body_emision_odp_Prov_Siniemsg...
     D                 pr           512a
     D Body_Cancelacion_odp_Prov_Sinie...
     D                 pr          5000a
     D Body_Cancelacion_odp_Prov_Siniemsg...
     D                 pr           512a
     D Body_emision_odp_Tercero...
     D                 pr          5000a
     D Body_emision_odp_Terceromsg...
     D                 pr           512a
     D Body_Cancelacion_odp_Tercero...
     D                 pr          5000a
     D Body_Cancelacion_odp_Terceromsg...
     D                 pr           512a
     D Body_Cancelacion_odp_Asegura...
     D                 pr          5000a
     D Body_Cancelacion_odp_Aseguramsg...
     D                 pr           512a
     D Body_emision_odp_Contaduria...
     D                 pr          5000a
     D Body_Cancelacion_odp_Contaduria...
     D                 pr          5000a
erc  D Body_Cancelacion_odp_Tesoreria...
erc  D                 pr          5000a

     D Reemplazo_de_variables...
     D                 pr
     D                             5000a
     D Reemplazo_de_variables_msg...
     D                 pr
     D                              512a   varying

     D Asunto_emision_odp_Prov_Sinie...
     D                 pr           270a   varying
     D Asunto_Cancelacion_odp_Prov_Sinie...
     D                 pr           270a   varying
     D Asunto_emision_odp_Tercero...
     D                 pr           270a   varying
     D Asunto_Cancelacion_odp_Tercero...
     D                 pr           270a   varying
     D Asunto_Cancelacion_odp_Asegura...
     D                 pr           270a   varying
     D Asunto_emision_odp_Contaduria...
     D                 pr           270a   varying
     D Asunto_Cancelacion_odp_Contaduria...
     D                 pr           270a   varying
erc  D Asunto_Cancelacion_odp_Tesoreria...
erc  D                 pr           270a   varying

     D @@msid          pr            25a

      * - Copys -------------------------------------------------------- **
     D/copy HDIILE/QCPYBOOKS,MAIL_H
     D/copy HDIILE/QCPYBOOKS,SVPMAIL_H
erc  D/copy hdiile/qcpybooks,svpdes_h


      * - Variables ---------------------------------------------------- **
     D Desde_mail      s             64a   varying
     D Desde_direccio  s            256a   varying
     D Asunto          s             70a   varying
     D Asunto_Largo    s            270a   varying
     D Body            s           5000a
     D Body1           s            512a   varying
     D Destinat_Nomb   s             50a   dim(100)
     D Destinat_mail   s            256a   dim(100)
     D Destinat_tipo   s             10i 0 dim(100)
     D Adjuntos        s            255a   dim(10)
     D rc              s             10i 0
     D i               s             10i 0
     D Borrar_adjunto  s              4a   inz('*YES')
     D Comprimir       s              4a   inz('*NO')
     D Nombre_zip      s             50a
     D rtn_sts         s             10i 0
     D @MailError      ds                  likeds(MAIL_ERDS_T)
     D CRLF            c                   x'0d25'
     d salir           S               n
     D @@Mto           s             15  2
     D @@Mone          s              5a
     D @@CodMo         s              2a

     D @@Madd          ds                  likeds(MailAddr_t) dim(100)
     D @@cade          s              5  0 dim(9)
     D @@err           s              1n
     d @@fin           s              3a
     d @@cadf          s              7  0 dim(9)
     d @1cadf3         s              5  0

     d Num             s              2  0
     D Nom_desti       s             50a
     D Nom_tercero     s             50a
     D Nom_asegura     s             50a
     D @fecha          s             10d   datfmt(*iso)
     d P_NIVT          s                   like(C1NIVT)
     d P_NIVC          s                   like(C1NIVC)
     d Tipo_mail_admi  s              2  0 inz(20)
     d zonas_excluida  s              5  0 CTDATA DIM(5) PERRCD(1)

     d ori_pmmai1      s                   like(pmmai1)
     d ori_pmmai2      s                   like(pmmai2)
     d gntprp          ds                  likeds(recprp_t) dim(100)
     D P_DATA_FROM     ds                  qualified
     D  From                         64a   varying
     D  Fadr                        256a   varying
     D Cprc            s             20a
     D Cspr            s             20a
     D Cspr1           s             20a
     D OK              s             10i 0
     D OK1             s             10i 0
     D ALFABETO        s             26a   inz('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D seed            s             10u 0
     D floater         s              8f
     D ran             s             30a
     D @1msid          s             25a

     D Momento         s               z
     D Ahora_num       s             20S 0
     d AddCPathHecho   S               n

     D xxlaps          s              5  0
     D xxfasd          s              2  0
     D xxfasm          s              2  0
     D xxfasa          s              4  0
     D MedPago         s             25

     D @@feca          s              4  0
     D @@fecm          s              2  0
     D @@fecd          s              2  0 inz(0)

     D K_cnhopa31      ds                  likerec(c1hopa31:*key)
     D K_cnhopa        ds                  likerec(c1hopa:*key)
     D K_gnttbe        ds                  likerec(g1ttbe:*key)
     D K_gntmsg        ds                  likerec(g1tmsg:*key)
     D k1yMon          ds                  likerec(g1tmon:*key)

      *
      * Consisiona la impresión de spool para ayudar a detectar errores.
      *

     D EsTesteo        s               n   inz(*off)
     D esJuicio        s               n
     D b_juic          s            512a

     d es_zona_excluida...
     d                 s               n

      *
      * Para envio al tercero
      *
     D @@Mad1          ds                  likeds(MailAddr_t) dim(100)
     D P_DATA_FRO1     ds                  likeds(Remitente_t)
     D Nu1             s              2  0
     D Asunt1          s             70a   varying
     D Bod1            s            512a   varying
     D Destinat_Nom1   s             50a   dim(100)
     D Destinat_mai1   s            256a   dim(100)
     D Destinat_tip1   s             10i 0 dim(100)

     D AddCPath        pr                  extpgm('TAATOOL/ADDCPATH')


     D                SDS
     D  nompgm           *PROC
     D  pgmlib                81     90
     D  nomjob               244    253
     D  nomusr               254    263

     Dspcadcom         pr                  extpgm('SPCADCOM')
     D                                1a
     D                                2a
     D                                1  0
     D                                5  0
     D                                5  0 dim(9)
     D                                 n
     D                                3a
     D                                7  0 dim(9) options(*nopass)

erc  d $rama$          s                   like(t@ramd)
erc  d $poli$          s                   like(cdpoli)
erc  d $sini$          s                   like(cdsini)
erc  d $aseg$          s                   like(dfnomb)
erc  d $fsin$          s              8  0 inz(20)
erc  d $nomp$          s                   like(Destinat_Nomb)
erc  d $fpag$          s              8  0 inz(20)
erc  d $nomv$          s                   like(dfnomb)
erc  d $dmay$          s                   like(cacoma)
erc  d $impo$          s                   like(pmimau)
erc  d $pate$          s                   like(vanmat)
erc  d $hecg$          s                   like(t@hecd)

      * Indicador *--------------------------------------------------------*

      ******************************************************
      * Procesa según el tipo de destinatario.
      ******************************************************
     c
     c                   clear                   Destinat_Nomb
     c                   clear                   Destinat_mail
     c                   clear                   Destinat_tipo
     c                   clear                   Nom_asegura
     c                   clear                   Nom_desti
     c                   clear                   Nom_tercero
     c                   clear                   Adjuntos
     c                   clear                   Nombre_zip
     c                   time                    Momento
     c                   move      momento       Ahora_num
      /free
       if not %open(cnhopa31);
       open cnhopa31;
       endif;

       if PMTIPO = 'C';
        K_cnhopa31.PAEMPR = PMEMPR;
        K_cnhopa31.PASUCU = PMSUCU;
        K_cnhopa31.PBTICO = PMARTC;
        K_cnhopa31.PBNRAS = PMPACP;
        K_cnhopa31.PRCOMA = PMCOMA;
        K_cnhopa31.PRNRMA = PMNRMA;
        K_cnhopa31.PBFASA = PMFASA;
        K_cnhopa31.PBFASM = PMFASM;
        K_cnhopa31.PBFASD = PMFASD;

        esJuicio = *off;
        setll %kds(K_cnhopa31:9) c1hopa31;
        reade %kds(K_cnhopa31:9) c1hopa31;
        dow not %eof;
            setll (paempr:pasucu:paartc:papacp) pahjhp04;
            reade (paempr:pasucu:paartc:papacp) pahjhp04;
            dow not %eof;
                esJuicio = *on;
                leave;
             reade (paempr:pasucu:paartc:papacp) pahjhp04;
            enddo;
            if esJuicio;
               leave;
            endif;
        reade %kds(K_cnhopa31:9) c1hopa31;
        enddo;

        chain %kds(K_cnhopa31:9) c1hopa31;
        if not %found(cnhopa31);
         eval PAARTC = PMARTC;
        else;
          if paImme <> *Zeros;
            @@Mto = paImme;
          else;
            @@Mto = paImau;
          endif;
          @@CodMo = paComo;
        endif;
       else;
        if not %open(cnhopa);
        open cnhopa;
        endif;
        K_cnhopa.PAEMPR = PMEMPR;
        K_cnhopa.PASUCU = PMSUCU;
        K_cnhopa.PAARTC = PMARTC;
        K_cnhopa.PAPACP = PMPACP;
        chain %kds(K_cnhopa) c1hopa;
        if not %found(cnhopa);
         eval PASTOP = '8';
        else;
          if paImme <> *Zeros;
            @@Mto = paImme;
          else;
            @@Mto = paImau;
          endif;
          @@CodMo = paComo;
        endif;

       endif;

       k1yMon.moComo = @@CodMo;
       chain %kds( k1yMon : 1 ) gntmon;
       if %found( gntmon );
         @@Mone = moNmoc;
       endif;

      /end-free
     c                   if        EsTesteo
     c                   except    NRODEOP
     c                   endif

      ***************************************************************
      **
      **    S I N I E S T R O S
      **
      ***************************************************************
     c                   if        paartc = t@artc
     c                   eval      es_zona_excluida = fun_es_zona_excluida
     c                   eval      es_zona_excluida = '0'
     c                   clear                   t@rame
     c                   clear                   b1hecg
     c     K_pahshp01    chain     p1hshp
     c                   if        %found(pahshp01)
     c     K_set001      chain     s1t001
     c                   if        %found(Set001)
     c                   if        t@rame = 4
     c     K_pahsb1      chain     p1hsb1
     c                   endif
     c                   endif
     c                   endif
     c
     c                   select
     c
       // Trata OP de Proveedores de Siniestros.
     c
     c                   when      es_proveedor
     c                             and not (pastop = '8' and pmtipo = 'G')
     c                   eval      ori_pmmai1 =   pmmai1
     c                   eval      ori_pmmai2 =   pmmai2
     c                   exsr      To_Prov_Sinie
     c                   if        ori_pmmai1 <> '0' or ori_pmmai2 <> '0'
     c
     c
     c                   if        pmmai3 <> '0' and
     c                             not es_zona_excluida
     c                             and (pmcoma = '80' or pmcoma = '81')
     c                             and PMTIPO = 'C'
      /free
        // busca cadena del productor para saber si va a tener que
        // enviar mail al organizador y si es así no borrar el adjunto

                          clear @@cade;
                          clear @@fin;
                          clear @@cadf;
                          clear @@madd;
                          callp  SPCADCOM( pmempr
                                         : pmsucu
                                         : pmnivt
                                         : pmnivc
                                         : @@cade
                                         : @@err
                                         : @@fin
                                         : @@cadf);


                          @1cadf3 = 0;
                          if not @@err and @@cadf(1) <> @@cadf(3);
                          @1cadf3 = @@cade(3);
                          Borrar_adjunto = '*NO';
                          endif;

      /end-free
     c                   endif


     c                   exsr      Envio_mail
     c                   eval      Borrar_adjunto = '*YES'

     c                   if        rtn_sts <> 0
     c                   if        ori_pmmai1 <> '0'
     c                   eval      pmmai1 = '1'
     c                   endif
     c                   if        ori_pmmai2 <> '0'
     c                   eval      pmmai2 = '1'
     c                   endif
     c                   endif
     c                   endif

     c                   if        pmmai3 <> '0' and
     c                             not es_zona_excluida
     c                             and (pmcoma = '80' or pmcoma = '81')
     C                   exsr      cadena
     c                   else
     c                   eval      pmmai3 = '0'
     c                   endif

       // Trata OP de terceros.

     c                   when      es_tercero  and not
     c                             (es_zona_excluida and PMTIPO = 'G')
     c                             and not (pastop = '8' and pmtipo = 'G')
     c                   eval      ori_pmmai1 =   pmmai1
     c                   eval      ori_pmmai2 =   pmmai2
     c                   exsr      To_Tercero
      * Mail al tercero
     C                   if        ori_pmmai1 <> '0'
     C                   exsr      envio_tercero
     c                   if        rtn_sts <> 0
     c                   eval      pmmai1 = '1'
     C                   endif
     C                   endif
     c                   if        ori_pmmai1 <> '0' or ori_pmmai2 <> '0'
     c                   exsr      Envio_mail

     c                   if        rtn_sts <> 0
     c                   if        ori_pmmai2 <> '0'
     c                   eval      pmmai2 = '1'
     c                   endif
     c                   endif
     c                   endif

     c                   if        pmmai3 <> '0' and
     c                             not es_zona_excluida
     c                   exsr      cadena
     c                   else
     c                   eval      pmmai3 = '0'
     c                   endif

       // Trata OP de Asegurados.

     c                   when      es_asegurado and PMTIPO = 'C'
     c                             and not (pastop = '8') and inmabc <> 'S'
     c                   eval      ori_pmmai1 =   pmmai1
     c                   eval      ori_pmmai2 =   pmmai2
     c                   exsr      To_Asegura
     C                   exsr      write_cntrdi
     c                   if        ori_pmmai1 <> '0' or ori_pmmai2 <> '0'
     c                   exsr      Envio_mail

     c                   if        rtn_sts <> 0
     c                   eval      pmmai1 = '0'
     c                   if        ori_pmmai2 <> '0'
     c                   eval      pmmai2 = '1'
     c                   endif
     c                   endif
     c                   endif

     c                   if        pmmai3 <> '0'
     c                   exsr      cadena
     c                   else
     c                   eval      pmmai3 = '0'
     c                   endif

     c                   endsl

      *
     c                   else
      ***************************************************************
      **
      **    C O N T A D U R Í A
      **
      ***************************************************************
     c                   if        pmmai1 <> '0'
      * Si no es impuestos.
     c                   if        PAARTC >= 31 and PAARTC <= 37
     c                             and  not (PAARTC = 32)
      *
      * Si no es terceros, solo proveedores.
      *
     c                             and not (Pmcoma = '**' or
     c                             Pmcoma = '*1')
     c                             and not (pastop = '8' and pmtipo = 'G')
     c                   exsr      To_Otros
     c
     c                   exsr      Envio_mail
     c                   else
     c                   eval      rtn_sts = 0
     c                   endif
     c                   if        rtn_sts = 0
     c                   eval      pmmai1 = '0'
     c                   eval      pmmai2 = '0'
     c                   eval      pmmai3 = '0'
     c                   else
     c                   eval      pmmai1 = '1'
     c                   endif
     c                   endif
     c                   endif


     c                   if        pmmai1 <> '1' and pmmai2 <> '1'
     c                             and pmmai3 <> '1'
     c                   delete    c1hopm
     c                   else
     c                   update    c1hopm
     c                   endif

     clr                 exsr      cierres_pgm
      ******************************************************
      *
      *
      *  Fin del programa.
      *
      *
      ******************************************************
      * Grabo en cntrdi para envio de recibo al PAS
      * en caso del que en beneficiario del pago sea el
      * asegurado y PMTIPO sea pago
      ******************************************************
     C     write_cntrdi  begsr
     C                   if        @@fecd = *zeros
     C                   eval      @@feca = %subdt(%timestamp():*y)
     C                   eval      @@fecm = %subdt(%timestamp():*m)
     C                   eval      @@fecd = %subdt(%timestamp():*d)
     C                   endif
     C                   if        PBFASA = @@feca and
     C                             PBFASM = @@fecm
     C     k_cntrd1      chain     c1trdi
     C                   if        not %found(cntrdi)
     C                   eval      CNEMPR = PAEMPR
     C                   eval      CNSUCU = PASUCU
     C                   eval      CNARTC = PAARTC
     C                   eval      CNPACP = PAPACP
     C                   eval      CNNIVT = PMNIVT
     C                   eval      CNNIVC = PMNIVC
     C                   eval      CNSINI = PMSINI
     C                   eval      CNNOPS = PMNOPS
     C                   eval      CNCOMA = PMCOMA
     C                   eval      CNNRMA = PMNRMA
     C                   eval      CNIMAU = PAIMAU
     C                   eval      CNRAMA = PARAMA
     C                   eval      CNPROC = '0'
     C                   eval      CNMAI1 = '0'
     C                   write     c1trdi
     C                   endif
     C                   endif
     c                   endsr
      * Para el caso de Proveedores de SINIESTROS
      ******************************************************
     c     To_Prov_Sinie begsr
     c                   eval      dfnomb = *all' '
     c     k_cntnau      chain     c1tnau
     c                   if        %found(cntnau)
     c                   eval      dfnrdf = NANRDF
     c                   if        EsTesteo
     c                   except    Dafben
     c                   endif
     c     k_gnhdaf      chain     g1hdaf
     c                   if        not %found(gnhdaf)
     c                   eval      Nom_desti = '**No Informado**'
     c                   else
     c                   eval      Nom_desti = dfnomb
     c                   endif
     c                   clear                   num
      * Busca mail del proveedor.
     c                   exsr      Mail_Beneficia
     c                   endif
      *
      * busca mail´s  del productor
     c                   if        not es_zona_excluida
     c                             and (pmcoma = '80' or pmcoma = '81')
     C                   eval      pmmai2 = '0'
     C                   eval      pmmai3 = '0'
     c*                  exsr      productor
     c                   endif
      *
      * Busca descripción forma de pago.
     c     k_cntcfp      chain     c1tcfp
     c                   if        not %found(cntcfp)
     c                   eval      fpivdv = 'No determinada'
     c                   endif

      *
      *  Cuerpo y asunto de mail por EMISIÓN de ODP
      *
     c                   if        PMTIPO = 'G'

      /free
                         Cspr ='AREA' + %editc(PAARTC:'X')
                                +  PMTIPO + 'PROVEEDOR';

                         Body = Body_emision_odp_Prov_Sinie;
                         Asunto_Largo= Asunto_emision_odp_Prov_Sinie;

                         Cspr1 ='AREA' + %editc(PAARTC:'X')
                                +  PMTIPO + 'PROVEEDORMSG';
                         Body1 = Body_emision_odp_Prov_Siniemsg;
                         @fecha = %date((*year * 10000) +
                                 (*month * 100)+*day : *iso);


      /end-free
     c                   endif
      *
      *  Cuerpo y asunto de mail por CANCELACIÓN de ODP
      *
     c                   if        PMTIPO = 'C'
      /free


                         Cspr ='AREA' + %editc(PAARTC:'X')
                                +  PMTIPO + 'PROVEEDOR';

                         Adjuntos(01) = %trim('/tmp/' +  %trim(nompgm) +
                                        %char(ahora_num) + '.XLS');

                         if       Graba_Xls(Adjuntos(01));
          //             Nombre_zip =  %trim(%trim(nompgm) +
          //                           %char(ahora_num) + '.ZIP');
                         else;
                         clear    Adjuntos;
                         endif;
                         Body = Body_Cancelacion_odp_Prov_Sinie;
                         b_juic = 'Antes de presentarse a '
                                + 'retirar su pago debera contactarse '
                                + 'y coordinar con su referente de la '
                                + 'Cia. sin excepcion</strong><p><strong>'
                                + '&nbsp;&nbsp;En el presente ';
                         if esJuicio;
                            body = %scanrpl( 'En el presente'
                                           : b_juic
                                           : body      );
                         endif;
                         Asunto_Largo= Asunto_Cancelacion_odp_Prov_Sinie;

                         Cspr1 ='AREA' + %editc(PAARTC:'X')
                                +  PMTIPO + 'PROVEEDORMSG';
                         Body1 = Body_Cancelacion_odp_Prov_Siniemsg;

       //Obtengo dias de pago

       if not %open(gnttbe);
        open gnttbe;
        k_gnttbe.g1empr = pmempr;
        k_gnttbe.g1sucu = pmsucu;
        k_gnttbe.g1tben = pmmar2;
        chain %kds(k_gnttbe) gnttbe;
       endif;

       if g1dia1 > 0;
        SPFEDIH ( pbfasa
                : pbfasm
                : pbfasd
                : g1dia1
                : 'A'
                : xxfasa
                : xxfasm
                : xxfasd
                : xxlaps );

        pmfasa = xxfasa;
        pmfasm = xxfasm;
        pmfasd = xxfasd;
       endif;

       if g1dia1 > 0;
        pmfasa = pbfasa;
        pmfasm = pbfasm;
        pmfasd = pbfasd;
       endif;

                         @fecha = %date((xxfasa * 10000) +
                                 (xxfasm * 100)+xxfasd : *iso);

      /end-free
     c                   endif
     c                   endsr
      ******************************************************
      * Para el caso de Tercero
      ******************************************************
     c     To_Tercero    begsr
     c                   eval      dfnomb = *all' '
     c                   eval      dfnrdf = PMNRMA
     c                   clear                   num
     c                   if        EsTesteo
     c                   except    Dafben
     c                   endif
     c     k_gnhdaf      chain     g1hdaf
     c                   if        not %found(gnhdaf)
     c                   eval      Nom_tercero = '**No Informado**'
     c                   else
     c                   eval      Nom_tercero = dfnomb
     c                   endif
     c                   clear                   num

     c
      * busca mail´s de productor
     c                   exsr      productor
      *
      * Busca descripción forma de pago.
     c     k_cntcfp      chain     c1tcfp
     c                   if        not %found(cntcfp)
     c                   eval      fpivdv = 'No determinada'
     c                   endif

      *
      *  Cuerpo y asunto de mail por EMISIÓN de ODP
      *
     c                   if        PMTIPO = 'G'
      /free

                         Cspr ='AREA' + %editc(PAARTC:'X')
                               +  PMTIPO + 'TERCERO   ';

                         Body = Body_emision_odp_Tercero;
                         Asunto_Largo= Asunto_emision_odp_Tercero;
                         Cspr1 ='AREA' + %editc(PAARTC:'X')
                               +  PMTIPO + 'TERCEROMSG';
                         Body1 = Body_emision_odp_Terceromsg;
       //Obtengo dias de pago

       if not %open(gnttbe);
        open gnttbe;
        k_gnttbe.g1empr = pmempr;
        k_gnttbe.g1sucu = pmsucu;
        k_gnttbe.g1tben = pmmar2;
        chain %kds(k_gnttbe) gnttbe;
       endif;

       if g1dia1 > 0;
        SPFEDIH ( pbfasa
                : pbfasm
                : pbfasd
                : g1dia1
                : 'A'
                : xxfasa
                : xxfasm
                : xxfasd
                : xxlaps );

        pmfasa = xxfasa;
        pmfasm = xxfasm;
        pmfasd = xxfasd;

       if g1dia1 > 0;

        pmfasa = pbfasa;
        pmfasm = pbfasm;
        pmfasd = pbfasd;

       endif;
       endif;
                         @fecha = %date((*year * 10000) +
                                 (*month * 100)+*day : *iso);

      /end-free
     c                   endif
      *
      *  Cuerpo y asunto de mail por CANCELACIÓN de ODP
      *
     c                   if        PMTIPO = 'C'
      /free

                         Cspr ='AREA' + %editc(PAARTC:'X')
                               +  PMTIPO + 'TERCERO   ';

                         Body = Body_Cancelacion_odp_Tercero;
                         Asunto_Largo= Asunto_Cancelacion_odp_Tercero;
                         Cspr1 ='AREA' + %editc(PAARTC:'X')
                               +  PMTIPO + 'TERCEROMSG';
                         Body1 = Body_Cancelacion_odp_Terceromsg;
       //Obtengo dias de pago

       if not %open(gnttbe);
        open gnttbe;
        k_gnttbe.g1empr = pmempr;
        k_gnttbe.g1sucu = pmsucu;
        k_gnttbe.g1tben = pmmar2;
        chain %kds(k_gnttbe) gnttbe;
       endif;

       if g1dia1 > 0;
        SPFEDIH ( pbfasa
                : pbfasm
                : pbfasd
                : g1dia1
                : 'A'
                : xxfasa
                : xxfasm
                : xxfasd
                : xxlaps );

        pmfasa = xxfasa;
        pmfasm = xxfasm;
        pmfasd = xxfasd;
       endif;

       if g1dia1 > 0;
        pmfasa = pbfasa;
        pmfasm = pbfasm;
        pmfasd = pbfasd;
       endif;
                         @fecha = %date((xxfasa * 10000) +
                                 (xxfasm * 100)+xxfasd: *iso);

      /end-free
     c                   endif
     c                   endsr
      ******************************************************
      * Para el caso de Asegurados.
      ******************************************************
     c     To_Asegura    begsr
     c                   eval      dfnomb = *all' '
     c                   eval      dfnrdf = PMNRMA
     c                   clear                   num
     c     k_gnhdaf      chain     g1hdaf
     c                   if        not %found(gnhdaf)
     c                   eval      Nom_tercero = '**No Informado**'
     c                   else
     c                   eval      Nom_tercero = dfnomb
     c                   endif
     c                   clear                   num

     c
      * busca mail´s de productor
     c                   exsr      productor
      *
      * Busca descripción forma de pago.
     c     k_cntcfp      chain     c1tcfp
     c                   if        not %found(cntcfp)
     c                   eval      fpivdv = 'No determinada'
     c                   endif

     C                   eval      MedPago = *blanks
     C                   select
     C                   When      fpivcv = 1
     C                   eval      MedPago = fpivdv
     C                   When      fpivcv = 1
     C                   eval      MedPago = fpivdv
     C                   When      fpivcv > 10
     C                   eval      MedPago = 'Transferencia Bancaria'
     C                   other
     C                   eval      MedPago = *blanks
     C                   endsl

      *
      *  Cuerpo y asunto de mail.
      *
     c                   if        PMTIPO = 'C'
      /free

                         Cspr ='AREA' + %editc(PAARTC:'X')
                               +  PMTIPO + 'ASEGURADO_' + %trim(b1hecg);

                         Body = Body_Cancelacion_odp_Asegura;
                         Asunto_Largo= Asunto_Cancelacion_odp_Asegura;
                         Cspr1 ='AREA' + %editc(PAARTC:'X')
                               +  PMTIPO + 'ASEGURADOMSG';
                         Body1 = Body_Cancelacion_odp_Aseguramsg;
       //Obtengo dias de pago

       if not %open(gnttbe);
        open gnttbe;
        k_gnttbe.g1empr = pmempr;
        k_gnttbe.g1sucu = pmsucu;
        k_gnttbe.g1tben = pmmar2;
        chain %kds(k_gnttbe) gnttbe;
       endif;

       if g1dia1 > 0;
        SPFEDIH ( pbfasa
                : pbfasm
                : pbfasd
                : g1dia1
                : 'A'
                : xxfasa
                : xxfasm
                : xxfasd
                : xxlaps );

        pmfasa = xxfasa;
        pmfasm = xxfasm;
        pmfasd = xxfasd;
       endif;

       if g1dia1 > 0;
        pmfasa = pbfasa;
        pmfasm = pbfasm;
        pmfasd = pbfasd;
       endif;
                         @fecha = %date((xxfasa * 10000) +
                                 (xxfasm * 100)+xxfasd: *iso);

      /end-free
     c                   endif
     c                   endsr
      ******************************************************
      * Para el caso de pagos de contaduria.
      ******************************************************
     c     To_Otros      begsr
     c                   eval      dfnomb = *all' '
     c                   eval      dfnrdf = *all'0'
     c                   eval      Nom_desti = ' '
      *
      * Si no es terceros, solo proveedores.
      *
     c                   if        not (Pmcoma = '**' or
     c                             Pmcoma = '*1')
     c     k_cntnau      chain     c1tnau
     c                   if        %found(cntnau)
     c                   eval      dfnrdf = NANRDF
     c                   endif
     c                   if        EsTesteo
     c                   except    Dafben
     c                   endif
     c     k_gnhdaf      chain     g1hdaf
     c                   if        not %found(gnhdaf)
     c                   eval      Nom_desti = '**No Informado**'
     c                   else
     c                   eval      Nom_desti = dfnomb
     c                   endif
     c                   clear                   num

      * Busca mail´s tipo administración de destinatario.

          exsr Mail_Beneficia;

      *
      * Busca descripción forma de pago.
     c     k_cntcfp      chain     c1tcfp
     c                   if        not %found(cntcfp)
     c                   eval      fpivdv = 'No determinada'
     c                   endif

      *
      *  Cuerpo y asunto de mail por EMISIÓN de ODP
      *
     c                   if        PMTIPO = 'G'
                         Cspr ='AREA' + %editc(PAARTC:'X')
                               +  PMTIPO + 'CONTADURIA';
                         if @@Mto < 0;
                         Cspr = %trim(Cspr) + '-';
                         Endif;
                         Body = Body_emision_odp_Contaduria;
                         Asunto_Largo= Asunto_Emision_odp_Contaduria;

     c                   endif
      *
      *  Cuerpo y asunto de mail por CANCELACIÓN de ODP
      *
     c                   if        PMTIPO = 'C'

      /free
                         Cspr ='AREA' + %editc(PAARTC:'X')
                               +  PMTIPO + 'CONTADURIA';

                         Adjuntos(01) = %trim('/tmp/' +  %trim(nompgm) +
                                        %char(ahora_num) + '.XLS');

                         if       Graba_Xls(Adjuntos(01));
               //        Nombre_zip =  %trim(%trim(nompgm) +
               //                      %char(ahora_num) + '.ZIP');
                         else;
                         clear    Adjuntos;
                         endif;
                         Body = Body_Cancelacion_odp_Contaduria;
                         b_juic = 'Antes de presentarse a '
                                + 'retirar su pago debera contactarse '
                                + 'y coordinar con su referente de la '
                                + 'Cia. sin excepcion</strong><p><strong>'
                                + '&nbsp;&nbsp;En el presente ';
                         if esJuicio;
                            body = %scanrpl( '</html>'
                                           : b_juic
                                           : body      );
                         endif;
                         Asunto_Largo= Asunto_Cancelacion_odp_Contaduria;

      /end-free
     c                   endif
     c                   endif
     c                   endsr
      ******************************************************
      * Busca mail por numero de daf
      ******************************************************
      /free
         begsr Mail_Beneficia;

          clear @@madd;
          eval pmmai1 = '1';
          rc =   SVPMAIL_xNrDaf( dfnrdf
                               : @@Madd
                               : Tipo_mail_admi);

          for i= 1 to rc;
           if  MAIL_isValid( @@Madd(i).mail );
            num += 1;
            if        num <= 100;
             Destinat_Nomb(num) = @@Madd(i).nomb;
             Destinat_mail(num) = @@Madd(i).mail;
             Destinat_tipo(num) = MAIL_NORMAL;
             eval pmmai1 = '0';
            endif;
           endif;
          endfor;

       endsr;
      /end-free
      ******************************************************
      * Busca mail por nivel/codigo de productor.
      ******************************************************
     c     productor     begsr
      /free
        // llamo srvpgm para que traiga mails

        if  pmmai2 <> '0';

          clear @@madd;
          eval pmmai2 = '1';
          rc =  SVPMAIL_xnivc(pmempr
                            : pmsucu
                            : pmnivt
                            : pmnivc
                            : @@Madd
                            : Tipo_mail_admi);

          for i= 1 to rc;
             if  MAIL_isValid( @@Madd(i).mail );
             num+=1;
             Destinat_Nomb(num) = @@Madd(i).nomb;
             Destinat_mail(num) = @@Madd(i).mail;
             Destinat_tipo(num) = MAIL_NORMAL;
             eval pmmai2 = '0';
             endif;
          endfor;
        endif;
      /end-free
     c                   endsr
      ******************************************************
      * Envío de mail
      ******************************************************
     c     Envio_mail    begsr

      /free
      // Remitente del mail.

       if MAIL_getFrom(nompgm: Cspr: P_Data_from) = 0;
        eval Desde_mail     = %trim(P_Data_from.From);
        eval Desde_direccio = %trim(P_Data_from.Fadr);
       else;
        eval Desde_mail     = 'Avisos HDI';
        eval Desde_direccio = 'AvisosHDI.Siniestros@hdi.com.ar';
       endif;


       rc = MAIL_getReceipt(nompgm: Cspr: gntprp);


        for i= 1 to rc;
         if  MAIL_isValid( gntprp(i).rpmail);
          num += 1;
          if        num <= 100;
           Destinat_Nomb(num) = gntprp(i).rpnomb;
           Destinat_mail(num) = gntprp(i).rpmail;
           if num = 1;
            Destinat_tipo(num) = MAIL_NORMAL;
           else;
            Destinat_tipo(num) = MAIL_CC;
           endif;
          endif;
         endif;
        endfor;
      /end-free
     C                   eval      rtn_sts = MAIL_SndLmail(
     C                                              Desde_mail:
     C                                              Desde_direccio:
     C                                              Asunto:
     C                                              Body:
     C                                              'H':
     C                                              Destinat_Nomb:
     C                                              Destinat_mail:
     C                                              Destinat_tipo:
     c                                              *OMIT:
     c                                              *OMIT:
     c                                              *OMIT:
     c                                              *OMIT:
     C                                              Adjuntos:
     C                                              Borrar_adjunto:
     C                                              Comprimir:
     C                                              Nombre_zip:
     c                                              *OMIT:
     c                                              Asunto_Largo)
     c                   if        EsTesteo
     c*                   except    Enviamail
     c                   endif
      * además del productor ahora se envia a organizador pero en mail
      * separado
      * En este punto se graba archivo GNTMSG -
     c                   exsr      grabmsg
     c                   endsr
      ******************************************************
      /free
        begsr cadena;
        // busca cadena del productor
        clear @@cade;
        clear @@fin;
        clear @@cadf;
        clear @@madd;
        callp  SPCADCOM( pmempr
                       : pmsucu
                       : pmnivt
                       : pmnivc
                       : @@cade
                       : @@err
                       : @@fin
                       : @@cadf);

      /end-free
     c                   if        EsTesteo
     c                   except    CADENAC
     c                   endif
      /free
        // ahora sólo se toma el organizador si <> de productor
        if not @@err and @@cadf(1) <> @@cadf(3);
        pmmai3 = '1';
          rc =  SVPMAIL_xNrDaf( @@cadf(3)
                              : @@Madd
                              : Tipo_mail_admi);


          if rc > *zero;
             num = *zero;
             for i= 1 to rc;
               if  MAIL_isValid( @@Madd(i).mail );
               num+=1;
               Destinat_Nomb(num) = @@Madd(i).nomb;
               Destinat_mail(num) = @@Madd(i).mail;
               Destinat_tipo(num) = MAIL_NORMAL;
               endif;
             endfor;

             exsr Envio_mail;
             if        rtn_sts = 0;
               eval      pmmai3 = '0';
             endif;
          endif;
        endif;

        endsr;
      /end-free
      *-----------------------------------------------
      * Llama a SPCADCOM para cierre de archivos.
      *-----------------------------------------------
     c     Cierres_pgm   Begsr
      /free
        @@fin = 'FIN';
        SPCADCOM( pmempr
                 : pmsucu
                 : pmnivt
                 : pmnivc
                 : @@cade
                 : @@err
                 : @@fin
                 : @@cadf);
        SVPMAIL_End();
      /end-free
     c                   endsr
      **********************************************************************
     c     Envio_tercero begsr

      /free

       pmmai1 = '0';
       nu1    =  0 ;
       clear @@Mad1;
       clear p_data_fro1;
       clear Asunt1;
       clear Bod1;
       clear Destinat_Nom1;
       clear Destinat_Mai1;
       clear Destinat_Tip1;

       if MAIL_getFrom(nompgm: 'AREA60CTERCEROMAIL': P_Data_fro1) = -1;
          leavesr;
       endif;

       rc = SVPMAIL_xNrDaf( pmnrma
                          : @@Mad1
                          : 1      );
       if rc < 1;
          leavesr;
       endif;

       nu1 = 0;
       for i = 1 to rc;
           if MAIL_isValid( @@mad1(i).mail);
              nu1 += 1;
              if nu1 <= 100;
                 Destinat_Nom1(nu1) = @@mad1(i).nomb;
                 Destinat_mai1(nu1) = @@mad1(i).mail;
                 if nu1 = 1;
                    Destinat_tip1(nu1) = MAIL_NORMAL;
                  else;
                    Destinat_tip1(nu1) = MAIL_CC;
                 endif;
              endif;
           endif;
       endfor;

       if MAIL_getSubject(nompgm: 'AREA60CTERCEROMAIL': Asunt1) = -1;
          leavesr;
       endif;

       if MAIL_getBody(nompgm: 'AREA60CTERCEROMAIL': Bod1) = -1;
          leavesr;
       endif;

       Asunt1 = %scanrpl( '%SINI%'
                        : %trim(%char(pmsini))
                        : %trim(Asunt1)       );

       Bod1   = %scanrpl( '%IMAU%'
                        : %trim(%editc(@@Mto:'K'))
                        : %trim(Bod1)         );

       Bod1   = %scanrpl( '%NOMB%'
                        : %trim(dfnomb)
                        : %trim(Bod1)         );

       Bod1   = %scanrpl( '%PACP%'
                        : %trim(%char(papacp))
                        : %trim(Bod1)         );

       Bod1   = %scanrpl( '%IVDV%'
                        : %trim(%char(FPIVDV))
                        : %trim(Bod1)         );

       Bod1   = %scanrpl( '%FPAG%'
                        : %editc(xxfasd:'X')
                        + '/'
                        + %editc(xxfasm:'X')
                        + '/'
                        + %editc(xxfasa:'X')
                        : %trim(Bod1)         );

       rtn_sts = MAIL_SndLmail( %trim(P_Data_fro1.From)
                              : %trim(P_Data_fro1.Fadr)
                              : Asunt1
                              : Bod1
                              : 'H'
                              : Destinat_Nom1
                              : Destinat_mai1
                              : Destinat_tip1   );
       if rtn_sts = 0;
          pmmai1 = '0';
       endif;

      /end-free
     c                   endsr
      **********************************************************************
      * Inicialización.
      **********************************************************************
     c     *inzsr        Begsr
     c     k_cntnau      Klist
     c                   kfld                    PMEMPR
     c                   kfld                    PMSUCU
     c                   kfld                    PMCOMA
     c                   kfld                    PMNRMA
     c     k_gnhdaf      Klist
     c                   kfld                    DFNRDF
     c     k_cntcfp      Klist
     c                   kfld                    PMEMPR
     c                   kfld                    PMSUCU
     c                   kfld                    PMIVCV

     C     K_pahshp01    klist
     C                   kfld                    paempr
     C                   kfld                    pasucu
     C                   kfld                    paartc
     C                   kfld                    papacp
     C                   kfld                    parama

     c     k_set001      Klist
     c                   kfld                    hprama

     c     K_pahsb1      klist
     c                   kfld                    hpempr
     c                   kfld                    hpsucu
     c                   kfld                    hprama
     c                   kfld                    hpsini
     c                   kfld                    hpnops
     c                   kfld                    hppoco
     c                   kfld                    hppaco
     c                   kfld                    hpriec
     c                   kfld                    hpxcob
     c                   kfld                    hpnrdf
     c                   kfld                    hpsebe

     c     k_cntrd1      klist
     c                   kfld                    PMEMPR
     c                   kfld                    PMSUCU
     c                   kfld                    PAARTC
     c                   kfld                    PAPACP
      /free
       if EsTesteo;
       open Qsysprt;
       endif;

       If not %open(SET400);
          open set400;
       endif;

       read s1t400;

       If  %open(SET400);
          Close set400;
       endif;

       Cprc = nompgm;
      /end-free
     c                   endsr
      /free

        begsr grabmsg;
        leavesr;
        if pmnivt <> *zeros and pmnivc <> *zeros;
        @1msid = @@msid;
        K_gntmsg.sgempr = pmempr;
        K_gntmsg.sgsucu = pmsucu;
        K_gntmsg.sgnivt = pmnivt;
        K_gntmsg.sgnivc = pmnivc;
        K_gntmsg.sgmsid = @1msid;
        chain %kds(K_gntmsg) g1tmsg;
        if not %found(gntmsg);
        sgempr = pmempr;
        sgsucu = pmsucu;
        sgnivt = pmnivt;
        sgnivc = pmnivc;
        sgmsid = @1msid;
        sgbody = body1;
        sgfmsg = @fecha;
        sgimpo = 0;
        sgread = '0';
        sgmar1 = '0';
        sgmar2 = '0';
        sgmar3 = '0';
        sgmar4 = '0';
        sgmar5 = '0';
        sgmar6 = '0';
        sgmar7 = '0';
        sgmar8 = '0';
        sgmar9 = '0';
00015   sgmar0 = '0';
00015   sguser = nomusr;
00015   sgdate = (*year*10000)+(*month*100)+*day;
        sgtime = %dec(%time():*iso);
00018   //write g1tmsg;
        //else;
        //@1msid = @@msid;
        //sgmsid = @1msid;
00018   //write g1tmsg;
99999   endif;
        endif;

99999   if @1cadf3 <> pmnivc and @1cadf3 <> *zeros;
        @1msid = @@msid;
        K_gntmsg.sgempr = pmempr;
        K_gntmsg.sgsucu = pmsucu;
        K_gntmsg.sgnivt = pmnivt;
        K_gntmsg.sgnivc = pmnivc;
        K_gntmsg.sgmsid = @1msid;
        chain %kds(K_gntmsg) g1tmsg;
        if not %found(gntmsg);
00015   sgempr = pmempr;
00015   sgsucu = pmsucu;
00015   sgnivt = 3;
00015   sgnivc = @1cadf3;
00015   sgmsid = @1msid;
00015   sgbody = body1;
00015   sgfmsg = @fecha;
00015   sgimpo = 0;
00015   sgread = '0';
00015   sgmar1 = '0';
00015   sgmar2 = '0';
00015   sgmar3 = '0';
00015   sgmar4 = '0';
00015   sgmar5 = '0';
00015   sgmar6 = '0';
00015   sgmar7 = '0';
00015   sgmar8 = '0';
00015   sgmar9 = '0';
00015   sgmar0 = '0';
00015   sguser = nomusr;
00015   sgdate = (*year*10000)+(*month*100)+*day;
        sgtime = %dec(%time():*iso);
00018   //write g1tmsg;
        //else;
        //@1msid = @@msid;
00015   //sgmsid = @1msid;
00018   //write g1tmsg;
        endif;
        endif;
00015   @1cadf3=*zeros;
        endsr;
      /end-free
     oqsysprt   E            NRODEOP     1  1
     o                                           27 '--------------------------'
     oqsysprt   E            NRODEOP        1
     o                                           10 'Nro de Op:'
     o                       PMARTC              15
     o                       PMPACP              22
     o                                           35 'MAR2     :'
     o                       PMMAR2              37
     o                                           48 'Cod Mayor:'
     o                       PMCOMA              52
     o                                           64 'Tipo:'
     o                       PMTIPO              65
     oqsysprt   E            SiniZon        1
     o                                           10 'ZONA     :'
     o                       INTIPD              18
     o                                           30 'Productor:'
     o                       PMNIVT              35
     o                       PMNIVC              42
     o                                           55 'Siniestro:'
     o                       PMSINI              65
     oqsysprt   E            Dafben         1
     o                                           10 'Beneficia:'
     o                       dfnrdf              20
     oqsysprt   E            Dafase         1
     o                                           10 'Asegurado:'
     o                       c1asen              20
     oqsysprt   E            Cadenac        1
     o                                           10 'Productor:'
     o                       @@cadf(1)           20
     o                                           40 'Organizad:'
     o                       @@cadf(3)           50
     o                                           60 'Error:'
     o                       @@err               70
     oqsysprt   E            Enviamail      1
     o                                           11 'Envio Mail:'
     o                       rtn_sts             20
      **********************************************************************
      *
      * Procedimientos.
      *
      **********************************************************************
      * Determina si es Proveedor
      **********************************************************************
     P es_proveedor    b

     D es_proveedor    pi                  like(*in01)

     c                   if        pmcoma >= '80' and pmcoma <= '89'
     c                             and pmmar2 <> '2' and pmmar2 <> '1'
     c                   eval      *in70 = *on
     c                   else
     c                   eval      *in70 = *off
     c                   endif
     C                   return    *in70

     P es_proveedor    e
      **********************************************************************
      * Determina si es un tercero
      **********************************************************************
     P es_tercero      b

     D es_tercero      pi                  like(*in01)

     C                   if        Pmmar2 = '2'
     c                   eval      *in70 = *on
     c                   else
     c                   eval      *in70 = *off
     c                   endif
     C                   return    *in70

     P es_tercero      e
      **********************************************************************
      * Determina si es un Asegurado
      **********************************************************************
     P es_asegurado    b

     D es_asegurado    pi                  like(*in01)

     C                   if        Pmmar2 = '1'
     c                   eval      *in70 = *on
     c                   else
     c                   eval      *in70 = *off
     c                   endif

     C                   return    *in70

     P es_asegurado    e
      **********************************************************************
      * Determina si el productor es o no de una zona en la que correspon
      *da enviar mail a partir de la lista de zonas excluidas de ese trata
      *miento. Solo se enviará mail cuando el productor es del interior.
      **********************************************************************
     P fun_es_zona_excluida...
     P                 b
     D fun_es_zona_excluida...
     D                 pi                  like(*in01)
     C                   if        %lookup(zona_productor(PMEMPR:
     C                                                    PMSUCU:
     C                                                    PMNIVT:
     C                                                    PMNIVC):
     C                                     zonas_excluida) > 0
     c                   eval      *in70 = *on
     c                   else
     c                   eval      *in70 = *off
     c                   endif
     C                   return    *in70
     P fun_es_zona_excluida...
     P                 e
      **********************************************************************
      * Determina zona del productor.
      **********************************************************************
     P zona_productor...
     P                 b
     D zona_productor...
     D                 pi                  like(INTIPD)
     D P_EMPR                              like(C1EMPR) const
     D P_SUCU                              like(C1SUCU) const
     D PMNIVT                              like(C1NIVT)
     D PMNIVC                              like(C1NIVC)
     c                   callp     Obtiene_productor(PMEMPR:PMSUCU:
     c                                               PMRAMA:PMSINI:
     c                                               PMNOPS:PMNIVT:
     c                                               PMNIVC)
     c     k_SAHINT      klist
     c                   kfld                    PMEMPR
     c                   kfld                    PMSUCU
     c                   kfld                    PMNIVT
     c                   kfld                    PMNIVC
     C     k_SAHINT      chain     s2hint
     C                   if        not %found
     c                   eval      INTIPD = *all'9'
     c                   endif
     c                   if        EsTesteo
     c                   except    SiniZon
     c                   endif
     C                   return    INTIPD
     p zona_productor...
     P                 e
      **********************************************************************
      * Obtiene el productor y asegurado.
      **********************************************************************
     P Obtiene_productor...
     P                 b
     D Obtiene_productor...
     D                 pi
     D P_EMPR                              like(PMEMPR) const
     D P_SUCU                              like(PMSUCU) const
     D P_RAMA                              like(PMRAMA) const
     D P_SINI                              like(PMSINI) const
     D P_NOPS                              like(PMNOPS) const
     D P_NIVT                              like(C1NIVT)
     D P_NIVC                              like(C1NIVC)
     c                   clear                   P_NIVT
     c                   clear                   P_NIVC
     C     k_PAHSCD      klist
     C                   kfld                    P_empr
     C                   kfld                    P_sucu
     C                   kfld                    P_rama
     C                   kfld                    P_sini
     C                   kfld                    P_nops
     C     k_pahscd      chain     p1hscd
     C                   if        %found(pahscd)
     C     k_PAHEC1      klist
     C                   kfld                    cdempr
     C                   kfld                    cdsucu
     C                   kfld                    cdarcd
     C                   kfld                    cdspol
     C                   kfld                    cdsspo
     C     k_pahec1      chain     p1hec1
     C                   if        %found(pahec1)
     c                   eval      P_NIVT =  c1nivt
     c                   eval      P_NIVC =  c1nivc
     c                   if        EsTesteo
     c                   except    Dafase
     c                   endif
     c     c1asen        chain     g1hdaf
     c                   if        %found(gnhdaf)
     c                   eval      Nom_asegura = dfnomb
     c                   endif
     c                   endif
     c                   endif
     C                   return

     P Obtiene_productor...
     P                 e
      **********************************************************************
      * Proc de Armado del Cuerpo del Mail.
      **********************************************************************

      ******************************************************
      *  Emisión de ODP a Proveedores de Siniestros.
      ******************************************************

     P Body_Emision_odp_Prov_Sinie...
     P                 b

     D Body_Emision_odp_Prov_Sinie...
     D                 pi          5000a

     D Body            s           5000a

       OK = MAIL_getLBody(Cprc:Cspr:Body);
       Reemplazo_de_variables(body);

       return body;
     P Body_Emision_odp_Prov_Sinie...
     P                 e
      ******************************************************
      *  Emisión de ODP a Proveedores de Siniestros GNTMSG
      ******************************************************

     P Body_Emision_odp_Prov_Siniemsg...
     P                 b

     D Body_Emision_odp_Prov_Siniemsg...
     D                 pi           512a

     D body1           s            512a   varying

       OK1 = MAIL_getBody(Cprc:Cspr1:Body1);
       Reemplazo_de_variables_msg(body1);

       return body1;
     P Body_Emision_odp_Prov_Siniemsg...
     P                 e


     P Asunto_Emision_odp_Prov_Sinie...
     P                 b
     D Asunto_Emision_odp_Prov_Sinie...
     D                 pi           270a   varying

     D Asunto_Largo    s            270a   varying
     D Asunto_breve    s             70a   varying

       OK = MAIL_getSubject(Cprc:Cspr:Asunto_breve);

       Asunto_Largo = %trim(Asunto_breve) + ': '                   +
                      %trim(%editc(pmsini:'2')) + ' importe: '     +
                      %trim(@@mone)                                +
                      %trim(%editw(@@mto: ' .   .   .   . 0 ,  ')) +
                      ' Beneficiario: '                            +
                      %trim(Nom_desti);


       return Asunto_Largo;
     P Asunto_Emision_odp_Prov_Sinie...
     P                 e
      ******************************************************
      *  Cancelación de ODP a Proveedores de Siniestros.
      ******************************************************

     P Body_Cancelacion_odp_Prov_Sinie...
     P                 b

     D Body_Cancelacion_odp_Prov_Sinie...
     D                 pi          5000a

     D Body            s           5000a

       OK = MAIL_getLBody(Cprc:Cspr:Body);
       Reemplazo_de_variables(Body);



         return body;
     P Body_Cancelacion_odp_Prov_Sinie...
     P                 e

      *********************************************************
      *  Cancelación de ODP a Proveedores de Siniestros GNTMSG
      *********************************************************

     P Body_Cancelacion_odp_Prov_Siniemsg...
     P                 b

     D Body_Cancelacion_odp_Prov_Siniemsg...
     D                 pi           512a

     D body1           s            512a   varying

       OK1 = MAIL_getBody(Cprc:Cspr1:body1);
       Reemplazo_de_variables_msg(body1);



         return body1;
     P Body_Cancelacion_odp_Prov_Siniemsg...
     P                 e


     P Asunto_Cancelacion_odp_Prov_Sinie...
     P                 b
     D Asunto_Cancelacion_odp_Prov_Sinie...
     D                 pi           270a   varying

     D Asunto_Largo    s            270a   varying
     D Asunto_breve    s             70a   varying

       OK = MAIL_getSubject(Cprc:Cspr:Asunto_breve);

       Asunto_Largo = %trim(Asunto_breve) + ': ' +
                      %trim(%editc(pmsini:'2')) + ' Beneficiario: ' +
                      %trim(Nom_desti);


       return Asunto_Largo;
     P Asunto_Cancelacion_odp_Prov_Sinie...
     P                 e

      ******************************************************
      *  Emisión de ODP a Tercero.
      ******************************************************
     P Body_emision_odp_Tercero...
     P                 b

     D Body_emision_odp_Tercero...
     D                 pi          5000a

     D Body            s           5000a

       OK = MAIL_getLBody(Cprc:Cspr:Body);
       Reemplazo_de_variables(Body);



       return body;
     P Body_emision_odp_Tercero...
     P                 e
      ******************************************************
      *  Emisión de ODP a Tercero GNTMSG
      ******************************************************
     P Body_emision_odp_Terceromsg...
     P                 b

     D Body_emision_odp_Terceromsg...
     D                 pi           512a

     D Body1           s            512a   varying

       OK1 = MAIL_getBody(Cprc:Cspr1:Body1);
       Reemplazo_de_variables_msg(Body1);



       return body1;
     P Body_emision_odp_Terceromsg...
     P                 e
      ******************************************************


     P Asunto_Emision_odp_Tercero...
     P                 b
     D Asunto_Emision_odp_Tercero...
     D                 pi           270a   varying

     D Asunto_Largo    s            270a   varying
     D Asunto_breve    s             70a   varying

       OK = MAIL_getSubject(Cprc:Cspr:Asunto_breve);

       Asunto_Largo = %trim(Asunto_breve) + ': ' +
                      %trim(%editc(pmsini:'2')) + ' Beneficiario: ' +
                      %trim(Nom_tercero);
       return Asunto_Largo;
     P Asunto_Emision_odp_Tercero...
     P                 e

      ******************************************************
      *  Cancelacion de ODP a Tercero.
      ******************************************************
     P Body_Cancelacion_odp_Tercero...
     P                 b

     D Body_Cancelacion_odp_Tercero...
     D                 pi          5000a

     D Body            s           5000a

       OK = MAIL_getLBody(Cprc:Cspr:Body);
       Reemplazo_de_variables(Body);


       return body;
     P Body_Cancelacion_odp_Tercero...
     P                 e
erc   ******************************************************
erc   *  Cancelacion_odp_Tesoreria
erc   ******************************************************
erc  P Body_Cancelacion_odp_Tesoreria...
erc  P                 b
erc
erc  D Body_Cancelacion_odp_Tesoreria...
erc  D                 pi          5000a
erc
erc  D Body            s           5000a
erc
erc    OK = MAIL_getLBody(Cprc:Cspr:Body);
erc
erc    return body;
erc  P Body_Cancelacion_odp_Tesoreria...
erc  P                 e
      ******************************************************
      *  Cancelacion de ODP a Tercero GNTMSG
      ******************************************************
     P Body_Cancelacion_odp_Terceromsg...
     P                 b

     D Body_Cancelacion_odp_Terceromsg...
     D                 pi           512a

     D Body1           s            512a   varying

       OK1 = MAIL_getBody(Cprc:Cspr1:Body1);
       Reemplazo_de_variables_msg(Body1);

       return body1;
     P Body_Cancelacion_odp_Terceromsg...
     P                 e


     P Asunto_Cancelacion_odp_Tercero...
     P                 b
     D Asunto_Cancelacion_odp_Tercero...
     D                 pi           270a   varying

     D Asunto_Largo    s            270a   varying
     D Asunto_breve    s             70a   varying

       OK = MAIL_getSubject(Cprc:Cspr:Asunto_breve);

       Asunto_Largo = %trim(Asunto_breve) + ': ' +
                      %trim(%editc(pmsini:'2')) + ' Beneficiario: ' +
                      %trim(Nom_tercero);
       return Asunto_Largo;
     P Asunto_Cancelacion_odp_Tercero...
     P                 e

      ******************************************************
      *  Armado de Id de mensaje para grabar en GNTMSG
      ******************************************************
     P @@msid          b
     D @@msid          pi            25a
     D @@msid          s             25a
     D x               s              2s 0

       for x = 1 to 25;
          random( seed
                : Floater
                : *omit);
          %subst(ran:x:1) = %subst(ALFABETO:%Int(floater*26+1):1);
       endfor;
       return ran;

     P @@msid          e
      ******************************************************
      *  Cancelacion de ODP a Asegurado.
      ******************************************************
     P Body_Cancelacion_odp_Asegura...
     P                 b

     D Body_Cancelacion_odp_Asegura...
     D                 pi          5000a

     D Body            s           5000a
     D xxlaps          s              5  0
     D xxfasd          s              2  0
     D xxfasm          s              2  0
     D xxfasa          s              4  0

       OK = MAIL_getLBody(Cprc:Cspr:Body);
       //Obtengo dias de pago

       if not %open(gnttbe);
        open gnttbe;
        k_gnttbe.g1empr = pmempr;
        k_gnttbe.g1sucu = pmsucu;
        k_gnttbe.g1tben = pmmar2;
        chain %kds(k_gnttbe) gnttbe;
       endif;

       if g1dia1 > 0;
        SPFEDIH ( pbfasa
                : pbfasm
                : pbfasd
                : g1dia1
                : 'A'
                : xxfasa
                : xxfasm
                : xxfasd
                : xxlaps );

        pmfasa = xxfasa;
        pmfasm = xxfasm;
        pmfasd = xxfasd;

       endif;

       Reemplazo_de_variables(Body);

       if g1dia1 > 0;

        pmfasa = pbfasa;
        pmfasm = pbfasm;
        pmfasd = pbfasd;

       endif;


       return body;
     P Body_Cancelacion_odp_Asegura...
     P                 e
      ******************************************************
      *  Cancelacion de ODP a Asegurado GNTMSG
      ******************************************************
     P Body_Cancelacion_odp_Aseguramsg...
     P                 b

     D Body_Cancelacion_odp_Aseguramsg...
     D                 pi           512a

     D Body1           s            512a     varying

       OK1 = MAIL_getBody(Cprc:Cspr1:Body1);
       Reemplazo_de_variables_msg(Body1);

       return body1;
     P Body_Cancelacion_odp_Aseguramsg...
     P                 e


     P Asunto_Cancelacion_odp_Asegura...
     P                 b
     D Asunto_Cancelacion_odp_Asegura...
     D                 pi           270a   varying

     D Asunto_Largo    s            270a   varying
     D Asunto_breve    s             70a   varying

       OK = MAIL_getSubject(Cprc:Cspr:Asunto_breve);

       Asunto_Largo = %trim(Asunto_breve) + ' al Asegurado: ' +
                      %trim(Nom_tercero) + ' Siniestro: ' +
                      %trim(%editc(pmsini:'2'));
       return Asunto_Largo;
     P Asunto_Cancelacion_odp_Asegura...
     P                 e

      ******************************************************
      *  Emisión de ODP a Otros pagos.
      ******************************************************
     P Body_emision_odp_Contaduria...
     P                 b

     D Body_emision_odp_Contaduria...
     D                 pi          5000a

     D Body            s           5000a

       OK = MAIL_getLBody(Cprc:Cspr:Body);
       Reemplazo_de_variables(Body);

        return body;
     P Body_emision_odp_Contaduria...
     P                 e


     P Asunto_emision_odp_Contaduria...
     P                 b
     D Asunto_emision_odp_Contaduria...
     D                 pi           270a   varying

     D Asunto_Largo    s            270a   varying
     D Asunto_breve    s             70a   varying

       OK = MAIL_getSubject(Cprc:Cspr:Asunto_breve);


       if @@Mto >= 0;
       Asunto_Largo = %trim(Asunto_breve) + ' ' + %trim(Nom_desti);
       else;
       Asunto_Largo = %trim(Asunto_breve) + ': '+  %trim(Nom_desti);
       endif;

       return Asunto_Largo;
     P Asunto_emision_odp_Contaduria...
     P                 e
      ******************************************************
      *  Cancelación de ODP a Otros pagos.
      ******************************************************

     P Body_Cancelacion_odp_Contaduria...
     P                 b

     D Body_Cancelacion_odp_Contaduria...
     D                 pi          5000a

     D Body            s           5000a

       OK = MAIL_getLBody(Cprc:Cspr:Body);
       Reemplazo_de_variables(Body);


       return body;
     P Body_Cancelacion_odp_Contaduria...
     P                 e


     P Asunto_Cancelacion_odp_Contaduria...
     P                 b
     D Asunto_Cancelacion_odp_Contaduria...
     D                 pi           270a   varying

     D Asunto_Largo    s            270a   varying
     D Asunto_breve    s             70a   varying

       OK = MAIL_getSubject(Cprc:Cspr:Asunto_breve);

       If @@Mto >= 0;
       Asunto_Largo = %trim(Asunto_breve) + ' ' +
                       %trim(Nom_desti);
       else;
       Asunto_Largo = %trim(Asunto_breve) + ': '
                      + %trim(Nom_desti);
       endif;

       return Asunto_Largo;
     P Asunto_Cancelacion_odp_Contaduria...
     P                 e


erc  P Asunto_Cancelacion_odp_Tesoreria...
erc  P                 b
erc  D Asunto_Cancelacion_odp_Tesoreria...
erc  D                 pi           270a   varying

erc  D Asunto_Largo    s            270a   varying
erc  D Asunto_breve    s             70a   varying

erc    OK = MAIL_getSubject(Cprc:Cspr:Asunto_breve);

erc    Asunto_Largo = %trim(Asunto_breve) + ' ' + '-' +
erc                   ' Rama: '     +  %trim($rama$) +
erc                   ',' +
                      ' poliza: '   +  %trim(%editc($poli$: 'X')) +
erc                   ',' +
                      ' Siniestro: '+  %trim(%editc($sini$: 'X')) +
erc                   ',' +
                      ' Asegurado: '+  %trim($aseg$) +
erc                   ',' +
                      ' fecha de siniestro:' +
                         %char(CDFSID) + '/'+ %char(CDFSIM)+ '/' +
                         %char(CDFSIA);

erc    return Asunto_Largo;
erc  P Asunto_Cancelacion_odp_Tesoreria...
     P                 e

      ******************************************************
      *  Reemplazo de variables.
      ******************************************************

     P Reemplazo_de_variables...
     P                 b

     D Reemplazo_de_variables...
     D                 pi
     D Body                        5000a


       body = %SCANRPL('%DIA%':
                       (%char(PMFASD) + '/'+ %char(PMFASM)+ '/' +
                        %char(PMFASA)):
                       body );
       body = %SCANRPL('%NUMODP%':%trim(%editc(PAARTC:'2')) + '-' +
                       %trim(%editc(PAPACP:'2')):body );

       body = %SCANRPL('%NUMFAC%':%trim(%subst(PMCOPT:4:13)):body );

       body = %SCANRPL('%IMPORTE%':%trim(@@Mone) +
                      %trim(%editw(@@mto: ' .   .   .   . 0 ,  ')):body );

       body = %SCANRPL('%FORM%':%trim(fpivdv):body );

       body = %SCANRPL('%NOMBENE%':%trim(Nom_tercero):body );

       body = %SCANRPL('%ASEGU%':%trim(Nom_asegura):body );

       body = %SCANRPL('%NROPOL%':%trim(%editc(CDPOLI:'K')):body );

       body = %SCANRPL('%RAMA%':%trim(%editc(CDRAMA:'X')):body );

       body = %SCANRPL('%NROSINI%':%trim(%editc(CDSINI:'K')):body );

       body = %SCANRPL('%MEDPAGO%':%trim(MedPago):body );


       return;
     P Reemplazo_de_variables...
     P                 e
      ******************************************************
      *  Reemplazo de variables para GNTMSG
      ******************************************************

     P Reemplazo_de_variables_msg...
     P                 b

     D Reemplazo_de_variables_msg...
     D                 pi
     D body1                        512a   varying


       body1 = %SCANRPL('%DIA%':
                       (%char(PMFASD) + '/'+ %char(PMFASM)+ '/' +
                        %char(PMFASA)):
                       body1 );
       body1 = %SCANRPL('%NUMODP%':%trim(%editc(PAARTC:'2')) + '-' +
                       %trim(%editc(PAPACP:'2')):body1 );

       body1 = %SCANRPL('%NUMFAC%':%trim(%subst(PMCOPT:4:13)):body1 );

       body1 = %SCANRPL('%IMPORTE%': %trim(%editc(@@Mto:'K')):body1 );

       body1 = %SCANRPL('%FORM%':%trim(fpivdv):body1 );

       body1 = %SCANRPL('%NOMBENE%':%trim(Nom_tercero):body1 );

       body1 = %SCANRPL('%ASEGU%':%trim(Nom_asegura):body1 );

       body1 = %SCANRPL('%NROPOL%':%trim(%editc(CDPOLI:'K')):body1 );

       body1 = %SCANRPL('%RAMA%':%trim(%editc(CDRAMA:'X')):body1 );

       body1 = %SCANRPL('%NROSINI%':%trim(%editc(CDSINI:'K')):body1 );


       return;
     P Reemplazo_de_variables_msg...
     P                 e
      *
      *------------------------------------------------------------------
      *
      *
      * Graba Excel para enviar.
      *
      *------------------------------------------------------------------
      *

     P Graba_Xls       B
     D Graba_Xls       pi              n
     D To_xls                       255

      /include hdiile/qcpybooks,hssf_h

      * Variables Excel
     D book            s                   like(SSWorkbook)
     D TitColumn       s                   like(SSCellStyle)
     D CellNumer       s                   like(SSCellStyle)
     D CellNu152       s                   like(SSCellStyle)
     D CellTexto       s                   like(SSCellStyle)
     D CellDates       s                   like(SSCellStyle)
     D Sheet           s                   like(SSSheet)
     D row             s                   like(SSRow)
     D rowcount        s             10i 0
     D TitColFont      s                   like(SSFont)
     D TempStr         s                   like(jString)
     D DataFmt         s                   like(SSDataFormat)
     D NumFmt          s              5i 0
     D DateFmt         s              5i 0
     D xls_Ok          s               n
     D K_cnhopa31      ds                  likerec(c1hopa31:*key)
     D K_cnhret99      ds                  likerec(c1hret:*key)
     D K_gnttfc        ds                  likerec(g1ttfc:*key)
     D K_cnhasi        ds                  likerec(c1hasi:*key)
     D K_cntcge        ds                  likerec(c1tcge:*key)
     D K_cnwnin05      ds                  likerec(c1wnin05:*key)
     D Imp_Neto        s             15  2
     D Imp_Iva         s             15  2
     D Imp_RetIVA      s             15  2
     D Imp_RetGAN      s             15  2
     D Imp_RetIIBB     s             15  2
     D Imp_RetSUSS     s             15  2
     D Imp_RetOSEG     s             15  2
     D Imp_RetOtros    s             15  2
     D Imp_Neto_tot    s             15  2
     D Imp_signo       s              1  0
     D Ok_cnhasi       s               n

       if not %open(cnhopa31);
       open cnhopa31;
       endif;

       K_cnhopa31.PAEMPR = PMEMPR;
       K_cnhopa31.PASUCU = PMSUCU;
       K_cnhopa31.PBTICO = PMARTC;
       K_cnhopa31.PBNRAS = PMPACP;
       K_cnhopa31.PRCOMA = PMCOMA;
       K_cnhopa31.PRNRMA = PMNRMA;
       K_cnhopa31.PBFASA = PMFASA;
       K_cnhopa31.PBFASM = PMFASM;
       K_cnhopa31.PBFASD = PMFASD;
       setll %kds(K_cnhopa31:9) c1hopa31;
       reade %kds(K_cnhopa31:9) c1hopa31;

      // Si hay registros inicializa el excel.

       if not %eof(CNHOPA31);
      //

      // Inicializa excel

       if AddCPathHecho <> *on;
       AddCPath();
       AddCPathHecho = *on;
       endif;

       ss_begin_object_group(100);
       book = new_HSSFWorkbook();

      // Define tipos de celdas.

        TitColumn  = SSWorkbook_createCellStyle(book);
        TitColFont = SSWorkbook_createFont(book);
        SSFont_setBoldweight(TitColFont: BOLDWEIGHT_BOLD);
        SSCellStyle_setFont(TitColumn: TitColFont);

        CellNumer = SSWorkbook_createCellStyle(book);
          DataFmt = SSWorkbook_createDataFormat(book);
          TempStr = new_String('#,##0');
          NumFmt  = SSDataFormat_getFormat(DataFmt: TempStr);
        SSCellStyle_setDataFormat(CellNumer: NumFmt);
        SSCellStyle_setAlignment(CellNumer: ALIGN_RIGHT);

        CellTexto = SSWorkbook_createCellStyle(book);
        SSCellStyle_setAlignment(CellTexto: ALIGN_LEFT);

        CellNu152 = SSWorkbook_createCellStyle(book);
          DataFmt = SSWorkbook_createDataFormat(book);
          TempStr = new_String('#,##0.00');
          NumFmt  = SSDataFormat_getFormat(DataFmt: TempStr);
        SSCellStyle_setDataFormat(CellNu152: NumFmt);
        SSCellStyle_setAlignment(CellNu152: ALIGN_RIGHT);

        CellDates = SSWorkbook_createCellStyle(book);
          DataFmt = SSWorkbook_createDataFormat(book);
          TempStr = new_String('dd/mm/yyyy');
          DateFmt = SSDataFormat_getFormat(DataFmt: TempStr);
        SSCellStyle_setDataFormat(CellDates: DateFmt);

      // define Hoja.

       Sheet = SS_newSheet(book: 'Hoja1');

      // Define ancho de columnas

        SSSheet_setColumnWidth( sheet: 00:  11 * 608 );
        SSSheet_setColumnWidth( sheet: 01:  11 * 256 );
        SSSheet_setColumnWidth( sheet: 02:  11 * 256 );
        SSSheet_setColumnWidth( sheet: 03:  11 * 256 );
        SSSheet_setColumnWidth( sheet: 04:  11 * 256 );
        SSSheet_setColumnWidth( sheet: 05:  11 * 256 );
        SSSheet_setColumnWidth( sheet: 06:  11 * 256 );
        SSSheet_setColumnWidth( sheet: 07:  11 * 256 );
        SSSheet_setColumnWidth( sheet: 08:  11 * 256 );
        SSSheet_setColumnWidth( sheet: 09:  11 * 256 );
        SSSheet_setColumnWidth( sheet: 10:  11 * 256 );

        if @@CodMo <> '00' and @@CodMo <> '01';
          SSSheet_setColumnWidth( sheet: 11:  11 * 256 );
          SSSheet_setColumnWidth( sheet: 12:  11 * 256 );
        endif;

       // Define Cabeceras de columnas.

        row = SSSheet_createRow(sheet: rowcount);
        ss_text( row: 00 : 'Concepto'                          : TitColumn);
        ss_text( row: 01 : 'Nro. O. Pago'                      : TitColumn);
        ss_text( row: 02 : 'Importe en Pesos'                  : TitColumn);
        ss_text( row: 03 : 'IVA'                               : TitColumn);
        ss_text( row: 04 : 'Ret.IVA'                           : TitColumn);
        ss_text( row: 05 : 'Ret.Ing.Btos.'                     : TitColumn);
        ss_text( row: 06 : 'Ret.Gcias.'                        : TitColumn);
        ss_text( row: 07 : 'Ret.SUSS'                          : TitColumn);
        ss_text( row: 08 : 'Ret.Osseg'                         : TitColumn);
        ss_text( row: 09 : 'Otras Ret'                         : TitColumn);
        ss_text( row: 10 : 'Imp. Pagado'                       : TitColumn);

        if @@CodMo <> '00' and @@CodMo <> '01';
        ss_text( row: 11 : 'Importe en Moneda Extrajera'       : TitColumn);
        ss_text( row: 12 : 'Moneda'                            : TitColumn);
        endif;


      // Ciclo de grabación.

       Imp_Neto_tot = 0;

       dow not %eof(cnhopa31);

        Imp_Neto     = 0;
        Imp_Iva      = 0;
        Imp_RetIVA   = 0;
        Imp_RetGAN   = 0;
        Imp_RetIIBB  = 0;
        Imp_RetSUSS  = 0;
        Imp_RetOSEG  = 0;
        Imp_RetOtros = 0;
        Imp_Neto_tot = Imp_Neto_tot + Pbimau;
        Ok_cnhasi    = *off;

        if %subst(pdcopt:1:2) >= '00' and %subst(pdcopt:1:2) <= '99';

         // Busca el importe neto y el iva en el asiento.

         if not %open(gnttfc);
          open gnttfc;
         endif;

         K_gnttfc.gntifa = %dec(%subst(pdcopt:1:2):2:0);
         chain %kds(K_gnttfc) g1ttfc;
         If  %found(gnttfc) and gndeha = 'D';
          Imp_signo = 1;
         else;
          Imp_signo = 2;
         endif;

         // Busca en CNHASI


         if not %open(cnhasi);
          open cnhasi;
         endif;

         K_cnhasi.ASEMPR = PAEMPR;
         K_cnhasi.ASSUCU = PASUCU;
         K_cnhasi.ASFASA = PAFASA;
         K_cnhasi.ASFASM = PAFASM;
         K_cnhasi.ASFASD = PAFASD;
         K_cnhasi.ASLIBR = PALIBR;
         K_cnhasi.ASTICO = PAARTC;
         K_cnhasi.ASNRAS = PAPACP;
         K_cnhasi.ASCOMO = PACOMO;
         setll %kds(K_cnhasi:9) c1hasi;
         reade %kds(K_cnhasi:9) c1hasi;
         dow not %eof(cnhasi);
          Ok_cnhasi    = *on;
          if Imp_signo = ASDEHA;
           K_cntcge.CGEMPR = PAEMPR;
           K_cntcge.CGSUCU = PASUCU;
           K_cntcge.CGNRCM = ASNRCM;

           if not %open(cntcge);
            open cntcge;
           endif;

           chain %kds(K_cntcge) c1tcge;
           if %found(cntcge) and CGCRFI = 'S';
            eval Imp_Iva = Imp_Iva + ASIMAU;
           else;
            eval Imp_Neto = Imp_Neto + ASIMAU;
           endif;
          endif;
         reade %kds(K_cnhasi:9) c1hasi;
         enddo;

         // Si no está en CNHASI lo busca en el CNWNIN

         if Ok_cnhasi = *off;
          if not %open(cnwnin05);
           open cnwnin05;
          endif;

          K_cnwnin05.NIEMPR = PAEMPR;
          K_cnwnin05.NISUC2 = PASUCU;
          K_cnwnin05.NIFASA = PAFASA;
          K_cnwnin05.NIFASM = PAFASM;
          K_cnwnin05.NILIBR = PALIBR;
          K_cnwnin05.NINRAS = PAPACP;
          K_cnwnin05.NIFASD = PAFASD;
          K_cnwnin05.NITIC2 = PAARTC;
          K_cnwnin05.NICOMO = PACOMO;
          setll %kds(K_cnwnin05:9) c1wnin05;
          reade %kds(K_cnwnin05:9) c1wnin05;
          dow not %eof(cnwnin05);
           if Imp_signo = NIDEHA;
            K_cntcge.CGEMPR = PAEMPR;
            K_cntcge.CGSUCU = PASUCU;
            K_cntcge.CGNRCM = NINRCM;

            if not %open(cntcge);
             open cntcge;
            endif;

            chain %kds(K_cntcge) c1tcge;
            if %found(cntcge) and CGCRFI = 'S';
             eval Imp_Iva = Imp_Iva + NIIMAU;
            else;
             eval Imp_Neto = Imp_Neto + NIIMAU;
            endif;
           endif;
          reade %kds(K_cnwnin05:9) c1wnin05;
          enddo;
         endif;
         // Busca si tuvo retenciones.

         if not %open(cnhret99);
          open cnhret99;
         endif;

         K_cnhret99.RTEMPR = PMEMPR;
         K_cnhret99.RTSUCU = PMSUCU;
         K_cnhret99.RTTICO = PATICO;
         K_cnhret99.RTNRAS = PANRAS;
         setll %kds(K_cnhret99:4) c1hret;
         reade %kds(K_cnhret99:4) c1hret;
         dow not %eof(cnhret99);
          Select;
          when RTTIIC = 'RIV' or  RTTIIC = 'RI2' or RTTIIC = 'RI3';
           Imp_RetIVA   = Imp_RetIVA + RTIRAU;
          when RTTIIC = 'IGA';
           Imp_RetGan   = Imp_RetGan + RTIRAU;
          when RTTIIC = 'IBC' or  RTTIIC = 'IBR';
           Imp_RetIIBB  = Imp_RetIIBB +  RTIRAU;
          when RTTIIC = 'EMP';
           Imp_RetSUSS  = Imp_RetSUSS +  RTIRAU;
          when RTTIIC = 'SSS';
           Imp_RetOSEG  = Imp_RetOSEG +  RTIRAU;
          other;
           Imp_RetOtros = Imp_RetOtros + RTIRAU;
          endsl;
         reade %kds(K_cnhret99:4) c1hret;
         enddo;

        // Da vuelta importes del comprobante si es NC o equivalente.

         if not (Imp_signo = 1);
          Imp_Neto = Imp_Neto * -1;
          Imp_IVA  = Imp_IVA  * -1;
         endif;

       //  Da vuelta el signo de las retenciones para que en la fila
       // sumando comprobante + retenciones de el total.

         Imp_RetIVA    = Imp_RetIVA      * -1;
         Imp_RetGAN    = Imp_RetGAN      * -1;
         Imp_RetIIBB   = Imp_RetIIBB     * -1;
         Imp_RetSUSS   = Imp_RetSUSS     * -1;
         Imp_RetOSEG   = Imp_RetOSEG     * -1;
         Imp_RetOtros  = Imp_RetOtros    * -1;

         rowcount += 1;
         row = SSSheet_createRow(sheet: rowcount);

         ss_text( row: 00: %trim(PDCOPT)                      : CellTexto);
         ss_text( row: 01: %editc(PAARTC:'X') + %editc(PAPACP:'X'): CellTexto);
         ss_num ( row: 02: Imp_Neto                           : CellNu152);
         ss_num ( row: 03: Imp_Iva                            : CellNu152);
         ss_num ( row: 04: Imp_RetIVA                         : CellNu152);
         ss_num ( row: 05: Imp_RetIIBB                        : CellNu152);
         ss_num ( row: 06: Imp_RetGAN                         : CellNu152);
         ss_num ( row: 07: Imp_RetSUSS                        : CellNu152);
         ss_num ( row: 08: Imp_RetOSEG                        : CellNu152);
         ss_num ( row: 09: Imp_RetOtros                       : CellNu152);
         ss_num ( row: 10: PBIMAU                             : CellNu152);

         if @@CodMo <> '00' and @@CodMo <> '01';
          ss_num ( row: 11: @@Mto                              : CellNu152);
          ss_text( row: 12: %trim(@@Mone)                      : CellTexto);
         endif;

         xls_Ok = *on;

        endif;

       reade %kds(K_cnhopa31:9) c1hopa31;
       enddo;

       if xls_Ok = *on;
        rowcount += 2;
        row = SSSheet_createRow(sheet: rowcount);

        ss_text( row: 00: ''                                 : CellTexto);
        ss_text( row: 01: ''                                 : CellTexto);
        ss_text( row: 02: ''                                 : CellTexto);
        ss_text( row: 03: ''                                 : CellTexto);
        ss_text( row: 04: ''                                 : CellTexto);
        ss_text( row: 05: ''                                 : CellTexto);
        ss_text( row: 06: ''                                 : CellTexto);
        ss_text( row: 07: ''                                 : CellTexto);
        ss_text( row: 08: 'Total Pagado'                     : CellTexto);
        ss_text( row: 09: ''                                 : CellTexto);
        ss_num ( row: 10: Imp_Neto_tot                       : CellNu152);

        if @@CodMo <> '00' and @@CodMo <> '01';
          ss_num ( row: 11: @@Mto                              : CellNu152);
          ss_text( row: 12: @@Mone                             : CellTexto);
        endif;

       endif;

       SS_save(book: %trim(To_xls));
       ss_end_object_group();

      // Exporta el total en PMIMAU para incluir en el Body.
        PMIMAU = Imp_Neto_tot;
      //
       endif;

       return    xls_Ok;
     P Graba_Xls       E
      *----------------------------------------------------------------
      ******************************************************
**
00001
00002
00015
00018
99999
