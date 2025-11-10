     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRSXI: QUOM Versión 2                                       *
      *         Lista de siniestros por intermediario                *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *01-Jun-2017            *
      * ------------------------------------------------------------ *
      * SGF 13/04/2021: Agrego tag para ramas no vida que indica si  *
      *                 se puede o no obtener un PDF con la denuncia.*
      * SGF 22/03/2023: Estado sale de PAHSEW si se puede.           *
      * SGF 08/03/2024: Agrego patente a BienSiniestrado.            *
      * SGF 12/05/2024: Agrego tipo y numero de voucher.             *
      * SGF 24/06/2024: Agrego predenuncia.                          *
      * JSN 22/10/2024: Se agrega Nuevo tag importePago, que seria   *
      *                 el importe a pagar.                          *
      * VCM 11/06/2025: Agrego condicional a para mostrar denunciaPDF*
      *                 DSPI-43                                      *
      * LRG 03/09/2025: Se cambio forma de obtener estado de         *
      *                 siniestro.- PEDS-2                           *
      * IMF 21/08/2025: Agrego tag cartaFranquicia                   *
      *                 desa_0859                                    *
      *                                                              *
      * ************************************************************ *
     Fpahstr102 if   e           k disk
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk
     Fsehase01  if   e           k disk
     Fsehni201  if   e           k disk    prefix(n2:2)
     Fpahscd    if   e           k disk
     Fset001    if   e           k disk
     Fpahsew    if   e           k disk
     Fset485    if   e           k disk    prefix(te:2)
     Fpds00008  if   e           k disk
     Fpahshp    if   e           k disk
     Fsetcdf    if   e           k disk
     Fpahsbs    if   e           k disk
     Fpahsva    if   e           k disk
     Fpahsb1    if   e           k disk
     Fset860    if   e           k disk

      /define DCLPROTO_H
      /copy hdiile/qcpybooks,rest_h
      /copy hdiile/qcpybooks,svprest_h
      /copy hdiile/qcpybooks,cowlog_h
      /copy hdiile/qcpybooks,svpvls_h

     D WSXSIN          pr                  ExtPgm('WSXSIN')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peRama                        2  0 const
     D  peSini                        7  0 const
     D  peNops                        7  0 const
     D  peSini                             likeds(pahstro_t)

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D fden            s             10d
     D fsin            s             10d
     D c               s             10i 0
     D rc2             s             10i 0
     D @@den           s             10a
     D @@ocu           s             10a
     D @@vsys          s            512a
     D @@Imau          s             15  2
     D @@neto          s             15  2
     D                 ds                  inz
     D    B1RIEC               1      3a
     D    todoRiesgo           1      1a
     D correspondeS    S              2a
     D CRLF            c                   x'0d25'

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peSini          ds                  likeds(pahstro_t)
     D peErro          s             10i 0
     D k1hstr          ds                  likerec(p1hstr1:*key)
     D k1hscd          ds                  likerec(p1hscd:*key)
     D k1hni2          ds                  likerec(s1hni201:*key)
     D k1t485          ds                  likerec(s1t485:*key)
     D k1s000          ds                  likerec(p1ds00:*key)
     D k1hshp          ds                  likerec(p1hshp:*key)
     D k1tcdf          ds                  likerec(s1tcdf:*key)
     D k1hsbs          ds                  likerec(P1HSBS:*key)
     D k1hsva          ds                  likerec(P1HSVA:*key)
     D k1hsb1          ds                  likerec(p1hsb1:*key)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

      /free

       *inlr = *on;

       if SVPVLS_getValSys( 'HPDFDENHAB' : *omit : @@vsys) = *off;
          @@vsys = 'S';
       endif;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
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

       if SVPREST_chkBase(empr:sucu:nivt:nivc:nit1:niv1:peMsgs) = *off;
          rc = REST_writeHeader( 400
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

       k1hstr.stempr = empr;
       k1hstr.stsucu = sucu;
       k1hstr.stnivt = %dec( nivt : 1 : 0 );
       k1hstr.stnivc = %dec( nivc : 5 : 0 );

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);
       COWLOG_logcon('WSRSXI':peBase);

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'siniestros' : '*BEG');

       c = 0;

       setll %kds(k1hstr:4) pahstr102;
       reade %kds(k1hstr:4) pahstr102;
       dow not %eof;

           c += 1;

           fden = %date(stfden:*iso);
           fsin = %date(stfsin:*iso);

           k1hscd.cdempr = stempr;
           k1hscd.cdsucu = stsucu;
           k1hscd.cdrama = strama;
           k1hscd.cdsini = stsini;
           chain %kds(k1hscd:4) pahscd;
           if not %found;
              cdnops = 0;
           endif;

           WSXSIN( stempr
                 : stsucu
                 : strama
                 : stsini
                 : cdnops
                 : peSini );

           @@den = %trim(%char(fden:*iso));
           @@ocu = %trim(%char(fsin:*iso));

           chain %kds(k1hscd:4) pahsew;

           REST_writeXmlLine( 'siniestro' : '*BEG' );
            REST_writeXmlLine( 'rama'               : %trim(%char(strama)) );
            REST_writeXmlLine( 'poliza'             : %trim(%char(stpoli)) );
            REST_writeXmlLine( 'nroSiniestro'       : %trim(%char(stsini)) );
            REST_writeXmlLine( 'asegurado'          : %trim(peSini.stasno) );
            REST_writeXmlLine('fechaDenuncia'       :@@den);
            REST_writeXmlLine('fechaSiniestro'      :@@ocu);
            REST_writeXmlLine( 'causa'              : %trim(peSini.stcaud) );
            if %found(pahsew);
               k1t485.terama = strama;
               k1t485.tecesi = ewcesi;
               chain %kds(k1t485:2) set485;
               if %found;
                  REST_writeXmlLine( 'estado' : %trim(ewdesi) );
                else;
                  REST_writeXmlLine( 'estado' : %trim(peSini.stdesi) )      ;
               endif;
             else;
               REST_writeXmlLine( 'estado' : %trim(peSini.stdesi) )         ;
            endif;
            REST_writeXmlLine( 'enJuicio' : peSini.stjuic );
            chain peSini.strama set001;
            if t@rame = 4;
               REST_writeXmlLine( 'bienSiniestrado' : peSini.stpatente);
             else;
               REST_writeXmlLine( 'bienSiniestrado' : peSini.stbiensin);
            endif;
            if @@vsys = 'S';
               chain peSini.strama set001;
               if %found;
                  if t@rame <> 18 and t@rame <> 21
                     and (cduser = 'GAUSQUOM01' or cduser = 'GAUSQUOM');
                     REST_writeXmlLine('denunciaPdf' : 'S' );
                   else;
                     REST_writeXmlLine('denunciaPdf' : 'N' );
                  endif;
                else;
                  REST_writeXmlLine('denunciaPdf' : 'N' );
               endif;
             else;
               REST_writeXmlLine('denunciaPdf' : 'N' );
            endif;

            k1s000.p0empr = stempr;
            k1s000.p0sucu = stsucu;
            k1s000.p0rama = strama;
            k1s000.p0sini = stsini;
            chain %kds(k1s000:4) pds00008;
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

            // Busca importe a pagar...
            exsr BuscaImau;

            REST_writeXmlLine( 'importePago'
                             : SVPREST_editImporte(@@Imau));
            //Busco carta franquicia
            exsr cartaFranquicia;
           REST_writeXmlLine( 'siniestro' : '*END' );

        reade %kds(k1hstr:4) pahstr102;
       enddo;

       REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );
       REST_writeXmlLine( 'siniestros' : '*END' );

       close *all;

       return;

       begsr BuscaImau;

         clear @@Imau;

         k1hshp.hpEmpr = stEmpr;
         k1hshp.hpSucu = stSucu;
         k1hshp.hpRama = stRama;
         k1hshp.hpSini = stSini;
         k1hshp.hpNops = cdNops;
         setll %kds(k1hshp:5) pahshp;
         reade %kds(k1hshp:5) pahshp;
         dow not %eof;
           if hpmar1 = 'I' and hpmar2 <> '2';
             @@Imau += hpimau;
           endif;
           reade %kds(k1hshp:5) pahshp;
         enddo;

       endsr;
       begsr cartaFranquicia;
         //Abro el tag
         REST_writeXmlLine( 'cartaFranquicia' : '*BEG' );
         //Asumo que este siniestro no corresponde.
         correspondeS = '-1';
         k1hsb1.b1empr = stempr;
         k1hsb1.b1sucu = stsucu;
         k1hsb1.b1rama = strama;
         k1hsb1.b1sini = stsini;
         chain %kds( k1hsb1 : 4 ) pahsb1;
         if %found;
            //Todo riesgo con todas las franquicias posibles.
            if todoRiesgo = 'D';
               chain b1hecg set860;
               //Si la causa corresponde seguimos.
               if %found and S@ESTA = '1';
                  k1tcdf.s1empr = stempr;
                  k1tcdf.s1sucu = stsucu;
                  k1tcdf.s1rama = strama;
                  k1tcdf.s1poli = stpoli;
                  k1tcdf.s1sini = stsini;
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
                        REST_writeXmlLine( 'valorNeto':'No supera franquicia');
                     else;
                        REST_writeXmlLine( 'valorNeto' : %char( @@neto ));
                     endif;
                     REST_writeXmlLine( 'empresaDestino' : s1empd );
                     //Guardo estado
                     correspondeS = s1stat;
                     REST_writeXmlLine( 'vigenciaDesde'  : %char(s1vigd) );
                     REST_writeXmlLine( 'vigenciaHasta'  : %char(s1vigh) );
                     REST_writeXmlLine( 'fechaSolicitud' : %char(s1feso) );
                     //Auto
                     k1hsbs.bsempr = stempr;
                     k1hsbs.bssucu = stsucu;
                     k1hsbs.bsrama = strama;
                     k1hsbs.bssini = stsini;
                     k1hsbs.bsnops = s1nops;
                     chain %kds( k1hsbs : 5 ) pahsbs;
                     if %found;
                        k1hsva.vaempr = stempr;
                        k1hsva.vasucu = stsucu;
                        k1hsva.varama = strama;
                        k1hsva.vasini = stsini;
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
         endif;//-> pahsb1
         REST_writeXmlLine( 'estado'          : correspondeS );
         REST_writeXmlLine( 'cartaFranquicia' : '*END' );
         //Fin carta franquicia
       endsr;
