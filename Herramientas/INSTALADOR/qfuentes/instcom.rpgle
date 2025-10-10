        ctl-opt
          actgrp(*caller)
          bnddir('INSTALADOR/HDIBDIR')
          option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
          datfmt(*iso) timfmt(*iso);
     * - ----------------------------------------------------------- *
     *  Sistema  .:  as400                                           *
     * ------------------------------------------------------------- *
      /copy instalador/qcpybooks,svpcfg_H
      /copy instalador/qcpybooks,svpinst_H
      /copy instalador/qcpybooks,svpapi_H
      /copy hdiile/qcpybooks,svpvls_H
     * - ----------------------------------------------------------- *
      *   Se llama...
     * - ----------------------------------------------------------- *
          // Prototipo
          dcl-pr INSTCOM;
               DESA     char(10);
               deta     char(50);
               flaginst ind;
               retorno  ind;
          end-pr;

          // Interfaz
          dcl-pi INSTCOM;
               DESA     char(10);
               deta     char(50);
               flaginst ind;
               retorno  ind;
          end-pi;
     * ------------------------------------------------------------- *
      *   Cuerpo Principal
     * - ----------------------------------------------------------- *
        /free
        *inlr = *on;
          exsr inicio;
          dow not endpgm;
               select;
                    when paso = 1;
                         exsr ambiente;
                    when paso = 2;
                         exsr accion;
                    when paso = 3;
                         exsr cargaFuentesObjetos;
                         if not flaginst;
                              endpgm = *on;
                         endif;
                    when paso = 4;
                         exsr pasajeObjetos;
                    when paso = 5;
                         exsr pasajeFuentes;
               endsl;
          enddo;
          if flaginst;
               exsr clearLibTemp;
          endif;
          return;
        /end-free
     * - ----------------------------------------------------------- *
      *  inicio
     * - ----------------------------------------------------------- *
          begsr inicio;
               SVPVLS_getValSys('INSTALOBJE': *omit : @@vsys);
               conf_obj = %trim(@@vsys);
               retorno = *on;
          endsr;
     * - ----------------------------------------------------------- *
      *  ambiente
     * - ----------------------------------------------------------- *
          begsr ambiente;
               if not svpcfg_ambiente(estoyEn);
                    endpgm = *on;
                    retorno = *off;
               endif;
               paso = 2;
          endsr;
     * - ----------------------------------------------------------- *
      *  Accion
     * - ----------------------------------------------------------- *
          begsr accion;
               select;
                    when estoyEn = 'SOFTTEST  ';
                         monitor;
                              callp rstttcmd( libr1
                                            : DESA
                                            : lsav1
                                            : savl1 );
                              paso = 3;
                         on-error;
                              endpgm = *on;
                              retorno = *off;
                         endmon;
                    when estoyEn = 'SOFTDESA  ';
                         monitor;
                              callp getsavf( desa
                                           : parasf
                                           : parasf);
                              paso = 3;
                         on-error;
                              endpgm = *on;
                              retorno = *off;
                         endmon;
               endsl;
          endsr;
     * - ----------------------------------------------------------- *
      *  Pasaje de Fuentes
     * - ----------------------------------------------------------- *
          begsr clearLibTemp;
               SVPVLS_getValSys('INSTALTEMP': *omit : @@vsys);
               cmd = 'CLRLIB LIB('+%trim(@@vsys)+')';
               monitor;
                    qCmdExc( %trim(cmd) : %len(%trim(cmd)) );
               on-error;
                    *in50 = *on;
               endmon;
          endsr;
     * - ----------------------------------------------------------- *
      *  Carga Fuentes y Objetos
     * - ----------------------------------------------------------- *
          begsr cargaFuentesObjetos;
               callp pgglectura( desa
                               : retornoSecu
                               : deta);
               if retornoSecu = 0;
                    retorno = *off;
                    endpgm  = *on;
               endif;
               paso = 4;
          endsr;

     * - ----------------------------------------------------------- *
      *  Pasaje de Objetos
     * - ----------------------------------------------------------- *
          begsr pasajeObjetos;
               callp pggobjetos( desa
                               : retornoSecu);
               if retornoSecu = 0;
                    endpgm = *on;
                    retorno = *off;
               endif;
               paso = 5;
          endsr;
     * - ----------------------------------------------------------- *
      *  Pasaje de Fuentes
     * - ----------------------------------------------------------- *
          begsr pasajeFuentes;
               callp pggfuentes( desa
                               : retornoSecu);
               if retornoSecu = 0;
                    retorno = *off;
               endif;
               endpgm  = *on;
          endsr;
