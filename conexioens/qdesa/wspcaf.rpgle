
     * - ----------------------------------------------------------- *
     *  Sistema  .:  as400                                           *
     *  Objetivo .: Servicio post para insertar solicitud de carta de*
     *              Franquicia                                       *
     * ------------------------------------------------------------- *
     *  Autor    .: Fabella Ivan M.                 Fecha : 18-09-25 *
     * - ----------------------------------------------------------- *
        ctl-opt
          actgrp(*caller)
          bnddir('HDIILE/HDIBDIR')
          option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
          datfmt(*iso) timfmt(*iso);
     * - ----------------------------------------------------------- *
      //   File
     * - ----------------------------------------------------------- *
         dcl-f setcdf usage(*update:*output) keyed;
         dcl-f pahsb1 usage(*input) keyed;
         dcl-f set860 usage(*input) keyed;
         dcl-f ctlsti usage(*input) keyed;
     * - ----------------------------------------------------------- *
      //   Claves de acceso
     * - ----------------------------------------------------------- *
         dcl-ds k1tcdf likerec(s1tcdf:*key);
         dcl-ds k1hsb1 likerec(p1hsb1:*key);
         dcl-ds k1yst2 likerec(c1lsti:*key);
     * - ----------------------------------------------------------- *
      //   Copys
     * - ----------------------------------------------------------- *
         /copy *libl/qcpybooks,cartaf_H
         /copy *libl/qcpybooks,SVPWS_h
         /copy *libl/qcpybooks,svprest_h
         /copy *libl/qcpybooks,rest_h
         /copy *libl/qcpybooks,cowlog_H
         /copy *libl/qcpybooks,svpgpe_H
         /copy *libl/qcpybooks,svpsin_H
         /copy *libl/qcpybooks,svppol_H
         /copy *libl/qcpybooks,mail_h
     * - ----------------------------------------------------------- *
      //   Variables para manejo de lo que recibo
     * - ----------------------------------------------------------- *
         dcl-s peCprc char(20) inz('WSPCAF');
         dcl-s peCspr char(50) inz('WSPCAF');
         dcl-s x               int(10);
         dcl-s pxSubj          varchar(70);
         dcl-s peLmen          varchar(512);
         dcl-s peTo            char(50)   dim(100);
         dcl-s peToad          char(256)  dim(100);
         dcl-s peToty          int(10)    dim(100);
         dcl-s z               int(10);
         dcl-ds pxRprp         likeds(RecPrp_t) dim(100);
         dcl-ds errmail        likeds(MAIL_ERDS_T);
         dcl-s Borrar_adjunto  char(4) INZ('*YES') ;
     * - ----------------------------------------------------------- *
      //   Variables para manejo de lo que recibo
     * - ----------------------------------------------------------- *
         dcl-ds request likeds(wspcaf_t);
         dcl-s  varEnt  char(512);
     * - ----------------------------------------------------------- *
      //   Variables para cocinar lo que recibo
     * - ----------------------------------------------------------- *
         dcl-s pxEmpr char(1);
         dcl-s pxSucu char(2);
         dcl-s pxRama packed(2:0);
         dcl-s pxSini packed(7:0);
         dcl-s pxNops packed(7:0);
         dcl-s pxEmde char(50);
         dcl-s pxMail char(50);
         dcl-s pxnivt char(1);
         dcl-s pxnivc char(7);
         //Variables que busco
         dcl-s poliza packed(7:0);
         dcl-s superP packed(7:0);
         dcl-s fecEmi packed(8:0);
         dcl-s fecViD packed(8:0);
         dcl-s fecViH packed(8:0);
         dcl-s pxarcd packed(6:0);
         dcl-s franq  packed(15:2);
     * - ----------------------------------------------------------- *
      //  Riesgo
     * - ----------------------------------------------------------- *
        dcl-ds tipoRiesgos inz;
            B1RIEC      char(3);
            todoRiesgo  char(1) overlay(B1RIEC:1);
        end-ds;
     * - ----------------------------------------------------------- *
      // Estrucutura para fecha de siniestro
     * - ----------------------------------------------------------- *
         dcl-ds fechaDS inz;
            fecsa packed(4:0);
            fecsm packed(2:0);
            fecsd packed(2:0);
         end-ds;
     * - ----------------------------------------------------------- *
      //   Variables para manejo de error y mensajes
      //   msgrwh -> codigo de msg http
     * - ----------------------------------------------------------- *
         dcl-s  pxErro int(10) INZ(0);
         dcl-ds pxMsgs likeds(paramMsgs);
     * - ----------------------------------------------------------- *
      //  Variables para LOG
     * - ----------------------------------------------------------- *
         dcl-s Data char(65535);
         dcl-c CRLF x'0D25';
     * - ----------------------------------------------------------- *
      //   Variables para manejo del pgm
     * - ----------------------------------------------------------- *
         dcl-s finPgm         ind inz(*off);
         dcl-s condicionesOk  ind inz(*off);
         dcl-s errorDatosEntr ind inz(*off);
         dcl-s graboSolicitud ind inz(*off);
         dcl-s pasoNro        packed(1:0) inz(1);
     * - ----------------------------------------------------------- *
     *   Prototipos externos
     * - ----------------------------------------------------------- *
        dcl-pr STR013A extpgm('STR013A');
          peIdpr ind;
          peEmpr char(1);
          peSucu char(2);
          peSini packed(7:0);
          peRama packed(2:0);
        end-pr;
     * - ----------------------------------------------------------- *
      *   Cuerpo Principal
     * - ----------------------------------------------------------- *
        /free
        *inlr = *on;
         path = 'path=cartaDeFranquicia';
         dow not finPgm;
            select;
               when pasoNro = 1;
               //Leemos lo que viene
                  lecturaDeDatos();
               when pasoNro = 2;
               //Chekeamos lo basico
                  chkDatosBase();
               when pasoNro = 3;
               //De request a variables
                  parseos();
               //Ultimas condiciones.
                  condiciones();
               //Si estan dadas las condiciones...
                  if condicionesOk;
                     getDatos();
                     grabacdf();
                  endif;
                  finPgm = *on;
               other;
                  finPgm = *on;
            endsl;
         enddo;
         //Si se grabo la solicitud de carta entonces
         //aviso a siniestros
         if graboSolicitud;
            enviaMail();
         endif;
         logea();
         srclos();
         respuesta();
         return;
        /end-free
     * - ----------------------------------------------------------- *
      *   Leo el buffer
     * - ----------------------------------------------------------- *
        dcl-proc lecturaDeDatos;
         options = 'doc=string '+ %trim(path) +
               ' allowmissing=yes allowextra=yes case=any' ;
         varEnt  = %trim(@PsDs.this) + '_BODY';

         if REST_getEnvVar(%trim(varEnt) : peValu );
            options = 'doc=file '+ %trim(path) +
                      ' case=any allowextra=yes allowmissing=yes';
            // buffer = peValu;
            Qp0zDltEnv(%trim(varEnt));
            monitor;
              xml-into request %xml('/tmp/wspcaf.xml' : options);
            on-error;
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'RPG0001'
                           : pxMsgs
                           : %trim(@@repl)
                           : %len(%trim(@@repl)) );
               pxErro = -1;
               finPgm = *on;
            endmon;
         else;
            rc = REST_readStdInput( %addr(buffer): %len(buffer) );
            monitor;
               xml-into request %xml(buffer : options);
            on-error;
               @@repl = %trim(@PsDs.this) + '_t';
               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'RPG0001'
                            : pxMsgs
                            : %trim(@@repl)
                            : %len(%trim(@@repl)) );
               pxErro = -1;
               finPgm = *on;
            endmon;
         endif;
         if not finPgm;
            pasoNro = 2;
         endif;
        end-proc;
     * - ----------------------------------------------------------- *
      *   Parseo para chekear cotizacion (base)
     * - ----------------------------------------------------------- *
        dcl-proc chkDatosBase;
         request.base.peEmpr = %upper(request.base.peEmpr);
         request.base.peSucu = %upper(request.base.peSucu);
         clear pxMsgs;
         pxErro = 0;
         if SVPREST_chkBase( request.base.peEmpr
                           : request.base.peSucu
                           : request.base.peNivt
                           : request.base.peNivc
                           : request.base.peNit1
                           : request.base.peNiv1
                           : pxMsgs             ) = *off;
            pxErro = -1;
            finPgm = *on;
         else;
            pasoNro = 3;
         endif;
        end-proc;
     * - ----------------------------------------------------------- *
      *
     * - ----------------------------------------------------------- *
        dcl-proc parseos;
      *  Empresa y sucursal
         monitor;
            pxEmpr = %trim(request.base.peEmpr);
         on-error;
            errorDatosEntr = *on;
         endmon;
         monitor;
            pxSucu = %trim(request.base.peSucu);
         on-error;
            errorDatosEntr = *on;
         endmon;
      *  Codigos de productor
         monitor;
            pxNivt = %trim(request.base.peNivt);
         on-error;
            errorDatosEntr = *on;
         endmon;
         monitor;
            pxNivc = %trim(request.base.peNivc);
         on-error;
            errorDatosEntr = *on;
         endmon;
      *  Nro Rama
         monitor;
            pxRama = %dec(request.rama:2:0);
         on-error;
            errorDatosEntr = *on;
         endmon;
      *  Nro Siniestro
         monitor;
            pxSini = %dec(request.sini:7:0);
         on-error;
            errorDatosEntr = *on;
         endmon;
      *  Empresa Destino
         monitor;
            pxEmde = request.emprDestino;
         on-error;
            errorDatosEntr = *on;
         endmon;
      *  Email destino
         monitor;
            pxMail = request.mailDestino;
         on-error;
            errorDatosEntr = *on;
         endmon;
         //Si algo fallo avisamos.
         if errorDatosEntr;
            pxErro = -1;
            pxMsgs.peMsid = 'Error';
            pxMsgs.peMsg1 = 'No corresponde cobertura';
            finPgm = *on;
         endif;
        end-proc;
     * - ----------------------------------------------------------- *
      *  Por el hecho generador del siniestros sabemos si corresponde
      *  o no la carta de franquicia.
     * - ----------------------------------------------------------- *
        dcl-proc condiciones;
         k1hsb1.b1empr = pxEmpr;
         k1hsb1.b1sucu = pxSucu;
         k1hsb1.b1rama = pxRama;
         k1hsb1.b1sini = pxsini;
         chain %kds( k1hsb1 : 4 ) pahsb1;
         if %found;
            //rescato el numero de operacion
            pxnops = b1nops;
            //Todo riesgo con todas las franquicias posibles.
            if todoRiesgo = 'D';
               chain b1hecg set860;
               //Si la causa corresponde seguimos.
               if %found and S@ESTA = '1';
                  condicionesOk = *on;
               //Sino, no corresponde.
               else;
                  pxErro = -1;
                  pxMsgs.peMsid = 'Error';
                  pxMsgs.peMsg1 = 'No corresponde cobertura';
               endif;
            //Si no es todoriesgo = 'D' no corresponde
            //por la cobertura.
            else;
                  pxErro = -1;
                  pxMsgs.peMsid = 'Error';
                  pxMsgs.peMsg1 = 'No corresponde cobertura';
            endif;
         //Si por esas cosas de la vida no se encuentra el siniestro
         else;
            pxErro = -1;
            pxMsgs.peMsid = 'Error';
            pxMsgs.peMsg1 = 'No se encontro siniestro';
         endif;//%found
         if pxErro <> -1;
            //Inspeccion
            k1yst2.c1empr = pxEmpr;
            k1yst2.c1sucu = pxSucu;
            k1yst2.c1sini = pxsini;
            chain %kds(k1yst2) ctlsti;
            if %found;
               if c1esta = *off;
                  consultaInspeccion();
               endif;
            else;
               consultaInspeccion();
            endif;
            if c1esta = *off;
               pxErro = -1;
               pxMsgs.peMsid = 'Error';
               pxMsgs.peMsg1 = 'Inspección no realizada';
               condicionesOk = *off;
            endif;
         endif;
        end-proc;
     * - ----------------------------------------------------------- *
      *  Busco datos de la poliza.
     * - ----------------------------------------------------------- *
        dcl-proc consultaInspeccion;
         STR013A( c1esta
                : pxEmpr
                : pxSucu
                : pxsini
                : pxRama );
        end-proc;
     * - ----------------------------------------------------------- *
      *  Busco datos de la poliza.
     * - ----------------------------------------------------------- *
        dcl-proc getDatos;
         poliza = SVPSIN_getPol( pxEmpr
                               : pxSucu
                               : pxRama
                               : pxSini
                               : pxNops );
         if not SVPSIN_getFechaSiniestro( pxEmpr
                                        : pxSucu
                                        : pxRama
                                        : pxSini
                                        : pxNops
                                        : fecsa
                                        : fecsm
                                        : fecsd );
            pxErro = -1;
            pxMsgs.peMsid = 'Error';
            pxMsgs.peMsg1 = 'Sin fecha siniestro';
            finPgm = *on;
         endif;
         //Articulo.
         pxarcd = SVPPOL_getArticulo( pxEmpr
                                    : pxSucu
                                    : pxRama
                                    : poliza );
         //SuperPoliza.
         superP = SVPPOL_getSuperPoliza( pxEmpr
                                       : pxSucu
                                       : pxRama
                                       : poliza );
         //Fecha emision.
         fecEmi = SPVSPO_getFecEmi( pxEmpr
                                  : pxSucu
                                  : pxarcd
                                  : superP );
         //Fechas de vigencia.
         SPVSPO_getFecVig( pxEmpr
                         : pxSucu
                         : pxarcd
                         : superP
                         : fecViD
                         : fecViH );
         //Franquicia.
         franq = svpsin_getfrastro( pxEmpr
                                  : pxSucu
                                  : pxRama
                                  : pxSini
                                  : pxNops
                                  : *omit );
         pasoNro = 4;
        end-proc;
     * - ----------------------------------------------------------- *
      *  Grabo
     * - ----------------------------------------------------------- *
        dcl-proc grabacdf;
         k1tcdf.s1empr = pxEmpr;
         k1tcdf.s1sucu = pxSucu;
         k1tcdf.s1rama = pxRama;
         k1tcdf.s1poli = poliza;
         k1tcdf.s1sini = pxSini;
         k1tcdf.s1nops = pxNops;
         k1tcdf.s1empd = pxEmde;
         //Cargo variables para escribir o actualizar.
         s1empr = pxEmpr;
         s1sucu = pxSucu;
         s1rama = pxRama;
         s1poli = poliza;
         s1sini = pxSini;
         s1nops = pxNops;
         s1empd = %trim(pxEmde);
         s1mail = %trim(pxMail);
         s1femi = fecEmi;
         S1vigd = fecViD;
         S1vigh = fecViH;
         s1fecs =  fecsa * 10000
                +  fecsm * 100
                +  fecsd;
         s1nivc = %dec(pxnivc:7:0);
         s1nivt = %dec(pxnivt:1:0);
         s1stat = '0';
         s1vfra = franq;
         //Fecha de solicitud
         s1feso = %dec(%date():*iso);
         chain %kds( k1tcdf ) setcdf;
         if not %found;
            graboSolicitud = *on;
            write  s1tcdf;
         else;
            pxErro = -1;
            pxMsgs.peMsid = 'Error';
            pxMsgs.peMsg1 = 'Ya fue cargado.';
            finPgm = *on;
         endif;
        end-proc;
     * - ----------------------------------------------------------- *
      *  Logea
     * - ----------------------------------------------------------- *
        dcl-proc logea;
         if pxErro <> -1;
            Data = CRLF
                 + 'SOLICITUD REGISTRADA: '
                 + ' Rama: '
                 + %char(s1rama)
                 + '. Poliza: '
                 + %char(s1poli)
                 + '. Siniestro: '
                 + %char(s1sini)
                 + '. Nro Operacion: '
                 + %char(s1nops)
                 + '. Estado Actual: '
                 + %char(s1stat);
            COWLOG_pgmLog( 'WSPCAF' : %trim(Data) :*on );
         else;
            Data = CRLF
                 + '¡¡¡¡¡ERROR!!!!!: '
                 + ' Rama: '
                 + %char(s1rama)
                 + '. Poliza: '
                 + %char(s1poli)
                 + '. Siniestro: '
                 + %char(s1sini)
                 + '. Nro Operacion: '
                 + %char(s1nops)
                 + '. Estado Actual: '
                 + %char(s1stat)
                 + '. Error: '
                 + pxMsgs.peMsg1 ;
            COWLOG_pgmLog('WSPCAF' : %trim(Data));
         endif;
        end-proc;
     * - ----------------------------------------------------------- *
      *  Respuesta
     * - ----------------------------------------------------------- *
        dcl-proc respuesta;
         if pxErro = -1;
            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : pxMsgs.peMsid
                            : pxMsgs.peMsev
                            : pxMsgs.peMsg1
                            : pxMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            finPgm = *on;
         else;
               REST_writeHeader( 204
                               : *omit
                               : *omit
                               : pxMsgs.peMsid
                               : pxMsgs.peMsev
                               : 'Solicitud registrada'
                               : 'Solicitud registrada' );
               REST_end();
               SVPREST_end();
         endif;
        end-proc;
     * - ----------------------------------------------------------- *
      *   Envio de mail
     * - ----------------------------------------------------------- *
        dcl-proc enviaMail;
         rc = MAIL_getSubject( peCprc : peCspr : pxSubj );
         rc = MAIL_getBody   ( peCprc : peCspr : peLmen );
         peLmen = %scanrpl( '%SIN%'
                          : %trim(%char(pxSini))
                          :  peLmen           );
         peLmen = %scanrpl( '%PRD%'
                          : %trim(%char(pxNivc))
                          :  peLmen           );
         peLmen = %scanrpl( '%EMPR%'
                          : %trim( pxEmde )
                          :  peLmen           );
         rc = MAIL_getReceipt( peCprc : peCspr : pxRprp : *ON );
         z  = 0;
          for x = 1 to rc;
               z += 1;
               peTo(z)    = pxRprp(x).rpnomb;
               peToad(z)  = pxRprp(x).rpmail;
               select;
                  when pxRprp(x).rpma01 = '1';
                        peToty(z) = MAIL_NORMAL;
                  when pxRprp(x).rpma01 = '2';
                        peToty(z) = MAIL_CC;
                  when pxRprp(x).rpma01 = '3';
                        peToty(z) = MAIL_CCO;
                  other;
                        peToty(z) = MAIL_NORMAL;
               endsl;
         endfor;
         rc1 = MAIL_setMailBand( '*SYSTEM'
                               : *blanks
                               : pxSubj
                               : peLmen
                               : 'H'
                               : peTo
                               : peToad
                               : peToty   );
         if rc = -1;
               errmail = MAIL_error();
         endif;
        end-proc;
     * - ----------------------------------------------------------- *
      *   Cierro.
     * - ----------------------------------------------------------- *
        dcl-proc srclos;
         svpsin_end();
         svpsin_end();
        end-proc;
