     H option(*nodebugio: *srcstmt: *noshowcpy)
     H actgrp(*caller) dftactgrp(*no)
     H COPYRIGHT('HDI Seguros')
     H bnddir('INSTALADOR/HDIBDIR')
     * - ----------------------------------------------------------- *
     *  Sistema  .:  as400                                           *
     * ------------------------------------------------------------- *
      /copy instalador/qcpybooks,svpcfg_H
      /copy instalador/qcpybooks,svpinst_H
      /copy hdiile/qcpybooks,svpvls_H
     * - ----------------------------------------------------------- *
      *   Se llama...
     * - ----------------------------------------------------------- *
     D CARGAINS        pr
     D                               10
     D                               50
     D                                 n
     D CARGAINS        pi
     D DESA                          10
     D deta                          50
     D retorno                         n
     * - ----------------------------------------------------------- *
     *Empresa/Sucursal
     * - ----------------------------------------------------------- *
     D                uds
     D  usempr               401    401
     D  ussucu               402    403
     * - ----------------------------------------------------------- *
     *
     * - ----------------------------------------------------------- *
     D estoyEn         s             10a
     D secu            s              2  0
     D paso            s             10i 0 inz(1)
     D endpgm          s               n   inz(*off)
     D parasf          s               n   inz(*on)
     D asteri          s             10A   inz('*         ')
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
               endsl;
          enddo;
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
                              callp getsavf(desa:parasf:parasf);
                              paso = 3;
                         on-error;
                              endpgm = *on;
                              retorno = *off;
                         endmon;
               endsl;
          endsr;
     * - ----------------------------------------------------------- *
      *  Carga Fuentes y Objetos
     * - ----------------------------------------------------------- *
          begsr cargaFuentesObjetos;
               callp fuentes1(desa : secu );
               if secu = '0';
                    retorno = *off;
               endif;
               endpgm  = *on;
          endsr;
