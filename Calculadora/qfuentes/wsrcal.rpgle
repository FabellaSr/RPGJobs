     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')

      * ************************************************************ *
      * WSRLTR: QUOM Versión 2                                       *
      * ------------------------------------------------------------ *
      * Ivan M. Fabella                      *                       *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fsetdat    if   e           k disk

      /copy hdiile/qcpybooks,rest_h
      /copy hdiile/qcpybooks,svprest_h

     * - ----------------------------------------------------------- *
      *   Variables para traslado
     * - ----------------------------------------------------------- *
     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D url             s           3000a   varying
     D rc              s              1n
     D x               s             10i 0


     * - ----------------------------------------------------------- *
      *   Variables para manejo del pgm
     * - ----------------------------------------------------------- *
     D finPgm          s               n   inz(*on)
     D pasoNro         S              1  0 inz(1)

     * - ----------------------------------------------------------- *
      *   Estructura para guardar los tipos de calculo
     * - ----------------------------------------------------------- *
     D valores         ds                  dim(50) qualified
     D num1                           5  0
     D num2                           5  0
     D calc                          10a
     D resu                           5  0


     * - ----------------------------------------------------------- *
      *   Claves de acceso
     * - ----------------------------------------------------------- *
     D k1tdat          ds                  likerec(S1tdat)
     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D z               s             10i 0

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

      /free

       *inlr = *on;

       clear valores;
       // ------------------------------------------
       // Leo URL
       // ------------------------------------------
       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
          return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Cuerpo
       // ------------------------------------------

       dow finPgm;
        select;
            when pasoNro = 1;
                 pro001();
            when pasoNro = 2;
                 pro002();
            when pasoNro = 3;
                 pro003();
        endsl;
       enddo;

       return;
     * - ----------------------------------------------------------- *
      *   Chekea base
     * - ----------------------------------------------------------- *
        dcl-proc pro001;
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
                                    : empr + sucu
                                    : peMsgs.peMsg2 );
                REST_end();
                SVPREST_end();
                finPgm = *off;
                return;
            endif;
            pasoNro = 2;
        end-proc;

     * - ----------------------------------------------------------- *
      *   Carga lista de Tipo Representantes HABILITADOS
     * - ----------------------------------------------------------- *
        dcl-proc pro002;
            k1tdat.s1empr = empr;
            k1tdat.s1sucu = sucu;
            setll %kds(k1tdat:2) setdat;
            reade %kds(k1tdat:2) setdat;
            dow not %eof;
            if S1MARP = '0' ;
                z += 1;
                valores(z).num1 = s1num1;
                valores(z).num2 = s1num2;
                valores(z).resu = s1resu;
                valores(z).calc = S1TCAL;
            endif;
                reade %kds(k1tdat:2) setdat;
            enddo;
            pasoNro = 3;
        end-proc;

     * - ----------------------------------------------------------- *
      *   Arma tag
     * - ----------------------------------------------------------- *
        dcl-proc pro003;
            REST_writeHeader();
            REST_writeEncoding();

            REST_startArray('calculos');
            for x = 1 to %elem(valores);

                REST_startArray( 'calculo' );
                REST_writeXmlLine( 'Numero 1': %char(valores(x).num1) );
                REST_writeXmlLine( 'Numero 2':%char(valores(x).num2));
                REST_writeXmlLine( 'resultado':%char(valores(x).resu));
                REST_writeXmlLine( 'Calculo': valores(x).calc);
                REST_endArray( 'calculo' );

            endfor;
            REST_endArray('calculos');
            REST_end();
            finPgm = *off;
        end-proc;
