        ctl-opt
          actgrp(*caller)
          bnddir('INSTALADOR/HDIBDIR')
          option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
          datfmt(*iso) timfmt(*iso);
     * - ----------------------------------------------------------- *
     *  Sistema  .:  as400                                           *
     *               Primer paso de instalaciones.                   *
     *               Este pgm usa apis de IBM para guardar en una    *
     *               estructura los fuentes de un determinado qsrcpf *
     *               El objetivo de este pgm es guardar en la tabla  *
     *               setsrc los fuentes encontrados con su tipo para *
     *               determinar donde se instalar el fuente y el obj *
     *               Se deja documentado el link donde se encuentra  *
     *               el codigo original utilizado para apis          *
     *               Para hacer el codigo mas limpio, las firmas y   *
     *               algunas variables que pueden ser globales, son  *
     *               declaradas en la hoja H                         *
     *       https://www.ibm.com/docs/es/i/7.5.0?topic=type-examples *
     * ------------------------------------------------------------- *
      /copy instalador/qcpybooks,svpapi_h
      /copy instalador/qcpybooks,svpinst_h
      /copy hdiile/qcpybooks,svpvls_h
          dcl-f paninsFm workstn;
          // -----------------------------------------------------------
          //  Prototipo
          // -----------------------------------------------------------
          dcl-pr PGGLEC;
               DESA char(10);
               SECU packed(2:0);
               deta char(50);
          end-pr;
          // -----------------------------------------------------------
          //  Interfaz
          // -----------------------------------------------------------
          dcl-pi PGGLEC;
               DESA char(10);
               SECU packed(2:0);
               deta char(50);
          end-pi;
          // -----------------------------------------------------------
          //  EMPRESA SUCURSAL
          // -----------------------------------------------------------
        dcl-ds uds qualified dtaara(*lda);
            usempr char(1) pos(401);
            ussucu char(2) pos(402);
        end-ds;
          // -----------------------------------------------------------
          //  Estructura de fecha de vigencia
          // -----------------------------------------------------------
          dcl-ds FechaVigencia inz;
               fecH packed(8:0) pos(1);
               feca packed(4:0) pos(1);
               fecm packed(2:0) pos(5);
               fecd packed(2:0) pos(7);
          end-ds;
          dcl-ds @PsDs psds qualified;
               this   char(10)   pos(1);
               Job    char(26)   pos(244);
               JobNam char(10)   pos(244);
               JobUsr char(10)   pos(254);
               JobNum zoned(6:0) pos(264);
               CurUsr char(10)   pos(358);
          end-ds;
     * ------------------------------------------------------------- *
      *   Cuerpo Principal
     * - ----------------------------------------------------------- *
        /free
        *inlr = *on;
          primero();
          //Levanto info de la instalacion.
          callApis();
          //Secuencia de instalacion
          secuencia();
          grabaIns();
          for x = 1 to pxeDsCMbr;
               cadena = %trim(pxDsMbr(x).MBRNAME);
               casos();
               graba();
          endfor;
          if secu = 0;
               exfmt FUENTEAERR;
          endif;

          return;
        /end-free
     * - ----------------------------------------------------------- *
      *  Primero lo
     * - ----------------------------------------------------------- *
          dcl-proc primero;
               SECU = 0;
               uds.usempr = 'A';
               uds.ussucu = 'CA';
               k1tsrc.s1empr = uds.usempr;
               k1tsrc.s1sucu = uds.ussucu;
               k1tsrc.s1desa = desa;
               //para APIs
               SVPVLS_getValSys('INSTALTEMP': *omit : @@vsys);
               file  = desa;
               FILE_LIB.flib  = %trim(@@vsys);
               FILE_LIB.ffile = qfile;
          end-proc;
     * - ----------------------------------------------------------- *
      *  Calculo secuencia
     * - ----------------------------------------------------------- *
          dcl-proc secuencia;
               chain %kds(k1tsrc:3) setsrc;
               if not %found;
                    s1secu = 1;
               else;
                    setgt %kds(k1tsrc:3) setsrc;
                    readpe(n) %kds(k1tsrc:3) setsrc @@Dssrc;
                    s1secu = @@Dssrc.s1secu + 1;
               endif;
               SECU = s1secu;
          end-proc;
     * - ----------------------------------------------------------- *
      *  Levantamos desde las apis
     * - ----------------------------------------------------------- *
          dcl-proc callApis;
               if not svpapi_loadMemToLib(FILE_LIB:pxDsMbr:pxeDsCMbr);
                    exfmt FUENTEAERR;
                    return;
               endif;
          end-proc;
     * - ----------------------------------------------------------- *
      *  casos - determina si se usa INSTALACPF o INSTALAPGM
     * - ----------------------------------------------------------- *
          dcl-proc casos;
               select;
               when tipo = 'PF' or tipo = 'LF';
                    if SVPVLS_getValSys('INSTALACPF': *omit : @@vsys);
                         conf_ins = %trim(@@vsys);
                    endif;
               other;
                    if SVPVLS_getValSys('INSTALAPGM': *omit : @@vsys);
                         conf_ins = %trim(@@vsys);
                    endif;
               endsl;
               if esWs = 'WS';
                 //   libo = 'QUOMDATA';
               endif;
          end-proc;
     * - ----------------------------------------------------------- *
      * graba - inserta registro en la tabla
     * - ----------------------------------------------------------- *
          dcl-proc graba ;
               s1empr = uds.usempr;
               s1sucu = uds.ussucu;
               s1marf = '0';
               s1marO = '0';
               //From
               s1ffil = %trim(qfile);
               s1flib = FILE_LIB.flib;
               //to
               s1tlib = tlib;
               s1tfil = tfil;
               //nombre fuente
               s1nfue = nomfue;
               //se mueve a...
               s1objl = libo;
               svpapi_getTypeAndAttributeObj( s1nfue
                                            : s1flib
                                            : s1tipo
                                            : s1attr);
               s1echa = %dec(%date():*iso);
               s1desa = desa;
               s1ech1 = %dec(%date():*iso);
               s1ausu = @PsDs.CurUsr;
               s1date = udate;
               s1time = %dec(%time);
               write s1tsrc;
          end-proc;
     * - ----------------------------------------------------------- *
      * grabaIns - inserta registro en la tabla
     * - ----------------------------------------------------------- *
        dcl-proc grabaIns;
               SIEMPR = uds.usempr;
               SISUCU = uds.ussucu;
               SIINST = desa;
               sideta = deta;
               sidate = udate;
               sitime = %dec(%time);
               siausu = @PsDs.CurUsr;
               sisecu = %dec(SECU:2:0);
               write sitins;
        end-proc;
