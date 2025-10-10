     H option(*nodebugio: *srcstmt: *noshowcpy)
     H actgrp(*caller) dftactgrp(*no)
     H alwnull(*usrctl)
     H COPYRIGHT('HDI Seguros')
     H bnddir('HDIILE/HDIBDIR')
     * - ----------------------------------------------------------- *
     *  Sistema  .:  as400                                           *
     *  Objetivo .:                                                  *
     * ------------------------------------------------------------- *
     *  Autor    .: Fabella Ivan M.                 Fecha : 00-00-00 *
     *                 - PRO001: Leo buffer de entrada. Este proc.   *
     *                           fue modifcado para que en caso de   *
     *                           wrapper, se lea desde disco.        *
     *                 - PRO002: SVPREST_chkBase                     *
     *                 - PRO005: Respuesta para el front             *
     * - ----------------------------------------------------------- *

     * - ----------------------------------------------------------- *
      *   Copys
     * - ----------------------------------------------------------- *
     D/copy hdiile/qcpybooks,svprest_h
     D/copy hdiile/qcpybooks,rest_h
     D/copy hdiile/qcpybooks,cowlog_H
     D/copy hdiile/qcpybooks,svpgpe_H
     D/copy hdiile/qcpybooks,parbase_h
     * - ----------------------------------------------------------- *
      *   PATH
     * - ----------------------------------------------------------- *
     D path            S             23a   inz('path=calculadora')
     * ---------------------------------------------------- *
      * Estrucutura para recibr datos post/get
     * ---------------------------------------------------- *
     D wspcal_t        ds                  qualified template
     D  base                               likeds(paramBaseA)
     D   peNum1                       5  0
     D   peNum2                       5  0
     D   peTcal                       1a
     * - ----------------------------------------------------------- *
      *   Variables para manejo de lo que recibo
     * - ----------------------------------------------------------- *
     D request         ds                  likeds(wspcal_t)
     D buffer          s          65535a
     D rc1             s             10i 0
     D options         s           5000a
     D varEnt          s            512a
     D peValu          s           1024a
     D x               S             10i 0 inz(1)
     D piSexo          S              1  0
     D peSexC          S              1a
     * - ----------------------------------------------------------- *
      *   Calculadora
     * - ----------------------------------------------------------- *
     DCALCULADO        PR                  extpgm('CALCULADO')
     D num1                           5  0 const
     D num2                           5  0 const
     D calc                           1a   const
     D fecl                           8  0 const
     D resu                           5  0 const
     D fin                            1a
     * - ----------------------------------------------------------- *
      *   Variables para manejo de error y mensajes
     * - ----------------------------------------------------------- *
     D wrepl           s          65535a
     D pxErro          s             10i 0
     D pxMsgs          ds                  likeds(paramMsgs)
     D msgerr          S              3  0 inz(400)
     * - ----------------------------------------------------------- *
      *  Variables para LOG
     * - ----------------------------------------------------------- *
     D Data            s          65535a
     D CRLF            c                   x'0d25'
     * - ----------------------------------------------------------- *
      *   Que trabajo es este?
     * - ----------------------------------------------------------- *
     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D  job                          10a   overlay(PsDs:244)
     D  CurUsr                       10a   overlay(PsDs:358)
     * - ----------------------------------------------------------- *
      *   Variables para manejo del pgm
     * - ----------------------------------------------------------- *
     D finPgm          s               n   inz(*off)
     D rtncal          s               n   inz(*off)
     D pasoNro         S              1  0 inz(1)
     * - ----------------------------------------------------------- *
      *   Cuerpo Principal
     * - ----------------------------------------------------------- *
        /free
        *inlr = *on;
        dow not finPgm;
            select;
               when pasoNro = 1;
                  pro001();
               when pasoNro = 2;
                  pro002();
               when pasoNro = 3;
                  pro003();
               when pasoNro = 4;
                  pro004();
               other;
                  finPgm = *off;
            endsl;
        enddo;
        logea();
        srclos();
        pro004();
        //return;
        /end-free
     * - ----------------------------------------------------------- *
      *   Leo el buffer
     * - ----------------------------------------------------------- *
        dcl-proc pro001;
         options = 'doc=string '+path+
               ' allowmissing=yes allowextra=yes case=any' ;
         varEnt  = %trim(PsDs.this) + '_BODY';

         if REST_getEnvVar(%trim(varEnt) : peValu );
            options = 'doc=file '+path+
                      ' case=any allowextra=yes allowmissing=yes';
            // buffer = peValu;
            Qp0zDltEnv(%trim(varEnt));

            monitor;
              xml-into request %xml('/tmp/wspcal.xml' : options);
            on-error;
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'RPG0001'
                           : pxMsgs
                           : %trim(wrepl)
                           : %len(%trim(wrepl)) );

              REST_writeHeader( 400
                              : *omit
                              : *omit
                              : 'RPG0001'
                              : pxMsgs.peMsev
                              : pxMsgs.peMsg1
                              : pxMsgs.peMsg2 );

                              REST_end();
                              SVPREST_end();
                              return;
           endmon;
         else;
            rc1 = REST_readStdInput( %addr(buffer): %len(buffer));
            monitor;
               xml-into request %xml(buffer : options);
            on-error;
               wrepl = %trim(PsDs.this) + '_t';
               SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'RPG0001'
                           : pxMsgs
                           : %trim(wrepl)
                           : %len(%trim(wrepl)) );
               REST_writeHeader( 400
                              : *omit
                              : *omit
                              : 'RPG0001'
                              : pxMsgs.peMsev
                              : pxMsgs.peMsg1
                              : pxMsgs.peMsg2 );
            pxErro = -1;
            REST_end();

               finPgm = *on;
               return;
            endmon;
         endif;

         if not finPgm;
            pasoNro = 2;
         endif;

        end-proc;
     * - ----------------------------------------------------------- *
      *   Calculo
     * - ----------------------------------------------------------- *
        dcl-proc pro003;
            CALCULADO(request.penum1
                     :request.penum2
                     :request.peTcal
                     :%dec(%date():*iso)
                     :*zeros
                     :rtncal);
         pasoNro = 4;
        end-proc;
     * - ----------------------------------------------------------- *
      *   Parseo para chekear cotizacion (base)
     * - ----------------------------------------------------------- *
        dcl-proc pro002;
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
                           : pxMsgs                ) = *off;
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
            return;
         else;
            pasoNro = 3;
         endif;
        end-proc;

     * - ----------------------------------------------------------- *
      *  Respuesta
     * - ----------------------------------------------------------- *
        dcl-proc pro004;
        if pxErro = -1;
           REST_writeHeader( msgerr
                           : *omit
                           : *omit
                           : pxMsgs.peMsid
                           : pxMsgs.peMsev
                           : pxMsgs.peMsg1
                           : pxMsgs.peMsg2 );
           REST_end();
           SVPREST_end();
           finPgm = *on;
           return;
        endif;

        REST_writeHeader( 201
                        : *omit
                        : *omit
                        : *omit
                        : *omit
                        : *omit
                        : *omit );

        REST_end();
        SVPREST_end();
        finPgm = *on;
        end-proc;
     * - ----------------------------------------------------------- *
      *  Logea
     * - ----------------------------------------------------------- *
        dcl-proc logea;
         if pxErro <> -1;
            Data = CRLF
                     + ' Cotizacion: '
                     + %char(request.peNum1)
                     + ' NIVC: '
                     + %char(request.base.peNivc)
                     + ' Paso(si es el 4 termino ok): '
                     + %char(pasoNro)
                     + ' Hora: '
                     + %char(%dec(%time():*iso));
                     COWLOG_pgmLog('WSPRLE':Data:*on);
         else;
            data = CRLF + 'Error: '+ pxMsgs;
            COWLOG_pgmLog('WSPRLE':Data:*on);
         endif;
        end-proc;
     * - ----------------------------------------------------------- *
        dcl-proc logeaInsert;
         if pxErro <> -1;
            Data = CRLF
                     + ' Cotizacion: '
                     + %char(request.peNum1)
                     + ' NIVC: ';
                     COWLOG_pgmLog('WSPRLE2':Data:*on);
         else;
            data = CRLF + 'Error: '+ pxMsgs;
            COWLOG_pgmLog('WSPRLE2':Data:*on);
         endif;
        end-proc;
     * - ----------------------------------------------------------- *
      *   Cierro.
     * - ----------------------------------------------------------- *
        dcl-proc srclos;

        end-proc;
