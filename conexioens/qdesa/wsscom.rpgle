     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSCOM: BPM                                                  *
      *         Lista de Compañias                                   *
      * ------------------------------------------------------------ *
      * Nestor Nestor                        *31-Ago-2021            *
      * ------------------------------------------------------------ *
      *  Modificaciones:                                             *
      *  IMF  18/08/2025 - Modifico SVPTAB_ListaCompanias por        *
      *                    SVPTAB_ListaCompaniasV2. Esta ultima      *
      *                    retorna la lista de la tabla set139       *
      *                                                              *
      * ************************************************************ *

      /copy hdiile/qcpybooks,rest_h
      /copy hdiile/qcpybooks,svprest_h
      /copy hdiile/qcpybooks,cowlog_h
      /copy hdiile/qcpybooks,svptab_h
      /copy hdiile/qcpybooks,wsstruc_h


     D tipo            s              1a

     D x               s             10i 0

     D peDsCmC         s             10i 0
     D peDsCm          ds                  likeds(dsset139_t) dim(999)

      /free

       *inlr = *on;

       rc1  = REST_getUri( @psds.this : uri );
       if rc1 = *off;
         REST_writeHeader( 204
                         : *omit
                         : *omit
                         : 'RPG0001'
                         : 40
                         : 'Error al parsear URL'
                         : 'Error al parsear URL' );
         REST_end();
         return;
       endif;
       url = %trim(uri);

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'companias' );
        if SVPTAB_ListaCompaniasV2( peDsCm : peDsCmC );
         for x = 1 to peDsCmC;
           REST_startArray( 'compania' );
             REST_writeXmlLine( 'codCiaCoasegurado'
                                : %editc(peDsCm(x).t@ncoc:'Z'));
             REST_writeXmlLine( 'nombreCompania'
                                : %char(peDsCm(x).t@dcoc));
             REST_writeXmlLine( 'numeroInscripcion'
                                : %editc(peDsCm(x).t@ICOC:'Z'));
             REST_writeXmlLine( 'idAseguradora'
                                : %editc(peDsCm(x).t@risi:'Z'));
           REST_endArray  ( 'compania' );
         endfor;
        endif;
       REST_endArray  ( 'companias' );

       return;

