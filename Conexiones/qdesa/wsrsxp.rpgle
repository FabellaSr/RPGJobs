     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRCIP: QUOM Versión 2                                       *
      *         Cuotas Impagas de una póliza.                        *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *06-Jun-2017            *
      *                                                              *
      * Ruben Castillo: Aviso de Orden de Pago para aplicar a pago de*
      *                 poliza que se vea en Zamba y en la pagina a  *
      *                 que acceden los productores para ver los     *
      *                 pasos.                                       *
      *                                                              *
      * SGF 13/04/2021: Agrego tag para ramas no vida que indica si  *
      *                 se puede o no obtener un PDF con la denuncia.*
      * SGF 30/07/21: Agrego Recibo Indemnizacion.                   *
      * SGF 22/03/2023: Estado sale de PAHSEW si se puede.           *
      * SGF 13/04/23: Los dias a sumar a la fecha de caja son habiles*
      * SGF 24/04/23: CUIDADO. Hay OPS con STOP='3' pero sin fecha de*
      *               pago.                                          *
      * SGF 08/03/24: Agrego patente a BienSiniestrado.              *
      * SGF 24/06/2024: Agrego predenuncia, tipo y numero de voucher.*
      * IMF 01/09/2025: Agrego proc cartaFranquicia. DESA-0859.      *
      *                                                              *
      * ************************************************************ *
     Fsehni2    if   e           k disk
     Fset001    if   e           k disk
     Fpahec1    if   e           k disk
     Fpahstr1   if   e           k disk
     Fpahed004  if   e           k disk    rename(p1hed004:p1hed0)
     Fset485    if   e           k disk    prefix(tt:2)
     Fpahsew    if   e           k disk
     Fpahshp    if   e           k disk
     Fcnhopa    if   e           k disk
     Fcnhric    if   e           k disk
     Fgnttbe    if   e           k disk
     Fpds00008  if   e           k disk
     Fsetcdf    if   e           k disk
     Fpahsbs    if   e           k disk
     Fpahsva    if   e           k disk
     Fpahsb1    if   e           k disk
     Fset860    if   e           k disk

      /copy hdiile/qcpybooks,wsstruc_h
      /copy hdiile/qcpybooks,rest_h
      /copy hdiile/qcpybooks,svprest_h
      /copy hdiile/qcpybooks,cowlog_h
      /copy hdiile/qcpybooks,svpvls_h
      /copy hdiile/qcpybooks,svpdes_h
      /copy hdiile/qcpybooks,spvfec_h

     D WSLSXP          pr                  ExtPgm('WSLSXP')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keysxp_t) const
     D   pePreg                            likeds(keysxp_t)
     D   peUreg                            likeds(keysxp_t)
     D   peLsin                            likeds(pahstro_t) dim(99)
     D   peLsinC                     10i 0
     D   peMore                       1n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D   pePosi        ds                  likeds(keysxp_t)
     D   pePreg        ds                  likeds(keysxp_t)
     D   peUreg        ds                  likeds(keysxp_t)
     D   peLsin        ds                  likeds(pahstro_t) dim(99)
     D   peLsinC       s             10i 0
     D   peMore        s              1n
     D   peRoll        s              1a

     D   pePasi        ds                  likeds(pahstro1_t) dim(99)
     D   pePasiC       s             10i 0
     D   peErr1        s             10i 0
     D   peMor1        s              1n
     D   peRol1        s              1a

     D WSLZI1          pr                  ExtPgm('WSLZI1')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   pePosi                            likeds(keyzi1_t) const
     D   pePreg                            likeds(keyzi1_t)
     D   peUreg                            likeds(keyzi1_t)
     D   peLins                            likeds(pahzin_t) dim(99)
     D   peLinsC                     10i 0
     D   peMore                       1n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D   pePos2        ds                  likeds(keyzi1_t)
     D   pePre2        ds                  likeds(keyzi1_t)
     D   peUre2        ds                  likeds(keyzi1_t)
     D   peLins        ds                  likeds(pahzin_t) dim(99)
     D   peLinsC       s             10i 0
     D   peMor2        s              1n
     D   peErr2        s             10i 0
     D   peRol2        s              1a

     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D rama            s              2a
     D poli            s              7a

     D rc2             s             10i 0
     D @@nit1          s              1  0
     D @@niv1          s              5  0
     D fliq            s             10a
     D fpag            s             10a
     D fins            s             10a
     D imp             s             30a
     D peErro          s             10i 0
     D x               s             10i 0
     D z               s             10i 0
     D @@rama          s              2  0
     D @@vsys          s            512a
     D @@fech          s              8  0
     D c               s             10i 0
     D tipoPago        s             50a
     D @@neto          s             15  2
     D                 ds                  inz
     D    B1RIEC               1      3a
     D    todoRiesgo           1      1a
     D correspondeS    S              2a
     D peMsgs          ds                  likeds(paramMsgs)
     D peBase          ds                  likeds(paramBase)

     D k1hni2          ds                  likerec(s1hni2:*key)
     D k1hed0          ds                  likerec(p1hed0:*key)
     D k1hec1          ds                  likerec(p1hec1:*key)
     D k1hstr          ds                  likerec(p1hstr1:*key)
     D k1hsew          ds                  likerec(p1hsew:*key)
     D k1t485          ds                  likerec(s1t485:*key)
     D k1hshp          ds                  likerec(p1hshp:*key)
     D k1hopa          ds                  likerec(c1hopa:*key)
     D k1hric          ds                  likerec(c1hric:*key)
     D k1ttbe          ds                  likerec(g1ttbe:*key)
     D k1s000          ds                  likerec(p1ds00:*key)
     D k1tcdf          ds                  likerec(s1tcdf:*key)
     D k1hsbs          ds                  likerec(P1HSBS:*key)
     D k1hsva          ds                  likerec(P1HSVA:*key)
     D k1hsb1          ds                  likerec(p1hsb1:*key)


      /free

       *inlr = *on;

       if SVPVLS_getValSys( 'HPDFDENHAB' : *omit : @@vsys) = *off;
          @@vsys = 'S';
       endif;

       rc1  = REST_getUri( @psds.this : uri );
       if rc1 = *off;
          return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       poli = REST_getNextPart(url);

       if SVPREST_chkBase(empr:sucu:nivt:nivc:nit1:niv1:peMsgs) = *off;
          rc1 = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          close *all;
          return;
       endif;

       if %check( '0123456789' : %trim(rama) ) <> 0;
          @@repl = rama;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RAM0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc1 = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'RAM0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       @@rama = %dec( rama : 2 : 0 );
       chain @@rama set001;
       if not %found;
          @@repl = rama;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RAM0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc1 = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'RAM0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if %check( '0123456789' : %trim(poli) ) <> 0;
          %subst(@@repl:1:2) = rama;
          %subst(@@repl:3:7) = poli;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc1 = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'POL0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       k1hed0.d0empr = empr;
       k1hed0.d0sucu = sucu;
       k1hed0.d0rama = %dec( rama : 2 : 0 );
       k1hed0.d0poli = %dec( poli : 7 : 0 );
       setgt  %kds(k1hed0:4) pahed004;
       readpe %kds(k1hed0:4) pahed004;
       if %eof;
          %subst(@@repl:1:2) = rama;
          %subst(@@repl:3:7) = poli;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc1 = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'POL0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       clear peBase;
       clear peLsin;
       clear peMsgs;
       clear pePosi;
       clear pePreg;
       clear peUreg;

       peLsinC = 0;
       peErro  = 0;
       peRoll  = 'I';

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec( nivt : 1 : 0 );
       peBase.peNivc = %dec( nivc : 5 : 0 );
       peBase.peNit1 = %dec( nit1 : 1 : 0 );
       peBase.peNiv1 = %dec( niv1 : 5 : 0 );

       COWLOG_logcon('WSRSXP':peBase);

       pePosi.cdrama = %dec( rama : 2 : 0 );
       pePosi.cdpoli = %dec( poli : 7 : 0 );
       pePosi.cdsini = 0;
       pePosi.cdnops = 0;

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'siniestros' : '*BEG' );

       dou peMore = *off;
           WSLSXP( peBase
                 : 99
                 : peRoll
                 : pePosi
                 : pePreg
                 : peUreg
                 : peLsin
                 : peLsinC
                 : peMore
                 : peErro
                 : peMsgs );

           if peLsinC <= 0;
              leave;
           endif;

           peRoll = 'F';
           pePosi = peUreg;

           for x = 1 to peLsinC;
            REST_writeXmlLine( 'siniestro' : '*BEG' );

            k1hsew.ewempr = peLsin(x).stempr;
            k1hsew.ewsucu = peLsin(x).stsucu;
            k1hsew.ewrama = peLsin(x).strama;
            k1hsew.ewsini = peLsin(x).stsini;
            k1hsew.ewnops = peLsin(x).stnops;
            chain %kds(k1hsew:5) pahsew;

            REST_writeXmlLine( 'rama' : %char(peLsin(x).strama));
            REST_writeXmlLine( 'poliza' : %char(peLsin(x).stpoli));
            REST_writeXmlLine( 'nroSiniestro' : %char(peLsin(x).stsini));
            REST_writeXmlLine( 'asegurado' : peLsin(x).stasno);
            REST_writeXmlLine( 'fechaDenuncia'
                             : %trim(%char(peLsin(x).stfden:*iso)) );
            REST_writeXmlLine( 'fechaSiniestro'
                             : %trim(%char(peLsin(x).stfsin:*iso)) );
            REST_writeXmlLine( 'causa'  : %trim(peLsin(x).stcaud) );

            if %found(pahsew);
               k1t485.ttrama = peLsin(x).strama;
               k1t485.ttcesi = ewcesi;
               chain %kds(k1t485:2) set485;
               if %found;
                  REST_writeXmlLine( 'estado' : %trim(ttdesi) );
                else;
                  REST_writeXmlLine( 'estado' : %trim(peLsin(x).stdesi) );
               endif;
             else;
               REST_writeXmlLine( 'estado' : %trim(peLsin(x).stdesi) );
            endif;

            REST_writeXmlLine( 'juicio' : peLsin(x).stjuic);

            if @@vsys = 'S';
               if t@rame <> 18 and t@rame <> 21;
                   REST_writeXmlLine('denunciaPdf' : 'S' );
                else;
                   REST_writeXmlLine('denunciaPdf' : 'N' );
               endif;
             else;
               REST_writeXmlLine('denunciaPdf' : 'N' );
            endif;

            exsr pagos;

            //exsr inspe;

            if t@rame = 4;
               REST_writeXmlLine( 'bienSiniestrado' : peLsin(x).stpatente);
             else;
               REST_writeXmlLine( 'bienSiniestrado' : peLsin(x).stbiensin);
            endif;

            // Predenuncia...
            k1s000.p0empr = peLsin(x).stempr;
            k1s000.p0sucu = peLsin(x).stsucu;
            k1s000.p0rama = peLsin(x).strama;
            k1s000.p0sini = peLsin(x).stsini;
            k1s000.p0nivt = peBase.peNivt;
            k1s000.p0nivc = peBase.peNivc;
            chain %kds(k1s000:6) pds00008;
            if %found;
               REST_writeXmlLine('tipoDeVoucher' :p0Mar1);
               REST_writeXmlLine('numeroDeVoucher':%char(p0Nore));
               REST_writeXmlLine( 'documentoPredenuncia'
                                : 'Predenuncia_'
                                + %trim(%char(p0npds))
                                + '.pdf'                        );
               REST_writeXmlLine( 'claseDocumental'
                                : 'Predenuncias'                );
             else;
               REST_writeXmlLine('tipoDeVoucher' : '');
               REST_writeXmlLine('numeroDeVoucher':'');
               REST_writeXmlLine( 'documentoPredenuncia' : *blanks);
               REST_writeXmlLine( 'claseDocumental'      : *blanks);
            endif;
            //Busco carta franquicia
            exsr cartaFranquicia;

            REST_writeXmlLine( 'siniestro' : '*END');

           endfor;

           if peMore = *off;
              leave;
           endif;

       enddo;

       REST_writeXmlLine( 'siniestros' : '*END' );
       REST_end();

       close *all;

       return;

       begsr pagos;
        k1hshp.hpempr = peLsin(x).stempr;
        k1hshp.hpsucu = peLsin(x).stsucu;
        k1hshp.hprama = peLsin(x).strama;
        k1hshp.hpsini = peLsin(x).stsini;
        REST_startArray( 'pagos' );
        setll %kds(k1hshp:4) pahshp;
        reade %kds(k1hshp:4) pahshp;
        dow not %eof;
            if hpmar1 = 'I' and hpmar2 <> '2';
               k1ttbe.g1empr = hpempr;
               k1ttbe.g1sucu = hpsucu;
               k1ttbe.g1tben = hpmar2;
               chain %kds(k1ttbe) gnttbe;
               if not %found;
                  g1dben = *blanks;
                  g1dia1 = 999;
               endif;
               REST_startArray( 'pago' );
                REST_writeXmlLine( 'fechaLiq'
                                 : SVPREST_editFecha( (hpfmoa * 10000)
                                                    + (hpfmom *   100)
                                                    +  hpfmod )        );
                REST_writeXmlLine( 'importePago'
                                 : SVPREST_editImporte(hpimau)         );
                REST_writeXmlLine( 'tipoBen': g1dben                   );
                REST_writeXmlLine( 'beneficiario'
                                 : SVPDAF_getNombre(hpnrdf)            );
                tipoPago = 'INDEMNIZACION';
                k1hopa.paempr = hpempr;
                k1hopa.pasucu = hpsucu;
                k1hopa.paartc = hpartc;
                k1hopa.papacp = hppacp;
                chain %kds(k1hopa:4) cnhopa;
                if not %found;
                   pastop = '0';
                   pamp01 = '0';
                endif;
                //
                // Si esta OP no la cobra un proveedor veo
                // si la misma es para cancelar saldo de poliza.
                //
                if (hpmar2 <> '3');
                   if pamp01 = '1';
                      tipoPago = 'CANCELACION DE SALDOS DE POLIZA';
                   endif;
                endif;
                REST_writeXmlLine( 'tipoPago' : tipoPago               );
                REST_writeXmlLine( 'cobertura'
                                 : SVPDES_cobLargo( hprama
                                                  : hpxcob )           );
                //
                // La fecha de pago es controversial
                // Lo que queremos mostrar acá es el día REAL en que el
                // beneficiario va a recibir el dinero... Esto es obviamente
                // una fantasía... Asi que, si la OP está CANCELADA por Caja
                // sumamos X días (que estan en GNTTBE) a la fecha de la
                // cancelacion de la op.
                // En cambio, si la op no está cancelada por caja aun, no
                // podemos dar una fecha
                //
                fpag = 'PENDIENTE';
                if (pastop = '3');
                   if pbfasa <> 0 and
                      pbfasm <> 0 and
                      pbfasd <> 0;
                      @@fech = SPVFEC_SumResDiaHabF8( (pbfasa * 10000)
                                                    + (pbfasm *   100)
                                                    +  pbfasd
                                                    : '+'
                                                    : g1dia1            );
                      fpag = %subst(%editc(@@fech:'X'):7:2)
                           + '/'
                           + %subst(%editc(@@fech:'X'):5:2)
                           + '/'
                           + %subst(%editc(@@fech:'X'):1:4);
                   endif;
                endif;
                REST_writeXmlLine( 'fechaPago'   : fpag );
                REST_writeXmlLine( 'nroOdp'      : %char(hppacp)       );
                k1hric.icempr = hpempr;
                k1hric.icsucu = hpsucu;
                k1hric.icartc = hpartc;
                k1hric.icpacp = hppacp;
                chain %kds(k1hric:4) cnhric;
                if not %found;
                   icivnr = 0;
                endif;
                REST_writeXmlLine( 'nroRecibo' : %char(icivnr)         );
               REST_endArray  ( 'pago' );
               c += 1;
            endif;
         reade %kds(k1hshp:4) pahshp;
        enddo;
        REST_endArray  ( 'pagos' );
       endsr;

       begsr inspe;

        clear peRol2;
        clear pePos2;
        clear pePre2;
        clear peUre2;
        clear peLins;

        peRol2 = 'I';
        peLinsC = 0;
        peErr2 = 0;

        pePos2.rama = peLsin(x).strama;
        pePos2.sini = peLsin(x).stsini;

        REST_writeXmlLine( 'inspecciones' : '*BEG' );

            WSLZI1( peBase
                  : 99
                  : peRol2
                  : peLsin(x).strama
                  : peLsin(x).stsini
                  : pePos2
                  : pePre2
                  : peUre2
                  : peLins
                  : peLinsC
                  : peMor2
                  : peErr2
                  : peMsgs );

         if peLinsC > 0;

            peRol2 = 'F';
            pePos2 = peUre2;

            for z = 1 to peLinsC;

             fins = %char(%date(peLins(z).infins:*iso));
             if fins = '0001-01-01';
                fins = *blanks;
             endif;

             REST_writeXmlLine( 'inspeccion' : '*BEG' );
             REST_writeXmlLine( 'fechaIns'   : fins );
             REST_writeXmlLine( 'nroReclamo': %char(peLins(z).inidre) );
             REST_writeXmlLine( 'responsable': peLins(z).ininsd );
             REST_writeXmlLine( 'estado': peLins(z).instin );
             REST_writeXmlLine( 'tipoDoc': peLins(z).intdoc );
             REST_writeXmlLine( 'inspeccion' : '*END' );

            endfor;

         endif;

        REST_writeXmlLine( 'inspecciones' : '*END' );

       endsr;
       begsr cartaFranquicia;
         //Abro el tag
         REST_writeXmlLine( 'cartaFranquicia' : '*BEG' );
         //Asumo que este siniestro no corresponde.
         correspondeS = '-1';
         k1hsb1.b1empr = peLsin(x).stempr;
         k1hsb1.b1sucu = peLsin(x).stsucu;
         k1hsb1.b1rama = peLsin(x).strama;
         k1hsb1.b1sini = peLsin(x).stsini;
         k1hsb1.b1nops = peLsin(x).stnops;
         chain %kds( k1hsb1 : 5 ) pahsb1;
         if %found;
            //Todo riesgo con todas las franquicias posibles.
            if todoRiesgo = 'D';
               chain b1hecg set860;
               //Si la causa corresponde seguimos.
               if %found and S@ESTA = '1';
                  k1tcdf.s1empr = peLsin(x).stempr;
                  k1tcdf.s1sucu = peLsin(x).stsucu;
                  k1tcdf.s1rama = peLsin(x).strama;
                  k1tcdf.s1poli = peLsin(x).stpoli;
                  k1tcdf.s1sini = peLsin(x).stsini;
                  //Si llego hasta aca es por que corresponde.
                  correspondeS = '0';
                  chain %kds( k1tcdf : 5 ) setcdf;
                  if %found;
                     REST_writeXmlLine( 'valorManoDeObra': %char( s1vmob ));
                     REST_writeXmlLine( 'valorRepuestos' : %char( s1vrep ));
                     REST_writeXmlLine( 'valorTotal'
                                      : %char( s1vmob + s1vrep )          );
                     REST_writeXmlLine( 'valorFranquicia': %char( s1vfra ));
                     @@neto = (s1vmob + s1vrep) - s1vfra ;
                     if @@neto <= 0;
                        REST_writeXmlLine( 'valorNeto': 'No supera franquicia');
                     else;
                        REST_writeXmlLine( 'valorNeto': %char( @@neto ));
                     endif;
                     REST_writeXmlLine( 'empresaDestino' : s1empd );
                     //Guardo estado
                     correspondeS = s1stat;
                     REST_writeXmlLine( 'vigenciaDesde'  : %char(s1vigd) );
                     REST_writeXmlLine( 'vigenciaHasta'  : %char(s1vigh) );
                     REST_writeXmlLine( 'fechaSolicitud' : %char(s1feso) );
                     //Auto
                     k1hsbs.bsempr = peLsin(x).stempr;
                     k1hsbs.bssucu = peLsin(x).stsucu;
                     k1hsbs.bsrama = peLsin(x).strama;
                     k1hsbs.bssini = peLsin(x).stsini;
                     k1hsbs.bsnops = s1nops;
                     chain %kds( k1hsbs : 5 ) pahsbs;
                     if %found;
                        k1hsva.vaempr = peLsin(x).stempr;
                        k1hsva.vasucu = peLsin(x).stsucu;
                        k1hsva.varama = peLsin(x).strama;
                        k1hsva.vasini = peLsin(x).stsini;
                        k1hsva.vanops = s1nops;
                        k1hsva.vapoco = bspoco;
                        k1hsva.vapaco = bspaco;
                        chain %kds( k1hsva : 7 ) pahsva;
                        if %found;
                           REST_writeXmlLine( 'datosAuto' : '*BEG' );
                              REST_writeXmlLine( 'marca'   : vavhmc );
                              REST_writeXmlLine( 'modelo'  : vavhmo );
                              REST_writeXmlLine( 'dominio' : vanmat );
                              REST_writeXmlLine( 'motor'   : vamoto );
                           REST_writeXmlLine( 'datosAuto' : '*END' );
                        endif;
                     endif;//->pahsbs
                  endif;//->setcdf
               endif;//->set860
            endif;//->todoRiesgo
         endif;//->pahsb1
         REST_writeXmlLine( 'estado'          : correspondeS );
         REST_writeXmlLine( 'cartaFranquicia' : '*END' );
         //Fin carta franquicia
       endsr;

      /end-free
